# Bắt Đầu #

Chương này sẽ giới thiệu về việc bắt đầu với Git. Chúng ta sẽ xuất phát bằng việc giải thích cơ bản về các công cụ quản lý phiên bản, sau đó là làm thế nào để chạy nó trên hệ thống của bạn và cuối cùng cài đặt như thế nào để có thể làm việc với nó. Kết thúc chương này bạn sẽ hiểu được lý do tại sao cần có sự hiện diện của Git, tại sao bạn nên sử dụng, nên thành thạo để sử dụng nó.

## Về Quản Lý Phiên Bản ##

Quản lý phiên bản (mã nguồn) là gì, tại sao bạn nên quan tâm? Quản lý phiên bản là một hệ thống lưu trữ các thay đổi của một tập tin (file) hoặc tập hợp các tập tin theo thời gian, do đó nó giúp bạn có thể quay lại một phiên bản xác định nào đó sau này. Mặc dù các ví dụ trong cuốn sách này sử dụng mã nguồn của phần mềm là đối tượng cho quản lý phiên bản, song trong thực thế bất kỳ loại file nào trên máy tính cũng có thể được sử dụng cho quản lý phiên bản.

Nếu bạn là một nhà thiết kế đồ hoạ hoặc thiết kế website, bạn muốn lưu trữ tất cả các phiên bản của một bức ảnh hoặc bố cục (cái mà chắc chắn bạn cần), thì sử dụng một Hệ Thống Quản Lý phiên bản (Version Control System - VCS) là một cách làm rất khôn ngoan. Một VCS cho phép bạn: khôi phục lại phiên bản cũ của các file, khôi phục lại phiên bản cũ của toàn bộ dự án, xem lại các thay đổi đã được thực hiện theo thời gian, xem ai là người thực hiện thay đổi cuối cùng có thể gây ra sự cố, hay xem ai là người đã gây ra sự cố đó và còn nhiều hơn thế nữa. Sử dụng VCS còn đồng nghĩa với việc khi bạn làm rối tung mọi thứ lên hay vô tình xoá mất các file đi, bạn có khôi phục lại chúng một cách dễ dàng. Hơn nữa, tất cả quá trình này có thể được thực hiện rất nhanh chóng và không hề tốn quá nhiều công sức.

### Hệ Thống Quản Lý Phiên Bản Cục Bộ ###

Nhiều người chọn phương pháp quản lý phiên bản bằng cách copy các file sang một thư mục khác (có thể là các thư mục được đặt tên theo thời gian, nếu họ thông minh). Đây là một phương pháp rất phổ biến bởi vì nó rất đơn giản, tuy nhiên nó cũng rất dễ gây ra lỗi. Bạn sẽ rất dễ quên rằng bạn đang ở trong thư mục nào hay vô tình sửa hoặc sao chép nhầm file mà bạn không muốn.

Để giải quyết vấn đề này, từ lâu các lập trình viên đã phát triển các phiên bản VCS cục bộ có chứa một database đơn giản lưu trữ tất cả các sự thay đổi của các files dưới sự kiểm soát thay đổi (xem Hình 1-1).

Insert 18333fig0101.png
Hình 1-1. Mô hình quản lý phiên bản cục bộ.

Một trong những hệ thống quản lý phiên bản phổ biến hơn có tên là rcs vẫn còn được sử dụng ở nhiều máy tính cho tới bây giờ. Ngay cả hệ điều hành Mac OS X nổi tiếng cũng đưa vào các lệnh rcs khi bạn cài đặt Developer Tools (Các công cụ dành cho lập trình viên). Phần mềm này cơ bản hoạt động bằng cách lưu giữ các bản vá (những sự thay đổi giữa các file) từ phiên bản này qua phiên bản khác ở một định dạng đặc biệt được lưu trên ổ cứng; nó có thể tái tạo lại bất kỳ file nào ở bất kỳ thời điểm nào bằng cách gộp tất cả các bản vá lại với nhau.

