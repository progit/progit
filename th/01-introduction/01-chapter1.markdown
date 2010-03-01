# เริ่มต้นใช้งาน #

ในบทนี้เราจะเริ่มเรียนรู้เกี่ยวกับการใช้งาน Git โดยจะเริ่มตั้งแต่จุดแรกสุดตั้งแต่อะไรคือเครื่องมือจัดการ version control จากนั้นจึงจะเริ่มอธิบายวิธีการติดตั้ง Git และสุดท้ายคือวิธีการตั้งค่าและเริ่มใช้งาน Git  ในช่วงท้ายบทคุณจะเข้าใจว่าทำไม Git ถึงถูกสร้างขึ้นมาและคุณจะได้ประโยชน์อะไรจากมันบ้าง

## เกี่ยวกับ Version Control ##

Version control คืออะไร และทำไมคุณถึงต้องแคร์? Version control คือ ระบบที่จัดเก็บการเปลี่ยนแปลงที่เกิดขึ้นกับไฟล์หนึ่งหรือหลายไฟล์เพื่อที่คุณสามารถเรียกเวอร์ชั่นใดเวอร์ชั่นหนึ่งกลับมาดูเมื่อไรก็ได้  หนังสือเล่มนี้จะยกตัวอย่างจากไฟล์ที่เป็นซอร์สโค้ดของซอฟต์แวร์ แต่ขอให้เข้าใจว่าจริง ๆ แล้วคุณสามารถใช้ version control กับไฟล์ชนิดใดก็ได้

ถ้าคุณเป็นนักออกแบบกราฟฟิคหรือเว็บดีไซเนอร์และต้องการเก็บทุกเวอร์ชั่นของรูปภาพหรือเลย์เอาต์ (ซึ่งคุณน่าจะอยากเก็บอยู่) การใช้ Version Control System (VCS) เป็นสิ่งที่ชาญฉลาดมาก เพราะมันช่วยให้คุณสามารถย้อนไฟล์บางไฟล์หรือแม้กระทั่งทั้งโปรเจคกลับไปเป็นเวอร์ชั่นเก่าได้ นอกจากนั้นระบบ VCS ยังจะช่วยให้คุณเปรียบเทียบการแก้ไขที่เกิดขึ้นในอดีต ดูว่าใครเป็นคนแก้ไขคนสุดท้ายที่อาจทำให้เกิดปัญหา แก้ไขเมื่อไร ฯลฯ และยังช่วยให้คุณสามารถกู้คืนไฟล์ที่คุณลบหรือทำเสียโดยไม่ตั้งใจได้อย่างง่ายดาย

### Version Control Systems แบบ Local ###

หลาย ๆ คนจัดเก็บประวัติการแก้ไขต่าง ๆ ด้วยมือโดยการคัดลอกไฟล์ไปไว้ในไดเร็คทอรี่ใหม่ (อาจจะเป็นไดเร็คทอรี่ที่มีชื่อเป็นวันเดือนปีและเวลาก็ได้) วิธีนี้เป็นวิธีที่ใช้กันโดยแพร่หลายเพราะว่าทำได้ง่ายแต่ในขณะเดียวกันก็เป็นวิธีที่เกิดข้อผิดพลาดได้ง่ายเช่นกัน ยกตัวอย่างเช่น คุณอาจไม่ทันดูว่าตอนนี้คุณอยู่ในไดเร็คทอรี่ไหนและเผลอเขียนทับไฟล์ที่คุณไม่น่าจะเขียนทับหรือทำการคัดลอกไฟล์ที่คุณไม่น่าจะคัดลอก

เพื่อที่จะลดปัญหาเหล่านี้ เมื่อนานมาแล้วโปรแกรมเมอร์ได้พัฒนาระบบ VCS ที่ใช้ในเครื่องของตัวเองโดยใช้ฐานข้อมูลง่าย ๆ เพื่อเก็บการแก้ไขทั้งหมดที่เกิดขึ้นกับไฟล์ที่อยู่ภายใต้ revision control (ดูรูป 1-1)

Insert 18333fig0101.png 
รูป 1-1. ระบบ version control แบบ local

