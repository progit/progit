# مبادئ Git #

إذا كان هناك فصل واحد عليك قراءته لكي تبدأ بإستخدام Git، فعليك بهذا الفصل! يغطي هذا الفصل جميع الأوامر الأساسية التي عليك معرفتها لكي تتمكن من القيام بأغلب الأمور أثناء استخدامك لـ Git. في نهاية هذا الفصل يجب أن تكون قادراً على انشاء واعداد الـ repository لمشروعك وعلى تحديد الملفات التي ستتم متابعتها والتي ستترك، وعلى تهييئ التغييرات لعمل commit عليها. ستتعلم أيضاً كيف تعد Git لكي تتجاهل بعض أنواع الملفات، كيف تقوم بالتراجع عن الأخطاء التي سترتكبها بسرعة وبسهولة، كيف تتصفح تاريخ مشروعك وكيف تعرض التغيرات بين الـ commits، وكيف تنشر وتسحب (push & pull) التغيرات من الـ repositories البعيدة عنك.

## الحصول على repository لمشروعك بـ Git ##

يمكنك انشاء مشروع بـ git بإحدى طريقتين. الأولى تكمن في أن تبدأ بناء على مشروع أسبق أو مجلد على سبيل المثال يحوي ملفات وأن تستورد مافيه الى مشروعك الجديد. أو أن تستنسخ repository بـ git جاهزة من مخدم ما.

### انشاء Repository في مجلد موجود مسبقاً ###

للبد بمتابعة تغيرات مشروع مسبق لديك بـ git، عليك الذهاب الى مجلد مشروعك ثم كتابة:

	$ git init

يقوم هذا بانشاء مجلد فرعية جديد تحت اسم .git يحوي جميع المعلومات والملفات المطلوبة - هيكل repository بـ git. حتى الآن، لن يتم متابعة أي تغيرات تحصل على مشروعك (انظر الفصل التاسع لمعلومات أخرى عن الملفات الموجودة في مجلد `.git` الذي أنشأته قبل قليل).

اذا أردت بمتابعة اصدارات الملفات الموجودة، يجب عليك البدء باخبار Git بهذه الملفات ومن ثم اجراء commit أولي. للقيام بهذا عليك استخدام أمر git add بالعدد الكافي بالملفات التي تريد، ومن ثم تتبعها أمر commit:

	$ git add *.c
	$ git add README
	$ git commit –m 'initial project version'

سنقوم بشرح هذه الأوامر في الفقرة القادمة، ولكن، الآن أصبحت التغيرات في مشروعك تتم متابعتها و commit أولي.

### استنساخ repository موجودة مسبقاً ###

للقيام باستنساخ  repository بـ git موجودة مسبقاً - مشروع تريد المساهمة فيه على سبيل المثال - الأمر الذي ستحتاجه هو git clone.  اذا كنت قد استخدمت أحد أنظمة إدارة الإصدارات الأخرى مثل Subversion مثلاً، ستلاحظ الإختلاف بين الأمر clone في git وأمر checkout. هناك فرق مهم، عندما تقوم git بعملية clone فإنك ستحصل على نسخة من كامل المعلومات تقريباً الموجودة على مخدم الـ repository. جميع إصدارات الملفات كلها في تاريخ حياة المشروع. أي، وبمعنى آخر، اذا حدث عطل أو ضرر ما لملفات المشروع الموجودة على المخدم الأساسي يمكنك استخدام أي واحدة من النسخ لاسترجاع المشروع للحالة التي كان عليها عند استنساخه (من الممكن أن تخسر بعض الروابط من طرف المخدم، ولكن جميع معلومات الإصدارات ستكون موجودة- انظر الفصل الرابع لمعلومات اخرى).


لاستنساخ repository يمكنك استخدام الأمر 'git clone [url]'. فعلى سبيل المثال، لكي تقوم باستنساخ مكتبة Git للغة Ruby والتي تدعى Grit، يمكنك القيام بالتالي:

	$ git clone git://github.com/schacon/grit.git

سيقوم هذا بانشاء مجلد جديد باسم "grit"، وتجهيز مجلد '.git' في داخله، سيقوم أيضاً بسحب جميع المعلومات من الـ repository، ويجهز نسخة جاهزة لكي تعمل عليها لآخر نسخة. اذا دخلت على مجلد 'grit' الجديد ستجد جميع ملفات المشروع. يمكنك بالطبع استنساخ المشروع لمجلد بإسم آخر، إليك مثال لكيفية القيام بهذا:

	$ git clone git://github.com/schacon/grit.git mygrit

سيقوم هذا الأمر بذات الأمر ولكن سيتم وضع المشروع بمجلد جديد باسم mygrit.

