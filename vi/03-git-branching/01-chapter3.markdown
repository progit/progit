# Phân Nhánh Trong Git #

Hầu hết mỗi hệ quản trị phiên bản (VCS) đều hỗ trợ một dạng của phân nhánh. Phân nhánh có nghĩa là bạn phân tách ra từ luồng phát triển chính và tiếp tục làm việc mà không sợ làm ảnh hưởng đến luồng chính. Trong nhiều VCS, đây dường như là một quá trình đòi hỏi nhiều công sức và sự cố gắng, thường thì bạn tạo một bản sao mới từ thư mục chứa mã nguồn, nó có thể mất khá nhiều thời gian trên các dự án lớn.

Nhiều người nhắc đến mô hình phân nhánh của Git như là "chức năng hủy diệt", và chính nó làm cho Git trở nên khác biệt trong cộng đồng VCS. Tại sao nó lại đặc biệt đến vậy? Cách Git phân nhánh "nhẹ" một cách đáng kinh ngạc, các hoạt động tạo nhánh xảy ra gần như ngay lập tức và việc di chuyển đi lại giữa các nhánh cũng thường rất nhanh. Không giống các VCSs khác, Git khuyến khích sử dụng rẽ nhánh và tích hợp thường xuyên cho workflow, thậm chí nhiều lần trong một ngày. Hiểu và thành thạo tính năng này cung cấp cho bạn một công cụ mạnh mẽ, độc đáo và có thể thay đổi được cách bạn thường phát triển phần mềm.

## Nhánh Là Gì? ##

Để có thể thực sử hiểu được cách phân nhánh của Git, chúng ta cần nhìn và xem xét lại cách Git lưu trữ dữ liệu. Như bạn đã biết từ Chương 1, Git không lưu trữ dữ liệu dưới dạng một chuỗi các thay đổi hoặc delta, mà thay vào đó là một chuỗi các ảnh (snapshot).

Khi bạn commit, Git lưu trữ đối tượng commit mà có chứa một con trỏ tới ảnh của nội dung bạn đã tổ chức (stage), tác giả và thông điệp, hay 0 hoặc nhiều con trỏ khác trỏ tới một hoặc nhiều commit cha trực tiếp của commit đó: commit đầu tiên không có cha, commit bình thường có một cha, và nhiều cha cho commit là kết quả được tích hợp lại từ hai hoặc nhiều nhánh.

Để hình dung ra vấn đề này, hãy giả sử bạn có một thư mục chứa ba tập tin, và bạn tổ chức tất cả chúng để commit. Quá trình tổ chức các tập tin sẽ thực hiện băm từng tập (sử dụng mã SHA-1 được đề cập ở Chương 1), lưu trữ phiên bản đó của tập tin trong kho chứa Git (Git xem chúng như là các blob), và thêm mã băm đó vào khu vực tổ chức:

	$ git add README test.rb LICENSE
	$ git commit -m 'initial commit of my project'

Lệnh `git commit` khi chạy sẽ băm tất cả các thư mục trong dự án và lưu chúng lại dưới dạng đối tượng `tree`. Sau đó Git tạo một đối tượng `commit` có chứa các thông tin mô tả (metadata) và một con trỏ trỏ tới đối tương `tree` gốc của dự án vì thế nó có thể tạo lại ảnh đó khi cần thiết.

Kho chứa Git của bạn bây giờ có chứa năm đối tượng: một blob cho nội dung của từng tập tin, một "cây" liệt kê nội dung của thư mục và chỉ rõ tên tập tin nào được lưu trữ trong blob nào, và một commit có con trỏ trỏ tới cây gốc và tất cả các thông tin mô tả commit. Về mặt lý thuyết, dữ liệu trong kho chứa Git có hình dạng như trong Hình 3-1. 

Insert 18333fig0301.png
Hình 3-1. Dữ liệu trong kho chứa với một commit.

Nếu bạn thực hiện một số thay đổi và commit lại thì commit tiếp theo sẽ lưu một con trỏ tới commit ngay trước nó. Sau hai commit, lịch sử của dự án sẽ tương tự như trong Hình 3-2.

Insert 18333fig0302.png
Hình 3-2. Các đối tượng dữ liệu của Git trong kho chứa nhiều commit. 

Một nhánh trong Git đơn thuần là một con trỏ có khả năng di chuyển được, trỏ đến một trong những commit này. Tên nhánh mặc định của Git là master. Như trong những lần commit đầu tiên, chúng đều được trỏ tới nhánh `master`. Và mỗi lần bạn thực hiện commit, nó sẽ được tự động ghi vào theo hướng tiến lên. (move forward)

Insert 18333fig0303.png
Hình 3-3. Nhánh trỏ tới dữ liệu commit.

Chuyện gì xảy ra nếu bạn tạo một nhánh mới? Làm như vậy sẽ tạo ra một con trỏ mới cho phép bạn di chuyển vòng quanh. Ví dụ bạn tạo một nhánh mới có tên testing. Việc này được thực hiện bằng lệnh `git branch`:

	$ git branch testing

Nó sẽ tạo một con trỏ mới, cùng trỏ tới commit hiện tại (mới nhất) của bạn (xem Hình 3-4).

Insert 18333fig0304.png
Hình 304. Nhiều nhánh cùng trỏ vào dữ liệu commit.

Vậy làm sao Git có thể biết được rằng bạn đang làm việc trên nhánh nào? Git giữ một con trỏ đặc biệt có tên HEAD. Lưu ý khái niệm về HEAD ở đây khác biệt hoàn toàn với các VCS khác mà bạn có thể đã sử dụng qua, như là Subversion hoặc CVS. Trong Git, đây là một con trỏ tới nhánh nội bộ mà bạn đang làm việc. Trong trường hợp này, bạn vẫn đang trên nhánh master. Lệnh git branch chỉ tạo một nhánh mới chứ không tự chuyển sang nhánh đó cho bạn (xem Hình 3-5).

Insert 18333fig0305.png
Hình 3-5. Tập tin HEAD trỏ tới nhánh mà bạn đang làm việc.

Để chuyển sang một nhánh đang tồn tại, bạn sử dụng lệnh `git checkout`. Hãy cùng chuyển sang nhánh testing mới:

	$ git checkout testing

Lệnh này sẽ chuyển con trỏ HEAD sang nhánh testing (xem Hình 3-6).

Insert 18333fig0306.png
Hình 3-6. HEAD trỏ tới nhánh khác khi bạn chuyển nhánh.

Ý nghĩa của việc này là gì? Hãy cùng thực hiện một commit khác:

	$ vim test.rb
	$ git commit -a -m 'made a change'

Hình 3-7 minh họa kết quả.

Insert 18333fig0307.png
Hình 3-7. Nhánh mà HEAD trỏ tới di chuyển tiến lên phía trước theo từng commit.

Điều này thật thú vị, bởi vì nhánh testing của bạn bây giờ đã tiển hẳn lên phía trước, nhưng nhánh `master` thì vẫn trỏ tới commit ở thời điểm khi bạn chạy lệnh `git checkout` để chuyển nhánh. Hãy cùng chuyển trở lại nhánh `master`:

	$ git checkout master

Hình 3-8 hiển thị kết quả.

Insert 18333fig0308.png
Hình 3-8. HEAD chuyển sang nhánh khác khi checkout.

