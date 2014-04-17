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

Git ไม่ได้มองและจัดเก็บข้อมูลในลักษณะนี้ แต่จะคิดว่าข้อมูลของมันเป็นเสมือนภาพถ่าย(snapshot)ของระบบไฟล์ขนาดเล็กๆ ทุกครั้งที่มีการ commit หรือบันทึกสถานะของโปรเจคลงใน Git มันจะทำการถ่ายภาพของไฟล์ทั้งหมดในตอนนั้นและบันทึกการอ้างอิงไปยัง snapshot นั้น เพื่อให้การจัดเก็บนั้นมีประสิทธิภาพ ถ้าไฟล์ใดที่ไม่ได้มีการเปลี่ยนแปลง Git ก็จะไม่บันทึกไฟล์นั้นอีกครั้ง เพียงแต่จะทำการเชื่อมโยงไปยังไฟล์เดิมที่เคยถูกบันทึกเอาไว้อยู่แล้ว Git จะมองข้อมูลดังรูปที่ 1-5

Insert 18333fig0105.png 
รูปที่ 1-5. Git เก็บข้อมูลเป็น snapshot ของโปรเจค

นี่คือความแตกต่างที่สำคัญระหว่าง Git กับ VCSs ตัวอื่นๆ มันทำให้ Git ทำได้เกือบทุกด้านของระบบ VCS อื่นๆ ซึ่งส่วนใหญ่ก็คัดลอกมาจากรุ่นก่อนๆ นี่ทำให้ Git เป็นเหมือนกับระบบไฟล์ขนาดเล็กที่มีเครื่องมือ(tools)อันทรงพลังอย่างน่าเหลือเชื่อครอบอยู่ แทนที่จะเป็น VCS แบบทั่วไป เราจะมาสำรวจข้อดีที่คุณจะได้รับจากแนวคิดแบบนี้เมื่อเรากล่าวถึงเรื่อง การแตกสาขา(Git branching) ในบทที่ 3

### การทำงานเกือบทุกอย่างเป็นการทำงานในเครื่องตัวเอง ###

การทำงานโดยส่วนใหญ่ของ Git จะใช้ไฟล์และทรัพยากรในเครื่องของเราเท่านั้น ปกติจะไม่มีข้อมูลใดๆ ที่จำเป็นต้องใช้จากคอมพิวเตอร์เครื่องอื่นๆ ในเน็ตเวิร์ก แต่หากคุณเคยใช้ CVCS อื่นที่การทำงานส่วนใหญ่ต้องใช้ข้อมูลบนเน็ตเวิร์กจำนวนมาก ในแง่นี้ก็จะทำให้คุณรู้สึกมีความสุขกับความเร็วในการทำงานของ Git เพราะว่าคุณจะมีประวัติการเปลี่ยนแปลงทั้งหมดของโปรเจคอยู่ในเครื่องของคุณอยู่แล้วและพร้อมที่จะทำงานได้ทันที

ตัวอย่างเช่น ถ้าจะดูประวัติย้อนหลังของโปรเจค Git ไม่จำเป็นที่จะต้องไปดึงข้อมูลจากเซิร์ฟเวอร์แล้วจึงแสดงผลให้คุณได้ มันแค่อ่านโดยตรงจากฐานข้อมูลในเครื่องของคุณ หมายความว่าคุณสามารที่จะดูประวัติของโปรเจคได้ทันที หากคุณจะดูความเปลี่ยนแปลงของไฟล์ในรุ่นปัจจุบันกับเมื่อหนึ่งเดือนที่แล้ว Git ก็สามารถค้นหาไฟล์เมื่อเดือนก่อนในเครื่องของเราแล้วทำการคำนวณความแตกต่าง แทนที่จะถามเครื่องเซิร์ฟเวอร์ให้ดึงไฟล์เก่ามาให้

