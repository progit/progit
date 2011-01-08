# Гранење со Git #

Во скоро секој VCS постои подршка за гранење. Гранење значи одделување од главната линија за развој и се продолжува со работа без интерференција во основната содржина. Во многу VCS алатки овој процес може да биде доста скап. Често има потреба од креирање на нова копија од изворниот код, што може да одземе многу време, посебно за поголеми проекти.

Една од најдобрите изведени функционалности во Git е токму гранењето и ова е тоа што го издвојува Git од останатите VCS. Што е тоа што го издвојува? Начинот на кој Git го врши гранењето е доста оптимизиран, креирањето на гранки и преминување од гранка на гранка завзема многу малку време. За разлика од останатите VCS, Git ви наметнува начин на работа со кој се врши гранење и спојување (merge) доста често, дури и неколку пати дневно. Разбирањето и учењето на оваа особина ви дава моќна и уникатна алатка и може буквално да ви го промени начинот на развој на вашиот проект.

## Што е гранење ##

За да може да го разбереме начинот на кој Git врши гранење мора да направиме еден чекор наназад и да разгледаме како Git ги зачувува податоците. Во Погавје 1 беше наведено дека Git не ги зачувува податоците како серија од промени, туку зачувува целосни слики од вашиот проект.

Секогаш кога сакате да зачувате податоци во Git, Git запишува објект во кој се состои покажувач до целосната слика која сте ја поставиле на сцена (stage), авторот и мета-податоци, нула или повеќе покажувачи до зачуваните податоци кои се директни родители на овој запис (commit): ниеден родител за првиот запис, еден родител за нормален запис, и повеќе родители за запис кој произлегува од спојување на две или повеќе гранки.

Да претпоставиме дека имате папка во која се содржат три датотеки и ги поставувате сите три на сцена, а потоа ги комитувате (зачувувате). Со поставување на сцена се креира контролна сума на секоја од датотеките (SHA-1 хеш спомнат во Поглавје 1), се зачувува верзијата на датотеката во базата на податоци (Git ги именува како blobs) и ја поставува контролната сума на сцена:

	$ git add README test.rb LICENSE
	$ git commit -m 'initial commit of my project'

Кога правете комит со командата `git commit`, Git пресметува контролна сума за сите папки (во овој случај само главната папка на проектот) и ги запишува овие три објекти во базата на податоци. Потоа Git креира комит објект во кој се содржат мета-податоците и покажувач кон коренот (root) на дрвото на проектот за потоа кога ке има потреба да може да крира слика од проектот.

Во овој момент вашата база на податоци содржи 5 објекти: еден blob за зодржината на секој од трите директориуми, едно дрво со кое е прикажана содржината на папката и во кое се наведени имињата на директориумите за секој blob и еден комит со покажувач до дрвото и комитираните мета-податоци. Концептуално податоците во базата на податоци изгледаат како на Слика 3-1.

Insert 18333fig0301.png 
Слика 3-1. Приказ на базата на податоци после еден комит.

Ако направите некоја промена и извршите повторно комит, овој комит зачувува покажувач кон записот кој дошол непосредно пред него. После две нови комитувања, вашата историја би можела да изгледа како на Слика 3-2.

Insert 18333fig0302.png 
Слика 3-2. Git објекти после повеќе запишувања.

Гранка во Git преставува едноставен покажувач кон еден од овие записи. Основната гранка се нарекува главна гранка или master. При првиот запис ви се доделува master гранка која покажува до последниот запис што сте го направиле. Секогаш кога запишувате (комитирате) покажувачот автоматски се поместува нанапред.

Insert 18333fig0303.png 
Слика 3-3. Гранка која покажува кон историјата на записите.

Што се случува кога креирате нова гранка? Со креирање на нова гранка се креира нов покажувач со кој може да се поместувате помеѓу записите. Да претпоставиме дека имаме креирано нова гранка со име testing. Ова се прави со командата `git branch`.

	$ git branch testing

