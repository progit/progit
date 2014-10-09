# Uzak Serverda Git #

Şu anda, Git kullanırken günlük ihtiyacınız olacak işleri yapabiliyor olmalısınız. Ancak, Git üzerinde takım arkadaşlarınızla işbirliğinde bulunmak için bir uzak Git reposuna ihtiyacınız var. Diğer insanların yerel repoları üzerinde pull ya da push işlemleri yapmanız teknik olarak mümkün olsa da, bunu yapmak cesurcadır çünkü dikkatli olmazsanız insanların çalışmalarını karman çorman etmek oldukça kolaydır. Bunun dışında, ulaşmak istediğiniz Git reposunun sahibi offline olsa da ulaşabileceğiniz ve doğruluğu daha güvenilir ortak bir repo genellikle kullanışlı bir seçenektir. Bunun için, takım arkadaşlarıyla işbirliğinde tercih edilen en yaygın yöntem, takımdaki insanların yazma ve okuma izinlerinin olduğu ortak bir repo kullanmaktır. Bu ortak repoya bundan sonra "Git Sunucusu" diyeceğiz. Fakat yakında farkedeceğiniz üzere Git çok az sistem kaynağı kullanır ve bunun için bütün bir sunucu kullanmaya genelde gerek olmaz.

Bir Git Suncusu çalıştırmak kolaydır. Öncelikle, sunucunuzla hangi protokollerden iletişim kuracağınızı belirlemelisiniz. Bu bölümün ilk kısmında mevcut protokoller ve bunları artıları/eksilerinden bahsedeceğiz. Gelecek bölümlerde ise bu protokollerı kullanarak bazı tipik kurulumlarla sunucunuzu nasıl ayağa kaldıracağınızı anlatacağız. Son olarak, bazı hosted(3. kişiler tarafından barındırılan) servislerden bahsedeceğiz. Eger kodunuzun başka insanların sunucularında barınması sizin için problem değilse ve bakım-kurulum işleri ile uğraşmak istemiyorsanız bu seçenekleri de değerlendirebilirsiniz.

Eğer kendi sunucunuzu kurmak ile ilgilenmiyorsanız, doğrudan bu bölümün son kısmına geçebilir ve kullanabileceğiniz bazı servisleri görebilirsiniz. Sonrasında dağıtık kaynak kontrol ortamlarında çalışmanın getiri ve götürülerinden bahsedeceğimiz bir sonraki bölüme geçebilirsiniz.

Bir uzak repo _çıplak(bare) repo_ genellikle hiç bir şey eklenmemiş, boş bir haldedir. Repo yalnızca işbirliği noktası olarak kullanılacağından, projenin disk üzerinde bir kopyasını tutmak anlamsızdır. Yalnızca Git bilgisi yeterlidir. En basit anlatımıyla, çıplak repo projeinizin yalnızca `.git` klasörünü içerir.

## Protokoller ##

Git data transferi için başlıca dört adet ağ protokolü kullanır: Local, Secure Shell (SSH), Git and HTTP. Burada bu protokoller nedir ve temel koşullarda hangisini kullanmalıyız ya da kullanmamalıyoz tartışacağız.

Burada önemli olarak HTTP protokolünü ayrı tutacağız, çünkü Git kurulan bütün serverlerda HTTP protokolü bulunması gerekir.

### Lokal Protokoller ###

En temel olanı, uzak reponun diskimizdeki başka bir klasör olduğu lokal protokoldür. Bu genellikle ekibinizdeki herkes NFS mount vb. şeklinde paylaşılan dosyalara erişiyorsa veya az kullanılan bir yöntem olarak; işler herkesin kullanıcı girişi yaptığı bir bilgisayar üzerinde yürütülüyorsa kullanılır. İkincisi ideal olmaz, çünkü tüm repoların aynı bilgisayarda bulunması bir kayıpta felaket olurdu.

Eğer paylaşılan bir dosya sisteminiz varsa, local file-based reponuzdan clone,push ve pull işlemlerini yapabilirsiniz. Bunları yapmak için URL olarak reponuzun klasör yolunu kullanmalısınız. Örneğin, lokal repo kolanlayım, böyle bir komut çalıştırabilirsiniz.

	$ git clone /opt/git/project.git

Ya da:

	$ git clone file:///opt/git/project.git

Eğer URL'inizin başında açıkça `file://` belirtirseniz, Git biraz farklı çalışır. Sadece yolu belirtirseniz; ve kaynak ile hedef aynı dosya sisteminde ise, Git ihtiyacı olan objeleri hardlink ile bağlamaya çalışır. Eğer aynı dosya sisteminde değillerse; gerekli ihtiyacı olan dosyaları üzerinde bulunduğu sistemin standart kopyalama fonksiyonalitesini kullanarak kopyalayacaktır. Eğer `file://`ı belirtirseniz; Git normalde dosyaları transfer etmek için kullandığı ve daha verimsiz olan ağ üzerinden transfer yöntemini kullanmaz. `file://`ı belirtmenin ana sebebi genellikle başka bir versiyon kontrol sisteminden içe aktarma gibi işlemler yapıldıktan sonra (bakım işlemleri ile ilgili 9. bölümü inceleyin) yabancı referanslar ve kalıntı objeler içeren reponuzun temiz bir kopyasını almaktır. Biz daha hızlı olduğu için burada normal yolu kullanacağız.

Varolan bir Git projesine lokal repo eklemek için aşağıdaki gibi bir kod çalıştırmalısınız;

	$ git remote add local_proj /opt/git/project.git

Sonra, bir network üzerinden yapıyormuşsunuz gibi o remote üzerinde pull ve push yapabilirsiz.

#### Artıları ####

File-based depoların artıları basit olmaları ile mevcut dosya izinlerini ve ağ erişimini kullanabilir olmasıdır. Eğer paylaşılan bir dosya sisteminiz varsa, ekibiniz için bir repo kurmak çok kolay bir işlemdir. Herhangi diğer bir paylaşılan klasörde yaptığınız gibi, herkesin paylaşılan izinlerinin olduğu bare repo kopyasında kalırsınız ve yazma/okuma izinlerini ayarlayabilirsiniz. Bir sonraki bölümde “Serverda Git.” bare reponun kopyasını nasıl export alırız ele alacağız.

Bu aynı zamanda başkasının reposundan çalışmasını hızlıca almak için güzel bir seçenek. Eğer siz ve arkadaşınız aynı projede çalışıyorsanız onlar sizin yaptıklarınızı kontrol etmek isteyeceklerdir, bunun için `git pull /home/john/project` gibi bir komut çalıştırmak genellikle servera push etmek ve pull etmekten daha kolaydır.

#### Eksileri ####

Bu yöntemin eksileri genellikle paylaşılan erişimi kurmak ve bir çok yerden erişmek temel ağ erişiminden daha zordur. Eğer evinizdeki bilgisiyarınızdan uzak diskinize push etmek istiyorsanız ağ tabanlı erişim zor ve yavaş olabilir.

Eğer siz paylaşılan bir disk kullanıyorsanız hızlı olmasından söz edemeyiz. Eğer verilere hızlı erişiminiz varsa lokal reponuz hızlıdır. Aynı sunucuda NFS üzerindeki bir repo ile aynı sunucuda SSH üzerinden erişilen bir repoya göre genellikle daha yavaştır.