ซึ่งก็มีโอกาสน้อยมากที่คุณไม่สามารถทำงานได้ถ้าหากออฟไลน์อยู่ หากคุณต้องเดินทางอยู่บนเครื่องหรือบนรถไฟและอยากจะทำงานสักหน่อย คุณก็สามารถ commit ได้อย่างมีความสุขจนกว่าจะเชื่อมต่อเน็ตเวิร์กได้แล้วอัพโหลด หากที่บ้านของคุณมีปัญหาเรื่องเน็ตเวิร์กคุณก็ยังคงทำงานได้ ถ้าเป็นระบบอื่นทำแบบนี้ไม่ได้แน่ และจะทำอะไรแทบจะไม่ได้เลยหากคุณเชื่อมต่อไปยังเซิร์ฟเวอร์ไม่ได้ ยิ่งในโปรแกรม Subversion และ CVS คุณสามารถแก้ไขไฟล์ต่างๆ ได้แต่จะไม่สามารถ commit ได้เพราะฐานข้อมูลมันออฟไล์อยู่ นี่อาจจะไม่ใช้เรื่องใหญ่อะไรแต่ก็ได้แต่คุณจะแปลกใจในความสามารถนี้ที่ Git ทำได้

### Git มีความเที่ยงตรง ###

ทุกอย่างที่ Git ทำการบันทึกเอาไว้จะถูกทำการ Checksum แล้วนำมาใช้เป็นตัวอ้างอิง นั่นทำให้ไม่มีทางที่เราจะแก้ไขข้อมูลของไฟล์และไดเร็กทอรี่ใดโดยที่ Git จะไม่รู้ ซึ่งฟังก์ชันนี้จะอยู่ในระดับล่างและเป็นหลักการของ Git คุณจะไม่มีทางที่จะทำข้อมูลสูญหายระหว่างการโยกย้ายหรือรับไฟล์ที่เสียหายโดย Git จะสามารถตรวจพบได้

กลไกที่ Git ใช้ในการทำ Checksum คือการแฮช(hash)แบบ SHA-1 ซึ่งผลลัพธ์จะได้ออกมาเป็นตัวอักษร 40 ตัวที่แทนเลขฐานสิบหก(0-9 และ a-f)จากการคำนวณเนื้อหาในไฟล์หรือโครงสร้างของไดเร็กทอรี่ของ Git ซึ่ง SHA-1 มีลักษณะดังนี้

	24b9da6552252987aa493b52f8696cd6d3b00373

คุณจะเห็นว่าผลของการแฮช(hash)เหล่านี้อยู่ในทุกที่ใน Git เพราะจะถูกใช้บ่อยครั้ง ซึ่งจริงๆแล้ว Git ไม่ได้เก็บบันทึกข้อมูลทุกอย่างตามชื่อไฟล์แต่เก็บในฐานข้อมูลของ Git แล้วสามารถอ้างถึงด้วยค่าแฮช(hash)ของข้อมูลของไฟล์

### Git เพียงแต่เพิ่มข้อมูล ###

เมื่อคุณกระทำอะไรสักอย่างใน Git เนื้อหาเกือบทั้งหมดนั้นก็จะถูกเพิ่มเข้าไปในฐานข้อมูลของ Git เท่านั้น มันเป็นเรื่องยากมากๆ ที่เราจะใช้ระบบที่ทำอะไรลงไปแล้วไม่สามารถย้อนคืนกลับมาได้หรือลบแล้วลบเลย เช่นเดียวกันกับ VCS ตัวอื่นๆ คุณสามารถสูญเสียข้อมูลหรือแก้ไขผิดพลาดได้โดยที่ยังไม่ทันได้ commit แต่ถ้าคุณ commit ลงใน snapshot ของ Git แล้วมันก็ยากที่จะสูญหายได้โดยเฉพาะอย่างยิ่งถ้าคุณทำการผลัก(push)ฐานข้อมูลของคุณไปไว้ที่อื่นๆ

สิ่งนี้ทำให้การใช้ Git ได้อย่างมีความสุข เพราะเรารู้ว่าเราสามารถทำการทดลองได้โดยที่ไม่มีอันตรายร้ายแรง เราจะดูเนื้อหาลึกๆว่า Git จัดเก็บข้อมูลอย่างไร และเราสามารถกู้ข้อมูลที่สูญหายไปได้อย่างไร ในบทที่ 9

### สามสถานะ ###

