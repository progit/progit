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
	nothing to commit (working directory clean)

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
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#	modified:   benchmarks.rb
	#

Berkas benchmarks.rb terlihat di bawah bagian yang bernama "Changed but not updated" - yang berarti bahwa sebuah berkas terpantau telah berubah di dalam direktori kerja namun belum masuk ke area stage. Untuk memasukkannya ke area stage, Anda menjalankan perintah `git add` (perintah ini adalah perintah multiguna - Anda menggunakannya untuk mulai memantau berkas baru, untuk memasukkannya ke area stage, dan untuk melakukan hal lain seperti menandai berkas terkonflik menjadi terpecahkan). Mari kita sekarang jalankan `git add` untuk memasukkan berkas benchmarks.rb ke dalam area stage, dan jalankan `git status` lagi:

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
	# Changed but not updated:
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
	*.a       # abaikan berkas .a
	!lib.a    # tapi pantau lib.a, walaupun Anda abaikan berkas .a di atas
	/TODO     # hanya abaikan berkas TODO yang berada di rooto, bukan di subdir/TODO
	build/    # abaikan semua berkas di dalam direktori build/
	doc/*.txt # abaikan doc/notes.txt, tapi bukan doc/server/arch.txt

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
	# Changed but not updated:
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
	# Changed but not updated:
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
	# Changed but not updated:
	#
	#	modified:   benchmarks.rb
	#
	$ git commit -a -m 'added new benchmarks'
	[master 83e38c7] added new benchmarks
	 1 files changed, 5 insertions(+), 0 deletions(-)

Perhatikan bagaimana Anda tidak perlu menjalankan `git add` terhadap berkas benchmarks.rb dalam hal ini sebelum Anda commit.

### Menghapus Berkas ###

Untuk menghapus sebuah berkas dari Git, Anda harus menghapusnya dari berkas terpantau (lebih tepatnya, mengpus dari area stage) dan kemudian commit. Perintah `git rm` melakukan hal tadi dan juga menghapus berkas tersebut dari direktori kerja Anda sehingga Anda tidak melihatnya sebagai berkas yang tak terpantau nantinya.

Jika Anda hanya menghapus berkas dari direktori kerja Anda, berkas tersebut akan muncul di bagian "Changed but not updated" (yaitu, di luar area stage) dari keluaran `git status` Anda:

	$ rm grit.gemspec
	$ git status
	# On branch master
	#
	# Changed but not updated:
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

At any stage, you may want to undo something. Here, we’ll review a few basic tools for undoing changes that you’ve made. Be careful, because you can’t always undo some of these undos. This is one of the few areas in Git where you may lose some work if you do it wrong.

### Changing Your Last Commit ###

One of the common undos takes place when you commit too early and possibly forget to add some files, or you mess up your commit message. If you want to try that commit again, you can run commit with the `--amend` option:

	$ git commit --amend

This command takes your staging area and uses it for the commit. If you’ve have made no changes since your last commit (for instance, you run this command immediately after your previous commit), then your snapshot will look exactly the same and all you’ll change is your commit message.

The same commit-message editor fires up, but it already contains the message of your previous commit. You can edit the message the same as always, but it overwrites your previous commit.

As an example, if you commit and then realize you forgot to stage the changes in a file you wanted to add to this commit, you can do something like this:

	$ git commit -m 'initial commit'
	$ git add forgotten_file
	$ git commit --amend 

All three of these commands end up with a single commit — the second commit replaces the results of the first.

### Unstaging a Staged File ###

The next two sections demonstrate how to wrangle your staging area and working directory changes. The nice part is that the command you use to determine the state of those two areas also reminds you how to undo changes to them. For example, let’s say you’ve changed two files and want to commit them as two separate changes, but you accidentally type `git add *` and stage them both. How can you unstage one of the two? The `git status` command reminds you:

	$ git add .
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#       modified:   benchmarks.rb
	#

Right below the “Changes to be committed” text, it says use `git reset HEAD <file>...` to unstage. So, let’s use that advice to unstage the benchmarks.rb file:

	$ git reset HEAD benchmarks.rb 
	benchmarks.rb: locally modified
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   benchmarks.rb
	#

The command is a bit strange, but it works. The benchmarks.rb file is modified but once again unstaged.

### Unmodifying a Modified File ###

What if you realize that you don’t want to keep your changes to the benchmarks.rb file? How can you easily unmodify it — revert it back to what it looked like when you last committed (or initially cloned, or however you got it into your working directory)? Luckily, `git status` tells you how to do that, too. In the last example output, the unstaged area looks like this:

	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   benchmarks.rb
	#

It tells you pretty explicitly how to discard the changes you’ve made (at least, the newer versions of Git, 1.6.1 and later, do this — if you have an older version, we highly recommend upgrading it to get some of these nicer usability features). Let’s do what it says:

	$ git checkout -- benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#

You can see that the changes have been reverted. You should also realize that this is a dangerous command: any changes you made to that file are gone — you just copied another file over it. Don’t ever use this command unless you absolutely know that you don’t want the file. If you just need to get it out of the way, we’ll go over stashing and branching in the next chapter; these are generally better ways to go. 

Remember, anything that is committed in Git can almost always be recovered. Even commits that were on branches that were deleted or commits that were overwritten with an `--amend` commit can be recovered (see Chapter 9 for data recovery). However, anything you lose that was never committed is likely never to be seen again.

## Working with Remotes ##

To be able to collaborate on any Git project, you need to know how to manage your remote repositories. Remote repositories are versions of your project that are hosted on the Internet or network somewhere. You can have several of them, each of which generally is either read-only or read/write for you. Collaborating with others involves managing these remote repositories and pushing and pulling data to and from them when you need to share work.
Managing remote repositories includes knowing how to add remote repositories, remove remotes that are no longer valid, manage various remote branches and define them as being tracked or not, and more. In this section, we’ll cover these remote-management skills.

### Showing Your Remotes ###

To see which remote servers you have configured, you can run the git remote command. It lists the shortnames of each remote handle you’ve specified. If you’ve cloned your repository, you should at least see origin — that is the default name Git gives to the server you cloned from:

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

You can also specify `-v`, which shows you the URL that Git has stored for the shortname to be expanded to:

	$ git remote -v
	origin	git://github.com/schacon/ticgit.git

If you have more than one remote, the command lists them all. For example, my Grit repository looks something like this.

	$ cd grit
	$ git remote -v
	bakkdoor  git://github.com/bakkdoor/grit.git
	cho45     git://github.com/cho45/grit.git
	defunkt   git://github.com/defunkt/grit.git
	koke      git://github.com/koke/grit.git
	origin    git@github.com:mojombo/grit.git

This means we can pull contributions from any of these users pretty easily. But notice that only the origin remote is an SSH URL, so it’s the only one I can push to (we’ll cover why this is in Chapter 4).

### Adding Remote Repositories ###

I’ve mentioned and given some demonstrations of adding remote repositories in previous sections, but here is how to do it explicitly. To add a new remote Git repository as a shortname you can reference easily, run `git remote add [shortname] [url]`:

	$ git remote
	origin
	$ git remote add pb git://github.com/paulboone/ticgit.git
	$ git remote -v
	origin	git://github.com/schacon/ticgit.git
	pb	git://github.com/paulboone/ticgit.git

Now you can use the string pb on the command line in lieu of the whole URL. For example, if you want to fetch all the information that Paul has but that you don’t yet have in your repository, you can run git fetch pb:

	$ git fetch pb
	remote: Counting objects: 58, done.
	remote: Compressing objects: 100% (41/41), done.
	remote: Total 44 (delta 24), reused 1 (delta 0)
	Unpacking objects: 100% (44/44), done.
	From git://github.com/paulboone/ticgit
	 * [new branch]      master     -> pb/master
	 * [new branch]      ticgit     -> pb/ticgit

Paul’s master branch is accessible locally as `pb/master` — you can merge it into one of your branches, or you can check out a local branch at that point if you want to inspect it.

### Fetching and Pulling from Your Remotes ###

As you just saw, to get data from your remote projects, you can run:

	$ git fetch [remote-name]

The command goes out to that remote project and pulls down all the data from that remote project that you don’t have yet. After you do this, you should have references to all the branches from that remote, which you can merge in or inspect at any time. (We’ll go over what branches are and how to use them in much more detail in Chapter 3.)

If you clone a repository, the command automatically adds that remote repository under the name origin. So, `git fetch origin` fetches any new work that has been pushed to that server since you cloned (or last fetched from) it. It’s important to note that the fetch command pulls the data to your local repository — it doesn’t automatically merge it with any of your work or modify what you’re currently working on. You have to merge it manually into your work when you’re ready.

If you have a branch set up to track a remote branch (see the next section and Chapter 3 for more information), you can use the `git pull` command to automatically fetch and then merge a remote branch into your current branch. This may be an easier or more comfortable workflow for you; and by default, the `git clone` command automatically sets up your local master branch to track the remote master branch on the server you cloned from (assuming the remote has a master branch). Running `git pull` generally fetches data from the server you originally cloned from and automatically tries to merge it into the code you’re currently working on.

### Pushing to Your Remotes ###

When you have your project at a point that you want to share, you have to push it upstream. The command for this is simple: `git push [remote-name] [branch-name]`. If you want to push your master branch to your `origin` server (again, cloning generally sets up both of those names for you automatically), then you can run this to push your work back up to the server:

	$ git push origin master

This command works only if you cloned from a server to which you have write access and if nobody has pushed in the meantime. If you and someone else clone at the same time and they push upstream and then you push upstream, your push will rightly be rejected. You’ll have to pull down their work first and incorporate it into yours before you’ll be allowed to push. See Chapter 3 for more detailed information on how to push to remote servers.

### Inspecting a Remote ###

If you want to see more information about a particular remote, you can use the `git remote show [remote-name]` command. If you run this command with a particular shortname, such as `origin`, you get something like this:

	$ git remote show origin
	* remote origin
	  URL: git://github.com/schacon/ticgit.git
	  Remote branch merged with 'git pull' while on branch master
	    master
	  Tracked remote branches
	    master
	    ticgit

It lists the URL for the remote repository as well as the tracking branch information. The command helpfully tells you that if you’re on the master branch and you run `git pull`, it will automatically merge in the master branch on the remote after it fetches all the remote references. It also lists all the remote references it has pulled down.

That is a simple example you’re likely to encounter. When you’re using Git more heavily, however, you may see much more information from `git remote show`:

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

This command shows which branch is automatically pushed when you run `git push` on certain branches. It also shows you which remote branches on the server you don’t yet have, which remote branches you have that have been removed from the server, and multiple branches that are automatically merged when you run `git pull`.

### Removing and Renaming Remotes ###

If you want to rename a reference, in newer versions of Git you can run `git remote rename` to change a remote’s shortname. For instance, if you want to rename `pb` to `paul`, you can do so with `git remote rename`:

	$ git remote rename pb paul
	$ git remote
	origin
	paul

It’s worth mentioning that this changes your remote branch names, too. What used to be referenced at `pb/master` is now at `paul/master`.

If you want to remove a reference for some reason — you’ve moved the server or are no longer using a particular mirror, or perhaps a contributor isn’t contributing anymore — you can use `git remote rm`:

	$ git remote rm paul
	$ git remote
	origin

## Tagging ##

Like most VCSs, Git has the ability to tag specific points in history as being important. Generally, people use this functionality to mark release points (v1.0, and so on). In this section, you’ll learn how to list the available tags, how to create new tags, and what the different types of tags are.

### Listing Your Tags ###

Listing the available tags in Git is straightforward. Just type `git tag`:

	$ git tag
	v0.1
	v1.3

This command lists the tags in alphabetical order; the order in which they appear has no real importance.

You can also search for tags with a particular pattern. The Git source repo, for instance, contains more than 240 tags. If you’re only interested in looking at the 1.4.2 series, you can run this:

	$ git tag -l 'v1.4.2.*'
	v1.4.2.1
	v1.4.2.2
	v1.4.2.3
	v1.4.2.4

### Creating Tags ###

Git uses two main types of tags: lightweight and annotated. A lightweight tag is very much like a branch that doesn’t change — it’s just a pointer to a specific commit. Annotated tags, however, are stored as full objects in the Git database. They’re checksummed; contain the tagger name, e-mail, and date; have a tagging message; and can be signed and verified with GNU Privacy Guard (GPG). It’s generally recommended that you create annotated tags so you can have all this information; but if you want a temporary tag or for some reason don’t want to keep the other information, lightweight tags are available too.

### Annotated Tags ###

Creating an annotated tag in Git is simple. The easiest way is to specify `-a` when you run the `tag` command:

	$ git tag -a v1.4 -m 'my version 1.4'
	$ git tag
	v0.1
	v1.3
	v1.4

The `-m` specifies a tagging message, which is stored with the tag. If you don’t specify a message for an annotated tag, Git launches your editor so you can type it in.

You can see the tag data along with the commit that was tagged by using the `git show` command:

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

That shows the tagger information, the date the commit was tagged, and the annotation message before showing the commit information.

### Signed Tags ###

You can also sign your tags with GPG, assuming you have a private key. All you have to do is use `-s` instead of `-a`:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gee-mail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

If you run `git show` on that tag, you can see your GPG signature attached to it:

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

A bit later, you’ll learn how to verify signed tags.

### Lightweight Tags ###

Another way to tag commits is with a lightweight tag. This is basically the commit checksum stored in a file — no other information is kept. To create a lightweight tag, don’t supply the `-a`, `-s`, or `-m` option:

	$ git tag v1.4-lw
	$ git tag
	v0.1
	v1.3
	v1.4
	v1.4-lw
	v1.5

This time, if you run `git show` on the tag, you don’t see the extra tag information. The command just shows the commit:

	$ git show v1.4-lw
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

### Verifying Tags ###

To verify a signed tag, you use `git tag -v [tag-name]`. This command uses GPG to verify the signature. You need the signer’s public key in your keyring for this to work properly:

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

If you don’t have the signer’s public key, you get something like this instead:

	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Can't check signature: public key not found
	error: could not verify the tag 'v1.4.2.1'

### Tagging Later ###

You can also tag commits after you’ve moved past them. Suppose your commit history looks like this:

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

Now, suppose you forgot to tag the project at v1.2, which was at the "updated rakefile" commit. You can add it after the fact. To tag that commit, you specify the commit checksum (or part of it) at the end of the command:

	$ git tag -a v1.2 9fceb02

You can see that you’ve tagged the commit:

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

### Sharing Tags ###

By default, the `git push` command doesn’t transfer tags to remote servers. You will have to explicitly push tags to a shared server after you have created them.  This process is just like sharing remote branches – you can run `git push origin [tagname]`.

	$ git push origin v1.5
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	* [new tag]         v1.5 -> v1.5

If you have a lot of tags that you want to push up at once, you can also use the `--tags` option to the `git push` command.  This will transfer all of your tags to the remote server that are not already there.

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

Now, when someone else clones or pulls from your repository, they will get all your tags as well.

## Tips and Tricks ##

Before we finish this chapter on basic Git, a few little tips and tricks may make your Git experience a bit simpler, easier, or more familiar. Many people use Git without using any of these tips, and we won’t refer to them or assume you’ve used them later in the book; but you should probably know how to do them.

### Auto-Completion ###

If you use the Bash shell, Git comes with a nice auto-completion script you can enable. Download the Git source code, and look in the `contrib/completion` directory; there should be a file called `git-completion.bash`. Copy this file to your home directory, and add this to your `.bashrc` file:

	source ~/.git-completion.bash

If you want to set up Git to automatically have Bash shell completion for all users, copy this script to the `/opt/local/etc/bash_completion.d` directory on Mac systems or to the `/etc/bash_completion.d/` directory on Linux systems. This is a directory of scripts that Bash will automatically load to provide shell completions.

If you’re using Windows with Git Bash, which is the default when installing Git on Windows with msysGit, auto-completion should be preconfigured.

Press the Tab key when you’re writing a Git command, and it should return a set of suggestions for you to pick from:

	$ git co<tab><tab>
	commit config

In this case, typing git co and then pressing the Tab key twice suggests commit and config. Adding `m<tab>` completes `git commit` automatically.
	
This also works with options, which is probably more useful. For instance, if you’re running a `git log` command and can’t remember one of the options, you can start typing it and press Tab to see what matches:

	$ git log --s<tab>
	--shortstat  --since=  --src-prefix=  --stat   --summary

That’s a pretty nice trick and may save you some time and documentation reading.

### Git Aliases ###

Git doesn’t infer your command if you type it in partially. If you don’t want to type the entire text of each of the Git commands, you can easily set up an alias for each command using `git config`. Here are a couple of examples you may want to set up:

	$ git config --global alias.co checkout
	$ git config --global alias.br branch
	$ git config --global alias.ci commit
	$ git config --global alias.st status

This means that, for example, instead of typing `git commit`, you just need to type `git ci`. As you go on using Git, you’ll probably use other commands frequently as well; in this case, don’t hesitate to create new aliases.

This technique can also be very useful in creating commands that you think should exist. For example, to correct the usability problem you encountered with unstaging a file, you can add your own unstage alias to Git:

	$ git config --global alias.unstage 'reset HEAD --'

This makes the following two commands equivalent:

	$ git unstage fileA
	$ git reset HEAD fileA

This seems a bit clearer. It’s also common to add a `last` command, like this:

	$ git config --global alias.last 'log -1 HEAD'

This way, you can see the last commit easily:
	
	$ git last
	commit 66938dae3329c7aebe598c2246a8e6af90d04646
	Author: Josh Goebel <dreamer3@example.com>
	Date:   Tue Aug 26 19:48:51 2008 +0800

	    test for current head

	    Signed-off-by: Scott Chacon <schacon@example.com>

As you can tell, Git simply replaces the new command with whatever you alias it for. However, maybe you want to run an external command, rather than a Git subcommand. In that case, you start the command with a `!` character. This is useful if you write your own tools that work with a Git repository. We can demonstrate by aliasing `git visual` to run `gitk`:

	$ git config --global alias.visual "!gitk"

## Summary ##

At this point, you can do all the basic local Git operations — creating or cloning a repository, making changes, staging and committing those changes, and viewing the history of all the changes the repository has been through. Next, we’ll cover Git’s killer feature: its branching model.
