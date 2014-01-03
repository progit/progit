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

Bạn có thể tiếp tục làm theo cách này cho nhiều tầng ổn định khác nhau. Nhiều dự án lớn có nhánh `proposed` hoặc `pu` (proposed updates) được sử dụng cho các nhánh chưa đủ điều kiện để tích hợp vào `next` hoặc `master`. 

You can keep doing this for several levels of stability. Some larger projects also have a `proposed` or `pu` (proposed updates) branch that has integrated branches that may not be ready to go into the `next` or `master` branch. The idea is that your branches are at various levels of stability; when they reach a more stable level, they’re merged into the branch above them.
Again, having multiple long-running branches isn’t necessary, but it’s often helpful, especially when you’re dealing with very large or complex projects.

### Topic Branches ###

Topic branches, however, are useful in projects of any size. A topic branch is a short-lived branch that you create and use for a single particular feature or related work. This is something you’ve likely never done with a VCS before because it’s generally too expensive to create and merge branches. But in Git it’s common to create, work on, merge, and delete branches several times a day.

You saw this in the last section with the `iss53` and `hotfix` branches you created. You did a few commits on them and deleted them directly after merging them into your main branch. This technique allows you to context-switch quickly and completely — because your work is separated into silos where all the changes in that branch have to do with that topic, it’s easier to see what has happened during code review and such. You can keep the changes there for minutes, days, or months, and merge them in when they’re ready, regardless of the order in which they were created or worked on.

Consider an example of doing some work (on `master`), branching off for an issue (`iss91`), working on it for a bit, branching off the second branch to try another way of handling the same thing (`iss91v2`), going back to your master branch and working there for a while, and then branching off there to do some work that you’re not sure is a good idea (`dumbidea` branch). Your commit history will look something like Figure 3-20.

Insert 18333fig0320.png
Figure 3-20. Your commit history with multiple topic branches.

Now, let’s say you decide you like the second solution to your issue best (`iss91v2`); and you showed the `dumbidea` branch to your coworkers, and it turns out to be genius. You can throw away the original `iss91` branch (losing commits C5 and C6) and merge in the other two. Your history then looks like Figure 3-21.

Insert 18333fig0321.png
Figure 3-21. Your history after merging in dumbidea and iss91v2.

It’s important to remember when you’re doing all this that these branches are completely local. When you’re branching and merging, everything is being done only in your Git repository — no server communication is happening.

## Remote Branches ##

Remote branches are references to the state of branches on your remote repositories. They’re local branches that you can’t move; they’re moved automatically whenever you do any network communication. Remote branches act as bookmarks to remind you where the branches on your remote repositories were the last time you connected to them.

They take the form `(remote)/(branch)`. For instance, if you wanted to see what the `master` branch on your `origin` remote looked like as of the last time you communicated with it, you would check the `origin/master` branch. If you were working on an issue with a partner and they pushed up an `iss53` branch, you might have your own local `iss53` branch; but the branch on the server would point to the commit at `origin/iss53`.

This may be a bit confusing, so let’s look at an example. Let’s say you have a Git server on your network at `git.ourcompany.com`. If you clone from this, Git automatically names it `origin` for you, pulls down all its data, creates a pointer to where its `master` branch is, and names it `origin/master` locally; and you can’t move it. Git also gives you your own `master` branch starting at the same place as origin’s `master` branch, so you have something to work from (see Figure 3-22).

Insert 18333fig0322.png
Figure 3-22. A Git clone gives you your own master branch and origin/master pointing to origin’s master branch.

If you do some work on your local master branch, and, in the meantime, someone else pushes to `git.ourcompany.com` and updates its master branch, then your histories move forward differently. Also, as long as you stay out of contact with your origin server, your `origin/master` pointer doesn’t move (see Figure 3-23).

Insert 18333fig0323.png
Figure 3-23. Working locally and having someone push to your remote server makes each history move forward differently.

To synchronize your work, you run a `git fetch origin` command. This command looks up which server origin is (in this case, it’s `git.ourcompany.com`), fetches any data from it that you don’t yet have, and updates your local database, moving your `origin/master` pointer to its new, more up-to-date position (see Figure 3-24).

Insert 18333fig0324.png
Figure 3-24. The git fetch command updates your remote references.

To demonstrate having multiple remote servers and what remote branches for those remote projects look like, let’s assume you have another internal Git server that is used only for development by one of your sprint teams. This server is at `git.team1.ourcompany.com`. You can add it as a new remote reference to the project you’re currently working on by running the `git remote add` command as we covered in Chapter 2. Name this remote `teamone`, which will be your shortname for that whole URL (see Figure 3-25).

Insert 18333fig0325.png
Figure 3-25. Adding another server as a remote.

Now, you can run `git fetch teamone` to fetch everything the remote `teamone` server has that you don’t have yet. Because that server has a subset of the data your `origin` server has right now, Git fetches no data but sets a remote branch called `teamone/master` to point to the commit that `teamone` has as its `master` branch (see Figure 3-26).

Insert 18333fig0326.png
Figure 3-26. You get a reference to teamone’s master branch position locally.

### Pushing ###

