# Cơ Bản Về Git #

Đây có thể là chương duy nhất bạn cần đọc để có thể bắt đầu sử dụng Git. Chương này bao hàm từng câu lệnh cơ bản bạn cần để thực hiện phần lớn những việc mà bạn sẽ làm với Git. Kết thúc chương này, bạn có thể cấu hình và khởi động được một kho chứa, bắt đầu hay dừng theo dõi các tập tin, và tổ chức/sắp xếp (stage) cũng như commit các thay đổi. Chúng tôi cũng sẽ hướng dẫn bạn làm sao để bỏ qua (ignore) một số tập tin cũng như kiểu tập tin nào đó, làm sao để khôi phục lỗi một cách nhanh chóng và dễ dàng, làm sao để duyệt qua lịch sử của dự án hay xem các thay đổi giữa những lần commit, và làm sao để đẩy lên (push) hay kéo về (pull) từ các kho chứa từ xa.

## Tạo Một Kho Chứa Git ##

Bạn có thể tạo một dự án có sử dụng Git dựa theo hai phương pháp chính. Thứ nhất là dùng một dự án hay một thư mục đã có sẵn để nhập (import) vào Git. Thứ hai là tạo bản sao của một kho chứa Git đang hoạt động trên một máy chủ khác.

### Khởi Tạo Một Kho Chứa Từ Thư Mục Cũ ###

Nếu như bạn muốn theo dõi một dự án cũ trong Git, bạn cần ở trong thư mục của dự án đó và gõ lệnh sau:

	$ git init

Lệnh này sẽ tạo một thư mục mới có tên `.git`, thư mục này chứa tất cả các tập tin cần thiết cho kho chứa - đó chính là bộ khung/xương của kho chứa Git. Cho tới thời điểm hiện tại, vẫn chưa có gì trong dự án của bạn được theo dõi (track) hết. (Xem *Chương 9* để biết chính xác những tập tin gì có trong thư mục `.git` bạn vừa tạo.)

Nếu bạn muốn kiếm soát phiên bản cho các tập tin có sẵn (đối lập với một thư mục trống), chắc chắn bạn nên bắt đầu theo dõi các tập tin đó và thực hiện commit đầu tiên/khởi tạo (initial commit). Bạn có thể hoàn thành việc này bằng cách chỉ định tập tin bạn muốn theo dõi trong mỗi lần commit sử dụng câu lệnh `git add`:

	$ git add *.c
	$ git add README
	$ git commit -m 'phiên bản đầu tiên/khởi tạo của dự án'

Chúng ta sẽ xem những lệnh này thực hiện những gì trong chốc lát nữa. Bâu giờ thì bạn đã có một kho chứ Git với các tập tin đã được theo dõi và một lần commit đầu tiên.

### Sao Chép Một Kho Chứa Đã Tồn Tại ###

Nếu như bạn muốn có một bản sao của một kho chứa Git có sẵn - ví dụ như, một dự án mà bạn muốn đóng góp vào - câu lệnh bạn cần là `git clone`. Nếu như bạn đã quen thuộc với các hệ thống VCS khác như là Subversion, bạn sẽ nhận ra rằng câu lệnh này là `clone` chứ không phải `checkout`. Đây là một sự khác biệt lớn - Git nhận một bản sao của gần như tất cả dữ liệu mà máy chủ đang có. Mỗi phiên bản của mỗi tập tin sử dụng cho lịch sử của dự án được kéo về khi bạn chạy `git clone`. Thực tế, nếu ổ cứng máy chủ bị hư hỏng, bạn có thể sử dụng bất kỳ bản sao trên bất kỳ máy khách nào để khôi phục lại trạng thái của máy chủ khi nó được sao chép (bạn có thể mất một số tập tin phía máy chủ, nhưng tất cả phiên bản của dữ liệu vẫn tồn tại ở đó - xem chi tiết ở *Chương 4*).

Sử dụng lệnh `git clone [url]` để sao chép một kho chứa. Ví dụ, nếu bạn muốn tạo một bản sao của thư viện Ruby Git có tên Grit, bạn có thể thực hiện như sau:

	$ git clone git://github.com/schacon/grit.git

Một thư mục mới có tên `grit` sẽ được tạo, kèm theo thư mục `.git` và bản sao mới nhất của tất cả dữ liệu của kho chứa đó bên trong. Nếu bạn xem bên trong thư mục `grit`, bạn sẽ thấy các tập tin của dự án bên trong, và đã sẵn sàng cho bạn làm việc hoặc sử dụng. Nếu bạn muốn sao chép kho chứa này vào một thư mục có tên khác không phải là grit, bạn có thể chỉ định tên thư mục đó như là một tuỳ chọn tiếp theo khi chạy dòng lệnh:

	$ git clone git://github.com/schacon/grit.git mygrit

Lệnh này thực thi tương tự như lệnh trước, nhưng thư mục của kho chứa lúc này sẽ có tên là `mygrit`.

Bạn có thể sử dụng Git thông qua một số "giao thức truyền tải" (transfer protocol) khác nhau. Ví dụ trước sử dụng giao thức `git://`, nhưng bạn cũng có thể sử dụng `http(s)://` hoặc `user@server:/path.git` thông qua giao thức SSH. *Chương 4* sẽ giới thiệu tất cả các tuỳ chọn áp dụng trên máy chủ để nó có thể truy cập vào kho chứa Git của bạn cũng như từng ưu và nhược điểm riêng của chúng.

## Ghi Lại Thay Đổi vào Kho Chứa ##

Bây giờ bạn đã có một kho chứa Git thật sự và một bản sao dữ liệu của dự án để làm việc. Bạn cần thực hiện một số thay đổi và commit ảnh của chúng vào kho chứa mỗi lần dự án đạt tới một trạng thái nào đó mà bạn muốn ghi lại.

Hãy nhớ là mỗi tập tin trong thư mục làm việc của bạn có thể ở một trong hai trạng thái : *tracked* hoặc *untrachked*. Tập tin *tracked* là các tập tin đã có mặt trong ảnh (snapshot) trước; chúng có thể là *unmodified*, *modified*, hoặc *staged*. Tập tin *untracked* là các tập tin còn lại - bất kỳ tập tin nào trong thư mục làm việc của bạn mà không có ở ảnh (lần commit) trước hoặc không ở trong khu vực tổ chức (staging area). Ban đầu, khi bạn tạo bản sao của một kho chứa, tất cả tập tin ở trạng thái "đã được theo dõi" (tracked) và "chưa thay đổi" (unmodified) vì bạn vừa mới tải chúng về và chưa thực hiện bất kỳ thay đổi nào.

Khi bạn chỉnh sửa các tập tin, Git coi là chúng đã bị thay đổi so với lần commit trước đó. Bạn *stage* các tập tin bị thay đổi này và sau đó commit tất cả các thay đổi đã được staged (tổ chức) đó, và quá trình này cứ thế lặp đi lặp lại như được miêu tả trong Hình 2-1.

Insert 18333fig0201.png
Hình 2-1. Vòng đời các trạng thái của tập tin.

### Kiểm Tra Trạng Thái Của Tập Tin ###

Công cụ chính để phát hiện trạng thái của tập tin là lệnh `git status`. Nếu bạn chạy lệnh này trực tiếp sau khi vừa tạo xong một bản sao, bạn sẽ thấy tương tự như sau:

	$ git status
	# On branch master
	nothing to commit, working directory clean

Điều này có nghĩa là bạn có một thư mục làm việc "sạch" - hay nói cách khác, không có tập tin đang theo dõi nào bị thay đổi. Git cũng không phát hiện ra tập tin chưa được theo dõi nào, nếu không thì chúng đã được liệt kê ra đây. Cuối cùng, lệnh này cho bạn biết bạn đang thao tác trên "nhánh" (branch) nào. Hiện tại thì nó sẽ luôn là `master`, đó là nhánh mặc định; bạn chưa nên quan tâm đến vấn đề này bây giờ. Chương tiếp theo chúng ta sẽ bàn về các Nhánh chi tiết hơn.

Giả sử bạn thêm một tập tin mới vào dự án, một tập tin `README` đơn giản. Nếu như tập tin này chưa từng tồn tại trước đó, kho bạn chạy `git status`, bạn sẽ thấy thông báo tập tin chưa được theo dõi như sau:

	$ vim README
	$ git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#	README
	nothing added to commit but untracked files present (use "git add" to track)

