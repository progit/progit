# Memulai Git #

Bab ini berisi pendahuluan mengenai Git. Kita akan memulai dengan membahas sedikit mengenai latar belakang sejarah version control, kemudian berlanjut pada tata cara menjalankan Git pada sistem anda dan terakhir cara untuk melakukan penyetingan dan memulai bekerja dengan Git. Pada akhir bab ini diharapkan anda dapat memahami mengapa Git ada, kenapa anda harus menggunakan dan harus melakukan pengaturan untuk menggunakannya.

## Tentang Version Control ##

Apa itu version control, dan kenapa anda harus peduli? Version control adalah sebuah sistem yang mencatat setiap perubahan terhadap sebuah berkas atau kumpulan berkas sehingga pada suatu saat anda dapat kembali kepada salah satu versi dari berkas tersebut. For the examples in this book you will use software source code as the files being version controlled, though in reality you can do this with nearly any type of file on a computer.

Jika anda adalah seorang desainer grafis atau desainer web dan anda ingin menyimpan setiap versi dari gambar atau layout yang anda buat (kemungkinan besar anda pasti ingin melakukannya), maka Version Control System (VCS) merupakan sebuah solusi bijak untuk digunakan. Sistem ini memungkinkan anda untuk mengembalikan berkas anda pada kondisi/keadaan sebelumnya, mengembalikan seluruh proyek pada keadaan sebelumnya, membandingkan perubahan setiap saat, melihat siapa yang terakhir melakukan perubahan terbaru pada suatu objek sehingga berpotensi menimbulkan masalah, siapa yang menerbitkan isu, dan lainnya. Dengan menggunakan VCS dapat berarti jika anda telah mengacaukan atau kehilangan berkas, anda dapat dengan mudah mengembalikannya. In addition, you get all this for very little overhead.

### Local Version Control Systems ###

Kebanyakan orang melakukan pengontrolan versi dengan cara menyalin berkas-berkas pada direktori lain (mungkin dengan memberikan penanggalan pada direktori tersebut, jika mereka rajin). Metode seperti ini sangat umum karena sangat sederhana, namun cenderung rawan terhadap kesalahan. Anda akan sangat mudah lupa dimana direktori anda sedang berada, selain itu dapat pula terjadi ketidak sengajaan penulisan pada berkas yang salah atau menyalin pada berkas yang bukan anda maksudkan.

Untuk mengatasi permasalahan ini, para programmer mengembangkan berbagai VCS lokal yang memiliki sebuah basis data sederhana untuk menyimpan semua perubahan pada berkas yang berada dalam cakupan revision control (Lihat Gambar 1-1).

Insert 18333fig0101.png 
Gambar 1-1. Diagram version control lokal.

Salah satu perkakas VCS yang populer adalah rcs, kakas ini masih didistribusikan dengan berbagai komputer pada masa kini. Bahkan sistem operasi Mac OS X menyertakan rcs ketika menginstal Developer Tools. Kakas ini pada dasarnya bekerja dengan cara menyimpan kumpulan patch dari satu perubahan ke perubahan lainnya dalam format khusus pada disk; ini kemudian dapat digunakan untuk menciptakan kembali wujud/keadaan suatu berkas pada suatu saat dengan cara menggunakan patch yang berkesesuaian dengan berkas dan waktu yang diinginkan.

### Version Control Systems Terpusat ###

Permasalahan berikutnya yang dihadapi adalah para pengembang perlu melakukan kolaborasi dengan pengembang pada sistem lainnya. Untuk mengatasi permasalahan ini maka dibangunlah Centralized Version Control Systems (CVCSs). Sistem ini, diantaranya CVS, Subversion, dan Perforce, memiliki sebuah server untuk menyimpan setiap versi berkas, dan beberapa klien yang dapat melakukan checkout berkas dari server pusat. Untuk beberapa tahun, sistem seperti ini menjadi standard untuk version control (lihat Gambar 1-2).

Insert 18333fig0102.png 
Gambar 1-2. Diagram version control terpusat.