Lệnh này vừa thực hiện hai việc. Nó di chuyển lại con trỏ về nhánh `master`, và sau đó nó phục hồi lại các tập tin trong thư mục làm việc của bạn trở lại snapshot mà `master` trỏ tới. Điều này cũng có nghĩa là các thay đổi bạn thực hiện từ thời điểm này trở đi sẽ tách ra so với phiên bản cũ hơn của dự án. Nó "tua lại" các thay đổi cần thiết mà bạn đã thực hiện trên nhánh `testing` một cách tạm thời để bạn có thể đi theo một hướng khác.

Hãy cùng tạo một vài thay đổi và commit lại một lần nữa:

	$ vim test.rb
	$ git commit -a -m 'made other changes'

Bây giờ lịch sử của dự án đã bị tách ra (xem Hình 3-9). Bạn tạo mới và chuyển sang một nhánh, thực hiện một số thay đổi trên đó, và rồi chuyển ngược lại nhánh chính và tạo thêm các thay đổi khác. Cả hai sự thay đổi này bị cô lập với nhau ở hai nhánh riêng biệt: bạn có thể chuyển đi hoặc lại giữa cách nhánh và tích hợp chúng lại với nhau khi cần thiết. Và bạn đã thực hiện những việc trên một cách đơn giản với lệnh `branch` và `checkout`.

Insert 18333fig0309.png
Hình 3-9. Lịch sử các nhánh đã bị phân tách.

Bởi vì một nhánh trong Git thực tế là một tập tin đơn giản chứa một mã băm SHA-1 có độ dài 40 ký tự của commit mà nó trỏ tới, chính vì thế tạo mới cũng như hủy các nhánh đi rất đơn giản. Tạo mới một nhánh nhanh tương đương với việc ghi 41 bytes vào một tập tin (40 ký tự cộng thêm một dòng mới).

Điều này đối lập rất lớn với cách mà các VCS khác phân nhánh, chính là copy toàn bộ các tập tin hiện có của dự án sang một thư mục thứ hai. Việc này có thể mất khoảng vài giây, thậm chí vài phút, phụ thuộc vào dung lượng của dự án, trong khi đó trong Git thì quá trình này luôn xảy ra ngay lập tức. Thêm một lý do nữa là, chúng ta đang lưu trữ cha của các commit, nên việc tìm kiếm gốc/cơ sở để tích hợp lại được thực hiện một cách tự động và rất dễ dàng. Những tính năng này giúp khuyến khích các lập trình viên tạo và sử dụng nhánh thường xuyên hơn.

Hãy cùng xem tại sao bạn nên làm như vậy.

## Cơ Bản Về Phân Nhánh và Tích Hợp ##

Hãy cùng xem qua một ví dụ đơn giản về phân nhánh và tích hợp với một quy trình làm việc mà có thể bạn sẽ sử dụng nó vào thực tế. Bạn sẽ thực hiện theo các bước sau: 

1. Làm việc trên một web site
2. Tạo nhánh cho một câu chuyện mới mà bạn đang làm.
3. Làm việc trên nhánh đó.

Đến lúc này, bạn nhận được thông báo rằng có một vấn đề nghiêm trọng cần được khắc phục ngay. Bạn sẽ làm theo các bước sau:

1. Chuyển lại về nhánh sản xuất (production)
2. Tạo mới một nhánh khác để khắc phục lỗi
3. Sau khi đã kiểm tra ổn định, tích hợp nhánh đó lại và đưa vào hoạt động.
4. Chuyển ngược lại với câu chuyện của bạn và tiếp tục làm việc.

### Cơ Bản về Phân Nhánh ###

Đầu tiên, giả sử bạn đang làm việc trên một dự án đã có một số commit từ trước (xem Hình 3-10).

Insert 18333fig0310.png
Hình 3-10. Một lịch sử commit ngắn và đơn giản.

Bạn quyết định sẽ giải quyết vấn đề số #53 sử dụng bất kỳ hệ thống giám sát vấn đề (issue-tracking) nào mà công ty bạn đang dùng. Để cho rõ ràng, Git không cung cấp kèm bất kỳ hệ thống giám sát vấn đề nào; nhưng bởi vì vấn đề số #53 là cái mà bạn sẽ tập trung vào nên bạn sẽ tạo một nhánh mới để làm việc trên đó. Để tạo một nhánh và chuyển sang nhánh đó đồng thời, bạn có thể chạy lệnh `git checkout` với tham số `-b`:

	$ git checkout -b iss53
	Switched to a new branch "iss53"

Đây là cách sử dụng vắn tắt của:

	$ git branch iss53
	$ git checkout iss53

Hình 3-11 minh họa kết quả.

Insert 18333fig0311.png
Hình 3-11. Tạo con trỏ nhánh mới.

Bạn làm việc trên đó và sau đó thực hiện một số commit. Làm như vậy sẽ khiến nhánh `iss53` di chuyển tiến lên, vì bạn đã checkout nó (hay, HEAD đang trỏ đến nó; xem Hình 3-12):

	$ vim index.html
	$ git commit -a -m 'added a new footer [issue 53]'

Insert 18333fig0312.png
Hình 3-12. Nhánh iss53 đã di chuyển tiến lên cùng với thay đổi của bạn.

Bây giờ bạn nhận được thông báo rằng có một vấn đề với trang web, và bạn cần khắc phục nó ngay lập tức. Với Git, bạn không phải triển khai bản vá lỗi cùng với các thay đổi bạn đã thực hiện trên nhánh `iss53`, và bạn không phải tốn quá nhiều công sức để khôi phục lại các thay đổi đó trước khi áp dụng bản vá vào sản xuất. Tất cả những gì bạn cần phải làm là chuyển lại nhánh master.

Tuy nhiên, trước khi làm điều này, bạn nên lưu ý rằng nếu thư mục làm việc hoặc khu vực tổ chức có chứa các thay đổi chưa được commit mà xung đột với nhánh bạn đang làm việc, Git sẽ không cho phép bạn chuyển nhánh. Tốt nhất là bạn nên ở trạng thái làm việc "sạch" (đã commit hết) trước khi chuyển nhánh. Có các cách khác để khắc phục vấn đề này (đó là stashing và sửa commit) mà chúng ta sẽ bàn tới sau. Hiện tại, bạn đã commit hết các thay đổi, vì vậy bạn có thể chuyển lại nhánh master:

	$ git checkout master
	Switched to branch "master"

Tại thời điểm này, thư mục làm việc của dự án giống hệt như trước khi bạn bắt đầu giải quyết vấn đề #53, và bạn có thể tập trung vào việc sửa lỗi. Điểm quan trọng cần ghi nhớ: Git khôi phục lại thư mục làm việc của bạn để nó giống như snapshot của commit mà nhánh bạn đang làm việc trỏ tới. Nó thêm, xóa, và sửa các tập tin một cách tự động để đảm bảo rằng thư mục làm việc của bạn giống như lần commit cuối cùng.

Tiếp theo, bạn có mỗi lỗi cần phải sửa. Hãy tạo mỗi nhánh để làm việc này cho tới khi nó được hoàn thành (xem Hình 3-13):

	$ git checkout -b hotfix
	Switched to a new branch "hotfix"
	$ vim index.html
	$ git commit -a -m 'fixed the broken email address'
	[hotfix]: created 3a0874c: "fixed the broken email address"
	 1 files changed, 0 insertions(+), 1 deletions(-)

