# Dasar-dasar Git #

Jika Anda hanya sempat membaca satu bab untuk dapat bekerja dengan Git, bab inilah yang tepat. Bab ini menjelaskan setiap perintah dasar yang Anda butuhkan untuk menyelesaikan sebagian besar permasalahan yang akan Anda hadapi dalam penggunaan Git. Pada akhir bab, Anda akan dapat mengkonfigurasi dan memulai sebuah repositori, memulai dan mengakhiri pemantauan berkas, dan melakukan staging dan committing perubahannya. Kami juga akan menunjukkan kepada Anda cara menata Git untuk mengabaikan berkas-berkas ataupun pola berkas tertentu, cara untuk membatalkan kesalahan secara cepat dan mudah, cara untuk melihat sejarah perubahan dari proyek dan melihat perubahan-perubahan yang telah terjadi diantara commit, dan cara untuk mendorong dan menarik perubahan dari repositori lain.

## Mengambil Repositori Git ##

Anda dapat mengambil sebuah proyek Git melalui 2 pendekatan utama. Cara pertama adalah dengan mengambil proyek atau direktori tersedia untuk dimasukkan ke dalam Git. Cara kedua adalah dengan melakukan kloning/duplikasi dari repositori Git yang sudah ada dari server. 

### Memulai Repository di Direktori Tersedia ###

Jika Anda mulai memantau proyek yang sudah ada menggunakan Git, Anda perlu masuk ke direktori dari proyek tersebut dan mengetikkan

	$ git init

Git akan membuat sebuah subdirektori baru bernama .git yang akan berisi semua berkas penting dari repositori Anda, yaitu kerangka repositori dari Git. Pada titik ini, belum ada apapun dari proyek Anda yang dipantau. (Lihat Bab 9 untuk informasi lebih lanjut mengenai berkas apa saja yang terdapat di dalam direktori `.git` yang baru saja kita buat.)

Jika Anda ingin mulai mengendalikan versi dari berkas tersedia (bukan direktori kosong), Anda lebih baik mulai memantau berkas tersebut dengan melakukan commit awal. Caranya adalah dengan beberapa perintah `git add` untuk merumuskan berkas yang ingin anda pantau, diikuti dengan sebuah commit:

	$ git add *.c
	$ git add README
	$ git commit –m 'versi awal proyek'

Kita akan membahas apa yang dilakukan perintah-perintah di atas sebentar lagi. Pada saat ini, Anda sudah memiliki sebuah repositori Git berisi file-file terpantau dan sebuah commit awal.

### Duplikasi Repositori Tersedia ###

Jika Anda ingin membuat salinan dari repositori Git yang sudah tersedia — misalnya, dari sebuah proyek yang Anda ingin ikut berkontribusi di dalamnya — perintah yang Anda butuhkan adalah `git clone`. Jika Anda sudah terbiasa dengan sistem VCS lainnya seperti Subversion, Anda akan tersadar bahwa perintahnya adalah clone dan bukan checkout. Ini adalah pembedaan yang penting — Git menerima salinan dari hampir semua data yang server miliki. Setiap versi dari setiap berkas yang tercatat dalam sejarah dari proyek tersebut akan ditarik ketika Anda menjalankan `git clone`. Bahkan, ketika cakram di server Anda rusak, Anda masih dapat menggunakan hasil duplikasi di klien untuk mengembalikan server Anda ke keadaan tepat pada saat duplikasi dibuat (Anda mungkin kehilangan beberapa hooks atau sejenisnya yang sebelumnya telah ditata di sisi server, namun semua versi data sudah kembali seperti sediakala-lihat Bab 4 untuk lebih detil).

Anda menduplikasi sebuah repositori menggunakan perintah `git clone [url]`. Sebagai contoh, jika Anda ingin menduplikasi pustaka Git Ruby yang disebut Grit, Anda dapat melakukannya sebagai berikut:

	$ git clone git://github.com/schacon/grit.git

Perintah ini akan membuat sebuah direktori yang dinamakan "grit", menata awal sebuah direktori `.git` di dalamnya, menarik semua data dari repositori, dan `checkout` versi mutakhir dari salinan kerja. Jika Anda masuk ke dalam direktori `grit` tersebut, Anda akan melihat berkas-berkas proyek sudah ada di sana, siap untuk digunakan. Jika Anda ingin membuat duplikasi dari repositori tersebut ke direktori yang tidak dinamakan grit, Anda harus merumuskan namanya sebagai opsi di perintah di atas:

	$ git clone git://github.com/schacon/grit.git mygrit

Perintah ini bekerja seperti perintah sebelumnya, namun direktori tujuannya akan diberi nama mygrit.

Git memiliki beberapa protokol transfer yang berbeda yang dapat digunakan. Pada contoh sebelumnya, kita menggunakan protokol `git://`, tetapi Anda juga dapat menggunakan `http(s)://` atau `user@server:/path.git`, yang akan menggunakan SSH sebagai protokol transfer. Bab 4 akan memperkenalkan Anda kepada semua opsi yang tersedia yang dapat ditata di sisi server untuk mengakses repositori Git Anda dan keuntungan dan kelebihan dari masing-masing protokol.

## Merekam Perubahan ke dalam Repositori ##

Anda sudah memiliki repositori Git yang bonafide dan sebuah salinan kerja dari semua berkas untuk proyek tersebut. Anda harus membuat beberapa perubahan dan commit perubahan tersebut ke dalam repositori setiap saat proyek mencapai sebuah keadaan yang ingin Anda rekam.

Ingat bahwa setiap berkas di dalam direktori kerja Anda dapat berada di 2 keadaan: terpantau atau tak-terpantau. Berkas terpantau adalah berkas yang sebelumnya berada di snapshot terakhir; mereka dapat berada dalam kondisi belum terubah, terubah, ataupun staged (berada di area stage). Berkas tak-terpantau adalah kebalikannya - merupakan berkas-berkas di dalam direktori kerja yang tidak berada di dalam snapshot terakhir dan juga tidak berada di area staging. Ketika Anda pertama kali menduplikasi sebuah repositori, semua berkas Anda akan terpantau dan belum terubah karena Anda baru saja melakukan checkout dan belum mengubah apapun.

Sejalan dengan proses edit yang Anda lakukan terhadap berkas-berkas tersebut, Git mencatatnya sebagai terubah, karena Anda telah mengubahnya sejak terakhir commit. Anda kemudian memasukkan berkas-berkas terubah ini ke dalam area stage untuk kemudian dilakukan commit, dan terus siklus ini berulang. Siklus perubahan ini diilustrasikan di Figure-2.1 

Insert 18333fig0201.png 
Figure 2-1. The lifecycle of the status of your files.

### Cek Status dari Berkas Anda ###

Alat utama yang Anda gunakan untuk menentukan berkas-berkas mana yang berada dalam keadaan tertentu adalah melalui perintah `git status`. Jika Anda menggunakan alat ini langsung setelah sebuah `clone`, Anda akan melihat serupa seperti di bawah ini:

	$ git status
	# On branch master
	nothing to commit, working directory clean

Ini berarti Anda memiliki direktori kerja yang bersih-dengan kata lain, tidak ada berkas terpantau yang terubah. Git juga tidak melihat berkas-berkas yang tak terpantau, karena pasti akan dilaporkan oleh alat ini. Juga, perintah ini memberitahu Anda tentang cabang tempat Anda berada. Pada saat ini, cabang akan selalu berada di master, karena sudah menjadi default-nya; Anda tidak perlu khawatir tentang cabang dulu. Bab berikutnya akan membahas tentang percabangan dan referensi secara lebih detil.

Mari kita umpamakan Anda menambah sebuah berkas baru ke dalam proyek Anda, misalnya sesederhana berkas README. Jika file tersebut belum ada sebelumnya, dan Anda melakukan `git status`, Anda akan melihatnya sebagai berkas tak-terpantau seperti berikut ini:

	$ vim README
	$ git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#	README
	nothing added to commit but untracked files present (use "git add" to track)