Со ова се креира нов покажувач кој покажува на истиот запис кој го користете во моментот на креирањето на гранката (Слика 3-4).

Insert 18333fig0304.png 
Слика 3-4. Повеќе гранки кои покажуваат кон историјата на записите.

Како Git препознава на која гранка моментално се наоѓате? Се чува посебен покажувач кој се нарекува HEAD. Овој покажувач е различен од концептот за HEAD во останатите VSC кои ви се познати, како што се Subversion или CVS. Во Git HEAD е покажувач до локалната гранка на која моментално се наоѓате. Во овој случај тој е поставен на главната гранка - master гранка. Командата git branch само креира нова гранка но не го поместува HEAD покажувачот кон ново креираната гранка (Слика 3-5).

Insert 18333fig0305.png 
Слика 3-5. HEAD датотека која покажува кон гранката на која се наоѓате.

За да се префрлите кон веќе постоечка гранка се користи командата `git checkout`:

	$ git checkout testing

Ова го поместува HEAD да покажува кон гранката testing (Слика 3-6).

Insert 18333fig0306.png
Слика 3-6. HEAD покажува кон друга гранка кога се поместуваме на друга гранка.

Кое е значењето на ова? Да направиме уште еден комит:

	$ vim test.rb
	$ git commit -a -m 'made a change'

Слика 3-7 го прикажува резултатот.

Insert 18333fig0307.png 
Слика 3-7. Гранката кон која покажува HEAD се поместува нанапред со секој комит.

Ова е доста интересно бидејќи сега вашата гранка testing се придвижува нанапред, но вашата master гранка сеуште покажува кон записот на кој се наоѓавте кога е повикана командата `git checkout`. Да се придвижиме назад кон master гранката:

	$ git checkout master

Слика 3-8 го прикажува резултатот.

Insert 18333fig0308.png 
Слика 3-8. HEAD се поместува кон друга гранка со командата checkout.

Оваа команда направи две работи. Го помести HEAD да покажува кон master гранката и ги врати директориумите во работната папка кон целосната слика кон која покажува master гранката. Ова значи дека промените кои ќе настанат од овој момент ќе потекнуваат од постара верзија на проектот. Генерално означува дека се враќаме назад и привремено ги одфрламе промените кои се направени на гранката testing со цел да продолжиме во различна насока.

Да направиме уште некои измени и повторно да комитираме:

	$ vim test.rb
	$ git commit -a -m 'made other changes'

Сега историјата на вашиот проект се разграни (Слика 3-9). Креиравме нова гранка и се префрливме на неа, направивме некои измени, а потоа се префрливме на main гранката и исто така направивме измени. Двете измени се изолирани во посебни гранки: може во секој момент да се префрлиме на некоја од гранките и да ги споиме кога ќе завршеме со сите потребни измени. Целата оваа работа е извршена со едноставни `branch` и `checkout` команди.

Insert 18333fig0309.png 
Слика 3-9. Разгранување на гранката.

Бидејќи гранка во Git е всушност едноставен директориум кој содржи SHA-1 контролна сума на записот кон кој покажува со големина од 40 карактери, гранките завземаат малку ресурси при креирање и бришење на истите. Креирање на нова гранка е едноставен процес на запишување на 41 бајт во директориум (40 карактери и 1 карактер за нов ред).

Овој принцип на креирање на гранки е доста различен од начинот на кој останатите VCS алатки вршат гранење, најчесто со копирање на целиот проект во нова папка. Ова одзема неколку секунди па дури и минути, во зависност од големината на проектот, додека во Git овој процес е секогаш моментален. Исто така бидејќи се запишува и родителот кога комитираме, наоѓањето на стартната точка при спојувањето на гранките се врши автоматски и генерално е многу лесно да се изведе. Овие карактеристики ги охрабруваат програмерите почесто да креираат и да користат гранки.

Да видиме зошто ова е корисно.

## Основно Гранење и Спојување ##

