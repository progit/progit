# Dağıtık Git #

Artık tüm developerların kodunu paylaşacağı bir uzak git reposuna sahipsiniz ve yerel çalışma akışınızda kullanacağınız temel Git komutlarına aşinasınız. Artık Git'in size sağladığı bazı dağıtık çalışma akışlarını nasıl kullanacağımıza bakacacağız.

Bu bölümde, dağıtık bir Git ortamında katılımcı ve koordinatör olarak nasıl çalışacağınızı göreceksiniz. Bir çok geliştiricinin çalıştığı projelere nasıl katkı sağlayacağınızı ve projenin sürdürülebilirliğini nasıl sağlayacağınızı öğreneceksiniz.

## Dağıtık Çalışma Akışları ##

Merkezi Versiyon Kontrol Sistemlerinden (CVCSs) farklı olarak, Git'in dağıtık yapısı geliştiricilerin projelerde nasıl işbirliği yapacağı konusunda daha esnek davranmanıza izin verir. Merkezi sistemlerde, her bir geliştirici merkez çevresinde az veya çok çalışan bir noktacıktır. Git'te ise; her bir geliştirici potansiyel olarak bir noktacık veya bir merkez olabilir. Her bir geliştirici başka repolar üzerindeki kodlara katkı sağlayabilir ve aynı zamanda başkalarının katkı sağladığı bir reponun koordinatörlüğünü üstlenebilir. Bu takımınıza ve projenize sonsuz sayıda çalışma akışı için imkan sağlar. Burada bu esnekliğin avantajlarını kullanan bazı çok kullanılan çalışma tasarım desenlerinden(pattern) bahsedeceğim. Her bir desenin güçlü ve zayıf yanlarının üzerinden geçeceğim. Böylece bunlardan birini seçebilirsiniz ya da ihtiyaçlarınıza göre şekillendirerek/karıştırarak kullanabilirsiniz.

### Merkezi Çalışma Akışı (Centralized Workflow) ###

Merkezi sistemlerde, genellikle tek bir katılım modeli vardır: Merkezi Çalışma Akışı. Kod katılımını kabul edebilen tek bir merkez veya repo bulunur ve herkes çalışmasını bu merkezle senkronize eder. Geliştiriciler bu merkezin çevresindeki noktacıklardır ve bu tek merkeze senkronize olurlar (Resim 5-1).

Insert 18333fig0501.png
Resim 5-1. Merkezi çalışma akışı.

Bu şu anlama gelir; eğer iki geliştirici bir merkezden repoyu klonlar ve değişiklikler yapar, ardından ilk geliştirici değişikliklerini merkeze gönderirse herhangi bir sıkıntı olmaz. Ancak ikinci geliştirici ilk geliştiricinin değişiklilerinin üzerine yazmadığından emin olmak için değişikliklerini göndermeden önce merkezi reponun son halini kendisine almalı ve kendi değişiklikleriyle birleştirmelidir. Bu konsept Git ya da Subversion (ya da herhangi bir  CVCS)'de mevcuttur, ve Git'de çok iyi çalışır.

Eğer küçük bir takımsanız veya merkezi çalışma akışından hali hazırda memnunsanız bu akışı Git ile kullanmaya devam edebilirsiniz. Tek bir repo oluşturun, ve takımdaki herkese bu repoya push edebilme izni verin; Git geliştiricilerin birbirlerinin değişikliklerini ezmesine izin vermeyecektir. Eğer bir geliştirici repoyu klonlar, değişiklikler yapar ve ardından değişikliklerini push etmeye çalışırsa ve o esnada başka bir geliştirici değişiklikler yapıp push ettiyse git sunucusu değişiklikleri reddedecektir. non-fast-forward(hızlı-ileri-olmayan?) değişiklikler yaptığı şeklinde bir hata alacak ve repodan fetch ve merge yapmadığı sürece değişikliklerini gönderemeyecektir.
Bu paradigma birçok insanı kendine çeker çünkü birçok kişiye tanıdık gelen ve rahat olabildikleri bir konsepttir.

### Entegrasyon Yöneticili Çalışma Akışı (Integration-Manager Workflow) ###

Git birden çok uzak repoyla çalışmanıza izin verdiğinden, her geliştiricinin kendi reposuna yazma izni ve diğer tüm repolara okuma izni olan bir çalışma akışı mümkündür. Bu senaryoda genellikle projeyi "resmi" olarak temsil eden ve doğruluğndan emin olunan bir repo bulunur. Bu repoya katkıda bulunmak için reponun kendinize ait olan klonun oluşturur ve kendi reponuz üzerinde çalışırsınız. Sonrasında ana proje reposunu yöneten kişiye sizin reponuzdaki değişiklikleri ana repoya alması için bir istekte bulunursunuz. Yönetici sizin reponuzu kendisine uzak sunucu olarak ekler, değişikliklerinizi test eder, ana repodaki branch ile birleştirir ve ana repoya gönderir. Bu işlem aşağıdaki şu şekilde ilerler (Resim 5-2):