### Hệ Thống Quản Lý Phiên Bản Tập Trung ###

Vấn đề nghiêm trọng tiếp theo mà mọi người thường mắc phải là họ cần cộng tác với các lập trình viên khác trong hệ thống. Để vượt qua trở ngại này, Hệ Thống Quản Lý Phiên Bản Tập Trung (Centralized Version Control Systems - CVCSs) được phát triển. Các hệ thống này, ví dụ như CVS, Subversion, và Perforce, bao gồm một máy chủ có chứa tất cả các tập tin đã được "phiên bản hoá" (versioned), và danh sách các máy khách có quyền thay đổi các tập tin này trên máy chủ trung tâm đó. Trong vòng nhiều năm, mô hình này đã trở thành tiêu chuẩn cho việc quản lý phiên bản (xem Hình 1-2). 

Insert 18333fig0102.png
Hình 1-2. Mô hình quản lý phiên bản tập trung.

Mô hình này cung cấp rất nhiều lợi thế, đặc biết so với việc quản lý cục bộ. Ví dụ, tất cả người dùng đều biết một phần nào đó những việc mà những người khác trong dự án đang làm. Người quản lý có quyền quản lý ai có thể làm gì theo ý muốn; và việc này dễ dàng hơn nhiều so với việc phải quản lý ở từng cơ sở dử liệu ở từng máy riêng biệt.

Tuy nhiên, mô hình này cũng có những bất cập nghiêm trọng. Dễ nhận thấy nhất đó là "sự cố tập trung" mà máy chủ trung tâm mắc phải. Nếu máy chủ đó không hoạt động trong một giờ, nghĩa là trong khoảng thời gian đó không ai có thể cộng tác với những người còn lại hoặc lưu trữ các thay đổi đã được phiên bản hoá của bất kỳ tập tin nào mà người đó đang thao tác. Nếu ổ cứng lưu trữ cơ sở dữ liệu trung tâm bị hỏng, và các sao lưu dự phòng chưa được tạo ra tính đến thời điểm đó, bạn sẽ mất toàn bộ lịch sử của dự án đó, ngoại trừ những phiên bản cục bộ mà người dùng có được trên máy tính cá nhân. Các hệ thống quản lý phiên bản cục bộ phải đối diện với vấn đề tương tự như thế này mỗi khi toàn bộ lịch sử của dự án được lưu ở một nơi, bạn có nguy cơ mất tất cả.

### Hệ Thống Quản Lý Phiên Bản Phân Tán ###

Đã tới lúc cần tới các Hệ Thống Quản Lý Phiên Bản Phân Tán - Distributed Version Control Systems (DVCSs). Trong các DVCS (ví dụ như Git, Mercurial, Bazaar hay Darcs), các máy khách không chỉ "check out" (sao chép về máy cục bộ) phiên bản mới nhất của các tập tin: chúng sao chép (mirror) toàn bộ kho chứa (repository). Chính vì vậy nếu như một máy chủ nào mà các hệ thống quản lý phiên bản này (mỗi máy khách là một hệ thống riêng biệt) đang cộng tác ngừng hoạt động, thì kho chứa từ bất kỳ máy khách nào cũng có thể dùng để sao chép ngược trở lại máy chủ để khôi phục lại toàn bộ hệ thống. Mỗi checkout thực sự là một bản sao đầy đủ của tất cả dữ liệu (xem Hình 1-3).

Insert 18333fig0103.png
Hình 1-3. Mô hình quản lý phiên bản phân tán.

Ngoài ra, phần lớn các hệ thống này xử lý rất tốt việc quản lý nhiều kho chứa từ xa, vì thế bạn có thể cộng tác với nhiều nhóm người khác nhau theo những cách khác nhau trong cùng một dự án. Việc này cho phép bạn cài đặt nhiều loại "tiến trình công việc" (workflow) không thể thực hiện được với các hệ thống tập trung, ví dụ như các mô hình phân cấp.

## Sơ Lược Lịch Sử của Git ##

