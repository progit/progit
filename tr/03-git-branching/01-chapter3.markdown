# Git'te Dallanma #

Neredeyse her SKS'nin bir dallanma (_branching_) işlevi vardır. Dallanma, ana geliştirme çizgisinden sapmak ve işinizi o ana geliştirme çizgisine bulaşmadan devam ettirmek anlamına gelir. Çoğu SKS aracında bu pahalı bir süreçtir; kaynak kod klasörünüzün yeni bir kopyasını yapmanızı gerektirir ve büyük projelerde çok zaman alır.

Bazıları Git'in dallanma modelinin onun "en vurucu özelliği" olduğunu söylerler; bu özelliğin SKS topluluğu içinde Git'i ayrı bir yere koyduğu doğrudur. Onu bu kadar özel yapan nedir? Git'te dallanmalar çok kolay ve neredeyse anlıktır, üstelik farklı dallar arasında gidip gelmek de bir o kadar hızlıdır. Çoğu SKS'den farklı olarak Git dallanma ve birleştirmenin (_merge_) sık (belki de günde birkaç kez) gerçekleşeceği bir iş akışını teşvik eder. Bu özelliği anlayıp bu konuda ustalaşmak size son derece becerikli ve eşsiz bir araç sağlayabileceği gibi çalışma biçiminizi de bütünüyle değiştirebilir.

## Dal Nedir? ##

Git'in dallanma işlemini nasıl yaptığını gerçekten anlayabilmek için geriye doğru bir adım atıp Git'in verilerini nasıl depoladığına bakmamız gerekiyor. 1. Bölüm'den hatırlayabileceğiniz üzere, Git verilerini bir dizi değişiklik olarak değil bir dizi bellek kopyası olarak depolar.

Git'te bir kayıt yaptığınızda, Git, kayda hazırladığınız içeriğin bellek kopyasına işaret eden imleci, yazar ve mesaj üstverisini ve söz konusu kaydın atalarını gösteren sıfır ya da daha fazla imleci (ilk kayıt için sıfır ata, normal bir kayıt için bir ata, iki ya da daha fazla dalın birleştirilmesinden oluşan bir kayıt için birden çok ata) içeren bir kayıt nesnesini depolar.