Sistem seperti ini memiliki beberapa kelebihan, terutama jika dibandingkan dengan VCS lokal. Misalnya, setiap orang pada tingkat tertentu mengetahui apa yang orang lain lakukan pada proyek. Administrators have fine-grained control over who can do what; and it’s far easier to administer a CVCS than it is to deal with local databases on every client.

Walau demikian, sistem dengan tatanan seperti ini memiliki kelemahan serius. Kelemahan nyata yang direpresesntasikan oleh sistem dengan server terpusat. Jika server mati untuk beberapa jam, maka tidak ada seorangpun yang bisa berkolaborasi atau menyimpan perubahan terhadap apa yang mereka telah kerjakan. Jika harddisk yang menyimpan basisdata mengalami kerusakan, dan salinan yang beran belum tersimpan, anda akan kehilangan setiap perubahan dari proyek kecuali snapshot yang dimiliki oleh setiap kolaborator pada komputernya masing-masing.VCS lokal juga mengalami nasib yang sama jika anda menyimpan seluruh history perubahan proyek pada satu tempat, anda mempunyai resiko kehilangan semuanya. 

### Distributed Version Control Systems ###

Inilah saatnya bagi Distributed Version Control Systems untuk mengambil tempat. dalam sebuah DVCS (seperti Git, Mercurial, Bazaar atau Darcs), klien tidak hanya melakukan checkout untuk snapshot terakhir setiap berkas, namun mereka (klien) memiliki salinan penuh dari repositori tersebut. Jadi, jika server mati, dan sistem berkolaborasi melalui server tersebut, maka klien manapun dapat mengirimkan salinan repositori tersebut kembali ke server. Setiap checkout pada DVCS merupakan sebuah backup dari keseluruhan data (lihat Gambar 1-3).

Insert 18333fig0103.png 
Gambar 1-3. Diagram distributed version control.

Lebih jauh lagi, kebanyakan sistem seperti ini mampu menangani sejumlah remote repository dengan baik, jadi anda dapat melakukan kolaborasi dengan berbagai kelompok kolaborator dalam berbagai cara secara bersama-sama pada suatu proyek. Hal ini memungkinkan anda untuk menyusun beberapa jenis alur kerja yang tidak mungkin dilakukan pada sistem terpusat, seperti hierarchical model. 

## A Short History of Git ##

Seperti hal besar lainnya, Git diawali dengan sedikit permasalahan dan kontroversi. Kernel Linux merupakan sebuah proyek perangkat lunak open source skala besar. Sepanjang perjalanan perawatan Kernel Linux (1991-2002), perubahan disimpan sebagai patch dan arsip-arsip berkas. Pada tahun 2002, proyek ini mulai menggunakan sebuah DVCS proprietary bernama BitKeeper.

Pada tahun 2005, hubungan antara komunitas pengembang Kernel Linux dengan perusahan yang mengembangkan Bitkeeper retak, dan status "gratis" pada BitKeeper dicabut. Hal ini membuat komunitas pengembang Kernel Linux (dan khususnya Linus Torvalds, sang pencipta Linux) harus mengembangkan perkakas sendiri dengan berbekal pengalaman yang mereka peroleh ketika menggunakan BitKeeper. Dan sistem tersebut diharapkan dapat memenuhi beberapa hal berikut:

* Kecepatan
* Desain yang sederhana
* Dukungan penuh untuk pengembangan non-linear (ribuan cabang paralel)
* Terdistribusi secara penuh
* Mampu menangani proyek besar seperti Kernel Linux secara efisien (dalam kecepatan dan ukuran data)

Sejak kelahirannya pada tahun 2005, Git telah berkembang dan semakin mudah digunakan serta hingga saat ini masih mempertahankan kualitasnya tersebut. Git luar biasa cepat, sangat efisien dalam proyek besar, dan memiliki sistem pencabangan yang luar biasa untuk pengembangan non-linear (Lihat Bab 3).

## Dasar Git ##

