# Введення #

<!-- # Getting Started # -->

В цьому розділі йдеться про початок роботи з Git.

Знайомство відбувається поступово: пояснення основних принципів роботи систем контролю версій, потім інструкція з запуску Git у вашій системі та врешті-решт опис його налаштування для початку роботи.

Наприкінці розділу ви вже розумітимете передумови виникнення Git, причини та способи його використання саме у ваших проектах та будете готові до практичних дій у цьому напрямі.

<!-- This chapter will be about getting started with Git.  We will begin at the beginning by explaining some background on version control tools, then move on to how to get Git running on your system and finally how to get it setup to start working with.  At the end of this chapter you should understand why Git is around, why you should use it and you should be all setup to do so. -->

## Про контроль версій ##

<!-- ## About Version Control ## -->

Що таке контроль версій і навіщо він вам?

Контроль версій здійснює система, що записує та «запам’ятовує» усі зміни одного чи сукупності файлів, завдяки чому ви можете відновити будь-яку версію пізніше.

Не варто надавати багато значення тому, що у прикладах цієї книги в якості файлів для контролю версій використовуються початкові коди програм. Насправді, для контролю версій можуть використовуватись будь-які файли

<!--What is version control, and why should you care? Version control is a system that records changes to a file or set of files over time so that you can recall specific versions later. Even though the examples in this book show software source code as the files under version control, in reality any type of file on a computer can be placed under version control.-->

Якщо ви графічний чи вебовий дизайнер та бажаєте зберігати кожну копію зображення чи шару, то використання системи контролю версій (СКВ) стане навпрочуд мудрим рішенням.

СКВ дозволяє: повертати до попереднього стану будь-які файли чи увесь проект цілком; переглядати зміни зроблені протягом усього часу; бачити хто вносив правки у щось, що могло викликати проблему; хто і коли додав  зауваження та багато інших рречей.

Використання СКВ також передбачає можливість легкого відновлення файлів у разі їх втрати чи пошкодження. На додачу, все це ви отримуєте за досить невеликих витрат часу та ресурсів системи

<!-- If you are a graphic or web designer and want to keep every version of an image or layout (which you certainly would), it is very wise to use a Version Control System (VCS). A VCS allows you to: revert files back to a previous state, revert the entire project back to a previous state, review changes made over time, see who last modified something that might be causing a problem, who introduced an issue and when, and more. Using a VCS also means that if you screw things up or lose files, you can generally recover easily. In addition, you get all this for very little overhead. -->

### Локальні системи контролю версій ###

<!-- ### Local Version Control Systems ### -->

Багато людей здійснюють контроль версій шляхом простого копіювання файлів до іншої директорії (особливо охайні навіть іменують директорії у хронологічному порядку). Завдяки своїй простоті такий підхід дуже розповсюджений, втім він також неймовірно ненадійний. Адже дуже легко переплутати в якій саме директорії ви зараз знаходитесь і випадково перезаписати не ті файли

<!-- Many people’s version-control method of choice is to copy files into another directory (perhaps a time-stamped directory, if they’re clever). This approach is very common because it is so simple, but it is also incredibly error prone. It is easy to forget which directory you’re in and accidentally write to the wrong file or copy over files you don’t mean to. -->

Для вирішення цієї проблеми були створені локальні СКВ, що мали просту базу даних для зберігання усіх змін необхідних файлів. (див. Ілюстрацію 1-1).

<!-- To deal with this issue, programmers long ago developed local VCSs that had a simple database that kept all the changes to files under revision control (see Figure 1-1). -->

Insert 18333fig0101.png
Ілюстрація 1-1. Схема локальної системи контролю версій.

<!-- Figure 1-1. Local version control diagram. -->

Однією з найпопулярніших систем цього типу була rcs, що й досі розповсюджується разом з багатьма комп’ютерами. Навіть операційна система Mac OS X отримує команду rcs після встановлення Developer Tools (Інструменти Розробника). Робота цієї програми заснована на зберіганні сукупності патчів (так називаються відмінності між файлами) між версіями у спеціальному форматі на диску. Вона може відновити стан будь якого файлу у будь-який час шляхом застосування усіх патчів.

<!-- One of the more popular VCS tools was a system called rcs, which is still distributed with many computers today. Even the popular Mac OS X operating system includes the rcs command when you install the Developer Tools. This tool basically works by keeping patch sets (that is, the differences between files) from one revision to another in a special format on disk; it can then recreate what any file looked like at any point in time by adding up all the patches. -->

### Централізовані системи контролю версій ###

<!-- ### Centralized Version Control Systems ### -->

Наступною великою проблемою, з якою зіткнулись люди, стала необхідність співпраці з іншими розробниками. В результаті, справу було вирішено завдяки централізованим системам контролю версій (ЦСКВ). Такі системи, як CVS, Subversion та Perforce, складаються з одного сервера, що зберігає усі контрольовані файли, та деякої кількості клієнтів, які отримують файли з цього «центру». Протягом багатьох років це залишалось стандартом у контролі версій (див. Ілюстрацію 1-2).