Insert 18333fig0313.png
Hình 3-13. Nhánh hotfix dựa trên nhánh master.

Bạn có thể chạy để kiểm tra, để chắc chắn rằng bản vá lỗi hoạt động đúng theo ý bạn muốn, và sau đó tích hợp nó lại nhánh chính để triển khai. Bạn có thể làm sử dụng lệnh `git merge` để làm việc này:

	$ git checkout master
	$ git merge hotfix
	Updating f42c576..3a0874c
	Fast forward
	 README |    1 -
	 1 files changed, 0 insertions(+), 1 deletions(-)

Bạn sẽ nhận thấy rằng cụm từ "Fast forward" trong lần tích hợp đó. Bởi vì commit được trở tới bởi nhánh mà bạn tích hợp vào lại trực tiếp là upstream của commit hiện tại, vì vậy Git di chuyển con trỏ về phía trước. Nói cách khác, khi bạn cố gắng tích hợp một commit với một commit khác mà có thể truy cập được từ lịch sử của commit trước thì Git sẽ đơn giản hóa bằng cách di chuyển con trỏ về phía trước vì không có sự rẽ nhánh nào để tích hợp - đây được gọi là "fast forward".

Thay đổi của bạn bây giờ ở trong snapshot của commit được trỏ tới bởi nhánh `master`, và bạn có thể triển khai thay đổi này (xem Hình 3-14).

Insert 18333fig0314.png
Hình 3-14. Nhánh master và nhánh hotfix cùng trỏ tới một điểm sau khi tích hợp.

Sau khi triển khai xong bản vá lỗi quan trọng đó, bạn đã sẵn sàng để quay lại với công việc bị gián đoạn trước đó. Tuy nhiên, việc đầu tiên cần làm là xóa nhánh `hotfix` đi, vì bạn không còn cần tới nó nữa - nhánh `master` trỏ tới cùng một điểm. Bạn có thể xóa nó đi bằng cách sử dụng tham số `-d` cho lệnh `git branch`:

	$ git branch -d hotfix
	Deleted branch hotfix (3a0874c).

Bây giờ bạn đã có thể chuyển lại nhánh mà bạn đang làm việc trước đó về vấn đề #53 và tiếp tục làm việc (xem Hình 3-15):

	$ git checkout iss53
	Switched to branch "iss53"
	$ vim index.html
	$ git commit -a -m 'finished the new footer [issue 53]'
	[iss53]: created ad82d7a: "finished the new footer [issue 53]"
	 1 files changed, 1 insertions(+), 0 deletions(-)

Insert 18333fig0315.png
Hình 3-15. Nhánh iss53 có thể di chuyển về phía trước một cách độc lập.

Điều đáng chú ý ở đây là những công việc bạn đã thực hiện ở nhánh `hotfix` không bao gồm trong nhánh `iss53`. Nếu bạn muốn đưa chúng vào, bạn có thể tích hợp nhánh `master` vào nhánh `iss53` bằng cách chạy lệnh `git merge master`, hoặc bạn có thể chờ đợi đến khi bạn quyết định tích hợp nhánh `iss53` ngược trở lại nhánh `master` về sau.

### Cơ Bản Về Tích Hợp ###

Giả sử bạn đã quyết định việc giải quyết vấn đề #53 đã hoàn thành và sẵn sàng để tích hợp vào nhánh `master`. Để làm được điều này, bạn sẽ tích hợp nhánh `iss53` lại, giống như bạn đã làm với nhánh `hotfix` trước đó. Tất cả những gì cần phải làm là chuyển sang (check out) nhánh mà bạn muốn được tích hợp vào và chạy lệnh `git merge`:

	$ git checkout master
	$ git merge iss53
	Merge made by recursive.
	 README |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Lần này có hơi khác so với lần tích hợp `hotfix` trước đó. Trong trường hợp này, lịch sử phát triển của bạn đã bị phân nhánh tại một thời điểm nào đó trước kia. Bởi vì commit trên nhánh mà bạn đang làm việc (master) không phải là "cha" trực tiếp của nhánh mà bạn đang tích hợp vào, Git phải làm một số việc. Trường hợp này, Git thực hiện một tích hợp 3-chiều, sử dụng hai snapshot được trỏ tới bởi các đầu mút của nhánh và "cha chung" của cả hai. Hình 3-16 minh họa ba snapshot mà Git sử dụng để thực hiện phép tích hợp trong trường hợp này.

Insert 18333fig0316.png
Hình 3-16. Git tự động nhận dạng "cha chung" phù hợp nhất để tích hợp các nhánh lại với nhau.

Thay vì việc chỉ di chuyển con trỏ về phía trước, Git tạo một snapshot mới - được hợp thành từ lần tích hợp 3-chiều này và cũng tự tạo một commit mới trỏ tới nó (xem Hình 3-17). Nó được biết tới như là "commit tích hợp" (merge commit) và nó đặc biệt vì có nhiều hơn một cha.

Đáng để chỉ ra rằng Git tự quyết định cha chung phù hợp nhất để sử dụng làm cơ sở cho việc tích hợp; điểm này khác với CVS hay Subversion (các phiên bản trước 1.5), khi mà các lập trình viên phải tự xác định cơ sở phù hợp nhất để tích hợp. Điều này khiến cho việc tích hợp trong Git trở nên dễ dàng hơn rất nhiều so với các hệ quản trị phiên bản khác.

Insert 18333fig0317.png
Hình 3-17. Git tự động tạo đối tượng commit mới chứa đựng các thay đổi đã tích hợp.

Bây giờ công việc của bạn đã được tích hợp lại với nhau, bạn không cần thiết phải giữ lại nhánh `iss53` nữa. Bạn có thể xóa nó đi và sau đó tự xóa vấn đề này trong hệ thống quản lý vấn đề của bạn:

	$ git branch -d iss53

### Mâu Thuẫn Khi Tích Hợp ###

Đôi khi, quá trình này không diễn ra một cách suôn sẻ. Nếu bạn thay đổi cùng một nội dung của cùng một tập tin ở hai nhánh khác nhau mà bạn đang muốn tích hợp vào, Git không thể tích hợp chúng một cách gọn gàng. Nếu bản vá lỗi cho vấn đề #53 cùng thay đổi một phần của một tập tin giống như nhánh `hotfix`, bạn sẽ nhận được một sự xung đột khi tiến hành tích hợp như sau:

	$ git merge iss53
	Auto-merging index.html
	CONFLICT (content): Merge conflict in index.html
	Automatic merge failed; fix conflicts and then commit the result.

Git chưa tự tạo commit tích hợp mới. Nó tạm dừng quá trình này lại cho đến khi bạn giải quyết xong xung đột. Nếu bạn muốn xem tập tin nào chưa được tích hợp tại bất kỳ thời điểm nào sau khi xung đột xảy ra, bạn có thể sử dụng lệnh `git status`:

	[master*]$ git status
	index.html: needs merge
	# On branch master
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#	unmerged:   index.html
	#