Да разгледаме еден едноставен пример на гранење и спојување на гранки преку едноставен модел на работа кој реално би можел да се користи. Да го следиме следново сценарио:

1.  Работете на некоја веб страна.
2.  Креирате гранка за нов натпис на кој работете.
3.  Работете на оваа гранка.

Во овој момент добивате повик дека друг настан е со поголем преоритет и треба брза реакција. Го правите следново:

1.  Се враќате назад кон вашата гранка која ја користите за продукција.
2.  Креирајте гранка за да ги додадете потребните итни измени.
3.  Откако се е истестирано, ја спојувате новата гранка со гранката за продукција.
4.  Вратете се назад кон почетниот натпис на кој работевте.

### Основно гранење ###

Да претпоставиме дека работите на вашиот проект и веќе имате направено неколку комитирања (Слика 3-10).

Insert 18333fig0310.png 
Слика 3-10. Кратка и едноставна историја на записи.

Сте одлучиле дека сакате да работите на изданието #53, во кој и да било систем за водење на евиденција кој го користи вашата компанија. Да разјасниме Git не е поврзан со никој специфичен систем за евиденција на изданијата, но бидејќи сакате да работите на изданието #53, креирате нова гранка на која ќе работите. За да креираме гранка и да се префрлиме на неа може да ја користеме командата `git checkout` со опцијата `-b`:

	$ git checkout -b iss53
	Се префрламе на нова гранка "iss53"

Ова е скратеница за:

	$ git branch iss53
	$ git checkout iss53

Слика 3-11 го прикажува резултатот.

Insert 18333fig0311.png 
Слика 3-11. Креирање на нов покажувач кон гранка.

Додека работите на вашата веб страна правите комит т.е ги зачувувате измените. Со ова гранката `iss53` се поместува нанапред, бидејќи сте направиле checked out (HEAD покажува кон неа; Слика 3-12):

	$ vim index.html
	$ git commit -a -m 'added a new footer [issue 53]'

Insert 18333fig0312.png 
Слика 3-12. Гранката iss53 се поместува нанапред.

Во овој момент добивате известување дека има проблем со вашата веб страна и морате итно да го поравете проблемот. Со Git немора решението на проблемот да го направите заедно со промените на гранката `iss53`. Се што треба да направите е да се вратите назад кон вашата главна гранка (master branch).

Мора да се запази фактот дека Git нема да ви дозволи да ја смените гранката доколку во вашиот работен директориум или на сцена имате некомитирани промени кои се во конфликт со грнаката од која сакате да направите нова гранка. Најдобро е да имате чиста работна состојба пред да правите промена на гранки. Постојат начини да се заобиколи ова, кои ќе бидат објаснети подоцна. Засега вршиме комитирање на сите измени, за да се префрлиме на главната гранка:

	$ git checkout master
	Се префрламе на гранката "master"

Во овој момент, вашиот работен директориум за проектот е ист како пред почнување со работа на изданието #53 и можете да се концентрирате на решавање на настанатиот проблем. Ова е важна особина која треба да се запамети: Git го ресетира вашиот работен директориум да изгледа како целосната слика на записот од кој креирате нова гранка. Тој автоматски ги додава, бриши и модифицира датотеките се со цел вашата работна копија да биде иста со гранката во моментот кога последен пат сте комитирале на истата.

Потоа треба да го внесете решението на проблемот кој го имате. Да креираме нова гранка hotfix на која ќе работиме на проблемот (Слика 3-13):

	$ git checkout -b 'hotfix'
	Се префрламе на нова гранка "hotfix"
	$ vim index.html
	$ git commit -a -m 'fixed the broken email address'
	[hotfix]: created 3a0874c: "fixed the broken email address"
	 1 files changed, 0 insertions(+), 1 deletions(-)

Insert 18333fig0313.png 
Слика 3-13. Гранка hotfix базирана на вашата главна гранка.