<!-- The next major issue that people encounter is that they need to collaborate with developers on other systems. To deal with this problem, Centralized Version Control Systems (CVCSs) were developed. These systems, such as CVS, Subversion, and Perforce, have a single server that contains all the versioned files, and a number of clients that check out files from that central place. For many years, this has been the standard for version control (see Figure 1-2). -->

Insert 18333fig0102.png
Ілюстрація 1-2. Схема централізованої системи контролю версій.

<!-- Figure 1-2. Centralized version control diagram. -->

Така конфігурація має багато переваг, особливо у порівнянні з локальними СКВ. Наприклад, кожен може дізнатись чим займається інший учасник проекту на будь-якому етапі. У адміністраторів є чіткий контроль над тим, хто і що може робити. До того ж, значно простіше адмініструвати централізовану систему, аніж мати справу з локальними базами даних кожного клієнта.

<!-- This setup offers many advantages, especially over local VCSs. For example, everyone knows to a certain degree what everyone else on the project is doing. Administrators have fine-grained control over who can do what; and it’s far easier to administer a CVCS than it is to deal with local databases on every client. -->

Втім, і цей підхід має деякі серйозні вади. Найбільш очевидною є безумовна залежність від одного елементу мережі, що являє собою централізований сервер. Якщо на годину вимкнути сервер, то протягом цієї години стає неможливою взаємодія між учасниками системи та збереження версійних змін до об’єктів, над якими ведеться робота. При пошкодженні жорсткого диску з центральною базою даних та відсутності її резервних копій ви втрачаєте абсолютно все — всю історію проекту, за виключенням хіба що поодиноких знімків, які клієнтам пощастило мати на локальних машинах.

Локальні СКВ страждають від тієї ж проблеми — ризик повної втрати проекту у результаті зберігання усієї історії в одному місці.

<!-- However, this setup also has some serious downsides. The most obvious is the single point of failure that the centralized server represents. If that server goes down for an hour, then during that hour nobody can collaborate at all or save versioned changes to anything they’re working on. If the hard disk the central database is on becomes corrupted, and proper backups haven’t been kept, you lose absolutely everything—the entire history of the project except whatever single snapshots people happen to have on their local machines. Local VCS systems suffer from this same problem—whenever you have the entire history of the project in a single place, you risk losing everything. -->

### Розподілені системи контролю версій ###

<!-- ### Distributed Version Control Systems ### -->

Ось тут в гру вступають розподілені системи контролю версій (РСКВ). У цих системах (наприклад: Git, Mercurial, Bazaar чи Darcs) клієнти мають не лише останній знімок файлів, вони отримують повне дзеркало репозиторію. Тож, за втрати одного з серверів, за допомогою якого відбувається співпраця, будь-який з клієнтських репозиторіїв може бути скопійований назад на сервер для відновлення. Кожне стягування файлів, по суті є повною резервною копією усіх даних (див. Ілюстрацію 1-3).

<!-- This is where Distributed Version Control Systems (DVCSs) step in. In a DVCS (such as Git, Mercurial, Bazaar or Darcs), clients don’t just check out the latest snapshot of the files: they fully mirror the repository. Thus if any server dies, and these systems were collaborating via it, any of the client repositories can be copied back up to the server to restore it. Every checkout is really a full backup of all the data (see Figure 1-3). -->

Insert 18333fig0103.png
Ілюстрація 1-3. Розподілена система контролю версій.

<!-- Figure 1-3. Distributed version control diagram. -->

Крім того, багато з цих систем чудово працюють з декількома віддаленими репозиторіями. Таким чином, у межах одного проекту ви можете співпрацювати з різними групами людей і різними шляхами одночасно. Це дозволяє налаштувати декілька типів робочих процесів, на відміну від централізованих систем.

<!-- Furthermore, many of these systems deal pretty well with having several remote repositories they can work with, so you can collaborate with different groups of people in different ways simultaneously within the same project. This allows you to set up several types of workflows that aren’t possible in centralized systems, such as hierarchical models. -->

## Коротенький екскурс в історію ##

<!-- ## A Short History of Git ## -->

Як і багато інших видатних речей, Git почався з творчого непорозуміння та гарячих протиріч. Ядро Linux це проект з відкритим програмним кодом достатньо великих розмірів. Протягом більшої частини існування ядра (1991-2002 рр.) зміни у коді передавались у вигляді патчів та архівів. У 2002 році у проекті почала використовуватись пропрієтарна РСКВ під назвою BitKeeper.

<!-- As with many great things in life, Git began with a bit of creative destruction and fiery controversy. The Linux kernel is an open source software project of fairly large scope. For most of the lifetime of the Linux kernel maintenance (1991–2002), changes to the software were passed around as patches and archived files. In 2002, the Linux kernel project began using a proprietary DVCS system called BitKeeper. -->

