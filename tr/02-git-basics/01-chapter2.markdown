# Git'in Temelleri #

Git'i kullanmaya başlamak için yalnızca bir bölüm okuyacak kadar zamanınız varsa, o bölüm, bu bölüm olmalı. Bu bölüm, Git'i kullanarak yapacağınız şeylerin çok büyük kısmı için kullanacağınız bütün temel komutları içeriyor. Bu bölümün sonunda bir yazılım havuzunun nasıl yapılandırıp, ilkleneceğini (_initialize_), dosyaların nasıl izlemeye alınıp izlemeden çıkarılacağını ve değişikliklerin nasıl hazırlanıp kaydedileceğini öğreneceksiniz. Bunlara ek olarak, Git'i bazı dosyaları ya da konumları belli örüntülere (_pattern_) uyan dosyaları görmezden gelmesi için nasıl ayarlayacağınızı, hataları hızlıca ve kolayca nasıl geri alabileceğinizi, projenizin tarihçesine nasıl göz gezdirip kayıtlar arasındaki farkları nasıl görüntüleyebileceğinizi ve uzak uçbirimlerden nasıl kod çekme işlemi yapabileceğinizi göstereceğiz.

## Bir Git Yazılım Havuzu Edinmek ##

Bir Git projesi edinmenin başlıca iki yolu vardır. Bunlardan ilki, halihazırda varolan bir projeyi Git'e aktarmaktır. İkincisi ise bir sunucuda yer alan bir Git yazılım havuzunu klonlamakdır.

### Var olan Bir Klasörde Yazılım Havuzu Oluşturmak ###

Var olan bir projenizi sürüm kontrolü altına almak istiyorsanız, projenin bulunduğu klasöre gidip aşağıdaki komutu çalıştırmanız gerekir:

	$ git init

Bu, gerekli yazılım havuzu dosyalarını —Git iskeletini— içeren `.git` adında bir klasör oluşturur. Bu noktada, projenizdeki hiçbir şey sürüm kontrolüne girmiş değildir. (Oluşturulan `.git` klasöründe tam olarak hangi dosyaların bulunduğu hakkında daha fazla bilgi edinmek için bkz. _9. Bölüm_.)

Var olan dosyalarınızı sürüm kontrolüne almak istiyorsanız, o dosyaları hazırlayıp kayıt etmelisiniz. Bunu, sürüm kontrolüne almak istediğiniz dosyaları belirleyip kayıt altına aldığınız birkaç git komutuyla gerçekleştirebilirsiniz:

	$ git add *.c
	$ git add README
	$ git commit -m 'projenin ilk hali'

Birazdan bu komutların üzerinde duracağız. Bu noktada, sürüm kontrolüne aldığınız dosyaları içeren bir Git yazılım havuzunuz var.

### Var olan Bir Yazılım Havuzunu Klonlamak ###

Var olan bir Git yazılım havuzunu klonlamak istiyorsanız —söz gelimi, katkıda bulunmak istediğiniz bir proje varsa- ihtiyacınız olan komut `git clone`. Subversion gibi başka SKS'lere aşinaysanız, komutun `checkout` değil `clone` olduğunu fark etmişsinizdir. Bu önemli bir ayrımdır —Git, sunucuda bulunan neredeyse bütün veriyi kopyalar. `git clone` komutunu çalıştırdığınızda her dosyanın proje tarihçesinde bulunan her sürümü istemciye indirilir. Hatta, sunucunuzun diski bozulacak olsa, herhangi bir istemcideki herhangi bir klonu, sunucuyu klonlandığı zamanki haline geri getirmek için kullanabilirsiniz (sunucunuzdaki bazı çengel betikleri (_hook_) kaybedebilirsiniz, ama sürümlenmiş verinin tamamı elinizin altında olacaktır —daha fazla ayrıntı için bkz. _4. Bölüm_)

Bir yazılım havuzu `git clone [url]` komutuyla klonlanır. Örneğin, Grit adlı Ruby Git kütüphanesini klonlamak isterseniz, bunu şu şekilde yapabilirsiniz:

	$ git clone git://github.com/schacon/grit.git

Bu komut `grit` adında bir klasör oluşturur, bu klasörün içinde bir `.git` alt dizini oluşturup ilklemesini yapar, söz konusu yazılım havuzunun bütün verisini indirir ve son sürümünün bir koyasını seçer (_checkout_). Bu yeni `grit` klasörüne gidecek olursanız, kullanılmaya ve üzerinde çalışılmaya hazır proje dosyalarını görürsünüz. Yazılım havuzunu adı grit'ten farklı bir klasöre kopyalamak isterseniz, bunu komut satırı seçeneği olarak vermelisiniz:

	$ git clone git://github.com/schacon/grit.git mygrit

Bu komut da bir öncekiyle aynı şeyleri yapar, fakat oluşturulan klasörün adı `mygrit`'tir.

Git'in bir dizi farklı transfer protokolü vardır. Yukarıdaki örnek `git://` protokolünü kullanıyor, ama `http(s)://`'in ya da SSH  transfer protokolünü kullanan `user@server:/path.git`'in kullanıldığına da tanık olabilirsiniz. _4. Bölüm_'de Git yazılım havuzuna erişmek için sunucunun kullanabileceği bütün geçerli seçenekleri ve bunların olumlu ve olumsuz yanlarını inceleyeceğiz.

## Değişiklikleri Yazılım Havuzuna Kaydetmek ##

Gerçek bir Git yazılım havuzuna ve söz konusu proje için gerekli olan bir dosya seçmesine sahipsiniz. Bu proje üzerinde değişiklikler yapmanız ve proje kaydetmek istediğiniz bir seviyeye geldiğinde bu değişikliklerin bir bellek kopyasını kaydetmeniz gerekecek.

Unutmayın, çalışma klasörünüzdeki dosyalar iki halden birinde bulunurlar: _izlenenler_ (_tracked_) ve _izlenmeyenler_ (_untracked_). _İzlenen_ dosyalar, bir önceki bellek kopyasında bulunan dosyalardır; bunlar _değişmemiş_, _değişmiş_ ya da _hazırlanmış_ olabilirler. Geri kalan her şey —çalışma klasörünüzde bulunan ve bir önceki bellek kopyasında ya da hazırlama alanında bulunmayan dosyalar— _izlenmeyen_ dosyalardır. Bir yazılım havuzunu yeni kopyalamışsanız, bütün dosyalar, henüz yeni seçme yaptığınız ve hiçbir şeyi değiştirmediğiniz için, izlenen ve değişmemiş olacaktır.

Dosyaları düzenlemeye başladığınızda, Git onları değişmiş olarak görecektir, çünkü son kaydınızdan beri üzerlerinde değişiklik yapmış olacaksınız. Değiştirdiğiniz bu dosyaları önce _hazırlayıp_ sonra bütün _hazırlanmış_ değişiklikleri kaydedeceksiniz ve bu döngü böyle sürüp gidecek. Bu döngü, Figür 2-1'de gösteriliyor.


Insert 18333fig0201.png
Figür 2-1. Dosyalarınızın değişik durumlarının döngüsü.

### Dosyaların Durumlarını Kontrol Etmek ###

Hangi dosyanın hangi durumda olduğunu görmek için kullanılacak temel araç `git status` komutudur. Bu komutu bir klonlama işleminin hemen sonrasında çalıştıracak olursanız, şöyle bir şey görmelisiniz:

	$ git status
	# On branch master
	nothing to commit, working directory clean

Bu çalışma klasörünüzün temiz olduğu anlamına gelir —başka bir deyişle, izlenmekte olup da değiştirilmiş herhangi bir dosya yoktur. Git'in saptadığı herhangi bir izlenmeyen dosya da yok, olsaydı burada listelenmiş olurdu. Son olarak, bu komut size hangi dal (_branch_) üzerinde olduğunuzu söylüyor. Şimdilik bu, daima varsayılan dal olan `master` olacaktır; Şu anda buna kafa yormayın. Sonraki bölüm de dallar ve referanslar konusu derinlemesine ele alınacak.

Diyelim ki projenize yeni bir dosya, basit bir README dosyası eklediniz. Eğer dosya önceden orada bulunmuyorsa, ve `git status` komutunu çalıştırırsanız, bu izlenmeyen dosyayı şu şekilde görürsünüz:

	$ vim README
	$ git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#	README
	nothing added to commit but untracked files present (use "git add" to track)

Yeni README dosyanızın izlenmediğini görüyorsunuz, çünkü `status` çıktısında “Untracked files” başlığı altında listelenmiştir. Bir dosyanın izlenmemesi demek, Git'in onu bir önceki bellek kopyasında (_commit_) görmemesi demektir; siz açıkça belirtmediğiniz sürece Git bu dosyayı izlemeye başlamayacaktır. Bunun nedeni, derleme çıktısı olan ikili dosyaların ya da projeye dahil etmek istemediğiniz dosyaların yanlışlıkla projeye dahil olmasını engellemektir. README dosyasını projeye eklemek istiyorsunuz, öyleyse dosyayı izlemeye alalım.

