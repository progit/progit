# Введение #

Эта глава расскажет вам о том, как начать работу с Git.  Мы начнем с рассмотрения некоторых основ версионного контроля, затем рассмотрим, как запустить Git на вашей системе, и, наконец, как настроить его для начала работы.  В конце этой главы вы поймете, почему Git так популярен, почему вам следует его использовать, и что необходимо для этого сделать. 

## О версионном контроле ##

Так что же такое версионный контроль и почему это должно вас волновать? Версионный контроль - это система которая записывает изменения файла или набора файлов во времени, позволяя вам в последствии получить определенную версию. В качестве примеров контролируемых файлов в этой книге использутся исходнный код программ, хотя на практике версионный контроль может применяться для любых файлов.

Если вы дизайнер или веб-дизайнер и хотите хранить каждую версию изображения или макета (что практически всегда вам необходимо), система контроля версий (Version Control System, VCS) - разумный выбор для решения этой проблемы. Она позволит вам откатить файлы к их предыдущиму состоянию, откатить к предыдущему состоянию целый проект, просматривать сделанные изменения, просмотреть, кто последний изменил что-то, что могло привести к проблеме, кто и когда внес проблему и т.д. Использование VCS означает также, что если вы испортили или потеряли файлы, вы можете их легко восстановить. Кроме того, вы получаете это все с крайне малыми затратами.

### Локальные системы контроля версий. ###

Распространенным методом версионного контроля является простое копирование файлов в другую папку (самые продвинутые добавляют дату в название папки). Это решение в силу своей простоты весьма распространено, однако зачастую ведет к ошибкам. Забыв, в каком каталоге вы сейчас находитесь, можно случайно сохранить не в тот файл или скопировать не те файлы, которые вы хотели.

Для решения этой проблемы много лет назад были разработаны локальные VCS, которые хранили все изменения контролируемых файлов в своей базе данных (см. рисунок 1-1).

Insert 18333fig0101.png 
Рисунок 1-1. Схема локальной VCS

Одной из наиболее популярных VCS данного типа является rcs, которая до сих пор устанавливается на многие компьютеры. Даже в современной операционной системе Mac OS X утилита rcs устанавливается вместе с Developer Tools. Эта улилита основана на работе с наборами патчей (являющимися различием между файлами) между двумя изменениями, хранимыми в специальном формате на диске. Это позволяет пересоздать любой файл на любой момент времени последовательно накладывая патчи.

### Централизованные системы контроля версий ###

Следующей глобальной проблемой оказалась нобходимость взаимодействия с разработчиками других систем. Чтобы решить эту проблему, были созданы Централизованные Системы Контроля Версий (Centralized Version Control Systems, CVCS). Такие системы, как CVS, Subversion и Perforce, обладают одним сервером хранящим все версии файлов и множеством клиентов, которые получают рабочие копии файлов из этого центрального хранилища. На многие годы это стало стандартным подходм к версионному контролю (см. рис. 1-2). 

Insert 18333fig0102.png 
Рисунок 1-2. Схема централизованного контроля версий

Такой подход имеет множество преимуществ, особенно над локальными VCS. К примеру, все знают кто и чем занимается на проекте. Администраторы имеют четкий контроль над тем, кто и что может делать, и, конечно, гораздо легче администрировать CVSC, чем локальные базы на каждом клиенте.

Однако есть и несколько серьезных недостатков при таком подходе. Наиболее очевидный - централизованый сервер является уязвимым местом всей системы. Если этот сервер выключается на час, то в течение часа не происходит взаимодействие между разработчиками и никто не может сохранить новые версии. Если же повреждается диск с центральной базой данных и нет резервной копии, вы теряете абсолютно все - всю историю проекта, за исключением разве что нескольких рабочих версий, сохранившихся на рабочих машинах пользователей. Локальные системы контроля версий подвержены той же проблеме - если вся история проекта хранится в одном месте, вы рискуете потерять все.