У 2005 році взаємовідносини між спільнотою розробників ядра та комерційною компанією, що займалась розробкою BitKeeper, погіршились і право безкоштовного користування продуктом було скасовано. Це спонукало спільноту Linux (і особливо Лінуса Торвальдса, засновника Linux) до створення власного інструменту. У пригоді став досвід використання BitKeeper з усіма його перевагами і недоліками. Головні вимоги до нової системи були такі:

<!-- In 2005, the relationship between the community that developed the Linux kernel and the commercial company that developed BitKeeper broke down, and the tool’s free-of-charge status was revoked. This prompted the Linux development community (and in particular Linus Torvalds, the creator of Linux) to develop their own tool based on some of the lessons they learned while using BitKeeper. Some of the goals of the new system were as follows: -->

*   швидкість;
*   простий дизайн;
*   підтримка нелінійної розробки (тисячі паралельних гілок);
*   повна розподільність;
*   можливість ефективного управління великими проектами на зразок ядра Linux (швидкість та розмір даних).

<!-- 
*	Speed
*	Simple design
*	Strong support for non-linear development (thousands of parallel branches)
*	Fully distributed
*	Able to handle large projects like the Linux kernel efficiently (speed and data size)
-->

Від свого створення у 2005 Git розвивався зберігаючи простоту використання, але не втрачаючи цих початкових орієнтирів. Він неймовірно швидкий, ефективний на великих проектах і має вражаючу систему розгалужування для нелінійної розробки (див. Розділ 3).

<!-- Since its birth in 2005, Git has evolved and matured to be easy to use and yet retain these initial qualities. It’s incredibly fast, it’s very efficient with large projects, and it has an incredible branching system for non-linear development (See Chapter 3). -->

## Основи Git ##

<!-- ## Git Basics ## -->

Отже, що таке Git у двох словах?

Це дуже важливо засвоїти, оскільки, зрозумівши основи та принципи функціонування Git, ви зможете використовувати його більш ефективно і з меншими зусиллями.

На час знайомства з Git спробуйте забути все що ви знаєте про інші СКВ. Це дозволить уникнути деяких непорозумінь.

Git зберігає інформацію та оперує нею дещо по-іншому, ніж інші системи, навіть попри схожий користувацький інтерфейс. Розуміння цих відмінностей допоможе уникнути плутанини у подальшому.

<!-- So, what is Git in a nutshell? This is an important section to absorb, because if you understand what Git is and the fundamentals of how it works, then using Git effectively will probably be much easier for you. As you learn Git, try to clear your mind of the things you may know about other VCSs, such as Subversion and Perforce; doing so will help you avoid subtle confusion when using the tool. Git stores and thinks about information much differently than these other systems, even though the user interface is fairly similar; understanding those differences will help prevent you from becoming confused while using it. -->

### Знімки ###

<!-- ### Snapshots, Not Differences ### -->

Однією з головних відмінностей від інших систем (таких як Subversion та подібних їй) є те, як Git сприймає дані.

Більшість СКВ зберігають інформацію як список файлових редагувань. Ці системи (CVS, Subversion, Perforce, Bazaar) розглядають інформацію як список файлів та їх змін, що показано на Ілюстрації 1-4.

<!-- The major difference between Git and any other VCS (Subversion and friends included) is the way Git thinks about its data. Conceptually, most other systems store information as a list of file-based changes. These systems (CVS, Subversion, Perforce, Bazaar, and so on) think of the information they keep as a set of files and the changes made to each file over time, as illustrated in Figure 1-4. -->

Insert 18333fig0104.png
Ілюстрація 1-4. Інші системи зберігають дані як список змін до початкової версії кожного файлу.
<!-- Figure 1-4. Other systems tend to store data as changes to a base version of each file. -->

Git сприймає та зберігає інформацію по-іншому. Git розглядає свої дані ніби сукупність знімків невеликої файлової системи. Щоразу, при збереженні поточного стану проекту, Git робить знімок (копію) того, як виглядають ваші файли саме у цей момент і зберігає посилання на цей знімок. Для ефективності, якщо файл не змінився, Git не збергіє його знову, а просто робить посилання на ідентичний файл з попередньої фіксації змін. Схематичне зображення такого підходу показано нижче.

<!-- Git doesn’t think of or store its data this way. Instead, Git thinks of its data more like a set of snapshots of a mini filesystem. Every time you commit, or save the state of your project in Git, it basically takes a picture of what all your files look like at that moment and stores a reference to that snapshot. To be efficient, if files have not changed, Git doesn’t store the file again—just a link to the previous identical file it has already stored. Git thinks about its data more like Figure 1-5. -->

Insert 18333fig0105.png
Ілюстрація 1-5. Git зберігає дані як знімки проекту за хронологією.

<!-- Figure 1-5. Git stores data as snapshots of the project over time. -->