Anda akan melihat bahwa berkas baru Anda README belum terpantau, karena berada di bawah judul "Untracked files" di keluaran status Anda. Untracked pada dasarnya berarti bahwa Git melihat sebuah berkas yang sebelumnya tidak Anda miliki di snapshot (commit) sebelumnya; Git tidak akan mulai memasukkannya ke dalam snapshot commit hingga Anda secara eksplisit memerintahkan Git. Git berlaku seperti ini agar Anda tidak secara tak-sengaja mulai menyertakan berkas biner hasil kompilasi atau berkas lain yang tidak Anda inginkan untuk disertakan. Anda hanya ingin mulai menyertakan README, mari kita mulai memantau berkas tersebut.

### Memantau Berkas Baru ###

Untuk mulai memantau berkas baru, Anda menggunakan perintah `git add`. Untuk mulai memantau berkas README tadi, Anda menjalankannya seperti berikut:

	$ git add README

Jika Anda menjalankan perintah `status` lagi, Anda akan melihat bahwa berkas README Anda sekarang sudah terpantau dan sudah masuk ke dalam area stage:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#

Anda dapat mengatakan bahwa berkas tersebut berada di dalam area stage karena tertulis di bawah judul "Changes to be committed". Jika Anda melakukan commit pada saat ini, versi berkas pada saat Anda menjalankan `git add` inilah yang akan dimasukkan ke dalam sejarah snapshot. Anda mungkin ingat bahwa ketika Anda menjalankan `git init` sebelumnya, Anda melanjutkannya dengan `git add (nama berkas)` - yang akan mulai dipantau di direktori Anda. Perintah `git add` ini mengambil alamat dari berkas ataupun direktori; jika sebuah direktori, perintah tersebut akan menambahkan seluruh berkas yang berada di dalam direktori secara rekursif.

### Memasukkan Berkas Terubah ke Dalam Area Stage ###

Mari kita ubah sebuah berkas yang sudah terpantau. Jika Anda mengubah berkas yang sebelumnya terpantau bernama `benchmarks.rb` dan kemudian menjalankan perintah `status` lagi, Anda akan mendapatkan keluaran kurang lebih seperti ini:

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

Berkas benchmarks.rb terlihat di bawah bagian yang bernama "Changes not staged for commit" - yang berarti bahwa sebuah berkas terpantau telah berubah di dalam direktori kerja namun belum masuk ke area stage. Untuk memasukkannya ke area stage, Anda menjalankan perintah `git add` (perintah ini adalah perintah multiguna - Anda menggunakannya untuk mulai memantau berkas baru, untuk memasukkannya ke area stage, dan untuk melakukan hal lain seperti menandai berkas terkonflik menjadi terpecahkan). Mari kita sekarang jalankan `git add` untuk memasukkan berkas benchmarks.rb ke dalam area stage, dan jalankan `git status` lagi:

	$ git add benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#

Kedua file sekarang berada di area stage dan akan masuk ke dalam commit Anda berikutnya. Pada saat ini, semisal Anda teringat satu perubahan yang Anda ingin buat di benchmarks.rb sebelum Anda lakukan commit. Anda buka berkas tersebut kembali dan melakukan perubahan tersebut, dan Anda siap untuk melakukan commit. Namun, mari kita coba jalankan `git status` kembali:

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

Apa? Sekarang benchmarks.rb terdaftar di dua tempat: area stage dan area terubah. Bagaimana hal ini bisa terjadi? Ternyata Git memasukkan berkas ke area stage tepat seperti ketika Anda menjalankan perintah `git add`. Jika Anda commit sekarang, versi benchmarks.rb pada saat Anda terakhir lakukan perintah `git add`-lah yang akan masuk ke dalam commit, bukan versi berkas yang saat ini terlihat di direktori kerja Anda ketika Anda menjalankan `git commit`. Jika Anda mengubah sebuah berkas setelah Anda menjalankan `git add`, Anda harus menjalankan `git add` kembali untuk memasukkan versi berkas terakhir ke dalam area stage:

	$ git add benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#

### Mengabaikan Berkas ###

Terkadang, Anda memiliki sekumpulan berkas yang Anda tidak ingin Git tambahkan secara otomatis atau bahkan terlihat sebagai tak-terpantau. Biasanya berkas hasil keluaran seperti berkas log atau berkas yang dihasilkan oleh sistem build Anda. Dalam kasus ini, Anda dapat membuat sebuah berkas bernama .gitignore yang berisi pola dari berkas terabaikan. Berikut adalah sebuah contoh isi dari berkas .gitignore:

	$ cat .gitignore
	*.[oa]
	*~

Baris pertama memberitahu Git untuk mengabaikan semua file yang berakhiran .o atau .a - berkas object dan arsip yang mungkin dihasilkan dari kompilasi kode Anda. Baris kedua memberitahu Git untuk mengabaikan semua file yang berakhiran dengan sebuah tilde (`~`), yang biasanya digunakan oleh banyak aplikasi olah-kata seperti Emacs untuk menandai berkas sementara. Anda juga dapat memasukkan direktori log, tmp ataupun pid; dokumentasi otomatis; dan lainnya. Menata berkas .gitignore sebelum Anda mulai bekerja secara umum merupakan ide yang baik sehingga Anda tidak secara tak-sengaja melakukan commit terhadap berkas yang sangat tidak Anda inginkan berada di dalam repositori Git.

Aturan untuk pola yang dapat Anda gunakan di dalam berkas .gitignore adalah sebagai berikut:

*	Baris kosong atau baris dimulai dengan # akan diabaikan.
*	Pola glob standar dapat digunakan.
*	Anda dapat mengakhir pola dengan sebuah slash (`/`) untuk menandai sebuah direktori.
*	Anda dapat menegasikan sebuah pola dengan memulainya menggunakan karakter tanda seru (`!`).

Pola Glob adalah seperti regular expression yang disederhanakan yang biasanya digunakan di shell. Sebuah asterisk (`*`) berarti 0 atau lebih karakter; `[abc]` terpasangkan dengan karakter apapun yang ditulis dalam kurung siku (dalam hal ini a, b, atau c); sebuah tanda tanya (`?`) terpasangkan dengan sebuah karakter; dan kurung siku yang melingkupi karakter yang terpisahkan dengan sebuah tanda hubung(`[0-9]`) terpasangkan dengan karakter apapun yang berada diantaranya (dalam hal ini 0 hingga 9).