هناك عدد من البروتوكولات المختلفة التي يمكنك اسستعمالها لنقل المعلومات في git. المثال السابق يستعمل بروتوكول 'git://'، ولكن من الممكن أن تجد أيضاً استخداماً لـ 'http(s)://' أو 'user@server:/path.git'، والتي تستعمل بروتوكول SSH في النقل. في الفصل الرابع من الكتاب ستتعرف على الخيارات المتوفرة للتواصل مع الـ repository الخاصة بك وميزات ومساوئ كل منها.

## تسجيل التعديلات في الـ repository ##
لديك repository أصلي ونسخة لتعمل عليها من ملفات المشروع. عليك أن تقوم ببعض التعديلات ثم تعمل commit لهذه التعديلات في repository الخاص بك في كل مرة يصل فيها المشروع إلى نقطة تود تسجيلها.

تذكر أنه كل ملف في مجلد العمل يمكن أن يكون في إحدى الحالتين فقط: مٌتَتَبّع tracked أو غير مٌتَتَبّع untracked. الملفات المٌتتبّعة هي ملفات كانت في أخر snapshot ويمكن إلغاء التعديلات عليها أو التعديل عليها أو وضعه في حالة staged (جاهز من أجل commit). الملفات غير المُتتبّعة هي كل الملفات الآخرى - أي ملف في مجلد العمل لم يكن موجوداً في آخر snapshot وليس معلماً بأنه staged. عندما تقوم باستنساخ repository جميع ملفاتك تكون بحالة متتبّعة tracked و غير معدلة unmodified لأنك قمت للتو بعمل check out ولم تقم بأي تعديل.

عندما تعدل الملفات، سيقوم git بتأشيرهم على أنهم modified، لأنك قمت بتغيرهم عن آخر commit. تقوم بعمل stage لهذه الملفات المعدلة ثم تقوم بعمل commit لجميع التغيرات في منطقة stage، وتتكرر العملية. يوضع الشكل 2-1 دورة العملية.

Insert 18333fig0201.png 
الشكل 2-1. دورة حالة الملفات.

### تفقد حالة ملفاتك ###

باستخدام الأمر git status يمكننا معرفة حالة الملفات لدينا. إذا قمت بتشغيل هذا الأمر مباشرة بعد قيامك بعمل clone يجب أن ترى شيئاً يشبه التالي:

	$ git status
	# On branch master
	nothing to commit, working directory clean

وهذا يعني أنه لديك مجلد عمل نظيف - بمعنى آخر، لايوجد أي ملفات معدلة أو ملفات غير مُتتبّعة. كما أنّ هذا الأمر يخبرك بأي فرع branch أنت تعمل. حالياً، دائماً هو master، وهو الافتراضي؛ في الفصل المقبل سنمر على الأفرع و المرجعيات references بالتفصيل.

لنقل بأنك قمت بإضافة ملف جديد على مشروعك، وليكن ملف README بسيط. إذا لم يكن الملف موجوداً مسبقاً، وقمت بتنفيذ الأمر `git status` سترى الملف غير مُتتبّعاً كما يلي:

	$ vim README
	$ git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#	README
	nothing added to commit but untracked files present (use "git add" to track)

يمكنك ملاحظة أنّ ملفك الجديد README غير مُتتبّع، فهو تحت تبويب "untracked files" في خرج الأمر. ويعني ذلك أنّ git يرى ملفاً جديداً على commit السابقة؛ علماً أنّ git لن يقوم بإضافة هذا الملف إلى الملفات المتتبعة إلا إذا قمت بطلب ذلك بشكل مباشر، والهدف من ذلك من أجل حماية المشروع من الضم الخاطئ لملفات binary أو أي ملفات لا تود بإضافتها. إلاّ أنّك ترغب في إضافة README إلى الملفات المتتبّعة. وسنقوم بذلك حالاً.

### تتبع الملفات الجديدة ###

للقيام بتتبع ملف جديد عليه استخدام الأمر `git add` . مثلاً لنقم بتتبع الملف الجديد README:

	$ git add README

إذا قمنا بتنفيذ الأمر `git status` مرة أخرى سنلاحظ أن الملف README أصبح متتبعاً وجاهزاً staged للقيام بعملية commit:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#

نستطيع معرفة بأن الملف staged من خلال ملاحظته تحت بند "changes to be comitted". إذا قمت بعمل commit في هذه اللحظة، سيقوم git بإضافة النسخة الحالية من الملف إلى snapshot. تذكر عندما قمنا بعمل git init سابقاً، ثم قمنا بإضافة الملفات عن طريق git add، كان ذلك للقيام ببدء تتبع الملفات في مجلد المشروع. يقبل الأمر git add مسار لملف أو لمجلد؛ فإذا كان المسار لمجلد سيقوم git بإضافة جميع الملفات والمجلدات ضمنه بشكل تعاودي recursively.