Це дуже важлива різниця між Git та іншими СКВ. З цієї причини у Git було заново переосмислено майже кожен аспект контролю версій, що зробило його схожим на мініатюрну файлову систему з деякими неймовірно потужними вбудованими інструментами. Ми познайомимось з деякими перевагами, які ви отримаєте при сприйнятті інформації подібним чином, у третьому розділі, де йдеться про гілки.

<!-- This is an important distinction between Git and nearly all other VCSs. It makes Git reconsider almost every aspect of version control that most other systems copied from the previous generation. This makes Git more like a mini filesystem with some incredibly powerful tools built on top of it, rather than simply a VCS. We’ll explore some of the benefits you gain by thinking of your data this way when we cover Git branching in Chapter 3. -->

### Майже кожна операція — локальна  ###

<!-- ### Nearly Every Operation Is Local ### -->

Більшість операцій в Git потребують лише локальних файлів та ресурсів для здійснення операцій — немає небхідності у інформації з інших комп’ютерів вашої мережі. Якщо ви працюєте з ЦСКВ, де більшість операцій обтяжені такими мережевими запитами, то цей аспект може привести вас до думки, що боги швидкості наділили Git неземною силою. Через те, що повна історія проекту знаходиться на вашому локльному диску, більшість операцій здійснюються майже миттєво.

<!-- Most operations in Git only need local files and resources to operate — generally no information is needed from another computer on your network.  If you’re used to a CVCS where most operations have that network latency overhead, this aspect of Git will make you think that the gods of speed have blessed Git with unworldly powers. Because you have the entire history of the project right there on your local disk, most operations seem almost instantaneous. -->

Наприклад, для перегляду історії, Git не має потреби брати її з серверу, він просто зчитує її прямо з локальної бази даних. Це означає, що ви отримуєте історію проекту не встигнувши кліпнути оком. Якщо ви бажаєте переглянути відмінності між поточною версією файлу та його редакцією місячної давності, Git знайде копію збережену місяць тому і проведе локальний розрахунок замість того, щоб звертатись за цим до віддаленого серверу чи спочатку робити запит на отримання старішої версії файлу.

<!-- For example, to browse the history of the project, Git doesn’t need to go out to the server to get the history and display it for you—it simply reads it directly from your local database. This means you see the project history almost instantly. If you want to see the changes introduced between the current version of a file and the file a month ago, Git can look up the file a month ago and do a local difference calculation, instead of having to either ask a remote server to do it or pull an older version of the file from the remote server to do it locally. -->

Також це значить, що за відсутності мережевого з’єднання ви не будете мати особливих обмежень. Перебуваючи у літаку чи потязі можна цілком комфортно фіксувати зміни поки не відновите з’єднання з мережею для їх завантаження. Дорогою додому, не маючи змоги належним чином використовувати свій VPN-клієнт, все одно можна продовжувати роботу. В багатьох інших системах подібні дії або неможливі, або пов’язані з безліччю труднощів. Наприклад, в Perforce, без з’єднання з мережею вам не вдасться зробити багато; у Subversion та CVS ви можете редагувати файли, але не можете фіксувати внесені зміни (оскільки немає зв’язку з базою даних). На перший погляд такі речі здаються незначним, але ви будете вражені наскільки велике значення вони можуть мати.

<!-- This also means that there is very little you can’t do if you’re offline or off VPN. If you get on an airplane or a train and want to do a little work, you can commit happily until you get to a network connection to upload. If you go home and can’t get your VPN client working properly, you can still work. In many other systems, doing so is either impossible or painful. In Perforce, for example, you can’t do much when you aren’t connected to the server; and in Subversion and CVS, you can edit files, but you can’t commit changes to your database (because your database is offline). This may not seem like a huge deal, but you may be surprised what a big difference it can make. -->

### Git виконує перевірку цілісності даних ###

<!-- ### Git Has Integrity ### -->

Будь-що у Git, перед збереженням, отримує контрольну суму, за якою потім і перевіряється. Таким чином, неможливо змінити файл чи директорію так, щоб Git про це не дізнався. Цей функціонал вбудовано у систему на найнижчих рівнях і є складовою частиною її філософії. Ви не можете втратити інформацію при передачі чи отримати пошкоджений файл без відома Git.

<!-- Everything in Git is check-summed before it is stored and is then referred to by that checksum. This means it’s impossible to change the contents of any file or directory without Git knowing about it. This functionality is built into Git at the lowest levels and is integral to its philosophy. You can’t lose information in transit or get file corruption without Git being able to detect it. -->

Механізм, який використовується для цього контролю, називається хеш SHA-1. Він являє собою 40-символьну послідовність цифр та перших літер латинського алфавіту (a-f) і вираховується на основі вмісту файлу чи структури директорії. Виглядає це приблизно так:

    24b9da6552252987aa493b52f8696cd6d3b00373

При роботі з Git ви постійно зустрічатимете такі хеші. Фактично, Git зберігає все не за назвою файлу, а саме за такими адресами.