1. Yönetici projenin genel reposuna push eder.
2. Geliştirici o repoyu kendisine klonlar ve değişiklilerini yapar.
3. Geliştirici değişikliklerini kendi reposuna gönderir.
4. Geliştirici yöneticiye değişiklilerini çekmesi için bir istekte bulunur (email vs.).
5. Yönetici geliştiricinin reposunu kendisine bir remote olarak ekler ve local olarak değişiklikleri birleştirir.
6. Yönetici birleştirilmiş değişiklikleri ana repoya gönderir.

Insert 18333fig0502.png
Figure 5-2. Entegrasyon Yöneticili Çalışma Akışı

Bir projeyi fork etmek ve o fork üzerinde çalışmak gibi işlemlerin kolay olduğu, Github gibi sitelerle birlikte bu çok kullanılan bir çalışma akışıdır. Bu yaklaşımın ana kazanımlarından biri geliştirici çalışmaya devam ederken yönetici geliştiricinin değişikliklerini herhangi bir zamanda ana repoya alabilir. Katılımcılar projenin kendi değişikliklerini dahil etmesini beklemek zorunda değildir. Herkes kendi alanında çalışabilir.

### Diktatör ve Yüzbaşılar Çalışma Akışı (Dictator and Lieutenants Workflow) ###

Bu çoklu repo çalışma akışının bir varyasyonudur. Genellikle yüzlerce katılımcının olduğu devasa projelerde kullanılır; meşhur bir örnek Linux çekirdeğidir. Bir çok entegrasyon yöneticisi projenin çeşitli yerlerinden sorumludur; bu kişiler yüzbaşılardır. Tüm yüzbaşıların üstünde ise 'iyiliksever diktatör' denilen tek bir entegrasyon yöneticisi vardır. İyiliksever diktatörün reposu tüm katılımcıların pull etmesi gereken referans repo konumundadır. Bu işlem aşağıdaki şu şekilde ilerler (Resim 5-3):

1. Normal geliştiriciler kendi topic branch(konu dalı)lerinde çalışırlan ve değişikliklerini diktatörün master branchi üzerinde rebase ederler.
2. Yüzbaşılar geliştiricilerin branchlerini kendi master branchlerine birleştirirler.
3. Diktatör yüzbaşıların master branchini kendi master branchine birleştirir.
4. Diktatör kendi master branchini referans repoya gönderir. Böylece diğer developerlar bunun üzerine rebase edebilirler.

Insert 18333fig0503.png
Resim 5-3. Diktatör ve Yüzbaşılar Çalışma Akışı.

Bu tarz bir çalışma akışı çok yaygın değildir fakat büyük projelerde veya çok hiyerarşik ortamlarda kullanışlı olabilir. Çünkü bu akış proje liderine (diktatör) görevlerin çoğunu dağıtma ve büyük kod setlerini entegre etmeden önce toplama imkanı sunar.

Bunlar Git gibi dağıtık sistemlerde mümkün olan çalışma akışlarından çok yaygın olan birkaçıydı. Sizin takım yapınıza ve çalışma şeklinize uygun olan daha başka yöntemler bulunabilir. Artık (umarım) hangi çalışma akışı kombinasyonunun size uyacağına karar verebilirsiniz. Şimdi daha özele inen bazı örneklerle değişik senaryolarda mümkün olabilecek rollerin çalışma akışlarından bahsedelim.

## Bir Projeye Katılım Sağlamak ##

Artık değişik çalışma akışlarını biliyor ve temel Git kullanımını iyice kavramış olmanız gerekiyor. Bu bölümde, bir projeye katkı sağlarken kullanılabilecek bazı genel pattern(desen)lardan bahsedeceğiz.

Bu işlemi açıklamanın en zor tarafı, nasıl yapılacağı ile ilgili çok fazla sayıda varyasyon olmasıdır. Çünkü Git çok esnektir ve insanlar bir arada çok farklı şekillerde çalışabilirler ve her proje birbirinden farklıdır. Bu da bir projeye nasıl katılım sağlanacağı konusunu anlatmayı problemli bir hale getirmektedir. İlişkili bazı değişkenler; aktif katılımcı sayısı, seçilen çalışma akışı, commit erişiminiz ve belki dışarıdan katılım metodudur.