หนึ่งในเครื่องมือ VCS ที่ใช้กันมากทั้งในอดีตและปัจจุบันคือระบบที่เรียกว่า rcs  แม้แต่ระบบปฏิบัติการ Mac OS X ก็ยังติดตั้ง rcs ให้เมื่อคุณติดตั้ง Developer Tools  เครื่องมือนี้ทำงานโดยเก็บสิ่งที่เรียกว่า patch set (ซึ่งก็คือผลต่างของไฟล์แต่ละไฟล์) สำหรับการแก้ไขแต่ละครั้งในรูปแบบพิเศษในเครื่อง ทำให้มันสามารถเรียกคืนไฟล์ ณ ช่วงเวลาใดขึ้นมาดูก็ได้โดยการไล่เรียงไปตาม patch ที่มี

### ระบบ Version Control Systems แบบรวมศูนย์ ###

ปัญหาถัดไปที่คนใช้พบก็คือการร่วมมือกันกับนักพัฒนาคนอื่น ๆ เพื่อที่จะแก้ปัญหานี้เครื่องมือใหม่จีงได้ถูกพัฒนาขึ้นมา เรียกว่าระบบ Centralized Version Control Systems (CVCSs) หรือระบบ Version Control Systems แบบรวมศูนย์  ระบบเหล่านี้ เช่น CVS, Subversion และ Perforce มีเซิร์ฟเวอร์กลางที่เก็บไฟล์ทั้งหมดไว้ในที่เดียวและผู้ใช้หลาย ๆ คนสามารถต่อเข้ามาเพื่อดึงไฟล์จากศูนย์กลางนี้ไปแก้ไขได้ ระบบการทำงานแบบรวมศูนย์นี้ได้ถูกนำมาใช้เป็นเวลานานหลายปี (ดูรูป 1-2)

Insert 18333fig0102.png 
รูป 1-2. ระบบ version control แบบรวมศูนย์

การทำงานแบบนี้มีประโยชน์เหนือ local VCS ในหลายด้าน เช่น ทุกคนสามารถรู้ได้ว่าคนอื่นในโปรเจคกำลังทำอะไร ผู้ควบคุมระบบสามารถควบคุมได้อย่างละเอียดว่าใครสามารถแก้ไขอะไรได้บ้าง การจัดการแบบรวมศูนย์ในที่เดียวทำได้ง่ายกว่าการจัดการฐานข้อมูลใน client แต่ละเครื่องเยอะ

แต่ระบบแบบนี้ก็มีจุดอ่อนเหมือนกัน ตรงที่การรวมศูนย์ทำให้มันเป็นจุดอ่อนจุดเดียวที่จะล่มได้เหมือนกันเพราะทุกอย่างรวมกันอยู่ที่เซิร์ฟเวอร์ที่เดียว ถ้าเซิร์ฟเวอร์นั้นล่มซักชั่วโมงนึง หมายความว่าในชั่วโมงนั้นไม่มีใครสามารถทำงานร่วมกันหรือบันทึกการเปลี่ยนแปลงงานที่กำลังทำอยู่ไปที่เซิร์ฟเวอร์ได้เลย หรือถ้าฮาร์ดดิสก์ของเซิร์ฟเวอร์เกิดเสียขึ้นมาและไม่มีการสำรองข้อมูลเอาไว้ คุณก็จะสูญเสียข้อมูลประวัติและทุกอย่างที่มี จะเหลือก็แค่ก๊อปปี้ของงานบนเครื่องแต่ละเครื่องเท่านั้นเอง

### ระบบ Version Control Systems แบบกระจายศูนย์ ###

นี่คือที่มาของ Distributed Version Control Systems (DVCSs) หรือระบบ VCS แบบกระจายศูนย์  ในระบบแบบนี้ (เช่น Git, Mercurial, Bazaar หรือ Darcs) แต่ละคนไม่เพียงได้ก๊อปปี้ล่าสุดของไฟล์เท่านั้น แต่ได้ทั้งก๊อปปี้ของ repository เลย หมายความว่าถึงแม้ว่าเซิร์ฟเวอร์จะเสีย client ก็ยังสามารถทำงานร่วมกันได้ต่อไป และ repository เหล่านี้ของ client ยังสามารถถูกก๊อปปี้กลับไปที่เซิร์ฟเวอร์เพื่อกูข้อมูลกลับคืนก็ได้ การ checkout แต่ละครั้งคือการทำสำรองข้อมูลทั้งหมดแบบเต็ม ๆ นั่นเอง (ดูรูป 1-3)