<!-- The mechanism that Git uses for this checksumming is called a SHA-1 hash. This is a 40-character string composed of hexadecimal characters (0–9 and a–f) and calculated based on the contents of a file or directory structure in Git. A SHA-1 hash looks something like this:

	24b9da6552252987aa493b52f8696cd6d3b00373

You will see these hash values all over the place in Git because it uses them so much. In fact, Git stores everything not by file name but in the Git database addressable by the hash value of its contents. -->

### Git, зазвичай, тільки додає дані ###

<!-- ### Git Generally Only Adds Data ### -->

Коли ви виконуєте певні дії в Git, при цьому, майже завжди відбувається додавання інформації до її бази даних. Дуже складно змусити систему зробити щось невиправне чи повністю видалити дані. Як і в будь-якій СКВ, ви можете втратити чи зіпсувати лише незафіксовані зміни. Але це майже неможливо, коли вже зроблено знімок, особливо, якщо ви регулярно надсилаєте свою базу до іншого репозиторію.

<!-- When you do actions in Git, nearly all of them only add data to the Git database. It is very difficult to get the system to do anything that is not undoable or to make it erase data in any way. As in any VCS, you can lose or mess up changes you haven’t committed yet; but after you commit a snapshot into Git, it is very difficult to lose, especially if you regularly push your database to another repository. -->

Це робить використання Git приємним, оскільки можна експериментувати без загрози щось зіпсувати.

Про те, як Git зберігає інформацію та як можна відновити втрачені дані, детальніше розповідається у Розділі 9.

<!-- This makes using Git a joy because we know we can experiment without the danger of severely screwing things up. For a more in-depth look at how Git stores its data and how you can recover data that seems lost, see Chapter 9. -->

### Три стани ###

<!-- ### The Three States ### -->

А зараз, будьте уважні. Це найважливіша річ, яку потрібно запам’ятати, якщо ви хочете щоб подальше вивчення Git пройшло гладко.

Git має три основних стани, у яких можуть перебувати ваші файли: зафіксований, змінений та доданий.

Зафіксований — значить, дані безпечно збережено в локальній базі даних.

Змінений означає, що у файл внесено редагування, які ще не зафіксовано у базі даних.

Доданий стан виникає тоді, коли ви позначаєте змінений файл у поточній версії, готуючи його таким чином до фіксації.

<!-- Now, pay attention. This is the main thing to remember about Git if you want the rest of your learning process to go smoothly. Git has three main states that your files can reside in: committed, modified, and staged. Committed means that the data is safely stored in your local database. Modified means that you have changed the file but have not committed it to your database yet. Staged means that you have marked a modified file in its current version to go into your next commit snapshot. -->

Це приводить нас до трьох головних відділів проекту під управлінням Git: директорія Git, робоча директорія та область додавання.

<!-- This leads us to the three main sections of a Git project: the Git directory, the working directory, and the staging area. -->

Insert 18333fig0106.png
Ілюстрація 1-6. Робоча директорія, область додавання та директорія Git.

<!-- Figure 1-6. Working directory, staging area, and git directory. -->

У директорії Git система зберігає метадані та базу даних об’єктів вашого проекту. Це найважливіша частина проекту. Саме вона копіюється при клонуванні проекту з іншого комп’ютеру.

<!-- The Git directory is where Git stores the metadata and object database for your project. This is the most important part of Git, and it is what is copied when you clone a repository from another computer. -->

Робоча директорія являє собою файли і директорії проекту у поточному стані. Ці об’єкти видобуваються з бази даних (яка, пригадаємо, зберігається у директорії Git) і розміщуються на диску для подальшого використання та редагування.

<!-- The working directory is a single checkout of one version of the project. These files are pulled out of the compressed database in the Git directory and placed on disk for you to use or modify. -->

Область додавання це простий файл, що зазвичай знаходиться у директорії Git і містить інформацію про об’єкти, стан яких буде враховано під час наступної фіксації змін.

<!-- The staging area is a simple file, generally contained in your Git directory, that stores information about what will go into your next commit. It’s sometimes referred to as the index, but it’s becoming standard to refer to it as the staging area. -->

Найпростіший процес взаємодії з Git виглядає приблизно так:

1. Ви редагуєте файли у своїй робочій директорії.
2. Надсилаєте файли в область додавання, шляхом створення знімків їх поточного стану.
3. Робите фіксацію, яка бере файли в області додавання і остаточно зберігає цей знімок у директорії Git.

<!-- The basic Git workflow goes something like this:

1. You modify files in your working directory.
2. You stage the files, adding snapshots of them to your staging area.
3. You do a commit, which takes the files as they are in the staging area and stores that snapshot permanently to your Git directory. -->

У випадку, якщо окрема версія файлу вже є у директорії Git, цей файл вважається зафіксованим. Якщо він зазнав змін і перебуває в області додавання, то він доданий. Якщо ж його стан відрізняється від того, який було зафіксовано, і файл не знаходиться в області додавання, то він називається зміненим.