Với bất kỳ xung đột nào xảy ra mà chưa được giải quyết, chúng sẽ được liệt kê là unmerged (chưa được tích hợp). Git thêm các dấu hiệu chuẩn riêng để giải quyết xung đột vào các tập tin có xảy ra xung đột, vì thế bạn có thể mở và giải quyết các xung đột đó một cách thủ công. Tập tin của bạn sẽ chứa một phần tương tự như sau:

	<<<<<<< HEAD:index.html
	<div id="footer">contact : email.support@github.com</div>
	=======
	<div id="footer">
	  please contact us at support@github.com
	</div>
	>>>>>>> iss53:index.html

Điều này có nghĩa là phiên bản trong HEAD (nhánh master, vì nó là nhánh bạn đã check out khi chạy lệnh merge) là phần mới nhất của đoạn đó (mọi thứ phía trên `=======`), trong khi phiên bản ở nhánh `iss53` chính là phần phía dưới. Để giải quyết vấn đề này, bạn phải chọn một trong hai phần hoặc tự gộp nội dung của chúng lại. Ví dụ, có thể bạn giải quyết xung đột này bằng cách thay thế toàn bộ đoạn code đó bằng:

	<div id="footer">
	please contact us at email.support@github.com
	</div>

Cách giải quyết này có chứa nội dung của cả hai phần, và tôi đã xóa bỏ hoàn toàn các dòng `<<<<<<<`, `=======`, và `>>>>>>>`. Sau khi giải quyết xong tất cả các phần này trong các tập tin bị xung đột, chạy lệnh `git add` cho từng tập tin để đánh dấu là chúng đã được giải quyết. Tổ chức chúng cùng đồng nghĩa với việc đánh dấu là đã được giải quyết trong Git. Nếu bạn muốn sử dụng một công cụ có giao diện đồ họa để giải quyết những vấn đề này, bạn có thể sử dụng `git mergetool`, Git sẽ tự động mở chương trình tương ứng và trợ giúp bạn giải quyết các xung đột: 

	$ git mergetool
	merge tool candidates: kdiff3 tkdiff xxdiff meld gvimdiff opendiff emerge vimdiff
	Merging the files: index.html

	Normal merge conflict for 'index.html':
	  {local}: modified
	  {remote}: modified
	Hit return to start merge resolution tool (opendiff):

Nếu bạn muốn sử dụng một công cụ tích hợp khác thay vì chương trình mặc định (Git sử dụng `opendiff` cho tôi trong trường hợp này vì tôi đang sử dụng một máy tính Mac), bạn có thể xem danh sách các chương trình tương thích bằng cách chạy lệnh "merge tool candidates". Gõ tên chương trình bạn muốn sử dung. Trong Chương 7, chúng ta sẽ cùng bàn luận về việc làm thế nào để thay đổi giá trị mặc định này.

Sau khi thoát khỏi chương trình hỗ trợ tích hợp, Git sẽ hỏi bạn nếu tích hợp thành công. Nếu bạn trả lời đúng, nó sẽ đánh dấu tập tin đó là đã giải quyết cho bạn.

Bạn có thể chạy `git status` lại một lần nữa để xác thực rằng tất cả các xung đột đã được giải quyết:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	modified:   index.html
	#

Nếu bạn hài lòng với điều này, và chắc chắn rằng tất cả các xung đột đã được tổ chức, bạn có thể chạy lệnh `git commit` để hoàn thành commit tích hợp. Thông điệp mặc định của commit có dạng như sau:

	Merge branch 'iss53'

	Conflicts:
	  index.html
	#
	# It looks like you may be committing a MERGE.
	# If this is not correct, please remove the file
	# .git/MERGE_HEAD
	# and try again.
	#

Bạn có sửa lại nội dung này với các chi tiết về việc bạn đã giải quyết như thế nào nếu bạn cho rằng các thông tin đó sẽ có ích cho các thành viên khác sau này - tại sao bạn lại làm như vậy, nếu như chúng còn chưa rõ ràng.

## Quản Lý Các Nhánh ##

Bạn đã tạo mới, tích hợp, và xóa một số nhánh, bây giờ hãy cùng xem một số công cụ giúp việc quản lý nhánh trở nên dễ dàng hơn khi tần suất sử dụng nhánh của bạn ngày càng nhiều.

Lệnh `git branch` thực hiện nhiều việc hơn là chỉ tạo và xóa nhánh. Nếu bạn chạy nó không có tham số, bạn sẽ có danh sách của tất cả các nhánh hiện tại:

	$ git branch
	  iss53
	* master
	  testing

Lưu ý về  ký tự `*` đứng trước nhánh `master`: nó chỉ cho bạn thấy nhánh mà bạn đang làm việc (Checkout). Có nghĩa là nếu bạn commit ở thời điểm hiện tại, thì nhánh `master` sẽ di chuyển tiến lên phía trước với các thay đổi mới. Để xem commit mới nhất trên từng nhánh, bạn có thể chạy lệnh `git branch -v`:

	$ git branch -v
	  iss53   93b412c fix javascript issue
	* master  7a98805 Merge branch 'iss53'
	  testing 782fd34 add scott to the author list in the readmes

Một lựa chọn hữu ích khác để tìm ra trạng thái của các nhánh là lọc qua các nhánh bạn đã hoặc chưa tích hợp vào nhánh hiện tại. Các lựa chọn để sử dụng cho mục đích này gồm `--merged` và `--no-merged`. Để biết nhánh nào đã được tích hợp vào nhánh hiện tại, bạn có thể sử dụng `git branch --merged`:

	$ git branch --merged
	  iss53
	* master

Bởi vì bạn đã tích hợp nhánh `iss53` vào trước đó, bạn sẽ thấy nó ở trong danh sách này. Cách nhánh trong danh sách không có dấu `*` ở phía trước thường an toàn để xóa bằng cách sử dụng `git branch -d`; bạn đã tích hợp các thay đổi trong đó vào một nhánh khác, vì thế bạn sẽ không hề bị mất bất cứ dữ liệu gì.

Để xem cách nhánh chứa các công việc/thay đổi chưa được tích hợp vào, bạn có thể chạy lệnh `git branch --no-merged`:

	$ git branch --no-merged
	  testing

Lệnh này lại hiện thị các nhánh khác. Bởi vì chúng bao gồm các công việc mà bạn chưa tích hợp vào, xóa nó đi bằng lệnh `git branch -d` sẽ báo lỗi:

	$ git branch -d testing
	error: The branch 'testing' is not an ancestor of your current HEAD.
	If you are sure you want to delete it, run 'git branch -D testing'.

Nếu bạn thực sự muốn xóa nó đi và chấp nhận mất các thay đổi, bạn có thể bắt buộc bằng cách sử dụng tham số `-D`, như hướng dẫn trong thông báo trên.

## Quy Trình Làm Việc Phân Nhánh ##

Bây giờ bạn đã có được các kiến thức cơ bản về phân nhánh và tích hợp, vậy bạn có thể hay nên làm gì với chúng. Trong phần này, chúng ta sẽ đề cập tới một số quy trình làm việc phổ biến áp dụng phân nhánh, vì thế bạn có thể tự quyết định có áp dụng chúng vào quy trình làm việc riêng của bạn hay không.

### Nhánh Lâu Đời ###