When you want to share a branch with the world, you need to push it up to a remote that you have write access to. Your local branches aren’t automatically synchronized to the remotes you write to — you have to explicitly push the branches you want to share. That way, you can use private branches for work you don’t want to share, and push up only the topic branches you want to collaborate on.

If you have a branch named `serverfix` that you want to work on with others, you can push it up the same way you pushed your first branch. Run `git push (remote) (branch)`:

	$ git push origin serverfix
	Counting objects: 20, done.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (15/15), 1.74 KiB, done.
	Total 15 (delta 5), reused 0 (delta 0)
	To git@github.com:schacon/simplegit.git
	 * [new branch]      serverfix -> serverfix

This is a bit of a shortcut. Git automatically expands the `serverfix` branchname out to `refs/heads/serverfix:refs/heads/serverfix`, which means, “Take my serverfix local branch and push it to update the remote’s serverfix branch.” We’ll go over the `refs/heads/` part in detail in Chapter 9, but you can generally leave it off. You can also do `git push origin serverfix:serverfix`, which does the same thing — it says, “Take my serverfix and make it the remote’s serverfix.” You can use this format to push a local branch into a remote branch that is named differently. If you didn’t want it to be called `serverfix` on the remote, you could instead run `git push origin serverfix:awesomebranch` to push your local `serverfix` branch to the `awesomebranch` branch on the remote project.

The next time one of your collaborators fetches from the server, they will get a reference to where the server’s version of `serverfix` is under the remote branch `origin/serverfix`:

	$ git fetch origin
	remote: Counting objects: 20, done.
	remote: Compressing objects: 100% (14/14), done.
	remote: Total 15 (delta 5), reused 0 (delta 0)
	Unpacking objects: 100% (15/15), done.
	From git@github.com:schacon/simplegit
	 * [new branch]      serverfix    -> origin/serverfix

It’s important to note that when you do a fetch that brings down new remote branches, you don’t automatically have local, editable copies of them. In other words, in this case, you don’t have a new `serverfix` branch — you only have an `origin/serverfix` pointer that you can’t modify.

To merge this work into your current working branch, you can run `git merge origin/serverfix`. If you want your own `serverfix` branch that you can work on, you can base it off your remote branch:

	$ git checkout -b serverfix origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

This gives you a local branch that you can work on that starts where `origin/serverfix` is.

### Tracking Branches ###

Checking out a local branch from a remote branch automatically creates what is called a _tracking branch_. Tracking branches are local branches that have a direct relationship to a remote branch. If you’re on a tracking branch and type `git push`, Git automatically knows which server and branch to push to. Also, running `git pull` while on one of these branches fetches all the remote references and then automatically merges in the corresponding remote branch.

When you clone a repository, it generally automatically creates a `master` branch that tracks `origin/master`. That’s why `git push` and `git pull` work out of the box with no other arguments. However, you can set up other tracking branches if you wish — ones that don’t track branches on `origin` and don’t track the `master` branch. The simple case is the example you just saw, running `git checkout -b [branch] [remotename]/[branch]`. If you have Git version 1.6.2 or later, you can also use the `--track` shorthand:

	$ git checkout --track origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

To set up a local branch with a different name than the remote branch, you can easily use the first version with a different local branch name:

	$ git checkout -b sf origin/serverfix
	Branch sf set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "sf"

Now, your local branch sf will automatically push to and pull from origin/serverfix.

### Deleting Remote Branches ###

Suppose you’re done with a remote branch — say, you and your collaborators are finished with a feature and have merged it into your remote’s `master` branch (or whatever branch your stable codeline is in). You can delete a remote branch using the rather obtuse syntax `git push [remotename] :[branch]`. If you want to delete your `serverfix` branch from the server, you run the following:

	$ git push origin :serverfix
	To git@github.com:schacon/simplegit.git
	 - [deleted]         serverfix

Boom. No more branch on your server. You may want to dog-ear this page, because you’ll need that command, and you’ll likely forget the syntax. A way to remember this command is by recalling the `git push [remotename] [localbranch]:[remotebranch]` syntax that we went over a bit earlier. If you leave off the `[localbranch]` portion, then you’re basically saying, “Take nothing on my side and make it be `[remotebranch]`.”

## Rebasing ##

In Git, there are two main ways to integrate changes from one branch into another: the `merge` and the `rebase`. In this section you’ll learn what rebasing is, how to do it, why it’s a pretty amazing tool, and in what cases you won’t want to use it.

### The Basic Rebase ###

If you go back to an earlier example from the Merge section (see Figure 3-27), you can see that you diverged your work and made commits on two different branches.

Insert 18333fig0327.png
Figure 3-27. Your initial diverged commit history.

The easiest way to integrate the branches, as we’ve already covered, is the `merge` command. It performs a three-way merge between the two latest branch snapshots (C3 and C4) and the most recent common ancestor of the two (C2), creating a new snapshot (and commit), as shown in Figure 3-28.

Insert 18333fig0328.png
Figure 3-28. Merging a branch to integrate the diverged work history.

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

## Summary ##

We’ve covered basic branching and merging in Git. You should feel comfortable creating and switching to new branches, switching between branches and merging local branches together.  You should also be able to share your branches by pushing them to a shared server, working with others on shared branches and rebasing your branches before they are shared.