### Yeni Dosyaları İzlemeye Almak ###

Yeni bir dosyayı izlemeye almak için `git add` komutunu kullanmalısınız. README dosyasını izlemeye almak için komutu şu şekilde çalıştırabilirsiniz:

	$ git add README

`status` komutunu yeniden çalıştırırsanız, README dosyasının artık izlemeye alındığını ve hazırlık alanında olduğunu göreceksiniz:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#

Hazırlık alanında olduğunu “Changes to be committed” başlığının altında olmasına bakarak söyleyebilirsiniz. Eğer bu noktada bir kayıt (_commit_) yapacak olursanız, dosyanın `git add` komutunu çalıştırdığınız andaki hali bellek kopyasına kaydedilecektir. Daha önce `git init` komutunu çalıştırdıktan sonra projenize dosya eklemek için `git add (dosya)` komutunu çalıştırdığınızı hatırlayacaksınız —bunun amacı klasörünüzdeki dosyaları izlemeye almaktı. `git add` komutu bir dosya ya da klasörün konumuyla çalışır; eğer söz konusu olan bir klasörse, klasördeki bütün dosyaları tekrarlamalı olarak projeye ekler.

### Değiştirilen Dosyaları Hazırlamak ###

Gelin şimdi halihazırda izlenmekte olan bir dosyayı değiştirelim. İzlenmekte olan `benchmarks.rb` adındaki bir dosyayı değiştirip `status` komutunu çalıştırdığınızda şöyle bir ekran çıktısıyla karşılaşırsınız:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#	modified:   benchmarks.rb
	#

`benchmarks.rb` dosyası “Changes not staged for commit” başlıklı bir bölümün altında görünüyor —bu başlık izlenmekte olan bir dosyada değişiklik yapılmış olduğu fakat dosyanın henüz hazırlık alanına alınmadığı durumlarda kullanılır. Dosyayı hazırlamak için, `git add` komutunu çalıştırın (`git add` çok amaçlı bir komuttur, bir dosyayı izlemeye almak için, kayda hazırlamak için, ya da birleştirme uyuşmazlıklarının çözüldüğünü işaretlemek gibi başka amaçlarla kullanılır). Gelin `benchmarks.rb` dosyasını kayda hazırlamak için `git add` komutunu çalıştırıp sonra da `git status` komutuyla duruma bakalım:

	$ git add benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#

Her iki dosya da kayda hazırlanmış durumdadır ve bir sonraki kaydınıza dahil edilecektir. Tam da bu noktada, henüz kaydı gerçekleştirmeden, aklınıza `benchmarks.rb` dosyasında yapmak istediğiniz küçük bir değişikliğin geldiğini düşünelim. Dosyayı yeniden açıp değişikliği yaptıktan sonra artık kaydı yapmaya hazırsınız. Fakat, `git status` komutunu bir kez daha çalıştıralım:

	$ vim benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#	modified:   benchmarks.rb
	#

Ne oldu? `benchmarks.rb` dosyası hem kayda hazırlanmış hem de kayda hazırlanmamış görünüyor. Bu nasıl olabiliyor? Git, bir dosyayı `git add` komutunun alıştırıldığı haliyle kayda hazırlar. Eğer şimdi kayıt yapacak olursanız, `benchmarks.rb` dosyası, çalışma klasöründe göründüğü haliyle değil, `git add` komutunu son çalıştırdığınız haliyle kayıt edilecektir. Bir dosyayı `git add` komutunu çalıştırdıktan sonra değiştirecek olursanız, dosyanın son halini kayda hazırlamak için `git add` komutunu bir kez daha çalıştırmanız gerekir:

	$ git add benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#

### Dosyaları Görmezden Gelmek ###

Çoğu zaman, projenizde Git'in takip etmesini, hatta size izlenmeyenler arasında göstermesini bile istemediğiniz bir küme dosya olacaktır. Bunlar, genellikle otomatik olarak oluşturulan seyir (_log_) dosyaları ya da yazılım inşa sisteminin çıktılarıdır. Bu durumlarda, bu dosyaların konumlarıyla eşleşen örüntüleri listeleyen `.gitignore` adında bir dosya oluşturabilirsiniz:

	$ cat .gitignore
	*.[oa]
	*~

İlk satır, Git'e `.o` ya da `.a` ile biten dosyaları —yazılım derlemesinin sonucunda ortaya çıkmış olabilecek _nesne_ ve _arşiv_ dosyalarını— görmezden gelmesini söylüyor. İkinci satır, Git'e Emacs gibi pek çok metin editörü tarafından geçici dosyaları işaretlemek için kullanılan tilda işaretiyle (`~`) biten bütün dosyaları görmezden gelmesini söylüyor. Bu listeye `log`, `tmp` ya da `pid` klasörlerini, otomatik olarak oluşturulan dokümantasyon dosyalarını ve sair dosyayı ekleyebilirsiniz. Daha projenin başlangıcında bir `.gitignore` dosyası oluşturmak yazılım havuzunuzda istemeyeceğiniz dosyaları yanlışlıkla kaydetmenize engel olacağından oldukça iyi bir fikirdir.

`.gitignore` dosyanızda bulundurabileceğiniz örüntüler şu kurallara bağlıdır:

*	Boş satırlar ve `#` ile başlayan satırlar görmezden gelinir.
*	Stadart _glob_ örüntüleri ayırt edilir (Ç.N.: _glob_ \*nix tarafından kullanılan sınırlı bir kurallı ifade (_regular expression_) biçimidir).
*	Bir klasörü belirtmek üzere örüntüleri bir eğik çizgi (`/`) ile sonlandırabilirsiniz.
*	Bir örüntüyü ünlem işaretiyle (`!`) başlattığınızda, örüntünün tersi gereçli olur.

_Glob_ örüntüleri _shell_'ler tarafından kullanılan basitleştirilmiş kurallı ifadelerdir (_regular expression_). Bir yıldız işareti (`*`) sıfır ya da daha fazla karakterle eşleşir; `[abc]` köşeli parantezin içindeki herhangi bir karakterle eşleşir (buradaki örnekte `a`, `b`, ya da `c` ile); soru işareti (`?`) bir karakterle eşleşir; tireyle ayrılmış karakterleri içine alan bir köşeli parantez (`[0-9]`) bu aralıktaki bütün karakterlerle eşleşir (bu örnekte 0'dan 9'a kadar olan karakterler).