Cũng như nhiều thứ tuyệt vời khác trong cuộc sống, Git ra đời từ một chút của sự huỷ diệt/phá sản/kết thúc có tính sáng tạo và sự tranh cãi nảy lửa. Nhân của Linux là một dự án phần mềm mã nguồn mở của một phạm vi khá lớn. Trong phần lớn thời gian bảo trì của nhân Linux (1991-2002), các thay đổi của phần mềm được truyền đi dưới dạng các bản vá và các tập tin lưu trữ. Vào năm 2002, dự án nhân Linux bắt đầu sử dụng một DVCS độc quyền có tên là BitKeeper.

Vào năm 2005, sự hợp tác giữa cộng đồng phát triển nhân Linux và công ty thương mại phát triển BitKeeper bị phá vỡ, và công cụ đó không còn được cung cấp miễn phí nữa. Chính điều này đã thúc đẩy cộng đồng phát triển Linux (chính xác hơn là Linus Torvalds, người sáng lập ra Linux) phát triển công cụ của riêng họ dựa trên những bài học từ việc sử dụng BitKeeper. Một số mục tiêu của hệ thống mới được vạch ra như sau:

*	Nhanh
*	Thiết kế đơn giản
*	Hỗ trợ tốt cho "phát triển phi tuyến tính" (non-linear development) - (hàng ngàn nhánh song song) 
*	Phân tán toàn diện
*	Có khả năng xử lý các dự án lớn giống như nhân Linux một cách hiệu quả (về mặt tốc độ và khối lượng dữ liệu)

Kể từ khi ra đời năm 2005, Git đã tiến hoá và phát triển toàn diện để dễ dàng sử dụng hơn, tuy thế các tiêu chí ban đầu vẫn được đảm bảo. Nó nhanh một cách đáng kinh ngạc, vô cùng hiệu quả với các dự án lớn, và một hệ thống phân nhánh không thể tin được cho phát triển phi tuyến tính (xem Chương 3).

## Cơ Bản về Git ##

Tóm lại thì, Git là gì? Đây là một phần quan trọng để tiếp thu, bởi vì nếu bạn hiểu được Git là gì và các nguyên tắc cơ bản của việc Git hoạt động như thế nào, thì sử dụng Git một cách hiệu quả sẽ trở nên dễ dàng hơn cho bạn rất nhiều. Khi học Git, hãy cố gắng gạt bỏ những kiến thức mà có thể bạn đã biết về các VCS khác, ví dụ như Subversion và Perforce; việc này sẽ giúp bạn tránh được sự hỗn độn, bối rối khi sử dụng nó. Git "nghĩ" về thông tin và lưu trữ nó khá khác biệt so với các hệ thống khác, mặc dù giao diện người dùng tương đối giống nhau; hiểu được những khác biệt đó sẽ giúp bạn tránh được rất nhiều bối rối.

### Ảnh Chụp, Không Phải Sự Khác Biệt ###

