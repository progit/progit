# Başlangıç #

Bu bölümde Git kullanımı hakkında temel bilgileri bulacaksınız. İşe, sürüm kontrol sistemleri hakkında açıklamalarla başlayacağız; daha sonra Git kurulumunun nasıl yapılacağını, en son olarak da aracın yapılandırma ve kullanımını açıklayacağız. Bu bölümün sonunda Git'in varlık sebebini ve neden onu kullanmanız gerektiğini anlayacak, Git'i kullanmaya başlamak için kurulumu tamamlamış olacaksınız.

## Sürüm Kontrolü Hakkında ##

Sürüm kontrolü nedir ve ne işe yarar? Sürüm kontrolü, bir ya da daha fazla dosya üzerinde yapılan değişiklikleri kaydeden ve daha sonra belirli bir sürüme geri dönebilmenizi sağlayan bir sistemdir. Bu kitaptaki örneklerde yazılım kaynak kod dosyalarının sürüm kontrolünü yapacaksınız, ne var ki gerçekte sürüm kontrolünü neredeyse her türden dosya için kullanabilirsiniz.

Bir grafik ya da web tasarımcısıysanız ve bir görselin ya da tasarımın değişik sürümlerini korumak istiyorsanız (ki muhtemelen bunu yapmak istersiniz), bir Sürüm Kontrol Sistemi (SKS) kullanmanız çok akıllıca olacaktır. SKS, dosyaların ya da bütün projenin geçmişteki belirli bir sürümüne erişmenizi, zaman içinde yapılan değişiklikleri karşılaştırmanızı, soruna neden olan şeyde en son kimin değişiklik yaptığını, belirli bir hatayı kimin, ne zaman sisteme dahil ettiğini ve daha başka pek çok şeyi görebilmenizi sağlar. Öte yandan, SKS kullanmak, bir hata yaptığınızda ya da bazı dosyaları yanlışlıkla sildiğinizde durumu kolayca telâfi etmenize yardımcı olur. Üstelik, bütün bunlar size kayda değer bir ek yük de getirmez.

### Yerel Sürüm Kontrol Sistemleri ###

Çoğu insan, dosyaları bir klasöre (akılları başlarındaysa tarih ve zaman bilgisini de içeren bir klasöre) kopyalayarak sürüm kontrolü yapmayı tercih eder. Bu yaklaşım çok yaygındır, çünkü çok kolaydır; ama aynı zamanda hatalara da alabildiğine açıktır. Hangi klasörde olduğunuzu unutup yanlış dosyaya yazabilir ya da istemediğiniz dosyaların üstüne kopyalama yapabilirsiniz.

Bu sorunla baş edebilmek için, programcılar uzun zaman önce, dosyalardaki bütün değişiklikleri sürüm kontrolüne alan basit bir veritabanına sahip olan yerel SKS'ler geliştirdiler (bkz. Figür 1-1).

Insert 18333fig0101.png 
Figür 1-1. Yerel sürüm kontrol diyagramı.

En yaygın SKS araçlarından biri, bugün hâlâ pekçok bilgisayara kurulu olarak dağıtılan, rcs adında bir sistemdi. Ünlü Mac OS X işletim sistemi bile, Developer Tools'u yüklediğinizde, rcs komutunu kurmaktadır. Bu araç, iki sürüm arasındaki yamaları (yani, dosyalar arasındaki farkları) özel bir biçimde diske kaydeder; daha sonra, bu yamaları birbirine ekleyerek, bir dosyanın belirli bir sürümdeki görünümünü yeniden oluşturur.

### Merkezi Sürüm Kontrol Sistemleri ###

İnsanların karşılaştığı ikinci büyük sorun, başka sistemlerdeki programcılarla birlikte çalışma ihtiyacından ileri gelir. Bu sorunla başa çıkabilmek için, Merkezi Sürüm Kontrol Sistemleri (MSKS) geliştirilmiştir. Bu sistemler, meselâ CVS, Subversion ve Perforce, sürüm kontrolüne alınan bütün dosyaları tutan bir sunucu ve bu sunucudan dosyaları seçerek alan (_check out_) istemcilerden oluşur. Bu yöntem, yıllarca, sürüm kontrolünde standart yöntem olarak kabul gördü (bkz. Figür 1-2).

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