Jadi, sebenarnya apa yang dimaksud dengan Git? Ini adalah bagian penting untuk dipahami, karena jika anda memahami apa itu Git dan cara kerjanya, maka dapat dipastikan anda dapat menggunakan Git secara efektif dengan mudah. Selama mempelajari Git, cobalah untuk melupakan VCS lain yang mungkin telah anda kenal sebelumnya, misalnya Subversion dan Perforce. Git sangat berbeda dengan sistem-sistem tersebut dalam hal menyimpan dan memperlakukan informasi yang digunakan, walaupun antar-muka penggunanya hampir mirip. Dengan memahami perbedaan tersebut diharapkan dapat membantu anda menghindari kebingungan saat menggunakan Git.

### Snapshots, Not Differences ###

Salah satu perbedaan yang mencolok antar Git dengan VCS lainnya (Subversion dan kawan-kawan) adalah dalam cara Git memperlakukan datanya. Secara konseptual, kebanyakan sistem lain menyimpan informasi sebagai sebuah daftar perubahan berkas. Sistem seperti ini (CVS, Subversion, Bazaar, dan yang lainnya) memperlakukan informasi yang disimpannya sebagai sekumpulan berkas dan perubahan yang terjadi pada berkas-berkas tersebut, sebagaimana yang diperlihatkan pada Gambar 1-4.

Insert 18333fig0104.png 
Gambar 1-4. Sistem lain menyimpan data perubahan terhadap versi awal setiap berkas.

Git tidak bekerja seperti ini. Melainkan, Git memperlakukan datanya sebagai sebuah kumpulan snapshot dari sebuah miniatur sistem berkas. Setiap kali anda melakukan commit, atau melakukan perubahan pada proyek Git anda, pada dasarnya Git merekam gambaran keadaan berkas-berkas anda pada saat itu dan menyimpan referensi untuk gambaran tersebut. Agar efisien, jika berkas tidak mengalami perubahan, Git tidak akan menyimpan berkas tersebut melainkan hanya pada file yang sama yang sebelumnya telah disimpan. Git memperlakukan datanya seperti terlihat pada Gambar 1-5.

Insert 18333fig0105.png 
Gambar 1-5. Git menyimpan datanya sebagai snapshot dari proyek setiap saat.

This is an important distinction between Git and nearly all other VCSs. It makes Git reconsider almost every aspect of version control that most other systems copied from the previous generation. This makes Git more like a mini filesystem with some incredibly powerful tools built on top of it, rather than simply a VCS. We’ll explore some of the benefits you gain by thinking of your data this way when we cover Git branching in Chapter 3.

### Hampir Semua Operasi Dilakukan Secara Lokal ###

Kebanyakan operasi pada Git hanya membutuhkan berkas-berkas dan resource lokal – tidak ada informasi yang dibutuhkan dari komputer lain pada jaringan anda. If you’re used to a CVCS where most operations have that network latency overhead, this aspect of Git will make you think that the gods of speed have blessed Git with unworldly powers. Because you have the entire history of the project right there on your local disk, most operations seem almost instantaneous.

Sebagai contoh, untuk melihat history dari proyek, Git tidak membutuhkan data histori dari server untuk kemudian menampilkannya untuk anda, namun secara sedarhana Git membaca historinya langsung dari basisdata lokal proyek tersebut. Ini berarti anda melihat histori proyek hampir secara instant. Jika anda ingin membandingkan perubahan pada sebuah berkas antara versi saat ini dengan versi sebulan yang lalu, Git dapat mencari berkas yang sama pada sebulan yang lalu dan melakukan pembandingan perubahan secara lokal, bukan dengan cara meminta remote server melakukannya atau meminta server mengirimkan berkas versi yang lebih lama kemudian membandingkannya secara lokal.

Hal ini berarti bahwa sangat sedikit yang tidak bisa anda kerjakan jika anda sedang offline atau berada diluar VPN. Jika anda sedang berada dalam pesawat terbang atau sebuah kereta dan ingin melakukan pekerjaan kecil, anda dapat melakukan commit sampai anda memperoleh koneksi internet hingga anda dapat menguploadnya. Jika anda pulang ke rumah dan VPN client anda tidak bekerja dengan benar, anda tetap dapat bekerja. Pada kebanyakan sistem lainnya, melakukan hal ini cukup sulit atau bahkan tidak mungkin sama sekali. Pada Perforce misalnya, anda tidak dapat berbuat banyak ketika anda tidak terhubung dengan server; pada Subversion dan CVS, anda dapat mengubah berkas, tapi anda tidak dapat melakukan commit pada basisdata anda (karena anda tidak terhubung dengan basisdata). Hal ini mungkin saja bukanlah masalah yang besar, namun anda akan terkejut dengan perbedaan besar yang disebabkannya.