Berikut adalah contoh lain dari isi berkas .gitignore:

	# sebuah komentar – akan diabaikan
	# abaikan berkas .a
	*.a
	# tapi pantau lib.a, walaupun Anda abaikan berkas .a di atas
	!lib.a
	# hanya abaikan berkas TODO yang berada di rooto, bukan di subdir/TODO
	/TODO
	# abaikan semua berkas di dalam direktori build/
	build/
	# abaikan doc/notes.txt, tapi bukan doc/server/arch.txt
	doc/*.txt

### Melihat Perubahan di Area Stage dan di luar Area Stage ###

Jika perintah `git status` terlalu kabur untuk Anda - Anda ingin mengetahui secara pasti apa yang telah berubah, bukan hanya berkas mana yang berubah - Anda dapat menggunakan perintah `git diff`. Kita akan bahas `git diff` secara lebih detil nanti; namun Anda mungkin menggunakannya paling sering untuk menjawab 2 pertanyaan berikut: Apa yang Anda ubah tapi belum dimasukkan ke area stage? Dan apa yang telah Anda ubah yang akan segera Anda commit? Walaupun `git status` menjawab pertanyaan tersebut secara umum, `git diff` menunjukkan kepada Anda dengan tepat baris yang ditambahkan dan dibuang - dalam bentuk patch-nya.

Mari kita anggap Anda mengubah dan memasukkan berkas README ke area stage lagi dan kemudian mengubah berkas benchmarks.rb tanpa memasukkannya ke area stage. Jika Anda jalankan perintah `status` Anda, Anda akan sekali lagi melihat keluaran seperti berikut:

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

Untuk melihat apa yang Anda telah ubah namun belum masuk ke area stage, ketikkan `git diff` tanpa argumen lainnya.

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

Perintah di atas membandingkan apa yang ada di direktori kerja Anda dengan apa yang ada di area stage. Hasilnya memberitahu Anda bahwa perubahan yang Anda ubah namun belum masuk ke area stage.

Jika Anda ingin melihat apa yang telah Anda masukkan ke area stage yang nantinya akan masuk ke commit Anda berikutnya, Anda dapat menggunakan `git diff --cached`. (Di Git versi 1.6.1 atau yang lebih tinggi, Anda dapat juga menggunakan `git diff --staged`, yang mungkin lebih mudah untuk diingat). Perintah ini membandingkan area stage Anda dengan commit Anda terakhir:

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

Satu hal penting yang harus dicatat adalah bahwa `git diff` saja tidak memperlihatkan semua perubahan yang telah Anda lakukan sejak terakhir Anda commit - hanya perubahan yang belum masuk ke area stage saja. Mungkin agak sedikit membingungkan, karena jika Anda telah memasukkan semua perubahan ke area stage, `git diff` akan memberikan keluaran kosong.

Sebagai contoh lain, jika Anda memasukkan berkas benchmarks.rb ke area stage dan kemudian meng-editnya, Anda dapat menggunakan `git diff` untuk melihat perubahan di berkas tersebut yang telah masuk ke area stage dan perubahan yang masih di luar area stage:

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

Sekarang Anda dapat menggunakan `git diff` untuk melihat apa saja yang masih belum dimasukkan ke area stage:

	$ git diff 
	diff --git a/benchmarks.rb b/benchmarks.rb
	index e445e28..86b2f7c 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -127,3 +127,4 @@ end
	 main()

	 ##pp Grit::GitRuby.cache_client.stats 
	+# test line

dan `git diff --cached` untuk melihat apa yang telah Anda masukkan ke area stage sejauh ini:

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

### Commit Perubahan Anda ###

Sekarang setelah area stage Anda tertata sebagaimana yang Anda inginkan, Anda dapat melakukan commit terhadap perubahan Anda. Ingat bahwa apapun yang masih di luar area stage - berkas apapun yang Anda telah buat atau ubah yang belum Anda jalankan `git add` terhadapnya sejak terakhir Anda edit - tidak akan masuk ke dalam commit ini. Perubahan tersebut akan tetap sebagai berkas terubah di cakram Anda. 
Dalam hal ini, saat terakhir Anda jalankan `git status`, Anda telah melihat bahwa semuanya telah masuk ke stage, sehingga Anda siap untuk melakukan commit dari perubahan Anda. Cara termudah untuk melakukan commit adalah dengan mengetikkan `git commit`:

	$ git commit

Dengan melakukan ini, aplikasi olahkata pilihan Anda akan terjalankan (Ini ditata oleh variabel lingkungan `$EDITOR` di shell Anda - biasanya vim atau emacs, walaupun Anda dapat mengkonfigurasinya dengan apapun yang Anda inginkan menggunakan perintah `git config -- global core.editor` yang telah Anda lihat di Bab 1).

Aplikasi olahkata akan menampilakn teks berikut (contoh berikut adalah dari layar Vim):

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

Anda dapat melihat bahwa pesan commit standar berisi keluaran terakhir dari perintah `git status` yang terkomentari dan sebuah baris kosong di bagian atas. Anda dapat membuang komentar-komentar ini dan mengetikkan pesan commit Anda, atau Anda dapat membiarkannya untuk membantu Anda mengingat apa yang akan Anda commit. (Untuk pengingat yang lebih eksplisit dari apa yang Anda ubah, Anda dapat menggunakan opsi `-v` di perintah `git commit`. Melakukan hal ini akan membuat diff dari perubahan Anda di dalam olahkata sehingga Anda dapat melihat secara tepat apa yang telah Anda lakukan). Ketika Anda keluar dari olahkata, Git akan membuat commit Anda dengan pesan yang Anda buat (dengan bagian terkomentari dibuang).

Cara lainnya, Anda dapat mengetikkan pesan commit Anda sebaris denegan perintah `commit` dengan mencantumkannya setelah tanda -m seperti berikut:

	$ git commit -m "Story 182: Fix benchmarks for speed"
	[master]: created 463dc4f: "Fix benchmarks for speed"
	 2 files changed, 3 insertions(+), 0 deletions(-)
	 create mode 100644 README

Sekarang Anda telah membuat commit pertama Anda~ Anda dapat lihat bahwa commit tersebut telah memberi Anda beberapa keluaran tentang dirinya sendiri: cabang apa yang Anda jadikan target commit (master), ceksum SHA-1 apa yang commit tersebut miliki (`463dc4f`), berapa banyak berkas yang diubah, dan statistik tentang jumlah baris yang ditambah dan dibuang dalam commit tersebut.

Ingat bahwa commit merekam snapshot yang Anda telah tata di area stage. Apapun yang tidak Anda masukkan ke area stage akan tetap berada di tempatnya, tetap dalam keadaan terubah; Anda dapat melakukan commit lagi untuk memasukkannya ke dalam sejarah Anda. Setiap saat Anda melakukan sebuah commit, Anda merekamkan sebuah snapshot dari proyek Anda yang bisa Anda kembalikan atau Anda bandingkan nantinya.

### Melewatkan Area Stage ###

Walaupun dapat menjadi sangat berguna untuk menata commit tepat sebagaimana Anda inginkan, area stage terkadang sedikit lebih kompleks dibandingkan apa yang Anda butuhkan di dalam alurkerja Anda. Jika Anda ingin melewatkan area stage, Git menyediakan sebuah jalan pintas sederhana. Dengan memberikan opsi `-a` ke perintah `git commit` akan membuat Git secara otomatis menempatkan setiap berkas yang telah terpantau ke area stage sebelum melakukan commit, membuat Anda dapat melewatkan bagian `git add`:

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

Perhatikan bagaimana Anda tidak perlu menjalankan `git add` terhadap berkas benchmarks.rb dalam hal ini sebelum Anda commit.

### Menghapus Berkas ###

Untuk menghapus sebuah berkas dari Git, Anda harus menghapusnya dari berkas terpantau (lebih tepatnya, mengpus dari area stage) dan kemudian commit. Perintah `git rm` melakukan hal tadi dan juga menghapus berkas tersebut dari direktori kerja Anda sehingga Anda tidak melihatnya sebagai berkas yang tak terpantau nantinya.

Jika Anda hanya menghapus berkas dari direktori kerja Anda, berkas tersebut akan muncul di bagian "Changes not staged for commit" (yaitu, di luar area stage) dari keluaran `git status` Anda:

	$ rm grit.gemspec
	$ git status
	# On branch master
	#
	# Changes not staged for commit:
	#   (use "git add/rm <file>..." to update what will be committed)
	#
	#       deleted:    grit.gemspec
	#

Kemudian, jika Anda jalankan `git rm`, Git akan memasukkan penghapusan berkas tersebut ke area stage:

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

Pada saat Anda commit nantinya, berkas tersebut akan hilang dan tidak lagi terpantau. Jika Anda mengubah berkas tersebut dan menambahkannya lagi ke index, Anda harus memaksa penghapusannya dengan menggunakan opsi `-f`. Ini adalah fitur keamanan (safety) untuk mencegah ketidaksengajaan penghapusan terhadap data yang belum terekam di dalam snapshot dan tak dapat dikembalikan oleh Git.

Hal berguna lain yang Anda dapat lakukan adalah untuk tetap menyimpan berkas di direktori kerja tetapi menghapusnya dari area kerja. Dengan kata lain, Anda mungkin ingin tetap menyimpan berkas tersebut di dalam cakram keras tetapi tidak ingin Git untuk memantaunya lagi. Hal ini khususnya berguna jika Anda lupa untuk menambahkan sesuaitu ke berkas `.gitignore` Anda dan secara tak-sengaja menambahkannya, seperti sebuah berkas log yang besar, atau sekumpulan berkas hasil kompilasi `.a`. Untuk melakukan ini, gunakan opsi `--cached`:

	$ git rm --cached readme.txt

Anda dapat menambahkan nama berkas, direktori, dan pola glob ke perintah `git rm`. Ini berarti Anda dapat melakukan hal seperti

	$ git rm log/\*.log

Perhatikan karakter backslash (`\`) di depan tanda `*`. Ini dibutuhkan agar Git juga meng-ekspansi nama berkas sebagai tambahan dari ekspansi nama berkas oleh shell Anda. Perintah ini mengapus semua berkas yang memiliki ekstensi `.log` di dalam direktori `log/`. Atau, Anda dapat melakukannya seperti ini:

	$ git rm \*~

Perintah ini akan membuang semua berkas yang berakhiran dengan `~`.

### Memindahkan Berkas ###

Tidak seperti kebanyakan sistem VCS lainnya, Git tidak secara eksplisit memantau perpindahan berkas. Jika Anda mengubag nama berkas di Git, tidak ada metada yang tersimpan di Git yang menyatakan bahwa Anda mengubah nama berkas tersebut. Namun demikian, Git cukup cerdas untuk menemukannya berdasarkan fakta yang ada - kita akan membicarakan tentang mendeteksi perpindahan berkas sebentar lagi.

Untuk itu agak membingungkan bahwa Git memiliki perintah `mv`. Jika Anda hendak mengubah nama berkas di Git, Anda dapat menjalankan seperti berikut

	$ git mv file_from file_to

dan itu berjalan baik. Bahkan, jika Anda menjalankannya seperti ini kemudian melihat ke status, Anda akan melihat bahwa Git menganggapnya sebagai perintah pengubahan nama berkas. 

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

Namun sebetulnya hal ini serupa dengan menjalankan perintah-perintah berikut:

	$ mv README.txt README
	$ git rm README.txt
	$ git add README

Git mengetahui secara implisit bahwa perubahan yang terjadi merupakan proses pengubahan nama, sehingga sebetulnya tidaklah terlalu bermasalah jika Anda mengubah nama sebuah berkas dengan cara ini atau dengan menggunakan perintah `mv`. Satu-satunya perbedaan utama adalah `mv` berjumlah satu perintah dan bukannya tiga - yang membuat fungsi ini lebih nyaman digunakan. Lebih penting lagi, Anda sebetulnya dapat menggunakan alat apapun yang Anda suka untuk mengubah nama berkas, tinggal tambahkan perintah add/rm di bagian akhir, sesaat sebelum Anda melakukan commit.

## Melihat Sejarah Commit ##

Setelah Anda membuat beberapa commit, atau jika Anda sudah menduplikasi sebuah repositori dengan sejumlah sejarah commit yang telah terjadi, Anda mungkin akan mau untuk melihat ke belakang untuk mengetahui apa yang sudah pernah terjadi. Alat paling dasar dan tepat untuk melakukan ini adalah perintah `git log`.

Contoh berikut menggunakan sebuah proyek sangat sederhana yang disebut simplegit yang sering saya gunakan untuk keperluan demonstrasi. Untuk mengambil proyek ini, lakukan

	git clone git://github.com/schacon/simplegit-progit.git

Ketika Anda jalankan `git log` dalam proyek ini, Anda akan mendapat keluaran yang mirip seperti berikut:

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

Secara standar, dengan tanpa argumen, `git log` menampilkan daftar commit yang pernah dibuat di dalam repositori ini terurut secara kronologis terbalik. Yaitu, commit terbaru muncul paling atas. Seperti yang dapat Anda lihat, perintah ini menampilkan setiap commit dengan nlai checksum SHA-1, nama dan email dari pengubah, tanggal perubahan dilakukan, dan pesan commitnya.

Sebagian besar variasi opsi dari perintah `git log` tersedia untuk menunjukkan kepada Anda secara tepat apa yang Anda cari. Di sini, kami akan menunjukkan kepada Anda beberapa dari opsi yang paling sering digunakan.

Salah satu dari opsi yang paling berguna adalah `-p`, karena menampilkan diff dari setiap commit. Anda juga dapat menggunakan `-2`, yang membantu membatasi keluarannya hingga 2 entri terakhir:

	$ git log –p -2
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

Opsi ini menampilkan informasi log yang sama, namun ditambah informasi diff dari setiap entri. Ini sangat membantu untuk proses tilik-ulang kode atau untuk secara cepat menelusuri apa yang telah terjadi dalam serangkaian commit yang telah ditambahkan oleh rekan kolaborasi.
Anda juga dapat menggunakan serangkaian opsi simpulan menggunakan `git log`. Misalnya, jika Anda ingin melihat statistik dari setiap commit, Anda dapat menggunakan osi `--stat`: 

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

Seperti Anda dapat lihat, opsi `--stat` menampilkan di bawah setiap entri commit sebuah daftar dari berkasi terubah, jumlah berkas yang diubah dan jumlah baris dalam berkas tersebut yang ditambah atau dihapus. Opsi ini juga menambahkan sebuah simpulan dari informasi tadi di bagian akhir.
Opsi lain yang juga berguna adalah `--pretty`. Opsi ini mengubah keluaran log ke dalam bentuk selain dari bentuk standar. Beberapa pilihan bentuk yang telah dibuat sebelumnya dapat Anda gunakan. Pilihan bentuk `oneline` akan mencetak setiap commit dalam satu baris, yang berguna jika Anda melihat banyak sekali commit. Selain itu, ada pilihan bentuk `short`, `full`, dan `fuller` yang menampilkan keluaran dalam format yang kurang lebih sama tetapi dengan lebih sedikit atau lebih banyak informasi, seperti:

	$ git log --pretty=oneline
	ca82a6dff817ec66f44342007202690a93763949 changed the version number
	085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 removed unnecessary test code
	a11bef06a3f659402fe7563abf99ad00de2209e6 first commit

Yang lebih mearik adalah pilihan bentuk `format`, yang memungkinkan kita untuk menentukan format keluaran log yang kita inginkan. Ini secara khusus berguna jika Anda membuat keluaran untuk diolah oleh mesin - karena Anda menentukan format secara eksplisit, Anda tahu keluaran tidak akan berubah jika Git dimutakhirkan.

	$ git log --pretty=format:"%h - %an, %ar : %s"
	ca82a6d - Scott Chacon, 11 months ago : changed the version number
	085bb3b - Scott Chacon, 11 months ago : removed unnecessary test code
	a11bef0 - Scott Chacon, 11 months ago : first commit

Tabel 2-1 memperlihatkan beberapa opsi berguna yang dapat digunakan oleh format.

	Opsi	Penjabaran dari keluaran
	%H	Hash dari commit
	%h	Hash dari commit dalam versi pendek
	%T	Hash dari pohon
	%t	Hash dari pohon dalam versi pendek
	%P	Hash dari parent
	%p	Hash dari parent dalam versi pendek
	%an	Nama pembuat
	%ae	Email pembuat
	%ad	Tanggal pembuat (format juga memperhitungkan opsi -date=)
	%ar	Tanggal pembuat, relatif
	%cn	Name pelaku commit
	%ce	Email pelaku commit
	%cd	Tanggal pelaku commit
	%cr	Tanggal pelaku commit, relatif
	%s	Judul

Anda mungkin bertanya-tanya apa perbedaan dari _pembuat_ dan _pelaku_commit_. Pembuat adalah orang yang sebetulnya menulis perubahan, sedangkan pelaku commit adalah orang yang terakhir mengaplikasikan perubahan tersebut. Jadi, jika Anda mengirimkan sebuah patch ke sebuah proyek dan salah satu dari anggota inti mengaplikasikan patch tersebut, Anda berdua akan dihitung - Anda sebagai pembuat dan anggota inti sebagai pelaku commit. Perbedaan ini ini akan kita bahas lebih lanjut di Bab 5.

Opsi `oneline` dan `format` secara khusus berguna dengan opsi `log` lainnya yang disebut `--graph`. Opsi ini menambah informasi gambar ASCII yang menunjukkan sejarah pencabangan dan penggabungan, yang kita dapat lihat dari salinan repositori proyek Grit:

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

Itulah beberapa opsi dalam memformat keluaran dari `git log` secara sederhana - masih ada banyak lagi. Tabel 2-2 menjabarkan opsi-opsi yang sejauh ini telah kita bahas dan beberapa opsi format umum lainnya yang mungkin berguna, sejalan dengan bagaimana opsi tersebut mengubah keluaran dari perintah `log`.

	Opsi	Penjabaran
	-p	Tampilkan patch yang digunakan di setiap commit
	--stat	Tampilkan statistik dari berkas terubah di setiap commit
	--shortstat	Tampilkan opsi `--stat` dalam satu baris perubahan/penambahan/penghapusan 
	--name-only	Tampilkan daftar berkas yang terubah setelah setiap informasi commit
	--name-status	Tampilkan daftar berkas yang terubah dan informasi status tertambah/terubah/terhapus
	--abbrev-commit	Tampilkan beberapa karakter awal dari ceksum SHA-1
	--relative-date	Tampilkan tanggal dalam bentuk relatif (misalnya, "2 weeks ago")
	--graph	Tampilkan gambar ASCII dari sejarah pencabangan dan penggabungan di samping keluaran log
	--pretty	Tampilkan commit dalam format alternatif. Opsi antara lain oneline, short, full, fuller dan format (dimana kita dapat merumuskan format yang kita inginkan).

### Membatasi Keluaran Log ###

Sebagai tambahan dari opsi format-keluaran, `git log` juga memiliki opsi pembatasan yang berguna - yaitu opsi yang membuat kita dapat menampilkan sebagian dari commit. Anda telah melihat salah satu opsi pembatasan ini sebelumnya - opsi `-2` yang menampilkan 2 commit terakhir. Bahkan jika Anda melakukan `-<n>`, dengan `n` adalah integer apapun untuk menampilkan sejumlah `n` commit terakhir. Dalam kenyataannya, Anda mungkin tidak akan menggunakan opsi ini terlalu sering, karena Git secara standar melakukan pipe dari semua output lewat sebuah pager sehingga Anda melihat hanya sebuah halaman dari keluaran log setiap saat.

Namun demikian, opsi pembatasan waktu seperti `--since` dan `--until` akan lebih berguna. Sebagai contoh, perintah berikut akan menampilkan sejumlah commit yang dilakukan dalam 2 minggu terakhir:

	$ git log --since=2.weeks

Perintah ini bekerja dengan format lainnya - Anda dapat mencantumkan tanggal tertentu ("2008-01-15") atau tanggal relatif seperti "2 years 1 day 3 minutes ago".

Anda juga dapat menyaring daftar untuk commit yang cocok dengan beberapa kriteria pencarian. Opsi `--author` membuat Anda dapat menyaring pembuat tertentu, dan opsi `--grep` membuat Anda dapat mencari keyword di dalam pesan commit. (Mohon diingat bahwa jika Anda ingin mencantumkan kedua opsi author dan grep, Anda harus menambahkan `--all-match` atau perintah akan mencocokkan yang berisi keduanya saja).

Opsi terakhir yang sangat berguna untuk menyaring `git log` adalah path. Jika anda mencantumkan direktori atau nama berkas, Anda dapat membatasi keluaran log ke commit yang merubah berkas-berkas tersebut. Ini selalu menjadi opsi terakhir dan biasanya didahului dengan dua tanda hubung (`--`) untuk memisahkan path dari opsi lainnya.

Dalam tabel 2-3 kita daftarkan opsi pembatasan ini dan opsi umum lainnya untuk acuan Anda.

	Opsi	Penjabaran
	-(n)	Tampilkan hanya sejumlah n commit terakhir
	--since, --after	Batasi commit hanya yang dibuat setelah tanggal yang dicantumkan
	--until, --before	Batasi commit hanya yang dibuat sebelum tanggal yang dicantumkan
	--author	Hanya tampilkan commit yang entri pembuatnya cocok dengan string yang dicantumkan
	--committer	Hanya tampilkan commit yang entri pelaku commitnya cocok dengan string yang dicantumkan

Sebagai contoh, jika Anda ingin melihat commit mana saja yang mengubah berkas test di sejarah kode sumber yang di-commit oleh Junio Hamano dan bukan merupakan penggabungan selama bulan October 2008, Anda dapat menjalankan seperti berikut:

	$ git log --pretty="%h - %s" --author=gitster --since="2008-10-01" \
	   --before="2008-11-01" --no-merges -- t/
	5610e3b - Fix testcase failure when extended attribute
	acd3b9e - Enhance hold_lock_file_for_{update,append}()
	f563754 - demonstrate breakage of detached checkout wi
	d1a43f2 - reset --hard/read-tree --reset -u: remove un
	51a94af - Fix "checkout --track -b newbranch" on detac
	b0ad11e - pull: allow "git pull origin $something:$cur

Dari sekitar 20,000 commit dalam sejarah kode sumber Git, perintah ini menampilkan hanya 6 yang cocok dengan kriteria di atas.

### Menggunakan GUI untuk Menggambarkan Sejarah ###

Jika Anda ingin menggunakan alat yang lebih grafis untuk menggambarkan sejarah commit Anda, Anda dapat melihat program Tcl/Tk yang disebut gitk yang didistribusikan bersama dengan Git. Gitk sebelunya hanyalah alat visual dari `git log`, dan dia menerima hampir semua opsi pembatasan yang dapat dilakukan oleh `git log`. Jika Anda mengetikkan gitk di baris perintah dalam direktori proyek Anda, Anda akan melihat seperti Gambar 2-2.

Insert 18333fig0202.png 
Gambar 2-2. Penggambaran sejarah oleh Gitk.

Anda dapat melihat sejarah commit di setengah bagian atas jendela dengan gambar pohon yang menarik. Tampilan diff di bagian bawah jendela memperlihatkan kepada Anda perubahan yang dilakukan di commit manapun yang Anda klik.

## Membatalkan Apapun ##

Pada setiap tahapan, Anda mungkin ingin membatalkan sesuatu. Di sini, kita akan membahas beberapa alat dasar untuk membatalkan perubahan yang baru saja Anda lakukan. Harus tetap diingat bahwa kita tidak selalu dapat membatalkan apa yang telah kita batalkan. Ini adalah salah satu area dalam Git yang dapat membuat Anda kehilangan apa yang telah Anda kerjakan jika Anda melakukannya dengan tidak tepat.

### Merubah Commit Terakhir Anda ###

Salah satu pembatalan yang biasa dilakukan adalah ketika kita melakukan commit terlalu cepat dan mungkin terjadi lupa untuk menambah beberapa berkas, atau Anda salah memberikan pesan commit Anda. Jika Anda ingin untuk mengulang commit tersebut, Anda dapat menjalankan commit dengan opsi `--ammend`:

	$ git commit --amend

Perintah ini mangambil area stage Anda dan menggunakannya untuk commit. Jika Anda tidak melakukan perubahan apapun sejak commit terakhir Anda (seumpama, Anda menjalankan perintah ini langsung setelah commit Anda sebelumnya), maka snapshot Anda akan sama persis dengan sebelumnya dan yang Anda dapat ubah hanyalah pesan commit Anda.

Pengolah kata akan dijalankan untuk mengedit pesan commit yang telah Anda buat pada commit sebelumnya. Anda dapat ubah pesan commit ini seperti biasa, tetapi pesan commit sebelumnya akan tertimpa.

Sebagai contoh, jika Anda melakukan commit dan menyadari bahwa Anda lupa untuk memasukkan beberapa perubahan dalam sebuah berkas ke area stage dan Anda ingin untuk menambahkan perubahan ini ke dalam commit terakhir, Anda dapat melakukannya sebagai berikut:

	$ git commit -m 'initial commit'
	$ git add forgotten_file
	$ git commit --amend 

Ketiga perintah ini tetap akan bekerja di satu commit - commit kedua akan menggantikan hasil dari commit pertama.

### Mengeluarkan Berkas dari Area Stage ###

Dua seksi berikutnya akan menunjukkan bagaimana menangani area stage Anda dan perubahan terhadap direktori kerja Anda. Sisi baiknya adalah perintah yang Anda gunakan untuk menentukan keadaan dari kedua area tersebut juga mengingatkan Anda bagaimana membatalkan perubahannya. Sebagai contoh, mari kita anggap Anda telah merubah dua berkas dan ingin melakukan commit kepada keduanya sebagai dua perubahan terpisah, tetapi Anda secara tidak sengaja mengetikkan `git add *` dan memasukkan keduanya ke dalam area stage. Bagaimana Anda dapat mengeluarkan salah satu dari keduanya? Perintah `git status` mengingatkan Anda:

	$ git add .
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#       modified:   benchmarks.rb
	#

Tepat di bawah tulisan "Changes to be committed", tercantum anjuran untuk menggunakan `git reset HEAD <file>` untuk mengeluarkan dari area stage. Mari kita gunakan anjuran tersebut untuk mengeluarkan berkas benchmarks.rb dari area stage:

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

Perintahnya terlihat agak aneh, tetapi menyelesaikan masalah. Berkas benchmarks.rb sekarang menjadi  terubah dan sudah berada di luar area stage.

### Mengembalikan Berkas Terubah ###

Apa yang terjadi jika Anda menyadari bahwa Anda tidak ingin menyimpan perubahan terhadap berkas benchmarks.rb? Bgaimana kita dapat dengan mudah mengembalikan berkas tersebut ke keadaan yang sama dengan saat Anda melakukan commit terakhir (atau saat awal menduplikasi, atau bagaimanapun Anda mendapatkannya ketika masuk ke direktori kerja Anda)? Untungnya, `git status` memberitahu Anda lagi bagaimana untuk melakukan hal itu. Pada contoh keluaran sebelumnya, area direktori kerja terlihat seperti berikut:

	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   benchmarks.rb
	#

Terlihat secara eksplisit cara Anda dapat membuang perubahan yang telah Anda lakukan (paling tidak, hanya versi Git 1.6.1 atau yang lebih baru yang memperlihatkan cara ini - jika Anda memiliki versi yang lebih tua, kami sangat merekomendasikan untuk memperbaharui Git untuk mendapatkan fitur yang lebih nyaman digunakan). Mari kita lakukan apa yang tertulis di atas:

	$ git checkout -- benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#

Anda dapat lihat bahwa perubahan telah dikembalikan. Anda juga seharusnya menyadari bahwa perintah ini juga berbahaya: perubahan apapun yang Anda buat di berkas tersebut akan hilang - Anda baru saja menyalin berkas lain ke perubahan Anda. Jangan pernah gunakan perintah ini kecuali Anda sangat yakin bahwa Anda tidak menginginkan berkas tersebut. Jika Anda hanya butuh untuk menyingkirkan perubahan untuk sementara, kita dapat bahas tentang penyimpanan (_to stash_) dan pencabangan (_to branch_) di bab berikutnya; kedua cara tersebut secara umum adalah cara yang lebih baik untuk dilakukan.

Ingat bahwa apapun yang dicommit di dalam Git dapat hampir selalu dikembalikan. Bahkan commit yang berada di cabang yang sudah terhapus ataupun commit yang sudah ditimpa dengan `commit --amend` masih dapat dikembalikan (lihat Bab 9 untuk penyelamatan data). Namun, apapun hilang yang belum pernah dicommit besar kumngkinannya tidak dapat dilihat kembali.

## Bekerja Berjarak ##

Untuk dapat berkolaborasi untuk proyek Git apapun, Anda perlu mengetahui bagaimana Anda dapat mengatur repositori berjarak dari jarak jauh. Repositori berjarak adalah sekumpulan versi dari proyek Anda yang disiarkan di Internet atau di jaringan. Anda dapat memiliki beberapa repositori berjarak, masing-masing bisanya dengan akses terbatas untuk membaca saja ataupun baca/tulis. Berkolaborasi dengan pihak lain menuntut kemampuan untuk mengatur repositori berjarak ini dan menarik dan mendorong data ke dan dari repositori berjarak tersebut ketika Anda butuh untuk membagi hasil kerja Anda.

Mengatur repositori berjarak mencakup pengetahuan untuk menambah repositori berjarak, menghapus repositori yang sudah tidak berlaku, mengatur cabang-cabang berjarak dan mendefinisikan cabang-cabang tersebut sebagai terpantau atau tidak, dan seterusnya. Dalam bagian ini, kita akan membahas kemampuan manajemen jarak jauh ini.

### Melihat Repositori Berjarak Anda ###

Untuk melihat server berjarak mana yang telah Anda konfigurasikan, Anda dapat menjalankan perintah `git remote`. Perintah tersebut mendaftarkan nama pendek dari masing-masing handle berjarak yang telah Anda buat sebelumnya. Jika Anda menduplikasikan repositori Anda, Anda seharusnya paling tidak dapat melihat `origin` - yaitu nama standar yang diberikan Git untuk menunjuk ke server asal tempat Anda menduplikasi: 

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

Anda juga dapat mencantumkan `-v`, yang akan menampilkan kepada Anda URL yang telah Git simpan sebagai alamat lengkap dari nama pendek tempat server asal.

	$ git remote -v
	origin	git://github.com/schacon/ticgit.git

Jika Anda memiliki lebih dari satu server berjarak, perintah tersebut akan menampilkan semuanya. Sebagai contoh, repositori Grit tampak seperti berikut.

	$ cd grit
	$ git remote -v
	bakkdoor  git://github.com/bakkdoor/grit.git
	cho45     git://github.com/cho45/grit.git
	defunkt   git://github.com/defunkt/grit.git
	koke      git://github.com/koke/grit.git
	origin    git@github.com:mojombo/grit.git

Ini berarti kita bisa menarik kontribusi dari pengguna manapun dengan cukup mudah. Tapi dapat dicatat bahwa hanya server berjarak `origin` yang menggunakan URL SSH, sehingga hanya itulah satu-satunya server yang dapat saya arahkan pendorongan (kita akan bahas kenapa hal ini terjadi di Bab 4).

### Menambah Repositori Berjarak ###

Saya telah menyinggung dan memberikan beberapa peragaan bagaimana menambah repositori berjarak di bagian sebelumnya, namun berikut adalah bagaimana untuk melakukannya secara eksplisit. Untuk menambah sebuah repositori berjarak Git yang baru sebagai sebuah nama pendek yang Anda dapat referensikan secara mudah, jalankan `git remote add [nama pendek] [url]`:

	$ git remote
	origin
	$ git remote add pb git://github.com/paulboone/ticgit.git
	$ git remote -v
	origin	git://github.com/schacon/ticgit.git
	pb	git://github.com/paulboone/ticgit.git

Sekarang Anda apat menggunakan `pb` dalam baris perintah daripada menggunakan URL lengkapnya. Sebagai contoh, jika Anda ingin mengambil semua informasi yang dimiliki oleh Paul, tapi belum Anda miliki di repositori Anda, Anda dapat menjalankan `git fetch pb`:

	$ git fetch pb
	remote: Counting objects: 58, done.
	remote: Compressing objects: 100% (41/41), done.
	remote: Total 44 (delta 24), reused 1 (delta 0)
	Unpacking objects: 100% (44/44), done.
	From git://github.com/paulboone/ticgit
	 * [new branch]      master     -> pb/master
	 * [new branch]      ticgit     -> pb/ticgit

Cabang master milik Paul sekarang dapat diakses di komputer Anda sebagai `pb/master` - Anda dapat menggabungkan cabang Paul ke dalam salah satu cabang Anda, atau Anda dapat melakukan `checkout` untuk mengaksesnya langsung sebagai cabang lokal jika Anda ingin menelitinya.

### Mengambil dan Menarik dari Repositori Berjarak ###

Sebagaimana yang telah Anda ketahui, untuk mengambil data dari proyek berjarak Anda, Anda dapat menjalankan:

	$ git fetch [remote-name]

Perintah tersebut akan diteruskan ke repositori berjarak dan menarik semua data yang belum Anda miliki dari sana. Setelah Anda melakukan ini, Anda akan memiliki referensi terhadap semua cabang yang ada di repositori berjarak tadi, yang kemudian dapat Anda gabungkan atau periksa kapanpun. (Kita akan bahas apa itu cabang dan bagaimana menggunakannya dengan lebih detil di Bab 3.)

Jika Anda menduplikasi sebuah repositori, perintah tersebut akan secara otomatis menambahkan repositori berjarak dengan nama `origin`. Jadi, `git fetch origin` akan mengambil semua hasil kerja baru yang sudah didorong ke server sejak Anda melakukan duplikasi (atau terakhir Anda mengambil). Penting untuk dicatat bahwa perintah `fetch` menarik semua data ke repositori lokal - perintah tersebut tidak secara otomatis menggabungkan hasil kerja baru dengan hasil kerja Anda atau mengubah apa yang sekarang sedang Anda kerjakan. Anda harus menggabungkannya secara manual ke dalam kerja Anda ketika Anda sudah siap.

Jika Anda memiliki cabang yang sudah tertata untuk memantau cabang berjarak (lihat bagian berikutnya dan bab3 untuk informasi lebih lanjut), Anda dapat menggunakan perintah `git pull` untuk secara otomatis mengambil dan menggabungkan cabang berjarak ke dalam cabang yang sekarang sedang aktif. Alur kerja ini mungkin lebih mudah atau lebih nyaman bagi Anda; dan secara standar, perintah `git clone` secara otomatis menata cabang master di lokal Anda untuk memantau cabang master di server berjarak tempat asal Anda menduplikasi (diasumsikan bahwa repositori berjarak memiliki cabang master). Menjalankan `git pull` secara umum mengambil data dari server tempat asal kita menduplikasi dan secara otomatis mencoba untuk menggabungkannya dengan kode yang sedang kita kerjakan saat ini.

### Mendorong ke Repositori Berjarak ###

Ketika proyek Anda sampai pada satu titik dimana Anda ingin membaginya, Anda harus mendorongnya ke server. Perintah untuk melakukan ini mudah: `git push [nama-berjarak] [nama-cabang]`. Jika Anda ingin mendorong cabang master ke server `origin` Anda (lagi, duplikasi secara umum menata nama-nama ini secara otomatis), maka Anda dapat menjalankan berikut ini untuk mendorong hasil kerja Anda kembali ke server:

	$ git push origin master

Perintah ini hanya bekerja jika Anda menduplikasi dari server dengan akses tulis terbuka bagi Anda dan jika belum ada orang yang mendorong sebelumnya. Jika Anda dan seorang lainnya menduplikasi secara bersamaan dan mereka mendorong ke server baru kemudian Anda, hasil kerja Anda akan segera ditolak. Anda perlu menarik hasil kerja mereka dahulu dan menggabungkannya dengan hasil kerja Anda sebelum Anda diperbolehkan untuk mendorong. Lihat Bab 3 untuk informasi lebih detil tentang bagaimana untuk mendorong ke server berjarak.

### Memeriksa Repositori Berjarak ###

Jika Anda ingin melihat informasi tertentu lebih lanjut tentang repositori berjarak, Anda dapat menggunakan perintah `git remote show [nama-remote]`. Jika Anda menjalankan perintah ini dengan nama pendek tertentu, sepertin `origin`, Anda akan mendapatkan seperti ini:

	$ git remote show origin
	* remote origin
	  URL: git://github.com/schacon/ticgit.git
	  Remote branch merged with 'git pull' while on branch master
	    master
	  Tracked remote branches
	    master
	    ticgit

Perintah ini akan memperlihatkan daftar URL dari repositori berjarak dan juga informasi cabang berjarak terpantau. Perintah tersebut juga membantu Anda melihat bahwa Anda berada di cabang master dan jika Anda menjalankan `git pull`, perintah tersebut akan secara otomatis menggabungkan dari cabang master berjarak setelah mengambil semua referensi dari sana. Perintah ini juga memperlihatkan daftar semua referensi yang sudah ditarik.

Ini adalah contoh sederhana yang paling mungkin Anda temui. Ketika Anda menggunakan Git lebih sering lagi, Anda makin dapat membaca lebih banyak lagi informasi yang keluar dari `git remote show`:

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

Perintah ini menunjukkan cabang mana yang secara otomatis terdorong ketika Anda menjalankan `git push` di cabang-cabang tertentu. Yang juga ditunjukkan adalah cabang berjarak di server yang belum Anda miliki, cabang berjarak yang Anda miliki namun telah terhapus di server, dan beberapa cabang yang secara otomatis akan digabungkan ketika Anda menjalankan `git pull`.

### Menghapus dan Mengganti Nama Repositori Berjarak ###

Jika Anda ingin mengganti nama sebuah referensi, pada Git versi baru Anda dapat menjalankan `git remote rename` untuk mengganti nama pendek dari repositori berjarak. Sebagai contoh, jika Anda ingin mengganti nama `pb` menjadi `paul`, Anda dapat melakukannya dengan perintah `git remote rename`:

	$ git remote rename pb paul
	$ git remote
	origin
	paul

Patut disinggung juga bahwa hal ini merubah nama cabang berjarak Anda juga. Apa yang biasanya dapat direferensikan sebagai `pb/master` saat ini berada di `paul/master`.

Jika Anda ingin untuk menghapus sebuah referensi untuk alasan tertentu - Anda memindahkan servernya atau tidak lagi menggunakan mirror tertentu, atau mungkin seorang kontributor tidak lagi berkontribusi - Anda dapat menggunakan `git remote rm`:

	$ git remote rm paul
	$ git remote
	origin

## Menandai ##

Seperti kebanyakan VCS, Git memiliki kemampuan untuk menandai titik tertentu dalam sejarah sebagai sesuatu yang penting. Biasanya, orang menggunakan fungsi ini untuk menandai titik-titik pelepasan (v1.0, dan seterusnya). Pada bagian ini, Anda akan belajar untuk melihat tanda-tanda yang telah ada, bagaimana membuat tanda baru, dan perbedaan dari beberapa tipe tanda.

### Melihat Daftar Tanda Anda ###

Melihat daftar tanda yang sudah ada di GIT tidak berbelit-belit. Ketikkan `git tag`:

	$ git tag
	v0.1
	v1.3

Perintah ini memperlihatkan tanda-tanda yang diurutkan secara alfabetis; urutan yang terlihat ini tidak memiliki kepentingan nyata tertentu.

Anda dapat juga mencari tanda dengan pola tertentu. Repositori kode Git, sebagai contoh, mengandung lebih dari 240 tanda. Jika Anda hanya tertarik untuk melihat seri dari 1.4.2, Anda dapat menjalankan:

	$ git tag -l 'v1.4.2.*'
	v1.4.2.1
	v1.4.2.2
	v1.4.2.3
	v1.4.2.4

### Membuat Tetanda ###

Git membagi tetanda dalam 2 tipe utama: ringan dan bercatatan. Tipe tetanda ringan sangat mirip dengan sebuah cabang yang tidak pernah berubah - tetanda hanya sebagai penunjuk ke commit tertentu. Di lain pihak, tipe tetanda bercatatan disimpan sebagai obyek penuh di dalam basis data Git. Tetanda ini di-checksum; mengandung nama penanda, email dan tanggal; memiliki pesan penandaan; dan dapat ditandatangani dan diverifikasi menggunakan GNU Privacy Guard (GPG). Anda pada umumnya direkomendasikan untuk membuat tetanda bercatatan sehingga Anda dapat memiliki semua informasi ini; tetapi jika Anda hanya menginginkan tetanda sementara atau untuk alasan tertentu tidak ingin menyimpan informasi lain yang lebih detil, tetanda ringan juga tersedia.

### Tetanda Bercatatan ###

Membuat sebuah tetanda bercatatan dalam Git adalah mudah. Cara termudah adalah dengan menggunakan parameter `-a` ketika Anda menjalankan perintah `tag`:

	$ git tag -a v1.4 -m 'my version 1.4'
	$ git tag
	v0.1
	v1.3
	v1.4

Parameter `-m` untuk mendefinikasn pesan penandaan, yang disimpan bersamaan dengan tanda. Jika Anda tidak mencantumkan pesan untuk tanda bercatatan, Git akan menjalankan editor Anda sehingga Anda dapat mengetikkannya di sana.

Anda dapat melihat data dari tanda tadi beserta commit yang ditandainya dengan menggunakan perintah `git show`:

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

Terlihat informasi penanda, tanggal dilakukan penandaan terhadap commit, dan catatan sebelum Git menampilkan informasi commitnya.

### Tetanda Tertandatangani ###

Anda dapat juga menandatangani tetanda Anda menggunakan GPG, diasumsikan bahwa Anda telah memiliki kunci pribadi (private key). Yang perlu Anda lakukan adalah mengganti `a` dengan `-s`:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gee-mail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

Jika Anda menjalankan `git show` terhadap tag tadi, Anda akan melihat tanda tangan GPG Anda terlampir di sana:

	$ git show v1.5
	tag v1.5
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 15:22:20 2009 -0800

	my signed 1.5 tag
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

Sebentar lagi, Anda akan belajar untuk memverifikasi tanda tertandatangani.

### Tetanda Ringan ###

Cara lain untuk menandai sebuah commit adalah dengan sebuah tanda ringan. Pada dasarnya tetanda ini adalah checksum dari commit yang disimpan di dalam berkas - tanpa informasi lain. Untuk membuat tetanda ringan ini, jangan cantumkan parameter `-a`, `-s` ataupun `-m`.

	$ git tag v1.4-lw
	$ git tag
	v0.1
	v1.3
	v1.4
	v1.4-lw
	v1.5

Pada saat ini, jika Anda menjalankan `git show` pada tag tersebut, Anda tidak akan melihat informasi lebih. Perinta tersebut hanya akan menampilkan commitnya.

	$ git show v1.4-lw
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

### Memverifikasi Tetanda ###

Untuk memverifikasi sebuah tag bertandatangan, Anda menggunakan `git tag -v [nama-tag]`. Perintah ini akan menggunakan GPG untuk memverifikasi tanda tangannya. Anda membutuhkan kunci umum dari penandatangan di dalam keyring Anda agar dapat bekerja dengan benar:

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

Jika Anda tidak memiliki kunci umum dari penandatangan, Anda akan melihat serupa ini:

	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Can't check signature: public key not found
	error: could not verify the tag 'v1.4.2.1'

### Mengakhirkan Penandaan ###

Anda dapat juga menandai commit walaupun Anda telah pindah melewatinya. Misalnya catatan sejarah commit Anda tampak seperti berikut:

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

Sekarang, misalnya Anda lupa untuk menandai proyek di v1.2, yang sebetulnya terletak di commit "update rakefile". Anda dapat menambahkannya. Untuk menandai commit tersebut, Anda mencantumkan checksum dari commit tersebut (atau bagian darinya) di bagian akhir dari perintah:

	$ git tag -a v1.2 9fceb02

Anda dapat melihat bahwa commit tersebut telah ditandai.

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

### Membagi Tetanda ###

Secara default, perintah `git push` tidak memindahkan tetanda ke server berjarak. Anda harus secara eksplisit mendorong tetanda ke server bersama setelah Anda membuatnya. Proses ini sama seperti membagi cabang berjarak - Anda dapat menjalankan `git push origin [nama-tag]`.

	$ git push origin v1.5
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	* [new tag]         v1.5 -> v1.5

Jika Anda memiliki banyak tanda yang ingin Anda dorong sekaligus, Anda dapat juga menggunakan opsi `--tags` terhadap perintah `git push`. Hal ini akan memindahkan semua tetanda Anda yang belum terpindahkan ke server berjarak.

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

Saat ini, ketika orang lain menduplikasi atau menarik dari repositori Anda, Mereka akan mendapatkan semua tetanda Anda juga.

## Tips dan Tricks ##

Sebelum kita menyelesaikan bab tentang dasar-dasar Git ini, beberapa tips dan triks dapat membuat pengalaman Git Anda lebih sederhana, mudah, atau bahkan akrab. Banyak orang menggunakan Git tanpa menggunakan tip-tip berikut ini, dan kami tidak akan merujuk kepada mereka atau mengasumsikan bahwa Anda telah menggunakannya nanti dalam buku ini; tetapi Anda mungkin sebaiknya mengetahui bagaimana menggunakannya.

### Auto-Completion ###

Jika Anda menggunakan Bash shell, Git tersedia dengan sebuah script auto-completion yang dapat Anda hidupkan. Unduh source-code Git, dan cari direktori `contrib/completion`; di sana Anda akan menemukan berkas bernama `git-completion.bash`. Salin berkas ini ke direktori home Anda, dan tambahakn ini ke dalam berkas `.bashrc`:

	source ~/.git-completion.bash

Jika Anda ingin memasang Git agar secara otomatis menggunakan fitur ini bagi semua pengguna, salin script tadi ke direktori `/opt/local/etc/bash_completion.d` di sistem Mac atau ke direktori `/etc/bash_completion.d/` di sistem Linux. Ini adalah direktori tempat script yang akan secara otomatis dibaca oleh Bash untuk menyediakan fitur auto-complete nya.

Jika Anda menggunakan Windows dengan Git Bash, yang sebetulnya adalah setting default ketika instalasi Git di Windows menggunakan msysGit, fitur ini seharusnya sudah terkonfigurasi.

Pencet huruf Tab ketika Anda menuliskan perintah Git, dan Bash akan menampilkan beberapa kemungkinan yang Anda dapat pilih:

	$ git co<tab><tab>
	commit config

Dalam hal ini, mengetikkan `git co` dan memencet kunci Tab 2x akan menampilkan pilihan commit dan config. Dengan menambahkan `m<tab>` akan melengkapi `git commit` secara otomatis.
	
Hal ini juga bekerja terhadap opsi, yang mungkin lebih berguna. Sebagai contoh, jika Anda menjalankan perintah `git log` dan tidak ingat salah satu dari opsi yang tersedia, Anda dapat mulai mengetikkannya dan memencet Tab untuk melihat apa yang cocok:

	$ git log --s<tab>
	--shortstat  --since=  --src-prefix=  --stat   --summary

Ini adalah trick yang cukup menarik dan dapat menghemat waktu Anda dan waktu membaca dokumentasi.

### Git Alias ###

Git tidak mengasumsikan perintah Anda jika Anda mengetikkannya sebagian. Jika Anda tidak ingin mengetikkan seluruh text dari setiap perintah Git, Anda dapat dengan mudah memasang alias dari setiap perintah menggunakan perintah `git config`. Berikut adalah beberapa contoh yang Anda mungkin ingin tata:

	$ git config --global alias.co checkout
	$ git config --global alias.br branch
	$ git config --global alias.ci commit
	$ git config --global alias.st status

Ini berarti bahwa, sebagai contoh, daripada mengetikkan `git commit`, Anda hanya butuh untuk mengetikkan `git ci`. Sejalan dengan Anda menggunakan Git, Anda akan mungkin menggunakan perintah lain sama seringnya; dalam hal ini, jangan ragu untuk membuat alias-alias baru.

Teknik ini juga akan berguna dalam pembuatan perintah yang Anda pikir harus ada. Sebagai contoh, untuk mengkoreksi masalah kemudahan penggunaan (usability) yang Anda temukan dalam pengeluaran berkas dari area stage, Anda dapat menambahkan alias ini ke dalam Git:

	$ git config --global alias.unstage 'reset HEAD --'

Hal ini akan membuat kedua perintah berikut sama:

	$ git unstage fileA
	$ git reset HEAD fileA

Tampak lebih terbaca. Biasa juga untuk menambahkan perintah `last` sebagai berikut:

	$ git config --global alias.last 'log -1 HEAD'

Dengan demikian, Anda dapat melihat commit terakhir dengan lebih mudah:
	
	$ git last
	commit 66938dae3329c7aebe598c2246a8e6af90d04646
	Author: Josh Goebel <dreamer3@example.com>
	Date:   Tue Aug 26 19:48:51 2008 +0800

	    test for current head

	    Signed-off-by: Scott Chacon <schacon@example.com>

Sebagaimana yang dapat Anda katakan, Git secara sederhana menggantikan perintah-perintah baru dengan apapun yang Anda alias kan. Namun demikian, mungkin Anda ingin menjalankan perintah eksternal, dan bukannya Git subcommand. Dalam kasus ini, Anda dapat mulai perintahnya dengan karakter `!`. Hal ini berguna jika Anda ingin membuat alat Anda sendiri yang bekerja terhadap repositori Git. Kita dapat mendemokannya dengan membuat alias `git visual` untuk menjalankan `gitk`:

	$ git config --global alias.visual '!gitk'

## Simpulan ##

Pada saat ini, Anda dapat melakukan semua hal dasar terhadap Git di lokal - membuat atau menduplikasi sebuah repositori, melakukan perubahan, memasukkan ke area stage dan melakukan commit terhadap perubahan tersebut, dan melihat sejarah dari semua perubahan yang pernah terjadi di sebuah repositori. Selanjutnya, kita akan membahas fitur pembunuh dari Git: cara Git melakukan percabangan.
