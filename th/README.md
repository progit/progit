[![Build Status](https://secure.travis-ci.org/progit/progit.png?branch=master)](https://travis-ci.org/progit/progit)

# เนื้อหาภายในหนังสือ Pro Git

ภายในนี้คือต้นฉบับของเนื้อหาภายใน Pro Git ทั้งหมด เนื้อหาในหนังสือ Pro Git ใช้สัญญาอนุญาตของครีเอทีฟคอมมอนส์เวอร์ชัน 3.0 ชนิด "อ้างอิงแหล่งที่มา ห้ามนำไปใช้เพื่อการค้า และให้อนุญาตต่อไปแบบเดียวกัน" 
เราหวังว่าหนังสือเล่มนี้จะช่วยให้เรียนรู้การใช้ Git ได้สะดวกขึ้น คุณสามารถสนับสนุนเราและสำนักพิมพ์ Apress ได้โดยสั่งซื้อหนังสือเล่มนี้ผ่าน Amazon

http://tinyurl.com/amazonprogit

หรือสามารถเข้าถึงที่:

http://git-scm.com/book/

# การสร้าง Ebooks

บนระบบปฏิบัติการ Fedora เวอร์ชัน 16 ขึ้นไป สามารถใช้คำสั่งด้านล่างนี้เพื่อสร้าง ebook ได้

    $ yum install ruby calibre rubygems ruby-devel rubygem-ruby-debug rubygem-rdiscount
    $ makeebooks en  # will produce a mobi

ในระบบปฏิบัติการ MacOS สามารถทำตามขั้นตอนดังนี้
	
1. ติดตั้ง ruby และ rubygems
2. `$ gem install rdiscount`
3. ดาวน์โหลดและติดตั้งโปรแกรม Calibre, command line tools และโปรแกรมสำหรับสร้างไฟล์ PDF:
    * pandoc: http://johnmacfarlane.net/pandoc/installing.html
    * xelatex: http://tug.org/mactex/
4. `$ makeebooks th` # จะได้ไฟล์ที่มี extension `.mobi`

# ข้อผิดพลาด

หากพบข้อผิดพลาดภายในหนังสือหรือพบจุดที่ต้องแก้ไข กรุณาแจ้งปัญหาผ่านระบบ issue ของ GitHub โดยการ[สร้าง issue](https://github.com/progit/progit/issues/new)
หลังจากสร้าง issue แล้ว ผู้ดูแลจะเข้ามารับเรื่องและดำเนินการต่อไป


# การแปลหนังสือ

หากต้องการแปลเนื้อหาภายในหนังสือ คุณสามารถแปลเนื้อหาภายในโฟลเดอร์ย่อยที่ตรงกับภาษาที่แปล ชื่อของโฟลเดอร์ย่อยจะใช้รหัสภาษาแบบ  [ISO 639](http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
เมื่อแปลเสร็จเรียบร้อยแล้ว ขอให้ส่ง pull request กลับมายัง repository เดิม

# การส่ง pull request

* ขอให้แน่ใจว่า encoding ของไฟล์เป็น UTF-8
* โปรดแยกการ pull request หากคุณแก้ไขเนื้อหาที่เป็นภาษาหลักของหนังสือ และเนื้อหาที่แปลจากภาษาหลัก
* หากแปลเนื้อหาภายในหนังสือ ขอให้เขียน commit message โดยให้มีรหัสของภาษาตาม ISO 639 ที่ครอบด้วยวงเล็บแบบก้ามปู ตามด้วยสิ่งที่เปลี่ยนแปลง เช่น `[de] Update chapter 2` 
* ตรวจสอบการ conflict ด้วยทุกครั้ง เนื่องจากเมื่อเกิด conflict ผู้ดูแลจะไม่รวมด้วยมือ
* ขอให้แน่ใจว่าสิ่งที่แก้ไขสามารถแปลงเป็น PDF, ebook และสามารถนำขึ้นเว็บไซต์ git-scm.com ได้โดยไม่มีปัญหาใด ๆ 