Можете да направите одредени тестови за да бидете сигурни дека проблемот е решен, а потоа ја соединувате гранката со вашата главна гранка. Ова се прави со командата `git merge`:

	$ git checkout master
	$ git merge hotfix
	Updating f42c576..3a0874c
	Fast forward
	 README |    1 -
	 1 files changed, 0 insertions(+), 1 deletions(-)

Во ова соединување се појавува фразата "Fast forward". Бидејќи записот кон кој што покажува гранката која ја споивте е наследник на записот на кој моментално се наоѓаме, Git го поместува покажувачот нанапред. Со други зборови кога спојуваме еден запис со запис кон кој може да се пристапи следејќи ја историјата на првиот запис, Git ги поедноставува работите со поместување на покажувачот нанапред бидејќи нема неконзистентни измени за спојување. Ова се нарекува "fast forward".

Вашите измени сега се наоѓаат во целосниот запис кон кој покажува `master` гранката (Слика 3-14).

Insert 18333fig0314.png 
Слика 3-14. По спојувањето главна гранка покажува кон истото место кон кое покажува hotfix гранката.

Откако решенитео на ненадејниот проблем е зачувано, подготвени сме да се вратиме назад на работата која ја работевме пред да бидеме прекинати. Меѓутоа прво ја бришеме `hotfix` гранката бидејќи повеќе не ни е потребна - `master` гранката покажува на исто место. Ова се прави со додавање на опцијата `-d` на командата `git branch`:

	$ git branch -d hotfix
	Deleted branch hotfix (3a0874c).

Сега можете да се вратите кон гранката за изданието #53 и да продолжите со работа (Слика 3-15):

	$ git checkout iss53
	Switched to branch "iss53"
	$ vim index.html
	$ git commit -a -m 'finished the new footer [issue 53]'
	[iss53]: created ad82d7a: "finished the new footer [issue 53]"
	 1 files changed, 1 insertions(+), 0 deletions(-)

Insert 18333fig0315.png 
Слика 3-15. Сега гранката iss53 може независно да се придвижува нанапред.

Овде е важно да се напомене дека промените кои се направени во `hotfix` гранката не се вклучени во гранката `iss53`. Ако сакате да ги повлечете овие промени, може да ја споите вашата `master` гранка со гранката `iss53` со извршување на командата `git merge master` или пак може подоцна ги повечете измените од `iss53` назад кон `master` гранката.

### Основно спојување ###

Да претпоставиме дека сте завршиле со работа на изданието #53 и сте подготвени да ги споите измените во `master` гранката. За да го направиме ова ќе ја споиме `iss53` гранката слично како што направивме претходно со `hotfix` гранката. Се што треба да направиме е да ја одвоиме гранката која сакаме да ја надградиме и да ја повикаме командата `git merge`:

	$ git checkout master
	$ git merge iss53
	Merge made by recursive.
	 README |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Ова изгледа малку поинаку отколку претходниот случај со спојувањето на `hotfix` гранката. Во овој случај вашата историја на развој започнува од некоја постара точка. Поради тоа што записот на гранката на која се наоѓате не е директен наследник на гранката на која што сакате да запишете, Git мора да изврши дополнителни работи. Во овој случај Git врши едноставено тристрано спојување, користејќи ги целосните записи кон кои покажуваат двете гранки и нивниот заеднички предок. На Слика 3-16 се прикажани трите целосни записи кои Git ги користи при ова спојување.

Insert 18333fig0316.png 
Слика 3-16. Git автоматски го пронаоѓа најдобриот заеднички предок, кој го користи како основа за спојување.

Наместо да го помести покажувачот нанапред, Git креира нов целосен запис кој произлегува од ова тристрано спојување и креира нов комит кој покажува кон него (Слика 3-17). Овој запис при спојување е карактеристичен по тоа што има повеќе од еден родител.

Важно е да се напомене дека Git го одредува најдобриот предок кој го користи како основа при спојувањето; ова е различно од CVS или од Subversion(пред верзијата 1.5), каде програмерот кој го врши спојувањето мора сам да одреди кој е најдобар предок. Ова го прави спојувањето со Git доста полесно во споредба со овие системи.