У наступному розділі ви дізнаєтесь більше про ці стани, а також про те, як використовувати їхні переваги або взагалі пропускати етап області додавання.

<!-- If a particular version of a file is in the git directory, it’s considered committed. If it’s modified but has been added to the staging area, it is staged. And if it was changed since it was checked out but has not been staged, it is modified. In Chapter 2, you’ll learn more about these states and how you can either take advantage of them or skip the staged part entirely. -->

## Встановлення Git ##

<!-- ## Installing Git ## -->

Перш за все, для використання Git, ви маєте його встановити. Для цього існує декілька способів; два найбільш вживаних це встановлення з сирців та встановлення існуючого пакунку для вашої платформи.

<!-- Let’s get into using some Git. First things first—you have to install it. You can get it a number of ways; the two major ones are to install it from source or to install an existing package for your platform. -->

### Встановлення з джерельного коду ###

<!-- ### Installing from Source ### -->

Встановлення Git з джерельного коду є дуже корисним, оскільки ви отримуєте найсвіжішу версію. У кожній новій версії системи зберігається тенденція до покращення елементів користувацького інтерфейсу, тож встановлення останньої версії це найкращий шлях, якщо ви володієте навиками компіляції програм з сирців. Крім того, багато дистрибутивів Лінукс містять досить застарілі пакунки, що може слугувати одним з приводів до цього способу встановлення.

<!-- If you can, it’s generally useful to install Git from source, because you’ll get the most recent version. Each version of Git tends to include useful UI enhancements, so getting the latest version is often the best route if you feel comfortable compiling software from source. It is also the case that many Linux distributions contain very old packages; so unless you’re on a very up-to-date distro or are using backports, installing from source may be the best bet. -->

Для встановлення Git вам знадобляться бібліотеки, від яких залежить система: curl, zlib, openssl, expat та libiconv. Якщо ви користуєтесь системою, в якій є утиліта yum (наприклад, Fedora) чи apt-get (будь-яка система на основі Debian — Ubuntu, Mint тощо), для встановлення цих залежностей в нагоді вам може стати одна з таких команд:

<!-- To install Git, you need to have the following libraries that Git depends on: curl, zlib, openssl, expat, and libiconv. For example, if you’re on a system that has yum (such as Fedora) or apt-get (such as a Debian based system), you can use one of these commands to install all of the dependencies: -->

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev libssl-dev

Після отримання необхідних компонентів, можна рухатись далі і стягнути останній знімок системи Git з офіційного сайту:

<!-- When you have all the necessary dependencies, you can go ahead and grab the latest snapshot from the Git web site: -->

	http://git-scm.com/download

Потім компіляція і встановлення:

<!-- Then, compile and install: -->

	$ tar -zxf git-1.7.2.2.tar.gz
	$ cd git-1.7.2.2
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

Коли все вишевказане виконано, ви можете завершити процес оновленням Git його власними засобами:

<!-- After this is done, you can also get Git via Git itself for updates: -->

	$ git clone git://git.kernel.org/pub/scm/git/git.git

### Встановлення на Linux ###

<!-- ### Installing on Linux ### -->

Якщо бажаєте встановити Git у системі Linux, можете скористатись вбудованим менеджером пакунків. Наприклад, у Fedora це робиться так:

<!-- If you want to install Git on Linux via a binary installer, you can generally do so through the basic package-management tool that comes with your distribution. If you’re on Fedora, you can use yum: -->

	$ yum install git-core

Якщо ж ви користувач дистрибутиву базованого на Debian чи його нащадках (як Ubuntu, Mint чи elementary), спробуйте apt-get:

<!-- Or if you’re on a Debian-based distribution like Ubuntu, try apt-get: -->

	$ apt-get install git

Крім того, багато сучасних дистрибутивів мають графічний інтерфейс управління програмним оточенням — це найпростіший шлях встановлення, а всі залежності підтягнуться автоматично.

### Встановлення на Mac ###

<!-- ### Installing on Mac ### -->

Існує два простих шляхи встановлення Git на Mac.

Найпростішим є використання графічного інсталятору, який можна звантажити з його сторінки на сервісі Google Code:

<!-- There are two easy ways to install Git on a Mac. The easiest is to use the graphical Git installer, which you can download from the Google Code page (see Figure 1-7): -->

	http://code.google.com/p/git-osx-installer

Insert 18333fig0107.png
Ілюстрація 1-7. Програма встановлення Git в OS X. 

<!-- Figure 1-7. Git OS X installer. -->

Іншим розповсюдженим способом є встановлення за допомогою MacPorts (`http://www.macports.org`). Якщо маєте цей пакет, встановіть Git командою:

<!-- The other major way is to install Git via MacPorts (`http://www.macports.org`). If you have MacPorts installed, install Git via -->

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

Вам не обов’язково мати всі розширення. Але якщо коли-небудь ви будете використовувати Git з репозиторіями Subversion, вам знадобиться +svn (детальніше у Розділі 8).