### Распределенные системы контроля версий ###

Это ситуация, когда Распределенные Системы Контроля Версий (Distributed Version Control Systems, DVCS) вступают в дело. В DVCS (таких как Git, Mercurial, Bazaar или Darcs), клиенты не просто забирают последние версии файлов, а полностью копируют репозиторий. Поэтому в случае, когда "умирает" сервер, через который осуществлялось взаимодействие, любой клиентский репозиторий может быть скопирован обратно на сервер для восстановления. Каждый раз при получении версий файлов создается полная копия всех данных (см. рисунок 1-3).

Insert 18333fig0103.png 
Рисунок 1-3. Схема распределенной системы контроля версий

Кроме того, большая часть этих систем позвляет работать с несколькими удаленными репозиториями, таким образом, вы можете взаимодействовать с различными группами людей разными способами в одно и то же время в рамках одного проекта. Это позволяет вам вести несколько типов рабочих процессов одновременно, что не возможно в централизованных системах, таких как иерархическая модель.

## Краткая история Git ##

Как и многие замечательные вещи Git начинался в некотором роде с отказа от имеющихся решений и жарких споров. Ядро Linux - действительно очень большой открытый проект. Большую часть существования ядра Linux (1991-2002) изменения вносились в код путем приема патчей и архивирования версий. В 2002 году проект перешел на использование проприетарной распределенной системы контроля версий BitKeeper. 

В 2005 отношения между сообществом разработчиков ядра Linux и компанией, разработавшей BitKeeper, испортились, и право бесплатного пользования продуктом было отменено. Это подтолкнуло разработчиков Linux (и в частности Линуса Торвальдса, создателя Linux) приступить к разработке собственной системы, базирущейся на знаниях, полученых за время использования BitKeeper. Основные требования к новой системе были следующими:

*	Скорость	
*	Простота дизайна
*	Поддержка нелинейной разработки (тысяси параллельных веток)
*	Полная распределенность
*	Возможность эффективной работы с такими большими проектами как ядро Linux (как по скорости, так и по размеру данных)

С момента рождения в 2005 Git развивался так, чтоб быть легким в использовании, сохраняя свои первоначальные своиства. Он невероятно быстр, очень эффективен для больших проектов, а также обладает превосходной системой ветвления для нелинейной разработки (см. главу 3).

## Основы Git ##

Так что ж такое Git в двух словах? Эту часть важно усвоить, поскольку если вы поймете, что есть Git, и основы того, как он работает, вам будет гораздо проще пользоваться им эффективно. Когда вы изучаете Git, постарайтесь освободиться от всего, что вы знали о других VCS, таких как Subversion или Perforce. Это позволит вам избежать коварных ловушек при использовании Git. Git хранит и работает с информацией иначе, чем другие системы, даже когда пользовательский интерфейс очень похож. Понимание этих различий поможет вам не запутаться при его использовании.

### Snapshots, Not Differences ###

Главное из отличей Git от других VCS (например Subversion) заключается в способе работы с данными. Концептуально большинство других систем хранит информацию как список изменений по файлам. Эти системы (CVS, Subversion, Perforce, Bazaar и другие) относятся к хранимым данным как к набору файлов и изменениям в каждом из них во времени, как показано на рисунке 1-4.

Insert 18333fig0104.png 
Рисунок 1-4. Другие системы хранят данные как изменения к базовой версии для каждого файла.

Git хранит данные другим способом. Вместо этого Git считает хранимые данные набором слепков мини файловой системы. Каждый раз когда вы делаете коммит (фиксацию? =), т.е. сохраняете текущую версию проекта в Git, он по сути сохраняет как выгядят все файлы вашего проекта на текущий момент и сохраняет в виде слепка. В целях сохранения эффективности, если файлы не менялись Git сохраняет не сам файл, а ссылку на ранее сохраненный файл. Подход Git к хранению данных приблизительно показан на рисунке 1-5. 