### Git Memiliki Integritas ###

Segala sesuatu pada Git akan melalui proses checksum terlebih dahulu sebelum disimpan yang kemudian direferensikan oleh hasil checksum tersebut. Hal ini berarti tidak mungkin melakukan perubahan terhadap berkas manapun tanpa diketahui oleh Git. Fungsionalitas ini dimiliki oleh Git pada level terendahnya dan ini merupakan bagian tak terpisahkan dari filosofi Git. Anda tidak akan kehilangan informasi atau mendapatkan file yang cacat tanpa diketahui oleh Git.

Mekanisme checksum yang digunakan oleh Git adalah SHA-1 hash. Ini merupakan sebuah susunan string yang terdiri dari 40 karakter heksadesimal (0 hingga 9 dan a hingga f) dan dihitung berdasarkan isi dari sebuah berkas atau struktur direktori pada Git. sebuah hash SHA-1 berupa seperti berikut:

	24b9da6552252987aa493b52f8696cd6d3b00373

Anda akan melihat nilai seperti ini pada berbagai tempat di Git. Faktanya, Git tidak menyimpan nama berkas pada basisdatanya, melainkan nilai hash dari isi berkas.

### Secara Umum Git Hanya Menambahkan Data ###

Ketika anda melakukan operasi pada Git, kebanyakan dari operasi tersebut hanya menambahkan data pada basisdata Git. It is very difficult to get the system to do anything that is not undoable or to make it erase data in any way. Seperti pada berbagai VCS, anda dapat kehilangan atau mengacaukan perubahan yang belum di-commit; namun jika anda melakukan commit pada Git, akan sangat sulit kehilanngannya, terutama jika anda secara teratur melakukan push basisdata anda pada repositori lain.

Hal ini menjadikan Git menyenangkan karena kita dapat berexperimen tanpa kehawatiran untuk mengacaukan proyek. Untuk lebih jelas dan dalam lagi tentang bagaimana Git menyimpan datanya dan bagaimana anda dapat mengembalikan yang hilang, lihat "Under the Covers" pada Bab 9.

### Tiga Keadaan ###

Sekarang perhatika. Ini adalah hal utama yang harus diingat tentang Git jika anda ingin proses belajar anda berjalan lancar. Git memiliki 3 keadaan utama dimana berkas anda dapat berada: committed, modified dan staged. Committed berarti data telah tersimpan secara aman pada basisdata lokal. Modified berarti anda telah melakukan perubahan pada berkas namun anda belum melakukan commit pada basisdata. Staged berarti anda telah menandai berkas yang telah diubah pada versi yang sedang berlangsung untuk kemudian dilakukan commit.

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

## Menginstall Git ##

Mari memulai menggunakan Git. Pertama, tentu saja anda harus menginstallnya terlebih dahulu. Anda dapat melakukan melalui berbagai cara; dua cara paling poluler adalah menginstallnya dari kode sumbernya atau menginstalkan paket yang telah disediakan untuk platform anda.

### Menginstall Dari Kode Sumber ###

Jika anda dapat melakukannya, akan sangat berguna untuk dapat menginstallnya dari kode sumber, karena anda akan mendapatkan versi terbaru dari Git. Setiap versi dari Git cenderung akan menampilkan kemajuan pada sisi antarmuka pengguna, jadi menggunakan versi terbaru seringkali menjadi jalan terbaik jika anda terbiasa melakukan kompilasi perangkat lunak dari kode sumbernya. Dan juga menjadi masalah bahwa banyak distribusi Linux yang menyertakan versi Git yang sangat lama; kecuali anda mempergunakan distribusi Linux paling up-to-date atau menggunakan backport, menginstall dari kode sumbernya mungkin menjadi solusi terbaik.