Hayattaki pek çok harika şey gibi, Git de bir miktar yaratıcı yıkım ve ateşli tartışmayla başladı. Linux çekirdeği (_kernel_) oldukça büyük ölçekli bir açık kaynak kodlu yazılım projesidir. Linux çekirdek bakım ve geliştirme yaşam süresinin çoğunda (1991-2002), yazılım değişiklikleri yamalar ve arşiv dosyaları olarak tutulup taşındı. 2002 yılında, Linux çekirdek projesi, BitKeeper adında tescilli bir DSKS kullanmaya başladı.

2005 yılında, Linux çekirdeğini geliştiren toplulukla BitKeeper'ı geliştiren şirket arasındaki ilişki bozuldu ve aracın topluluk tarafından ücretsiz olarak kullanılabilmesi uygulamasına son verildi. Bu, Linux geliştirim topluluğunu (ve özellikle Linux'un yaratıcısı olan Linus Torvalds'ı) BitKeeper'ı kullanırken aldıkları derslerden yola çıkarak kendi araçlarını geliştirme konusunda harekete geçirdi. Yeni sistemin hedeflerinden bazıları şunlardı:

*	Hız
*	Basit tasarım
*	Çizgisel olmayan geliştirim için güçlü destek (binlerce paralel dal (_branch_))
*	Bütünüyle dağıtık olma
*	Linux çekirdeği gibi büyük projelerle verimli biçimde başa çıkabilme (hız ve veri boyutu)

2005'teki doğumundan beri, Git kullanım kolaylıklarını geliştirebilmek için evrilip olgunlaştı, ama yine de bu niteliklerini korudu. Git, inanılmaz ölçüde hızlı, büyük ölçekli projelerde alabildiğine verimli ve çizgisel olmayan geliştirim (bkz. 3. Bölüm) için inanılmaz bir dallanma (_branching_) sistemine sahip.

## Git'in Temelleri ##

Peki Git özünde nedir? Bu, özümsenmesi gereken önemli bir alt bölüm, çünkü Git'in ne olduğunu ve temel çalışma ilkelerini anlarsanız, Git'i etkili biçimde kullanmanız çok daha kolay olacaktır. Git'i öğrenirken, Subversion ve Perforce gibi diğer SKS'ler hakkında bildiklerinizi aklınızdan çıkarmaya çalışın; bu aracı kullanırken yaşanabilecek kafa karışıklıklarını önlemenize yardımcı olacaktır. Git'in, kullanıcı arayüzü söz konusu sistemlerle benzerlik gösterse de, bilgiyi depolama ve yorumlama biçimi çok farklıdır; bu farklılıkları anlamak, aracı kullanırken kafa karışıklığına düşmenizi engellemekte yardımcı olacaktır.

### Farklar Değil, Bellek Kopyaları ###

Git ile diğer SKS'ler (Subversion ve ahbapları dahil) arasındaki esas fark, Git'in bilgiyi yorumlayış biçimiyle ilgilidir. Kavramsal olarak, diğer sistemlerin çoğu, bilgiyi dosya-tabanlı bir dizi değişiklik olarak depolar. Bu sistemler (CVS, Subversion, Perforce, Bazaar ve saire) bilgiyi, kayıt altında tuttukları bir dosya kümesi ve zamanla her bir dosya üzerinde yapılan değişikliklerin listesi olarak yorumlarlar (bkz. Figür 1-4).

Insert 18333fig0104.png 
Figür 1-4. Diğer sistemler veriyi her bir dosyanın ilk sürümu üzerinde yapılan değişiklikler olarak depolama eğilimindedir.

Git, veriyi böyle yorumlayıp depolamaz. Bunun yerine, Git, veriyi, bir mini dosya sisteminin bellek kopyaları olarak yorumlar. Her kayıt işleminde (_commit_), ya da projenizin konumunu her kaydedişinizde, Git o anda dosyalarınızın nasıl göründüğünün bir fotoğrafını çekip o bellek kopyasına bir referansı depolar. Verimli olabilmek için, değişmeyen dosyaları yeniden depolamaz, yalnızca halihazırda depolanmış olan bir önceki özdeş kopyaya bir bağlantı kurar. Git'in veriyi yorumlayışı daha çok Figür 1-5'teki gibidir.

Insert 18333fig0105.png 
Figür 1-5. Git veriyi projenin zaman içindeki bellek kopyaları olarak depolar.