Insert 18333fig0105.png 
Рисунок 1-5. Git хранит данные как слепки состояний проекта во времени.

Это важное отличие Git от практически всех других систем контроля версий. Это наполняет новым смыслом практически все аспекиы версионного контроля, которые другие системы взяли от своих предшествениц. Это делает Git больше похожим на небольшую файловую систему, с невероятно мощными инструментами работающими поверх нее, чем на просто VCS. Мы рассмотрим некоторые преимущества, которые вы получаете, думая о хранении данных, когда коснемся работы с ветвями в Git в главе 3. 

### Использование локальных операций ###

Для совершения большинства операций в Git необходимы только локальные файлы и ресурсы, т.е. обычно информация с других компьютеров в сети не нужна. Если вы пользовались централизованными системами, где практически на каждую операцию накладывается сетевая задержка, этот аспект работы Git заставит вас подумать, что боги скорости наделили Git неземной силой. Поскольку вся история проекта хранится локально у вас на диске, большинство операций выглядит практически мгновенными. 

К примеру, чтобы просматривать историю проекта Git, не нужно предварительно скачивать эти данные с сервера, достаточно просто прочитать её непосредственно из вашего локального репозитория. Это позовляет просматривать историю практически моментально. Если вам нужно просмотреть изменения между текущей версией файла и версией, сделаной месяц назад, Git может прочитать файл месячной давности и вычислить разницу локально, вместо того чтоб посылать запрос на получение разницы на удаленный сервер или стягивать старую версию файла с сервера и делать локальное сравнение. 

Также это означает, что только небольшую часть операций вы не можете сделать без доступа к сети или VPN. Когда вы летите в самолете или путешествуете поездом и хотите немного поработать, вы можете сохранять новые версии и отгрузить их, когда сетевое соединение будет доступно. Придя домой и не сумев подключить ваш VPN кленет, вы можете продолжать работать. Во многих других системах это невозможно, или же крайне неудобно. Используя Perforce, к примеру, вы не сможете сделать многого без соединения с сервером. Работая с Subversion и CVS вы можете редактироваться файлы, но вы не можете сохранить изменения в базе (потому что база отключена). Возможно сейчас это не выглядит существенным, но потом вы удивитесь, увидев, на сколько это бывает важным.

### Git следит за целостностью данных ###

Перед сохранением любых данных Git вычисляет контрольные суммы, которые в дальнейшем используются в качестве ключа для доступа к данным. Из этого следует, что невозможно изменить содержимое файла или каталога так, чтобы Git об этом не знал. Эта функциональность имплементирована на самых нижних уровнях Git и является важной составляющей его философии. Вы не потеряете информацию при передаче данных или в случае повреждения файлов, поскольку Git всегда может это определить.

Механизм используемый Git для вычисления контрольных сумм называется хэш SHA-1. Результатом вычисления контрольной суммы является 40-символьная строка, содержащия шестнадцатеричные цифры (0-9 и a-f). Она вычисляется на основе содержимого файла или каталога, хранимого Git. SHA-1 хэш выглядить примерно так: 

	24b9da6552252987aa493b52f8696cd6d3b00373

Работая с Git, вы будете постоянно встречать эти хэши, поскольку они очень активно используются. Фактически Git сохраняет данные не по имени файла, а обращается к файлам в своей базе, адресуя их по хэшам их содержимого.

### Git практически всегда добавляет данные ###

Практически все действия, которые вы совершаете в Git, только добавляют данные в базу данных. Поэтому очень сложно заставить систему сделать что-то неотменяемое или приводящее к удалению данных. Конечно, как и в любой другой системе контроля версий, вы можете потерять изменения, которые еще не были сохранены в Git, но после того, как вы сделали коммит (фиксацию? =))), очень сложно их потерять, особенно если вы регулярно отправляете вашу базу в другой репозиторий.