Bởi vì Git sử dụng tích hợp 3 chiều đơn giản, nên tích hợp từ nhánh này vào nhánh khác nhiều lần trong cùng một giai đoạn thường dễ dàng. Có nghĩa là bạn có thể có nhiều nhánh luôn mở và sử dụng chúng cho các giai đoạn phát triển khác nhau; bạn có thể tích hợp từ một số nhánh nào đó vào các nhánh khác một cách thường xuyên.

Nhiều lập trình viên Git sử dụng quy trình làm việc dựa theo phương pháp này, chẳng hạn như chỉ chứa mã nguồn ổn định hoàn toàn ở nhánh `master` - hầu như là mã nguồn đã phát hành hoặc chuẩn bị phát hành. Họ có một nhánh song song khác có tên develop hoặc next, nơi mà họ làm việc hoặc sử dụng để kiểm tra độ ổn định - nó không nhất thiết luôn luôn phải ổn định, tuy nhiên mỗi khi nó đạt được trạng thái ổn định, nó sẽ được tích hợp vào nhánh `master`. Chúng được sử dụng với vai trò là các nhánh chủ đề (topic branch) - các nhánh có vòng đời ngắn, giống như nhánh `iss53` trước đó - để đảm bảo chúng qua được các bài kiểm tra và không gây ra lỗi.

Trong thực tế, chúng ta đang nói về các con trỏ di chuyển dọc theo đường thẳng của các commit. Các nhánh ổn định hơn thường ở phía cuối của đường thẳng, còn các nhánh đang phát triển thường ở phía đầu hàng (xem Hình 3-18).

Insert 18333fig0318.png
Hình 3-18. Nhánh ổn định hơn thường ở phía cuối hàng trong lịch sử commit.

Sẽ dễ hình dung hơn khi nghĩ về chúng như là các xi-lô, nơi mà tập hợp các commit cô đặc dần thành một xi-lô ổn định hơn khi đã được kiểm tra đầy đủ (xem Hình 3-19).

Insert 18333fig0319.png
Hình 3-19. Có lẽ sẽ dễ hiểu hơn khi coi các nhánh là các xi-lô.

Bạn có thể tiếp tục làm theo cách này cho nhiều tầng ổn định khác nhau. Nhiều dự án lớn có nhánh `proposed` hoặc `pu` (proposed updates) được sử dụng cho các nhánh chưa đủ điều kiện để tích hợp vào `next` hoặc `master`. Ý tưởng ở đây là, các nhánh ở các tầng khác nhau của sự ổn định; khi chúng đạt tới một mức ổn định hơn nào đó, chúng sẽ được tích hợp vào tầng trên nó. 
Tóm lại, có nhiều nhánh tồn lại lâu dài không thật sự cần thiết, nhưng nó thường rất hữu ích, đặc biệt là khi bạn làm việc với các dự án lớn và phức tạp.

### Nhánh Chủ Đề ###

Nhánh chủ đề (topic branches) thì ngược lại, nó lại khá hữu ích cho các dự án ở bất kỳ cỡ nào. Một nhánh chủ đề là nhánh có vòng đời ngắn mà bạn tạo để phát triển một tính năng nào đó hoặc tương tự. Nó giống như một thứ gì đó mà bạn chưa từng làm với một VCS trước đây bởi vì nhìn chung nó đòi hỏi rất nhiều nỗ lực để tạo mới cũng như tích hợp các nhánh lại với nhau.

Như bạn đã thấy trong phần trước với các nhánh `iss53` và `hotfix` bạn đã tạo ra. Bạn thực hiện một số commit trên đó và xóa chúng đi ngay sau khi tính hợp chúng lại với nhánh chính. Kỹ thuật này cho phép bạn chuyển ngữ cảnh một cách nhanh chóng và toàn diện - vì công việc của bạn tách biệt hoàn toàn ở các xi-lô nơi mà tất cả các thay đổi ở nhánh đó chỉ liên quan đến chủ đề đó, điều này khiến cho việc xem xét lại (review) mã nguồn hoặc tương tự trở nên dễ dàng hơn rất nhiều. Bạn có thể giữ các thay đổi ở đó trong bất kỳ khoảng thời gian nào bạn muốn, có thể tính bằng phút, ngày, hoặc tháng, và sau đó tích hợp lại khi chúng đã sẵn sàng, không quan trọng thứ tự chúng được tạo ra hay làm việc.

Hãy cùng xét một ví dụ về thực hiện một số công việc (trên nhánh `master`), tạo nhánh cho một vấn đề cần giải quyết (`iss91`), làm việc trên đó một chút, tạo một nhánh thứ hai cùng giải quyết vấn đề đó nhưng theo một cách khác (`iss91v2`), quay trở lại nhánh `master` và làm việc trong một khoảng thời gian nhất định, sau đó tạo một nhánh khác từ đó cho một ý tưởng mà bạn không chắc chắn là nó có phải là ý hay hay không (nhánh `dumbidea`). Lúc này lịch sử commit của bạn sẽ giống Hình 3-20.

Insert 18333fig0320.png
Hình 3-20. Lịch sử commit với nhiều nhánh chủ đề.

Bây giờ, giả sử bạn quyết định lựa chọn cách giải quyết thứ hai (`iss91v2`); và bạn trình bày ý tưởng `dumbidea` cho các đồng nghiệp, điều mà bạn không ngờ tới rằng mọi người lại cho đó là một ý tưởng tuyệt vời. Bạn đã có thể bỏ đi nhánh ban đầu `iss91` (mất commit C5 và C6) và tích hợp hai commit còn lại. Lịch sử của bạn lúc này sẽ giống Hình 3-21.

Insert 18333fig0321.png
Hình 3-21. Lịch sử commit sau khi tích hợp dumbidea và iss91v2.

Ghi nhớ một điều quan trọng là khi bạn làm tất cả những việc này, các nhánh hoàn toàn nằm ở máy nội bộ. Khi bạn phân nhánh và tích hợp, tất cả mọi thứ xảy ra trên kho chứa Git của bạn - không có giao tiếp tới máy chủ nào xảy ra.

## Nhánh Remote ##

Nhánh từ xa (remote) là các tham chiếu tới trạng thái của các nhánh trên kho chứa trung tâm của bạn. Chúng là các nhánh nội bộ mà bạn không thể di chuyển; chúng chỉ di chuyển một cách tự động mỗi khi bạn thực hiện bất kỳ giao tiếp nào qua mạng lưới. Nhánh remote hoạt động như là các bookmark (dấu) để nhắc nhở bạn các nhánh trên kho chứa trung tâm của bạn ở đâu vào lần cuối cùng bạn kết nối tới.

Chúng có dạng `(remote)/(branch)`. Ví dụ, nếu bạn muốn xem nhánh `master` trên nhánh remote `origin` của bạn như thế nào từ lần giao tiếp cuối cùng, bạn sẽ dùng `origin/master`. Nếu bạn đang giải quyết một vấn đề với đối tác và họ đẩy dữ liệu lên nhánh `iss53`, bạn có thể có riêng nhánh `iss53` trên máy nội bộ; nhưng nhánh trên máy chủ sẽ trỏ tới commit tại `origin/iss53`.