Bu, Git'le neredeyse bütün diğer SKS'ler arasında ciddi bir ayrımdır. Bu ayrım nedeniyle Git, sürüm kontrolünün, diğer sürüm kontrol sistemlerinin çoğu tarafından önceki kuşaklardan devralınan neredeyse bütün yönlerini yeniden gözden geçirmek zorunda bırakır. Bu ayrım Git'i basit bir SKS olmanın ötesinde, etkili araçlara sahip bir mini dosya sistemi gibi olmaya iter. Veriyi bu şekilde yorumlamanın yararlarından bazılarını dallanmayı işleyeceğimiz 3. Bölüm'de ele alacağız.

### Neredeyse Her İşlem Yerel ###

Git'teki işlemlerin çoğu, yalnızca yerel dosyalara ve kaynaklara ihtiyaç duyar —genellikle bilgisayar ağındaki başka bir bilgisayardaki bilgilere ihtiyaç yoktur. Eğer çoğu işlemin ağ gecikmesi maliyetiyle gerçekleştiği bir MSKS kullanmışsanız, Git'in bu yönünü görünce, onun hız tanrıları tarafından kutsanmış olduğunu düşünebilirsiniz. Çünkü projenin bütün tarihçesi orada, yerel diskinde bulunmaktadır, işlemlerin çoğu anlık gerçekleşiyor gibi görünür.

Örneğin, projenin tarihçesini taramak için Git bir sunucuya bağlanıp oradan tarihçeyi indirdikten sonra görüntülemekle uğraşmaz —yerel veritabanını okumak yeterlidir. Bu da proje terihçesini neredeyse anında görünteleyebilmeniz anlamına gelir. Bir dosyanın şimdiki haliyle bir ay önceki hali arasındaki farkları görmek isterseniz, Git, bir sunucudan fark hesaplaması yapmasını talep etmek ya da karşılaştırmayı yerelde yapabilmek için dosyanın bir ay önceki halini indirmek zorunda kalmak yerine, dosyanın bir ay önceki halini yerelde bulup fark hesaplamasını yerelde yapar.

Bu aynı zamanda, eğer bağlantınız kopmuşsa, ya da VPN bağlantını yoksa yapamayacağınız şeylerin de sayıca oldukça sınırlı olduğu anlamına geliyor. Uçağa ya da trene binmiş olduğunuz halde biraz çalışmak istiyorsanız, yükleme yapabileceğiniz bir ağ bağlantısına kavuşana kadar güle oynaya kayıt yapabilirsiniz. Eve vardığınızda VPN istemcinizin olması gerektiği gibi çalışmıyorsa, yine de çalışmaya devam edebilirsiniz. pek çok başka sistemde bunları yapmak ya imk^ansız ya da zahmetlidir. Söz gelimi Perforce'ta, bir sunucuya bağlı değilseniz fazlaca bir şey yapamazsınız; Subversion ve CVS'te dosyaları değiştirebilirsiniz, ama veritabanına kayıt yapamazsınız (çünkü veritabanına bağlantınız yoktur). Bu, çok önemli bir sorun gibi görünmeyebilir, ama ne kadar fark yaratabileceğini gördüğünüzde şaşırabilirsiniz.

### Git Bütünlüklüdür ###

Git'te her şey depolanmadan önce sınama toplamından geçirilir (_checksum_) ve daha sonra bu sınama toplamı kullanılarak ifade edilir. Bu da demek oluyor ki, Git fark etmeden bir dosyanın ya da klasörün içeriğini değiştirmek mümkün değildir. Bu işlev Git'in merkezi işlevlerinden biridir ve felsefesiyle bir bütünlük oluşturur. Transfer sırasında veri kaybı ya da doysa arızası olmuşsa, Git bunu mutlaka fark edecektir.

Git'in sınama toplamı için kullandığı mekanizmaya SHA-1 özeti denir. Bu, on altılı sayı sisteminin (_hexadecimal_) sembolleriyle gösterilen (0-9 ve A-F) ve dosya ve klasör düzenini temel alan bir hesaplamayla elde denilen 40 karakterlik bir karakter dizisidir. Bir SHA-1 özeti şuna benzer:

	24b9da6552252987aa493b52f8696cd6d3b00373

Bu özetler sıklıkla karşınıza çıkacak, çünkü Git onları yaygın biçimde kullanyor. Hatta, Git her şeyi dosya adıyla değil, içeriğinin özet değeriyle adreslenen veritabanında tutar.

### Git Genellikle Yalnızca Veri Ekler ###