Это делает использование Git похожим на игру, поскольку вы можете эксперементировать, не боясь серьезно что-то поломать. Если вы хотите более детально изучить, как Git хранит данные и как вы можете восстановить их, когда вдруг кажется, что они потерялись, ознакомьтесь с разделом "Under the Covers" в главе 9.

### Три состояния ###

Теперь, внимание. Это одна из главных вещей которую вы должны запомнить о Git, если вы хотить чтобы дальнейшее изучение прошло гладко. В Git файлы могут находиться в одном из трех состояний: зафиксированные,измененные и подготовленные. Если файл зафиксирован, это означает, что он уже сохранен в вашей локальной базе. К измененным относятся файлы, которые поменялись, но еще не были зафиксированны. Подготовленные файлы – это файлы, которые вы пометили для включения в следующий коммит (фиксацию? =))).

Now, pay attention. This is the main thing to remember about Git if you want the rest of your learning process to go smoothly. Git has three main states that your files can reside in: committed, modified, and staged. Committed means that the data is safely stored in your local database. Modified means that you have changed the file but have not committed it to your database yet. Staged means that you have marked a modified file in its current version to go into your next commit snapshot.

Таким образом, в проекте с использованием Git есть три части: каталог Git (Git directory), рабочий каталог (working directory) и область подготовленых файлов (staging area).

This leads us to the three main sections of a Git project: the Git directory, the working directory, and the staging area.

Insert 18333fig0106.png 
Рисунок 1-6. Рабочий каталог, область подготовленых файлов, каталог Git.

Каталог Git – это место где Git хранит метаданные и базу данных объектов вашего проекта. Это наиболее важная часть Git, и именно она копируется, когда вы клонируете репозиторий с другого компьютера.

The Git directory is where Git stores the metadata and object database for your project. This is the most important part of Git, and it is what is copied when you clone a repository from another computer.

Рабочая директория — это извлеченная из базы копия определенной версии проекта. Эти файлы, извлеченные из сжатой базы данных в каталоге Git и помещенные на диск для просмотра и модификаций.

The working directory is a single checkout of one version of the project. These files are pulled out of the compressed database in the Git directory and placed on disk for you to use or modify.

Область подготовленных файлов - это файл, обычно хранящийся в вашем каталоге Git, который соодержит информацию о том, что должно войти в следующий коммит. Иногда ее называют индексом (index), но последнее время становится стандартом называть ее областью подготовленых фалов.

The staging area is a simple file, generally contained in your Git directory, that stores information about what will go into your next commit. It’s sometimes referred to as the index, but it’s becoming standard to refer to it as the staging area.

Стандартный рабочий процесс с использованием Git выглядит примерно так:

The basic Git workflow goes something like this:

1.	Вы изменяете файлы в вашем рабочем каталоге.
2.	Вы подготавливаете файлы, добавляя их слепки в область подготовленых файлов.
3.	Вы делаете коммит, при этом слепки файлов, сохраненные в области подготовленных файлов, перемещаются на хранение в каталог Git.

1.	You modify files in your working directory.
2.	You stage the files, adding snapshots of them to your staging area.
3.	You do a commit, which takes the files as they are in the staging area and stores that snapshot permanently to your Git directory.

Если рабочая версия файла совпадает с версией в каталоге Git, файл считается зафиксированым. Если файл изменен, но добавлен в область подготовленных данных, он подготовлен к коммиту. Если ж файл изменен, но не подготовлен, то он считается модифицированным. В главе 2 вы узнаете больше об этих трех сосотояних и как вы можете, либо получить преимущество, либо пропустить стадию подготовленных файлов.

If a particular version of a file is in the git directory, it’s considered committed. If it’s modified but has been added to the staging area, it is staged. And if it was changed since it was checked out but has not been staged, it is modified. In Chapter 2, you’ll learn more about these states and how you can either take advantage of them or skip the staged part entirely.