Điều này có thể hơi khó hiểu một chút, vậy hãy cùng xem một ví dụ. Giả sử bạn có một máy chủ Git trên mạng của bạn tại địa chỉ `git.ourcompany.com`. Nếu bạn tạo bản sao từ đây, Git sẽ tự động đặt tên nó là `origin` cho bạn, tải về toàn bộ dữ liệu, tạo một con trỏ tới nhánh `master` và đặt tên nội bộ cho nó là `origin/master`; và bạn không thể di chuyển nó. Git cũng cung cấp cho bạn nhánh `master` riêng, bắt đầu cùng một vị trí với `master` của origin để cho bạn có thể bắt đầu làm việc (xem Hình 3-22).

Insert 18333fig0322.png
Hình 3-22. Một bản sao Git cung cấp cho bạn nhánh master riêng và nhánh origin/master trỏ tới nhánh master của origin.

Nếu bạn thực hiện một số thay đổi trên nhánh `master` nội bộ, và cùng thời điểm đó, một người nào đó đẩy lên `git.ourcompany.com` và cập nhật nhánh master của nó, thì lịch sử của bạn sẽ di chuyển về phía trước khác đi. Miễn là bạn không kết nối tới máy chủ thì con trỏ `origin/master` sẽ vẫn không đổi (xem Hình 3-23).

Insert 18333fig0323.png
Hình 3-23. Làm việc nội bộ và ai đó đẩy lên máy chủ khiến cho lịch sử thay đổi khác biệt nhau.

Để đồng bộ hóa các thay đổi, bạn chạy lệnh `git fetch origin`. Lệnh này sẽ tìm kiếm máy chủ nào là origin (trong trường hợp này là `git.ourcompany.com`), truy xuất toàn bộ dữ liệu mà bạn chưa có từ đó, và cập nhật cơ sở dữ liệu nội bộ của bạn, di chuyển con trỏ `origin/master` tới vị trí mới được cập nhật (xem Hình 3-24).

Insert 18333fig0324.png
Hình 3-24. Lệnh git fetch cập nhật các tham chiếu từ xa.

Để minh họa cho việc có nhiều máy chủ từ xa và các nhánh từ xa của các dự án thuộc các máy chủ đó, giả sử bạn có một máy chủ Git nội bộ khác sử dụng riêng cho các nhóm "thần tốc". Máy chủ này có địa chỉ là `git.team1.ourcompany.com`. Bạn có thể thêm nó như là một tham chiếu từ xa tới dự án bạn đang làm việc bằng cách chạy lệnh `git remote add` như đã giới thiệu ở Chương 2. Đặt tên cho remote đó là `teamone`, đó sẽ là tên rút gọn thay thế cho địa chỉ đầy đủ kia (xem Hình 3-25).

Insert 18333fig0325.png
Hình 3-25. Thêm một máy chủ từ xa khác.

Bây giờ bạn có thể chạy lệnh `git fetch teamone` để truy xất toàn bộ nội dung mà bạn chưa có từ máy chủ `teamone`. Bởi vì máy chủ đó có chứa một tập con dữ liệu từ máy chủ `origin` đang có, Git không truy xuất dữ liệu nào cả mà thiết lập một nhánh từ xa mới là `teamone/master` để trỏ tới commit mà `teamone` đang có như là nhánh `master` (xem Hình 3-26).

Insert 18333fig0326.png
Hình 3-26. Bạn sẽ có một tham chiếu tới vị trí nội bộ của nhánh `master` của teamone.

### Đẩy Lên ###

Khi bạn muốn chia sẻ một nhánh với mọi người, bạn cẩn phải đẩy nó lên một máy chủ mà bạn có quyền ghi trên đó. Nhánh nội bộ của bạn sẽ không tự động thực hiện quá trình đồng bộ hóa - mà bạn phải tự đẩy lên cách nhánh mà bạn muốn chia sẻ. Theo cách này, bạn có thể có các nhánh riêng tư cho những công việc mà bạn không muốn chia sẻ, và chỉ đẩy lên các nhánh chủ đề mà bạn muốn mọi người cùng tham gia đóng góp.

Nếu bạn có một nhánh là `serverfix` mà bạn muốn mọi người cùng cộng tác, bạn có thể đẩy nó lên theo cách mà chúng ta đã làm đối với nhánh đầu tiên. Chạy `git push (remote) (branch)`:

	$ git push origin serverfix
	Counting objects: 20, done.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (15/15), 1.74 KiB, done.
	Total 15 (delta 5), reused 0 (delta 0)
	To git@github.com:schacon/simplegit.git
	 * [new branch]      serverfix -> serverfix

Đây là một cách làm tắt. Git tự động mở rộng nhánh `serverfix` thành `refs/heads/serverfix:refs/heads/serverfix`, có nghĩa là, "Hãy sử dụng nhánh nội bộ serverfix của tôi và đẩy nó lên để cập nhật nhánh serverfix trên máy chủ từ xa." Chúng ta sẽ đi sâu vào phần `refs/heads/` ở Chương 9, nhưng bạn thường có thể bỏ qua nó. Bạn cũng có thể chạy lệnh sau `git push origin serverfix:serverfix`, cách này cũng cho kết quả tương tự - nó có nghĩa là "Hãy sử dụng serverfix của tôi để tạo một serverfix trên máy chủ". Bạn có thể sử dụng định dạng này để đẩy một nhánh nội bộ lên một nhánh từ xa với một tên khác. Nếu bạn không muốn gọi nó là `serverfix` trên máy chủ, bạn có thể chạy lệnh sau `git push origin serverfix:awesomebranch` để đẩy nhánh nội bộ `serverfix` vào nhánh `awesomebranch` trên máy chủ trung tâm. 

Lần tới một trong các đồng nghiệp của bạn truy xuất nó từ trên máy chủ, họ sẽ có một tham chiếu tới phiên bản trên máy chủ của `serverfix` dưới tên `origin/serverfix`:

	$ git fetch origin
	remote: Counting objects: 20, done.
	remote: Compressing objects: 100% (14/14), done.
	remote: Total 15 (delta 5), reused 0 (delta 0)
	Unpacking objects: 100% (15/15), done.
	From git@github.com:schacon/simplegit
	 * [new branch]      serverfix    -> origin/serverfix

Điều quan trọng cần chú ý ở đây là khi bạn truy xuất dữ liệu từ máy chủ mà có kèm theo nhánh mới, Git sẽ không tự động tạo phiên bản nội bộ của nhánh đó. Nói cách khác, trong trường hợp này, bạn sẽ không có nhánh `serverfix` mới - bạn chỉ có một con trỏ tới `origin/serverfix` mà bạn không thể chỉnh sửa.

Để tích hợp công việc hiện tại vào nhánh bạn đang làm việc, bạn có thể chạy `git merge origin/serverfix`. Nếu bạn muốn nhánh `serverfix` riêng để có thể làm việc trên đó, bạn có thể tách nó ra khỏi nhánh trung tâm bằng cách:

	$ git checkout -b serverfix origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

Cách này sẽ tạo cho bạn một nhánh nội bộ mà bạn có thể làm việc, bắt đầu cùng một vị trí với `origin/serverfix`.

### Theo Dõi Các Nhánh ###

Check out một nhánh nội bộ từ một nhánh trung tâm tự động tạo ra một _tracking branch_. Tracking branches là các nhánh nội bộ có liên quan trực tiếp với một nhánh trung tâm. Nếu bạn đang ở trên một tracking branch và chạy `git push`, Git tự động biết nó sẽ phải đẩy lên nhánh nào, máy chủ nào. Ngoài ra, chạy `git pull` khi đang ở trên một trong những nhánh này sẽ truy xuất toàn bộ các tham chiếu từ xa và sau đó tự động tích hợp chúng với các nhánh từ xa tương ứng.