Bunu görselleştirmek için, üç dosyadan oluşan bir klasörünüzün olduğunu ve bu üç dosyayı da kayıt için hazırladığınızı varsayalım. Dosyaları kayda hazırlamak her bir dosyanın sınama toplamını alır (1. Bölüm'de söz ettiğimiz SHA-1 özeti), dosyanın o sürümünü Git yazılım havuzunda depolar (Git'te bunlara _blob_ denir (Ç.N. _blob_ Türkçe'ye damla ya da topak diye çevrilebilir, fakat kelimeyi olduğu gibi kullanmanın daha anlaşılır olacağını düşündük.)) ve sınama toplamını hazırlık alanına ekler:

	$ git add README test.rb LICENSE
	$ git commit -m 'initial commit of my project'

`git commit` komutunu çalıştırarak bir kayıt oluşturduğunuzda, Git her bir alt klasörün (bu örnekte yalnızca kök klasörün) sınama toplamını alır ve bu ağaç yapısındaki bu nesneleri yazılım havuzunda depolar. Git, daha sonra, üst veriyi ve ihtiyaç duyulduğunda bellek kopyasının yeniden yaratabilmek için ağaç yapısındaki nesneyi gösteren bir imleci içeren bir kayıt nesneyi yaratır.

Şimdi, Git yazılım havuzunuzda beş nesne bulunuyor: üç dosyanızın her biri için bir içerik _blob_'u, klasörün içeriğini listeleyen ve hangi dosyanın hangi _blob_'da depolandığı bilgisini içeren bir ağaç nesnesi ve o ağaç nesnesini gösteren bir imleci ve bütün kayıt üstverisini içeren bir kayıt nesnesi. Kavramsal olarak, Git yazılım havuzunuzdaki veri Figür 3-1'deki gibi görünür.

Insert 18333fig0301.png 
Figür 3-1. Tek kayıtlı yazılım havuzundaki veri.

Yeniden değişiklik yapıp kaydederseniz, yeni kayıt kendisinden hemen önce gelen kaydı gösteren bir imleci de depolar. İki ya da daha fazla kaydın sonunda tarihçeniz Figür 3-2'deki gibi görünür.

Insert 18333fig0302.png 
Figür 3-2. Birden çok kayıt sonunda Git nesne verisi.

Git'te bir dal, bu kayıtlardan birine işaret eden, yer değiştirebilen kıvrak bir imleçten ibarettir. Git'teki varsayılan dal adı `master`'dır. İlk kaydı yaptığınızda, son yaptığınız kaydı gösteren bir `master` dalına sahip olursunuz. Her kayıt yaptığınızda dal otomatik olarak son kaydı göstermek üzere hareket eder.

Insert 18333fig0303.png 
Figür 3-3. Dal kayıt verisinin tarihçesini gösteriyor.

Yeni bir dal oluşturduğunuzda ne olur? Yeni kayıtlarla ilerlemenizi sağlayan yeni bir imleç yaratılır. Söz gelimi, `testing` adında yeni bir dal oluşturalım. Bunu, `git branch` komutuyla yapabilirsiniz:

	$ git branch testing

Bu, şu an bulunduğunuz kayıttan hareketle yeni bir imleç yaratır (bkz. Figür 3-4).


Insert 18333fig0304.png 
Figür 3-4. Birden çok dal kayıt verisinin tarihçesini gösteriyor.

Git şu an hangi dalın üzerinde olduğunuzu nereden biliyor? `HEAD` adında özel bir imleç tutuyor. Unutmayın, buradaki `HEAD` Subversion ya da CVS gibi başka SKS'lerden alışık olduğunuz `HEAD`'den çok farklıdır. Git'te bu, üzerinde bulunduğunuz yerel dalı gösterir. Bu örnekte hâlâ `master` dalındasınız. `git branch` komutu yalnızca yeni bir dal yarattı —o dala atlamadı (bkz. Figür 3-5).

Insert 18333fig0305.png 
Figür 3-5. HEAD dosyası üzerinde bulunduğunuz dalı gösteriyor.

Varolan bir dala atlamak için `git checkout` komutunu çalıştırmalısınız. Gelin, `testing` dalına atlayalım:

	$ git checkout testing

Bu, `HEAD`'in `testing` dalını göstermesiyle sonuçlanır (bkz. Figür 3-6).

Insert 18333fig0306.png
Figür 3-6. Dal değiştirdiğinizde HEAD üzerinde olduğunuz dalı gösterir.

Bunun ne önemi var? Gelin bir kayıt daha yapalım:

	$ vim test.rb
	$ git commit -a -m 'made a change'

Figür 3-7 sonucu resmediyor.

Insert 18333fig0307.png 
Figür 3-7. HEAD'in gösterdiği dal her kayıtla ileri doğru hareket eder.

Burada ilginç olan `testing` dalı ilerlediği halde `master` dalı hâlâ dal değiştirmek için `git checkout` komutunu çalıştırdığınız zamanki yerinde duruyor. Gelin yeniden `master` dalına dönelim.

	$ git checkout master

Figür 3-8 sonucu gösteriyor.

Insert 18333fig0308.png 
Figür 3-8. Seçme (checkout) işlemi yapıldığında HEAD başka bir dalı gösterir.

Örnekteki komut iki şey yaptı. `HEAD` imlecini yeniden `master` dalını gösterecek şekilde hareket ettirdi ve çalışma klasörünüzdeki dosyaları `master`'ın gösterdiği bellek kopyasındaki hallerine getirdi. Bu demek oluyor ki, bu noktada yapacağınız değişiklikler projenin daha eski bir sürümünü baz alacak. Özünde, başka bir yöne gidebilmek için `testing` dalında yaptığınız değişiklikleri geçici olarak geri almış oldunuz.

Gelin bir değişiklik daha yapıp kaydedelim:

	$ vim test.rb
	$ git commit -a -m 'made other changes'

Şimdi proje tarihçeniz iki ayrı dala ıraksadı (bkz. Figür 3-9). Yeni bir dal yaratıp ona geçtiniz, bazı değişiklikler yaptınız; sonra ana dalınıza geri döndünüz ve başka bazı değişiklikler yaptınız. Bu iki değişiklik iki ayrı dalda birbirinden yalıtık durumdalar: iki dal arasında gidip gelebilir, hazır olduğunuzda bu iki dalı birleştirebilirsiniz. Bütün bunları yalnızca `branch` ve `checkout` komutlarını kullanarak yaptınız.

Insert 18333fig0309.png 
Figür 3-9. Dal tarihçeleri birbirinden ıraksadı.

Git'te bir dal işaret ettiği kaydın 40 karakterlik SHA-1 sınama toplamını içeren basit bir dosyadan ibaret olduğu için dalları yaratmak ve yok etmek oldukça masrafsızdır. Yeni bir dal yaratmak bir dosyaya 41 karakter (40 karakter ve bir satır sonu) yazmak kadar hızlıdır.

Bu, çoğu SKS'nin bütün proje dosyalarını yeni bir klasöre kopyalamayı gerektiren dallanma yaklaşımıyla keskin bir karşıtlık içindedir. Söz konusu yaklaşımda projenin boyutlarına bağlı olarak dallanma saniyeler, hatta dakikalar sürebilir; Git'te ise bu süreç her zaman anlıktır. Ayrıca, kayıt yaparken ata kayıtları da kaydettiğimiz için birleştirme sırasında uygun bir ortak payda bulma işi de otomatik olarak ve genellikle oldukça kolayca halledilir. Bu özellikler yazılımcıları sık sık dal yaratıp kullanmaya teşvik eder.

Neden böyle olması gerektiğine yakından bakalım.

## Dallanma ve Birleştirmenin Temelleri ##

Gelin, basit bir örnekle, gerçek hayatta kullanacağınız bir dallanma ve birleştirme işleyişinin üstünden geçelim. Şu adımları izleyeceksiniz:

1. Bir web sitesi üzerine çalışıyor olun.
2. Üzerinde çalıştığınız yeni bir iş parçası için bir dal yaratın.
3. Çalışmalarınızı bu dalda gerçekleştirin.

Bu noktada, sizden kritik önemde başka sorun üzerinde çalışıp hızlıca bir yama hazırlamanız istensin. Bu durumda şunları yapacaksınız:

1. Ana dalınıza geri dönün.
2. Yamayı eklemek için yeni bir dal oluşturun.
3. Testleri tamamlandıktan sonra yama dalını ana dalla birleştirip yayına verin.
4. Çalışmakta olduğunuz iş parçası dalına geri dönüp çalışmaya devam edin.

### Dallanmanın Temelleri ###

Önce, diyelim ki bir projede çalışıyorsunuz ve halihazırda birkaç tane kaydınız var (bkz. Figür 3-10).

Insert 18333fig0310.png 
Figür 3-10. Kısa ve basit bir kayıt tarihçesi.

Şirketinizin kullandığı sorun izleme programındaki #53 numaralı sorun üzerinde çalışmaya karar verdiniz. Açıklığa kavuşturmak için söyleyelim: Git herhangi bir sorun izleme programına bağlı değildir; ama #53 numaralı sorun üzerinde çalışmak istediğiniz başı sonu belli bir konu olduğu için, çalışmanızı bir dal üzerinde yapacaksınız. Bir dalı yaratır yaratmaz hemen ona geçiş yapmak için `git checkout` komutunu `-b` seçeneğiyle birlikte kullanabilirsiniz:

	$ git checkout -b iss53
	Switched to a new branch "iss53"

Bu, aşağıdaki iki komutun yerine kullanabileceğiniz bir kısayoldur:

	$ git branch iss53
	$ git checkout iss53

Figür 3-11 sonucu resmediyor.

Insert 18333fig0311.png 
Figür 3-11. Yeni bir dal imleci yaratmak.

Web sitesi üzerinde çalışıp bazı kayıtlar yapıyorsunuz. Bunu yaptığınızda `iss53` dalı ilerliyor, çünkü seçtiğiniz dal o (yani `HEAD` onu gösteriyor; bkz. Figür 3-12).

	$ vim index.html
	$ git commit -a -m 'added a new footer [issue 53]'

Insert 18333fig0312.png 
Figür 3-12. Çalışmamız sonucunda iss53 dalı ilerledi.

Şimdi, sizden web sitesindeki bir sorun için acilen bir yama hazırlamanız istensin. Git kullanıyorsanız, yamayı daha önce `iss53` dalında yaptığınız yaptığınız değişikliklerle birlikte yayına sokmanız gerekmez; yama üzerinde çalışmaya başlamadan önce söz konusu değişiklikleri geri alıp yayındaki web sitesini kaynak koduna ulaşabilmek için fazla çabalamanıza da gerek yok. Tek yapmanız gereken `master` dalına geri dönmek.

Ama, bunu yapmadan önce şunu belirtmekte yarar var: eğer çalışma klasörünüzde ya da kayda hazırlık alanında seçmek (_checkout_) istediğiniz dalla uyuşmazlık gösteren kaydedilmemiş değişiklikler varsa, Git dal değiştirmenize izin vermeyecektir. Dal değiştirirken çalışma alanınızı temiz olması en iyisidir. Bunun üstesinden gelmek için başvurulabilecek yolları (zulalama ve kayıt değiştirme gibi) daha sonra inceleyeceğiz. Şimdilik, bütün değişikliklerinizi kaydettiniz, dolayısıyla `master` dalına geçiş yapabilirsiniz.

	$ git checkout master
	Switched to branch "master"

Bu noktada, çalışma klasörünüz #53 numaralı sorun üzerinde çalışmaya başlamadan hemen önceki halindedir ve yamayı hazırlamaya odaklanabilirsiniz. Burası önemli: Git, çalışma klasörünüzü seçtiğiniz dalın gösterdiği kaydın bellek kopyasıyla aynı olacak şekilde ayarlar. Dal, son kaydınızda nasıl görünüyorsa çalışma klasörünü o hale getirebilmek için otomatik olarak dosyaları ekler, siler ve değiştirir.

Sırada, hazırlanacak yama var. Şimdi yama üzerinde çalışmak için bir `hotfix` dalı oluşturalım (bkz. Figür 3-13):

	$ git checkout -b 'hotfix'
	Switched to a new branch "hotfix"
	$ vim index.html
	$ git commit -a -m 'fixed the broken email address'
	[hotfix]: created 3a0874c: "fixed the broken email address"
	 1 files changed, 0 insertions(+), 1 deletions(-)

Insert 18333fig0313.png 
Figür 3-13. hotfix dalı master dalını baz alıyor.

Testlerinizi uygulayabilir, yamanızın istediğiniz gibi olduğundan emin olduktan sonra yayına sokabilmek için `master` dalıyla birleştirebilirsiniz. Bunun için `git merge` komutu kullanılır:

	$ git checkout master
	$ git merge hotfix
	Updating f42c576..3a0874c
	Fast forward
	 README |    1 -
	 1 files changed, 0 insertions(+), 1 deletions(-)

Birleştirme çıktısındaki "Fast forward" ifadesine dikkat. Birleştirdiğiniz dalın gösterdiği kayıt, üstünde bulunduğunuz dalın doğrudan devamı olduğundan, Git yalnızca imleci ileri alır. Başka bir deyişle, bir kaydı, kendi tarihçesinde geri giderek ulaşılabilecek bir başka kayıtla birleştiriyorsanız, Git ıraksayan ve birleştirilmesi gereken herhangi bir şey olmadığı için işleri kolaylaştırıp imleci ileri alır —buna "fast forward" (hızlı ileri alma) denir.

Yaptığınız değişiklik artık `master` dalı tarafından işaret edilen kaydın bellek kopyasındadır ve yayımlanabilir (bkz. Figür 3-14).

Insert 18333fig0314.png 
Figür 3-14. Birleştirmeden sonra master dalınız hotfix dalınızla aynı yeri gösterir.

Bu çok önemli yama yayımlandıktan sonra, kaldığınız yere geri dönebilirsiniz. Fakat önce `hotfix` dalını sileceksiniz, çünkü artık ona ihtiyacınız kalmadı —`master` dalı aynı yeri gösteriyor. `git branch` komutunu `-d` seçeneğiyle birlikte kullanarak silme işlemini yapabilirsiniz:

	$ git branch -d hotfix
	Deleted branch hotfix (3a0874c).

Şimdi kaldığınız yere geri dönebilir ve #53 numaralı sorun üzerinde çalışmaya devam edebilirsiniz (bkz. 3-15).

	$ git checkout iss53
	Switched to branch "iss53"
	$ vim index.html
	$ git commit -a -m 'finished the new footer [issue 53]'
	[iss53]: created ad82d7a: "finished the new footer [issue 53]"
	 1 files changed, 1 insertions(+), 0 deletions(-)

Insert 18333fig0315.png 
Figür 3-15. iss53 dalınız bağımsız olarak ilerleyebilir.

Şunu belirtmekte yarar var: `hotfix` dalında yaptığınız düzeltme `iss53` dalındaki dosyalarda bulunmuyor. Eğer bu değişikliği çekmek isterseniz, `git merge master` komutunu çalıştırarak `master` dalınızı `iss53` dalınızla birleştirebilirsiniz; alternatif olarak `iss53` dalındaki değişiklikleri `master`dalıyla birleştirmeye hazır hale getirene kadar bekleyebilirsiniz.

### Birleştirmenin Temelleri ###

Diyelim ki #53 numaralı sorunla ilgili çalışmanızı tamamladınız ve `master` dalıyla birleştirmeye hazırsınız. Bunu yapabilmek için `iss53` dalınızı, aynı `hotfix` dalını yaptığınız gibi birleştireceksiniz. Bütün yapmanız gereken birleştirmeyi gerçekleştirmek istediğiniz dalı seçmek (_checkout_) ve `git merge` komutunu çalıştırmak:

	$ git checkout master
	$ git merge iss53
	Merge made by recursive.
	 README |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Bu daha önce yaptığınız `hotfix` birleştirmesinden biraz farklı görünüyor. Burada, kayıt tarihçeniz daha eski bir noktadan ıraksamıştı. Üzerinde bulunduğunuz dalın gösterdiği kayıt birleştirmekte olduğunuz dalın doğrudan atası olmadığından Git'in biraz iş yapması gerekiyor. Bu örnekte Git, iki dalın en uç noktası ve ikisinin ortak atasının kullanıldığı üç taraflı basit bir birleştirme yapıyor. Figür 3-16, bu birleştirmede kullanılan üç farklı bellek kopyasını vurguluyor.

Insert 18333fig0316.png 
Figür 3-16. Git, dalları birleştirmek için en uygun ortak atayı buluyor.

Git, yalnızca dal imlecini ileri kaydırmak yerine üç taraflı birleştirmenin sonucunda ortaya çıkan bellek kopyası için otomatik bir kayıt oluşturuyor (bkz. Figür 3-17). Buna birleştirme kaydı denir ve özelliği birden çok atasının olmasıdır.

Git'in en uygun ortak atayı otomatik olarak bulduğunu vurgulamakta yarar var; bu kullanıcının en uygun ortak paydayı bulmak zorunda olduğu CVS ve Subversion'daki durumdan (1.5 sürümünden önceki haliyle) farklıdır. Bu Git kullanarak birleştirme yapmayı söz konusu diğer sistemlere göre çok daha kolay bir hale getirir.

Insert 18333fig0317.png 
Figür 3-17. Git, otomatik olarak, birleştirilmiş çalışmayı içeren yeni bir kayıt nesnesi yaratır.

Çalışmanız birleştirildiğine göre, artık `iss53` dalına ihtiyacınız kalmadı. Dalı silip, sorun izleme sisteminizdeki sorunu da kapatabilirsiniz:

	$ git branch -d iss53

### Temel Birleştirme Uyuşmazlıkları ###

Zaman zaman bu süreç o kadar da pürüzsüz ilerlemez. Eğer aynı dosyanın aynı bölümünü her iki dalda da değiştirmişseniz, Git temiz bir birleştirme yapamaz. #53 numaraları sorun için hazırladığınız düzeltme `hotfix`le aynı yazılım parçasını değiştiriyorsa, şuna benzer bir birleştirme uyuşmazlığıyla karşılaşırsınız:

	$ git merge iss53
	Auto-merging index.html
	CONFLICT (content): Merge conflict in index.html
	Automatic merge failed; fix conflicts and then commit the result.

Burada Git otomatik olarak yeni bir birleştirme kaydı oluşturmadı. Sizin uyuşmazlığı çözmenizi beklemek için sürece ara verdi. Bir birleştirme uyuşmazlığından sonra hangi dosyaların birleştirilmemiş olduğunu görmek için `git status` komutunu çalıştırabilirsiniz.

	[master*]$ git status
	index.html: needs merge
	# On branch master
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#	unmerged:   index.html
	#

Birleştirme uyuşmazlığı henüz çözümlenmemiş her şey _unmerged_ (birleştirilmemiş) olarak gösterilecektir. Git, dosyaları açıp uyuşmazlıkları çözümleyebilmeniz için standart uyuşmazlık çözümleme işaretçileri koyar. Dosyanızda şuna benzer bir bölümle karşılaşırsınız:

	<<<<<<< HEAD:index.html
	<div id="footer">contact : email.support@github.com</div>
	=======
	<div id="footer">
	  please contact us at support@github.com
	</div>
	>>>>>>> iss53:index.html

Burada , `HEAD`deki sürüm (ki bu `master` dalındaki sürümdür çünkü birleştirme komutunu bu daldan çalıştırdınız) üstte, (`=======` işaretinin üstündeki her şey), `iss53` dalındaki sürüm ise altta gösterilmektedir. Uyuşmazlığı çözümleyebilmek için bu ikisinden birini seçmeli, ya da birleştirmeyi istediğiniz gibi kendiniz düzenlemelisiniz. Söz gelimi, uyuşmazlığı çözmek için bütün bu kod bloğunun yerine şunu yerleştirebilirsiniz:

	<div id="footer">
	please contact us at email.support@github.com
	</div>

Çözümlemede iki taraftan da bir şeyler var ve `<<<<<<<`, `=======`, ve `>>>>>>>` işaretlerini içeren satırlar tamamen silinmiş durumda. Uyuşmazlık olan her bir dosyadaki her bir uyuşmazlık bloğunu çözümledikten sonra her dosyanın üzerinde `git add` komutunu çalıştırarak, uyuşmazlığın o dosya için çözülmüş olduğunu belirtebilirsiniz. Bir dosyayı ayda hazırlamak o dosyayı uyuşmazlığı çözümlenmiş olarak işaretler.
Uyuşmazlıkları çözümlemek için görsel bir araç kullanmak isterseniz `git mergetool` komutunu çalıştırabilirsiniz; bu komut size tek tek herbir uyuşmazlığı gösterecek uygun bir birleştirme aracını çalıştırır:

	$ git mergetool
	merge tool candidates: kdiff3 tkdiff xxdiff meld gvimdiff opendiff emerge vimdiff
	Merging the files: index.html

	Normal merge conflict for 'index.html':
	  {local}: modified
	  {remote}: modified
	Hit return to start merge resolution tool (opendiff):

Varsayılan aracın dışında bir araç kullanmak isterseniz (Git, Mac'te çalıştığım için bu örnekte `opendiff`'i seçti), Git'in desteklediği bütün birleştirme araçlarının listesini en üstte “merge tool candidates” yazısından hemen sonra görebilirsiniz. Kullanmak istediğiniz aracın adını yazın. 7. Bölüm'de kendi çalışma ortamınız için varsayılan değeri nasıl değiştirebileceğinizi inceleyeceğiz.

Birleştirme aracını kapattıktan sonra, Git size birleştirmenin başarılı olup olmadığını soracaktır. Eğer başarılı olduğunu söylerseniz, sizin yerinize dosyayı kayda hazırlayıp çözümlenmiş olarak işaretler.

Bütün uyuşmazlıkların çözümlendiğinden emin olmak için tekrar `git status` komutunu çalıştırabilirsiniz:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	modified:   index.html
	#

Durumdan memnunsanız ve uyuşmazlığı olan bütün dosyaların kayda hazırlandığından eminseniz, `git commit`'i kullanarak birleştirme kaydını tamamlayabilirsiniz. Öntanımlı kayıt mesajı şöyle görünür:

	Merge branch 'iss53'

	Conflicts:
	  index.html
	#
	# It looks like you may be committing a MERGE.
	# If this is not correct, please remove the file
	# .git/MERGE_HEAD
	# and try again.
	#

İleride bu birleştirme işlemini inceleyecek olanlar için yararlı olacağını düşünüyorsanız bu kayıt mesajını ayrıntılandırabilirsiniz —eğer aşikâr değilse, birleştirmeyi neden yaptığınızı, ve birleştirmede neler yaptığınızı açıklayabilirsiniz.

## Dal Yönetimi ##

Dal yaratma, birleştirme ve silme işlemlerini yaptığımıza göre, gelin şimdi de dallar üzerinde çalışırken işimize yarayacak kimi dal yönetim araçlarına göz atalım.

`git branch` komutu dal yaratmak ve silmekten fazlasını yapar. Bu komutu hiçbir seçenek kullanmadan çalıştırırsanız, mevcut dallarınızın bir listesini görürsünüz:

	$ git branch
	  iss53
	* master
	  testing

`master` dalının önündeki `*` karakterine dikkatinizi çekmiştir: bu, o dalı seçmiş olduğunuzu (_checkout_) gösteriyor. Yani, bu noktada bir kayıt yapacak olursanız, yeni değişikliğiniz `master` dalını ileri götürecek. Her bir dalın en son kaydının ne olduğunu görmek isterseniz `git branch -v` komutunu çalıştırabilirsiniz:

	$ git branch -v
	  iss53   93b412c fix javascript issue
	* master  7a98805 Merge branch 'iss53'
	  testing 782fd34 add scott to the author list in the readmes

Dallarınızın ne durumda olduğunu incelerken yararlı olacak bir başka şey de, hangi dalların üzerinde bulunduğunuz dalla birleştirilip hangisinin birleştirilmediğini görmek olabilir. `--merged` ve `--no-merge` seçenekleri Git'in 1.5.6 sürümünden itibaren kullanıma sunulmuştur. Hangi dalların üzerinde bulunduğunuz dalla birleştirilmiş olduğunu görmek için `git branch --merged` komutunu kullanabilirsiniz:

	$ git branch --merged
	  iss53
	* master

`iss53` dalını daha önce birleştirdiğiniz için listede görüyorsunuz. Bu listede önünde `*` olmayan dalları `git branch -d` komutuyla silebilirsiniz; onlardaki değişiklikleri zaten başka bir dalla birleştirdiğiniz için, herhangi bir kaybınız olmaz.

Henüz birleştirmediğiniz değişikliklerin bulunduğu dalları görmek için `git branch --no-merged` komutunu çalıştırabilirsiniz:

	$ git branch --no-merged
	  testing
Burada diğer dalı görüyorsunuz. Bu dalda henüz birleştirmediğiniz değişiklikler bulunduğu için `git branch -d` komutu hata verecektir:

	$ git branch -d testing
	error: The branch 'testing' is not an ancestor of your current HEAD.
	If you are sure you want to delete it, run 'git branch -D testing'.

Oradaki değişiklikleri kaybetmeyi göze alarak dalı her şeye rağmen silmek istiyorsanız, yukarıdaki çıktıda da belirtildiği gibi, `-D` seçeneğiyle üsteleyebilirsiniz.

## Dallanma İş Akışları ##

Dallanma ve birleştirmenin temellerine hakim olduğunuza göre, şimdi bu bilgiyi kullanarak neler yapabileceğimize bakalım. Bu alt bölümde masrafsız dallanmanın olanaklı kıldığı bazı yaygın iş akışları üzerinde duracağız, böylece bunları kendi geliştirme döngünüzde kullanıp kullanmamaya karar verebilirsiniz.

### Uzun Süreli Dallar ###

Git, basit üç taraflı birleştirme yaptığı için uzun bir zaman dilimi boyunca bir daldan diğerine çok sayıda birleştirme yapmak genellikle kolaydır. Yani, sürekli açık olan ve geliştirme döngünüzün değişik aşamalarında kullanabileceğiniz birkaç dal bulundurabilirsiniz; düzenli olarak bazılarından diğerlerine birleştirme yapabilirsiniz.

Git'i kullanan pek çok yazılımcı bu yaklaşımı benimser, `master` dalında yalnızca kararlı (_stable_) durumdaki kod bulunur —yalnızca yayımlanmış olan ya da yayımlanacak kod. `develop` ya da `next` adında, kararlılık testlerinin yürütüldüğü bir paralel dalları daha vardır —bu dal o kadar kararlı olmayabilir, fakat kararlı duruma getirildiğinde `master` dalına birleştirilir. Kısa ömürlü, belirli bir işlevin geliştirilmesine ayrılmış dalların (sizin `iss53` adlı dalınız gibi) hazır olduklarında birleştirilmeleri için —bütün testlerden geçtiklerinden ve yeni hatalara kapı aralamadıklarından emin olmak amacıyla— kullanılır.

Gerçekte, yazılım tarihçesinde ileri doğru hareket eden imleçlerden söz ediyoruz. Kararlı dallar eski kayıtları, güncel dallar çok daha yenilerini gösterir (bkz. Figür 3-18).

Insert 18333fig0318.png 
Figür 3-18. Daha kararlı dallar genellikle kayıt tarihçesinde daha geride bulunurlar.

Bu dalları, çalışma ambarları olarak hayal ediliriz, bir dizi kayıt bütünüyle test ediltikten sonra daha kararlı başka br ambara konulurlar (bkz. Figür 3-19).

Insert 18333fig0319.png 
Figure 3-19. Dalların ambarlar gibi olduğunu düşünebilirsiniz.

Çeşitli kararlılık seviyeleri tanımlayıp bu işleyişi o şekilde kullanabilirsiniz. Büyük projelerde `proposed` (önerilen) ya da `pu` (proposed updates - önerilen güncellemeler) adında bir dal daha olabilir. Bu dala, `next` ya da `master` dalına birleştirilecek kadar kararlı aşamada bulunmayan dallar birleştirilir. Sonuçta, dallar farklı kararlılık seviyelerinde bulunurlar; daha kararlı bir seviyeye ulaştıklarında, bir üstlerindeki dala birleştirilirler.
Tekrarlayalım: birden çok uzun ömürlü dal bulundurmak zorunlu değildir, ama, özellikle çok büyük ya da karmaşık projelerde çalışıyorsanız çoğunlukla yararlıdır.

### İşlev Dalları ###

İşlev dalları, her ölçekte proje için yararlıdır. İşlev dalları, belirli bir özellikle ilgili değişikliklerin geliştirilmesi için kullanılan kısa ömürlü dallardır. Başka SKS'lerde bu çok masraflı olduğu için, muhtemelen bu yaklaşımı daha önce benimsemediniz. Ama Git'te dal yaratmak, o dal üzerinde çalışmak, dalı birleştirmek ve daha sonra silmek, günde birkaç kez yapılan yaygın bir yöntemdir.

Bunu bir önceki alt bölümde `iss53` ve `hotfix` dalları üzerinde çalışırken gördünüz. Bu dallarda birkaç değişiklik yaptınız ve bu değişiklikleri `master` dalına birleştirdikten hemen sonra bu dalları sildiniz. Bu teknik sayesinde, bağlamlar arasında hızlı ve bütünlüklü geçişler yapabilirsiniz —çalışmalarınız belirli bir işlevin geliştirilmesine adanmış farklı ambarlara ayrılmış olduğundan, geçen süre zarfında, diyelim kod gözden geçirmesi sırasında neler olduğunu kolaylıkla görebilirsiniz. Değişikliklerinizi işlev dallarında dakikalarca, günlerce ya da aylarca tutabilir, hazır oldukları zaman, hangisinin dalın daha önce oluşturulduğuna aldırmadan birleştirebilirsiniz.

Diyelim ki `master` dalında çalışıyorsunuz, sonra bir hatayı gidermek için yeni bir dal oluşturuyorsunuz (`iss91`), derken aynı hatayı başka türlü gidermek için yeni bir dal oluşturuyorsunuz (`iss91v2`), sonra `master`'a geri dönüp biraz daha çalışıyorsunuz, sonra aklınıza gelen ama çok da gerekli olmadığını düşündüğünüz bir şeyle ilgili çalışmak için yeni bir dal oluşturuyorsunuz (`dumbidea`)... Kayıt tarihçeniz Figür 3-20'deki gibi görünecektir.

Insert 18333fig0320.png 
Figür 3-20. Birden çok işlev dalının bulunduğu kayıt tarihçeniz.

Şimdi diyelim ki, hatanın giderilmesinde ikinci çözümü (`iss91v2`) kullanmaya karar veriyorsunuz ve iş arkadaşlarınız `dumbidea` dalında yaptıklarınızı dahice buluyor. `iss91` dalınızı çöpe atabilir (C5 ve C6 kayıtlarını kaybedeceksiniz) diğer iki dalı birleştirebilirsiniz. Bu durumda tarihçeniz Figür 3-21'deki gibi görünecektir.

Insert 18333fig0321.png 
Figür 3-21. dumbidea ve iss91v2'yi birleştirdikten sonra kayıt tarihçeniz.

Unutmayın, bütün bunları yerel dallarda yapıyorsunuz. Dal yaratırken ve birleştirme yaparken her şey yalnızca yerel yazılım havuzunda gerçekleşiyor —hiçbir sunucu iletişimi olmuyor.

## Uzak Uçbirim Dalları ##

Yerel yazılım havuzunuzdaki uzak uçbirim dalları, uzak uçbirimlerdeki yazılım havuzlarınızın durumlarını gösteren imleçlerdir. Bunlar, hareket ettiremediğiniz yerel dallardır; yalnızca sunucuyla iletişim kurduğunuzda hareket ederler. Bu dallar, son bağlandığınızda sunucudaki yazılım havuzunun ne durumda olduğunu hatırlatan işaretçilerdir.

`(remote)`/`(dal)` biçimindedirler. Örneğin, sunucuya son bağlandığınızda `origin` uzak uçbirimindeki `master` dalının nasıl olduğunu görmek isterseniz, `origin/master` dalına bakmalısınız. Bir hatayı bir iş ortağıyla birlikte çözüyorsanız ve onlar `iss53` adında bir dalı sunucuya itmişlerse, sizin yerel dalınızın adı `iss53` iken, sunucuya itilmiş olan dalın adı `origin/iss53` olacaktır.

Bu biraz kafa karıştırıcı olabilir, gelin bir örnekle açıklayalım. Diyelim ki `git.şirketimiz.com` adresinde bir Git sunucunuz var. Buradan klonlama yaparsanız, Git bu yazılım havuzunu otomatik olarak `origin` olarak adlandıracak, bütün veriyi indirecek, onun `master` dalının gösterdiği kaydı gösteren `origin/master` adında hareket ettiremeyeceğiniz bir yerel dal oluşturacaktır. Git ayrıca,  üzerinde çalışabilmeniz için `origin`in `master` dalının olduğu yeri gösteren `master` adında yerel bir dal da oluşturacaktır (bkz. Figür 3-22).

Insert 18333fig0322.png 
Figür 3-22. Bir Git klonladığınızda hem yerel bir master dalınız hem de origin'in master dalını gösteren origin/master adında bir dalınız olur.

Eğer siz kendi master dalınızda çalışırken biir başkası `git.şirketimiz.com`'a itme yapıp `master` dalını güncellerse, tarihçeleriniz birbirinden farklılaşacaktır. Üstelik, `origin` sunucusuyla iletişime geçmediğiniz sürece sizin `origin/master` dalınız hareket etmeyecektir (bkz. Figür 3-23).

Insert 18333fig0323.png 
Figür 3-23. Siz yerelde çalışıyorken bir başkası sunucuya itme yaparsa, tarihçeleriniz birbirinden farklı hareket etmeye başlar.

Çalışmalarınızı eşitlemek için `git fetch origin` komutunu çalıştırabilirsiniz. Bu komut `origin` sunucusunun hangisi olduğuna bakar (bu örnekte `git.şirketimiz.com`), orada bulunup da sizde olmayan her türlü veriyi indirir, yerel veritabanınızı güncelleyip yerelinizdeki `origin/master` dalını yeni, güncel konumuna taşır (bkz. Figür 3-24).

Insert 18333fig0324.png 
Figür 3-24. git fetch komutu uzak uçbirim imleçlerinizi günceller.

Birden çok uzak uçbirime sahip bir projede uzak uçbirim imleçlerinin nasıl görüneceğini incelemek için, Scrum takımlarınızdan birisi tarafından kullanılan başka bir sunucunuzun daha olduğunu varsayalım. Bu sunucunun adresi `git.team1.şirketimiz.com` olsun. 2. Bölüm'de incelediğimiz gibi, bu sunucuyu projenize uzak uçbirim olarak eklemek için `git remote add` komutunu kullanabilirsiniz. Bu uçbirimin adı `teamone` olsun, ki bu adı daha sonra bütün URL yerine kısaltma olarak kullanacaksınız (bkz. Figür 3-25).

Insert 18333fig0325.png 
Figür 3-25. Başka bir sunucuyu uzak uçbirim olarak eklemek.

`teamone` uzak uçbiriminde bulunup da sizde bulunmayan şeyleri getirmek için `git fetch teamone` komutunu çalıştırabilirsiniz. O sunucuda bulunan veriler `origin` sunucusunda bulunanların alt kümesi olduğundan, Git herhangi bir veri çekmez, ama `teamone/master` adında, `teamone` sunucusunun `master` dalının gösterdiği kaydı gösteren bir uzak uçbirim dalı oluşturur (bkz. Figür 3-26).

Insert 18333fig0326.png 
Figür 3-26. teamone'nin master dalının pozisyonunu gösteren bir yerel imleciniz oluyor.

### İtme İşlemi ###

Bir daldaki çalışmalarınızı başkalarıyla paylaşmak istediğinizde, onu yazma yetkinizin olduğu bir uzak uçbirime itmelisiniz (_push_). yerel dallarınız otomatik olarak sunucuyla eşitlenmez —paylaşmak istediğiniz dalları açık şekilde itmelisiniz. Böylece, paylaşmak istemediğiniz dallar için özel yerel dallar kullanıp, yalnızca paylaşmak istediğiniz işlev dallarını iteblirsiniz.

Başkalarıyla ortaklaşa çalışmak istediğiniz `serverfix` adında bir dalınız varsa, onu da ilk dalınızı ittiğiniz gibi itebilirsiniz. `git push (remote) (branch)` komutunu çalıştırın.

	$ git push origin serverfix
	Counting objects: 20, done.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (15/15), 1.74 KiB, done.
	Total 15 (delta 5), reused 0 (delta 0)
	To git@github.com:schacon/simplegit.git
	 * [new branch]      serverfix -> serverfix

Bu bir tür kısayol sayılabilir. Git `serverfix` dal adını otomatik olarak `refs/heads/serverfix:refs/heads/serverfix` biçiminde açımlar, bu şu demektir: “yerel `serverfix` dalımı alıp uzak uçbirimin `serverfix` dalını güncellemek için kullan.” `refs/heads/` kısmınz 9. Bölüm'de ayrıntısıyla değineceğiz, ama genellikle bu kısmı kullanmasanız da olur. Aynı amaçla `git push origin serverfix:serverfix` komutunu da çalıştırabilirsiniz —bu da şu demektir: “Yereldeki serverfix'i al, bunu uzak uçbirimin serverfix'i yap.” Bu biçimi, yereldeki dal adıyla uzak uçbirimdeki dal adı farklı ise kullanabilirsiniz. Dal adının uzak uçbirimde `serferfix` olmasını istemezseniz `git push origin serverfix:awesomebranch` komutunu çalıştırarak yereldeki `serverfix` dalını uzak uçbirimdeki `awesomebranch` dalına itebilirsiniz.

Birlikte çalıştığınız insanlar sunucudan getirme işlemi (_fetch_) yaptıklarında,  sunucudaki `serverfix` sürümünün bulunduğu yeri gösteren `origin/serverfix` adında bir imlece sahip olacaklar.

	$ git fetch origin
	remote: Counting objects: 20, done.
	remote: Compressing objects: 100% (14/14), done.
	remote: Total 15 (delta 5), reused 0 (delta 0)
	Unpacking objects: 100% (15/15), done.
	From git@github.com:schacon/simplegit
	 * [new branch]      serverfix    -> origin/serverfix

Unutmayın, getirme (_fetch_) komutuyla yeni uzak uçbirim dallarını indirdiğinizde, yerelde otomatik olarak değiştirilebilir dallar oluşturulmaz. Başka bir deyişle, bu örnekte, `serverfix` adında bir dalınız olmaz, değiştiremeyeceğiniz `origin/serverfix` adında bir imleciniz olur.

Oradaki değişiklikleri üzerinde çalışmakta olduğunuz dala birleştirmek isterseniz, `git merge origin/serverfix` komutunu çalıştırabilirsiniz. Üzerinde çalışmak üzere kendinize ait bir `serverfix` dalınız olmasını isterseniz, uzak uçbirim dalını temel alabilirsiniz:

	$ git checkout -b serverfix origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

Bu, üzerinde çalışabileceğiniz ve `origin/serverfix`in gösterdiği yerden başlayan bir yerel dal yaratır.

### İzleme Dalları ###

Bir uzak uçbirim dalından yerel bir dal seçtiğinizde (_checkout_), bu işlem otomatik olarak bir _izleme dalı_ (_tracking branch_) oluşturur. İzleme dalları, uzak uçbirim dallarıyla doğrudan ilişkileri bulunan yerel dallardır. Bir izleme dalından `git push` komutunu çalıştırdığınızda , Git hangi sunucudaki hangi dala itme işlemi yapması gerektiğini bilir. Ayrıca, bu dallardan birinden `git pull` komutunu çalıştırdığınızda, bütün imleçler indirileceği gibi, bu izleme dalına karşılık gelen uzak uçbirim dalı da otomatik olarak bu dalla birleştirilir.

Bir yazılım havuzunu klonladığınızda, genellikle `origin/master` dalını izleyen bir `master` dalı yaratılır. Bu nedenle `git push` ve `git pull` komutları bu durumlarda ek argümanlara gerek kalmadan çalışırlar. Öte yandan, isterseniz başka izleme dalları da —`origin`'i ya da `master` dalınız izlemeyen dallar— oluşturabilirsiniz. Yukarıda basit bir örneğini gördük: `git checkout -b [dal] [uzak_ucbirim]/[dal]`. Git'in 1.6.2'den itibaren olan sürümlerinde `--track` kısayolunu da kullanabilirsiniz:

	$ git checkout --track origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

Uzak uçbirim dalının adından başka bir adla yerel dal oluşturmak isterseniz, yukarıdaki komutu farklı bir yerel dal adıyla kullanabilirsiniz:

	$ git checkout -b sf origin/serverfix
	Branch sf set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "sf"

Şimdi, yereldeki sf dalı, otomatik olarak `origin/serverfix` dalına itme ve çekme işlemi yapabilecek.

### Uzak Uçbirim Dallarını Silmek ###

Diyelim ki uzak bir dalla yapacaklarınız bitti ve siz ile takım arkadaşlarınız bir özelliği tamamlayıp sizin uzaktaki `master` dalınıza (veya kararlı kodunuzun olduğu herhangi bir dalda) birleştirdi. Bir uzak dalı `git push [uzakadı] :[dal]` sabit sözdizimini kullanarak silebilirsiniz. Eğer sunucudan `serverfix` dalını silmek isterseniz, şu komutu çalıştırın:

	$ git push origin :serverfix
	To git@github.com:schacon/simplegit.git
	 - [deleted]         serverfix

İşte bu! Artık sunucunuzda bu dal olmayacak. Bu sayfayı dikkatlice anlamak isteyebilirsiniz, çünkü muhtemelen bu komuta ihtiyacınız olacak ancak sözdizimini unutacaksınız. Bu komutu hatırlamanın bir yolu daha önceden biraz bahsedilen `git push [uzakadı] [yereldal]:[uzakdal]` sözdizimini hatırlamaktır. Eğer `[yereldal]` kısmını yazmazsanız, aslında dediğiniz şey “Benim tarafımdan bir şey alma ancak `[uzakdal]`dan al.”

## Rebasing (Tekrar Adresleme) ##

Git içerisinde, değişiklikleri bir daldan diğerine bütünleştirmek için iki temel yol bulunuyor: `merge` ve `rebase`. Bu bölümde sadece rebase komutunun ne olduğunu, nasıl yapılacağını, neden mükemmel bir araç olduğunu ve hangi durumlarda kullanmak istemeyeceğinizi öğreneceksiniz.

### Temel Tekrar Adresleme ###

Birleştirme kısmındaki örneğe geri giderseniz (Figür 3-27'ye bakın), çalışmanızı ayırdığınızı ve iki farklı dal üzerinde gönderi yaptığınızı görebilirsiniz.

Insert 18333fig0327.png 
Figure 3-27. İlk ayrılan gönderi geçmişi.

Dalları bütünlemenin en kolay yolu - daha önceden anlattığımız gibi - `merge` komutudur. Bu komut, en son iki dal bellek kopyası (C3 ve C4) ve ikisinin en yakın ortak atası (C2) arasında üç yönlü bir birleştirme yapar. Bunun sonucunda yeni bir bellek kopyası (ve gönderi) oluşturur. Bkz. Figür 3-28.

Insert 18333fig0328.png 
Figure 3-28. Ayrılmış çalışma geçmişini bütünleştirmek için bir dal birleştirmek.

However, there is another way: you can take the patch of the change that was introduced in C3 and reapply it on top of C4. In Git, this is called _rebasing_. With the `rebase` command, you can take all the changes that were committed on one branch and replay them on another one.

In this example, you’d run the following:

	$ git checkout experiment
	$ git rebase master
	First, rewinding head to replay your work on top of it...
	Applying: added staged command

It works by going to the common ancestor of the two branches (the one you’re on and the one you’re rebasing onto), getting the diff introduced by each commit of the branch you’re on, saving those diffs to temporary files, resetting the current branch to the same commit as the branch you are rebasing onto, and finally applying each change in turn. Figure 3-29 illustrates this process.

Insert 18333fig0329.png 
Figure 3-29. Rebasing the change introduced in C3 onto C4.

At this point, you can go back to the master branch and do a fast-forward merge (see Figure 3-30).

Insert 18333fig0330.png 
Figure 3-30. Fast-forwarding the master branch.

Now, the snapshot pointed to by C3' is exactly the same as the one that was pointed to by C5 in the merge example. There is no difference in the end product of the integration, but rebasing makes for a cleaner history. If you examine the log of a rebased branch, it looks like a linear history: it appears that all the work happened in series, even when it originally happened in parallel.

Often, you’ll do this to make sure your commits apply cleanly on a remote branch — perhaps in a project to which you’re trying to contribute but that you don’t maintain. In this case, you’d do your work in a branch and then rebase your work onto `origin/master` when you were ready to submit your patches to the main project. That way, the maintainer doesn’t have to do any integration work — just a fast-forward or a clean apply.

Note that the snapshot pointed to by the final commit you end up with, whether it’s the last of the rebased commits for a rebase or the final merge commit after a merge, is the same snapshot — it’s only the history that is different. Rebasing replays changes from one line of work onto another in the order they were introduced, whereas merging takes the endpoints and merges them together.

### More Interesting Rebases ###

You can also have your rebase replay on something other than the rebase branch. Take a history like Figure 3-31, for example. You branched a topic branch (`server`) to add some server-side functionality to your project, and made a commit. Then, you branched off that to make the client-side changes (`client`) and committed a few times. Finally, you went back to your server branch and did a few more commits.

Insert 18333fig0331.png 
Figure 3-31. A history with a topic branch off another topic branch.

Suppose you decide that you want to merge your client-side changes into your mainline for a release, but you want to hold off on the server-side changes until it’s tested further. You can take the changes on client that aren’t on server (C8 and C9) and replay them on your master branch by using the `--onto` option of `git rebase`:

	$ git rebase --onto master server client

This basically says, “Check out the client branch, figure out the patches from the common ancestor of the `client` and `server` branches, and then replay them onto `master`.” It’s a bit complex; but the result, shown in Figure 3-32, is pretty cool.

Insert 18333fig0332.png 
Figure 3-32. Rebasing a topic branch off another topic branch.

Now you can fast-forward your master branch (see Figure 3-33):

	$ git checkout master
	$ git merge client

Insert 18333fig0333.png 
Figure 3-33. Fast-forwarding your master branch to include the client branch changes.

Let’s say you decide to pull in your server branch as well. You can rebase the server branch onto the master branch without having to check it out first by running `git rebase [basebranch] [topicbranch]` — which checks out the topic branch (in this case, `server`) for you and replays it onto the base branch (`master`):

	$ git rebase master server

This replays your `server` work on top of your `master` work, as shown in Figure 3-34.

Insert 18333fig0334.png 
Figure 3-34. Rebasing your server branch on top of your master branch.

Then, you can fast-forward the base branch (`master`):

	$ git checkout master
	$ git merge server

You can remove the `client` and `server` branches because all the work is integrated and you don’t need them anymore, leaving your history for this entire process looking like Figure 3-35:

	$ git branch -d client
	$ git branch -d server

Insert 18333fig0335.png 
Figure 3-35. Final commit history.

### The Perils of Rebasing ###

Ahh, but the bliss of rebasing isn’t without its drawbacks, which can be summed up in a single line:

**Do not rebase commits that you have pushed to a public repository.**

If you follow that guideline, you’ll be fine. If you don’t, people will hate you, and you’ll be scorned by friends and family.

When you rebase stuff, you’re abandoning existing commits and creating new ones that are similar but different. If you push commits somewhere and others pull them down and base work on them, and then you rewrite those commits with `git rebase` and push them up again, your collaborators will have to re-merge their work and things will get messy when you try to pull their work back into yours.

Let’s look at an example of how rebasing work that you’ve made public can cause problems. Suppose you clone from a central server and then do some work off that. Your commit history looks like Figure 3-36.

Insert 18333fig0336.png 
Figure 3-36. Clone a repository, and base some work on it.

Now, someone else does more work that includes a merge, and pushes that work to the central server. You fetch them and merge the new remote branch into your work, making your history look something like Figure 3-37.

Insert 18333fig0337.png 
Figure 3-37. Fetch more commits, and merge them into your work.

Next, the person who pushed the merged work decides to go back and rebase their work instead; they do a `git push --force` to overwrite the history on the server. You then fetch from that server, bringing down the new commits.

Insert 18333fig0338.png 
Figure 3-38. Someone pushes rebased commits, abandoning commits you’ve based your work on.

At this point, you have to merge this work in again, even though you’ve already done so. Rebasing changes the SHA-1 hashes of these commits so to Git they look like new commits, when in fact you already have the C4 work in your history (see Figure 3-39).

Insert 18333fig0339.png 
Figure 3-39. You merge in the same work again into a new merge commit.

You have to merge that work in at some point so you can keep up with the other developer in the future. After you do that, your commit history will contain both the C4 and C4' commits, which have different SHA-1 hashes but introduce the same work and have the same commit message. If you run a `git log` when your history looks like this, you’ll see two commits that have the same author date and message, which will be confusing. Furthermore, if you push this history back up to the server, you’ll reintroduce all those rebased commits to the central server, which can further confuse people.

If you treat rebasing as a way to clean up and work with commits before you push them, and if you only rebase commits that have never been available publicly, then you’ll be fine. If you rebase commits that have already been pushed publicly, and people may have based work on those commits, then you may be in for some frustrating trouble.

## Özet ##

Git'in temel branch ve merge işlemlerinden bahsettik. Artık rahatça yeni branch oluşturabilir, branchler arasından geçiş yapabilir ve local branchler ile merge işlemi yapabilirsiniz. Aynı zamanda branchlerinizi paylaşılan bir sunucuya göndererek paylaşabilmelisiniz ya da başkalarıyla ortak branchlerde çalışabilmeli ve branchlerinizi paylaşmadan önce rebase edebilmelisiniz.