## Установка Git ##

Настало время немного ознакомиться с использованием Git. Первое, что вам необходимо сделать – установить его. Есть несколько способов сделать это; два основных ― установка из исходников и установка собранного пакета для вашей платформы.

Let’s get into using some Git. First things first—you have to install it. You can get it a number of ways; the two major ones are to install it from source or to install an existing package for your platform.

### Установка из исходников ###

Установка из исходного кода обычно лучше, поскольку вы получаете самую свежую версию. Каждая новая версия Git обычно включает полезные улучшения интерфейса, поэтому установка последней версии - часто лучший выбор, если конечно вас не затрудняет установка программ из исходников. Это также правильный выбор, поскольку многие дистрибутивы Linux содержат очень старые пакеты, поэтому если вы не используете очень свежий дистрибутив или , установка из исходников лучше.

If you can, it’s generally useful to install Git from source, because you’ll get the most recent version. Each version of Git tends to include useful UI enhancements, so getting the latest version is often the best route if you feel comfortable compiling software from source. It is also the case that many Linux distributions contain very old packages; so unless you’re on a very up-to-date distro or are using backports, installing from source may be the best bet.

Для установки Git, вам понадобятся следующие библиотеки, являющиеся зависимостями: curl, zlib, openssl, expat, and libiconv. Если вы, к примеру, используете систему, в которой есть yum (такую как Fedora) или apt-get (такую как системы основаные на Debian), вы можете использовать одну из следующих команд, чтобы разрешить все зависимости.

To install Git, you need to have the following libraries that Git depends on: curl, zlib, openssl, expat, and libiconv. For example, if you’re on a system that has yum (such as Fedora) or apt-get (such as a Debian based system), you can use one of these commands to install all of the dependencies:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev 
	
После того, как вы поставите все необходимые библиотеки, вы можете начинать установку, скачав последнюю версию с сайта Git:

When you have all the necessary dependencies, you can go ahead and grab the latest snapshot from the Git web site:

	http://git-scm.com/download
	
Теперь скомпилируйте и установите:

Then, compile and install:

	$ tar -zxf git-1.6.0.5.tar.gz
	$ cd git-1.6.0.5
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

После этого вы можете клонировать исходный код Git с помощью Git, для получения обновлений:

After this is done, you can also get Git via Git itself for updates:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	
### Установка в Linux ###

Если вы хотитие установить Git под Linux как бинарный пакет, вы можете это сделать, используя утилиту для управления пакетами, входящую в ваш дистрибутив. Если вы используете Fedora, вы можете воспользоваться yum:

If you want to install Git on Linux via a binary installer, you can generally do so through the basic package-management tool that comes with your distribution. If you’re on Fedora, you can use yum:

	$ yum install git-core

Если ж у вас дистрибутив основаный на Debian, например Ubuntu, попробуйте apt-get:

Or if you’re on a Debian-based distribution like Ubuntu, try apt-get:

	$ apt-get install git-core

### Установка на Mac ###

Есть два простых способа установить Git на Mac. Более простой ― использовать графический инсталлятор Git, который вы можете скачать со страницы Google Code (см. рисунок 1-7):

There are two easy ways to install Git on a Mac. The easiest is to use the graphical Git installer, which you can download from the Google Code page (see Рисунок 1-7):

	http://code.google.com/p/git-osx-installer

Insert 18333fig0107.png 
Рисунок 1-7. Инсталлятор Git под OS X.

Другой распространенный способ установка Git через MacPorts (`http://www.macports.org`). Если у вас установлены MacPorts, инсталлируйте Git так:

The other major way is to install Git via MacPorts (`http://www.macports.org`). If you have MacPorts installed, install Git via

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

Вы не обязаны включать все дополнения, но возможно вы захотите включить +svn в случае, если вам нужно использовать Git совместно с репозиториями Subversion (см. главу 8).