Insert 18333fig0317.png 
Слика 3-17. Git автоматски креира нов комит објект кој ги содржи споените измени.

Сега откако вашите измени се споени со главната гранака немате потреба од гранката `iss53`. Може слободно да ја избришиме:

	$ git branch -d iss53

### Основни конфликти при спојување ###

Повремено овој процес не се одвива толку едноставно. Git нема да може да ги спои гранките доколку имате промени во ист дел од иста датотека во двете гранки кои сакате да ги споите. Доколку вашите измени во изданието #53 афектираат ист дел од датотека на која сте работеле на `hotfix` гранката, ќе добиете конфликт кој изгледа вака:

	$ git merge iss53
	Auto-merging index.html
	CONFLICT (content): Merge conflict in index.html
	Automatic merge failed; fix conflicts and then commit the result.

Git автоматски нема да креира нов комит објект. Тој го паузира процесот се додека не го разрешите конфликтот. Доколку сакате да видете кои датотеки не се споени после конфликтот може да ја повикате командата `git status`:

	[master*]$ git status
	index.html: needs merge
	# On branch master
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#	unmerged:   index.html
	#

Секој директориум во кој има конфликти кои не се разрешени се пикажани како unmerged. Git додава стандардни маркери за разрешување на конфликти на директориумите кои имаат конфликти. Конфликтните датотеки имаат секции кои изгледаат вака:

	<<<<<<< HEAD:index.html
	<div id="footer">contact : email.support@github.com</div>
	=======
	<div id="footer">
	  please contact us at support@github.com
	</div>
	>>>>>>> iss53:index.html

Ова означува дека везијата во HEAD (вашата master гранка, бидејќи таа е гранката која ја одвоивте при повикување на командата merge) е горниот дел од сегментот (се што е над `=======`), додека верзијата во `iss53` гранката изгледа како долниот дел од сегментот. Со цел да се разреши конфликтот треба да одберете една од можностите и да ја споете содржината мануелно. На пример овој конфликт може да се разреши со промена на целиот блок со:

	<div id="footer">
	please contact us at email.support@github.com
	</div>

This resolution has a little of each section, and I’ve fully removed the `<<<<<<<`, `=======`, and `>>>>>>>` lines. After you’ve resolved each of these sections in each conflicted file, run `git add` on each file to mark it as resolved. Staging the file marks it as resolved in Git.
If you want to use a graphical tool to resolve these issues, you can run `git mergetool`, which fires up an appropriate visual merge tool and walks you through the conflicts:

	$ git mergetool
	merge tool candidates: kdiff3 tkdiff xxdiff meld gvimdiff opendiff emerge vimdiff
	Merging the files: index.html

	Normal merge conflict for 'index.html':
	  {local}: modified
	  {remote}: modified
	Hit return to start merge resolution tool (opendiff):

If you want to use a merge tool other than the default (Git chose `opendiff` for me in this case because I ran the command on a Mac), you can see all the supported tools listed at the top after “merge tool candidates”. Type the name of the tool you’d rather use. In Chapter 7, we’ll discuss how you can change this default value for your environment.

After you exit the merge tool, Git asks you if the merge was successful. If you tell the script that it was, it stages the file to mark it as resolved for you.

You can run `git status` again to verify that all conflicts have been resolved:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	modified:   index.html
	#

If you’re happy with that, and you verify that everything that had conflicts has been staged, you can type `git commit` to finalize the merge commit. The commit message by default looks something like this:

	Merge branch 'iss53'

	Conflicts:
	  index.html
	#
	# It looks like you may be committing a MERGE.
	# If this is not correct, please remove the file
	# .git/MERGE_HEAD
	# and try again.
	#

You can modify that message with details about how you resolved the merge if you think it would be helpful to others looking at this merge in the future — why you did what you did, if it’s not obvious.

## Branch Management ##

Now that you’ve created, merged, and deleted some branches, let’s look at some branch-management tools that will come in handy when you begin using branches all the time.