<!-- You don’t have to add all the extras, but you’ll probably want to include +svn in case you ever have to use Git with Subversion repositories (see Chapter 8). -->

### Встановлення на Windows ###

<!-- ### Installing on Windows ### -->

Встановлення Git на комп’ютері під управлінням операційної системи Windows не повинно викликати проблем.

Одну з найпростіших процедур встановлення пропонує проект msysGit. Просто звантажте встановлювач зі сторінки на GitHub і запустіть процес встановлення:

<!-- Installing Git on Windows is very easy. The msysGit project has one of the easier installation procedures. Simply download the installer exe file from the GitHub page, and run it: -->

	http://msysgit.github.com/

Після встановлення, ви отримаєте і командний рядок (що включає також SSH клієнт), і стандартний графічний інтерфейс.

<!-- After it’s installed, you have both a command-line version (including an SSH client that will come in handy later) and the standard GUI. -->

Примітка: ви можете використовувати Git з командним рядком msysGit, він допускає набори команд, що наводяться в цій книзі. Якщо ж, з якихось причин, вам потрібно використовувати вбудований у Windows командний рядок, то замість простих одинарних лапок потрібно використовувати подвійні (наприклад, для параметрів, що містять пробіли чи закінчуються символом "^", оскільки це символ продовження).

<!-- Note on Windows usage: you should use Git with the provided msysGit shell (Unix style), it allows to use the complex lines of command given in this book. If you need, for some reason, to use the native Windows shell / command line console, you have to use double quotes instead of simple quotes (for parameters with spaces in them) and you must quote the parameters ending with the circumflex accent (^) if they are last on the line, as it is a continuation symbol in Windows. -->

## Початкове налаштування ##

<!-- ## First-Time Git Setup ## -->

Тепер, маючи у своїй системі Git, варто зробити деякі налаштування його середовища. Це потрібно зробити лише один раз, оновлення не перезаписуватимуть їх. Втім, ви завжди можете внести зміни, повторно виконавши потрібні команди.

<!-- Now that you have Git on your system, you’ll want to do a few things to customize your Git environment. You should have to do these things only once; they’ll stick around between upgrades. You can also change them at any time by running through the commands again. -->

Git містить інструмент під назвою "git config", що дозволяє переглядати та встановлювати налаштування, від яких залежить вигляд та функціонал Git. Ці налаштування можуть зберігатись у трьох різних місцях:

<!-- Git comes with a tool called git config that lets you get and set configuration variables that control all aspects of how Git looks and operates. These variables can be stored in three different places: -->

*   файл `/etc/gitconfig`: містить значення змінних усіх користувачів системи та їхніх репозиторіїв. Для звернення до цього файлу потрібно в команду `git config` передати параметр `--system`.

<!-- *	`/etc/gitconfig` file: Contains values for every user on the system and all their repositories. If you pass the option` --system` to `git config`, it reads and writes from this file specifically. -->

*   файл `~/.gitconfig` містить налаштування лише для вашого користувача. Працювати з цим файлом можна за допомогою опції `--global`.

<!-- *	`~/.gitconfig` file: Specific to your user. You can make Git read and write to this file specifically by passing the `--global` option. -->

*   конфігураційний файл у директорії Git (`.git/config`) стосується лише цього окремого репозиторію. Значення кожного наступного равня мають пріоритет перед попереднім, тож значення з `.git/config` більш важливі, ніж з `/etc/gitconfig`. 

<!-- *	config file in the git directory (that is, `.git/config`) of whatever repository you’re currently using: Specific to that single repository. Each level overrides values in the previous level, so values in `.git/config` trump those in `/etc/gitconfig`. -->

У системі Windows Git шукатиме файл `.gitconfig` у директорії `$HOME` (`%USERPROFILE%` у системному середовищі), що зазвичай вказує на `C:\Documents and Settings\$USER` або `C:\Users\$USER`, в залежності від версії операційної системи. Крім того, шукатиметься також файл /etc/gitconfig, що пов’язаний з кореневою директорією MSys, яка знаходиться там, де ви вирішили встановити Git.

<!-- On Windows systems, Git looks for the `.gitconfig` file in the `$HOME` directory (`%USERPROFILE%` in Windows’ environment), which is `C:\Documents and Settings\$USER` or `C:\Users\$USER` for most people, depending on version (`$USER` is `%USERNAME%` in Windows’ environment). It also still looks for /etc/gitconfig, although it’s relative to the MSys root, which is wherever you decide to install Git on your Windows system when you run the installer. -->

### Особисті налаштування ###

<!-- ### Your Identity ### -->

Перша річ, про яку варто подбати після встановлення Git, вказати ваше ім’я та адресу електронної пошти. Це важливо, оскільки кожна фіксація змін використовує цю інформацію і записує її у дані про знімки:

<!-- The first thing you should do when you install Git is to set your user name and e-mail address. This is important because every Git commit uses this information, and it’s immutably baked into the commits you pass around: -->

	$ git config --global user.name "Ivan Franko"
	$ git config --global user.email ivanfranko@example.com

Знову ж таки, за умови використання параметру `--global`, вам знадобиться виконати цю дію лише одного разу. Git постійно використовуватиме вказану інформацію для кожної з ваших дій у цій системі. Змінити введені ім’я чи адресу пошти для окремих проектів можна, знаходячись у директорії проекту, тими ж командами, але вже без використання параметру `--global`.

<!-- Again, you need to do this only once if you pass the `--global` option, because then Git will always use that information for anything you do on that system. If you want to override this with a different name or e-mail address for specific projects, you can run the command without the `--global` option when you’re in that project. -->

### Редактор ###

<!-- ### Your Editor ### -->

Тепер, коли особисті налаштування у порядку, ви можете вказати який текстовий редактор бажаєте використовувати у випадках, коли знадобиться вводити текстову інформацію. Типово Git використовує редактор, що є стандартним у системі (зазвичай це Vi чи Vim). Для того щоб змінити його на інший (наприклад, Emacs), потрібно виконати таку команду: 

<!-- Now that your identity is set up, you can configure the default text editor that will be used when Git needs you to type in a message. By default, Git uses your system’s default editor, which is generally Vi or Vim. If you want to use a different text editor, such as Emacs, you can do the following: -->

	$ git config --global core.editor emacs

### Утиліта порівняння ###

<!-- ### Your Diff Tool ### -->

Іншою корисною опцією може бути використання певної утиліти порівняння, що буде використовуватись для розв’язання конфліктів при об’єднанні знімків. Припустімо, це має бути vimdiff:

<!-- Another useful option you may want to configure is the default diff tool to use to resolve merge conflicts. Say you want to use vimdiff: -->

	$ git config --global merge.tool vimdiff

Git сприймає kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge, та opendiff у якості коректних значень. Також ви можете вказати інший інструмент, про що більш детальніше розповідається у Розділі 7.

<!-- Git accepts kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge, and opendiff as valid merge tools. You can also set up a custom tool; see Chapter 7 for more information about doing that. -->

### Перевірка налаштувань ###

<!-- ### Checking Your Settings ### -->

Для перегляду своїх налаштувань використовуйте команду `git config --list`:

<!-- If you want to check your settings, you can use the `git config --list` command to list all the settings Git can find at that point: -->

	$ git config --list
	user.name=Taras Shevchenko
	user.email=taras@example.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...
	
<!--$ git config --list
    user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	... -->

Деякі ключі можуть зустрічатись декілька разів. Це може статись через те, що Git шукає значення у різних місцях (наприклад, `/etc/gitconfig` та `~/.gitconfg`). В такому випадку, Git використовує останнє знайдене значення для кожного з ключів.

<!-- You may see keys more than once, because Git reads the same key from different files (`/etc/gitconfig` and `~/.gitconfig`, for example). In this case, Git uses the last value for each unique key it sees. -->

Також, за допомогою конструкції `git config {key}` можна перевірити значення певного ключа:

<!-- You can also check what Git thinks a specific key’s value is by typing `git config {key}`: -->

    $ git config user.name
	Taras Shevchenko
	
<!-- $ git config user.name
    Scott Chacon -->

## Отримання допомоги ##

<!-- ## Getting Help ## -->

У випадку, якщо вам знадобиться допомога, існує три шляхи доступу до керівництва з використання для будь-якої команди Git:

<!-- If you ever need help while using Git, there are three ways to get the manual page (manpage) help for any of the Git commands: -->

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

Наприклад, так ви можете переглянути допоміжну інформацію щодо використання команди config:

<!-- For example, you can get the manpage help for the config command by running -->

	$ git help config

Особлива зручність цих команд у том, що вони доступні навіть без підключення до мережі.

Якщо ж офіційного керівництва  і цієї книжки буде недостатньо, і вам знадобиться персональна допомога, спробуйте під’єднатись до каналу `#git` або `#github` на IRC сервері Freenode. Там постійно перебувають сотні людей, що добре розуміються на роботі з Git і готові допомогти. 

<!-- These commands are nice because you can access them anywhere, even offline.
If the manpages and this book aren’t enough and you need in-person help, you can try the `#git` or `#github` channel on the Freenode IRC server (irc.freenode.net). These channels are regularly filled with hundreds of people who are all very knowledgeable about Git and are often willing to help. -->

## Підсумок ##

<!-- ## Summary ## -->

Тепер ви знаєте що таке Git і в чому його відмінність від централізованих систем контролю версій, з якими ви, можливо, вже знайомі. Також ви отримали у своїй системі робочу версію Git з персональними налаштуваннями.

Настав час дізнатись про Git більше.

<!-- You should have a basic understanding of what Git is and how it’s different from the CVCS you may have been using. You should also now have a working version of Git on your system that’s set up with your personal identity. It’s now time to learn some Git basics. -->