Insert 18333fig0103.png 
รูป 1-3. ระบบ version control แบบกระจายศูนย์

นอกจากนั้นระบบเหล่านี้ยังทำงานกับหลาย ๆ repository ได้อย่างดี ทำให้คุณสามารถทำงานกับคนหลายกลุ่มซึ่งทำงานในรูปแบบต่างกันในโปรเจคเดียวกันได้อย่างง่ายดาย เนื่องจากระบบเหล่านี้สนับสนุนการทำงานได้หลากหลายรูปแบบ ซึ่งอาจทำได้ยากในระบบแบบรวมศูนย์

## ประวัติย่อของ Git ##

เช่นเดียวกันกับหลายสิ่งในชีวิตที่ยิ่งใหญ่ Git เริ่มต้นจากส่วนผสมของความคิดริเริ่มที่สั่นคลอนสถานะปัจจุบันเล็กน้อยแต่ทำให้เกิดผลกระทบในวงกว้าง  โปรเจคลีนุกซ์เคอร์เนล (Linux kernel) ถือเป็นซอฟต์แวร์แบบโอเพนซอร์สที่มีขนาดค่อนข้างใหญ่ ในช่วงปี 1991-2002 การพัฒนาเคอร์เนลถูกแชร์กันไปมาผ่าน patch และไฟล์ซอร์สโค้ดที่ถูกบีบอัด จากนั้นในปี 2002 ก็มีการเริ่มนำเครื่องมือ DVCS ที่ไม่ใช่โอเพนซอร์สชื่อ BitKeeper มาใช้งาน

ในปี 2005 ความสัมพันธ์ระหว่าง community ที่พัฒนาลีนุกซ์เคอร์เนลและบริษัทที่พัฒนา BitKeeper มีอันต้องจบลง และการใช้งานเครื่องมือนี้แบบฟรีก็ถูกยกเลิกไป ทำให้นักพัฒนาทั้งหลาย (โดยเฉพาะอย่างยิ่งไลนัส ทอร์วอลด์ ผู้สร้างลีนุกซ์) ต้องพัฒนาเครื่องมือของตัวเองขึ้นมาจากประสบการณ์ที่่มีอยู่ระหว่างการใช้งาน BitKeeper โดยมีวัตถุประสงค์ดังนี้:

*	ความเร็ว
*	ดีไซน์ที่เรียบง่าย
*	สนับสนุนการทำงานหลายทางพร้อม ๆ กัน (เช่นมี branch การพัฒนาเป็นพัน)
*	แยกศูนย์
*	สามารถรองรับโปรเจคขนาดใหญ่อย่างลีนุกซ์เคอร์เนลได้เป็นอย่างดี (ทั้งในแง่ความเร็วและขนาดของข้อมูล)

ตั้งแต่เริ่มต้นเมื่อปี 2005 Git ได้ถูกทำให้ใช้งานง่ายขึ้นแต่ก็ยังคงความสามารถตามวัตถุประสงค์เดิมเอาไว้ โดยสามารถทำงานได้เร็วเหลือเชื่อ ใช้พื้นที่น้อยสำหรับโปรเจคใหญ่ ๆ และก็มีระบบการ branch ที่สนับสนุนการทำงานหลายทางพร้อม ๆ กัน (ดูบทที่ 3)

## Git ขั้นพื้นฐาน ##

