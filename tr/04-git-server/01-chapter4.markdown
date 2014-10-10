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

### SSH Protokolü ###

Git için en yaygın transfer protokolü SSH'dır. Çünkü SSH erişimi zaten bir çok yerde kuruludur, eğer kurulu değilse de kurulumu gayet kolaydır. SSH yalnızca ağ tabanlı bir protokoldür kolayca okuyabilir ve yazabilirsiniz. Diğer iki ağ protokolü (HTTP ve Git) genellikle sadece okunur, bundan dolayı bunlar dışarıya açık olsa bile, kendi komutlarını yazmak için hala SSH'a ihtiyacı vardır. SSH doğrulanmış bir ağ protokolüdür. Çünkü her yerde bulunur ayrıca kurulumu ve kullanımı kolaydır.

Git reposunu SSH üzerinden clonelarken, URL'i ssh:// şeklinde belirtmelisiniz. Örnek:

	$ git clone ssh://user@server/project.git

Ya da SSH için kısaca scp-like yazımını kullanabilirsiniz:

	$ git clone user@server:project.git

Siz bir kullanıcı belirlemezseniz, Git geçerli oturum açmış olan kullanıcıyı varsayar.

#### Artıları ####

SSH kullanmanızın çok fazla artıları vardır. İlk olarak, temelde kullandığınız bir ağ üzerinden doğrulanmış bir kimlik ile dosyalara yazma erişiminiz olur. İkincisi, SSH kurmak kolaydır, birçok ağ yöneticileri SHH ile ilgili deneyime sahiptir ve birçok işletim sistemi dağıtımlarının SSH kurmak ve yönetmek için araçları vardır. Bir diğeri SSH üzerinden tüm veri transferi şifrelenir ve doğrulanır. Son olarak SSH'ın bir artısı da verileri akatarmadan önce mümkün olduğunca kompakt hale getiriyor.

#### Eksileri ####

Negatif yönlerinden bir tanesi reponuza anonim erişim sağlanamaz. İnsanların sizin open source projenize erişebilmesi için SSH üzerinden erişimleri olması gerekmektedir.Yalnızca kurumsal ağ içerisinde bunu kullanıyorsanız SSH kullanmanız gereken protokollerden belki de tekidir. Eğer bir projeye anonim erişimi vermek istiyorsanız push ve pull işlerimleri için SSH kurmanız gerekecektir.

### Git Protokolü ###

Sonraki Git Protokolüdür. Git ile paketlenmiş olarak gelen servistir. SSH protokolüne benzer bir hizmet sunar 9418 portunu dinler fakat kimlik doğrulaması gerektirmez. In order for a repository to be served over the Git protocol, you must create the `git-daemon-export-ok` file — the daemon won’t serve a repository without that file in it — but other than that there is no security. Either the Git repository is available for everyone to clone or it isn’t. This means that there is generally no pushing over this protocol. You can enable push access; but given the lack of authentication, if you turn on push access, anyone on the internet who finds your project’s URL could push to your project. Suffice it to say that this is rare.

#### Artıları ####

Git Protokol'ü mevcut en hızlı transfer protokolüdür. Eğer kimlik doğrulaması gerektirmeyen büyük bir projeniz varsa Git protokolü kullanmak doğru seçim olacaktır. Git Protokol'ü şifreleme ve kimlik doğrulama olmadan aynı mekanızmayı kullanır.

#### Eksileri ####

Git Protokolü'nün olumsuz yönlerinden bir tanesi doğrulama olmamasıdır. Projeye tek erişim olması istenmeyen bir durumdur. Genellik push (yazma) erişimine sahip geliştiriciler için SSH ile eşleştirme gerekir ve herkes  `git://` kullanır.
Muhtemelen kurulumu en zor olan protokoldür. It must run its own daemon, which is custom — bu bölümün kurulumuna “Gitosis” kısmında değineceğiz — it requires `xinetd` configuration or the like, which isn’t always a walk in the park. 9418 portuna erişebilmek için bir güvenlik duvarı karşınıza çıkacaktır bu port genellikle izin verilen bir port değildir. Büyük kurumların arkasındaki firewall'lar genellikle bu portu tanımaz ve bloke ederler.

### HTTP / S Protokolü ###

Son olarak HTTP / S Protokolü. Kurulum basitliği açısından en güzeli HTTP ya da HTTPS protokolüdür. Basically, all you have to do is put the bare Git repository under your HTTP document root and set up a specific `post-update` hook, and you’re done (Git hook hakkında bilgi için 7. bölüme bakınız). At that point, anyone who can access the web server under which you put the repository can also clone your repository. HTTP üzerinden reponuza erişim izni vermek için:

	$ cd /var/www/htdocs/
	$ git clone --bare /path/to/git_project gitproject.git
	$ cd gitproject.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

That’s all. The `post-update` hook that comes with Git by default runs the appropriate command (`git update-server-info`) to make HTTP fetching and cloning work properly. SSH üzerinden bir repo pushlamak için bu komut çalıştırılır, ardından diğer insanlarda bu komut ile clonelayabilir.

	$ git clone http://example.com/gitproject.git

In this particular case, we’re using the `/var/www/htdocs` path that is common for Apache setups, but you can use any static web server — just put the bare repository in its path. Git verileri statik dosyalar olarak tutulur. (detaylar için bölüm 9'a bakınız).

HTTP üzerinden push yapmak mümkündür, yaygın olarak kullanılan bir teknik değildir ve karışık WebDAV gereksinimleri kurmayı gerektirir. Nadiren kullanıldığı için kitapta yer almıyor. Eğer HTTP ile push yapmak ile ilgileniyorsanız konu ile ilgili `http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt` linkini inceleyebilirsiniz. Bir diğer nokta eğer sunucunuz yazma ve güncelleme işlemleri için WebDAV destekliyorsa, belirli Git özellikleri olmadan, herhangi bir WebDAV sunucusu kullanabilirsiniz;

#### Artıları ####

En temel artısı kurulumu kolaydır. Sunduğu bir çok komut ile  Git reponuza ulşamak için kolaylıklar sağlar. Ve bunu yapmak sadece birkaç dakika sürer. HTTP protokolü sunucunuz üzerinde bir yoğunluk yapmaz. Çünkü genellikle statik bir HTTP sunucusu kullanır, bir Apache server saniye binlerce dosya transfer edebilir fakat küçük sunucular için bu zor olabilir.

You can also serve your repositories read-only over HTTPS, which means you can encrypt the content transfer; or you can go so far as to make the clients use specific signed SSL certificates. Generally, if you’re going to these lengths, it’s easier to use SSH public keys; but it may be a better solution in your specific case to use signed SSL certificates or other HTTP-based authentication methods for read-only access over HTTPS.

Bir diğer güzel üzelliği de HTTP protokolü firewall tarafından tanınan yaygın bir protokoldür.

#### Eksileri ####

HTTP üzerinden reponuz için hizmet almanızın olumsuz yanı verimsiz olmasıdır. Genellikle klonlama işlemleri uzun sürer ve diğer ağ protokollerinden daha fazla ağ hacmi vardır. Because it’s not as intelligent about transferring only the data you need — there is no dynamic work on the part of the server in these transactions — the HTTP protocol is often referred to as a _dumb_ protocol. HTTP protokolü ve diğer protokoller hakkında verimlilik karşılaştırmaları için bölüm )'a bakınız.