Git'te işlem yaptığınızda neredeyse bu işlemlerin tamamı Git veritabanına veri ekler. Sistemin geri döndürülemez bir şey yapmasını ya da veri silmesini sağlamak çok zordur. Her SKS'de olduğu gibi henüz kaydetmediğiniz değişiklikleri kaybedebilir ya da bozabilirsiniz; ama Git'e bir bellek kopyasını kaydettikten sonra veri kaybetmek çok zordur, özellikle de veritabanınızı düzenli olarak başka bir yazılım havuzuna itiyorsanız (_push_).

Bu Git kullanmayı keyifli hale getirir, çünkü işleri ciddi biçimde sıkıntıya sokmadan denemeler yapabileceğimizi biliriz. Git'in veriyi nasıl depoladığı ve kaybolmuş görünen veriyi nasıl kurtarabileceğiniz hakkında daha derinlikli bir inceleme için bkz. 9. Bölüm.

### Üç Aşama ###

Şimdi dikkat! Öğrenme sürecinizin pürüzsüz ilerlemesini istiyorsanız, aklınızda bulundurmanız gereken esas şey bu. Git'te, dosyalarınızın içinde bulunabileceği üç aşama (_state_) vardır: kaydedilmiş, değiştirilmiş ve hazırlanmış. Kaydedilmiş, verinin güvenli biçimde veritabanında depolanmış olduğu anlamına gelir. Değiştirilmiş, dosyayı değiştirmiş olduğunuz fakat henüz veritabanına kaydetmediğiniz anlamına gelir. Hazırlanmış ise, değiştirilmiş bir dosyayı bir sonraki kayıt işleminde bellek kopyasına alınmak üzere işaretlediğiniz anlamına gelir.

Bu da bizi bir Git projesinin üç ana bölümüne getiriyor: Git klasörü, çalışma klasörü ve hazırlık alanı.

Insert 18333fig0106.png 
Figür 1-6. Çalışma klasörü, hazırlık alanı ve Git klasörü.

Git klasörü, Git'in üstverileri (_metadata_) ve nesne veritabanını depoladığı yerdir. Bu, Git'in en önemli parçasıdır ve bir yazılım havuzunu bir bilgisayardan bir başkasına klonladığınızda kopyalanan şeydir.

Çalışma klasörü projenin bir sürümünden yapılan tek bir seçmedir. Bu dosyalar Git klasöründeki sıkıştırılmış veritabanından çıkartılıp sizin kullanımınız için sabit diske yerleştirilir.

Hazırlık alanı (_staging area_), genellikle Git klasörünüzde bulunan ve bir sonraki kayıt işlemine hangi değişikliklerin dahil olacağını tutan sade bir dosyadır. Buna bazen indeks dendiği de olur, ama hazırlık alanı ifadesi giderek daha standart hale geliyor.

Git işleyişi temelde şöyledir:

1. Çalışma klasörünüzdeki dosyalar üzerinde değişiklik yaparsınız.
2. Dosyaları bellek kopyalarını hazırlık alanına ekleyerek hazırlarsınız.
3. Dosyaların hazırlık alanındaki hallerini alıp oradaki bellek kopyasını kalıcı olarak Git klasörüne depolayan bir kayıt işlemi yaparsınız.

Bir dosyanın belirli bir sürümü Git klasöründeyse, onun kaydedilmiş olduğu kabul edilir. Eğer üzerinde değişiklik yapılmış fakat hazırlık alanına eklenmişse, hazırlanmış olduğu söylenir. Ve seçme işleminden sonra üzerinde değişiklik yapılmış fakat kayıt için hazırlanmamışsa, değiştirilmiş olarak nitelenir.

## Git'in Kurulumu ##

Gelin Git'i kullanmaya başlayalım. Her şeyden önce, Git'i kurmanız gerekiyor. Bunu iki başlıca biçimde gerçekleştirebilirsiniz: kaynak kodundan ya da platformunuz için halihazırda varolan paketi kullanarak kurabilirsiniz.

### Kaynak Kodundan Kurulum ###

Yapabiliyorsanız, Git'i kaynak kodundan kurmak kullanışlıdır, çünkü böylece en yeni versiyonunu edinebilirsiniz. Git'in her yeni versiyonu yararlı kullanıcı arayüzü güncellemeleri içerir, dolayısıyla en son versiyonu kurmak, eğer yazılım derlemek konusunda sıkıntı yaşamayacağınızı düşünüyorsanız, en iyi yoldur. Ayrıca kimi zaman, Linux dağıtımları yazılımların çok eski paketlerini içerirler; dolayısıyla, çok güncel bir dağıtıma sahip değilseniz ya da terstaşımalar (_backport_) kullanmıyorsanız, kaynak koddan kurulum en mantıklı seçenek olabilir.