Bạn có thể thấy là tập tin `README` mới chưa được theo dõi, bởi vì nó nằm trong danh sách "Các tập tin chưa được theo dõi:" (Untracked files) trong thông báo trạng thái được hiển thị. Chưa được theo dõi về cơ bản có nghĩa là Git thấy một tập tin chưa tồn tại trong ảnh (lần commit) trước; Git sẽ không tự động thêm nó vào các commit tiếp theo trừ khi bạn chỉ định rõ ràng cho nó làm như vậy. Theo cách này, bạn sẽ không vô tình thêm vào các tập tin nhị phân hoặc các tập tin khác mà bạn không thực sự muốn. Trường hợp này bạn thực sự muốn thêm README, vậy hãy bắt đầu theo dõi nó.

### Theo Dõi Các Tập Tin Mới ###

Để có thể theo dõi các tập tin mới tạo, bạn sử dụng lệnh `git add`. Và để bắt đầu theo dõi tập tin `README` bạn có thể chạy lệnh sau:

	$ git add README

Nếu bạn chạy lệnh kiểm tra trạng thái lại một lần nữa, bạn sẽ thấy tập tin `README` bây giờ đã được theo dõi và tổ chức (staged):

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#

Bạn có thể thấy nó đã được staged vì nó đã nằm trong danh sách "Các thay đổi chuẩn bị commit". Nếu bạn commit tại thời điểm này, phiên bản của tập tin ở thời điểm bạn chạy `git add` sẽ được thêm vào lịch sử commit. Nhớ lại khi bạn chạy `git init` lúc trước, sau đó là lệnh `git add (files)` - đó chính là bắt đầu theo dõi các tập tin trong thư mục của bạn. Lệnh `git add` có thể dùng cho một tập tin hoặc một thư mục; nếu là thư mục, nó sẽ thêm tất cả tập tin trong thư mục đó cũng như các thư mục con.

### Quản Lý Các Tập Tin Đã Thay Đổi ###

Hãy sửa một tập tin đang được theo dõi. Nếu bạn sửa một tập tin đang được theo dõi như `benchmarks.rb` sau đó chạy lệnh `status`, bạn sẽ thấy tương tự như sau:

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

Tập tin `benchmarks.rb` nằm trong danh sách "Các thay đổi chưa được tổ chức/đánh dấu để commit" - có nghĩa là một tập tin đang được theo dõi đã bị thay đổi trong thư mục làm việc nhưng chưa được "staged". Để làm việc này, bạn chạy lệnh `git add` (đó là một câu lệnh đa chức năng - bạn có thể dùng nó để bắt đầu theo dõi tập tin, tổ chức tập tin, hoặc các việc khác như đánh dấu đã giải quyết xong các tập tin có nội dung mâu thuẫn nhau khi tích hợp). Chạy `git add` để "stage" tập tin `benchmarks.rb` và sau đó chạy lại lệnh `git status`: 

	$ git add benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#

Cả hai tập tin đã được tổ chức và sẽ có mặt trong lần commit tới. Bây giờ, giả sử bạn nhớ ra một chi tiết nhỏ nào đó cần thay đổi trong tập tin `benchmarks.rb` trước khi commit. Bạn lại mở nó ra và sửa, bây giờ thì sẵn sàng để commit rồi. Tuy nhiên, hãy chạy `git status` lại một lần nữa:

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

Chuyện gì xảy ra thế này? Bây giờ `benchmarks.rb` lại nằm trong cả hai danh sách staged và unstaged. Làm sao có thể thế được? Hoá ra là Git tổ chức một tập tin chính lúc bạn chạy lệnh `git add`. Nếu bạn commit bây giờ, phiên bản của tập tin `benchmarks.rb` khi bạn chạy `git add` sẽ được commit chứ không phải như bạn nhìn thấy hiện tại trong thư mục làm việc khi chạy `git commit`. Nếu như bạn chỉnh sửa một tập tin sau khi chạy `git add`, bạn phải chạy `git add` lại một lần nữa để đưa nó vào phiên bản mới nhất:

	$ git add benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#

### Bỏ Qua Các Tập Tin ###

Thường thì hay có một số loại tập tin mà bạn không muốn Git tự động thêm nó vào hoặc thậm chí hiển thị là không được theo dõi. Những tập tin này thường được tạo ta tự động ví dụ như các tập tin nhật ký (log files) hay các tập được sinh ra khi biên dịch chương trình. Trong những trường hợp như thế, bạn có thể tạo một tập tin liệt kê các "mẫu" (patterns) để tìm những tập tin này có tên `.gitignore`. Đây là một ví dụ của `.gitignore`:

	$ cat .gitignore
	*.[oa]
	*~

Dòng đầu tiên yêu cầu Git bỏ qua tất cả các tập tin có đuôi là `.o` hoặc `.a` - các tập tin *object* và *archiev* có thể được tạo ra khi bạn dịch mã nguồn. Dòng thứ hai yêu cầu Git bỏ qua tất cả tập tin có đuôi là dẫu ngã (`~`), chúng được sử dụng để lưu các giá trị tạm thời bởi rất nhiều chương trình soạn thảo như Emacs. Bạn có thể thêm vào các thư mục như `log`, `tmp`, hay `pid`; hay các tài liệu được tạo ra tự động,... Tạo một tập tin `.gitignore` trước khi bắt đầu làm việc là một ý tưởng tốt, như vậy bạn sẽ không vô tình commit các tập tin mà bạn không muốn.

Quy tắc cho các mẫu có thể sử dụng trong `.gitignore` như sau:

*	Dòng trống hoặc bắt đầu với `#` sẽ được bỏ qua.
*	Các mẫu chuẩn toàn cầu hoạt động tốt.
*	Mẫu có thể kết thúc bằng dấu gạch chéo (`/`) để chỉ định một thư mục.
*	Bạn có thể có "mẫu phủ định" bằng cách thêm dấu cảm thám vào phía trước (`!`).

Các mẫu toàn cầu giống như các biểu thức chính quy (regular expression) rút gọn được sử dụng trong shell. Dấu sao (`*`) khớp với 0 hoặc nhiều ký tự; `[abc]` khớp với bất kỳ ký tự nào trong dấu ngoặc (trong trường hợp này là `a`, `b`, hoặc `c`); dấu hỏi (`?`) khớp với một ký tự đơn; và dấu ngoặc có ký tự được ngăn cách bởi dấu gạch ngang (`[0-9]`) khớp bất kỳ ký tự nào trong khoảng đó (ở đây là từ 0 đến 9).

Đây là một ví dụ của `.gitignore`:

	# a comment - dòng này được bỏ qua
	# không theo dõi tập tin có đuôi .a 
	*.a
	# nhưng theo dõi tập lib.a, mặc dù bạn đang bỏ qua tất cả tập tin .a ở trên
	!lib.a
	# chỉ bỏ qua tập TODO ở thư mục gốc, chứ không phải ở các thư mục con subdir/TODO
	/TODO
	# bỏ qua tất cả tập tin trong thư mục build/
	build/
	# bỏ qua doc/notes.txt, không phải doc/server/arch.txt
	doc/*.txt
	# bỏ qua tất cả tập .txt trong thư mục doc/
	doc/**/*.txt

Mẫu `**/` có mặt từ Git phiên bản 1.8.2 trở lên.

### Xem Các Thay Đổi Staged và Unstaged ###

Nếu câu lệnh `git status` quá mơ hồ với bạn - bạn muốn biết chính xác cái đã thay đổi là gì, chứ không chỉ là tập tin nào bị thay đổi - bạn có thể sử dụng lệnh `git diff`. Chúng ta sẽ nói về `git diff` chi tiết hơn trong phần sau; nhưng chắc chắn bạn sẽ thường xuyên sử dụng nó để trả lời cho hai câu hỏi sau: Cái bạn đã thay đổi nhưng chưa được staged là gì? Và Những thứ đã được staged để chuẩn bị commit là gì?. Lệnh `git status` chỉ trả lời những câu hỏi trên một cách chung chung, nhưng `git diff` chỉ cho bạn chính xác từng dòng đã được thêm hoặc xoá - hay còn được biết đến như là bản vá (patch).

Giả sử bạn sửa và stage tập tin `README` lại một lần nữa, sau đó là sửa tập `benchmarks.rb` mà không stage nó. Nếu bạn chạy lệnh `status`, bạn sẽ lại nhìn thấy tương tự như sau:

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

Để xem chính xác bạn đã thay đổi nhưng chưa stage những gì, hãy dùng `git diff` không sử dụng tham số nào khác:

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

Câu lệnh này so sánh cái ở trong thư mục làm việc của bạn với cái ở trong khu vực tổ chức (staging). Kết quả cho bạn biết những thứ đã bị thay đổi mà chưa được stage.

Nếu bạn muốn xem những gì bạn đã staged mà chuẩn bị được commit, bạn có thể sử dụng `git diff --cached`. (Từ Git 1.6.1 trở đi, bạn có thể sử dụng `git diff --staged`, có thể sẽ dễ nhớ hơn.) Lệnh này so sánh những thay đổi đã được tổ chức với lần commit trước đó:

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