## Server'da Git ##

Başlangıçta bir Git serverını ayarlamak için; varolan bir  repoyu henuz hiç bir şey içermeyen, yeni bir repoya aktarmalısnız. 
Yeni bir boş repo oluşturmak için, `--bare` seçeneği ile komutu çalıştırın. 

	$ git clone --bare my_project my_project.git
	Cloning into bare repository 'my_project.git'...
	done.

Şuan  `my_project.git` dizininde Git dizinin bir kopyası bulunmaktadır.

Bu komutta aynı işlemi yapar

	$ cp -Rf my_project/.git my_project.git

Configrasyon dosyamızda birkaç küçük farklılık vardır; but for your purpose, this is close to the same thing. Bir çalışma dizini olmadan kendi başına Git deposunu alır, ve yalnız bunun için özel bir dizin oluşturur.

### Server'a Boş Bir Dizin Oluşturmak ###

Elimizde bol bir dizinimiz var, tüm yapmamız gereken bunu server'a koymak ve protokol ayarlarını yapmak. SSH erişimi olan ve `git.example.com` adında bir server kurduğumuzu varsayalım, ve `/opt/git` dizini altında tüm depolarımızı saklayalım. Boş reponuzu kopyalayarak yeni repo oluşturabilirsiniz:

	$ scp -r my_project.git user@git.example.com:/opt/git

Bu noktada `/opt/git` dizinine okuma ve SSH erişimi olan kullanıcılar aşağıdaki komut ile reponuzu klonlayabilir

	$ git clone user@git.example.com:/opt/git/my_project.git

Bir kullanıcnın server içinde SSHs ve `/opt/git/my_project.git` dizinine yazma erişimi varsa, otomatik olarak push yapma izni olacaktır. Eğer `git init` komutunu `--shared` seçeneği ile çalıştırırsanız Git uygun olarak izinleri verecektir.

	$ ssh user@git.example.com
	$ cd /opt/git/my_project.git
	$ git init --bare --shared

Git üzerinde boş bir repo oluşturmak ve SSH izinleri vermenin ne kadar kolay olduğunu gördünüz. Şimdi projelerde birlikte çalışabilirsiniz.

It’s important to note that this is literally all you need to do to run a useful Git server to which several people have access — just add SSH-able accounts on a server, and stick a bare repository somewhere that all those users have read and write access to. You’re ready to go — nothing else needed.

Önümüzdeki bölümlerde, daha sofistike kurulumları göreceğiz. Bunlar kullanıcı izinleri, web UI kurmak, Gitosis aracını kullanarak ve daha fazla, her kullanıcı için kullanıcı hesapları oluşturmak zorunda değiliz gibi konular. However, keep in mind that to collaborate with a couple of people on a private project, all you _need_ is an SSH server and a bare repository.

### Küçük Ayarlar ###

Eğer kuruluşunuza Git ile çalışıyorsanız ve birkaç developer varsa bu işler sizin için kolay olabilir. Bir Git sunucusu kurmanın en karmaşık yönlerinden biri, kullanıcı yönetimidir. Bazı repolar için belirli kullanıcılara okuma bazılarına okuma/yazma erişimi vermek istiyorsanız izinleri düzenlemek zor olabilir.

#### SSH Erişimi ####

Eğer mevcut server'ınıza tüm developerların SSH erişimi var ise ilk repo kurulumu için pek bir iş yapmanız gerekmiyor (son bolumde bahsettiğimiz gibi). Eğer daha complex erişim izinleri istiyorsanız, sunucuda çalışan işletim sisteminin normal dosya sistemi izinleri ile düzenleyebilirsiniz.

If you want to place your repositories on a server that doesn’t have accounts for everyone on your team whom you want to have write access, o zaman onlar için SSH erişimi kurmanız gerekiyor. Biz bunu yapmak için SSH sunucusunun yüklü olduğu bir sunucunuz varsayalım.

Takımdaki herkese erişim vermenin birkaç yolu vardır. İlki basittir ama biraz zahmetli olabilir, herkes için bir hesap oluşturmak. `adduser` çalıştırmak ve her kullanıcı için geçici parolalar oluşturmak istemeyebilirsiniz..

İkinci method tek bir 'git' kullanıcısı oluşturmak, ask every user who is to have write access to send you an SSH public key, and add that key to the `~/.ssh/authorized_keys` file of your new 'git' user. Bu noktada, herkes 'git' kullanıcısı ile bu makineye erişebilecek. This doesn’t affect the commit data in any way — the SSH user you connect as doesn’t affect the commits you’ve recorded.

Bunu yapmanın bir başka yolu, bir LDAP sunucusuna veya zaten kurdunuz bazı diğer merkezi kimlik doğrulama kaynağından SSH sunucusu kimlik doğrulamasına sahip olmaktır. Böylece her kullanıcı makine üzerinden shell erişimi alabilir.

## SSH Key Oluşturmak ##

Git serverlerda kimlik doğrulaması için SSH public keys kullanıyor. Eğer oluşturulmuş yoksa her kullanıcı için sistem bir key oluşturur. İlk olarak hazırda bir key var mı kontrol edilir. Varsayılan olarak, bir kullanıcının SSH anahtarları o kullanıcının ~ /. ssh dizininde depolanır. Eğer oluşturulmuş bir key varsa onu kolayca listeleyebilirsiniz.

	$ cd ~/.ssh
	$ ls
	authorized_keys2  id_dsa       known_hosts
	config            id_dsa.pub