Git'i kurmak için, Git'in bağımlı olduğu şu kütüphanelerin sisteminizde bulunması gerekiyor: curl, zlib, openssl, expat, ve libiconv. Örneğin, (Fedora gibi) yum aracına ya da (Debian tabanlı sistemler gibi) apt-get aracına sahip bir sistemdeyseniz, bağımlılıkları kurmak için şu komutlardan birini kullanabilirsiniz:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev libssl-dev
	
Bütün gerekli bağımlılıkları yükledikten sonra Git web sitesinden en son bellek kopyasını edinebilirsiniz:

	http://git-scm.com/download

Sonra derleyip kurabilirsiniz:

	$ tar -zxf git-1.7.2.2.tar.gz
	$ cd git-1.7.2.2
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

Bu adımdan sonra, Git'teki yeni güncellemeleri Git'in kendisini kullanarak edinebilirsiniz:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	
### Linux'ta Kurulum ###

Git'i Linux sisteminize paket kurucu yardımıyla kurmak istiyorsanız, bunu genellikle dağıtımınızla birlikte gelen temel paket yönetim aracıyla yapabilirsiniz. Fedora kullanıcısıysanız, yum'u kullanabilirsiniz:

	$ yum install git-core

Ubuntu gibi Debian-tabanlı bir sistemdeyseniz, apt-get'i kullanabilirsiniz:

	$ apt-get install git

### Mac'te Kurulum ###

Git'i Mac'te kurmak için iki kolay yol vardır. En kolayı, SourceForge sayfasından indirebileceğiniz görsel Git yükleyicisini kullanmaktır (bkz. Figür 1-7).

	http://sourceforge.net/projects/git-osx-installer/

Insert 18333fig0107.png 
Figür 1-7. Git OS X yükleyicisi.

Diğer başlıca yol, Git'i MacPorts (`http://www.macports.org`) vasıtasıyla kurmaktır. MacPorts halihazırda kurulu bulunuyorsa Git'i şu komutla kurabilirsiniz:

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

Bütün ek paketleri kurmanız şart değil, ama Git'i Subversion yazılım havuzlarıyla kullanmanız gerekecekse en azından +svn'i edinmelisiniz.

### Windows'ta Kurulum ###

Git'i Windows'da kurmak oldukça kolaydır. mysysGit projesi en basit kurulum yöntemlerinden birine sahip. Çalıştırılabilir kurulum dosyasını GitHub sayfasından indirip çalıştırmanız yeterli:

	http://msysgit.github.com/

Kurulum tamamlandığında hem (daha sonra işe yarayacak olan SSH istemcisini de içeren) komut satırı nüshasına hem de standart kullanıcı arayüzüne sahip olacaksınız.

## İlk Ayarlamalar ##

Artık Git sisteminizde kurulu olduğuna göre, onu ihtiyacınıza göre uyarlamak için bazı düzenlemeler yapabilirsiniz. Bunları yalnızca bir kere yapmanız yeterli olacaktır: güncellemelerden etkilenmeyeceklerdir. Ayrıca istediğiniz zaman komutları yeniden çalıştırarak ayarları değiştirebilirsiniz.

Git, Git'in nasıl görüneceğini ve çalışacağını belirleyen bütün konfigürasyon değişkenlerini görmenizi ve değiştirmenizi sağlayan git config adında bir araçla birlikte gelir. Bu değişkenler üç farklı yerde depolanabilirler:

*	`/etc/gitconfig` dosyası: Sistemdeki bütün kullanıcılar ve onların bütün yazılım havuzları için geçerli olan değerleri içerir. `git config` komutunu `--system` seçeneğiyle kullanırsanız, araç bu dosyadan okuyup değişiklikleri bu dosyaya kaydedecektir.
*	`~/.gitconfig` dosyası: Kullanıcıya özeldir. `--global` seçeneğiyle Git'in bu dosyadan okuyup değişiklikleri bu dosyaya kaydetmesini sağlayabilirsiniz.
*	kullanmakta olduğunuz yazılım havuzundaki git klasöründe bulunan config dosyası (yani `.git/config`): Söz konusu yazılım havuzuna özeldir. Her düzeydeki ayarlar kendisinden önce gelen düzeydeki ayarları gölgede bırakır (_override_), dolayısıyla `.git/config`'deki değerler `/etc/gitconfig`'deki değerlerden daha baskındır.