### تجهيز الملفات المعدلة ###

لنقم بالتعديل على ملف قمنا بإضافته سابقاً. إذا قمنا مثلاً بالتعديل على ملف متتبع مسبقاً يدعى `benchmarks.rb`  وقمنا بتنفيذ الأمر git status، سيكون الخرج مشابهاً للخرج التالي:

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

يظهر الملف benchmarks.rb تحت بند "changes not staged for commit" وهذا يعني أن الملف المُتتبّع قد خضع لعملية تعديل لكنه لم يخضع للتجهيز من أجل commit. للقيام بتجهيزه (أو تأشيره للإضافة إلى commit الجديد) يجب علينا تنفيذ الأمر `git add` (لاحظ بأنّه أمر متعدد الوظائف - نستطيع استخدامه لتتبع الملفات الجديدة، تجهيز الملفات من أجل commit، والقيام بأمور أخرى مثل حل الاعتراضات في حال القيام بدمج merge). لنقم بتنفيذ git add الآن لوضع benchmarks.rb بحالة staged، ومن ثم لنقم بتنفيذ الأمر git status لنرى ما الذي قد تغيّر:

	$ git add benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#

كلا الملفين الآن جاهز للإدخال بعملية commit المقبلة. في هذه النقطة، لنفرض أنك تود القيام بتعديل على ملف benchmarks.rb قبل القيام بعملية commit، ستقوم بفتح الملف والتعديل عليه وأنك جاهز للقيام بعملية commit. لكن قبل ذلك، دعنا نقوم بتنفيذ الأمر git status مرة إضافية:

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

ما الذي يحصل؟ كيف أصبح benchmarks.rb موجوداً تحت التبويبين staged و unstaged؟ لقد اتضح لنا أنّ git يقوم بتجهيز الملف على حالته عند قيامك بتنفيذ الأمر git add. إذا قمت بعمل commit الآن، ستكون نسخة benchmarks.rb كما كانت عند قيامك بتنفيذ الأمر git add وليس النسخة الجديدة التي حصلنا عليها بعد قيامنا بتعديل الملف. لذا إذا قمنا بتعديل ملف قبل قيامنا بتنفيذ git add، وقبل القيام بعملية commit، علينا تجهيز الملف مرة أخرى لعملية commit، وذلك بتنفيذ الأمر git add مرة جديدة:

	$ git add benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#

### تجاهل الملفات ###

غالباً ما تود من git تجاهل صنف من الملفات بحث لا يقوم بإضافتها تلقائياً أو لا يظهرها بأنّها غير متتبعة. تكون هذه الملفات عادة ملفات مولدة بشكل تلقائي مثل ملفات log و الملفات الوسيطة التي تولدها أدوات التطوير لديك. في مثل هذه الحالات/ يمكن إنشاء ملف .gitignore يحوي على أنماط لأسماء الملفات التي نرغب بتجاهلها. هذا مثال عمّا قد يحتويه ملف .gitignore:

	$ cat .gitignore
	*.[oa]
	*~

أول سطر يقوم بتوجيه git إلى تجاهل أي ملفات ذات لواحق من النوع o أو a - ملفات الكائنات وملفات الأرشيف وهي ملفات وسيطة تولدها أدوات بناء الكود عادة. السطر الثاني يوجه git إلى تجاهل أي ملفات تنتهي بالرمز (~) والتي تكون ملفات مؤقتة عادةً تستخدمها بعض برامج تحرير الكود. قد ترغب أيضاً بإضافة مجلدات log و tmp أو pid؛ أو حتى ملفات التوثيق تلقائية التوليد (من الكود عادة)، وغيرها. ينصح بإضافة ملف .gitignore في بداية إنشاء repository حتى نتجنب إضافة بعض الملفات عن طريق الخطأ وتلويث respository.

قواعد الأنماط التي يمكن وضعها ضمن ملف .gitignore هي كالتالي:

*	الأسطر التي تبدأ بالرمز (#) يتم تجاهلها.
*	أنماط glob القياسية تعمل.
*	يمكن إنهاء النمط برمز (/) للدلالة على أنه يستهدف مجلداً.
*	يمكن نفي نمط ما عن طريق وضع علامة التعجب (!) في بداية السطر قبل النمط.

أنماط Glob عبارة عن نسخة مبسطة من Regular Expressions يتم استخدامها ضمن واجهة الأوامر shell. رمز النجمة (`*`) يطابق صفر-محرفاً أو أكثر. `[abc]` تطابق أي محارف ضمن الأقواس المربعة في هذه الحالة تكون a b c؛ علامة الاستفهام (?) تطابق محرفاً واحداً فقط؛ بينما تطابق الأقواس المربعة التي تحوي على محارف مفصولة بإشارة hyphen أي محرفاً يقع في المجال بين محرف البداية والنهاية - مثلا [0-9] يطابق محارف الأرقام بين 0 و 9 ضمناً.

مثال عن ملف .gitignore:

	# a comment – this is ignored
	# no .a files
	*.a
	# but do track lib.a, even though you're ignoring .a files above
	!lib.a
	# only ignore the root TODO file, not subdir/TODO
	/TODO
	# ignore all files in the build/ directory
	build/
	# ignore doc/notes.txt, but not doc/server/arch.txt
	doc/*.txt

### مشاهدة التغيّرات المجهّزة والتغيّرات غير المجهّزة ###

إذا لم تكتف بالمعلومات التي يقدمها لك أمر `git status` يمكنك استخدام أمر `git diff`  للحصول على معلومات تفصيلية حول التغيرات التي طرأت على الملفات. سنقوم لاحقاً بالتعمق في هذا الأمر، لكن الآن سنكتفي بالإشارة إلى الاستخدامات الغالبة له؛ حيث أنك ستستخدمه غالباً للحصول على أجوبة على هذين السؤالين: ما الذي قمنا بالتعديل عليه ولم نجهزه بعد لعملية commit؟ ما الملفات التي أصبحت جاهزة للدخول في عملية commit المقبلة؟
بالرغم من أنه يمكننا أن نحصل على هذه المعلومات باستخدام أمر `git status` إلا أنّ أمر `git diff` يوضح لنا التغيرات التي جرت على مستوى السطر والحرف - ما الذي قمنا بإضافته وما الذي أزلناه!

لنقل أنك قمت بالتعديل على ملف README مرة أخرى وأشرته للإضافة إلى عملية commit وقمت بالتعديل على ملف benchmarks.rb ولم تضفه إلى قائمة الملفات الجاهزة لعملية commit؛ إذا قمت بتنفيذ الأمر `status` ستشاهد مرة أخرى شيئاً من الشكل:

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

لترى ما قمت بالتعديل عليه ولم تجهزه للإضافة نفذ الأمر `git diff` بدون إضافات:

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

يقوم هذا الأمر بعمل مقارنة بين الملفات ضمن مجلد العمل والملفات الموجودة في منطقة التعديلات المجهزة للإضافة staging area. وتخبرنا نتيجته بالتعديلات التي أجريناها ولم نقم بتجهيزها للإضافة إلى عملية commit المقبلة.

لمشاهدة الملفات ذات الحالة staged والتي ستدخل في عملية commit المقبلة، يمكن استخدام الأمر `git diff --cached` (بالنسبة للإصدارات 1.6.1 وما بعد من git يمكنك أيضاً استخدام الأمر `git diff --staged` )، كالتالي:

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

من الجدير بالذكر أن أمر `git diff` لوحده لا يقوم بعرض جميع التعديلات التي تمت من آخر commit - فهو يقوم بعرض فقط التعديلات التي لم تؤشر على أنها staged. ويمكن أن يسبب ذلك بعض الإرباك، حيث أنك إذا قمت بإضافة جميع التعديلات إلى قائمة staged فلن يقوم بعرض أي شي في خرج تنفيذه.

كمثال أيضاً، إذا قمنا بإضافة benchmarks.rb إلى قائمة staged ومن ثم قمنا بالتعديل عليه من جديد، يمكننا استخدام أمر `git diff` للحصول على لائحة بالتغييرات التي حصلت ولم تضف إلى قائمة staged كالتالي:

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


	$ git diff 
	diff --git a/benchmarks.rb b/benchmarks.rb
	index e445e28..86b2f7c 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -127,3 +127,4 @@ end
	 main()

	 ##pp Grit::GitRuby.cache_client.stats 
	+# test line

وباستخدام `git diff --cached` نتمكن من رؤية ما تم تجهيزه للإضافة إلى عملية commit القادمة:

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

### القيام بعملية (اعتماد) commit للتغيّرات ###

بعد اكمال تجهيز الملفات التي ترغب بإضافتها إلى النسخة snapshot الجديدة، يمكنك تنفيذ أمر commit ليتم اعتماد التعديلات التي أجريتها في سجل git. تذكر أنّ أي ملف لم يتم تجهيزه - سواء لم تقم بإضافته باستخدام الأمر git add بعد إنشاءه أو التعديل عليه - لن يدخل في هذه الإعتمادية، وستبقى على أنها ملفات تم تعديلها في مجلد العمل. أبسط طريقة لاعتماد التعديلات هي القيام بأمر `git commit` كالتالي:

	$ git commit

تنفيذ هذا الأمر سيطلب منا إدخال رسالة عملية commit - عادة ما يتم فتح محرر النصوص المشار إليه بمتغير البيئة `$EDITOR`. يمكنك تهيئته عن طريق الأمر `git config --global core.editor` كما شاهدنا في الفصل الأول.

يقوم محرر النصوص بعرض هذه الشاشة (مثالنا باستخدام VIM):

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

يمكنك ملاحظة أن رسالة عملية commit تحوي على خرج آخر عملية `git status` على شكل تعليقات بالإضافة إلى سطر فارغ في بداية الملف. يمكنك إزالة هذه التعليقات، أو يمكنك تركها لمساعدتك بتذكر ما قمت باعتماد تعديلاته. يمكنك الحصول على معلومات أكثر تفصلياً إذا قمت بتمرير الخيار `-v` إلى الأمر `git commit`. حيث يقوم ذلك بإضافة خرج أمر `git diff` إلى رسالة commit على شكل تعليقات أيضاً. عند إغلاق المحرر يقوم git بإنشاء commit ويتجاهل التعليقات.

علماً أنّه يمكنك كتابة رسالة الاعتمادية مباشرة من خلال تمرير الخيار `-m` إلى الأمر `git commit` على الشكل التالي:

	$ git commit -m "Story 182: Fix benchmarks for speed"
	[master]: created 463dc4f: "Fix benchmarks for speed"
	 2 files changed, 3 insertions(+), 0 deletions(-)
	 create mode 100644 README

مبروك، لقد قمت بعمل أول commit لك! يعطيك خرج العملية معلومات عنها: في أي فرع branch تم الإعتماد (هنا master)، ما قيمة هاش SHA-1 الخاصة بالعملية ( هنا `463dc4f`)، عدد الملفات التي تغيّرت، بالإضافة إلى إحصاءات حول الأسطر التي أضيفت وأزيلت في هذه العملية.

تذكر أنّ عملية commit تأخذ صورة عن الملفات في قائمة staged. أي شيء لم تقم بإضافته إلى هذه القائمة ما زال في مجلد العمل بحالة "معدل" modified؛ يمكنك القيام بإضافتهم من خلال عملية commit جديدة إلى التأريخ في git. نستنتج أنّه في كل عملية commit يقوم git بأخذ "صورة" snapshot عن المشروع يمكننا العودة لها لاحقاً أو مقارنتها أو غير ذلك..

### تجاوز منطقة التجهيز Staging Area ###

منطقة التجهيز تكون أحياناً معقدة أكثر مما تحتاج في عملك إلا أنّها مفيدة لعمل commits تماماً كما تودهم أن يكونوا. إذا أردت تجاوز منطقة التجهيز، يوفر git اختصاراً بسيطاً لذلك. باستخدام الأمر `git commit -a` يقوم git بإضافة الملفات المتتبعة إلى منطقة التجهيز بشكل تلقائي، كأنك قمت بعمل `git add`:

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

لاحظ بأنك لاتحتاج إلى تنفيذ الأمر `git add` على ملف benchmark.rb قبل القيام بعملية commit.

### إزالة الملفات ###

لحذف ملف من git، يجب عليك إزالته من قائمة الملفات المتتبعة (وبشكل أدق، إزالته من منطقة التجهيز) ومن ثم القيام بعملية commit. الأمر `git rm` يقوم بعمل ذلك كما يقوم بحذف الملف من مجلد العمل الخاص بك لذا لن تراه بعد الآن في قائمة الملفات غير المتتبعة في المرة المقبلة.

إذا قمت بإزالة الملف من مجلد العمل، يظهر تحت بند "تعديلات غير مجهزة للاعتماد" (أي _unstaged_) من خرج الأمر `git status`:

	$ rm grit.gemspec
	$ git status
	# On branch master
	#
	# Changes not staged for commit:
	#   (use "git add/rm <file>..." to update what will be committed)
	#
	#       deleted:    grit.gemspec
	#

فإذا قمت بتنفيذ أمر `git rm` يقوم بتجهيز عملية الحذف ليتم اعتمادها:

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

وفي المرة المقبلة التي ستقوم فيها بعمل commit، سيتم إزالة الملف من قائمة التتبع. إذا قمت مسبقاً بتعديل الملف وإضفته إلى الفهرس، يجب عليه تنفيذ عملية الحذف قسرياً وذلك بإضافة الخيار `-f`. يتم اتباع هذه الطريقة بغية حماية البيانات من أية عمليات حذف "عرضية" لملفات لم يتم تسجيلها ضمن git ولايمكن استعادتها بعد ذلك.

أما إذا أردت إزالة الملف من منطقة التجهيز مع الحفاظ عليه في مجلد العمل (أي إزالته من تتبع git مع بقاءه على وسيطة التخزين) - وهو شيء مفيد إذا قمت بنسيان إضافة شيء ما إلى ملف `.gitignore` وأضفته عن طريق الخطأ ؛ كملف log كبير مثلاً - استخدم الخيار `--cached` مع الأمر `git rm` كالتالي:

	$ git rm --cached readme.txt

يمكنك تمرير أسماء ملفات، مجلدات، وأنماط glob للأمر `git rm`. وهذا يعني بأنه يمكننا عمل أشياء كالتالي:

	$ git rm log/\*.log

لاحظ الشرطة العكسية (`\`) قبل رمز النجمة `*`. إنّها ضرورية لأن git يقوم بعمل توسعة الأسماء الخاصة به بالإضافة إلى التوسعة الخاصة بسطر الأوامر. هذا الأمر يقوم بحذف كافة الملفات التي تملك اللاحقة `.log` في مجلد `/log`. أو يمكنك عمل شيء كالتالي:

	$ git rm \*~

وهذا الأمر يقوم بحذف كافة الملفات المنتهية بالمحرف `~`.

### نقل الملفات ###

على خلاف أغلب أنظمة إدارة الإصدارات VCS الأخرى، لا يقوم git بتعقب حركة الملفات بشكل صريح. إذا قمت بإعادة تسمية ملف ضمن git، لايتم تسجيل أي بيانات وصفية metadata في git تقوم بأنك قمت بإعادة تسمية الملف. لكن، git ذكي جداً في استعياب ذلك - وسنقوم بمناقشة الأمر بعد قليل.

إذا أردت القيام بإعادة تسمية ملف يمكنك استخدام أمر `mv` في git كالتالي:

	$ git mv file_from file_to

إذا قمنا بتنفيذ الأمر والنظر إلى خرج أمر `git status`:

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

وهو مكافئ للقيام بتنفيذ الأوامر التالي على التسلسل:

	$ mv README.txt README
	$ git rm README.txt
	$ git add README

يدرك git بأنك قمت بعملية إعادة تسمية، لذا فالإختلاف الوحيد بين الطريقتين هو أنّ `git mv` عبارة عن أمر واحد، وليس ثلاثة أوامر. يمكن الاستفادة من هذه الخاصة باستخدام أية أدوات للقيام بعمليات إعادة التسمية، واستخدام add/rm قبل القيام بعملية commit.

## مراجعة تأريخ عمليات commit ##

بعد قيامك بعدد من عمليات الاعتماد commit، أو استنساخ repository بسجل تأريخ، ربما ستود إلقاء نظرة على ما جرى. أبسط وأقوى أداة لعمل ذلك هي الأمر `git log`.

هذه الأمثلة تستخدم مشروع بسيط جداً يدعى simplegit أقوم باستخدامه في عمليات العرض بأغلب الأحيان. للحصول على المشروع قم باستنساخه عن موقع github كالتالي:

	git clone git://github.com/schacon/simplegit-progit.git

عندما تقوم بعمل `git log` ضمن المشروع، سيظهر لديك خرج مشابه للتالي:

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

بتنفيذ الأمر بدون بارمترات، يقوم git بعرض عمليات commit في repository بترتيب زمني معكوس - من الأحدث إلى الأقدم. كما يقوم بعرض بجانب كل commit هاش SHA-1 checksum الخاص بها، اسم وبريد الكاتب الإلكتروني، تاريخ الاعتماد، ورسالة الاعتماد.

يمكن إرفاق الأمر `git log` بعدد كبير من الخيارات للحصول على المعلومات التي نريدها بالضبط.. تجد في الأسفل مثالاً عن أكثر الخيارات استخداماً.

أحد أهم الخيارات هو `-p`، والذي يقوم بإظهار الفوارق المستحدثة بين عمليات commit المختلفة. يمكن أيضاً استخدام الخيار `-2` ليحد خرج النتيجة إلى آخر عمليتين:

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

هذا الخيار يعرض نفس المعلومات بالإضافة خرج diff بعده مباشرة. فهو مهم جداً من أجل مراجعة الكود واستعراض ما الذي تغير بشكل سريع ضمن سلسلة من عمليات commit. يمكنك أيضاً استخدام خيارات للتلخيص مع أمر `git log`. على سبيل المثال، إذا أردت رؤية بعض الإحصاءات المختصرة لكل commit، يمكنك استخدام الخيار `stat`:

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

كما ترى باستخدام الخيار `--stat` يتم عرض قائمة من الملفات المعدلة، عدد الملفات التي تغيرت، وعدد الأسطر التي أضيفت أو أزيلت. كما يضع ملخصاً للمعلومات في النهاية.
يوجد خيار مفيد آخر وهو `--pretty`. هذا الخيار يغير خرج السل إلى صيغ غير الافتراضية. يوجد بعضها مركب مسبقاً. مثلاً `oneline` يقوم بطباعة كل commit على سطر لوحدها، وهذا أمر مفيد في حال كنت تنظر إلى العديد من عمليات commit. بالإضافة إلى `short`، `full` و `fuller` والتي تعرض خرجاً تقريباً بنفس الصيغة مع معلومات أكثر أو أقل:

	$ git log --pretty=oneline
	ca82a6dff817ec66f44342007202690a93763949 changed the version number
	085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 removed unnecessary test code
	a11bef06a3f659402fe7563abf99ad00de2209e6 first commit

أكثر الخيارات أهمية هو `format`، والذي يسمح لك بتحديد صيغة الخرج بشكل صريح بما يتناسب مع إعرابها آلياً - حيث أنك تعرف أنّه لن يتغير عند التحديث إلى git:

	$ git log --pretty=format:"%h - %an, %ar : %s"
	ca82a6d - Scott Chacon, 11 months ago : changed the version number
	085bb3b - Scott Chacon, 11 months ago : removed unnecessary test code
	a11bef0 - Scott Chacon, 11 months ago : first commit

الجدول 2-1 يعرض بعض الخيارات المفيدة التي يمكن إضافتها إلى الصيغة.

	الخيار	وصف الخرج
	%H	Commit هاش
	%h	الهاش الاعتمادي المختصر
	%T	هاش الشجرة
	%t	هاش الشجرة المختصر
	%P	هاشات الوالد
	%p	هاشات الوالد المختصرة
	%an	اسم الكاتب
	%ae	بريد الكاتب الإلكتروني
	%ad	تاريخ الكاتب (يراعي الصيغة –date= option)
	%ar	تاريخ الكاتب - نسبياً
	%cn	اسم منفذ الاعتماد
	%ce	بريد منفذ الاعتماد الإلكتروني
	%cd	تاريخ منفذ الاعتماد
	%cr	تاريخ منفذ الاعتماد - نسبياً
	%s	العنوان

قد تتسائل عن الاختلاف بين _الكاتب_ AUTHOR و _منفذ الاعتماد_ COMMITTER. الكاتب هو الشخص الذي كتب العمل بداية، بينما منفذ الاعتماد هو آخر شخص طبق العمل. لذا، إذا أرسلت باتشاً إلى مشروع وأحد المطورين الرئيسين قام بتطبيق الباتش، تأخذان كلاكما الاعتمادية - أنت ككاتب وهو كمنفذ اعتماد.

وتكون هذه الخيارات مفيدة أكثر بالترافق مع الخيار `--graph`. حيث يضيف هذا الأمر غراف ASCII بسيط يوضح تأريخ الأفرع و الدمج، لاحظ التالي:

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

يوجد مجموعة من الخيارات البسيطة مع أمر `git log`. يوضح الجدول 2-2 قائمة من الخيارات التي قمنا بتغطيتها حتى الآن وبعض صيغ التنسيق الشائعة والتي قد تكون مفيدة، وبجانبها شرح مبسط عن التغيير الذي تجريه على الخرج.

	الخيار	الوصف
	-p	يظهر الباتش المدخل مع كل عملية commit.
	--stat	يظهر إحصاءات حول التعديلات التي حصلت على الملفات مع كل عملية commit.
	--shortstat	Display only the changed/insertions/deletions line from the --stat command.
	--name-only	يظهر قائمة الملفات المعدلة.
	--name-status	يظهر قائمة الملفات المعدلة عن طريق الإضافة والحذف وغير ذلك.
	--abbrev-commit	يظهر أول مجموعة من هاش SHA-1 بدلاً عن كامل الأحرف 40.
	--relative-date	Display the date in a relative format (for example, “2 weeks ago”) instead of using the full date format.
	--graph	عرض غراف ASCII مع الخرج يظهر عمليات التفريع و الدمج.
	--pretty	Show commits in an alternate format. Options include oneline, short, full, fuller, and format (where you specify your own format).

### تحديد خرج السجل ###

بالإضافة تحديد شكل الخرج، يسمح git بأخذ مجموعة جزئية فقط من الخرج. وقد قمت بمشاهدة ذلك مسبقاً - الخيار `-2` المستخدم لعرض آخر عمليتي commit. في الواقع يمكنك استخدام `-<n>` حيث `n` هي عدد صحيح لعرض آخر `n` عملية commit. في الحقيقة، لن تستخدمها على الغالب، لأن git يقوم بتمرير كامل الخرج لبرنامج تصفح لتتمكن من تصفح عمليات commit صفحة صفحة.

من الخيارات الهامة جداً، المحددات الزمنية مثل `--since` و `--until`. على سبيل المثال، هذا الأمر يعطيك قائمة بعمليات commit التي حصلت في آخر أسبوعين:

	$ git log --since=2.weeks

ويعمل هذا الأمر مع أنواع كثيرة من الصيغ - يمكنك تحديد تاريخ محدد ("2008-01-15") أو تاريخ نسبي مثل "2 years 1 day 3 minutes ago".

يكطمط أيضاً تصفية قائمة عمليات commit من خلال محددات البحث. مثلاً خيار `--author` يقوم بتصفية النتائج وفق كاتب محدد، و `--grep` يقوم بالفلترة عن طريق كلمة مفتاحية. (لاحظ أنّه إذا قمت بإضافة  خياراي author و grep، يجب عليك إضافة الخيار `--all-match` أو سيقوم git بعمل مطابقة مع أحدهما فقط).

آخر الخيارات الهامة التي يمكن تمريرها إلى الأمر `git log` كمصناف هي المسار. إذا قمت بتحديد مجلد أو اسم ملف، يمكنك تحديد الخرج إلى عمليات commit التي آثرت في هذا المسار. ودائماً ما يكون آخر خيار  يوضع في `log` ويسبق بداشين double dashes (`--`) ليفصل المسارات عن الخيارات.

في الجدول 2-3 - نعرض الخيارات التي يمكن إضافتها مع log.

	خيار	وصف
	-(n)	يظهر آن n عملية commit.
	--since, --after	تحديد عمليات commit بعد التاريخ الذي يتلوها.
	--until, --before	تحديد عمليات commit حتى التاريخ الذي يتلوها.
	--author	فقط أظهر عمليات commit التابعة لهذا الكاتب.
	--committer	فقط أظهر عمليات commit التابعة لهذا المعتمد.

على سبيل المثال، إذا أردت رؤية أي عمليات commit عدلت ملفات الاختبار في تأريخ الكود المصدري والتي قام Junio Hamano بعملها ولم يتم دمجها في شهر أوكتوبر 2008، يمكن كتابة هذا الأمر:

	$ git log --pretty="%h - %s" --author=gitster --since="2008-10-01" \
	   --before="2008-11-01" --no-merges -- t/
	5610e3b - Fix testcase failure when extended attribute
	acd3b9e - Enhance hold_lock_file_for_{update,append}()
	f563754 - demonstrate breakage of detached checkout wi
	d1a43f2 - reset --hard/read-tree --reset -u: remove un
	51a94af - Fix "checkout --track -b newbranch" on detac
	b0ad11e - pull: allow "git pull origin $something:$cur

من بين 20 ألف عملية commit تقريباً في تأريخ git الخاص بهذا الكود المصدري، أظهر الأمر فقط عمليات الاعتماد الستة المطابقة لمحددات البحث.

### Using a GUI to Visualize History ###

If you like to use a more graphical tool to visualize your commit history, you may want to take a look at a Tcl/Tk program called gitk that is distributed with Git. Gitk is basically a visual `git log` tool, and it accepts nearly all the filtering options that `git log` does. If you type gitk on the command line in your project, you should see something like Figure 2-2.

Insert 18333fig0202.png 
Figure 2-2. The gitk history visualizer.

You can see the commit history in the top half of the window along with a nice ancestry graph. The diff viewer in the bottom half of the window shows you the changes introduced at any commit you click.

## Undoing Things ##

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
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   benchmarks.rb
	#

The command is a bit strange, but it works. The benchmarks.rb file is modified but once again unstaged.

### Unmodifying a Modified File ###

What if you realize that you don’t want to keep your changes to the benchmarks.rb file? How can you easily unmodify it — revert it back to what it looked like when you last committed (or initially cloned, or however you got it into your working directory)? Luckily, `git status` tells you how to do that, too. In the last example output, the unstaged area looks like this:

	# Changes not staged for commit:
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

	$ git config --global alias.visual '!gitk'

## Summary ##

At this point, you can do all the basic local Git operations — creating or cloning a repository, making changes, staging and committing those changes, and viewing the history of all the changes the repository has been through. Next, we’ll cover Git’s killer feature: its branching model.