Dosyalarına baktığında iki şey arıyoruz something and something.pub, burada genellikle bir şey `id_dsa` or `id_rsa`.  `.pub` dosya ortak anahtardır, ve diğer dosyaların özel anahtarıdır. Eğer bu dosyalar yok ise (or you don’t even have a `.ssh` directory), `ssh-keygen` ile bu dosyaları oluşturabilirsiniz, Linux/Mac sistemlerinde SSH paketi Windows MSysGit paketi ile geliyor:
 
	$ ssh-keygen
	Generating public/private rsa key pair.
	Enter file in which to save the key (/Users/schacon/.ssh/id_rsa):
	Enter passphrase (empty for no passphrase):
	Enter same passphrase again:
	Your identification has been saved in /Users/schacon/.ssh/id_rsa.
	Your public key has been saved in /Users/schacon/.ssh/id_rsa.pub.
	The key fingerprint is:
	43:c5:5b:5f:b1:f1:50:43:ad:20:a6:92:6a:1f:9a:3a schacon@agadorlaptop.local

Eğer anahtarı kaydetmek isterseniz (`.ssh/id_rsa`) önce kaydetmek istediğiniz yeri sorar, ve sonra iki kez parolanızı sorar, eğer parolanızı yazmak istemiyorsanız boş geçin.

Now, each user that does this has to send their public key to you or whoever is administrating the Git server (assuming you’re using an SSH server setup that requires public keys). Yapmaları gereken `.pub` dosyasının ve içeriğini kopyalamak olduğunu bunu e-posta atmak. Örnek public key:

	$ cat ~/.ssh/id_rsa.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU
	GPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3
	Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XA
	t3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/En
	mZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbx
	NrRFi9wrf+M7Q== schacon@agadorlaptop.local

Birden fazla işletim sistemlerinde SSH key oluşturma ile ilgili kapsamlı bilgi için bknz: Github klavuzu SSH keys http://github.com/guides/providing-your-ssh-key.

## Sunucu Kurma ##

Şimdi baştan sona adım adım sunucu tarafına SSH erişimi kuralım. Bu örnekte, kullanıcılarınızı doğrulamak için `authorized_keys` methodu kullanacağız. Ayrıca Ubuntu gibi standart bir Linux dağıtımı kullanıyoruz varsayacağız. Öncelikle, bir 'git' kullanıcı ve bu kullanıcı için bir `.ssh` dizin oluşturun.

	$ sudo adduser git
	$ su git
	$ cd
	$ mkdir .ssh

Sonra, you need to add some developer SSH public keys to the `authorized_keys` file for that user. Let’s assume you’ve received a few keys by e-mail and saved them to temporary files. Yine, public keyimiz aşağıdaki gibi olacaktır:

	$ cat /tmp/id_rsa.john.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCB007n/ww+ouN4gSLKssMxXnBOvf9LGt4L
	ojG6rs6hPB09j9R/T17/x4lhJA0F3FR1rP6kYBRsWj2aThGw6HXLm9/5zytK6Ztg3RPKK+4k
	Yjh6541NYsnEAZuXz0jTTyAUfrtU3Z5E003C4oxOj6H0rfIF1kKI9MAQLMdpGW1GYEIgS9Ez
	Sdfd8AcCIicTDWbqLAcU4UpkaX8KyGlLwsNuuGztobF8m72ALC/nLF6JLtPofwFBlgc+myiv
	O7TCUSBdLQlgMVOFq1I2uPWQOkOWQAHukEOmfjy2jctxSDBQ220ymjaNsHT4kgtZg2AYYgPq
	dAv8JggJICUvax2T9va5 gsg-keypair

Sizin  `authorized_keys` dosyanıza sadece bunlar eklenecek:

	$ cat /tmp/id_rsa.john.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.josie.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.jessica.pub >> ~/.ssh/authorized_keys

Şimdi,boş bir repository oluşturmak için  `git init` komutunu `--bare` özelliği ile çalıştırın, which initializes the repository without a working directory:

	$ cd /opt/git
	$ mkdir project.git
	$ cd project.git
	$ git --bare init

Sonra, John, Josie, or Jessica can push the first version of their project into that repository by adding it as a remote and pushing up a branch. Note that someone must shell onto the machine and create a bare repository every time you want to add a project. Let’s use `gitserver` as the hostname of the server on which you’ve set up your 'git' user and repository. If you’re running it internally, and you set up DNS for `gitserver` to point to that server, then you can use the commands pretty much as is:

	# on Johns computer
	$ cd myproject
	$ git init
	$ git add .
	$ git commit -m 'initial commit'
	$ git remote add origin git@gitserver:/opt/git/project.git
	$ git push origin master

Bu noktada, yapılan değişiklikler kolayca yedeklenir:

	$ git clone git@gitserver:/opt/git/project.git
	$ cd project
	$ vim README
	$ git commit -am 'fix for the README file'
	$ git push origin master

Bu method ile, kolayca Git server üzerinde okuma/yazma yapabilirsiniz.

As an extra precaution, you can easily restrict the 'git' user to only doing Git activities with a limited shell tool called `git-shell` that comes with Git. If you set this as your 'git' user’s login shell, then the 'git' user can’t have normal shell access to your server. To use this, specify `git-shell` instead of bash or csh for your user’s login shell. To do so, you’ll likely have to edit your `/etc/passwd` file:

	$ sudo vim /etc/passwd

Alt kısımda bu şekilde bir çıktı görmelisiniz:

	git:x:1000:1000::/home/git:/bin/sh

Change `/bin/sh` to `/usr/bin/git-shell` (or run `which git-shell` to see where it’s installed). Satırınız böyle görünmelidir:

	git:x:1000:1000::/home/git:/usr/bin/git-shell

Şimdi, the 'git' user can only use the SSH connection to push and pull Git repositories and can’t shell onto the machine. If you try, you’ll see a login rejection like this:

	$ ssh git@gitserver
	fatal: What do you think I am? A shell?
	Connection to gitserver closed.

## Genel Erişim ##

Peki projenize anonim olarak erişmek isterseniz? Perhaps instead of hosting an internal private project, you want to host an open source project. Or maybe you have a bunch of automated build servers or continuous integration servers that change a lot, and you don’t want to have to generate SSH keys all the time — you just want to add simple anonymous read access.