Git, Windows sistemlerde `$HOME` klasöründeki (çoğu kullanıcı için `C:\Documents and Settings\$USER` klasörüdür) `.gitconfig` dosyasına bakar (Ç.N.: Windows kullanıcı klasörüne %HOMEPATH% çevresel değişkenini kullanarak ulaşabilirsiniz). Git, Windows sistemlerde de /etc/gitconfig dosyasını arar fakat bu konum, Git kurulumu sırasında seçtiğiniz MSys kök dizinine göredir.

### Kimliğiniz ###

Git'i kurduğunuzda yapmanız gereken ilk şey adınızı ve e-posta adresinizi ayarlamaktır. Bunun önemli olmasının nedeni her bir Git kaydının bu bilgiyi kullanıyor olması ve bu bilgilerin dolaşıma soktuğunuz kayıtlara değişmez biçimde işlenmesidir.

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Yinelemek gerekirse, `--global` seçeneğini kullandığınızda bunu bir kez yapmanız yeterli olacaktır, çünkü Git, o sistemde yapacağınız her işlem için bu bilgileri kullanacaktır. İsmi ya da e-posta adresini projeden projeye değiştirmek isterseniz, komutu değişiklik yapmak istediğiniz proje klasörünün içinde `--global` seçeneği olmadan çalıştırabilirsiniz.

### Editörünüz ###

Kimlik ayarlarınızı yaptığınıza göre, Git sizden bir mesaj yazmanızı istediğinde kullanacağınız editörle ilgili düzenlemeyi yapabilirsiniz. Aksi belirtilmedikçe Git sisteminizdeki öntanımlı (_default_) editörü kullanır, bu da genellikle Vi ya da Vim'dir. Emacs gibi başka bir metin editörü kullanmak isterseniz, şu komutu kullanabilirsiniz:

	$ git config --global core.editor emacs
	
### Dosya Karşılaştırma Aracınız ###

Düzenlemek isteyeceğiniz bir diğer yararlı ayar da birleştirme (_merge_) uyuşmazlıklarını gidermek için kullanacağınız araçla ilgilidir. vimdiff aracını seçmek için şu komutu kullanabilirsiniz:

	$ git config --global merge.tool vimdiff

Git kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge ve opendiff araçlarını kabul eder. Dilerseniz özel bir araç için de ayarlamalar yapabilirsiniz (bununla ilgili daha fazla bilgi için bkz. 7. Bölüm).

### Ayarlarınızı Gözden Geçirmek ###

Ayarlarınızı gözden geçirmek isterseniz, Git'in bulabildiği bütün ayarları listelemek için `git config --list` komutunu kullanabilirsiniz.

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

Bir ayarı birden çok kez görebilirsiniz; bunun nedeni Git'in aynı ayarı değişik dosyalardan (örneğin `etc/gitconfig` ve `~/.gitconfig`'den) okumuş olmasıdır. Bu durumda Git gördüğü her bir tekil ayar için en son bulduğu değeri kullanır.

`git config {ayar}` komutunu kullanarak Git'ten bir ayarın değerini görüntülemesini de isteyebilirsiniz:

	$ git config user.name
	Scott Chacon

## Yardım Almak ##

Git'i kullanırken yardıma ihtiyacınız olursa, herhangi bir Git komutunun yardım kılavuzu sayfasını (_manpage_) üç değişik biçimde görüntüleyebilirsiniz:

	$ git help <eylem>
	$ git <eylem> --help
	$ man git-<eylem>

Örneğin, config komutu için kılavuzu sayfasını görüntülemek için şu komutu çalıştırabilirsiniz:

	$ git help config

Bu komutların güzel tarafı onlara her an, ağ bağlantınız olmasa bile ulaşabiliyor olmanızdır. Eğer kılavuz sayfaları ve bu kitap yeterli olmazsa ve kişisel yardıma ihtiyaç duyacak olursanız, Freenode IRC sunucusundaki (irc.freenode.net) `#git` ya da `#github` kanallarına bağlanmayı deneyebilirsiniz. Bu kanallar Git hakkında derin bilgiye sahip yüzlerce kişi tarafından düzenli olarak ziyaret edilmektedir.

## Özet ##

Artık Git'in ne olduğu ve kullanmış olabileceğiniz MSKS'den hangi açılardan farklı olduğu konusunda temel bilgilere sahipsiniz. Ayrıca sisteminizde, sizin kimlik bilgilerinize göre ayarlanmış bir Git kurulumu bulunuyor. Şimdi Git'in temellerini öğrenme zamanı.