İlk değişken; aktif katılımcı sayısı. Kaç kişi bu projeye ne sıklıkla kod katılımı sağlıyorlar? Birçok durumda iki-üç geliştiriciniz ve her geliştirici için günde birkaç commit olacaktır; atıl projeler için belki daha az. Fakat gerçekten büyük şirketler ve projeler için, binlerce geliştirici ve her gün düzinelerce hatta yüzlerce yama olabilir. Bu önemlidir çünkü geliştici sayısı arttıkça, kodunuzun temizce uygulanması ve kolayca birleştirilmesi konusunda daha çok sıkıntı yaşayacaksınız. Değişiklikleriniz, siz çalışırken veya değişikliklerinizin birleştirilmesini beklerken başka geliştiricilerin değişikliklerinin birleştirilmiş olmasından dolayı eski kalmış ya da kısmen/tamamen bozulmaya sebep olmuş olabilir. Peki kodunuzu nasıl düzenli olarak güncel ve değişikliklerinizi güncel tutacaksınız?

Diğer değişken; projeniz için kullandığınız çalışma akışı. Her geliştiricinin kod üzerinde eşit yazma hakları olacak şekilde merkezi mi? Projede tüm yamaları kontrol eden bir entegrasyon yöneticisi var mı? Tüm yamalar başka geliştiriciler kontrol edilip mi onaylanıyor? Siz bu süreçte var mısınız? Bir yüzbaşı sistemi var ve öncelikle değişikliklerinizi onlara mı göndermek durumundasınız?

Diğer bir sorun ise commit erişiminiz. Çünkü bir projeye doğrudan yazma izninizin olup olmaması o projede uygulanması gereken çalışma akışını çok etkiler. Eğer yazma izniniz yoksa, prje katılımcıların çalışmalarını ne şekilde kabul etmeyi tercih ediyor? Bir politikasi var mı? Tek seferde ne kadarlık bir katılım sağlıyorsunuz? Ne sıklıkla katılım sağlıyorsunuz?

Tüm bu sorular nasıl verimli bir şekilde katılım sağlayacağınızı, sizin için ne şekilde çalışma akışları mevcut olacağını ve tercih edildiğini etkileyecektir. Bunların her birini ve yönlerini, basitten karmaşığa doğru giderek ve bir seri kullanım durumları halinde inceleyeceğiz. Sonrasında ihtiyaç duyduğunuz çalışma akışını bu örneklerden yola çıkarak oluşturabilirsiniz.

### Commit Prensipleri ###

Özel kullanım durumlarına bakmadan önce, commit mesajları hakkında küçük bir not düşelim. Commit oluşturmak ile ilgili iyi prensiplere sahip olmak ve bunlara uymayı sürdürmek Git ile çalışmayı ve diğer geliştiricilerle yapılan işbirliğini çok kolaylaştırır. Git projesinin kendisine gönderilen yamalar iyi commitler oluşturmak için bize birçok ipucu sunmaktadır. Aynı zamanda Git kaynak kodunda `Documentation/SubmittingPatches` dosyasını okuyabilirsiniz.

Öncelikle, hiç bir beyaz-boşluk hatasını göndermek istemezsiniz. Git bunun kontrolü için kolay bir yol sunmaktadır. Commit etmeden önce `git diff --check` çalıştırırsanız, Git olası beyaz-boşluk hatalarını bulacak ve sizin için listeleyecektir. Bir örnek: (terminaldeki kırmızı renkler `X` ile değiştirilmiştir)

	$ git diff --check
	lib/simplegit.rb:5: trailing whitespace.
	+    @git_dir = File.expand_path(git_dir)XX
	lib/simplegit.rb:7: trailing whitespace.
	+ XXXXXXXXXXX
	lib/simplegit.rb:26: trailing whitespace.
	+    def command(git_cmd)XXXX

Eğer commit etmeden önce bu komutu çalıştırırsanız, neredeyse muhtemelen diğer geliştiricileri rahatsız edecek olan beyaz-boşlukları commit ediyor olduğunuzu görürsünüz.