Probably the simplest way for smaller setups is to run a static web server with its document root where your Git repositories are, and then enable that `post-update` hook we mentioned in the first section of this chapter. Let’s work from the previous example. Say you have your repositories in the `/opt/git` directory, and an Apache server is running on your machine. Again, you can use any web server for this; but as an example, we’ll demonstrate some basic Apache configurations that should give you an idea of what you might need.

Öncelikle hook'u etkinleştirmemiz gerekiyor:

	$ cd project.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

Peki bu `post-update` hook ne yapar? Temelde şunları yapar:

	$ cat .git/hooks/post-update
	#!/bin/sh
	#
	# An example hook script to prepare a packed repository for use over
	# dumb transports.
	#
	# To enable this hook, rename this file to "post-update".
	#

	exec git-update-server-info

Bu SSH üzerinden sunucuya push yaptığınızda, Git HTTP almak için gereken dosyaları günceleyecek ve bu komutu çalıştıracak.

Daha sonra, Apache sunucumuza VirtualHost girişi ekmemiz gerekecek. Here, we’re assuming that you have wildcard DNS set up to send `*.gitserver` to whatever box you’re using to run all this:

	<VirtualHost *:80>
	    ServerName git.gitserver
	    DocumentRoot /opt/git
	    <Directory /opt/git/>
	        Order allow, deny
	        allow from all
	    </Directory>
	</VirtualHost>

You’ll also need to set the Unix user group of the `/opt/git` directories to `www-data` so your web server can read-access the repositories, çünkü CGI komut dosyası çalıştıran Apache örneği (varsayılan) kullanıcı olarak çalışıyor olacak.

	$ chgrp -R www-data /opt/git

Apache'yi yeniden başlattığınızda, sizin projeniz dizininizin altında oluşan URL ile clonelanabilir:

	$ git clone http://git.gitserver/project.git

This way, you can set up HTTP-based read access to any of your projects for a fair number of users in a few minutes. Another simple option for public unauthenticated access is to start a Git daemon, although that requires you to daemonize the process - we’ll cover this option in the next section, if you prefer that route.

## GitWeb ##

Now that you have basic read/write and read-only access to your project, you may want to set up a simple web-based visualizer. Git comes with a CGI script called GitWeb that is commonly used for this. You can see GitWeb in use at sites like `http://git.kernel.org` (see Figure 4-1).

Insert 18333fig0401.png
Figure 4-1. The GitWeb web-based user interface.

If you want to check out what GitWeb would look like for your project, Git comes with a command to fire up a temporary instance if you have a lightweight server on your system like `lighttpd` or `webrick`. On Linux machines, `lighttpd` is often installed, so you may be able to get it to run by typing `git instaweb` in your project directory. If you’re running a Mac, Leopard comes preinstalled with Ruby, so `webrick` may be your best bet. To start `instaweb` with a non-lighttpd handler, you can run it with the `--httpd` option.

	$ git instaweb --httpd=webrick
	[2009-02-21 10:02:21] INFO  WEBrick 1.3.1
	[2009-02-21 10:02:21] INFO  ruby 1.8.6 (2008-03-03) [universal-darwin9.0]

That starts up an HTTPD server on port 1234 and then automatically starts a web browser that opens on that page. It’s pretty easy on your part. When you’re done and want to shut down the server, you can run the same command with the `--stop` option:

	$ git instaweb --httpd=webrick --stop

If you want to run the web interface on a server all the time for your team or for an open source project you’re hosting, you’ll need to set up the CGI script to be served by your normal web server. Some Linux distributions have a `gitweb` package that you may be able to install via `apt` or `yum`, so you may want to try that first. We’ll walk though installing GitWeb manually very quickly. First, you need to get the Git source code, which GitWeb comes with, and generate the custom CGI script:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/
	$ make GITWEB_PROJECTROOT="/opt/git" \
	        prefix=/usr gitweb
	$ sudo cp -Rf gitweb /var/www/

Notice that you have to tell the command where to find your Git repositories with the `GITWEB_PROJECTROOT` variable. Now, you need to make Apache use CGI for that script, for which you can add a VirtualHost:

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

Again, GitWeb can be served with any CGI capable web server; if you prefer to use something else, it shouldn’t be difficult to set up. At this point, you should be able to visit `http://gitserver/` to view your repositories online, and you can use `http://git.gitserver` to clone and fetch your repositories over HTTP.

## Gitosis ##

Keeping all users’ public keys in the `authorized_keys` file for access works well only for a while. When you have hundreds of users, it’s much more of a pain to manage that process. You have to shell onto the server each time, and there is no access control — everyone in the file has read and write access to every project.

At this point, you may want to turn to a widely used software project called Gitosis. Gitosis is basically a set of scripts that help you manage the `authorized_keys` file as well as implement some simple access controls. The really interesting part is that the UI for this tool for adding people and determining access isn’t a web interface but a special Git repository. You set up the information in that project; and when you push it, Gitosis reconfigures the server based on that, which is cool.

Installing Gitosis isn’t the simplest task ever, but it’s not too difficult. It’s easiest to use a Linux server for it — these examples use a stock Ubuntu 8.10 server.

Gitosis requires some Python tools, so first you have to install the Python setuptools package, which Ubuntu provides as python-setuptools:

	$ apt-get install python-setuptools

Next, you clone and install Gitosis from the project’s main site:

	$ git clone https://github.com/tv42/gitosis.git
	$ cd gitosis
	$ sudo python setup.py install

That installs a couple of executables that Gitosis will use. Next, Gitosis wants to put its repositories under `/home/git`, which is fine. But you have already set up your repositories in `/opt/git`, so instead of reconfiguring everything, you create a symlink:

	$ ln -s /opt/git /home/git/repositories

Gitosis is going to manage your keys for you, so you need to remove the current file, re-add the keys later, and let Gitosis control the `authorized_keys` file automatically. For now, move the `authorized_keys` file out of the way:

	$ mv /home/git/.ssh/authorized_keys /home/git/.ssh/ak.bak

Next you need to turn your shell back on for the 'git' user, if you changed it to the `git-shell` command. People still won’t be able to log in, but Gitosis will control that for you. So, let’s change this line in your `/etc/passwd` file

	git:x:1000:1000::/home/git:/usr/bin/git-shell