Một điều quan trọng cần ghi nhớ là chỉ chạy `git diff` không thôi thì nó sẽ không hiển thị cho bạn tất cả thay đổi từ lần comiit trước - mà chỉ có các thay đổi chưa được tổ chức. Điều này có thể gây khó hiểu một chút, bởi vì nếu như bạn đã tổ chức tất cả các thay đổi, `git diff` sẽ không hiện gì cả.

Thêm một ví dụ nữa, nếu như bạn tổ chức tập tin `benchmarks.rb` rồi sau đó mới sửa nó, bạn có thể sử dụng `git diff` để xem các thay đổi đã tổ chức cũng như chưa tổ chức:

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

Bây giờ bạn có thể sử dụng `git diff` để xem những gì vẫn chưa được tổ chức

	$ git diff
	diff --git a/benchmarks.rb b/benchmarks.rb
	index e445e28..86b2f7c 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -127,3 +127,4 @@ end
	 main()

	 ##pp Grit::GitRuby.cache_client.stats
	+# test line

và `git diff --cached` để xem những gì đã được tổ chức tới thời điểm hiện tại:

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

### Commit Thay Đổi ###

Bây giờ, sau khi đã tổ chức các tập tin theo ý muốn, bạn có thể commit chúng. Hãy nhỡ là những gì chưa được tổ chức - bất kỳ tập tin nào được tạo ra hoặc sửa đổi sau khi chạy lệnh `git add` - sẽ không được commit. Chúng sẽ vẫn ở trạng thái đã thay đổi trên ổ cứng của bạn.
Trong trường hợp này, bạn thấy là từ lần cuối cùng chạy `git status`, tất cả mọi thứ đã được tổ chức thế nên bạn đã sẵn sàng để commit. Cách đơn giản nhất để commit là gõ vào `git commit`:

	$ git commit

Sau khi chạy lệnh này, chương trình soạn thảo do bạn lựa chọn sẽ được mở lên. (Chương trình được chỉ định bằng biến `$EDITOR` - thường là vim hoặc emacs, tuy nhiên bạn có thể chọn bất kỳ chương trình nào khác bằng cách sử dụng lệnh `git config --global core.editor` như bạn đã thấy ở *Chương 1*).

Nó sẽ hiển thị đoạn thông báo sau (trong ví dụ này là màn hình của Vim):

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

Bạn có thể thấy thông báo mặc định có chứa nội dung của lần chạy `git status` cuối cùng được dùng làm chú thích và một dòng trống ở trên cùng. Bạn có thể xoá những chú thích này đi và nhập vào nội dung riêng của bạn cho commit đó, hoặc bạn có thể giữ nguyên như vậy để giúp bạn nhớ được những gì đang commit. (Một cách nữa để nhắc nhở bạn rõ ràng hơn những gì bạn đã sửa là truyền vào tham số -v cho `git commit`. Làm như vậy sẽ đưa tất cả thay đổi như khi thực hiện lệnh diff vào chương trình soạn thảo, như vậy bạn có thể biết chính xác những gì bạn đã làm.) Khi bạn thoát ra khỏi chương trình soạn thảo, Git tạo commit của bạn với thông báo/điệp đó (các chú thích và diff sẽ bị bỏ đi).

Nói cách khác, bạn có thể gõ trực tiếp thông điệp cùng với lệnh `commit` bằng cách thêm vào sau cờ `-m`, như sau:

	$ git commit -m "Story 182: Fix benchmarks for speed"
	[master]: created 463dc4f: "Fix benchmarks for speed"
	 2 files changed, 3 insertions(+), 0 deletions(-)
	 create mode 100644 README

Bây giờ thì bạn đã thực hiện xong commit đầu tiên. Bạn có thể thấy là commit đó hiển thị một số thông tin về chính nó như: nhánh mà bạn commit tới (`master`), mã băm SHA-1 của commit đó, bao nhiêu tập tin đã thay đổi, và thống kê về số dòng đã thêm cũng như xoá trong commit.

Hãy nhớ là commit lưu lại ảnh các tập tin mà bạn chỉ định trong khu vực tổ chức. Bất kỳ tập tin nào không ở trong đó sẽ vẫn giữ nguyên trạng thái là đã sửa (modified); bạn có thể thực hiện một commit khác để thêm chúng vào lịch sử. Mỗi lần thực hiện commit là bạn đang ghi lại ảnh của dự án mà bạn có thể dựa vào đó để so sánh hoặc khôi phục về sau này.

### Bỏ Qua Khu Vực Tổ Chức ###

Mặc dù tự tổ chức commit theo cách bạn muốn là một cách hay, tuy nhiên đôi khi khu vực tổ chức khiến quy trình làm việc của bạn trở nên phức tạp. Nếu bạn muốn bỏ qua bước này, Git đã cung cấp sẵn cho bạn một "lối tắt". Chỉ cần thêm vào lựa chọn `-a` khi thực hiện `git commit`, Git sẽ tự động thêm tất cả các tập tin đã được theo dõi trước khi thực hiện lệnh commit, cho phép bạn bỏ qua bước `git add`:

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

Hãy chú ý tại sao bạn không phải chạy `git add` với tập tin `benchmarks.rb` trước khi commit trong trường hợp này.

### Xoá Tập Tin ###

Để xoá một tập tin khỏi Git, bạn phải xoá nó khỏi danh sách được theo dõi (chính xác hơn, xoá nó khỏi khu vực tổ chức) và sau đó commit. Lệnh `git rm` thực hiện điều đó và cũng xoá tập tin khỏi thư mục làm việc vì thế bạn sẽ không thấy nó như là tập tin không được theo dõi trong những lần tiếp theo.

Nếu bạn chỉ đơn giản xoá tập tin khỏi thư mục làm việc, nó sẽ được hiện thị trong phần "Thay đổi không được tổ chức để commit" (hay _unstaged_) khi bạn chạy `git status`:

	$ rm grit.gemspec
	$ git status
	# On branch master
	#
	# Changes not staged for commit:
	#   (use "git add/rm <file>..." to update what will be committed)
	#
	#       deleted:    grit.gemspec
	#

Khi đó, nếu bạn chạy `git rm`, Git sẽ xoá tập tin đó khỏi khu vực tổ chức:

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

Lần commit tới, tập tin đó sẽ bị xoá và không còn được theo dõi nữa. Nếu như bạn đã sửa và thêm tập tin đó vào danh sách, bạn phải ép Git xoá đi bằng cách thêm lựa chọn `-f`. Đây là một chức năng an toàn nhằm ngăn chặn việc xoá nhầm dữ liệu chưa được lưu vào ảnh và nó sẽ không thể được khôi phục từ Git.

Một chức năng hữu ích khác có thể bạn muốn sử dụng đó là giữ tập tin trong thư mục làm việc nhưng không thêm chúng vào khu vực tổ chức. Hay nói cách khác bạn muốn lưu tập tin trên ổ cứng nhưng không muốn Git theo dõi chúng nữa. Điều này đặc biệt hữu ích nếu như bạn quên thêm nó vào tập `.gitignore` và vô tình tổ chức (stage) chúng, ví dụ như một tập tin nhật ký lớn hoặc rất nhiều tập tin `.a`. Để làm được điều này, hãy sử dụng lựa chọn `--cached`:

	$ git rm --cached readme.txt

Bạn có thể truyền vào tập tin, thư mục hay mẫu (patterns) vào lệnh `git rm`. Nghĩa là bạn có thể thực hiện tương tự như:

	$ git rm log/\*.log