Her bir commit'i mantıklı bir biçimde ayrılmış olarak yapın. Yapabiliyorsanız, değişikliklerinizi olabildiğince hafif yapın. Yani tüm haftasonu 5 sorun üzerine çalışıp da Pazartesi günü hepsini tek bir devasa commit halinde göndermeyin. Haftasonu boyunca commit yapmadıysanız bile, Pazartesi günü staging alanını kullanarak çözdüğünüz sorunların her birini mantıklı mesajlar içeren ayrı commitler haline getirin. Eğer bazı değişiklikler aynı dosyayı etkiliyorsa `git add --patch` kullanarak dosyaları kısmı olarak staginge almaya çalışın (6. bölümde bahsedeceğiz). 5 commit ya da tek commit yaptığınızda projenin sonuçtaki hali değişmez. Ama sizinle birlikte çalışanların işlerini neden zorlaştıralım ki? Bu yaklaşım aynı zamanda gerekirse değişikliklerden birini ya da birkaçını çıkarmak ya da geri çevirmek gerektiğinde de çok işe yarayacaktır. 6. Bölüm geçmişi baştan yazmak ve dosyaları interaktif olarak stage etmek için gerekli olan birçok kullanışlı Git ipuçlarını içermektedir. Temiz ve anlaşılabilir bir geçmiş oluşturmak için bu araçları kullanın.

Aklımızdan çıkarmamamız gereken son şey ise commit mesajıdır. Kaliteli ve anlaşılabilir commit mesajları yazmayı alışkanlık haline getirmek Git ile çalışmayı ve işbirliği yapmayı çok kolaylaştıracaktır. Genel bir kural olarak, mesajınız 50 karakterden uzun olmayan ve değişiklikleri kısaca anlatan bir satır ardından bir boş satır ve devamında ayrıntılı bir açıklama şeklinde olmalıdır. Git projesinde bu detaylı açıklamanızın sizi bu değişikliğe iten sebepleri ve sizin yaptığınızla önceki arasındaki farkları açıklamanız istenmektedir. Aşağıdaki örnek ilk olarak Tim Pope tarafından tpope.net'te İngilizce olarak yazılmıştır:

	Kısa (50 ya da daha az karakter) bir özet

	Gerekiyorsa, daha detaylı ve açıklayıcı bir metin. Satır uzunluğunu
	72 karakter civarında tutmaya çalışın. İlk satırı bir e-mailin konusu
	ve bu metni de mailin kendisi olarak düşünebilirsiniz. Boş satır
	ise konu ve mailin metnini ayırmaktadır. Eğer detaylı metin yazıyorsanız
	bu boş satır önemlidir çünkü kullanmadığınız durumlarda rebase gibi
	araçlar karışık hale gelebilir.

	Yeni paragraf yazmanız gerektiğinde yine boş bir satır bırakın.

	 - Bullet listeler de kullanılabilir

	 - Tipik olarak bir tire ya da yıldızı takip eden bir boşluk ve metin şeklinde
	  liste elemanları oluşturulabilir.

Eğer tüm commit mesajlarınız böyle görünürse, herşey siz ve birlikte çalıştığınız geliştiriciler için daha kolay olacaktır. Git projesinin kendisi çok iyi formatlanmış commit mesajlarına sahiptir. İyi formatlanmış commit mesajlarına sahip bir proje geçmişinin nasıl göründüğünü görmeniz için sizi, Git projesi üzerinde `git log --no-merges` komutunu çalıştırmaya davet ediyorum.

Bu kitabın tamamı boyunca sadelik uğruna mesajları böyle güzel biçimde yazmayacağım. Bunun yerine `git commit` komutunu `-m` ayarı ile çağırarak mesajlarını yazacağım. İmamın dediğini yap, yaptığını yapma :)

### Özel(dışarıya kapalı) Küçük Takım ###

Muhtemelen karşılacağınız en temel senaryo, özel bir projeye üzerinde çalışan iki veya daha fazla geliştiricidir. Özel derken, kapalı kaynaklı ve proje dışındaki insanlar tarafından kaynağı görülemeyen projelerden bahsediyorum. Siz ve tüm geliştiriciler projeye yazma hakkına sahipler.

Bu ortamda, Subversion ya da başka bir merkezi sistemde takip ettiğiniz çalışma akışını takip edebilirsiniz. Offline commit ve büyük ölçüde daha kolay olan branchler ve birleştirmenin avantajlarını halen kullanabilirsiniz. Ama çalışma akışı halen çok benzer olabilir, en temel fark ise birleştirmelerin sunucuda olması yerine istemci tarafında commit anında olmasıdır.
İki geliştiricinin ortak bir repoda çalışmaya başlamasıyla ne olacağına bakalım. İlk geliştirici Burak repoyu klonlar, bir değişiklik yapar ve yerel olarak commit eder. (Örnekleri kısaltmak adına protokol mesajları yerine `...` yazıyorum)

	# Burak's Machine
	$ git clone john@githost:simplegit.git
	Initialized empty Git repository in /home/burak/simplegit/.git/
	...
	$ cd simplegit/
	$ vim lib/simplegit.rb
	$ git commit -am 'geçersiz varsayılan değer kaldırıldı'
	[master 738ee87] geçersiz varsayılan değer kaldırıldı
	 1 files changed, 1 insertions(+), 1 deletions(-)