back to this:

	git:x:1000:1000::/home/git:/bin/sh

Now it’s time to initialize Gitosis. You do this by running the `gitosis-init` command with your personal public key. If your public key isn’t on the server, you’ll have to copy it there:

	$ sudo -H -u git gitosis-init < /tmp/id_dsa.pub
	Initialized empty Git repository in /opt/git/gitosis-admin.git/
	Reinitialized existing Git repository in /opt/git/gitosis-admin.git/

This lets the user with that key modify the main Git repository that controls the Gitosis setup. Next, you have to manually set the execute bit on the `post-update` script for your new control repository.

	$ sudo chmod 755 /opt/git/gitosis-admin.git/hooks/post-update

You’re ready to roll. If you’re set up correctly, you can try to SSH into your server as the user for which you added the public key to initialize Gitosis. You should see something like this:

	$ ssh git@gitserver
	PTY allocation request failed on channel 0
	ERROR:gitosis.serve.main:Need SSH_ORIGINAL_COMMAND in environment.
	  Connection to gitserver closed.

That means Gitosis recognized you but shut you out because you’re not trying to do any Git commands. So, let’s do an actual Git command — you’ll clone the Gitosis control repository:

	# on your local computer
	$ git clone git@gitserver:gitosis-admin.git

Now you have a directory named `gitosis-admin`, which has two major parts:

	$ cd gitosis-admin
	$ find .
	./gitosis.conf
	./keydir
	./keydir/scott.pub

The `gitosis.conf` file is the control file you use to specify users, repositories, and permissions. The `keydir` directory is where you store the public keys of all the users who have any sort of access to your repositories — one file per user. The name of the file in `keydir` (in the previous example, `scott.pub`) will be different for you — Gitosis takes that name from the description at the end of the public key that was imported with the `gitosis-init` script.

If you look at the `gitosis.conf` file, it should only specify information about the `gitosis-admin` project that you just cloned:

	$ cat gitosis.conf
	[gitosis]

	[group gitosis-admin]
	members = scott
	writable = gitosis-admin

It shows you that the 'scott' user — the user with whose public key you initialized Gitosis — is the only one who has access to the `gitosis-admin` project.

Now, let’s add a new project for you. You’ll add a new section called `mobile` where you’ll list the developers on your mobile team and projects that those developers need access to. Because 'scott' is the only user in the system right now, you’ll add him as the only member, and you’ll create a new project called `iphone_project` to start on:

	[group mobile]
	members = scott
	writable = iphone_project

Whenever you make changes to the `gitosis-admin` project, you have to commit the changes and push them back up to the server in order for them to take effect:

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

You can make your first push to the new `iphone_project` project by adding your server as a remote to your local version of the project and pushing. You no longer have to manually create a bare repository for new projects on the server — Gitosis creates them automatically when it sees the first push:

	$ git remote add origin git@gitserver:iphone_project.git
	$ git push origin master
	Initialized empty Git repository in /opt/git/iphone_project.git/
	Counting objects: 3, done.
	Writing objects: 100% (3/3), 230 bytes | 0 bytes/s, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:iphone_project.git
	 * [new branch]      master -> master

Notice that you don’t need to specify the path (in fact, doing so won’t work), just a colon and then the name of the project — Gitosis finds it for you.

You want to work on this project with your friends, so you’ll have to re-add their public keys. But instead of appending them manually to the `~/.ssh/authorized_keys` file on your server, you’ll add them, one key per file, into the `keydir` directory. How you name the keys determines how you refer to the users in the `gitosis.conf` file. Let’s re-add the public keys for John, Josie, and Jessica:

	$ cp /tmp/id_rsa.john.pub keydir/john.pub
	$ cp /tmp/id_rsa.josie.pub keydir/josie.pub
	$ cp /tmp/id_rsa.jessica.pub keydir/jessica.pub

Now you can add them all to your 'mobile' team so they have read and write access to `iphone_project`:

	[group mobile]
	members = scott john josie jessica
	writable = iphone_project

After you commit and push that change, all four users will be able to read from and write to that project.

Gitosis has simple access controls as well. If you want John to have only read access to this project, you can do this instead:

	[group mobile]
	members = scott josie jessica
	writable = iphone_project

	[group mobile_ro]
	members = john
	readonly = iphone_project

Now John can clone the project and get updates, but Gitosis won’t allow him to push back up to the project. You can create as many of these groups as you want, each containing different users and projects. You can also specify another group as one of the members (using `@` as prefix), to inherit all of its members automatically:

	[group mobile_committers]
	members = scott josie jessica

	[group mobile]
	members   = @mobile_committers
	writable  = iphone_project

	[group mobile_2]
	members   = @mobile_committers john
	writable  = another_iphone_project

If you have any issues, it may be useful to add `loglevel=DEBUG` under the `[gitosis]` section. If you’ve lost push access by pushing a messed-up configuration, you can manually fix the file on the server under `/home/git/.gitosis.conf` — the file from which Gitosis reads its info. A push to the project takes the `gitosis.conf` file you just pushed up and sticks it there. If you edit that file manually, it remains like that until the next successful push to the `gitosis-admin` project.

## Gitolite ##

This section serves as a quick introduction to Gitolite, and provides basic installation and setup instructions.  It cannot, however, replace the enormous amount of [documentation][gltoc] that Gitolite comes with.  There may also be occasional changes to this section itself, so you may also want to look at the latest version [here][gldpg].

[gldpg]: http://sitaramc.github.com/gitolite/progit.html
[gltoc]: http://sitaramc.github.com/gitolite/master-toc.html

Gitolite is an authorization layer on top of Git, relying on `sshd` or `httpd` for authentication.  (Recap: authentication is identifying who the user is, authorization is deciding if he is allowed to do what he is attempting to).

Gitolite allows you to specify permissions not just by repository, but also by branch or tag names within each repository.  That is, you can specify that certain people (or groups of people) can only push certain "refs" (branches or tags) but not others.

### Installing ###

Installing Gitolite is very easy, even if you don’t read the extensive documentation that comes with it.  You need an account on a Unix server of some kind.  You do not need root access, assuming Git, Perl, and an OpenSSH compatible SSH server are already installed.  In the examples below, we will use the `git` account on a host called `gitserver`.