ทีนี้เราต้องให้ความสนใจหน่อย เพราะนี่คือสิ่งสำคัญของ Git ที่จะต้องจำให้ได้ ถ้าคุณต้องการจะศึกษาส่วนอื่นๆต่อไปของ Git อย่างราบรื่น ไฟล์ของคุณใน Git จะมีอยู่ 3 สถานะ คือ ยืนยันแล้ว(committed), ถูกแก้ไข(modified) และ อยู่ในขั้นตอน(staged) ซึ่ง Committed หมายถึงข้อมูลที่ถูกบันทึกเรียบร้อยแล้วในฐานข้อมูลในเครื่องของคุณ  Modified หมายถึงไฟล์ของคุณได้ถูกแก้ไขแล้วแต่ยังไม่ได้ยืนยัน(commit)ลงในฐานข้อมูลของคุณ Staged หมายถึงคุณได้ทำเครื่องหมายไว้ที่ไฟล์ที่ถูกแก้ไขในเวอร์ชันปัจจุบันเพื่อที่จะรอการ commit ใน snapshot ถัดไป

นี่ทำให้โปรเจคที่ใช้ Git มี 3 ส่วน คือ the Git directory, working directory, และ staging area.

Insert 18333fig0106.png 
Figure 1-6. Working directory, staging area, และ git directory.

Git directory เป็นที่ที่ Git ใช้เก็บ metadata และออปเจ็คของฐานข้อมูลของโปรเจคของคุณ นี่คือส่วนสำคัญที่สุดของ Git และเป็นส่วนที่จะถูกคัดลอกมาเมื่อคุณทำการโคลน(clone)คลังข้อมูลจากคอมพิวเตอร์เครื่องอื่น

working directory เป็นเวอร์ชันนึงของไฟล์ในโปรเจคที่ถูกดึงออกมาจากฐานข้อมูลที่ถูกบีบอัดไว้ใน Git directory แล้วเก็บไว้ในดิสก์เพื่อให้คุณนำไปใช้หรือเอามาแก้ไข

staging area เป็นไฟล์ธรรมดาไฟล์นึง โดยทั่วไปก็อยู่ใน Git directory ของคุณ ซึ่งเก็บข้อมูลส่วนที่คุณจะทำการ commit ในครั้งถัดไป บางครั้งก็เรียกว่าดัชนี(index) แต่ปกติก็จะเรียกว่า staging area

กระบวนการขั้นตอนพื้นฐานของ Git มีลักษณะดังนี้

1. คุณทำการแก้ไขไฟล์ใน working directory ของคุณ
2. แล้วทำการ  stage ไฟล์เหล่านั้นเพื่อให้มีการใส่ snapshot ลงไปใน staging area ของคุณ
3. ทำการยืนยัน(commit)ซึ่งนำไฟล์ที่อยู่ใน staging area ไปเก็บอย่างถาวรใน Git directory

เมื่อไฟล์อยู่ใน Git directory มันจะถือว่าเป็นสถานะ committed ถ้าไฟล์ถูกแก้ไขแล้วถูกเพิ่มลงใน staging area สถานะจะเป็น staged และถ้าไฟล์ถูกแก้ไขแล้วหลังถูกดึงออกมาแต่ไม่ได้เป็นสถานะ staged ก็จะเป็นสถานะ modified ในบทที่ 2 คุณจะได้เรียนรู้เกี่ยวกับสถานะมากกว่านี้และวิธีการที่คุณสามารถใช้ประโยชน์จากสถานะเหล่านี้หรือการข้ามสถานะ staged ได้อย่างไร

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

	$ apt-get install git

### การติดตั้งบนแมค ###

There are two easy ways to install Git on a Mac. The easiest is to use the graphical Git installer, which you can download from the SourceForge page (see Figure 1-7):

	http://sourceforge.net/projects/git-osx-installer/

Insert 18333fig0107.png 
Figure 1-7. Git OS X installer.

The other major way is to install Git via MacPorts (`http://www.macports.org`). If you have MacPorts installed, install Git via

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

You don’t have to add all the extras, but you’ll probably want to include +svn in case you ever have to use Git with Subversion repositories (see Chapter 8).

### Installing on Windows ###

Installing Git on Windows is very easy. The msysGit project has one of the easier installation procedures. Simply download the installer exe file from the GitHub page, and run it:

	http://msysgit.github.com/

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