แล้วสรุปสั้น ๆ ได้ว่า Git คืออะไรล่ะ? ส่วนนี้เป็นส่วนสำคัญที่คุณต้องพยายามทำความเข้าใจเพราะถ้าคุณเข้าใจว่า Git คืออะไรและทำงานอย่างไร คุณจะสามารถใช้งาน Git ได้อย่างมีประสิทธิภาพและง่ายดายมาก เวลาคุณเรียนรู้ Git ให้พยายามลืมสิ่งต่าง ๆ ที่คุณอาจจะรู้อยู่แล้วจาก VCS อื่น ๆ เช่น Subversion หรือ Perforce เพราะคุณอาจสับสนคอนเซ็ปต์จากเครื่องมือเหล่านั้นได้ เหตุผลก็เพราะ Git เก็บและมองข้อมูล่างจากระบบอื่น ๆ เป็นอย่างมากถึงแม้ว่าจะทำงานคล้ายกันก็ตาม

### เก็บ Snapshot แทนผลต่าง ###

ความแตกต่างมากที่สุดระหว่าง Git และ VCS อื่น ๆ (เช่น Subversion และผองเพื่อน) คือ วิธีที่ Git มองข้อมูลต่าง ๆ  โดยทั่วไประบบอื่นมักจะเก็บข้อมูลในรูปแบบของการแก้ไขที่เกิดขึ้นกับไฟล์ต่าง ๆ  ระบบเหล่านี้ (เช่น CVS, Subversion, Perforce, Bazaar, ฯลฯ) จะมองข้อมูลในรูปแบบของไฟล์และการแก้ไขต่าง ๆ ที่เกิดขึ้นกับไฟล์แต่ละไฟล์ ดังเช่นในรูปที่ 1-4

Insert 18333fig0104.png 
รูปที่ 1-4. ระบบอื่น ๆ มักจะเก็บข้อมูลโดยอิงกับการแก้ไขที่เกิดขึ้นกับไฟล์

Git doesn’t think of or store its data this way. Instead, Git thinks of its data more like a set of snapshots of a mini filesystem. Every time you commit, or save the state of your project in Git, it basically takes a picture of what all your files look like at that moment and stores a reference to that snapshot. To be efficient, if files have not changed, Git doesn’t store the file again—just a link to the previous identical file it has already stored. Git thinks about its data more like Figure 1-5. 

Insert 18333fig0105.png 
รูปที่ 1-5. Git เก็บข้อมูลเป็น snapshot ของโปรเจค

This is an important distinction between Git and nearly all other VCSs. It makes Git reconsider almost every aspect of version control that most other systems copied from the previous generation. This makes Git more like a mini filesystem with some incredibly powerful tools built on top of it, rather than simply a VCS. We’ll explore some of the benefits you gain by thinking of your data this way when we cover Git branching in Chapter 3.

### การทำงานเกือบทุกอย่างเป็นการทำงานในเครื่องตัวเอง ###

Most operations in Git only need local files and resources to operate – generally no information is needed from another computer on your network.  If you’re used to a CVCS where most operations have that network latency overhead, this aspect of Git will make you think that the gods of speed have blessed Git with unworldly powers. Because you have the entire history of the project right there on your local disk, most operations seem almost instantaneous.

For example, to browse the history of the project, Git doesn’t need to go out to the server to get the history and display it for you—it simply reads it directly from your local database. This means you see the project history almost instantly. If you want to see the changes introduced between the current version of a file and the file a month ago, Git can look up the file a month ago and do a local difference calculation, instead of having to either ask a remote server to do it or pull an older version of the file from the remote server to do it locally.

This also means that there is very little you can’t do if you’re offline or off VPN. If you get on an airplane or a train and want to do a little work, you can commit happily until you get to a network connection to upload. If you go home and can’t get your VPN client working properly, you can still work. In many other systems, doing so is either impossible or painful. In Perforce, for example, you can’t do much when you aren’t connected to the server; and in Subversion and CVS, you can edit files, but you can’t commit changes to your database (because your database is offline). This may not seem like a huge deal, but you may be surprised what a big difference it can make.

### Git Has Integrity ###

Everything in Git is check-summed before it is stored and is then referred to by that checksum. This means it’s impossible to change the contents of any file or directory without Git knowing about it. This functionality is built into Git at the lowest levels and is integral to its philosophy. You can’t lose information in transit or get file corruption without Git being able to detect it.