Bir `.gitignore` dosyası örneği daha:

	# bir yorum - bu görmezden gelinir
	# .a dosyalarını görmezden gel
	*.a
	# ama yukarıda .a dosyalarını görmezden geliyor olsan bile lib.a dosyasını izlemeye al
	!lib.a
	# kök dizindeki /TODO dosyasını (TODO adındaki alt klasörü değil) görmezden gel
	/TODO
	# build/ klasöründeki bütün dosyaları görmezden gel
	build/
	# doc/notes.txt dosyasını görmezden gel ama doc/server/arch.txt dosyasını görmezden gelme
	doc/*.txt

### Kayda Hazırlanmış ve Hazırlanmamış Değişiklikleri Görüntülemek ###

`git status` komutunu fazla anlaşılmaz buluyorsanız —yalnızca hangi dosyaların değiştiğini değil, bu dosyalarda tam olarak nelerin değiştiğini görmek istiyorsanız— `git diff` komutunu kullanabilirsiniz. `git diff` komutunu ileride ayrıntılı olarak inceleyeceğiz; ama bu komutu muhtemelen en çok şu iki soruya cevap bulmak için kullanacaksınız: Değiştirip de henüz kayda hazırlamadığınız neler var? Ve kayda olmak üzere hangi değişikliklerin hazırlığını yaptınız? `git status` bu soruları genel biçimde cevaplıyor olsa da `git diff` eklenen ve çıkarılan bütün dosyaları —olduğu gibi yamayı— gösterir.

Diyelim `README` dosyasını düzenleyip kayda hazırladınız, sonra da `benchmarks.rb` dosyasını düzenlediniz ama kayda hazırlamadınız. `status` komutunu çalıştırdığınızda şöyle bir şey görürsünüz:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#	modified:   benchmarks.rb
	#

Henüz kayda hazırlamadığınız değişiklikleri görmek için `git diff` komutunu (başka hiçbir argüman kullanmadan) çalıştırın:

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

Komut, çalışma klasörünüzün içeriğiyle kayda hazırlık alanının içeriğini karşılaştırır. Sonuç size henüz kayda hazırlamadığınız değişiklikleri gösterir.

Kayda hazırlamış olduğunuz değişiklikleri görmek için `git diff --cache` komutunu kullanabilirsiniz. (1.6.1'den sonraki Git sürümlerinde hatırlaması daha kolay olabilecek `git diff --staged` komutunu da kullanabilirsiniz.) Bu komut kayda hazırlanmış değişikliklerle son kaydı karşılaştırır.

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

Dikkat edilmesi gereken nokta, `git diff`'in son kayıttan beri yapılan bütün değişiklikleri değil yalnızca kayda hazırlanmamış değişiklikleri gösteriyor oluşudur. Bu zaman zaman kafa karıştırıcı olabilir, zira, bütün değişikliklerinizi kayda hazırladıysanız, `git diff`'in çıktısı boş olacaktır.

Yine, örnek olarak, `benchmarks.rb` dosyasını kayda hazırlayıp daha sonra üzerinde değişiklik yaparsanız, `git diff` komutunu kullanarak hangi değişikliklerin kayda hazırlandığını, hangilerinin hazırlanmadığını görüntüleyebilirsiniz:

	$ git add benchmarks.rb
	$ echo '# test line' >> benchmarks.rb
	$ git status
	# On branch master
	#
	# Changes to be committed:
	#
	#	modified:   benchmarks.rb
	#
	# Changes not staged for commit:
	#
	#	modified:   benchmarks.rb
	#

Şimdi `git diff` komutuyla hangi değişikliklerin henüz kayda hazırlanmamış olduğunu

	$ git diff
	diff --git a/benchmarks.rb b/benchmarks.rb
	index e445e28..86b2f7c 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -127,3 +127,4 @@ end
	 main()

	 ##pp Grit::GitRuby.cache_client.stats
	+# test line

ve `git diff --cached` komutuyla neleri kayda hazırlamış olduğunuzu görebilirsiniz:

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

### Değişiklikleri Kaydetmek ###

Yaptığınız değişiklikleri dilediğiniz gibi hazırlık alanına aldığınıza göre artık onları kaydedebilirsiniz (_commit_). Unutmayın, kayda hazırlanmamış —oluşturduğunuz ya da değiştirdiğiniz fakat `git add` komutunu kullanarak kayda hazırlamadığınız— değişiklikler kaydedilmeyecektir. Onlar sabit diskinizde değiştirilmiş dosyalar olarak kalacaklar.

Bu örnekte, `git status` komutunu son çalıştırdığınızda her şeyin kayda hazırlanmış olduğunu gördünüz, dolayısıyla değişikliklerinizi kaydetmeye hazırsınız. Kayıt yapmanın en kolay yolu `git commit` komutunu kullanmaktır:

	$ git commit

Bu komutu çalıştırdığınızda sisteminizde seçili bulunan metin editörü açılacaktır. (Editörünüz _shell_'inizin `$EDITOR` çevresel değişkeni tarafından tanımlanır —genellikle vim ya da emacs'tır, fakat `git config --global core.editor` komutunu _1. Bölüm_'de gördüğünüz gibi çalıştırarak bu ayarı değiştirebilirsiniz.)

Metin editörü aşağıdaki metni görüntüler (bu örnek Vim ekranından):

	# Please enter the commit message for your changes. Lines starting
	# with '#' will be ignored, and an empty message aborts the commit.
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       new file:   README
	#       modified:   benchmarks.rb
	~
	~
	~
	".git/COMMIT_EDITMSG" 10L, 283C

Gördüğünüz gibi hazır kayıt mesajı `git status` çıktısının `#` kullanılarak devre dışı bırakılmış haliyle en üstte bir boş satırdan oluşur. Bu devre dışı bırakılmış kayıt mesajını silip yerine kendi kayıt mesajınızı yazabilir, ya da neyi kaydettiğinizi size hatırlatması için orada bırakabilirsiniz. (Neyi değiştirdiğinizin daha ayrıntılı olarak hatırlatılmasını isterseniz, `git commit` mesajını `-v` seçeneğiyle kullanabilirsiniz. Bu seçenek kaydetmekte olduğunuz değişikliğin içeriğini de (_diff_) editörde gösterecektir.) Editörü kapattığınızda Git, yazdığınız mesajı kullanarak değişikliği kaydeder (devre dışı bırakılmış bölümü ve değişikliğin içeriğini mesajın dışında bırakır).

Bir başka seçenek de, kayıt mesajınızı `commit` komutunu `-m` seçeneğiyle aşağıdaki gibi kullanmaktır:

	$ git commit -m "Story 182: Fix benchmarks for speed"
	[master]: created 463dc4f: "Fix benchmarks for speed"
	 2 files changed, 3 insertions(+), 0 deletions(-)
	 create mode 100644 README

İlk kaydınızı oluşturmuş oldunuz! Görüldüğü gibi kayıt kendisiyle ilgili bilgiler veriyor: hangi dala kayıt yapmış olduğunuzu (`master`), kaydın SHA-1 sınama toplamının ne olduğunu (`463dc4f`), kaç dosyada değişiklik yaptığınızı ve kayıtta kaç satır ekleyip çıkardığınıza dair istatistiklerin çıktısını veriyor.

Unutmayın, kayıt, hazırlık alanında kayda hazırladığınız bellek kopyasının kaydıdır. Kayda hazırlamadığınız değişiklikler, değişiklik olarak duruyor; onları da proje tarihçesine eklemek isterseniz yeni bir kayıt yapabilirsiniz. Her kayıt işleminde projenizin bir bellek kopyasını kaydediyorsunuz; bu bellek kopyalarını daha sonra geriye sarabilir ya da birbiriyle karşılaştırabilirsiniz.

### Hazırlık Alanını Atlamak ###

Her ne kadar kayıtları tam istediğiniz gibi düzenlemek inanılmaz derecede yararlı bir şey olsa da, hazırlık alanı kimi zaman iş akışınıza fazladan bir yük getirebilir. Git, hazırlık alanını kullanmadan geçmek isteyenler için basit bir kısayol sunuyor. `git commit` komutunu `-a` seçeneğiyle kullanırsanız, Git, halihazırda izlenmekte olan bütün dosyaları otomatik olarak kayda hazırlayıp, `git add` aşamasını atlamanızı sağlar:

	$ git status
	# On branch master
	#
	# Changes not staged for commit:
	#
	#	modified:   benchmarks.rb
	#
	$ git commit -a -m 'added new benchmarks'
	[master 83e38c7] added new benchmarks
	 1 files changed, 5 insertions(+), 0 deletions(-)

Gördüğünüz gibi, kayıt işlemi yapmadan önce `benchmarks.rb` dosyasını `git add` komutundan geçirmek zorunda kalmadınız.

### Dosyaları Ortadan Kaldırmak ###

Bir dosyayı Git'ten silmek için, önce izlenen dosyaları listesinden çıkarmalı (daha doğrusu, kayda hazırlık alanından kaldırmalı) sonra da kaydetmelisiniz. `git rm` hem bunu yapar hem de dosyayı çalışma klasörünüzden siler, böylece dosyayı izlenmeyen dosyalar arasında görmezsiniz.

Eğer dosyayı çalışma klasörünüzden silerseniz, `git status` çıktısının “Changes not staged for commit” (yani _kayda hazırlanmamış olanlar_) başlığı altında boy gösterecektir:

	$ rm grit.gemspec
	$ git status
	# On branch master
	#
	# Changes not staged for commit:
	#   (use "git add/rm <file>..." to update what will be committed)
	#
	#       deleted:    grit.gemspec
	#

Sonrasında `git rm` komutunu çalıştırırsanız, dosyanın ortadan kaldırılması için kayda hazırlanmasını sağlamış olursunuz:

	$ git rm grit.gemspec
	rm 'grit.gemspec'
	$ git status
	# On branch master
	#
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       deleted:    grit.gemspec
	#

Bir sonraki kaydınızda, dosya silinmiş olacak ve artık izlenmeyecektir. Eğer dosyayı değiştirmiş ve halihazırda indekse eklemişseniz, ortadan kaldırma işlemini `-f` seçeneğini kullanarak zorlamanız gerekecektir. Bu, herhangi bir bellek kopyasına kaydedilmemiş ve Git kullanılarak kurtarılamayacak verilerin kaybolmasını önlemek amacıyla geliştirilmiş bir önlemdir.

Yapmak isteyebileceğiniz bir başka şey de dosyayı çalışma klasörünüzde tutup, kayda hazırlık alanından silmek olabilir. Bir başka deyişle, dosyayı sabit diskinizde bulundurmak ama Git'in izlenecek dosyalar listesinden çıkarmak isteyebilirsiniz. Bu, özellikle belirli bir dosyayı (büyük bir seyir dosyasını ya da bir küme derlenmiş `.a` dosyasını) `.gitignore` dosyanıza eklemeyi unutup yanlışlıkla Git indeksine eklediğinizde kullanışlı olan bir özelliktir. Bunu yapmak için `--cached` seçeneğini kullanmalısınız:

	$ git rm --cached readme.txt

`git rm` komutunu dosyalar, klasörler ya da _glob_ örüntüleri üzerinde kullanabilirsiniz. Yani şöyle şeyler yapabilirsiniz:

	$ git rm log/\*.log

`*`'in önündeki ters eğik çizgi işaretini gözden kaçırmayın. Bu işaret gereklidir, çünkü _shell_'inizin dosya adı açımlamasına ek olarak, Git de kendi dosya adı açımlamasını yapar. Yukarıdaki komut, `log/` klasöründeki `.log` eklentili bütün dosyaları ortadan kaldıracaktır. Ya da, şöyle bir şey yapabilirsiniz:

	$ git rm \*~

Bu komut `~` ile biten bütün dosyaları ortadan kaldıracaktır.

### Dosyaları Taşımak ###

Çoğu SKS'nin aksine Git taşınan dosyaları takip etmez. Bir dosyanın adını değiştirirseniz, Git, dosyanın yeniden adlandırıldığına dair herhangi bir üstveri oluşturmaz. Fakat Git, olay olup bittikten sonra neyin ne olduğunu anlamakta oldukça beceriklidir —dosya hareketlerini keşfetme meselesini birazdan ele alacağız.

Bu nedenle Git'in bir `mv` komutu olması biraz kafa karıştırıcı olabilir. Git'te bir dosyanın adını değiştirmek istiyorsanız, şöyle bir komut çalıştırabilirsiniz:

	$ git mv eski_dosya yeni_dosya

ve istediğinizi elde edersiniz. Hatta, buna benzer bir komut çalıştırdıktan sonra `status` çıktısına bakarsanız Git'in bir dosya adlandırma işlemini (_rename_) listelediğini görürsünüz:

	$ git mv README.txt README
	$ git status
	# On branch master
	# Your branch is ahead of 'origin/master' by 1 commit.
	#
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       renamed:    README.txt -> README
	#

Öte yandan bu komut, şu komutları arka arkaya çalıştırmaya eşdeğerdir:

	$ mv README.txt README
	$ git rm README.txt
	$ git add README

Git dosya taşıma işlemini dolaylı yollardan anlar, dolayısıyla dosyayı yeniden adlandırmayı bu komutlarla mı yaptığınız yoksa `mv` komutunu mu kullandığınız Git açısından önemli değildir. Tek gerçek fark arka arkaya üç komut kullanmak yerine tek bir komut kullanıyor olmanızdır —`mv` bir kullanıcıya kolalık sağlayan bir komuttur. Daha önemlisi, bir dosyanın adını değiştirmek için istediğiniz her aracı kullanabilir, `add/rm` işlemlerini sonraya kayıttan hemen öncesine bırakabilirsiniz.

## Kayıt Tarihçesini Görüntülemek ##

Birkaç kayıt oluşturduktan, ya da halihazırda kayıt tarihçesi olan bir yazılım havuzunu klonladığınızda, muhtemelen geçmişe bakıp neler olduğuna göz atmak isteyeceksiniz. Bunun için kullanabileceğiniz en temel ve becerikli araç `git log` komutudur.

Buradaki örnekler benim çoğunlukla tanıtımlarda kullandığım `simplegit` adında bir projeyi kullanıyor. Projeyi edinmek için aşağıdaki komutu çalıştırabilirsiniz:

	git clone git://github.com/schacon/simplegit-progit.git

Bu projenin içinde `git log` komutunu çalıştırdığınızda şuna benzer bir çıktı göreceksiniz:

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

Aksi belirtilmedikçe, `git log` bir yazılım havuzundaki kayıtları ters kronolojik sırada listeler. Yani, en son kayıtlar en üstte görünür. Görüldüğü gibi, bu komut her kaydın SHA-1 sınama toplamını, yazarının adını ve adresini, kaydedildiği tarihi ve kayıt mesajını listeler.

`git log` komutunun, size tam olarak aradığınız şeyi göstermek için kullanılabilecek çok sayıda seçeneği vardır. Burada, en çok kullanılan bazı seçenekleri tanıtacağız.

En yararlı seçeneklerden biri, kaydın içeriğini (_diff_) gösteren `-p` seçeneğidir. İsterseniz `-2`'yi kullanarak komutun çıktısını son iki kayıtla sınırlayabilirsiniz:

	$ git log -p -2
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	diff --git a/Rakefile b/Rakefile
	index a874b73..8f94139 100644
	--- a/Rakefile
	+++ b/Rakefile
	@@ -5,7 +5,7 @@ require 'rake/gempackagetask'
	 spec = Gem::Specification.new do |s|
	-    s.version   =   "0.1.0"
	+    s.version   =   "0.1.1"
	     s.author    =   "Scott Chacon"

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

Bu seçenek daha önceki bilgilere ek olarak kaydın içeriğini de her gösterir. Bu, yazılımı gözden geçirirken ya da belirli bir katılımcı tarafından yapılan bir dizi kayıt sırasında nelerin değiştiğine hızlıca göz atarken çok işe yarar.

Dilerseniz `git log`'u özet bilgiler veren bir dizi seçenekle birlikte kullanabilirsiniz. Örneğin, her kayıtla ilgili özet istatistikler için `--stat` seçeneğini kullanabilirsiniz:

	$ git log --stat
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	 Rakefile |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	 lib/simplegit.rb |    5 -----
	 1 files changed, 0 insertions(+), 5 deletions(-)

	commit a11bef06a3f659402fe7563abf99ad00de2209e6
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 10:31:28 2008 -0700

	    first commit

	 README           |    6 ++++++
	 Rakefile         |   23 +++++++++++++++++++++++
	 lib/simplegit.rb |   25 +++++++++++++++++++++++++
	 3 files changed, 54 insertions(+), 0 deletions(-)

Gördüğünüz gibi `--stat`  seçeneği, her kaydın altına o kayıtta değişikliğe uğramış dosyaların listesini, kaç tane dosyanın değişikliğe uğradığını ve söz konusu dosyalara kaç satırın eklenip çıkarıldığı bilgisini ekler. Bu bilgilerin bir özetini de kaydın en altına yerleştirir. Oldukça yararlı bir başka seçenek de `--pretty` seçeneğidir. Bu seçenek `log` çıktısının biçimini değiştirmek için kullanılır. Bu seçenekle birlikte kullanacağınız birkaç tane öntanımlı ek seçenek vardır. `oneline` ek seçeneği her bir kaydı tek bir satırda gösterir; bu çok sayıda kayda göz atıyorsanız yararlı olabilir. Ayrıca `short`, `full` ve `fuller` seçenekleri aşağı yukarı aynı miktarda bilgiyi —bazı farklarla— gösterir:

	$ git log --pretty=oneline
	ca82a6dff817ec66f44342007202690a93763949 changed the version number
	085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 removed unnecessary test code
	a11bef06a3f659402fe7563abf99ad00de2209e6 first commit

En ilginç ek seçenek, istediğiniz log çıktısını belirlemenizi sağlayan `format` ek seçeneğidir. Bu, özellikle bilgisayar tarafından işlenecek bir çıktı oluşturmak konusunda elverişlidir —biçimi açıkça kendiniz belirlediğiniz için farklı Git sürümlerinde farklı sonuçlarla karşılaşmazsınız:

	$ git log --pretty=format:"%h - %an, %ar : %s"
	ca82a6d - Scott Chacon, 11 months ago : changed the version number
	085bb3b - Scott Chacon, 11 months ago : removed unnecessary test code
	a11bef0 - Scott Chacon, 11 months ago : first commit

Tablo 2-1 `format` ek seçeneğinin kabul ettiği bazı biçimlendirme seçeneklerini gösteriyor.

	Seçenek	Çıktının Açıklaması
	%H	Sınama toplamı
	%h	Kısaltılmış sınama toplamı
	%T	Git ağacı sınama toplamı
	%t	Kısaltılmış Git ağacı sınama toplamı
	%P	Ata kayıtların sınama toplamları
	%p	Ata kayıtların kısaltılmış sınama toplamları
	%an	Yazarın adı
	%ae	Yazarın e-posta adresi
	%ad	Yazılma tarihi (–date= seçeneğiyle uyumludur)
	%ar	Yazılma tarihi (göreceli tarih)
	%cn	Kaydedenin adı
	%ce	Kaydedenin e-posta adresi
	%cd	Kaydedilme tarihi
	%cr	Kaydedilme tarihi (göreceli tarih)
	%s	Konu

_yazar_'la _kaydeden_ arasında ne gibi bir fark olduğunu merak ediyor olabilirsiniz. _yazar_ yamayı oluşturan kişidir, _kaydeden_'se yamayı projeye uygulayan kişi. Bir projeye yama gönderdiğinizde, projenin çekirdek üyelerinden biri yamayı projeye uygularsa, her ikinizin de adı kaydedilecektir —sizin adınız yazar olarak onun adı kaydeden olarak. Bu farkı _5. Bölüm_'de biraz daha ayrıntılı olarak ele alacağız.

`oneline` ve `format` ek seçenekleri özellikle `--graph` ek seçeneğiyle birlikte kullanıldıklarında çok işe yararlar. Bu ek seçenek projenizin dal (_branch_) ve birleştirme (_merge_) tarihçesini gösteren sevimli bir ASCII grafiği oluşturur. Grit yazılım havuzunun grafiğine bakalım:

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

Bunlar `git log`'la birlikte kullanabileceğiniz seçeneklerden yalnızca birkaçı —daha başka çok sayıda seçenek var. Tablo 2-2 yukarıda incelediğimiz seçeneklerin yanı sıra, yararlı olabilecek başka seçenekleri `git log` çıktısına olan etkileriyle birlikte listeliyor.

	Seçenek	Açıklama
	-p	Kayıtların içeriklerini de göster.
	--stat	Kayıtlarda değişikliğe uğrayan dosyalarla ilgili istatistikleri göster.
	--shortstat	Yalnızca değişikliği/eklemeyi/çıkarmayı özetleyen satırı göster command.
	--name-only	Kayıtlarda değişen dosyaların yalnızca adlarını göster.
	--name-status	Kayıtlarda değişen dosyaların adlarıyla birlikte değişme/eklenme/çıkarılma bilgisini de göster.
	--abbrev-commit	Sınama toplamının 40 karakterli tamamı yerine yalnızca ilk birkaç karakterini göster.
	--relative-date	Tarihi gün, ay, yıl olarak göstermek yerine göreceli olarak göster ("iki hafta önce" gibi).
	--graph	Log tarihçesinin yanısıra, dal ve birleştirme tarihçesini ASCII grafiği olarak göster.
	--pretty	Kayıtları alternatif bir biçimlendirmeyle göster. `oneline` `short`, `full`, `fuller` ve (kendi istediğiniz biçimi belirleyebildiğiniz) `format` ek seçenekleri kullanılabilir.

### Log Çıktısını Sınırlandırma ###

`git log` komutu, biçimlendirme seçeneklerinin yanı sıra bir dizi sınırlandırma seçeneği de sunar —bu seçenekler kayıtların yalnızca bir alt kümesini gösterir. Bu seçeneklerden birini yukarıda gördünüz —yalnızca son iki kaydı gösteren `-2` seçeneğini. Aslında, son `n` kaydı görmek için `n` yerine herhangi bir tam sayı koyarak bu seçeneği `-<n>` biçiminde kullanabilirsiniz. Bunu muhtemelen çok sık kullanmazsınız, zira Git `log` çıktısını zaten sayfa sayfa gösteriyor, dolayısıyla `git log` komutunu çalıştırdığınızda zaten önce kayıtların birinci sayfasını göreceksiniz.

Öte yandan `--since` ya da `--until` gibi çıktıyı zamanla sınırlayan seçenekler işinizi kolaylaştırabilir. Söz gelimi, şu komut, son iki hafta içinde yapılmış kayıtları listeliyor:

	$ git log --since=2.weeks

Bu komut pek çok değişik biçimlendirmeyle kullanılabilir —kesin bir tarih (“2008-01-15”) ya da “2 years 1 day 3 minutes ago” gibi göreli bir tarih kullanabilirsiniz.

Ayrıca listeyi belirli arama ölçütlerine uyacak biçimde filtreleyebilirsiniz. `--author` seçeneği belirli bir yazara aiy kayıtları filtrelemenizi sağlar; `--grep` seçeneğiyse kayıt mesajlarında anahtar kelimeler aramanızı sağlar. (Unutmayın, hem `author` hem de `grep` seçeneklerini kullanmak istiyorsanız, komuta `--all-match` seçeneğini de eklemelisiniz, aksi takdirde, komut bu iki seçenekten herhangi birine uyan kayıtları bulup getirecektir.)

`git log`la kullanılması son derece yararlı olan son seçenek konum seçeneğidir. `git log`'u bir klasör ya da dosya adıyla birlikte kullanırsanız, komutun çıktısını yalnızca o dosyalarda değişiklik yapan kayıtlarla sınırlamış olursunuz. Bu, komuta her zaman en son seçenek olarak eklenmelidir ve konumlar iki tireyle (`--`) diğer seçeneklerden ayrılmalıdır.

Tablo 2-3, bu seçenekleri ve birkaç başka yaygın seçeneği listeliyor.

	Seçenek	Açıklama
	-(n)	Yalnızca son n kaydı göster.
	--since, --after	Yalnızca belirli bir tarihten sonra eklenmiş kayıtlları göster.
	--until, --before	Yalnızca belirli bir tarihten önce yapılmış kayıtları göster.
	--author	Yalnızca yazarın adının belirli bir karakter katarıyla (_string_) eşleşen kayıtları göster.
	--committer	Yalnızca kaydedenin adının belirli bir karakter katarıyla eşleştiği kayıtları göster.

Örneğin, Git kaynak kod yazılım havuzu tarihçesinde birleştirme (_merge_) olmayan hangi kayıtların Junio Hamano tarafından 2008'in Ekim ayında kaydedilmiş olduğunu görmek için şu komutu çalıştırabilirsiniz:

	$ git log --pretty="%h - %s" --author=gitster --since="2008-10-01" \
	   --before="2008-11-01" --no-merges -- t/
	5610e3b - Fix testcase failure when extended attribute
	acd3b9e - Enhance hold_lock_file_for_{update,append}()
	f563754 - demonstrate breakage of detached checkout wi
	d1a43f2 - reset --hard/read-tree --reset -u: remove un
	51a94af - Fix "checkout --track -b newbranch" on detac
	b0ad11e - pull: allow "git pull origin $something:$cur

Bu komut, Git kaynak kodu yazılım havuzundaki yaklaşık 20,000 komut arasından bu ölçütlere uyan 6 tanesini gösteriyor.

### Tarihçeyi Görselleştirmek için Grafik Arayüz Kullanımı ###

Kayıt tarihçenizi görüntülemek için görselliği daha çok ön planda olan bir araç kullanmak isterseniz, Git'le birlikte dağıtılan bir Tcl/Tk programı olan `gitk`'ya bir göz atmak isteyebilirsiniz. Gitk, temelde `git log`'u görselleştiren bir araçtır ve neredeyse `git log`'un kabul ettiği bütün filtreleme seçeneklerini tanır. Proje klasörünüzde komut satırına `gitk` yazacak olursanız Figür 2-2'deki gibi bir şey görürsünüz.

Insert 18333fig0202.png
Figür 2-2. gitk grafiklse tarihçe görüntüleyicisi.

Pencerenin üst yarısında bir kalıtım grafiğinin yanı sıra kayıt tarihçesini görebilirsiniz. Alttaki kayıt içeriği görüntüleyicisi, tıkladığınız herhangi bir kayıttaki değişiklikleri gösterecektir.

## Değişiklikleri Geri Almak ##

Herhangi bir noktada yaptığınız bir değişikliği geri almak isteyebilirsiniz. Burada yapılan değişiklikleri geri almakta kullanılabilecek bazı araçları inceleyeceğiz. Dikkatli olun, zira geri alınan bu değişikliklerden bazılarını yeniden gerçekleştiremeyebilirsiniz. Bu, eğer bir hata yaparsanız, bunu Git'i kullanarak telafi edemeyeceğiniz, az sayıda alanından biridir.

### Son Kayıt İşlemini Değiştirmek ###

Eğer kaydı çok erken yapmışsanız, bazı dosyaları eklemeyi unutmuşsanız ya da kayıt mesajında hata yapmışsanız, sık rastlanan düzeltme işlemlerinden birini kullanabilirsiniz. Kaydı değiştirmek isterseniz, `commit` komutunu `--amend` seçeneğiyle çalıştırabilirsiniz:

	$ git commit --amend

Bu komut, hazırlık alanındaki değişiklikleri alıp bunları kaydı değiştirmek için kullanır. Eğer son kaydınızdan beri hiçbir değişiklik yapmamışsanız (örneğin, bu komutu yeni bir kayıt yaptıktan hemen sonra çalıştırıyorsanız) o zaman kaydınızın bellek kopyası aynı kalacak ve değiştireceğiniz tek şey kayıt mesajı olacaktır.

Aynı kayıt mesajı editörü açılır, fakat editörde bir önceki kaydın kayıt mesajı görünür. Mesajı her zamanki gibi değiştirebilirsiniz, ama bu yeni kayıt mesajı öncekinin yerine geçecektir.

Söz gelimi, eğer bir kayıt sırasında belirli bir dosyada yaptığınız değişiklikleri kayda hazırlamayı unuttuğunuzu fark ederseniz, şöyle bir şey yapabilirsiniz:

	$ git commit -m 'initial commit'
	$ git add forgotten_file
	$ git commit --amend

Bu üç komuttan sonra, tarihçenize tek bir kayıt işlenmiştir —son kayıt öncekinin yerine geçer.

### Kayda Hazırlanmış Bir Dosyayı Hazırlık Alanından Kaldırmak ###

Bu iki alt bölüm kayda hazırlık alanındaki ve çalışma klasörünüzdeki değişiklikleri nasıl idare edeceğinizi gösteriyor. İşin güzel yanı, bu iki alanın durumunu öğrenmek için kullanacağınız komut aynı zamanda bu alanlardaki değişiklikleri nasıl geri alabileceğinizi de hatırlatıyor. Diyelim ki iki dosyayı değiştirdiniz ve bu iki değişikliği ayrı birer kayıt olarak işlemek istiyorsunuz, ama yanlışlıkla `git add *` komutunu kullanarak ikisini birden hazırlık alanına aldınız. Bunlardan birini nasıl hazırlık alanından çıkarabilirsiniz? `git status` komutu size bunu da anımsatıyor:

	$ git add .
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#       modified:   benchmarks.rb
	#

“Changes to be committed” yazısının hemen altında "use `git reset HEAD <file>...` to unstage" yazdığını görüyoruz. `benchmarks.rb` dosyasını bu öneriye uygun olarak hazırlık alanından kaldıralım:

	$ git reset HEAD benchmarks.rb
	benchmarks.rb: locally modified
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   benchmarks.rb
	#

Komut biraz tuhaf, ama iş görüyor. `benchmarks.rb` dosyası hazırlık alanından kaldırıldı ama hâlâ değişmiş olarak görünüyor.

### Değişmiş Durumdaki Bir Dosyayı Değişmemiş Duruma Geri Getirmek ###

Peki `benchmarks.rb` dosyasındaki değişiklikleri korumak istemiyorsanız? Yaptığınız değişiklikleri kolayca nasıl geri alacaksınız —son kayıtta nasıl görünüyorsa o haline (ya da ilk klonlandığı haline, yahut çalışma klasörünüze ilk aldığınız haline) nasıl geri getireceksiniz? Neyse ki `git status` komutu bunu nasıl yapacağınızı da söylüyor. Son örnek çıktıda hazırlık alanı dışındaki değişiklikler şöyle görünüyor:

	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   benchmarks.rb
	#

Yaptığınız değişiklikleri nasıl çöpe atabileceğinizi açıkça söylüyor (en azından Git'in 1.6.1'le başlayan yeni sürümleri bunu yapıyor —eğer daha eski bir sürümle çalışıyorsanız, kolaylık sağlayan bu özellikleri edinebilmek için programı güncellemenizi öneririz). Gelin, söyleneni yapalım:

	$ git checkout -- benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#

Gördüğünüz gibi değişiklikler çöpe atıldı. Bunun tehlikeli bir komut olduğunu aklınızdan çıkarmayın: o dosyaya yaptığınız bütün değişiklikler şimdi yok oldu —dosyanın üstüne yeni bir dosya kopyaladınız. Eğer dosyadaki değişiklikleri istemediğinizden yüzde yüz emin değilseniz asla bu komutu kullanmayın. Eğer sorun bu dosyada yaptığınız değişikliklerin başka işlemler yapmanıza engel olması ise bir sonraki bölümde ele alacağımız zulalama (_stash_) ve dallandırma (_branch_) işlemlerini kullanmanız daha iyi olacaktır.

Unutmayın, Git'te kaydedilmiş her şey neredeyse her zaman kurtarılabilir. Silinmiş dallardaki kayıtlar ve hatta `--amend` seçeneğiyle üzerine yazılmış kayıtlar bile kurtarılabilirler (veri kurtarma konusunda bkz. _9. Bölüm_). Diğer taraftan, kaydedilmemiş bir değişikliği kaybederseniz büyük olasılıkla onu kurtarmanız mümkün olmaz.

## Uzak Uçbirimlerle Çalışmak ##

Bir Git projesine katkıda bulunabilmek için uzaktaki yazılım havuzlarını nasıl düzenleyeceğinizi bilmeniz gerekir. Uzaktaki yazılım havuzları, projenizin İnternet'te ya da başka bir ağda barındırılan sürümleridir. Birden fazla uzak yazılım havuzunuz olabilir, bunlardan her biri sizin için ya salt okunur ya da okunur/yazılır durumdadır. Başkalarıyla ortak çalışmak, bu yazılım havuzlarını düzenlemeyi, onlardan veri çekip (_pull_) onlara veri iterek (_push_) çalışmalarınızı paylaşmayı gerektirir.

Uzaktaki yazılım havuzlarınızı düzenleyebilmek için, projenize uzak yazılım havuzlarının nasıl ekleneceğini, kullanılmayan havuzların nasıl çıkarılacağını, çeşitli uzak dalları düzenlemeyi ve onların izlenen dallar olarak belirleyip belirlememeyi ve daha başka şeyleri gerektirir. Bu alt bölümde bu uzağı yönetme yeteneklerini inceleyeceğiz.

### Uzak Uçbirimleri Görüntüleme ###

Projenizde hangi uzak sunucuları ayarladığınızı görme için `git remote` komutunu kullanabilirsiniz. Bu komut, her bir uzak uçbirimin belirlenmiş kısa adını görüntüler. Eğer yazılım havuzunuzu bir yerden klonlamışsanız, en azından _origin_ uzak uçbirimini görmelisiniz —bu Git'in klonlamanın yapıldığı sunucuya verdiği öntanımlı addır.

	$ git clone git://github.com/schacon/ticgit.git
	Initialized empty Git repository in /private/tmp/ticgit/.git/
	remote: Counting objects: 595, done.
	remote: Compressing objects: 100% (269/269), done.
	remote: Total 595 (delta 255), reused 589 (delta 253)
	Receiving objects: 100% (595/595), 73.31 KiB | 1 KiB/s, done.
	Resolving deltas: 100% (255/255), done.
	$ cd ticgit
	$ git remote
	origin

`-v` seçeneğini kullanarak Git'in bu kısa ad için depoladığı URL'yi de görebilirsiniz:

	$ git remote -v
	origin	git://github.com/schacon/ticgit.git

Projenizde birden çok uzak uçbirim varsa, bu komut hepsini listeleyecektir. Örneğin, benim Git yazılım havuzum şöyle görünüyor:

	$ cd grit
	$ git remote -v
	bakkdoor  git://github.com/bakkdoor/grit.git
	cho45     git://github.com/cho45/grit.git
	defunkt   git://github.com/defunkt/grit.git
	koke      git://github.com/koke/grit.git
	origin    git@github.com:mojombo/grit.git

Bu demek oluyor ki bu kullanıcıların herhangi birinden kolaylıkla çekme işlemi (_pull_) yapabiliriz. Fakat dikkat ederseniz, yalnızca _origin_ uçbiriminin SSH URL'si var, yani yalnızca o havuza kod itebiliriz (_push_) (niye böyle olduğunu _4. Bölüm_'de inceleyeceğiz)

### Uzak Uçbirimler Eklemek ###

Önceki alt bölümlerde uzak uçbirim eklemekten söz ettim ve bazı örnekler verdim, ama bir kez daha konuyu açıkça incelemekte yarar var. Uzaktaki bir yazılım havuzunu kısa bir ad vererek eklemek için `git remote add [kisa_ad] [url]` komutunu çalıştırın:

	$ git remote
	origin
	$ git remote add pb git://github.com/paulboone/ticgit.git
	$ git remote -v
	origin	git://github.com/schacon/ticgit.git
	pb	git://github.com/paulboone/ticgit.git

Artık bütün bir URL yerine `pb`'yi kullanabilirsiniz. Örneğin, Paul'ün yazılım havuzunda bulunan ama sizde bulunmayan bütün bilgileri getirmek için `git fetch pb` komutunu kullanabilirsiniz:

	$ git fetch pb
	remote: Counting objects: 58, done.
	remote: Compressing objects: 100% (41/41), done.
	remote: Total 44 (delta 24), reused 1 (delta 0)
	Unpacking objects: 100% (44/44), done.
	From git://github.com/paulboone/ticgit
	 * [new branch]      master     -> pb/master
	 * [new branch]      ticgit     -> pb/ticgit

Paul'ün `mastertr` dalı sizin yazılım havuzunuzda da `pb/master` olarak erişilebilir durumdadır —kendi dallarınızdan biriyle birleştirebilir (_merge_) ya da bir yerel dal olarak seçip içeriğini inceleyebilirsiniz.

### Uzak Uçbirimlerden Getirme ve Çekme İşlemi Yapmak ###

Biraz önce gördüğünüz gibi, uzaktaki yazılım havuzlarından veri almak için şu komutu kullanabilirsiniz:

	$ git fetch [uzak-sunucu-adı]

Bu komut, söz konusu uzaktaki yazılım havuzuna gidip orada bulunup da sizin projenizde bulunmayan bütün veriyi getirir. Bunu yaptıktan sonra sizin projenizde o uzak yazılım havuzundaki bütün dallara referanslar oluşur —ki bunları birleştirme yapmak ya da içeriği incelemek için kullanabilirsiniz. (Dalların ne olduğunu ve onları nasıl kullanabileceğinizi _3. Bölüm_'de ayrıntılı biçimde inceleyeceğiz.)

Bir yazılım havuzunu klonladığınızda, klonlama komutu söz konusu kaynak yazılım havuzunu _origin_ adıyla uzak uçbirimler arasına ekler. Dolayısıyla, `git fetch origin` komutu, klonlamayı yaptığınızdan (ya da en son getirme işlemini (_fetch_) yatığınızdan) beri sunucuya itilmiş yeni değişiklikleri getirir. Unutmayın, `fetch` komutu veriyi yeler yazılım havuzunuza indirir —otomatik olarak sizin yaptıklarınızla birleştirmeye, ya da çalıştığınız şeyler üzerinde değişiklik yapmaya kalkışmaz. Hazır olduğunuzda birleştirme işlemini sizin yapmanız gerekir.

Uzaktaki bir dalı izlemek üzere ayarlanmış bir dalınız varsa (daha fazla bilgi için sonraki alt bölüme ve _3. Bölüm_'e bakınız) bu dal üzerinde `git pull` komutunu kullanarak uzaktaki yazılım havuzundaki veriyi hem getirip hem de mevcut dalınızla birleştirebilirsiniz. Bu çalışması daha kolay bir düzen olabilir; bu arada, `git clone ` komutu, otomatik olarak, yerel yazılım havuzunuzda, uzaktaki yazılım havuzunun `master` dalını takip eden bir `master` dalı oluşturur (uzaktaki yazılım havuzunun `master` adında bir dalı olması koşuluyla). `git pull` komutu genellikle yereldeki yazılım havuzunuza kaynaklık eden sunucudan veriyi getirip otomatik olarak üzerinde çalışmakta olduğunuz dalla birleştirir.

### Uzaktaki Yazılım Havuzuna Veri İtmek ###

Projeniz paylaşmak istediğiniz bir hale geldiğinde, yaptıklarınızı kaynağa itmeniz gerekir. Bunun için kullanılan komut basittir: `git push [uzak-sunucu-adi] [dal-adi]`. Projenizdeki `master` dalını `origin` sunucunuzdaki `master` dalına itmek isterseniz (yineleyelim; kolanlama işlemi genellikle bu isimleri otomatik olarak oluşturur), şu komutu kullanabilirsiniz:

	$ git push origin master

Bu komut, yalnızca yazma yetkisine sahip olduğunuz bir sunucudan klonlama yapmışsanız ve son getirme işleminizden beri hiç kimse itme işlemi yapmamışsa istediğiniz sonucu verir. Eğer sizinle birlikte bir başkası daha klonlama yapmışsa ve o kişi sizden önce itme yapmışsa, sizin itme işleminiz reddedilir. İtmeden önce sizden önce itilmiş değişiklikleri çekip kendi çalışmanızla birleştirmeniz gerekir. Uzaktaki yazılım havuzlarına itme yapmak konusunda daha ayrıntılı bilgi için bkz. _3. Bölüm_.

### Uzak Uçbirim Hakkında Bilgi Almak ###

Belirli bir uzak uçbirim hakkında daha fazla bilgi almak isterseniz `git remote show [ucbirim-adi]` komutunu kullanabilirsiniz. Bu komutu `origin` gibi belirli bir uçbirim kısa adıyla kullanırsanız şöyle bir sonuç alırsınız:

	$ git remote show origin
	* remote origin
	  URL: git://github.com/schacon/ticgit.git
	  Remote branch merged with 'git pull' while on branch master
	    master
	  Tracked remote branches
	    master
	    ticgit

Bu, uçbirimin URL'sini ve dalların izlenme durumunu gösterir. Komut, size, eğer `master` dalda iseniz ve `git pull` komutunu çalıştırırsanız, bütün referansları uzak uçbirimden indirip uzaktaki `master` dalından yerel `master` dalına birleştirme yapacağını da söylüyor. Ayrıca, ekmiş olduğu bütün uzak dalları da bir liste halinde veriyor.

Yukarıdaki verdiğimiz, basit bir örnekti. Git'i daha yoğun biçimde kullandığınızda, `git remote show` komutu çok daha fazla bilgi içerecektir:

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

Bu çıktı, belirli dallarda `git push` komutunu çalıştırdığınızda hangi dalların otomatik olarak itileceğini gösteriyor. Buna ek olarak uzak uçbirimde bulunup da sizin projenizde henüz bulunmayan uzak dalları, uzak uçbirimden silinmiş olduğu halde sizin projenizde bulunan dalları ve `git pull` komutunu çalıştırdığınızda otomatik olarak birleştirme işlemine uğrayacak birden çok dalı gösteriyor.

### Uzan Uçbirimleri Kaldırmak ve Yeniden Adlandırmak ###

Bir uçbirimin kısa adını değiştirmek isterseniz, Git'in yeni sürümlerinde bunu `git remote rename` komutuyla yapabilirsiniz. Örneğin, `pb` uçbirimini `paul` diye yeniden adlandırmak isterseniz, bunu `git remote rename`'i kullanarak yapabilirsiniz:

	$ git remote rename pb paul
	$ git remote
	origin
	paul

Bu işlemin uçbirim dal adlarını da değiştirdiğini hatırlatmakta yarar var. Bu işlemden önce `pb/master` olan dalın adı artık `paul/master` olacaktır.

Bir uçbirim referansını herhangi bir nedenle —sunucuyu taşımış ya da belirli bir yansıyı artık kullanmıyor olabilirsiniz; ya da belki katılımcılardan birisi artık katkıda bulunmuyordur— kaldırmak isterseniz `git remote rm` komutunu kullanabilirsiniz:

	$ git remote rm paul
	$ git remote
	origin

## Etiketleme ##

Çoğu SKS gibi Git'in de tarihçedeki belirli noktaları önemli olarak etiketleyebilme özelliği vardır. Genellikle insanlar bu işlevi sürümleri (`v1.0`, vs.) işaretlemek için kullanırlar. Bu alt bölümde mevcut etiketleri nasıl listeleyebileceğinizi, nasıl yeni etiketler oluşturabileceğinizi ve değişik etiket tiplerini öğreneceksiniz.

### Etiketlerinizi Listeleme ###

Git'te mevcut etiketleri listeleme işi epeyi kolaydır. `git tag` yazmanız yeterlidir:

	$ git tag
	v0.1
	v1.3

Bu komut etiketleri alfabetik biçimde sıralar; etiketlerin sırasının bir önemi yoktur.

İsterseniz belirli bir örüntüyle eşleşen etiketleri de arayabilirsiniz. Git kaynak yazılım havuzunda 240'tan fazla etiket vardır. Yalnızca 1.4.2 serisindeki etiketleri görmek isterseniz şu komutu çalıştırmalısınız:

	$ git tag -l 'v1.4.2.*'
	v1.4.2.1
	v1.4.2.2
	v1.4.2.3
	v1.4.2.4

### Etiket Oluşturma ###

Git iki başlıca etiket tipi kullanır: hafif ve açıklamalı. Hafif etiketler hiç değişmeyen dallar gibidir —belirli bir kaydı işaret ederler. Öte yandan, açıklamalı etiketler, Git veritabanında bütünlüklü nesneler olarak kaydedilirler. Sınama toplamları alınır; etiketleyenin adını ve e-posta adresini içerirler; bir etiket mesajına sahiptirler ve GNU Privacy Guard (GPG) kullanılarak imzalanıp doğrulanabilirler. Genellikle bütün bu bilgilere ulaşılabilmesini olanaklı kılabilmek için açıklamalı etiketlerin kullanılması önerilir, ama bütün bu bilgileri depolamadan yalnızca geçici bir etiket oluşturmak istiyorsanız, hafif etiketleri de kullanabilirsiniz.

### Açıklamalı Etiketler ###

Git'te açıklamalı etiket oluşturmak basittir. En kolayı `tag` komutunu çalıştırırken `-a` seçeneğini kullanmaktır:

	$ git tag -a v1.4 -m 'sürümüm 1.4'
	$ git tag
	v0.1
	v1.3
	v1.4

`-m` seçeneği etiketle birlikte depolanacak etiketleme mesajını belirlemek için kullanılır. Açıklamalı bir etiket için mesajı bu şekilde belirlemezseniz, Git mesajı yazabilmeniz için bir editör açacaktır.

`git show` komutunu kullanarak etiketlenen kayıtla birlikte etikete ilişkin verileri de görebilirsiniz:

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

Bu, kayıt bilgisinden önce etiketleyenle ilgili bilgileri, kaydın etiketlendiği tarihi ve açıklama mesajını gösterir.

### İmzalı Etiketler ###

Eğer bir kişisel anahtarınız (_private key_) varsa etiketlerinizi GPG ile imzalayabilirsiniz. Yapmanız gereken tek şey `-a` yerine `-s` seçeneğini kullanmaktır:

	$ git tag -s v1.5 -m 'imzalı 1.5 etiketim'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gee-mail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

Bu etiket üzerinde `git show` komutunu çalıştırırsanız, GPG imzasını da görebilirsiniz:

	$ git show v1.5
	tag v1.5
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 15:22:20 2009 -0800

	imzalı 1.5 etiketim
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

Birazdan imzalı etiketleri nasıl doğrulayabileceğinizi öğreneceksiniz.

### Hafif Etiketler ###

Kayıtları etiketlemenin bir yolu da hafif etiketler kullanmaktır. Bu, kayıt sınama toplamının bir dosyada depolanmasından ibarettir —başka hiçbir bilgi tutulmaz. Bir hafif etiket oluştururken `-a`, `-s` ya da `-m` seçeneklerini kullanmamalısınız.

	$ git tag v1.4-lw
	$ git tag
	v0.1
	v1.3
	v1.4
	v1.4-lw
	v1.5

Şimdi etiket üzerinde `git show` komutunu çalıştıracak olsanız, etiketle ilgili ek bilgiler görmezsiniz. Komut yalnızca kaydı gösterir:

	$ git show v1.4-lw
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

### Etiketleri Doğrulamak ###

İmzalı bir etiketi doğrulamak için `git tag -v [etiket-adi]` komutu kullanılır. Bu komut imzayı doğrulamak için GPG'yi kullanır. Bunun düzgün çalışması için imza sahibinin kamusal anahtarı (_public key_) anahtar halkanızda (_keyring_) bulunmalıdır.

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

Eğer imzalayıcının genel anahtarına sahip değilseniz, bunun yerine aşağıdakine benzer bir şey göreceksiniz:

	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Can't check signature: public key not found
	error: could not verify the tag 'v1.4.2.1'

### Sonradan Etiketleme ###

Geçmişteki kayıtları da etiketleyebilirsiniz. Diyelim ki Git tarihçeniz şöyle olsun:

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

Söz gelimi, "updated rakefile" kaydında projenizi `v1.2` olarak etiketlemeniz gerekiyordu, ama unuttunuz. Etiketi sonradan da ekleyebilirsiniz. O kaydı etiketlemek için komutun sonuna kaydın sınama toplamını (ya da bir parçasını) eklemelisiniz:

	$ git tag -a v1.2 9fceb02

Kaydın etiketlendiğini göreceksiniz:

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

### Etiketleri Paylaşmak ###

Aksi belirtilmedikçe `git push` komutu etiketleri uzak uçbirimlere aktarmaz. Etiketleri belirtik biçimde bir ortak sunucuya itmeniz gerekir. Bu süreç uçbirim dallarını paylaşmaya benzer —`git push origin [etiket-adi]` komutunu çalıştırabilirsiniz.

	$ git push origin v1.5
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	* [new tag]         v1.5 -> v1.5

Bir seferde birden çok etiketi paylaşmak isterseniz, `git push` komutuyla birlikte `--tags` seçeneğini de kullanabilirsiniz. Bu, halihazırda itilmemiş olan bütün etiketlerinizi uzak uçbirime aktaracaktır.

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

Artık başka biri sizin yazılım havuzunuzdan çekme yaptığında, bütün etiketlerinize de sahip olacaktır.

## İpuçları ##

Git'in temelleri hakkındaki bu bölümü tamamlamadan önce, Git deneyiminizi kolaylaştırabilmek için birkaç ipucu vermekte yarar var. Pek çok insan Git'i bu ipuçlarına başvurmadan kullanıyor; bu ipuçlarından ileride tekrar söz etmeyeceğimiz gibi bunları bilmeniz gerektiğini de varsaymıyoruz; ama yine de bilmeniz yararınıza olacaktır.

### Otomatik Tamamlama ###

Eğer Bash -shell_'ini kullanıyorsanız, Git'in otomatik tamamlama betiğini (_script_) kullanabilirsiniz. Git kaynak kodunu indirip `contrib/completion` klasörüne bakın; orada `git-completion.bash` adında bir dosya olmalı. Bu dosyayı ev dizininize (_home_) kopyalayıp `.bashrc` dosyanıza ekleyin:

	source ~/.git-completion.bash

Otomatik tamamlama özelliğinin bütün Git kullanıcıları için geçerli olmasını istiyorsanız, bu betik dosyasını Mac sistemler için `/opt/local/etc/bash_completion.d` konumuna Linux sistemlerde `/etc/bash_completion.d/` konumuna kopyalayın. Bu, Bash'ın otomatik olarak yükleyeceği betiklerin bulunduğu bir klasördür.

Eğer bir Windows kullanıcısıysanız ve Git Bash kullanıyorsanız- ki bu msysGit'le kurulum yaptığınızdaki öntanımlı programdır, otomatik tamamlama kendiliğinden gelecektir.

Bir Git komutu yazarken Sekme tuşuna bastığınızda, karşınıza bir dizi seçenek getirir:

	$ git co<selme><sekme>
	commit config

Bu örnekte, `git co` yazıp Sekme tuşuna iki kez basmak `commit` ve `config` komutlarını öneriyor. Komutun devamında `m` yazıp bir kez daha Sekme tuşuna basacak olursanız, komut otomatik olarak `git commit`'e tamamlanır.

Bu, seçeneklerde de kullanılabilir, ki muhtemelen daha yararlı olacaktır. Örneğin, `git log` komutunu çalıştırırken seçeneklerden birisini hatırlayamadınız, seçeneği yazmaya başlayıp Sekme tuşuna basarak eşleşen seçenekleri görebilirsiniz:

	$ git log --s<sekme>
	--shortstat  --since=  --src-prefix=  --stat   --summary

Bu güzel özellik sizi zaman kazandırabileceği gibi ikide bir belgelendirmeye bakma gereğini de ortadan kaldırır.

### Takma Adlar ###

Bir komutun bir kısmını yazdığınızda Git bunu anlamayacaktır. Komutların uzun adlarını kullanmak istemezseniz, `git config` komutunu kullanarak bunların yerine daha kısa takma adlar belirleyebilirsiniz. Kullanmak isteyebileceğiniz bazı takma adları buraya aldık:

	$ git config --global alias.co checkout
	$ git config --global alias.br branch
	$ git config --global alias.ci commit
	$ git config --global alias.st status

Bu durumda, örneğin,  `git commit` yazmak yerine `git ci` yazmanız yeterli olacaktır. Git'i kullandıkça sık kullandığınız başka komutlar da olacaktır, o zaman o komutlar için de takma adlar oluşturabilirsiniz.

Bu teknik, eksikliğini hissettiğiniz komutları oluşturmakta da yararlı olabilir. Örneğin, bir dosyayı hazırlık alanından kaldırmak için yapılması gerekenleri yeni bir komut olarak tanımlayabilirsiniz:

	$ git config --global alias.unstage 'reset HEAD --'

Bu durumda şu iki komut eşdeğer olacaktır:

	$ git unstage fileA
	$ git reset HEAD fileA

Biraz daha temiz değil mi? Bir `last` komutu eklemek de oldukça yaygındır:

	$ git config --global alias.last 'log -1 HEAD'

Böylece son kaydı kolaylıkla görebilirsiniz:

	$ git last
	commit 66938dae3329c7aebe598c2246a8e6af90d04646
	Author: Josh Goebel <dreamer3@example.com>
	Date:   Tue Aug 26 19:48:51 2008 +0800

	    test for current head

	    Signed-off-by: Scott Chacon <schacon@example.com>

Gördüğünüz gibi Git yeni komutu takma ad olarak belirlediğini şeyin yerine kullanıyor. Ama belki de bir Git komutu çalıştırmak değil de başka bir program kullanmak istiyorsunuz. Bu durumda komutun başına `!` karakterini koymalısınız. Bir Git yazılım havuzu üzerinde çalışan kendi araçlarınızı yazıyorsanız bu seçenek yararlı olabilir. Bunu göstermek için ,`gitk`'yi çalıştırmak için `git visual` diye yeni bir takma ad tanımlayabiliriz:

	$ git config --global alias.visual '!gitk'

## Özet ##

Bu noktada, bütün temel Git işlemlerini yapabiliyorsunuz —bir yazılım havuzunu yaratmak ya da klonlamak, değişiklikler yapmak, bu değişiklikleri kayda hazırlamak ve kaydetmek ve yazılım havuzundaki bütün kayıtların tarihçesini görüntülemek. Sıradaki bölümde Git'in en vurucu özelliğini, dallanma modelini inceleyeceğiz.