The `git branch` command does more than just create and delete branches. If you run it with no arguments, you get a simple listing of your current branches:

	$ git branch
	  iss53
	* master
	  testing

Notice the `*` character that prefixes the `master` branch: it indicates the branch that you currently have checked out. This means that if you commit at this point, the `master` branch will be moved forward with your new work. To see the last commit on each branch, you can run `git branch –v`:

	$ git branch -v
	  iss53   93b412c fix javascript issue
	* master  7a98805 Merge branch 'iss53'
	  testing 782fd34 add scott to the author list in the readmes

Another useful option to figure out what state your branches are in is to filter this list to branches that you have or have not yet merged into the branch you’re currently on. The useful `--merged` and `--no-merged` options have been available in Git since version 1.5.6 for this purpose. To see which branches are already merged into the branch you’re on, you can run `git branch –merged`:

	$ git branch --merged
	  iss53
	* master

Because you already merged in `iss53` earlier, you see it in your list. Branches on this list without the `*` in front of them are generally fine to delete with `git branch -d`; you’ve already incorporated their work into another branch, so you’re not going to lose anything.

To see all the branches that contain work you haven’t yet merged in, you can run `git branch --no-merged`:

	$ git branch --no-merged
	  testing

This shows your other branch. Because it contains work that isn’t merged in yet, trying to delete it with `git branch -d` will fail:

	$ git branch -d testing
	error: The branch 'testing' is not an ancestor of your current HEAD.
	If you are sure you want to delete it, run 'git branch -D testing'.

If you really do want to delete the branch and lose that work, you can force it with `-D`, as the helpful message points out.

## Branching Workflows ##

Now that you have the basics of branching and merging down, what can or should you do with them? In this section, we’ll cover some common workflows that this lightweight branching makes possible, so you can decide if you would like to incorporate it into your own development cycle.

### Long-Running Branches ###

Because Git uses a simple three-way merge, merging from one branch into another multiple times over a long period is generally easy to do. This means you can have several branches that are always open and that you use for different stages of your development cycle; you can merge regularly from some of them into others.

Many Git developers have a workflow that embraces this approach, such as having only code that is entirely stable in their `master` branch — possibly only code that has been or will be released. They have another parallel branch named develop or next that they work from or use to test stability — it isn’t necessarily always stable, but whenever it gets to a stable state, it can be merged into `master`. It’s used to pull in topic branches (short-lived branches, like your earlier `iss53` branch) when they’re ready, to make sure they pass all the tests and don’t introduce bugs.

In reality, we’re talking about pointers moving up the line of commits you’re making. The stable branches are farther down the line in your commit history, and the bleeding-edge branches are farther up the history (see Figure 3-18).

Insert 18333fig0318.png 
Figure 3-18. More stable branches are generally farther down the commit history.

It’s generally easier to think about them as work silos, where sets of commits graduate to a more stable silo when they’re fully tested (see Figure 3-19).

Insert 18333fig0319.png 
Figure 3-19. It may be helpful to think of your branches as silos.

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

Now, you can run `git fetch teamone` to fetch everything server has that you don’t have yet. Because that server is a subset of the data your `origin` server has right now, Git fetches no data but sets a remote branch called `teamone/master` to point to the commit that `teamone` has as its `master` branch (see Figure 3-26).

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

Checking out a local branch from a remote branch automatically creates what is called a _tracking branch_. Tracking branches are local branches that have a direct relationship to a remote branch. If you’re on a tracking branch and type git push, Git automatically knows which server and branch to push to. Also, running `git pull` while on one of these branches fetches all the remote references and then automatically merges in the corresponding remote branch.

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

Now, the snapshot pointed to by C3 is exactly the same as the one that was pointed to by C5 in the merge example. There is no difference in the end product of the integration, but rebasing makes for a cleaner history. If you examine the log of a rebased branch, it looks like a linear history: it appears that all the work happened in series, even when it originally happened in parallel.

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