The mechanism that Git uses for this checksumming is called a SHA-1 hash. This is a 40-character string composed of hexadecimal characters (0–9 and a–f) and calculated based on the contents of a file or directory structure in Git. A SHA-1 hash looks something like this:

	24b9da6552252987aa493b52f8696cd6d3b00373

You will see these hash values all over the place in Git because it uses them so much. In fact, Git stores everything not by file name but in the Git database addressable by the hash value of its contents.

### Git Generally Only Adds Data ###

When you do actions in Git, nearly all of them only add data to the Git database. It is very difficult to get the system to do anything that is not undoable or to make it erase data in any way. As in any VCS, you can lose or mess up changes you haven’t committed yet; but after you commit a snapshot into Git, it is very difficult to lose, especially if you regularly push your database to another repository.

This makes using Git a joy because we know we can experiment without the danger of severely screwing things up. For a more in-depth look at how Git stores its data and how you can recover data that seems lost, see “Under the Covers” in Chapter 9.

### The Three States ###

Now, pay attention. This is the main thing to remember about Git if you want the rest of your learning process to go smoothly. Git has three main states that your files can reside in: committed, modified, and staged. Committed means that the data is safely stored in your local database. Modified means that you have changed the file but have not committed it to your database yet. Staged means that you have marked a modified file in its current version to go into your next commit snapshot.

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

## การติดตั้ง Git ##

ก่อนที่จะใช้งานคุณคงต้องติดตั้ง Git ก่อน โดยคุณสามารถทำได้หลายวิธี วิธีหลักสองวิธีคือติดตั้งจากซอร์สโค้ดหรือติดตั้งจากแพคเกจที่มีอยู่แล้วสำหรับระบบปฏิบัติการของคุณ

### ติดตั้งจากซอร์สโค้ด ###

ถ้าเป็นไปได้เราขอแนะนำให้คุณติดตั้ง Git โดยการคอมไพล์โปรแกรมจากซอร์สโค้ด เพราะคุณจะได้ใช้เวอร์ชั่นล่าสุดซึ่งมักจะมาพร้อมกับการปรับปรุงอยู่เสมอ อีกเหตุผลหนึ่งก็คือแพคเกจที่มากับลีนุกซ์หลายรุ่นเป็นแพคเกจเวอร์ชั่นเก่ามาก ถ้าคุณไม่ได้ใช้ลีนุกซ์รุ่นล่าสุดหรือใช้ backport การติดตั้งจากซอร์สโค้ดน่าจะเป็นทางเลือกที่ดีที่สุด

ก่อนอื่นคุณต้องเตรียม library ที่จำเป็นเสียก่อน คือ curl, zlib, openssl, expat และ libiconv โดยคุณสามารถใช้ yum (ถ้าคุณใช้ Fedora) หรือ apt-get (ถ้าคุณใช้ระบบแบบ Debian) เพื่อติดตั้ง:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev

หลังจากที่ติดตั้งโปรแกรมที่จำเป็นแล้วก็ถึงเวลาดาวน์โหลดเวอร์ชั่นล่าสุดของ Git โดยใช้คำสั่ง:	

	http://git-scm.com/download
	
จากนั้นก็คอมไพล์และติดตั้ง:

	$ tar -zxf git-1.6.0.5.tar.gz
	$ cd git-1.6.0.5
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

หลังจากติดตั้งเรียบร้อยคุณสามารถดึงซอร์สโค้ดของ Git มาเพื่ออัดเกรดได้โดยใช้ตัวโปรแกรม Git เอง:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	
### การติดตั้งบนลีนุกซ์ ###

ถ้าคุณต้องการติดตั้ง Git บนลีนุกซ์โดยใช้แพคเกจสำเร็จรูป คุณสามารถใช้ระบบจัดการแพคเกจที่มากับระบบปฏิบัติการของคุณได้เลย เช่น ถ้าคุณใช้ Fedora คุณสามารถติดตั้งผ่าน yum โดยใช้คำสั่ง:

	$ yum install git-core

หรือถ้าคุณใช้ระบบแบบ Debian อย่าง Ubuntu คุณสามารถติดตั้งผ่าน apt-get ได้:

	$ apt-get install git-core