Chú ý dấu chéo ngược (`\`) đằng trước `*`. Việc này là cần thiết vì ngoài phần mở rộng mặc định Git còn sử dụng thêm phần mở rộng riêng - "This is necessary because Git does its own filename expansion in addition to your shell’s filename expansion". Trên Windows, dấu gạch ngược (`\`) phải bỏ đi. Lệnh này xoá toàn bộ tập tin có đuôi `.log` trong thư mục `log/`. Hoặc bạn có thể thực hiện tương tự như sau:

	$ git rm \*~

Lệnh này xoá toàn bộ tập tin kết thúc bằng `~`.

### Di Chuyển Tập Tin ###

Không giống như các hệ thống quản lý phiên bản khác, Git không theo dõi việc di chuyển tập tin một cách rõ ràng. Nếu bạn đổi tên một tập tin trong Git, không có thông tin nào được lưu trữ trong Git có thể cho bạn biết là bạn đã đổi tên một tập tin. 
Tuy nhiên, Git rất thông minh trong việc tìm ra điều đó - chúng ta sẽ nói về phát hiện việc di chuyển các tập tin sau.

Vì thế nên nó hơi khó hiểu khi Git cung cấp lệnh `mv`. Nếu bạn muốn đổi tên một tập tin trong Git, bạn có thể dùng 

	$ git mv file_from file_to

và nó chạy tốt. Thực tế, nếu bạn chạy lệnh tương tự và sau đó kiểm tra trạng thái, bạn sẽ thấy Git coi là nó đã đổi tên một tập tin:

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

Tuy nhiên, việc này lại tương tự việc thực hiện như sau:

	$ mv README.txt README
	$ git rm README.txt
	$ git add README

Git ngầm hiểu đó là đổi tên, vì thế dù bạn đổi tên bằng cách này hoặc dùng lệnh `mv` cũng không quan trọng. Sự khác biệt duy nhất ở đây là `mv` là một lệnh duy nhất thay vì ba - sử dụng nó thuận tiện hơn rất nhiều. Quan trọng hơn, bạn có thể dùng bất kỳ cách nào để đổi tên một tập tin, và chạy add/rm sau đó, trước khi commit.

## Xem Lịch Sử Commit ##

Sau khi bạn đã thực hiện rất nhiều commit, hoặc bạn đã sao chép một kho chứa với các commit có sẵn, chắc chắn bạn sẽ muốn xem lại những gì đã xảy ra. Cách đơn giản và có liệu lực tốt nhất là sử dụng lệnh `git log`.

Các ví dụ sau đây sử dụng một dự án rất đơn giản là `simplegit` tôi thường sử dụng làm ví dụ minh hoạ. Để tải dự án này, bạn hãy chạy lệnh:

	git clone git://github.com/schacon/simplegit-progit.git

Khi bạn chạy `git log` trên dự án này, bạn sẽ thấy tương tự như sau:

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

Mặc định, không sử dụng tham số nào, `git log` liệt kê các commit được thực hiện trong kho chứa đó theo thứ tự thời gian. Đó là, commit mới nhất được hiển thị đầu tiên. Như bạn có thể thấy, lệnh này liệt kê từng commit với mã băm SHA-1, tên người commit, địa chỉ email, ngày lưu, và thông điệp của chúng. 

Có rất nhiều tuỳ chọn (tham biến/số) khác nhau cho lệnh `git log` giúp bạn tìm chỉ hiện thị thứ mà bạn thực sự muốn. Ở đây, chúng ta sẽ cùng xem qua các lựa chọn phổ biến, thường được sử dụng nhiều nhất.

Một trong các tuỳ chọn hữu ích nhất là `-p`, nó hiện thị diff của từng commit. Bạn cũng có thể dùng `-2` để giới hạn chỉ hiển thị hai commit gần nhất:

	$ git log -p -2
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	diff --git a/Rakefile b/Rakefile
	index a874b73..8f94139 100644
	--- a/Rakefile
	+++ b/Rakefile
	@@ -5,5 +5,5 @@ require 'rake/gempackagetask'
	 spec = Gem::Specification.new do |s|
	     s.name      =   "simplegit"
	-    s.version   =   "0.1.0"
	+    s.version   =   "0.1.1"
	     s.author    =   "Scott Chacon"
	     s.email     =   "schacon@gee-mail.com

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

Lựa chọn này hiển thị thông tin tương tự nhưng thêm vào đó là nội dung diff trực tiếp của từng commit. Điều này rất có ích cho việc xem lại mã nguồn hoặc duyệt qua nhanh chóng những commit mà đồng nghiệp của bạn đã thực hiện.

Đôi khi xem lại cách thay đổi tổng quát (word level) lại dễ dàng hơn việc xem theo dòng. Lựa chọn `--word-diff` được cung cấp trong Git, bạn có thể thêm nó vào sau lệnh `git log -p` để xem diff một cách tổng quát thay vì xem từng dòng theo cách thông thường. Xem diff tổng quát dường như là vô dụng khi sử dụng với mã nguồn, nhưng lại rất hữu ích với các tập tin văn bản lớn như sách hay luận văn. Đây là một ví dụ:

	$ git log -U1 --word-diff
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	diff --git a/Rakefile b/Rakefile
	index a874b73..8f94139 100644
	--- a/Rakefile
	+++ b/Rakefile
	@@ -7,3 +7,3 @@ spec = Gem::Specification.new do |s|
	    s.name      =   "simplegit"
	    s.version   =   [-"0.1.0"-]{+"0.1.1"+}
	    s.author    =   "Scott Chacon"

Như bạn có thể thấy, không có dòng nào được thêm hay xoá trong phần thông báo như là với diff thông thường. Thay đổi được hiển thị ngay trên một dòng. Bạn có thể thấy phần thêm mới được bao quanh trong `{+ +}` còn phần xoá đi thì trong `[- -]`. Có thể bạn cũng muốn giảm ba dòng ngữ cảnh trong phần hiển thị diff xuống còn một dòng, vì ngữ cảnh hiện tại là các từ, không phải các dòng nữa. Bạn có thể làm được điều này với tham số `-U1` như ví dụ trên.

Bạn cũng có thể sử dụng một loại lựa chọn thống kê với `git log`. Ví dụ, nếu bạn muốn xem một số thống kê tóm tắt cho mỗi commit, bạn có thể sử dụng tham số `--stat`:

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

Như bạn có thể thấy, lựa chọn `--stat` in ra phía dưới mỗi commit danh sách các tập tin đã chỉnh sửa, bao nhiêu tập tin được sửa, và bao nhiêu dòng trong các tập tin đó được thêm vào hay xoá đi. Nó cũng in ra một phần tóm tắt ở cuối cùng. 
Một lựa chọn rất hữu ích khác là `--pretty`. Lựa chọn này thay đổi phần hiển thị ra theo các cách khác nhau. Có một số lựa chọn được cung cấp sẵn cho bạn sử dụng. Lựa chọn `oneline` in mỗi commit trên một dòng, có ích khi bạn xem nhiều commit cùng lúc. Ngoài ra các lựa chọn `short`, `full`, và `fuller` hiện thị gần như tương tự nhau với ít hoặc nhiều thông tin hơn theo cùng thứ tự:

	$ git log --pretty=oneline
	ca82a6dff817ec66f44342007202690a93763949 changed the version number
	085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 removed unnecessary test code
	a11bef06a3f659402fe7563abf99ad00de2209e6 first commit

Lựa chọn thú vị nhất là `format`, cho phép bạn chỉ định định dạng riêng của phần hiện thị. Nó đặc biệt hữu ích khi bạn đang xuất ra cho các máy phân tích thông tin (machine parsing) - vì bạn là người chỉ rõ định dạng, nên bạn sẽ biết được nó không bị thay đổi cùng với các cập nhật sau này của Git.

	$ git log --pretty=format:"%h - %an, %ar : %s"
	ca82a6d - Scott Chacon, 11 months ago : changed the version number
	085bb3b - Scott Chacon, 11 months ago : removed unnecessary test code
	a11bef0 - Scott Chacon, 11 months ago : first commit

Bảng 2-1 liệt kê một vài lựa chọn mà `format` sử dụng.

<!-- Attention to translators: this is a table declaration.
The lines must be formatted as follows
<TAB><First column text><TAB><Second column text>
-->

	Lựa chọn	Mô tả thông tin đầu ra
	%H	Mã băm của commit
	%h	Mã băm của commit ngắn gọn hơn
	%T	Băm hiển thị dạng cây
	%t	Băm hiển thị dạng cây ngắn gọn hơn
	%P	Các mã băm gốc
	%p	Mã băm gốc ngắn gọn
	%an	Tên tác giả
	%ae	E-mail tác giả
	%ad	Ngày "tác giả" (định dạng tương tự như lựa chọn --date= )
	%ar	Ngày tác giả, tương đối
	%cn	Tên người commit
	%ce	Email người commit
	%cd	Ngày commit
	%cr	Ngày commit, tương đối
	%s	Chủ để

Có thể bạn băn khoăn về sự khác nhau giữa _tác giả_ (author) và _người commit_ (committer). _Tác giả_ là người đầu tiên viết bản vá (patch), trong khi đó _người commit_ là người cuối cùng áp dụng miếng vá đó. Như vậy, nếu bạn gửi một bản vá cho một dự án và một trong các thành viên chính của dự án "áp dụng" (chấp nhận) bản vá đó, cả hai sẽ cùng được ghi nhận công trạng (credit) - bạn với vai trò là tác giả và thành viên của dự án trong vai trò người commit. Chúng ta sẽ bàn kỹ hơn một chút về sự khác nhau này trong *Chương 5*.

Lựa chọn `oneline` và `format` đặc biệt hữu ích khi sử dụng với một tham số khác của `log` là `--graph`. Khi sử dụng, tham số này sẽ thêm một biểu đồ sử dụng dựa trên các ký tự ASCII hiển thị nhánh và lịch sử tích hợp các tập tin của bạn, chúng ta có thể thấy trong dự án Grit như sau:

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

Vừa rồi mới chỉ là một số lựa chọn định dạng cơ bản cho `git log` - còn rất nhiều các định dạng khác. Bảng 2-2 liệt kê các lựa chọn chúng ta đã đề cập qua và một số định dạng cơ bản khác có thể hữu ích, cùng với mô tả đầu ra của lệnh `log`.

<!-- Attention to translators: this is a table declaration.
The lines must be formatted as follows
<TAB><First column text><TAB><Second column text>
-->

	Tuỳ chọn	Mô tả
	-p	Hiển thị bản vá với mỗi commit.
	--word-diff	Hiển thị bản vá ở định dạng tổng quan (word).
	--stat	Hiển thị thống kê của các tập tin được chỉnh sửa trong mỗi commit.
	--shortstat	Chỉ hiển thị thay đổi/thêm mới/xoá bằng lệnh --stat.
	--name-only	Hiển thị danh sách các tập tin đã thay đổi sau thông tin của commit.
	--name-status	Hiển thị các tập tin bị ảnh hưởng với các thông tin như thêm mới/sửa/xoá.
	--abbrev-commit	Chỉ hiện thị một số ký tự đầu của mã băm SHA-1 thay vì tất cả 40.
	--relative-date	Hiển thị ngày ở định dạng tương đối (ví dụ, "2 weeks ago") thay vì định dạng đầy đủ.
	--graph	Hiển thị biểu đồ ASCII của nhánh và lịch sử tích hợp cùng với thông tin đầu ra khác.
	--pretty	Hiện thị các commit sử dụng một định dạng khác. Các lựa chọn bao gồm oneline, short, full, fuller và format (cho phép bạn sử dụng định dạng riêng).
	--oneline	Một lựa chọn ngắn, thuận tiện cho `--pretty=oneline --abbrev-commit`.

### Giới Hạn Thông Tin Đầu Ra ###

Ngoài các lựa chọn để định dạng đầu ra, `git log` còn nhận vào một số các lựa chọn khác cho mục đích giới hạn khác - là các lựa chọn cho phép bạn hiển thị một phần các commit. Bạn đã thấy một trong các tham số đó - đó là `-2`, cái mà dùng để hiện thị hai commit mới nhất. Thực tế bạn có thể dùng `-<n>`, trong đó `n` là số nguyên dương bất kỳ để hiển thị `n` commit mới nhất. Trong thực tế, bạn thường không sử dụng chúng, vì mặc định Git đã hiển thị đầu ra theo trang do vậy bạn chỉ xem được một trang lịch sử tại một thời điểm.

Tuy nhiên, tham số kiểu giới hạn theo thời gian như `--since` và `--until` khá hữu ích. Ví dụ, lệnh này hiển thị các commit được thực hiện trong vòng hai tuần gần nhất:

	$ git log --since=2.weeks

Lệnh này hoạt động được với rất nhiều định dạng - bạn có thể chỉ định một ngày cụ thể ("2008-01-15") hoặc tương đối như "2 years 1 day 3 minutes ago".

Bạn cũng có thể lọc các commint thoả mãn một số tiêu chí nhất định. Tham số `--author` cho phép bạn lọc một tác giả nhất định, và tham số `--grep` cho phép bạn tìm kiếm các từ khoá trong thông điệp của commit. (Lưu ý là nếu như bạn muốn chỉ định tham số author và grep, bạn phải thêm vào `--all-match` bằng không lệnh đó sẽ chỉ tìm kiếm các commit thoả mãn một trong hai.)

Tham số hữu ích cuối cùng sử dụng cho `git log` với vai trò một bộ lọc là đường dẫn. Nếu bạn chỉ định một thư mục hoặc tên một tập tin, bạn có thể giới hạn các commit chỉ được thực hiện trên tập tin đó. Tham số này luôn được sử dụng cuối cùng trong câu lệnh và đứng sau hai gạch ngang (`--`) như thường lệ để phân chia các đường dẫn khác nhau.

Bảng 2-3 liệt kê các lựa chọn trên và một số lựa chọn phổ biến khác cho bạn thao khảo.

<!-- Attention to translators: this is a table declaration.
The lines must be formatted as follows
<TAB><First column text><TAB><Second column text>
-->

	Lựa chọn	Mô tả
	-(n)	Chỉ hiển thị n commit mới nhất
	--since, --after	Giới hạn các commit được thực hiện sau ngày nhất định.
	--until, --before	Giới hạn các commit được thực hiện trước ngày nhất định.
	--author	Chỉ hiện thị các commit mà tên tác giả thoả mãn điều kiện nhất định.
	--committer	Chỉ hiện thị các commit mà tên người commit thoả mãn điều kiện nhất định.

Ví dụ, bạn muốn xem các commit đã thay đổi các tập tin thử nghiệm trong lịch sử mã nguồn của Git, được commit bởi Junio Hâmno trng tháng 10 năm 2008 mà chưa được tích hợp/gộp, bạn có thể chạy lệnh sau:

	$ git log --pretty="%h - %s" --author=gitster --since="2008-10-01" \
	   --before="2008-11-01" --no-merges -- t/
	5610e3b - Fix testcase failure when extended attribute
	acd3b9e - Enhance hold_lock_file_for_{update,append}()
	f563754 - demonstrate breakage of detached checkout wi
	d1a43f2 - reset --hard/read-tree --reset -u: remove un
	51a94af - Fix "checkout --track -b newbranch" on detac
	b0ad11e - pull: allow "git pull origin $something:$cur

Có gần 20,000 commit trong lịch sử mã nguồn của Git, lệnh này chỉ hiện thị 6 commit thoả mãn tiêu chí đặt ra.

### Hiển Thị Lịch Sử Trên Giao Diện ###

Nếu bạn muốn sử dụng một công cụ đồ hoạ để trực quan hoá lịch sử commit, bạn có thể thử một chương trình Tcl/Tk có tên `gitk` được xuất bản kèm với git. Gitk cơ bản là một công cụ `git log` trực quan, nó chấp nhận hầu hết các lựa chọn để lọc mà `git log` thường dùng. Nếu bạn gõ `gitk` trên thư mục của dự án, bạn sẽ thấy giống như Hình 2-2.

Insert 18333fig0202.png
Hình 2-2. Công cụ trực quan hoá lịch sử commit gitk.

Bạn có thể xem lịch sử commit ở phần nửa trên của cửa sổ cùng cùng một biểu đồ "cây" (ancestry) trực quan. Phần xem diff ở nửa dưới của cửa sổ hiện thị các thay đổi trong bất kỳ commit nào bạn click ở trên.

## Phục Hồi ##

Tại thời điểm bất kỳ, bạn có thể muốn phục hồi (undo) một phần nào đó. Bây giờ, chúng ta sẽ cùng xem xét một số công cụ cơ bản dùng cho việc phục hồi các thay đổi đã thực hiện. Hãy cẩn thận, bởi vì không phải lúc nào bạn cũng có thể làm được điều này. Đây là một trong số ít thuộc thành phần của Git mà bạn có thể mất dữ liệu nếu làm sai.

### Thay Đổi Commit Cuối Cùng ###

Một trong những cách phục hồi phổ biến thường dùng khi bạn commit quá sớm/vội và có thể quên thêm vào đó một số tập tin hoặc là thông điệp commit không như ý muốn. Nếu như bạn muốn thực hiện lại commit đó, bạn có thể chạy lệnh commit với tham số `--amend`:

	$ git commit --amend

Lệnh này sử dụng khu vực tổ chức để commit. Nếu bạn không thay đổi gì thêm từ lần commit cuối cùng (ví dụ, bạn chạy lệnh này ngay lập tức sau commit trước đó), thì ảnh của dự án sẽ vẫn như vậy và tất cả những gì bạn thay đổi là thông điệp của commit.

Trình soạn thảo văn bản xuất hiện để bạn thay đổi thông điệp của commit, nhưng nó đã chứa nội dung thông điệp của commit trước đó. Bạn có thể sửa nội dung như thường lệ, và nó sẽ được ghi đè lên commit trước đó.

Ví dụ, nếu như bạn thực hiện xong commit và rồi sau đó mới nhận ra rằng đã quên tổ chức các thay đổi trong tập tin bạn muốn để thêm vào commit đó, bạn có thể chạy lệnh sau:

	$ git commit -m 'initial commit'
	$ git add forgotten_file
	$ git commit --amend

Sau khi chạy ba lệnh này, kết quả cuối cùng cũng vẫn chỉ là một commit - commit thứ hai sẽ thay thế các kết quả của commit trước đó.

### Loại Bỏ Tập Tin Đã Tổ Chức ###

Hai phần tiếp theo sẽ minh hoạ cho bạn thấy làm sao để thoả hiệp các thay đổi giữa khu vực tổ chức và thư mục làm việc. Cái hay ở đây là câu lệnh sử dụng để xác định trạng thái của hai khu vực đồng thời cũng gợi ý cho bạn làm sao thể phục hồi các thay đổi. Ví dụ như, giả sự bạn sửa nội dung của hai tập tin và muốn commit chúng làm hai lần riêng biệt nhau, nhưng bạn đã vô tình sử dụng `git add *` và tổ chức cả hai. Vậy làm thể nào để loại bỏ một trong hai khỏi khu vực tổ chức? Lệnh `git status` sẽ giúp bạn:

	$ git add .
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#       modified:   benchmarks.rb
	#

Ngay dưới phần "Thay đổi sắp được commit", nó chỉ ra rằng "sử dụng `git reset HEAD <file>...` để loại bỏ khỏi khu vực tổ chức". Vậy thì hãy làm theo gợi ý đó để loại bỏ tập tin `benchmarks.rb`:

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

Lệnh này hơi khác biệt một chút, nhưng nó hoạt động đúng như chúng ta mong đợi. Tập tin `benchmarks.rb` được thay đổi và một lần nữa lại trở thành chưa tổ chức.

### Phục Hồi Tập Tin Đã Thay Đổi ###

Sẽ như thế nào khi bạn nhận ra rằng bạn không muốn giữ những thay đổi trong tập tin `benchmarks.rb`? Làm thế nào để dễ dàng phục hồi lại những thay đổi đó - phục hồi nó lại trạng thái giống như sau khi thực hiện commit cuối cùng (hoặc như sau khi sao chép (initialy cloned), hoặc như lúc bạn mới đưa chúng vào thư mục làm việc)? May mắn là, `git status` cũng sẽ cho bạn biết làm sao để thực hiện được việc đó. Trong thông báo đầu ra của ví dụ vừa rồi, khu vực tổ chức của chúng ta như sau:

	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   benchmarks.rb
	#

Nó chỉ cho bạn rõ ràng làm sao thể hủy những thay đổi vừa được thực hiện (ít nhất, phiên bản mới nhất của Git, 1.6.1 và mới hơn, hỗ trợ điều này - nếu bạn đang sử dụng phiên bản cũ hơn, chúng tôi khuyên bạn nên nâng cấp để có thể sử dụng được những các chức năng có tính khả dụng cao hơn). Hãy làm theo hướng dẫn:

	$ git checkout -- benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#

Bạn có thể thấy những thay đổi mà bạn vừa mới phục hồi. Bạn cũng nên nhận ra rằng đây là một câu lệnh nguy hiểm: bất kỳ thay đổi nào được thực hiện trên tập tin đó không còn nữa - bạn vừa mới sao chép một tập tin khác thay thế nó. Đừng nên sử dụng lệnh này trừ khi bạn biết rõ ràng rằng bạn không cần đến tập tin đó. Nếu bạn chỉ không muốn thấy nó nữa, chúng ta sẽ tìm hiểu về phân nhánh và lưu trữ (stashing) trong chương sau; chúng là các phương pháp thay thế tốt hơn. 

Hãy nhớ là, bất cứ thứ gì đuợc commit vào Git luôn có thể phục hồi lại. Thậm chí cả các commit ở các nhánh đã bị xoá hoặc bị ghi đè bởi `--amend` (xem thêm về phục hồi dữ liệu ở *Chuơng 9*). Tuy nhiên, bất cứ thứ gì bị mất mà chưa đuợc commit thì không có cơ hội phục hồi lại.

## Làm Việc Từ Xa ##

Để có thể cùng cộng tác với các thành viên khác trên bất kỳ dự án sử dụng Git nào, bạn cần phải biết quản lý các kho chứa của bạn. Các kho chứa từ xa là các phiên bản của dự án của bạn, đuợc lưu trữ trên Internet hoặc một mạng luới nào đó. Bạn có thể có nhiều kho chứa khác nhau, thưòng thì bạn có thể chỉ-đọc hoặc đọc/ghi. Cộng tác với các thành viên khác liên quan đến quản lý những kho chứa này và việc kéo, đẩy dữ liệu từ chúng khi bạn cần chia sẻ công việc. Quản lý các kho chứa từ xa đòi hỏi phải biết cách thêm các kho chứa, xoá kho chứa không hợp lệ, quản lý nhiều nhánh khác nhau và xác định có theo dõi chúng hay không, và còn nhiều hơn thế nữa. Trong phần này chúng ta sẽ đề cập đến các kỹ năng quản lý từ xa này.

### Hiển Thị Máy Chủ ###

Để xem bạn đã cấu hình tới máy chủ từ xa nào, bạn có thể chạy lệnh `git remote`. Nó sẽ liệt kê tên ngắn gọn của mỗi máy chủ từ xa bạn đã chỉ định. 
Nếu bạn sao chép nó từ một kho chứa có sẵn, ít nhất bạn sẽ thấy *bản gốc* (origin) - tên mặc định mà Git đặt cho phiên bản trên máy chủ mà bạn đã sao chép từ đó:

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

Bạn cũng có thể sử dụng tham số `-v` để hiển thị địa chỉ mà Git đã lưu tên rút gọn đó:  

	$ git remote -v
	origin  git://github.com/schacon/ticgit.git (fetch)
	origin  git://github.com/schacon/ticgit.git (push)

Nếu bạn có nhiều hơn một máy chủ từ xa, lệnh này sẽ liệt kê hết tất cả. Ví dụ, kho chứa Grit sẽ hiện thị tuơng tự như sau:

	$ cd grit
	$ git remote -v
	bakkdoor  git://github.com/bakkdoor/grit.git
	cho45     git://github.com/cho45/grit.git
	defunkt   git://github.com/defunkt/grit.git
	koke      git://github.com/koke/grit.git
	origin    git@github.com:mojombo/grit.git

Điều này có nghĩa là bạn có thể "kéo" những đóng góp từ bất kỳ nguời dùng nào ở trên một cách dễ dàng. Nhưng chú ý là chỉ máy chủ nguyên bản từ xa (origin remote) là có địa chỉ SSH, do vậy nó là cái duy nhất mà tôi có thể đẩy lên (chúng ta sẽ tìm hiều tại sao trong *Chuơng 4*).

### Thêm Các Kho Chứa Từ Xa ###

Tôi đã đề cập và đưa một số ví dụ minh họa về việc thêm mới các kho chứa từ xa trong các phần trước, nhưng bây giờ chúng ta sẽ nói sâu hơn về nó. Để thêm mới một kho chứa Git từ xa như là một tên rút gọn để bạn có thể tham khảo dễ dàng, hãy chạy lệnh `git remote add [shortname] [url]`: 

	$ git remote
	origin
	$ git remote add pb git://github.com/paulboone/ticgit.git
	$ git remote -v
	origin	git://github.com/schacon/ticgit.git
	pb	git://github.com/paulboone/ticgit.git

Bây giờ bạn có thể sử dụng `pb` trong các câu lệnh, nó có tác dụng tương đương với một địa chỉ hoàn chỉnh. Ví dụ, nếu bạn muốn duyệt qua/truy cập tất cả thông tin mà Paul có mà bạn chưa có trong kho chứa, bạn có thể chạy lệnh `git fetch pb`: 

	$ git fetch pb
	remote: Counting objects: 58, done.
	remote: Compressing objects: 100% (41/41), done.
	remote: Total 44 (delta 24), reused 1 (delta 0)
	Unpacking objects: 100% (44/44), done.
	From git://github.com/paulboone/ticgit
	 * [new branch]      master     -> pb/master
	 * [new branch]      ticgit     -> pb/ticgit

Nhánh chính của Paul có thể truy cập cục bộ như là `pb/master` - bạn có thể tích hợp nó vào các nhánh của bạn, hoặc sử dụng nó như là một nhánh cục bộ ở thời điểm đó nếu như bạn muốn kiểm tra nó.  

### Truy Cập Và Kéo Về Từ Máy Chủ Trung Tâm ###

Như bạn vừa thấy, để lấy dữ liệu của các dự án từ xa về, bạn có thể chạy:

	$ git fetch [remote-name]

Lệnh này sẽ truy cập vào dự án từ xa đó và kéo xuống toàn bộ dữ liệu mà bạn chưa có trong đó cho bạn. Sau khi thực hiện xong bước này, bạn đã có các tham chiếu đến toàn bộ các nhánh của dự án từ xa đó, nơi mà bạn có thể tích hợp hoặc kiểm tra bất kỳ thời điểm nào. (Chúng ta sẽ đề cập chi tiết hơn về nhánh là gì và sử dụng chúng như thế nào ở *Chương 3*.)

Nếu bạn tạo bản sao từ một kho chứa nào đó khác, lệnh này sẽ tự động kho chứa từ xa đó vào dưới tên *origin*. Vì thế, `git fetch origin` sẽ truy xuất (fetch) bất kỳ thay đổi mới nào được đẩy lên trên máy chủ từ sau khi bạn sao chép (hoặc lần truy xuất cuối cùng). Hãy ghi nhớ một điều quan trọng là lệnh `fetch` kéo tất cả dữ liệu về kho chứa trên máy của bạn - nó không tự động tích hợp với bất kỳ thay đổi nào mà bạn đang thực hiện. Bạn phải tích hợp nó một cách thủ không vào kho chứa nội bộ khi đã sẵn sàng.

Nếu bạn có một nhánh được cài đặt để theo dõi một nhánh từ xa khác (xem phần tiếp theo và *Chương 3* để biết thêm chi tiết), bạn có thể sử dụng lệnh `git pull` để tự động truy xuất và sau đó tích hợp nhánh từ xa vào nhánh nội bộ. Đây có thể là cách dễ dàng và thoải mái hơn cho bạn; và mặc định thì, lệnh `git clone` tự động cài đặt nhánh chính nội bộ (local master branch) để theo dõi nhanh chính trên máy chủ từ xa (remote master branch) - nơi mà bạn sao chép về, (giả sử máy chủ từ xa có một nhánh chính). Thường thì khi chạy lệnh `git pull` nó sẽ truy xuất dữ liệu từ máy chủ trung tâm nơi lần đầu bạn sao chép và cố gắng tự động tích hợp chúng vào kho chứa hiện thời nơi bạn đang làm việc. 

### Đẩy Lên Máy Chủ Trung Tâm ###

Đến một thời điểm nào đó bạn muốn chia sẻ dự án của bạn, bạn phải đẩy ngược nó lên. Câu lệnh để thực hiện rất đơn giản: `git push [tên-máy-chủ] [tên-nhánh]`. Nếu bạn muốn đẩy nhánh master vào nhánh `orgin` trên máy chủ (nhắc lại, khi sao chép Git thường cài đặt/cấu hình mặc định các tên đó cho bạn), bạn có thể chạy lệnh sau để đẩy các công việc đã hoàn thành ngược lại máy chủ: 

	$ git push origin master

Lệnh này chỉ hoạt động nếu bạn sao chép từ một máy chủ mà trên đó bạn được cấp phép quyền ghi và chưa có ai khác đẩy dữ liệu lên tại thời điểm đó. Nếu bạn và ai khác cùng sao chép tại cùng một thời điểm; người kia đẩy ngược lên, sau đó bạn cũng muốn đẩy lên, thì hành động của bạn sẽ bị từ chối ngay tức khắc. Trước hết bạn phải thực hiện kéo các thay đổi mà người đó đã thực hiện và tích hợp/gộp nó vào của bạn, sau đó bạn mới được phép đẩy lên. Xem *Chương 3* để hiểu chi tiết hơn về làm thế nào để đẩy lên máy chủ trung tâm. 

### Kiểm Tra Một Máy Chủ Trung Tâm ###

Nếu bạn muốn xem chi tiết hơn các thông tin về một kho chứa trung tâm nào đó, bạn có thể sử dụng lệnh `git remote show [tên-trung-tâm]`. Nếu như bạn chạy lệnh này với một tên rút gọn, như là `origin`, bạn sẽ thấy tương tự như sau:

	$ git remote show origin
	* remote origin
	  URL: git://github.com/schacon/ticgit.git
	  Remote branch merged with 'git pull' while on branch master
	    master
	  Tracked remote branches
	    master
	    ticgit

Lệnh này liệt kê địa chỉ của kho chứa trung tâm cũng như thông tin các nhánh đang theo dõi. Nó cho bạn biết rằng nếu như bạn đang ở nhánh master và chạy lệnh git pull, nó sẽ tự động tích hợp nhánh này với nhánh trung tâm sau khi truy xuất toàn bộ các tham chiếu từ xa. Nó cũng liệt kê tất cả các tham chiếu từ xa mà nó đã kéo xuống đó.

Đây là một ví dụ đơn giản mà bạn thường xuyên gặp phải. Khi bạn sử dụng Git thường xuyên hơn, bạn sẽ thường thấy nhiều thông tin hơn từ lệnh `git remote show`:

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

Lệnh này hiển thị nhánh nào tự động được đẩy lên khi bạn chạy `git push` trên một nhánh nhất định. Nó cũng cho bạn thấy nhánh nào trên máy chủ trung tâm mà bạn chưa có, nhánh nào bạn có mà đã bị xóa trên máy chủ, và các nhánh nào sẽ tự động được tích hợp khi chạy lệnh `git pull`. 

### Xóa Và Đổi Tên Từ Xa ###

Nếu như bạn muốn đổi tên một tham chiếu, trong những phiên bản gần đây của Git bạn có thể chạy `git remote rename` để đổi tên rút gọn cho một kho chứa từ xa nào đó. Ví dụ, nếu bạn muốn đổi tên `pb` thành `paul`, bạn có thể dùng lệnh `git remote rename`:

	$ git remote rename pb paul
	$ git remote
	origin
	paul

Lệnh này đồng thời cũng sẽ thay đổi cả tên các nhánh trung tâm/từ xa của bạn. Các tham chiếu trước đây như `pb/master` sẽ đổi thành `paul/master`.

Nếu bạn muốn xóa một tham chiếu đi vì lý do nào đó - bạn đã chuyển máy chủ và không còn sử dụng một bản sao nhất định, hoặc có thể một người dùng nào đó không còn đóng góp vào dự án nữa - bạn có thể sử dụng `git remote rm`:

	$ git remote rm paul
	$ git remote
	origin

## Đánh Dấu ##

Cũng giống như đa số các hệ quản trị phiên bản khác, Git có khả năng đánh dấu (tag) các mốc quan trọng trong lịch sử của dự án. Nhìn chung, mọi người sử dụng chức năng này để đánh dấu các thời điểm phát hành (ví dụ như `v1.0`). Trong phần này bạn sẽ được học làm sao để liệt kê các tag hiện có, làm sao để tạo mới tag, và các loại tag khác nhau hiện có. 

### Liệt Kê Tag ###

Liệt kê các tag hiện có trong Git khá là đơn giản. Bạn chỉ cần gõ `git tag`:

	$ git tag
	v0.1
	v1.3

Lệnh này sẽ liệt kê các tag được sắp xếp theo thứ tự bảng chứ cái; thứ tự mà nó xuất hiện không thực sự quan trọng lắm.

Bạn cũng có thể tìm kiếm một tag sử dụng mẫu (pattern). Ví dụ, trong kho chứa mã nguồn của Git có chứa hơn 240 tag. Nếu như bạn chỉ quan tâm đến các tag thuộc dải 1.4.2, bạn có thể chạy lệnh sau:

	$ git tag -l 'v1.4.2.*'
	v1.4.2.1
	v1.4.2.2
	v1.4.2.3
	v1.4.2.4

### Thêm Tag Mới ###

Git sử dụng hai loại tag chính: lightweight và annotated. Một lightweigh tag (hạng nhẹ) giống như một nhánh mà không có sự thay đổi - nó chỉ trỏ đến một commit nào đó. Annotated (chú thích) tag, thì lại được lưu trữ như là những đối tượng đầy đủ trong cơ sở dữ liệu của Git. Chúng được băm; chứa tên người tag, địa chỉ email và ngày tháng; có thông điệp kèm theo; và có thể được ký và xác thực bằng GNU Privacy Guard (GPG). Thông thường, annotated tag được khuyến khích sử dụng hơn vì nó có chứa các thông tin trên; tuy nhiên nếu như bạn muốn một tag tạm thời hoặc vì một lý do nào đó bạn không muốn lưu trữ các thông tin trên, lightweight tag là sự lựa chọn hợp lý hơn.

### Annotated Tags ###

Tạo một tag chú thích (annnotated) trong Git rất đơn giản. Cách dễ nhất là sử dụng `-a` khi bạn chạy lệnh `tag`:

	$ git tag -a v1.4 -m 'my version 1.4'
	$ git tag
	v0.1
	v1.3
	v1.4

Tham số `-m` được sử dụng để truyền vào nội dung/thông điệp cho tag. Nếu như bạn không chỉ định nội dung cho một annotated tag, Git sẽ mở trình soạn thảo và yêu cầu bạn nhập nội dung vào đó.

Bạn có thể xem được thông tin của tag cùng với commit được tag bằng cách sử dụng lệnh `git show`:

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

Nó sẽ hiện thị thông tin người tag, ngày commit được tag, và thông báo chú thích trước khi hiện thông tin của commit.

### Signed Tags ###

Bạn cũng có thể ký các tag của bạn sử dụng GPG, giải sử bạn có một private key. Tất cả những gì bạn cần phải làm là sử dụng `-s` thay vì `-a`:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gee-mail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

Nếu bạn chạy lệnh `git show` trên tag đó, bạn có thể thấy được chữ ký GPG của bạn được đính kèm theo nó:

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

Một lát nữa, bạn sẽ được học làm sao để kiểm tra/xác minh (verify) các tag đã được ký.

### Lightweight Tags ###

Một cách khác để tag các commit là sử dụng lightweight tag. Cơ bản nó là mã băm của một commit được lưu lại vào trong một tập tin - ngoài ra không còn thông tin nào khác. Để tạo một lightweight tag, bạn không sử dụng `-a`, `-s`, hay `-m`:

	$ git tag v1.4-lw
	$ git tag
	v0.1
	v1.3
	v1.4
	v1.4-lw
	v1.5

Lần này, nếu bạn chạy `git show` trên tag đó, bạn sẽ không thấy các thông tin bổ sung nữa. Lệnh này chỉ show commit mà thôi:

	$ git show v1.4-lw
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

### Xác Thực Các Tag ###

Để xác thực một tag đã được ký, bạn sử dụng `git tag -v [tên-tag]`. Lệnh này sử dụng GPG để xác minh chữ ký. Bạn cần phải có public key của người ký để có thể thực hiện được điều này:

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

Nếu như bạn không có public key của người ký, bạn sẽ thấy thông báo như sau:

	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Can't check signature: public key not found
	error: could not verify the tag 'v1.4.2.1'

### Tag Muộn ###

Bạn cũng có thể tag các commit mà bạn đã thực hiện trước đó. Giả sử lịch sử commit của bạn giống như sau:

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

Bây giờ, giả sử bạn quên không tag dự án ở phiên bản `v1.2`, tương đương với commit "updated rakefile". Bạn vẫn có thể thêm tag vào lúc này. Để làm được điều bạn bạn cần chỉ định mã băm của commit (hoặc một phần của nó) ở cuối lệnh:

	$ git tag -a v1.2 -m 'version 1.2' 9fceb02

Bạn có thể thấy là commit đã được tag:

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

### Chia Sẻ Các Tag ###

Mặc định, lệnh `git push` không "truyền" (transfer) các tag lên máy chủ trung tâm. Bạn phải chỉ định một cách rõ ràng để có thể đẩy các tag lên máy chủ để sau khi đã tạo ra chúng. Quá trình này giống như chia sẽ cách nhánh trung tâm - bạn có thể chạy `git push origin [tên-tag]`.

	$ git push origin v1.5
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	* [new tag]         v1.5 -> v1.5

Nếu bạn có rất nhiều tag muốn đẩy lên cùng một lúc, bạn có thể sử dụng tham số `--tags` cho lệnh `git push`. Nó sẽ truyền tất cả các tag chưa được đồng bộ lên máy chủ.

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

Bây giờ, nếu ai đó sao chép hoặc kéo dữ liệu từ kho chứa của bạn, họ sẽ cũng sẽ có được tất cả các tag.

## Mẹo Nhỏ ##

Trước khi kết thúc chương cơ bản về Git này, có một vài mẹo nhỏ có thể giúp ích cho việc sử dụng Git của bạn trở nên đơn giản và dễ dàng hơn. Có nhiều người vẫn sử dụng Git mà không biết đến những điều này, chúng ta sẽ không đề cập đến chúng hoặc giả định bạn sẽ sử dụng nó khi kết thúc cuốn sách này; tuy nhiên bạn nên biết cách sử dụng chúng.

### Gợi Ý ###

Nếu bạn đang sử dụng Bash shell (có thể hiểu là cửa sổ dòng lệnh, nhưng cũng nên phân biệt với các loại shell khác: zsh, rc,...), Git cung cấp công cụ gợi ý các lệnh rất tốt mà bạn có thể bật nó lên. Nó có thể được tải về trực tiếp từ mã nguồn của Git tại https://github.com/git/git/blob/master/contrib/completion/git-completion.bash . Sao chép tập tin này vào thư mục home của bạn và thêm dòng sau vào tập tin `.bashrc`:

	source ~/git-completion.bash

Nếu như bạn muốn cài đặt công cụ gợi ý này cho tất cả người dùng trên máy tính của bạn, hãy sao chép đoạn mã này vào thư mục `/opt/local/etc/bash_completion.d` trên máy tính Mac hoặc thư mục `/etc/bash_completion.d/` trên các máy tính chạy Linux. Đây là thư mục chứa các đoạn mã mà Bash sẽ tự động chạy để có thể cung cấp chức năng gợi ý cho bạn. 

Nếu bạn đang sử dụng Git Bash trên Windows - mặc định khi cài đặt Git trên Windows sử dụng msysGit, chức năng gợi ý đã được cấu hình sẵn.

Ấn phím Tab khi bạn gõ một câu lệnh Git, nó sẽ trả về một tập hợp các gợi ý cho bạn chọn:

	$ git co<tab><tab>
	commit config

Trong trường hợp này, gõ `git co` và sau đó gõ Tab hai lần sẽ cho bạn gợi ý commit và config. Gõ thêm `m<tab>` để có được lệnh `git commit` tự động.

Nó cũng hoạt động được với các lựa chọn/tham số, chắc chắn rất hữu ích. Ví dụ như nếu bạn đang chạy lệnh `git log` và không nhớ một trong các lựa chọn, bạn có thể bắt đầu gõ và ấn Tab để xem lệnh nào thỏa mãn:

	$ git log --s<tab>
	--shortstat  --since=  --src-prefix=  --stat   --summary

Đó là một mẹo rất hay và đôi khi có thể tiết kiệm thời gian đọc tài liệu cho bạn.

### Bí Danh Trong Git ###

Git không thể phỏng đoán ra câu lệnh nếu như bạn chỉ gõ một phần của câu lệnh đó. Nếu bạn không muốn gõ toàn bộ từng câu lệnh, bạn có thể dễ dàng cài đặt một bí danh (alias) cho mỗi lệnh sử dụng `git config`. Sau đây là một số ví dụ có thể hữu ích cho bạn:

	$ git config --global alias.co checkout
	$ git config --global alias.br branch
	$ git config --global alias.ci commit
	$ git config --global alias.st status

Có nghĩa là, ví dụ, thay vì phải gõ `git commit`, bạn chỉ cần gõ `git ci`. Khi bạn bắt đầu sử dụng Git, chắc chắn bạn sẽ sử dụng cả các câu lệnh khác một cách thường xuyên; trong trường hợp này, đừng ngần ngại tạo thêm các bí danh mới. 

Kỹ thuật này cũng có thể rất hữu ích trong việc tạo mới các câu lệnh mà bạn cho rằng sự tồn tại của chúng là cần thiết. Ví dụ như, để làm chính xác các vấn đề liên quan đến tính khả dụng mà bạn gặp phải khi bỏ tổ chức (unstaging) một tập tin, bạn có thể tự tạo bí danh riêng cho việc này:

	$ git config --global alias.unstage 'reset HEAD --'

Lệnh này tương đương với hai câu lệnh sau:

	$ git unstage fileA
	$ git reset HEAD fileA

Theo cách này thì nhìn có vẻ rõ ràng hơn. Một bí danh phổ biến khác là lệnh `last`, như sau:

	$ git config --global alias.last 'log -1 HEAD'

Với cách này, bạn có thể xem được commit cuối cùng một cách dễ dàng:

	$ git last
	commit 66938dae3329c7aebe598c2246a8e6af90d04646
	Author: Josh Goebel <dreamer3@example.com>
	Date:   Tue Aug 26 19:48:51 2008 +0800

	    test for current head

	    Signed-off-by: Scott Chacon <schacon@example.com>

Bạn cũng có thể tự nhận thấy rằng, Git thay thế lệnh mới với bất cứ tên gì bạn đặt cho nó. Tuy nhiên, cũng có thể bạn muốn chạy một lệnh bên ngoài, hơn là bản thân các lệnh trong Git. Trong trường hợp này, bạn bắt đầu lệnh đó với ký tự `!`. Nó khá hữu ích trong trường hợp bạn viết công cụ riêng của bạn để làm việc với Git. Một ví dụ minh họa là việc tạo bí danh cho `git visual` để chạy `gitk`: 

	$ git config --global alias.visual '!gitk'

## Tổng Kết ##

Đến bây giờ thì bạn đã có thể thực hiện các thao tác cơ bản của Git một cách cục bộ - tạo mới, sao chép kho chứa, tạo thay đổi, tổ chức và commit các thay đổi đó, và xem lịch sử của các thay đổi đã được thực hiện trên kho chứa. Trong phần tiếp theo, chúng ta sẽ đề cập tới chức năng tuyệt vời của Git: mô hình phân nhánh.