You don’t have to add all the extras, but you’ll probably want to include +svn in case you ever have to use Git with Subversion repositories (see Chapter 8).

### Установка в Windows ###

Установка Git в Windows очень проста. Проект msysGit предлагает очень простую процедуру установки. Просто скачайте exe файл инсталлятора со страницы Google Code и запустите его:

Installing Git on Windows is very easy. The msysGit project has one of the easier installation procedures. Simply download the installer exe file from the Google Code page, and run it:

	http://code.google.com/p/msysgit

После установки у вас будет как консольная версия (включающая SSH-клиент, который пригодится позднее), так и стандартная графическая.

After it’s installed, you have both a command-line version (including an SSH client that will come in handy later) and the standard GUI.

## Первоначальная настройка Git ##

Теперь, когда Git установлен в вашей системе, вам нужно настроить некоторые параметры Git. Это нужно сделать только один раз ― при обновлении настройки сохраняются. Но вы можете их поменять в любой момент выполнив те же команды снова.

Now that you have Git on your system, you’ll want to do a few things to customize your Git environment. You should have to do these things only once; they’ll stick around between upgrades. You can also change them at any time by running through the commands again.

В состав Git входит утилита git config которая позволяет вам просматривать и устанавливать параметры, котролирующие все аспекты работы и внешнего вида Git. Эти параметры могут быть сохранены в трех местах:

Git comes with a tool called git config that lets you get and set configuration variables that control all aspects of how Git looks and operates. These variables can be stored in three different places:

*	файл `/etc/gitconfig`. Содержит переменные общие для всех пользователей вашей системы и всех их репозиториев. Если вы указываете параметр `--system`, запуская `git config`, то параметры читаются и сохраняются в этот файл.
*	файл `~/.gitconfig`. Хранит настройки конкретного пользователя. Этот файл использутеся при указании параметра `--global`.
*	конфигурационный файл в каталоге Git (`.git/config`) используемого репозитория. Содержит параметры, используемые только при работе с данным репозиторием. Каждый более конкретный файл настроек имеет более высокий приоритет, чем файл предыдущего уровня, т.е. значения в `.git/config` перекрывают соответствующие значения в `/etc/gitconfig`.

*	`/etc/gitconfig` file: Contains values for every user on the system and all their repositories. If you pass the option` --system` to `git config`, it reads and writes from this file specifically. 
*	`~/.gitconfig` file: Specific to your user. You can make Git read and write to this file specifically by passing the `--global` option. 
*	config file in the git directory (that is, `.git/config`) of whatever repository you’re currently using: Specific to that single repository. Each level overrides values in the previous level, so values in `.git/config` trump those in `/etc/gitconfig`.

В системах семейства Windows, файл `.gitconfig` хранится в каталоге $HOME (`C:\Documents and Settings\$USER` для большенства пользователей). Кроме того Git ищет файл /etc/gitconfig относительно корневого каталога MSys, который вы указали в инсталляторе Git во время установки.

On Windows systems, Git looks for the `.gitconfig` file in the `$HOME` directory (`C:\Documents and Settings\$USER` for most people). It also still looks for /etc/gitconfig, although it’s relative to the MSys root, which is wherever you decide to install Git on your Windows system when you run the installer.

### Имя пользователя ###

Первое, что вам следует сделать после установки Git ― указать ваше имя и адрес электронной почты. Это важно, потому что каждый коммит в Git содержит эту информацию, и она включена в коммиты, отправляемые вами:

The first thing you should do when you install Git is to set your user name and e-mail address. This is important because every Git commit uses this information, and it’s immutably baked into the commits you pass around:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Повторюсь, что эти настройки нужно сделать один раз, если вы указываете параметр `--global`, поскольку в этом случае Git будет использовать эти данные для всего, что вы делаете в этой системе. Если вы хотить указать другое имя или электронную почту для конкретных проектов, вы можете запустить команду без параметра `--global` в каталоге с нужным проектом.