Sự khác nhau cơ bản giữa Git với bất kỳ VCS nào khác (bao gồm Subversion và tương tự là cách Git "nghĩ" về dữ liệu. Về mặt lý thuyết mà nói, phần lớn hệ thống khác lưu trữ thông tin dưới dạng danh sách các tập tin được thay đổi. Các hệ thống này (CVS, Subversion, Perforce, Bazaar,...) coi thông tin được lưu trữ như là một tập hợp các tập tin và các thay đổi được thực hiện trên mỗi tập tin theo thời gian, được minh hoạ trong hình 1-4.

Insert 18333fig0104.png
Hình 1-4. Các hệ thống khác hướng tới lưu trữ tập tin dưới dạng các thay đổi so với bản cơ sở của mỗi tập tin.

Git không nghĩ hoặc xử lý dữ liệu theo cách này. Mà thay vào đó Git coi dữ liệu của nó giống như một tập hợp các "ảnh" (snapshot) của một hệ thống tập tin nhỏ. Mỗi lần bạn "commit", hoặc lưu lại trạng thái hiện tại của dự án trong Git, về cơ bản Git "chụp một bức ảnh" ghi lại nội dung của tất cả các tập tin tại thời điểm đó và tạo ra một tham chiếu tới "ảnh" đó. Để hiệu quả hơn, nếu như tập tin không có sự thay đổi nào, Git không lưu trữ tập tin đó lại một lần nữa mà chỉ tạo một liên kết tới tập tin gốc đã tồn tại trước đó. Git thao tác với dữ liệu giống như Hình 1-5.

Insert 18333fig0105.png
Hình 1-5. Git lưu trữ dữ liệu dưới dạng ảnh chụp của dự án theo thời gian.

Đây là sự khác biệt lớn nhất giữa Git và hầu hết các VCS khác. Nó khiến Git cân nhắc lại hầu hết các khía cạnh của quản lý phiên bản mà phần lớn các hệ thống khác chỉ áp dụng lại từ các thế hệ trước. Chính lý do này làm cho Git giống như một hệ thống quản lý tập tin thu nhỏ với các tính năng, công cụ vô cùng mạnh mẽ được xây dựng dựa trên nó, không  chỉ là một hệ thống quản lý phiên bản đơn giản. Chúng ta sẽ khám phá một số lợi ích đạt được từ việc quản lý dữ liệu theo cách này khi bàn luận về Phân nhánh trong Git ở Chương 3.

### Phần Lớn Thao Tác Diễn Ra Cục Bộ ###

Phần lớn các thao tác/hoạt động trong Git chỉ cần yêu cầu các tập tin hay tài nguyên cục bộ - thông thường nó sẽ không cần bất cứ thông tin từ máy tính nào khác trong mạng lưới của bạn. Nếu như bạn quen với việc sử dụng các hệ thống quản lý phiên bản tập trung nơi mà đa số hoạt động đều chịu sự ảnh hưởng bởi độ trễ của mạng, thì với Git đó lại là một thế mạnh. Bởi vì toàn bộ dự án hoàn toàn nằm trên ổ cứng của bạn, các thao tác được thực hiện gần như ngay lập tức. 

Ví dụ, khi bạn muốn xem lịch sử của dự án, Git không cần phải lấy thông tin đó từ một máy chủ khác để hiển thị, mà đơn giản nó được đọc trực tiếp từ chính cơ sở dữ liệu cục bộ của bạn. Điều này có nghĩa là bạn có thể xem được lịch sử thay đổi của dự án gần như ngay lập tức. Nếu như bạn muốn so sánh sự thay đổi giữa phiên bản hiện tại của một tập tin với phiên bản của một tháng trước, Git có thể tìm kiếm tập tin cũ đó trên máy cục bộ rồi sau đó so sánh sự khác biệt cho bạn. Thay vì việc phải truy vấn từ xa hoặc "kéo về" (pull) phiên bản cũ của tập tin đó từ máy chủ trung tâm rồi mới thực hiện so sánh cục bộ.

Điều này còn đồng nghĩa với có rất ít việc mà bạn không thể làm được khi không có kết nối Internet hoặc VPN bị ngắt. Nếu bạn muốn làm việc ngay cả khi ở trên máy bay hoặc trên tầu, bạn vẫn có thể commit bình thường cho tới khi có kết nối Internet để đồng bộ hoá. Nếu bạn đang ở nhà mà VPN lại không thể kết nối được, bạn cũng vẫn có thể làm việc bình thường. Trong rất nhiều hệ thống khác, việc này gần như là không thể hoặc rất khó khăn. Ví dụ trong Perforce, bạn gần như không thể làm gì nếu như không kết nối được tới máy chủ; trong Subversion và CVS, bạn có thể sửa tập tin nhưng bạn không thể commit các thay đổi đó vào cơ sở dữ liệu (vì cơ sở dữ liệu của bạn không được kết nối). Đây có thể không phải là điều gì đó lớn lao, nhưng bạn sẽ ngạc nhiên về sự thay đổi lớn mà nó có thể làm được.

### Git Mang Tính Toàn Vẹn ###

Mọi thứ trong Git được "băm" (checksum or hash) trước khi lưu trữ và được tham chiếu tới bằng mã băm đó. Có nghĩa là việc thay đổi nội dung của một tập tin hay một thư mục mà Git không biết tới là điều không thể. Chức năng này được xây dựng trong Git ở tầng thấp nhất và về mặt triết học được coi là toàn vẹn. Bạn không thể mất thông tin/dữ liệu trong khi truyền tải hoặc nhận về một tập tin bị hỏng mà Git không phát hiện ra. 

Cơ chế mà Git sử dụng cho việc băm này được gọi là mã băm SHA-1. Đây là một chuỗi được tạo thành bởi 40 ký tự của hệ cơ số 16 (0-9 và a-f) và được tính toán dựa trên nội dung của tập tin hoặc cấu trúc thư mục trong Git. Một mã băm SHA-1 có định dạng như sau:

	24b9da6552252987aa493b52f8696cd6d3b00373

Bạn sẽ thấy các mã băm được sử dụng ở mọi nơi trong Git. Thực tế, Git không sử dụng tên của các tập để lưu trữ mà bằng các mã băm từ nội dung của tập tin vào một cơ sở dữ liệu có thể truy vấn được.

### Git Chỉ Thêm Mới Dữ Liệu ###

Khi bạn thực hiện các hành động trong Git, phần lớn tất cả hành động đó đều được thêm vào cơ sở dữ liệu của Git. Rất khó để yêu cầu hệ thống thực hiện một hành động nào đó mà không thể khôi phục lại được hoặc xoá dữ liệu đi dưới mọi hình thức. Giống như trong các VCS khác, bạn có thể mất hoặc làm rối tung dữ liệu mà bạn chưa commit; nhưng khi bạn đã commit thì rất khó để mất các dữ liệu đó, đặc biệt là nếu bạn thường xuyên đẩy (push) cơ sở dữ liệu sang một kho chứa khác.

Điều này khiến việc sử dụng Git trở nên thích thú bởi vì chúng ta biết rằng chúng ta có thể thử nghiệm mà không lo sợ sẽ phá hỏng mọi thứ. Để có thể hiểu sâu hơn việc Git lưu trữ dữ liệu như thế nào hay làm sao để khôi phục lại dữ liệu có thể đã mất, xem Chương 9.

### Ba Trạng Thái ###

Bây giờ, hãy chú ý. Đây là điều quan trọng cần ghi nhớ về Git nếu như bạn muốn hiểu được những phần tiếp theo một cách trôi chảy. Mỗi tập tin trong Git được quản lý dựa trên ba trạng thái: committed, modified, và staged. Committed có nghĩa là dữ liệu đã được lưu trữ một cách an toàn trong cơ sở dữ liệu. Modified có nghĩa là bạn đã thay đổi tập tin nhưng chưa commit vào cơ sở dữ liệu. Và staged là bạn đã đánh dấu sẽ commit phiên bản hiện tại của một tập tin đã chỉnh sửa trong lần commit sắp tới.

Điều này tạo ra ba phần riêng biệt của một dự án sử dụng Git: thư mục Git, thư mục làm việc, và khu vực tổ chức (staging area).

Insert 18333fig0106.png
Hình 1-6. Thư mục làm việc, khu vực khán đài, và thư mục Git.

Thư mục Git là nơi Git lưu trữ các "siêu dữ kiện" (metadata) và cơ sở dữ liệu cho dự án của bạn. Đây là phần quan trọng nhất của Git, nó là phần được sao lưu về khi bạn tạo một bản sao (clone) của một kho chứa từ một máy tính khác.

Thư mục làm việc là bản sao một phiên bản của dự án. Những tập tin này được kéo về (pulled) từ cơ sở dữ liệu được nén lại trong thư mục Git và lưu trên ổ cứng cho bạn sử dụng hoặc chỉnh sửa.

Khu vực khán đài là một tập tin đơn giản được chứa trong thư mục Git, nó chứa thông tin về những gì sẽ được commit trong lần commit sắp tới. Nó còn được biết đến với cái tên "chỉ mục" (index), nhưng khu vực tổ chức (staging area) đang dần được coi là tên tiêu chuẩn.

Tiến trình công việc (workflow) cơ bản của Git:

1. Bạn thay đổi các tập tin trong thư mục làm việc.
2. Bạn tổ chức các tập tin, tạo mới ảnh của các tập tin đó vào khu vực tổ chức.
3. Bạn commit, ảnh của các tập tin trong khu vực tổ chức sẽ được lưu trữ vĩnh viễn vào thư mục Git.

Nếu một phiên bản nào đó của một tập tin ở trong thư mục Git, nó được coi là đã commit. Nếu như nó đã được sửa và thêm vào khu vực tổ chức, nghĩa là nó đã được staged. Và nếu nó được thay đổi từ khi checkout nhưng chưa được staged, nó được coi là đã thay đổi. Trong Chương 2, bạn sẽ được tìm hiểu kỹ hơn về những trạng thái này cũng như làm thế nào để tận dụng lợi thế của chúng hoặc bỏ qua hoàn toàn giai đoạn tổ chức (staged).

## Cài Đặt Git ##

Hãy bắt đầu một chút vào việc sử dụng Git. Việc đầu tiên bạn cần phải làm là cài đặt nó. Có nhiều cách để thực hiện; hai cách chính đó là cài đặt từ mã nguồn hoặc cài đặt từ một gói có sẵn dựa trên hệ điều hành hiện tại của bạn.

### Cài Đặt Từ Mã Nguồn ###

Sẽ hữu ích hơn nếu bạn có thể cài đặt Git từ mã nguồn, vì bạn sẽ có được phiên bản mới nhất. Mỗi phiên bản của Git thường bao gồm nhiều cải tiến hữu ích về giao diện người dùng, vì thế cài đặt phiên bản mới nhất luôn là cách tốt nhất nếu như bạn quen thuộc với việc biên dịch phần mềm từ mã nguồn. Đôi khi nhiều phiên bản của Linux sử dụng các gói (package) rất cũ; vì thế trừ khi bạn đang sử dụng phiên bản mới nhất của Linux hoặc thường xuyên cập nhật, cài đặt từ mã nguồn có thể nói là sự lựa chọn tốt nhất.

Để cài đặt được Git, bạn cần có các thư viện mà Git sử dụng như sau: curl, zlib, openssl, expat, và libiconv. Ví dụ như bạn đang sử dụng một hệ điều hành có sử dụng yum (như Fedora) hoặc apt-get (như các hệ điều hành xây dựng trên nền Debian), bạn có thể sử dụng một trong các lệnh sau để cài đặt tất cả các thư viện cần thiết:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev libssl-dev

Khi đã cài đặt xong tất cả các thư viện cần thiết, bước tiếp theo là tải về phiên bản mới nhất của Git từ website của nó:

	http://git-scm.com/download

Sau đó, dịch và cài đặt:

	$ tar -zxf git-1.7.2.2.tar.gz
	$ cd git-1.7.2.2
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

Sau khi thực hiện xong các bước trên, bạn cũng có thể tải về các bản cập nhật của Git dùng chính nó như sau:

	$ git clone git://git.kernel.org/pub/scm/git/git.git

### Cài Đặt Trên Linux ###

Nếu như bạn muốn cài đặt Git trên Linux thông qua một chương trình cài đặt, bạn có thể làm việc này thông qua phần mềm quản lý các gói cơ bản đi kèm với hệ điều hành của bạn. Nếu bạn đang sử dụng Fedora, bạn có thể dùng yum:

	$ yum install git-core

Còn nếu bạn đang sử dụng một hệ điều hành dựa trên nhân Debian như Ubuntu, hãy dùng apt-get:

	$ apt-get install git

### Cài Đặt Trên Mac ###

Có hai cách đơn giản để cài đặt Git trên Mac. Cách đơn giản nhất là sử dụng chương trình cài đặt có hỗ trợ giao diện, bạn có thể tải về từ trang web của SourceForge (xem Hình 1-7):

	http://sourceforge.net/projects/git-osx-installer/

Insert 18333fig0107.png
Hình 1-7. Chương trình cài đặt Git cho Mac OS X.

Cách khác để cài đặt Git là thông qua MacPorts (`http://www.macports.org`). Nếu như bạn đã cài đặt MacPorts, Git có thể được cài đặt sử dụng lệnh sau:

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

Bạn không phải cài đặt các thư viện đi kèm, nhưng có lẽ bạn muốn cài đặt thêm +svn trong trường hợp sử dụng chung Git với Subversion (xem Chương 8).

### Cài Đặt Trên Windows ###

Cài đặt Git trên Windows rất đơn giản. Dự án msysGit cung cấp một cách cài đặt Git dễ dàng hơn. Đơn giản chỉ tải về tập tin cài đặt định dạng exe từ Github, và chạy:

	http://msysgit.github.com/

Sau khi nó được cài đặt, bạn có cả hai phiên bản: command-line (bao gồm SSH) và bản giao diện chuẩn.

Chú ý khi sử dụng trên Windows: bạn nên dùng Git bằng công cụ có sẵn: msysGit shell (kiểu Unix), nó cho phép bạn sử dụng các lệnh phức tạp trong sách này. Vì lý do nào đó, bạn muốn sử dụng cửa sổ dòng lệnh chuẩn của Windows: Windows shell, bạn bản sử dụng nháy kép thay vì nháy đơn (cho các tham số đầu vào có bao gồm dấu cách) và bạn phải dùng dấu mũ (^) cho tham số nếu chúng kéo dài đến cuối dòng, vì nó là ký tự tiếp diễn trong Windows.

## Cấu Hình Git Lần Đầu ##

Bây giờ Git đã có trên hệ thống, bạn muốn tuỳ biến một số lựa chọn cho môi trường Git của bạn. Bạn chỉ phải thực hiện các bước này một lần duy nhất; chúng sẽ được ghi nhớ qua các lần cập nhật. Bạn cũng có thể thay đổi chúng bất kỳ lúc nào bằng cách chạy lại các lệnh.

Git cung cấp sẵn git config cho phép bạn xem hoặc chỉnh sửa các biến cấu hình để quản lý toàn bộ các khía cạnh của Git như giao diện hay hoạt động. Các biến này có thể được lưu ở ba vị trí khác nhau:

*	`/etc/gitconfig` : Chứa giá trị cho tất cả người dùng và kho chứa trên hệ thống. Nếu bạn sử dụng ` --system` khi chạy `git config`, thao tác đọc và ghi sẽ được thực hiện trên tập tin này.
*	`~/.gitconfig` : Riêng biệt cho tài khoản của bạn. Bạn có thể chỉ định Git đọc và ghi trên tập tin này bằng cách sử dụng ` --global`.
*	tập tin config trong thư mục git (`.git/config`) của bất kỳ kho chứa nào mà bạn đang sử dụng: Chỉ áp dụng riêng cho một kho chứa. Mỗi cấp sẽ ghi đè các giá trị của cấp trước nó, vì thế các giá trị trong `.git/config` sẽ "chiến thắng" các giá trị trong `/etc/gitconfig`.

Trên Windows, Git sử dụng tập tin `.gitconfig` trong thư mục `$HOME` (`%USERPROFILE%` trên môi trường Windows), cụ thể hơn đó là `C:\Documents and Settings\$USER` hoặc `C:\Users\$USER`, tuỳ thuộc vào phiên bản Windows đang sử dụng (`$USER` là `%USERNAME%` trên môi trường Windows). Nó cũng tìm kiếm tập tin /etc/gitconfig, mặc dù nó đã được cấu hình sẵn chỉ đến thư mục gốc của MSys, có thể là một thư mục bất kỳ, nơi bạn chọn khi cài đặt.

### Danh Tính Của Bạn ###

Việc đầu tiên bạn nên làm khi cấu hình Git là chỉ định tên tài khoản và địa chỉ e-mail. Điều này rất quan trọng vì mỗi Git sẽ sử dụng chúng cho mỗi lần commit, những thông tin này được gắn bất di bất dịch vào các commit:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Tôi xin nhắc lại là bạn chỉ phải làm việc này một lần duy nhất nếu như sử dụng `--global`, vì Git sẽ sử dụng các thông tin đó cho tất cả những gì bạn làm trên hệ thống. Nếu bạn muốn sử dụng tên và địa chỉ e-mail khác cho một dự án riêng biệt nào đó, bạn có thể chạy lại lệnh trên không sử dụng `--global` trên dự án đó.

### Trình Soạn Thảo ###

Bây giờ danh tính của bạn đã được cấu hình xong, bạn có thể lựa chọn trình soạn thảo mặc định sử dụng để soạn thảo các dòng lệnh. Mặc định, Git sử dụng trình soạn thảo mặc địch của hệ điều hành, thường là Vi hoặc Vim. Nếu bạn muốn sử dụng một trình soạn thảo khác, như Emacs, bạn có thể sửa như sau:

	$ git config --global core.editor emacs

### Công Cụ So Sánh Thay Đổi ###

Một lựa chọn hữu ích khác mà bạn có thể muốn thay đổi đó là chương trình so sánh sự thay đổi để giải quyết các trường hợp xung đột nội dung. Ví dụ bạn muốn sử dụng vimdiff:

	$ git config --global merge.tool vimdiff

Git chấp nhận kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge, và opendiff là các công cụ trộn/sát nhập (merge) hợp lệ. Bạn cũng có thể sử dụng một công cụ yêu thích khác; xem hướng dẫn ở Chương 7.

### Kiểm Tra Cấu Hình ###

Nếu như bạn muốn kiểm tra các cấu hình cài đặt, bạn có thể sử dụng lệnh `git config --list` để liệt kê tất cả các cài đặt của Git:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

Bạn có thể thấy các từ khoá xuất hiện nhiều hơn một lần, bởi vì Git đọc chúng từ các tập tin khác nhau (ví dụ, `/etc/gitconfig` và `~/.gitconfig`). Trong trường hợp này Git sử dụng giá trị xuất hiện cuối cùng cho mỗi từ khoá duy nhất.

Bạn cũng có thể kiểm tra giá trị của một từ khoá riêng biệt nào đó bằng cách sử dụng `git config {key}`:

	$ git config user.name
	Scott Chacon

## Trợ Giúp ##

Nếu bạn cần sự giúp đỡ khi sử dụng Git, có ba cách để hiển thị tài liệu hướng dẫn (manpage) cho bất kỳ câu lệnh Git nào:

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

Ví dụ, bạn có thể hiển thị hướng dẫn cho câu lệnh config bằng cách chạy:

	$ git help config

Những lệnh này rất thuận tiện và hữu ích vì bạn có thể sử dụng chúng mọi nơi, ngay cả khi không có kết nối Internet.
Nếu các tài liệu hướng dẫn và cuốn sách này chưa đủ, bạn vẫn cần thêm người trợ giúp, hãy thử sử dụng kênh `#git` hoặc `#github` trên Freenode IRC server (irc.freenode.net). Những kênh này thường xuyên thu hút hàng trăm người có kiến thức rất tốt về Git và họ luôn sẵn lòng giúp đỡ.

## Tóm Tắt ##

Bạn đã có kiến thức cơ bạn về Git là gì và chúng khác các CVCS (hệ thống quản lý phiên bản/mã nguồn tập trung) mà bạn đã, đang sử dụng như thế nào. Bạn cũng đã có một phiên bản hoạt động tốt của Git được cấu hình với danh tính cá nhân trên máy tính của bạn. Và đã đến lúc để học một số kiến thức cơ bản về Git.