### การติดตั้งบนแมค ###

There are two easy ways to install Git on a Mac. The easiest is to use the graphical Git installer, which you can download from the Google Code page (see Figure 1-7):

	http://code.google.com/p/git-osx-installer

Insert 18333fig0107.png 
Figure 1-7. Git OS X installer.

The other major way is to install Git via MacPorts (`http://www.macports.org`). If you have MacPorts installed, install Git via

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

You don’t have to add all the extras, but you’ll probably want to include +svn in case you ever have to use Git with Subversion repositories (see Chapter 8).

### Installing on Windows ###

Installing Git on Windows is very easy. The msysGit project has one of the easier installation procedures. Simply download the installer exe file from the Google Code page, and run it:

	http://code.google.com/p/msysgit

After it’s installed, you have both a command-line version (including an SSH client that will come in handy later) and the standard GUI.

## First-Time Git Setup ##

Now that you have Git on your system, you’ll want to do a few things to customize your Git environment. You should have to do these things only once; they’ll stick around between upgrades. You can also change them at any time by running through the commands again.

Git comes with a tool called git config that lets you get and set configuration variables that control all aspects of how Git looks and operates. These variables can be stored in three different places:

*	`/etc/gitconfig` file: Contains values for every user on the system and all their repositories. If you pass the option` --system` to `git config`, it reads and writes from this file specifically. 
*	`~/.gitconfig` file: Specific to your user. You can make Git read and write to this file specifically by passing the `--global` option. 
*	config file in the git directory (that is, `.git/config`) of whatever repository you’re currently using: Specific to that single repository. Each level overrides values in the previous level, so values in `.git/config` trump those in `/etc/gitconfig`.

On Windows systems, Git looks for the `.gitconfig` file in the `$HOME` directory (`C:\Documents and Settings\$USER` for most people). It also still looks for /etc/gitconfig, although it’s relative to the MSys root, which is wherever you decide to install Git on your Windows system when you run the installer.

### Your Identity ###

The first thing you should do when you install Git is to set your user name and e-mail address. This is important because every Git commit uses this information, and it’s immutably baked into the commits you pass around:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Again, you need to do this only once if you pass the `--global` option, because then Git will always use that information for anything you do on that system. If you want to override this with a different name or e-mail address for specific projects, you can run the command without the `--global` option when you’re in that project.

### Your Editor ###

Now that your identity is set up, you can configure the default text editor that will be used when Git needs you to type in a message. By default, Git uses your system’s default editor, which is generally Vi or Vim. If you want to use a different text editor, such as Emacs, you can do the following:

	$ git config --global core.editor emacs
	
### Your Diff Tool ###

Another useful option you may want to configure is the default diff tool to use to resolve merge conflicts. Say you want to use vimdiff:

	$ git config --global merge.tool vimdiff

Git accepts kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge, and opendiff as valid merge tools. You can also set up a custom tool; see Chapter 7 for more information about doing that.

### Checking Your Settings ###

If you want to check your settings, you can use the `git config --list` command to list all the settings Git can find at that point:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

You may see keys more than once, because Git reads the same key from different files (`/etc/gitconfig` and `~/.gitconfig`, for example). In this case, Git uses the last value for each unique key it sees.

You can also check what Git thinks a specific key’s value is by typing `git config {key}`:

	$ git config user.name
	Scott Chacon

## Getting Help ##

If you ever need help while using Git, there are three ways to get the manual page (manpage) help for any of the Git commands:

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

For example, you can get the manpage help for the config command by running

	$ git help config

These commands are nice because you can access them anywhere, even offline.
If the manpages and this book aren’t enough and you need in-person help, you can try the `#git` or `#github` channel on the Freenode IRC server (irc.freenode.net). These channels are regularly filled with hundreds of people who are all very knowledgeable about Git and are often willing to help.

## สรุป ##

You should have a basic understanding of what Git is and how it’s different from the CVCS you may have been using. You should also now have a working version of Git on your system that’s set up with your personal identity. It’s now time to learn some Git basics.