Again, you need to do this only once if you pass the `--global` option, because then Git will always use that information for anything you do on that system. If you want to override this with a different name or e-mail address for specific projects, you can run the command without the `--global` option when you’re in that project.

### Выбор редактора ###

Теперь, когда вы указали свое имя, вы можете выбрать редактор по умолчанию, который будет использоваться, когда необходимо ввести сообщение в Git. Изначально Git использует редактор по умолчанию для вашей системы, обычно это Vi или Vim. Если вы хотите использовать другой текстовый редактор, например Emacs, вы можете воспользоваться командой:

Now that your identity is set up, you can configure the default text editor that will be used when Git needs you to type in a message. By default, Git uses your system’s default editor, which is generally Vi or Vim. If you want to use a different text editor, such as Emacs, you can do the following:

	$ git config --global core.editor emacs
	
### Утилита сравнения ###

Другая полезная настройка, которая может вам понадобиться ― утилита сравнения по умолчанию, которая будет использоваться для разрешения конфликтов слияния. Например для vimdiff:

Another useful option you may want to configure is the default diff tool to use to resolve merge conflicts. Say you want to use vimdiff:

	$ git config --global merge.tool vimdiff

Git умеет работать с kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge и opendiff, но вы можете настроить и другую утилиту, о чем вы можете прочитать в главе 7.

Git accepts kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge, and opendiff as valid merge tools. You can also set up a custom tool; see Chapter 7 for more information about doing that.

### Проверка настроек ###

Если вы хотите проверить используемые настройки, вы можете воспользоваться командой `git config --list`, чтоб просмотреть все настройки:

If you want to check your settings, you can use the `git config --list` command to list all the settings Git can find at that point:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

Вы можете обнаружить некоторые параметры несколько раз, потому что Git прочитал их из разных файлов (например из `/etc/gitconfig` и `~/.gitconfig`). В этом случае используется последнее значение для каждого найденного параметра.

You may see keys more than once, because Git reads the same key from different files (`/etc/gitconfig` and `~/.gitconfig`, for example). In this case, Git uses the last value for each unique key it sees.

Также вы можете проверить значение конкретного параметра выполнив `git config {параметр}`:

You can also check what Git thinks a specific key’s value is by typing `git config {key}`:

	$ git config user.name
	Scott Chacon

## Как получить помощь? ##

Если вам нужна помощь при использовании Git, есть три способа открыть страницу руководства (manpage) по любой команде Git:

If you ever need help while using Git, there are three ways to get the manual page (manpage) help for any of the Git commands:

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

Например, вы можете открыть руководство на команду config, запустив:

For example, you can get the manpage help for the config command by running

	$ git help config

Эти команды также хороши тем что вы всегда можете ими воспользоваться, даже без подключения к сети.
Если руководства и этой книги недостаточно, и вам нужна персональная помощь, вы можете попытаться поискать ее на каналах `#git` и `#github` сервера Freenode IRC (irc.freenode.net). Обычно там сотни людей отлично знающих Git, могущих помочь.

These commands are nice because you can access them anywhere, even offline.
If the manpages and this book aren’t enough and you need in-person help, you can try the `#git` or `#github` channel on the Freenode IRC server (irc.freenode.net). These channels are regularly filled with hundreds of people who are all very knowledgeable about Git and are often willing to help.

## Итоги ##

Теперь у вас должно быть общее понимание, что такое Git, и чем он отличается от CVCS, которыми вы могли пользоваться раньше. Также у вас должна быть установлена рабочая версия Git с вашими личными настройками. Настало время перейти изучению некоторых основ Git.

You should have a basic understanding of what Git is and how it’s different from the CVCS you may have been using. You should also now have a working version of Git on your system that’s set up with your personal identity. It’s now time to learn some Git basics.