Khi bạn tạo bản sao của một kho chứa, thông thường Git tự động tạp một nhánh `master` để theo dõi `origin/master`. Đó là lý do tại sao `git push` và `git pull` có thể chạy tốt mà không cần bất kỳ tham số nào. Tuy nhiên, bạn có thể cài đặt các tracking branch khác nếu muốn - các nhánh này không theo dõi nhánh trên `origin` cũng như `master`. Một ví dụ đơn giản giống như bạn vừa thấy: `git checkout -b [branch] [remotename]/[branch]`. Nếu bạn đang sử dụng Git phiên bản 1.6.2 trở lên, bạn có thể sử dụng `--track`:

	$ git checkout --track origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

Để cài đặt một nhánh nội bộ sử dụng tên khác với tên mặc định trên nhánh trung tâm, bạn có thể dễ dàng sử dụng phiên bản đầu tiên với một tên nội bộ khác:

	$ git checkout -b sf origin/serverfix
	Branch sf set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "sf"

Bây giờ, nhánh nội bộ sf sẽ tự động "kéo và đẩy" từ origin/serverfix.

### Xóa Nhánh Trung Tâm ###

Giả sử bạn và đồng nghiệp đã hoàn thành một chức năng nào đó và đã tích hợp nó vào nhánh `master` trung tâm (hoặc bất kỳ nhánh nào khác sử dụng cho việc lưu trữ các phiên bản ổn định). Bạn có thể xóa một nhánh trung tâm đi sử dụng cú pháp sau `git push [remotename] :[branch]`. Nếu bạn muốn xóa nhánh `serverfix` trên máy chủ, bạn có thể chạy lệnh sau:

	$ git push origin :serverfix
	To git@github.com:schacon/simplegit.git
	 - [deleted]         serverfix

Vậy là đã xong, nhánh đó đã bị xóa khỏi máy chủ. Có thể bạn muốn đánh dấu trang này lại, vì bạn sẽ cần đến câu lệnh này và có thể bạn sẽ quên cú pháp của nó. Một cách để nhớ lệnh này là xem lại cú pháp chúng ta đã nhắc tới trước đó `git push [remotename] [localbranch]:[remotebranch]`. Nếu bạn bỏ qua phần `[localbranch]`, thì cơ bản bạn đang thực hiện "Không sử dụng gì từ phía nội bộ để tạo nhánh `[remotebranch]`."

## Rebasing ##

Trong Git, có hai cách chính để tích hợp các thay đổi từ nhánh này vào nhánh khác: đó là `merge` và `rebase`. Trong phần này bạn sẽ được tìm hiểu rebase là gì, sử dụng nó như thế nào, tại sao nó được coi là một công cụ khá tuyệt vời, và trong trường hợp nào thì không nên sử dụng nó.

### Cơ Bản về Rebase ###

Nếu bạn xem lại ví dụ trước trong phần Tích Hợp (xem Hình 3-27), bạn có thể thấy rằng bạn đã phân nhánh công việc của bạn và thực hiện commit trên hai nhánh khác nhau.

Insert 18333fig0327.png
Hình 3-17. Lần phân nhánh đầu tiên.

Cách đơn giản nhất để tích hợp các nhánh, như chúng ta đã đề cập từ trước, đó là lệnh `merge`. Nó thực hiện tích hợp 3-chiều giữa hai snapshot mới nhất của hai nhánh (C3 và C4) và cha chung gần nhất của cả hai (C2), tạo mới một snapshot khác (và commit), như trong Hình 3-28.

Insert 18333fig0328.png
Hình 3-28. Gộp nhánh lại để hợp nhất công việc bị tách ra trước đây.

Tuy nhiên, còn có một cách khác: bạn có thể sử dụng bản vá của thay đổi được đưa ra ở C3 và áp dụng nó lên trên C4. Trong Git, đây được gọi là _rebasing_. Bằng cách sử dụng lệnh `rebase`, bạn có thể sử dụng tất cả các thay đổi được commit ở một nhánh và "chạy lại" (replay) chúng trên một nhánh khác.

Trong ví dụ này, bạn thực hiện như sau:

	$ git checkout experiment
	$ git rebase master
	First, rewinding head to replay your work on top of it...
	Applying: added staged command

Nó thực hiện bằng cách đi tới commit cha chung của hai nhánh (nhánh bạn đang làm việc và nhánh bạn đang muốn rebase), tìm sự khác biệt trong mỗi commit của nhánh mà bạn đang làm việc, lưu lại các thay đổi đó vào một tập tin tạm thời, khôi phục lại nhánh hiện tại về cùng một commit với nhánh bạn đang rebase, và cuối cùng áp dụng lần lượt các thay đổi. Hình 3-29 minh họa toàn bộ quá trình này.

Insert 18333fig0329.png
Hình 3-29. Quá trình rebase thay đổi ở C3 vào C4.

Đến lúc này, bạn có thể quay lại nhánh `master` và thực hiện fast-forward merge (xem Hình 3-30).

Insert 18333fig0330.png
Hình 3-30. Di chuyển nhánh master lên phía trước.

Bây giờ snapshot mà C3' trỏ tới cũng giống như snapshot được trở tới bởi C5 trong ví dụ sử dụng merge. Không có sự khác biệt nào khi so sánh kết quả của hai phương pháp này, nhưng sử dụng rebase sẽ cho chúng ta lịch sử rõ ràng hơn. Nếu bạn xem xét lịch sử của nhánh mà chúng ta rebase vào, nó giống như một đường thẳng: mọi thứ dường như xảy ra theo trình tự, thậm chí ban đầu nó diễn ra song song.


Bình thường, bạn sử dụng cách này để đảm bảo rằng các commit được áp dụng một cách rõ ràng, rành mạch trên nhánh remote - có lẽ là một dự án mà bạn đang đóng góp chứ không phải duy trì nó. Trong trường hợp này, bạn thực hiện công việc trên một nhánh và sau đó rebase trở lại nhánh `origin/master` khi đã sẵn sàng. Theo cách này thì người duy trì dự án đó không phải thực hiện việc tích hợp - mà chỉ chi chuyển tiến lên phía trước (fast-forwar) hoặc đơn giản là áp dụng chúng vào.

Lưu ý rằng snapshot được trỏ tới bởi commit cuối cùng, cho dù nó là kết quả của việc rebase hay merge, thì nó vẫn giống nhau - chỉ khác nhau về các bước thực hiện mà thôi. Quá trình rebase được thực hiện bằng cách thực hiện lại các thay đổi từ nhánh này qua nhánh khác theo thứ tự chúng đã được thực hiện, trong khi đó merge lại lấy hai điểm kết thúc và gộp chúng lại với nhau.

### Rebase Nâng Cao ###

Bạn cũng có thể thực hiện rebase trên một đối tượng khác mà không phải là nhánh rebase. Xem ví dụ Hình 3-31. Bạn tạo một nhánh chủ để (`server`) để thêm một số tính năng server-side vào dự án, và thực hiện một số commit. Sau đó bạn tạo một nhánh khác để thực hiện một số thay đổi cho phía client (`client`) và cũng commit vài lần. Cuối cùng, bạn quay trở lại nhánh server và thực hiện thêm một số commit nữa.