Untuk menginstall Git, anda membutuhkan beberapa library yang dibutuhkan oleh Git: curl, zlib, openssl, expat, dan libiconv. Sebagai contoh, jika anda berada pada sistem yang menggunakan yum (seperti Fedora) atau apt-get (seperti sistem berbasis Debian), anda dapat menggunakan salah satu dari perintah berikut untuk menginstall semua library yang dibutuhkan oleh Git:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev

Setelah anda memperoleh semua library yang dibutuhkan, anda kemudian dapat melanjutkan dengan mengunduh Git dari situsnya:

	http://git-scm.com/download
	
Kemudian, kompilasi dan install:

	$ tar -zxf git-1.6.0.5.tar.gz
	$ cd git-1.6.0.5
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

Setelah semua ini selesai, anda juga dapat memperoleh Git terbaru melalui Git sendiri:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	
### Menginstall Git di Linux ###

Jika anda ingin menginstall Git di Linux menggunakan installer biner, anda bisa melakukannya melalui perkakas manajemen paket yang anda pada distribusi Linux yang anda gunakan. Jika anda menggunakan Fedora, anda dapat menggunakan yum:

	$ yum install git-core

Atau jika anda menggunakan distro berbasis Debian seperti Ubuntu, coba gunakan apt-get:

	$ apt-get install git-core

### Menginstall Git pada Mac ###

Terdapat dua cara mudah untuk menginstal Git pada sebuah komputer Mac. Cara termudah adalah menggunakan installer Git berbasis GUI, yang dapat anda peroleh dari halaman Google Code (lihat Gambar 1-7):

	http://code.google.com/p/git-osx-installer

Insert 18333fig0107.png 
Gambar 1-7. Git OS X installer.

Cara lainnya adalah dengan menggunakan MacPorts (`http://www.macports.org`). Jika anda telah menginstall MacPorts, maka anda dapat menginstall Git melalui cara berikut

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

Anda tidak harus menambahkan extras-nya, tetapi anda mungkin membutuhkan +svn jika anda harus menggunakan Git pada repositori Subversion (lihat Bab 8).

### Menginstall pada Sistem Operasi Windows ###

Menginstall Git pada Windows sangatlah mudah. Cara termudah dapat anda peroleh dengan menggunakan msysGit. Cukup download file installernya dari halaman Google Code, lalu eksekusi.

	http://code.google.com/p/msysgit

Setelah terinstall, anda akan memperoleh versi command-line (bersama dengan klien SSH yang praktis) dan versi GUI-nya.

## Setup Git Untuk Pertama Kalinya ##

Sekarang anda telah memiliki Git pada sistem anda, berikutnya anda akan harus melakukan beberapa penyesuai pada lingkungan Git anda. Anda hanya perlu melakukan hal ini sekali saja; pada saat memperbaharui versi Git anda, penyesuai tidak perlu dilakukan lagi. Anda pun dapat mengubah penyesuaian tersebut setiap saat.

Pada Git terdapat sebuah perkakas yang disebut dengan git config yang memungkinkan anda untuk memperoleh informasi dan menetapkan variable konfigurasi yang mengontrol segala aspek bagaimana Git beroperasi dan berperilaku. Variable-variable ini dapat disimpan pada tiga tempat berbeda:

*	`/etc/gitconfig` file: Menyimpan berbagai nilai-nilai variable untuk setiap pengguna pada sistem dan semua repositori milik para pengguna tersebut. Jika anda memberikan opsi `--system` pada `git config`, maka Git akan membaca dan menulis file konfigurasi ini secara spesifik.
*	`~/.gitconfig` file: Spesifik hanya untuk pengguna yang bersangkutan. Anda dapat membuat Git membaca dan menulis pada berkas ini secara spesifik dengan memberikan opsi `--global`. 
*	config file pada direktori git (yaitu, `.git/config`) atau reposotori manapun yang sedang anda gunakan: Spesifik hanya pada repositori itu saja. Setiap nilai pada setiap tingkat akan selalu menimpa nilai yang telah ditetapkan pada level sebelumnya, jadi nilai yang telah di-set pada `.git/config` akan menimpa nilai yang telah di-set pada `/etc/gitconfig`.