İkinci geliştirici Nesrin de aynı şeyi yapar. Repoyu klonlar ve bir değişiklik commit eder:

	# Nesrin's Machine
	$ git clone nesrin@githost:simplegit.git
	Initialized empty Git repository in /home/nesrin/simplegit/.git/
	...
	$ cd simplegit/
	$ vim TODO
	$ git commit -am 'sıfırlama görevi eklendi'
	[master fbff5bc] sıfırlama görevi eklendi
	 1 files changed, 1 insertions(+), 0 deletions(-)

Şimdi Nesrin çalışmasını uzak sunucudaki repoya pushlar:

	# Nesrin's Machine
	$ git push origin master
	...
	To nesrin@githost:simplegit.git
	   1edee6b..fbff5bc  master -> master

Burak da kendi değişikliğini pushlamaya çalışır:

	# Burak's Machine
	$ git push origin master
	To burak@githost:simplegit.git
	 ! [rejected]        master -> master (non-fast forward)
	error: failed to push some refs to 'burak@githost:simplegit.git'

Burak'a izin verilmez çünkü o esnada Nesrin push yapmıştır. Eğer önceden Subversion kullandıysanız bunu anlamanız önemlidir. 2 geliştirici farklı dosyaları düzenlemiştir. Eğer farklı dosyalarda değişiklik yapıldıysa Subversion otomatik olarak sunucuda bir birleştirme yapacaktır. Git'te ise commitleri kendi yerelinizde birleştirmelisiniz. Burak push yapmadan önce Nesrin'in değişikliklerini kendisine çekmeli, ve kendi değişiklikleriyle birleştirmelidir:

	$ git fetch origin
	...
	From burak@githost:simplegit
	 + 049d078...fbff5bc master     -> origin/master

Bu noktada Burak'ın yerel reposu Resım 5-4'teki gibi gorunecektir.

Insert 18333fig0504.png
Figure 5-4. Burak'ın baştakı reposu.

Artık Burak Nesrin'in yaptığı değişikliklerin bir referansına sahip. Şimdi kendi değişiklikleri ile Nesrin'in değişikliklerini birleştirip sonrasında repoya push edebilir.

	$ git merge origin/master
	Merge made by recursive.
	 TODO |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Eğer birleştirme sorunsuz giderse Burak'ın commit geçmişi Resim 5-5deki gibi olacaktır.

Insert 18333fig0505.png
Figure 5-5. `origin/master` ile birleştirdikten sonra Burak'ın reposu.

Şimdi, Burak herşeyin hala düzgün olduğundan emin olmak için test edip ardından değişikliklerini sunucuya gönderebilir:

	$ git push origin master
	...
	To burak@githost:simplegit.git
	   fbff5bc..72bbc59  master -> master

Sonuç olarak Burak'ın commit geçmişi Resim 5-6daki gibi görünür.

Insert 18333fig0506.png
Figure 5-6. Origin sunucuya gönderdikten sonra Burak'ın commit geçmişi.

Aynı esnada Nesrin de bir konu branchinde çalışmaktadır. `issue54` isminde bir branch oluşturmuş ve bu branche 3 commit yapmıştır ve henüz Burak'ın yaptığı değişiklileri kendisine çekmemiştir. Commit geçmişi Resim 5-7deki gibidir.

Insert 18333fig0507.png
Figure 5-7. Nesrin'in baştaki commit geçmişi.

Nesrin Burak ile senkronize olmak ister ve fetch eder:

	# Nesrin's Machine
	$ git fetch origin
	...
	From nesrin@githost:simplegit
	   fbff5bc..72bbc59  master     -> origin/master

Bu Burak'ın pushladığı çalışmaları çeker. Jessica'nın geçmişi şimdi Resim 5-8deki gibidir.

Insert 18333fig0508.png
Figure 5-8. Burak'ın değişikliklerini fetch ettikten sonra Nesrin'in geçmişi.

Nesrin kendi branchinin hazır olduğunu düşünür, fakat neleri birleştirmesi gerektiğini görmek istemektedir. `git log` çalıştırarak bunu görebilir:

	$ git log --no-merges origin/master ^issue54
	commit 738ee872852dfaa9d6634e0dea7a324040193016
	Author: Burak Can <bcan@example.com>
	Date:   Fri May 29 16:01:27 2009 -0700

	    geçersiz varsayılan değer kaldırıldı