Insert 18333fig0331.png
Hình 3-31. Nhánh chủ đề được tạo từ một nhánh chủ đề khác.

Giả sử bạn quyết định tích hợp các thay đổi phía client vào nhánh chính cho bản phát hành sắp tới, nhưng bạn vẫn muốn giữ các thay đổi server-side cho đến khi nó được kiểm tra kỹ lưỡng. Bạn có thể lấy các thay đổi ở client mà không có mặt ở server (C8 và C9) sau đó chạy lại (replay) chúng trên nhánh master bằng cách sử dụng lựa chọn `--onto` cho lệnh `git rebase`:

	$ git rebase --onto master server client

Lệnh này cơ bản nói rằng, "Hãy check out nhánh client, tìm ra các bản vá từ commit chung của nhánh `client` và `server`, sau đó thực thi lại vào nhánh `master`." Nó hơi phức tạp một chút nhưng kết quả như Hình 3-32 thì lại rất tuyệt.

Insert 18333fig0332.png
Hình 3-32. Quá trình rebase nhánh chủ đề khỏi một nhánh chủ đề khác.

Bây giờ bạn có thể di chuyển con trỏ của nhánh master tiến lên phía trước (xem Hình 3-33):

	$ git checkout master
	$ git merge client

Insert 18333fig0333.png
Hình 3-33. Di chuyển nhánh master lên phía trước để bao gồm các thay đổi của nhánh client.

Giả sử rằng bạn quyết định kéo về cả nhánh trên máy chủ. Bạn có thể rebase nhánh trên máy chủ đó vào nhánh master mà không phải checkout trước bằng lệnh `git rebase [basebranch] [topicbranch]` - lệnh này sẽ checkout nhánh chủ để (trong trường hợp này là `server`) cho bạn và áp dụng lại các thay đổi vào nhánh cơ sở (base) `master`:

	$ git rebase master server

Lệnh này sẽ thực hiện lại các thay đổi trên nhánh `server` chèn vào nhánh `master` như trong Hình 3-34.

Insert 18333fig0334.png
Hình 3-34. Rebase nhánh server chèn lên nhánh master. 

Sau đó bạn có thể di chuyển con trỏ nhánh base (`master`):

	$ git checkout master
	$ git merge server

Bạn có thể xóa nhánh `client` và `server` vì tất cả công việc đã được tích hợp vào master và bạn không cần đến chúng nữa, lịch sử quả toàn bộ quá trình vừa rồi giống như Hình 3-35:

	$ git branch -d client
	$ git branch -d server

Insert 18333fig0335.png
Hình 3-35. Lịch sử commit cuối cùng.

### Rủi Ro của Rebase ###

Mặc dù rebase rất hữu ích nhưng nó cũng có không ít những mặt hạn chế, điều này có thể tổng kết bằng câu sau đây:

**Không được rebase các commit mà bạn đã đẩy lên một kho chứa công khai.**

Miễn là bạn làm theo hướng dẫn này, sẽ không có chuyện gì xảy ra. Nếu không, mọi người sẽ ghét bạn, và bạn sẽ bị bạn bè và gia đình coi thường.

Khi bạn thực hiện rebase, bạn đang bỏ đi các commit đã tồn tại và tái tạo lại các commit mới tương tự nhưng thực ra khác biệt. Nếu bạn đẩy commit ở một nơi nào đó và mọi người kéo xuống máy của họ, sau đó bạn sửa lại các commit đó bằng lệnh `git rebase` và đẩy lên một lần nữa, đồng nghiệp của bạn sẽ phải tích hợp lại công việc của họ và mọi thứ sẽ rối tung lên khi bạn cố gắng kéo các thay đổi của họ ngược lại máy bạn.

Hãy cùng xem một ví dụ làm sao việc rebase công khai có thể gây sự cố. Giả sử bạn tạo bản sao từ một máy chủ trung tâm và thực hiện một số thay đổi từ đó. Lịch sử commit của bạn sẽ giống như Hình 3-36.

Insert 18333fig0336.png
Hình 3-36. Tạo bản sao một kho chứa, và base một số thay đổi vào đó.

Bây giờ, một người khác thực hiện một số thay đổi khác có kèm theo một lần tích hợp (merge), và đẩy lên máy chủ trung tâm. Bạn truy xuất chúng và tích hợp nhánh trung tâm mới đó vào của bạn, lúc này lịch sử của bạn sẽ giống như Hình 3-37.

Insert 18333fig0337.png
Hình 3-37. Truy xuất thêm các commit và tích hợp lại.

Tiếp theo, người đã đẩy tích hợp đó quyết định lại và rebase lại những thay đổi của họ; họ thực hiện `git push --force` để ghi đè lịch sử trên máy chủ. Sau đó bạn truy xuất lại dữ liệu từ máy chủ, đưa về các commit mới.

Insert 18333fig0338.png
Hình 3-38. Một người nào đó đẩy lên các commit rebase, bỏ đi các commit có chứa thay đổi của bạn.

Lúc này, bạn phải tích hợp lại một lần nữa các thay đổi này, mặc dù trước đó bạn đã làm rồi. Quá trình rebase thay đổi mã băm SHA-1 của các commit này vì thế đối với Git chúng giống như các commit mới, mà thực tế thì bạn đã có C4 trong lịch sử của bạn (xem Hình 3-39).

Insert 18333fig0339.png
Hình 3-39. Bạn tích hợp các thay đổi tương tự lại một lần nữa vào một commit tích hợp mới.

Bạn phải tích hợp thay đổi đó để có thể theo kịp với các lập trình viên khác về sau này. Sau khi thực hiện việc này, lịch sử commit của bạn sẽ bao gồm cả hai commit C4 và C4' có mã SHA-1 khác nhau nhưng lại có cùng chung nội dung thay đổi cũng như thông điệp commit. Nếu bạn chạy lệnh `git log` trong trường hợp này bạn sẽ thấy hai commit cùng chung ngày commit và thông điệp, điều này sẽ gây khó hiểu cho bạn. Hơn nữa, nếu bạn đẩy chúng ngược lên máy chủ, bạn sẽ đưa vào một lần nữa tất cả các commit đã rebase đó và sẽ gây khó hiểu cho nhiều người khác nữa.

Nếu bạn sử dụng rebase như là cách để dọn dẹp các commit trước khi đẩy chúng lên, và nếu như bạn chỉ rebase commit chưa bao giờ được công khai, thì sẽ không có chuyện gì xảy ra. Nếu bạn rebase các commit đã được công khai và mọi người có thể đã tích hợp (base) nó vào công việc của họ thì bạn có thể gặp phải các vấn đề thực sự khó chị.

## Tổng Kết ##

Chúng ta đã đề cập tới các khái niệm cơ bản về phân nhánh và tích hợp trong Git. Bạn nên nắm vững việc tạo mới, di chuyển giữa các nhánh và tích hợp các nhánh nội bộ lại với nhau. Bạn cũng nên có khả năng chia sẽ các nhánh bằng cách đẩy chúng lên một máy chủ trung tâm, cộng tác với các thành viên khác trên các nhánh dùng chung và rebase chúng trước khi chia sẻ.