Pada Sistem Operasi Windows, Git akan mencari berkas `.gitconfig` pada direktori `$HOME` (`C:\Documents and Settings\$USER` untuk kebanyakan kasus). Selain itu juga akan mencari /etc/gitconfig, direktori ini relatif terhadap direktori root MSys, yang mana tergantung dari direktori yang dipilih saat anda menginstall Git pada Windows anda.

### Identitas Anda ###

Hal pertama yang harus anda lakukan ketika menginstalkan Git adalah mengatur username dan alamat e-mail anda. Hal ini penting karena setiap commit pada Git akan menggunakan informasi ini, dan informasi ini akan selamanya disimpan dengan commit yang anda buat tersebut:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Lagi-lagi, anda hanya perlu melakukan ini sekali saja jika anda menggunakan opsi `--global`, karena Git akan selalu menggunakan informasi tersebut selama anda berada pada sistem yang sama. Jika anda ingin menimpa informasi ini dengan menggunakan e-mail atau username yang berbeda untuk proyek tertentu, anda dapat perintah tersebut tanpa menggunakan opsi `--global` ketika anda berada pada proyek tersebut.

### Editor Anda ###

Sekarang identitas anda telah siap, berikutnya anda dapat memilih text editor default yang akan digunakan manakala Git membutuhkan anda untuk menulis sebuah pesan. Secara default, Git akan menggunakan default editor sesuai dengan sistem operasi, biasanya adalah Vi atau Vim pada sistem Unix. Jika anda ingin menggunakan text editor yang lainnya, seperti Emacs, anda dapat melakukan perintah seperti berikut:

	$ git config --global core.editor emacs
	
### Perkakas Diff Anda ###

Opsi lainnya yang mungkin berguna dan mungkin ingin anda ubah adalah perkakas diff yang digunakan untuk menyelesaikan konflik yang terjadi ketika dilakukannya merge (penggabungan). Katakanlah anda ingin menggunakan vimdiff:

	$ git config --global merge.tool vimdiff

Git dapat menggunakan berbagai perkakas diff ini diantaranya kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge, dan opendiff. Anda pun dapat menggunakan perkakas kastem; lihat Bab 7 untuk informasi lebih jauh lagi mengenai hal tersebut.

### Mengecek Settingan Anda ###

Jika anda ingin mengecek settingan anda, anda dapat menggunakan peritah `git config --list` untuk menampilkan semua settingan yang digunakan Git:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

Anda mungkin akan melihat beberapa variable yang ditampilkan lebih dari sekali, hal ini terjadi karena variable yang sama diperoleh dari beberapa file konfigurasi berbeda (misalnya, `/etc/gitconfig` dan `~/.gitconfig`). Pada kasus seperti ini, Git hanya akan menggunakan nilai yang terlihat paling akhir saja.

Andapun dapat melihat apa nilai yang Git pergunakan untuk suatu variable secara spesifik dengan mengunakan `git config {key}`:

	$ git config user.name
	Scott Chacon

## Memperoleh Pertolongan ##

Jika anda membutuhkan pertolongan ketika menggunakan Git, terdapat 3 cara yang dapat digunakan untuk membuka halaman manual (manpage) untuk setiap perintah Git:

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

Sebagai contoh, anda dapat memperoleh halaman manual untuk perintah config dengan menjalankan perintah:

	$ git help config

Perintah ini sangatlah luar biasa karena anda dapat mengaksesnya kapan saja, bahkan ketika sedang offline.
Jika manpage dan buku ini tidaklah cukup, dan anda membutuhkan pertolongan dari seorang manusia, anda dapat mencoba channel `#git` atau `#github` pada Freenode IRC server (irc.freenode.net). Channel ini biasanya berisi ratusan orang yang memiliki pengetahuan tentang Git dan sering kali memiliki kemauan untuk menolong.

## Kesimpulan ##

Sekarang anda memiliki pengetahuan dasar mengenai apa yang dimaksud dengan Git dan perbedaannya dari VCS terpusat yang mungkin pernah anda gunakan. Anda pun seharusnya sekarang memiliki Git pada sistem anda yang telah diatur dengan identitas personal anda. Sekarang saatnya untuk mempelajari beberapa dasar Git.