Gitolite is somewhat unusual as far as "server" software goes — access is via SSH, and so every userid on the server is a potential "gitolite host".  We will describe the simplest install method in this article; for the other methods please see the documentation.

To begin, create a user called `git` on your server and login to this user.  Copy your SSH public key (a file called `~/.ssh/id_rsa.pub` if you did a plain `ssh-keygen` with all the defaults) from your workstation, renaming it to `<yourname>.pub` (we'll use `scott.pub` in our examples).  Then run these commands:

	$ git clone git://github.com/sitaramc/gitolite
	$ gitolite/install -ln
	    # assumes $HOME/bin exists and is in your $PATH
	$ gitolite setup -pk $HOME/scott.pub

That last command creates new Git repository called `gitolite-admin` on the server.

Finally, back on your workstation, run `git clone git@gitserver:gitolite-admin`. And you’re done!  Gitolite has now been installed on the server, and you now have a brand new repository called `gitolite-admin` in your workstation.  You administer your Gitolite setup by making changes to this repository and pushing.

### Customising the Install ###

While the default, quick, install works for most people, there are some ways to customise the install if you need to.  Some changes can be made simply by editing the rc file, but if that is not sufficient, there’s documentation on customising Gitolite.

### Config File and Access Control Rules ###

Once the install is done, you switch to the `gitolite-admin` clone you just made on your workstation, and poke around to see what you got:

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

Notice that "scott" (the name of the pubkey in the `gitolite setup` command you used earlier) has read-write permissions on the `gitolite-admin` repository as well as a public key file of the same name.

Adding users is easy.  To add a user called "alice", obtain her public key, name it `alice.pub`, and put it in the `keydir` directory of the clone of the `gitolite-admin` repo you just made on your workstation.  Add, commit, and push the change, and the user has been added.

The config file syntax for Gitolite is well documented, so we’ll only mention some highlights here.

You can group users or repos for convenience.  The group names are just like macros; when defining them, it doesn’t even matter whether they are projects or users; that distinction is only made when you *use* the "macro".

	@oss_repos      = linux perl rakudo git gitolite
	@secret_repos   = fenestra pear

	@admins         = scott
	@interns        = ashok
	@engineers      = sitaram dilbert wally alice
	@staff          = @admins @engineers @interns

You can control permissions at the "ref" level.  In the following example, interns can only push the "int" branch.  Engineers can push any branch whose name starts with "eng-", and tags that start with "rc" followed by a digit.  And the admins can do anything (including rewind) to any ref.

	repo @oss_repos
	    RW  int$                = @interns
	    RW  eng-                = @engineers
	    RW  refs/tags/rc[0-9]   = @engineers
	    RW+                     = @admins

The expression after the `RW` or `RW+` is a regular expression (regex) that the refname (ref) being pushed is matched against.  So we call it a "refex"!  Of course, a refex can be far more powerful than shown here, so don’t overdo it if you’re not comfortable with Perl regexes.

Also, as you probably guessed, Gitolite prefixes `refs/heads/` as a syntactic convenience if the refex does not begin with `refs/`.

An important feature of the config file’s syntax is that all the rules for a repository need not be in one place.  You can keep all the common stuff together, like the rules for all `oss_repos` shown above, then add specific rules for specific cases later on, like so:

	repo gitolite
	    RW+                     = sitaram

That rule will just get added to the ruleset for the `gitolite` repository.

At this point you might be wondering how the access control rules are actually applied, so let’s go over that briefly.

There are two levels of access control in Gitolite.  The first is at the repository level; if you have read (or write) access to *any* ref in the repository, then you have read (or write) access to the repository.  This is the only access control that Gitosis had.

The second level, applicable only to "write" access, is by branch or tag within a repository.  The username, the access being attempted (`W` or `+`), and the refname being updated are known.  The access rules are checked in order of appearance in the config file, looking for a match for this combination (but remember that the refname is regex-matched, not merely string-matched).  If a match is found, the push succeeds.  A fallthrough results in access being denied.

### Advanced Access Control with "deny" rules ###

So far, we’ve only seen permissions to be one of `R`, `RW`, or `RW+`.  However, Gitolite allows another permission: `-`, standing for "deny".  This gives you a lot more power, at the expense of some complexity, because now fallthrough is not the *only* way for access to be denied, so the *order of the rules now matters*!

Let us say, in the situation above, we want engineers to be able to rewind any branch *except* master and integ.  Here’s how to do that:

	    RW  master integ    = @engineers
	    -   master integ    = @engineers
	    RW+                 = @engineers

Again, you simply follow the rules top down until you hit a match for your access mode, or a deny.  Non-rewind push to master or integ is allowed by the first rule.  A rewind push to those refs does not match the first rule, drops down to the second, and is therefore denied.  Any push (rewind or non-rewind) to refs other than master or integ won’t match the first two rules anyway, and the third rule allows it.

### Restricting pushes by files changed ###

In addition to restricting what branches a user can push changes to, you can also restrict what files they are allowed to touch.  For example, perhaps the Makefile (or some other program) is really not supposed to be changed by just anyone, because a lot of things depend on it or would break if the changes are not done *just right*.  You can tell Gitolite:

    repo foo
        RW                      =   @junior_devs @senior_devs

        -   VREF/NAME/Makefile  =   @junior_devs

Users who are migrating from the older Gitolite should note that there is a significant change in behaviour with regard to this feature; please see the migration guide for details.

### Personal Branches ###

Gitolite also has a feature called "personal branches" (or rather, "personal branch namespace") that can be very useful in a corporate environment.

A lot of code exchange in the Git world happens by "please pull" requests.  In a corporate environment, however, unauthenticated access is a no-no, and a developer workstation cannot do authentication, so you have to push to the central server and ask someone to pull from there.

This would normally cause the same branch name clutter as in a centralised VCS, plus setting up permissions for this becomes a chore for the admin.

Gitolite lets you define a "personal" or "scratch" namespace prefix for each developer (for example, `refs/personal/<devname>/*`); please see the documentation for details.

### "Wildcard" repositories ###

Gitolite allows you to specify repositories with wildcards (actually Perl regexes), like, for example `assignments/s[0-9][0-9]/a[0-9][0-9]`, to pick a random example.  It also allows you to assign a new permission mode (`C`) which enables users to create repositories based on such wild cards, automatically assigns ownership to the specific user who created it, allows him/her to hand out `R` and `RW` permissions to other users to collaborate, etc.  Again, please see the documentation for details.

### Other Features ###

We’ll round off this discussion with a sampling of other features, all of which, and many more, are described in great detail in the documentation.

**Logging**: Gitolite logs all successful accesses.  If you were somewhat relaxed about giving people rewind permissions (`RW+`) and some kid blew away `master`, the log file is a life saver, in terms of easily and quickly finding the SHA that got hosed.

**Access rights reporting**: Another convenient feature is what happens when you try and just ssh to the server.  Gitolite shows you what repos you have access to, and what that access may be.  Here’s an example:

        hello scott, this is git@git running gitolite3 v3.01-18-g9609868 on git 1.7.4.4

             R     anu-wsd
             R     entrans
             R  W  git-notes
             R  W  gitolite
             R  W  gitolite-admin
             R     indic_web_input
             R     shreelipi_converter

**Delegation**: For really large installations, you can delegate responsibility for groups of repositories to various people and have them manage those pieces independently.  This reduces the load on the main admin, and makes him less of a bottleneck.

**Mirroring**: Gitolite can help you maintain multiple mirrors, and switch between them easily if the primary server goes down.

## Git Daemon ##

For public, unauthenticated read access to your projects, you’ll want to move past the HTTP protocol and start using the Git protocol. The main reason is speed. The Git protocol is far more efficient and thus faster than the HTTP protocol, so using it will save your users time.

Again, this is for unauthenticated read-only access. If you’re running this on a server outside your firewall, it should only be used for projects that are publicly visible to the world. If the server you’re running it on is inside your firewall, you might use it for projects that a large number of people or computers (continuous integration or build servers) have read-only access to, when you don’t want to have to add an SSH key for each.

In any case, the Git protocol is relatively easy to set up. Basically, you need to run this command in a daemonized manner:

	git daemon --reuseaddr --base-path=/opt/git/ /opt/git/

`--reuseaddr` allows the server to restart without waiting for old connections to time out, the `--base-path` option allows people to clone projects without specifying the entire path, and the path at the end tells the Git daemon where to look for repositories to export. If you’re running a firewall, you’ll also need to punch a hole in it at port 9418 on the box you’re setting this up on.

You can daemonize this process a number of ways, depending on the operating system you’re running. On an Ubuntu machine, you use an Upstart script. So, in the following file

	/etc/event.d/local-git-daemon

you put this script:

	start on startup
	stop on shutdown
	exec /usr/bin/git daemon \
	    --user=git --group=git \
	    --reuseaddr \
	    --base-path=/opt/git/ \
	    /opt/git/
	respawn

For security reasons, it is strongly encouraged to have this daemon run as a user with read-only permissions to the repositories — you can easily do this by creating a new user 'git-ro' and running the daemon as them.  For the sake of simplicity we’ll simply run it as the same 'git' user that Gitosis is running as.

When you restart your machine, your Git daemon will start automatically and respawn if it goes down. To get it running without having to reboot, you can run this:

	initctl start local-git-daemon

On other systems, you may want to use `xinetd`, a script in your `sysvinit` system, or something else — as long as you get that command daemonized and watched somehow.

Next, you have to tell your Gitosis server which repositories to allow unauthenticated Git server-based access to. If you add a section for each repository, you can specify the ones from which you want your Git daemon to allow reading. If you want to allow Git protocol access for the `iphone_project`, you add this to the end of the `gitosis.conf` file:

	[repo iphone_project]
	daemon = yes

When that is committed and pushed up, your running daemon should start serving requests for the project to anyone who has access to port 9418 on your server.

If you decide not to use Gitosis, but you want to set up a Git daemon, you’ll have to run this on each project you want the Git daemon to serve:

	$ cd /path/to/project.git
	$ touch git-daemon-export-ok

The presence of that file tells Git that it’s OK to serve this project without authentication.

Gitosis can also control which projects GitWeb shows. First, you need to add something like the following to the `/etc/gitweb.conf` file:

	$projects_list = "/home/git/gitosis/projects.list";
	$projectroot = "/home/git/repositories";
	$export_ok = "git-daemon-export-ok";
	@git_base_url_list = ('git://gitserver');

You can control which projects GitWeb lets users browse by adding or removing a `gitweb` setting in the Gitosis configuration file. For instance, if you want the `iphone_project` to show up on GitWeb, you make the `repo` setting look like this:

	[repo iphone_project]
	daemon = yes
	gitweb = yes

Now, if you commit and push the project, GitWeb will automatically start showing the `iphone_project`.

## Hosted Git ##

If you don’t want to go through all of the work involved in setting up your own Git server, you have several options for hosting your Git projects on an external dedicated hosting site. Doing so offers a number of advantages: a hosting site is generally quick to set up and easy to start projects on, and no server maintenance or monitoring is involved. Even if you set up and run your own server internally, you may still want to use a public hosting site for your open source code — it’s generally easier for the open source community to find and help you with.

These days, you have a huge number of hosting options to choose from, each with different advantages and disadvantages. To see an up-to-date list, check out the following page:

	https://git.wiki.kernel.org/index.php/GitHosting

Because we can’t cover all of them, and because I happen to work at one of them, we’ll use this section to walk through setting up an account and creating a new project at GitHub. This will give you an idea of what is involved.

GitHub is by far the largest open source Git hosting site and it’s also one of the very few that offers both public and private hosting options so you can keep your open source and private commercial code in the same place. In fact, we used GitHub to privately collaborate on this book.

### GitHub ###

GitHub is slightly different than most code-hosting sites in the way that it namespaces projects. Instead of being primarily based on the project, GitHub is user centric. That means when I host my `grit` project on GitHub, you won’t find it at `github.com/grit` but instead at `github.com/schacon/grit`. There is no canonical version of any project, which allows a project to move from one user to another seamlessly if the first author abandons the project.

GitHub is also a commercial company that charges for accounts that maintain private repositories, but anyone can quickly get a free account to host as many open source projects as they want. We’ll quickly go over how that is done.

### Setting Up a User Account ###

The first thing you need to do is set up a free user account. If you visit the Pricing and Signup page at `http://github.com/plans` and click the "Sign Up" button on the Free account (see Figure 4-2), you’re taken to the signup page.

Insert 18333fig0402.png
Figure 4-2. The GitHub plan page.

Here you must choose a username that isn’t yet taken in the system and enter an e-mail address that will be associated with the account and a password (see Figure 4-3).

Insert 18333fig0403.png
Figure 4-3. The GitHub user signup form.

If you have it available, this is a good time to add your public SSH key as well. We covered how to generate a new key earlier, in the "Simple Setups" section. Take the contents of the public key of that pair, and paste it into the SSH Public Key text box. Clicking the "explain ssh keys" link takes you to detailed instructions on how to do so on all major operating systems.
Clicking the "I agree, sign me up" button takes you to your new user dashboard (see Figure 4-4).

Insert 18333fig0404.png
Figure 4-4. The GitHub user dashboard.

Next you can create a new repository.

### Creating a New Repository ###

Start by clicking the "create a new one" link next to Your Repositories on the user dashboard. You’re taken to the Create a New Repository form (see Figure 4-5).

Insert 18333fig0405.png
Figure 4-5. Creating a new repository on GitHub.

All you really have to do is provide a project name, but you can also add a description. When that is done, click the "Create Repository" button. Now you have a new repository on GitHub (see Figure 4-6).

Insert 18333fig0406.png
Figure 4-6. GitHub project header information.

Since you have no code there yet, GitHub will show you instructions for how create a brand-new project, push an existing Git project up, or import a project from a public Subversion repository (see Figure 4-7).

Insert 18333fig0407.png
Figure 4-7. Instructions for a new repository.

These instructions are similar to what we’ve already gone over. To initialize a project if it isn’t already a Git project, you use

	$ git init
	$ git add .
	$ git commit -m 'initial commit'

When you have a Git repository locally, add GitHub as a remote and push up your master branch:

	$ git remote add origin git@github.com:testinguser/iphone_project.git
	$ git push origin master

Now your project is hosted on GitHub, and you can give the URL to anyone you want to share your project with. In this case, it’s `http://github.com/testinguser/iphone_project`. You can also see from the header on each of your project’s pages that you have two Git URLs (see Figure 4-8).

Insert 18333fig0408.png
Figure 4-8. Project header with a public URL and a private URL.

The Public Clone URL is a public, read-only Git URL over which anyone can clone the project. Feel free to give out that URL and post it on your web site or what have you.

The Your Clone URL is a read/write SSH-based URL that you can read or write over only if you connect with the SSH private key associated with the public key you uploaded for your user. When other users visit this project page, they won’t see that URL—only the public one.

### Importing from Subversion ###

If you have an existing public Subversion project that you want to import into Git, GitHub can often do that for you. At the bottom of the instructions page is a link to a Subversion import. If you click it, you see a form with information about the import process and a text box where you can paste in the URL of your public Subversion project (see Figure 4-9).

Insert 18333fig0409.png
Figure 4-9. Subversion importing interface.

If your project is very large, nonstandard, or private, this process probably won’t work for you. In Chapter 7, you’ll learn how to do more complicated manual project imports.

### Adding Collaborators ###

Let’s add the rest of the team. If John, Josie, and Jessica all sign up for accounts on GitHub, and you want to give them push access to your repository, you can add them to your project as collaborators. Doing so will allow pushes from their public keys to work.

Click the "edit" button in the project header or the Admin tab at the top of the project to reach the Admin page of your GitHub project (see Figure 4-10).

Insert 18333fig0410.png
Figure 4-10. GitHub administration page.

To give another user write access to your project, click the “Add another collaborator” link. A new text box appears, into which you can type a username. As you type, a helper pops up, showing you possible username matches. When you find the correct user, click the Add button to add that user as a collaborator on your project (see Figure 4-11).

Insert 18333fig0411.png
Figure 4-11. Adding a collaborator to your project.

When you’re finished adding collaborators, you should see a list of them in the Repository Collaborators box (see Figure 4-12).

Insert 18333fig0412.png
Figure 4-12. A list of collaborators on your project.

If you need to revoke access to individuals, you can click the "revoke" link, and their push access will be removed. For future projects, you can also copy collaborator groups by copying the permissions of an existing project.

### Your Project ###

After you push your project up or have it imported from Subversion, you have a main project page that looks something like Figure 4-13.

Insert 18333fig0413.png
Figure 4-13. A GitHub main project page.

When people visit your project, they see this page. It contains tabs to different aspects of your projects. The Commits tab shows a list of commits in reverse chronological order, similar to the output of the `git log` command. The Network tab shows all the people who have forked your project and contributed back. The Downloads tab allows you to upload project binaries and link to tarballs and zipped versions of any tagged points in your project. The Wiki tab provides a wiki where you can write documentation or other information about your project. The Graphs tab has some contribution visualizations and statistics about your project. The main Source tab that you land on shows your project’s main directory listing and automatically renders the README file below it if you have one. This tab also shows a box with the latest commit information.

### Projeleri Forklamak ###

If you want to contribute to an existing project to which you don’t have push access, GitHub encourages forking the project. When you land on a project page that looks interesting and you want to hack on it a bit, you can click the "fork" button in the project header to have GitHub copy that project to your user so you can push to it.

This way, projects don’t have to worry about adding users as collaborators to give them push access. People can fork a project and push to it, and the main project maintainer can pull in those changes by adding them as remotes and merging in their work.

To fork a project, visit the project page (in this case, mojombo/chronic) and click the "fork" button in the header (see Figure 4-14).

Insert 18333fig0414.png
Figure 4-14. Get a writable copy of any repository by clicking the "fork" button.

After a few seconds, you’re taken to your new project page, which indicates that this project is a fork of another one (see Figure 4-15).

Insert 18333fig0415.png
Figure 4-15. Your fork of a project.

### GitHub Özeti ###

That’s all we’ll cover about GitHub, but it’s important to note how quickly you can do all this. You can create an account, add a new project, and push to it in a matter of minutes. If your project is open source, you also get a huge community of developers who now have visibility into your project and may well fork it and help contribute to it. At the very least, this may be a way to get up and running with Git and try it out quickly.

## Özet ##

You have several options to get a remote Git repository up and running so that you can collaborate with others or share your work.

Running your own server gives you a lot of control and allows you to run the server within your own firewall, but such a server generally requires a fair amount of your time to set up and maintain. If you place your data on a hosted server, it’s easy to set up and maintain; however, you have to be able to keep your code on someone else’s servers, and some organizations don’t allow that.

It should be fairly straightforward to determine which solution or combination of solutions is appropriate for you and your organization.
