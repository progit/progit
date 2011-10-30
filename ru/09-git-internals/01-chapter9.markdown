# Git изнутри #

Вы могли прочитать почти всю книгу перед тем, как приступить к этой главе, а могли только часть. Так или иначе, в данной главе рассматриваются внутренние процессы Git и особенности его реализации. На мой взгляд, изучение этих вещей это основа понимания того насколько Git полезный и мощный инструмент. Хотя некоторые утверждают, что изложение этого материал может сбить новичков с толку и оказаться для них неоправданно сложным. Именно поэтому эта глава отнесена в конец, давая возможность заинтересованным освоить её раньше, а сомневающимся — позже.

Итак, приступим. Во-первых, напомню, что Git это по сути контентно-адресуемая файловая система с пользовательским СУВ-интерфейсом поверх неё. Довольно скоро станет понятнее, что это значит.

На заре развития Git (примерно до версии 1.5), интерфейс был значительно сложнее, поскольку был более похож на интерфейс доступа к файловой системе, чем на законченную СУВ. За последние годы, интерфейс значительно улучшился и по удобству не уступает аналогам; у некоторых, тем не менее, с тех пор сохранился стереотип о том, что интерфейс у Git чересчур сложный и труден для изучения.

Контентно-адресуемая файловая система — основа Git, очень интересна, именно её мы сначала рассмотрим в этой главе; далее будут рассмотрены транспортные механизмы и инструменты обслуживания репозитория, с которыми вам в своё время возможно придётся столкнуться.

## Сантехника и фарфор ##

В этой книге было описано как пользоваться Git используя примерно три десятка команд, например, `checkout`, `branch`, `remote` и т.п. Но так как сначала Git был скорее инструментарием для создания СУВ, чем СУВ удобной для пользователей, в нём полно команд, выполняющих низкоуровневые операции, которые спроектированы так, чтобы их можно было использовать в цепочку в стиле UNIX, а также использовать в сценариях. Эти команды как правило называют служебными ("plumbing" — трубопровод), а более ориентированные на пользователя называют пользовательскими ("porcelain" — фарфор).

Первые восемь глав книги были посвящены практически только пользовательским командам. В данной главе же рассматриваются именно низкоуровневые служебные команды, дающие контроль над внутренними процессами Git и показывающие, как он работает и почему он работает так, а не иначе. Предполагается, что данные команды не будут использоваться напрямую из командной строки, а будут служить в качестве строительных блоков для новых команд и пользовательских сценариев.

Когда вы выполняете `git init` в новом или существовавшем ранее каталоге, Git создаёт подкаталог `.git`, в котором располагается почти всё, чем он заправляет. Если требуется выполнить резервное копирование или клонирование репозитория, достаточно скопировать всего лишь один этот каталог, чтобы получить почти всё необходимое. И данная глава почти полностью посвящена его содержимому. Вот так он выглядит:

	$ ls 
	HEAD
	branches/
	config
	description
	hooks/
	index
	info/
	objects/
	refs/

Там могут быть и другие файлы, но непосредственно после `git init` вы увидите именно это. Каталог `branches` не используется новыми версиями Git, а файл `description` требуется только программе GitWeb, на них не стоит обращать особого внимания. Файл `config` содержит настройки проекта, а каталог `info` — файл с глобальным фильтром, игнорирующим те файлы, которые вы не хотите поместить в .gitignore. В каталоге `hooks` располагаются клиентские и серверные хуки, подробно рассмотренные в главе 7.

Итак, осталось четыре важных элемента: файлы `HEAD`, `index` и каталоги `objects`, `refs`. Это ключевые элементы хранилища Git. В каталоге `objects` находится, собственно, база данных, в `refs` — ссылки на объекты коммитов в этой базе (ветки). Файл `HEAD` указывает на текущую ветку, и в файле `index` хранится информация индекса. В последующих разделах данные элементы будут рассмотрены более подробно.

## Объекты в Git ##

Git — контентно-адресуемая файловая система. Здорово. Но что это означает?
А означает это, что в своей основе Git — простое хранилище ключ-значение. Можно добавить туда любое содержимое, в ответ будет выдан ключ, по которому это содержимое можно извлечь. Для примера, можно воспользоваться служебной командой `hash-object`, которая добавляет данные в каталог `.git` и возвращает ключ. Для начала создадим новый Git-репозиторий и убедимся, что каталог `objects` пуст:

	$ mkdir test
	$ cd test
	$ git init
	Initialized empty Git repository in /tmp/test/.git/
	$ find .git/objects
	.git/objects
	.git/objects/info
	.git/objects/pack
	$ find .git/objects -type f
	$

Git проинициализировал каталог `objects` и создал в нём подкаталоги `pack` и `info`, пока без файлов. Теперь добавим кое-какое текстовое содержимое в базу Git'а:

	$ echo 'test content' | git hash-object -w --stdin
	d670460b4b4aece5915caf5c68d12f560a9fe3e4

Ключ `-w` команды `hash-object` указывает, что объект необходимо сохранить, иначе команда просто выведет ключ и всё. Флаг `--stdin` указывает, что данные необходимо считать со стандартного ввода, в противном случае `hash-object` ожидает имя файла. Вывод команды — 40-символьная контрольная сумма. Это хеш SHA-1 — контрольная сумма содержимого и заголовка, который будет рассмотрен позднее. Теперь можно увидеть, в каком виде будут сохранены ваши данные:

	$ find .git/objects -type f 
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4

В каталоге `objects` появился файл. Это и есть начальное внутреннее представление данных в Git — один файл на единицу хранения с именем, являющимся контрольной суммой содержимого и заголовка. Первые два символа SHA определяют подкаталог файла, остальные 38 — собственно, имя.

Получить обратно содержимое объекта можно командой `cat-file`. Это своеобразный шведский армейский нож для проверки объектов в Git. Ключ `-p` означает автоматическое определение типа содержимого и вывод содержимого на печать в удобном виде:

	$ git cat-file -p d670460b4b4aece5915caf5c68d12f560a9fe3e4
	test content

Теперь вы умеете добавлять данные в Git и извлекать их обратно. То же самое можно делать и с файлами. Рассмотрим пример. Наиболее простой контроль версий файла можно осуществить, создав его и сохранив в базе:

	$ echo 'version 1' > test.txt
	$ git hash-object -w test.txt 
	83baae61804e65cc73a7201a7252750c76066a30

Теперь изменим файл и сохраним его в базе ещё раз:

	$ echo 'version 2' > test.txt
	$ git hash-object -w test.txt 
	1f7a7a472abf3dd9643fd615f6da379c4acb3e3a

Теперь в базе содержатся две версии файла test.txt, а также самый первый сохранённый объект:

	$ find .git/objects -type f 
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4

Теперь можно откатить файл к его первой версии:

	$ git cat-file -p 83baae61804e65cc73a7201a7252750c76066a30 > test.txt 
	$ cat test.txt 
	version 1

или второй:

	$ git cat-file -p 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a > test.txt 
	$ cat test.txt 
	version 2

Однако запоминать хеш для каждой версии неудобно, к тому же теряется само имя файла, сохраняется лишь содержимое. Объекты такого типа называют блобами (англ. binary large object). Имея SHA-1 объекта, можно попросить Git показать нам его тип с помощью команды `cat-file -t`:

	$ git cat-file -t 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a
	blob

### Объекты-деревья ###

Рассмотрим другой тип объектов Git — деревья. Они решают проблему хранения имён файлов, а также позволяют хранить группы файлов вместе. Система хранения данных Git подобна файловым системам UNIX в упрощённом виде. Содержимое хранится в объектах-деревьях и блобах, дерево соответствует записи каталога в ФС, а блоб более или менее соответствует inode или содержимому файла. Объект-дерево может содержать одну и более записей, каждая из которых представляет собой набор из SHA-1 хеша, соответствующего блобу или поддереву, режима доступа к файлу, типа и имени файла. Например, в проекте simplegit дерево на момент написания выглядит так:

	$ git cat-file -p master^{tree}
	100644 blob a906cb2a4a904a152e80877d4088654daad0c859      README
	100644 blob 8f94139338f9404f26296befa88755fc2598c289      Rakefile
	040000 tree 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0      lib

Запись `master^{tree}` означает объект-дерево, на который указывает последний коммит ветки `master`. Заметьте, что подкаталог `lib` — не блоб, а указатель на другое дерево:

	$ git cat-file -p 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0
	100644 blob 47c6340d6459e05787f644c2447d2595f5d3a54b      simplegit.rb

Схематически, данные, которые хранятся в Git, выглядят примерно так, как это изображено на рисунке 9-1.

Insert 18333fig0901.png 
Рисунок 9-1. Упрощённая модель данных Git.

Вручную можно создавать не только блобы, но и деревья. Git обычно создаёт дерево исходя из состояния индекса и затем сохраняет соответствующий объект-дерево. Поэтому для создания объекта-дерева необходимо проиндексировать какие-нибудь файлы. Для создания индекса из одной записи — первой версии файла text.txt, воспользуемся командой `update-index`. Данная команда может искусственно добавить более раннюю версию test.txt в новый индекс. Необходимо передать опции `--add`, т.к. файл ещё не существует в индексе (да и самого индекса ещё нет), и `--cacheinfo`, т.к. добавляемого файла нет в рабочем каталоге, но он есть в базе данных. Также необходимо передать режим доступа, хеш и имя файла:

	$ git update-index --add --cacheinfo 100644 \
	  83baae61804e65cc73a7201a7252750c76066a30 test.txt

В данном случае режим доступа — `100644`, что означает обычный файл. Другие возможные варианты: `100755` — исполняемый файл, `120000` — символическая ссылка. Режимы доступа в Git сделаны по аналогии с режимами доступа в UNIX, но они гораздо менее гибки: данные три режима — единственные доступные для файлов (блобов) в Git (хотя существуют и другие режимы используемые для каталогов и подмодулей).

Теперь можно воспользоваться командой `write-tree` для сохранения индекса в объект-дерево. Здесь опция `-w` не требуется — вызов `write-tree` автоматически создаст объект-дерево по состоянию индекса, если такого дерева ещё не существует:

	$ git write-tree
	d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	$ git cat-file -p d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	100644 blob 83baae61804e65cc73a7201a7252750c76066a30      test.txt

Также можно проверить, что мы действительно создали объект-дерево:

	$ git cat-file -t d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	tree

Создадим новое дерево со второй версией файла test.txt и ещё одним файлом:

	$ echo 'new file' > new.txt
	$ git update-index test.txt 
	$ git update-index --add new.txt 

Теперь в индексе содержится новая версия файла test.txt и новый файл new.txt. Запишем это дерево (сохранив состояние индекса в объект-дерево) и посмотрим, что из этого получилось:

	$ git write-tree
	0155eb4229851634a0f03eb265b69f5a2d56f341
	$ git cat-file -p 0155eb4229851634a0f03eb265b69f5a2d56f341
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a      test.txt

Заметьте, что в данном дереве находятся записи для обоих файлов, а также, что хеш файла test.txt это хеш "второй версии" этого файла (`1f7a7a`). Для интереса, добавим первое дерево как подкаталог для текущего. Зачитать дерево в индекс можно командой `read-tree`. В нашем случае, чтобы прочитать уже существующее дерево в индекс и сделать его поддеревом, необходимо использовать опцию `--prefix`:

	$ git read-tree --prefix=bak d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	$ git write-tree
	3c4e9cd789d88d8d89c1073707c3585e41b0e614
	$ git cat-file -p 3c4e9cd789d88d8d89c1073707c3585e41b0e614
	040000 tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579      bak
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a      test.txt

Если бы вы создали рабочий каталог, соответствующий только что созданному дереву, вы бы получили два файла в корне и подкаталог `bak` со старой версией файла test.txt. Данные, которые хранит Git для такой структуры, представлены на рисунке 9-2.

Insert 18333fig0902.png 
Рисунок 9-2. Структура данных Git для текущего дерева.

### Объекты-коммиты ###

У нас есть три дерева, соответствующих разным состояниям проекта, но предыдущая проблема с необходимостью запоминать все три значения SHA-1, чтобы иметь возможность восстановить какое-либо из этих состояний, ещё не решена. К тому же у нас нет никакой информации о том, кто, когда и почему сохранил их. Такие данные — основная информация, которая хранится в объекте-коммите.

Для создания объекта-коммита необходимо вызвать `commit-tree` и задать SHA-1 нужного дерева и, если необходимо, родительские объекты-коммиты. Для начала создадим коммит для самого первого дерева:

	$ echo 'first commit' | git commit-tree d8329f
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d

Просмотреть вновь созданный объект-коммит можно командой `cat-file`:

	$ git cat-file -p fdf4fc3
	tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	author Scott Chacon <schacon@gmail.com> 1243040974 -0700
	committer Scott Chacon <schacon@gmail.com> 1243040974 -0700

	first commit

Формат объекта-коммита прост: в нём указано дерево верхнего уровня, соответствующее состоянию проекта на некоторый момент; имя автора и коммитера берутся из полей конфигурации `user.name` и `user.email`; также добавляется текущая временная метка, пустая строка и затем сообщение коммита.

Далее, создадим ещё два объекта-коммита, каждый из которых будет ссылаться на предыдущий коммит:

	$ echo 'second commit' | git commit-tree 0155eb -p fdf4fc3
	cac0cab538b970a37ea1e769cbbde608743bc96d
	$ echo 'third commit'  | git commit-tree 3c4e9c -p cac0cab
	1a410efbd13591db07496601ebc7a059dd55cfe9

Каждый из трёх объектов-коммитов указывает на одно из состояний проекта. Может показаться странным, но теперь у нас есть полноценная Git-история, которую можно посмотреть командой `git log`, указав хеш последнего коммита:

	$ git log --stat 1a410e
	commit 1a410efbd13591db07496601ebc7a059dd55cfe9
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:15:24 2009 -0700

	    third commit

	 bak/test.txt |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

	commit cac0cab538b970a37ea1e769cbbde608743bc96d
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:14:29 2009 -0700

	    second commit

	 new.txt  |    1 +
	 test.txt |    2 +-
	 2 files changed, 2 insertions(+), 1 deletions(-)

	commit fdf4fc3344e67ab068f836878b6c4951e3b15f3d
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:09:34 2009 -0700

	    first commit

	 test.txt |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Поразительно. Мы только что выполнили низкоуровневые операции для построения истории без использования высокоуровневых интерфейсов. По существу, именно это делает Git, когда выполняются команды `git add` и `git commit` — сохраняет блобы для изменённых файлов, обновляет индекс, записывает объекты-деревья и коммит-объекты, ссылающиеся на объекты-деревья верхнего уровня и предшествующие коммиты. Эти три основных вида объектов в Git: блоб, дерево и коммит — сначала сохраняются как отдельные файлы в каталоге `.git/objects`. Вот все объекты, которые сейчас лежат в каталоге с примером (в комментариях написано чему объекты соответствует):

	$ find .git/objects -type f
	.git/objects/01/55eb4229851634a0f03eb265b69f5a2d56f341 # tree 2
	.git/objects/1a/410efbd13591db07496601ebc7a059dd55cfe9 # commit 3
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a # test.txt v2
	.git/objects/3c/4e9cd789d88d8d89c1073707c3585e41b0e614 # tree 3
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30 # test.txt v1
	.git/objects/ca/c0cab538b970a37ea1e769cbbde608743bc96d # commit 2
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4 # 'test content'
	.git/objects/d8/329fc1cc938780ffdd9f94e0d364e0ea74f579 # tree 1
	.git/objects/fa/49b077972391ad58037050f2a75f74e3671e92 # new.txt
	.git/objects/fd/f4fc3344e67ab068f836878b6c4951e3b15f3d # commit 1

Если пройти по всем внутренним ссылкам, получится граф объектов такой, как на рисунке 9-3.

Insert 18333fig0903.png 
Рисунок 9-3. Все объекты в репозитории Git.

### Хранение объектов ###

Ранее я упоминал, что заголовок сохраняется вместе с содержимым. Давайте посмотрим, как сохраняются объекты Git на диске. Мы рассмотрим сохранение блоб-объекта, в данном случае это будет строка "есть проблемы, шеф?". Пример будет выполнен на языке Ruby. Для запуска интерактивного интерпретатора воспользуйтесь командой `irb`:

	$ irb
	>> content = "есть проблемы, шеф?"
	=> "есть проблемы, шеф?"

Git создаёт заголовок, начинающийся с типа объекта, в данном случае это блоб. Далее добавляется пробел, размер содержимого и в конце нулевой байт:

	>> header = "blob #{content.length}\0"
	=> "blob 34\000"

Git дописывает содержимое после заголовка и вычисляет SHA-1 сумму для полученного результата. В Ruby значение SHA-1 для строки можно получить, подключив соответствующую библиотеку командой `require` и затем воспользовавшись вызовом `Digest::SHA1.hexdigest()`:

	>> store = header + content
	=> "blob 34\000\320\225\321\201\321\202\321\214 \320\277\321\200\320\276\320\261\320\273\320\265\320\274\321\213, \321\210\320\265\321\204?"
	>> require 'digest/sha1'
	=> true
	>> sha1 = Digest::SHA1.hexdigest(store)
	=> "d8a734f44240bdf766c8df342664fde23d421d64"

Git сжимает новые данные при помощи zlib, что решается в Ruby соответствующей библиотекой. Сперва, необходимо подключить её, а после вызвать `Zlib::Deflate.deflate()` с данными в качестве параметра:

	>> require 'zlib'
	=> true
	>> zlib_content = Zlib::Deflate.deflate(store)
	=> "x\234\001*\000\325\377blob 34\000\320\225\321\201\321\202\321\214 \320\277\321\200\320\276\320\261\320\273\320\265\320\274\321\213, \321\210\320\265\321\204?\3453\030S"

После этого, запишем сжатую zlib'ом строку в объект на диск. Определим путь к файлу, который будет записан (первые два символа хеша используются в качестве названия подкаталога, оставшиеся 38 — в качестве имени файла в этом каталоге). В Ruby для этой задачи можно использовать функцию `FileUtils.mkdir_p()` для создания подкаталога, если он не существует. Далее, откроем файл вызовом `File.open()` и запишем наши сжатые данные вызовом `write()` для полученного файлового дескриптора:

	>> path = '.git/objects/' + sha1[0,2] + '/' + sha1[2,38]
	=> ".git/objects/d8/a734f44240bdf766c8df342664fde23d421d64"
	>> require 'fileutils'
	=> true
	>> FileUtils.mkdir_p(File.dirname(path))
	=> ".git/objects/bd"
	>> File.open(path, 'w') { |f| f.write zlib_content }
	=> 32

Вот и всё, мы создали корректный объект-блоб для Git. Все другие объекты создаются аналогично, меняется только запись о типе в заголовке (blob, commit, tree). Стоит добавить, что хотя в блобе может храниться почти любое содержимое, содержимое объектов-деревьев и объектов-коммитов записывается в очень строгом формате.

## Ссылки в Git ##

Для просмотра всей истории можно выполнить команду вроде `git log 1a410e`, но, опять же, требуется помнить, что именно коммит `1a410e` является последним, чтобы иметь возможность найти все наши объекты. Нам нужен файл-указатель с простым именем, который бы содержал это значение хеша SHA-1, чтобы можно было пользоваться этим файлом вместо хеша.

В Git такие файлы, содержащие SHA-1, называются ссылками ("refs") и располагаются в каталоге `.git/refs`. В нашем проекте этот каталог пока пуст, но в нём уже существует некоторая структура каталогов:

	$ find .git/refs
	.git/refs
	.git/refs/heads
	.git/refs/tags
	$ find .git/refs -type f
	$

Чтобы создать новую ссылку, которая поможет вам вспомнить, какой коммит последний, по сути, необходимо сделать всего лишь следующее:

	$ echo "1a410efbd13591db07496601ebc7a059dd55cfe9" > .git/refs/heads/master

Теперь можно использовать только что созданную ссылку из каталога heads вместо хеша в командах Git:

	$ git log --pretty=oneline  master
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Тем не менее, редактировать данные файлы напрямую не рекомендуется. Git предоставляет безопасную команду `update-ref` для изменения ссылок:

	$ git update-ref refs/heads/master 1a410efbd13591db07496601ebc7a059dd55cfe9

Вот что такое по сути ветка в Git — простой указатель или ссылка на последнюю версию в работе. Для создания ветки, соответствующей состоянию второго коммита, можно выполнить следующее:

	$ git update-ref refs/heads/test cac0ca

Данная ветка будет содержать только коммиты, предшествующие выбранному:

	$ git log --pretty=oneline test
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Теперь наша база данных Git схематично выглядит так, как показано на рисунке 9.4.

Insert 18333fig0904.png 
Рисунок 9-4. Объекты в каталоге .git, а также указатели на вершины веток.

Когда выполняется команда `git branch (имя ветки)`, Git, по сути, выполняет `update-ref` для добавления хеша последнего коммита текущей ветки под указанным именем в виде новой ссылки.

### HEAD ###

Вопрос в том, как же Git получает хеш последнего коммита при выполнении `git branch (имя ветки)`? Ответ содержится в файле HEAD. Данный файл является символической ссылкой на текущую ветку. Символическая ссылка отличается от обычной тем, что она содержит не сам хеш SHA-1, а указатель на другую ссылку. Если вы загляните в этот файл, то увидите что-то такое:

	$ cat .git/HEAD 
	ref: refs/heads/master

Если выполнить `git checkout test`, то содержимое файла изменится:

	$ cat .git/HEAD 
	ref: refs/heads/test

При выполнении `git commit`, Git создаёт объект-коммит, указывая его родителем тот объект, SHA-1 которого содержится в файле, на который ссылается HEAD.

Данный файл, конечно, можно редактировать вручную, но безопаснее использовать команду `symbolic-ref`. Получить значение HEAD данной командой можно так:

	$ git symbolic-ref HEAD
	refs/heads/master

Изменить значение HEAD можно так:

	$ git symbolic-ref HEAD refs/heads/test
	$ cat .git/HEAD 
	ref: refs/heads/test

Символическую ссылку на файл вне refs поставить нельзя:

	$ git symbolic-ref HEAD test
	fatal: Refusing to point HEAD outside of refs/

### Метки ###

Мы рассмотрели три основных типа объектов в Git, но есть и четвёртый. Объект-метка очень похож на объект-коммит: он содержит имя поставившего метку, дату, сообщение и указатель. Разница же в том, что метка указывает на коммит, а не на дерево. Она похожа на ветку, которая никогда не перемещается — она всегда указывает на один и тот же коммит, она просто даёт ему понятное имя.

Как было сказано в главе 2, метки бывают двух типов: аннотированные и легковесные. Легковесную метку можно сделать следующей командой:

	$ git update-ref refs/tags/v1.0 cac0cab538b970a37ea1e769cbbde608743bc96d

Вот и всё! Легковесная метка — это ветка, которая никогда не перемещается. Аннотированная метка имеет более сложную структуру. При создании аннотированной метки, Git создаёт специальный объект, на который будет указывать ссылка, а не просто указатель на коммит. Мы можем увидеть это создав аннотированную метку (`-a` задаёт аннотированные метки):

	$ git tag -a v1.1 1a410efbd13591db07496601ebc7a059dd55cfe9 -m 'test tag'

Вот значение SHA-1 созданного объекта:

	$ cat .git/refs/tags/v1.1 
	9585191f37f7b0fb9444f35a9bf50de191beadc2

Теперь выполним `cat-file` для этого хеша:

	$ git cat-file -p 9585191f37f7b0fb9444f35a9bf50de191beadc2
	object 1a410efbd13591db07496601ebc7a059dd55cfe9
	type commit
	tag v1.1
	tagger Scott Chacon <schacon@gmail.com> Sat May 23 16:48:58 2009 -0700

	test tag

Заметьте, в поле object записан SHA-1 коммита, для которого мы делали метку. Также стоит отметить, что это поле не обязательно указывает на коммит, но на любой объект в Git. Например, в исходный код Git мейнтейнер добавил свой публичный GPG-ключ в качестве блоба и поставил для него метку. Увидеть этот ключ можно, выполнив команду

	$ git cat-file blob junio-gpg-pub

в репозитории с исходным кодом Git. В репозитории ядра Linux также есть метка, указывающая не на коммит — первая метка указывает на дерево первичного импорта.

### Ссылки на удалённые ветки ###

Третий тип ссылок, который мы рассмотрим — ссылка на удалённую ветку. Если вы добавили удалённый репозиторий и отправили (push) на него изменения, Git сохранит последнее отправленное значение SHA-1 в каталоге `refs/remotes` для всех отправленных веток. Например, можно добавить удалённый репозиторий `origin` и отправить туда ветку `master`:

	$ git remote add origin git@github.com:schacon/simplegit-progit.git
	$ git push origin master
	Counting objects: 11, done.
	Compressing objects: 100% (5/5), done.
	Writing objects: 100% (7/7), 716 bytes, done.
	Total 7 (delta 2), reused 4 (delta 1)
	To git@github.com:schacon/simplegit-progit.git
	   a11bef0..ca82a6d  master -> master

Позже, вы сможете посмотреть где находилась ветка `master` с сервера `origin` во время последнего соединения с сервером заглянув в файл `refs/remotes/origin/master`:

	$ cat .git/refs/remotes/origin/master 
	ca82a6dff817ec66f44342007202690a93763949

Ссылки на удалённые ветки отличаются от обычных веток (ссылки в `refs/heads`) тем, что на них нельзя переключиться с помощью `git checkout`. Git работает с ними как с закладками, указывающими на последнее состояние соответствующих веток на ваших серверах.

## Packfiles ##

## Сжатые файлы ##

Let’s go back to the objects database for your test Git repository. At this point, you have 11 objects — 4 blobs, 3 trees, 3 commits, and 1 tag:

Вернёмся к базе объектов в нашем тестовом репозитории. Их должно быть 11: 4 блоба, 3 дерева, 3 коммита и одна метка:

	$ find .git/objects -type f
	.git/objects/01/55eb4229851634a0f03eb265b69f5a2d56f341 # tree 2
	.git/objects/1a/410efbd13591db07496601ebc7a059dd55cfe9 # commit 3
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a # test.txt v2
	.git/objects/3c/4e9cd789d88d8d89c1073707c3585e41b0e614 # tree 3
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30 # test.txt v1
	.git/objects/95/85191f37f7b0fb9444f35a9bf50de191beadc2 # tag
	.git/objects/ca/c0cab538b970a37ea1e769cbbde608743bc96d # commit 2
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4 # 'test content'
	.git/objects/d8/329fc1cc938780ffdd9f94e0d364e0ea74f579 # tree 1
	.git/objects/fa/49b077972391ad58037050f2a75f74e3671e92 # new.txt
	.git/objects/fd/f4fc3344e67ab068f836878b6c4951e3b15f3d # commit 1

Git compresses the contents of these files with zlib, and you’re not storing much, so all these files collectively take up only 925 bytes. You’ll add some larger content to the repository to demonstrate an interesting feature of Git. Add the repo.rb file from the Grit library you worked with earlier — this is about a 12K source code file:

Git сжимает содержимое данных файлов при помощи zlib и для хранения остаётся немного данных, всего 925 байт. Для того, чтобы показать интересную особенность Git, добавим файл побольше. Файл repo.rb из библиотеки Grit, с которой мы работали ранее, занимает примерно 12 килобайт:

	$ curl http://github.com/mojombo/grit/raw/master/lib/grit/repo.rb > repo.rb
	$ git add repo.rb 
	$ git commit -m 'added repo.rb'
	[master 484a592] added repo.rb
	 3 files changed, 459 insertions(+), 2 deletions(-)
	 delete mode 100644 bak/test.txt
	 create mode 100644 repo.rb
	 rewrite test.txt (100%)

If you look at the resulting tree, you can see the SHA-1 value your repo.rb file got for the blob object:

Если рассмотреть полученное дерево, можно заметить хеш файла repo.rb:

	$ git cat-file -p master^{tree}
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e      repo.rb
	100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

You can then use `git cat-file` to see how big that object is:

Для определения размера объекта можно воспользоваться командой `git cat-file`:

	$ git cat-file -s 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e
	12898

Now, modify that file a little, and see what happens:

Теперь, изменим немного данный файл и посмотрим на результат:

	$ echo '# testing' >> repo.rb 
	$ git commit -am 'modified repo a bit'
	[master ab1afef] modified repo a bit
	 1 files changed, 1 insertions(+), 0 deletions(-)

Check the tree created by that commit, and you see something interesting:

Рассмотрим итоговое дерево:

	$ git cat-file -p master^{tree}
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 05408d195263d853f09dca71d55116663690c27c      repo.rb
	100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

The blob is now a different blob, which means that although you added only a single line to the end of a 400-line file, Git stored that new content as a completely new object:

Теперь файлу repo.rb соответствует другой блоб-объект, т.е., даже одна добавленная строка в конце 400-строчного файла требует создания нового объекта:

	$ git cat-file -s 05408d195263d853f09dca71d55116663690c27c
	12908

You have two nearly identical 12K objects on your disk. Wouldn’t it be nice if Git could store one of them in full but then the second object only as the delta between it and the first?

Итак, имеем два почти одинаковых объекта по 12 килобайт. Было бы неплохо, если бы Git сохранял только один объект целиком, а в другом хранил разницу между ним и исходным.

It turns out that it can. The initial format in which Git saves objects on disk is called a loose object format. However, occasionally Git packs up several of these objects into a single binary file called a packfile in order to save space and be more efficient. Git does this if you have too many loose objects around, if you run the `git gc` command manually, or if you push to a remote server. To see what happens, you can manually ask Git to pack up the objects by calling the `git gc` command:

Так и есть. Исходный формат для сохранения объектов в Git называется свободным форматом объектов. Однако, иногда Git упаковывает несколько объектов в один файл, называемый сжатым для сохранения места на диске и повышения эффективности. Это случается, если свободных объектов становится слишком много, либо при вызове `git gc`, либо при отправке изменения на удалённый сервер. Для понимания того, что происходит, можно выполнить команду `git gc`:

	$ git gc
	Counting objects: 17, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (13/13), done.
	Writing objects: 100% (17/17), done.
	Total 17 (delta 1), reused 10 (delta 0)

If you look in your objects directory, you’ll find that most of your objects are gone, and a new pair of files has appeared:

Если посмотреть на файлы в каталоге объектов, теперь можно заметить, что большая часть объектов отсутствует, зато появились новые файлы .idx и .pack:

	$ find .git/objects -type f
	.git/objects/71/08f7ecb345ee9d0084193f147cdad4d2998293
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4
	.git/objects/info/packs
	.git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.idx
	.git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.pack

The objects that remain are the blobs that aren’t pointed to by any commit — in this case, the "what is up, doc?" example and the "test content" example blobs you created earlier. Because you never added them to any commits, they’re considered dangling and aren’t packed up in your new packfile.

Оставшиеся объекты — блобы, на которые не указывает ни один коммит (в данном случае это объекты, содержащие строки "Есть проблемы, шеф?" и "test content"). В силу того, что ни в одном коммите данные файлы не присутствуют, они считаются "висячими" и не упаковываются.

The other files are your new packfile and an index. The packfile is a single file containing the contents of all the objects that were removed from your filesystem. The index is a file that contains offsets into that packfile so you can quickly seek to a specific object. What is cool is that although the objects on disk before you ran the `gc` were collectively about 12K in size, the new packfile is only 6K. You’ve halved your disk usage by packing your objects.

Другие файлы — сжатый файл и его индекс. Сжатый файл содержит все объекты, которые были удалены, а индекс — их смещения в файле, для удобства извлечения. Упаковка данных положительно повлияла на общий размер файлов, если до этого они занимали примерно 12 килобайт, сжатый файл занимает 6. Места на диске занято теперь в два раза меньше.

How does Git do this? When Git packs objects, it looks for files that are named and sized similarly, and stores just the deltas from one version of the file to the next. You can look into the packfile and see what Git did to save space. The `git verify-pack` plumbing command allows you to see what was packed up:

Как Git это делает? При упаковке Git ищет файлы, которые похожи по имени и размеру и сохраняет разницу между версиями. Можно рассмотреть сжатый файл подробнее и понять, какие действия были выполнены для сжатия. Для этого существует служебная команда `git verify-pack`:

	$ git verify-pack -v \
	  .git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.idx
	0155eb4229851634a0f03eb265b69f5a2d56f341 tree   71 76 5400
	05408d195263d853f09dca71d55116663690c27c blob   12908 3478 874
	09f01cea547666f58d6a8d809583841a7c6f0130 tree   106 107 5086
	1a410efbd13591db07496601ebc7a059dd55cfe9 commit 225 151 322
	1f7a7a472abf3dd9643fd615f6da379c4acb3e3a blob   10 19 5381
	3c4e9cd789d88d8d89c1073707c3585e41b0e614 tree   101 105 5211
	484a59275031909e19aadb7c92262719cfcdf19a commit 226 153 169
	83baae61804e65cc73a7201a7252750c76066a30 blob   10 19 5362
	9585191f37f7b0fb9444f35a9bf50de191beadc2 tag    136 127 5476
	9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e blob   7 18 5193 1
	05408d195263d853f09dca71d55116663690c27c \
	  ab1afef80fac8e34258ff41fc1b867c702daa24b commit 232 157 12
	cac0cab538b970a37ea1e769cbbde608743bc96d commit 226 154 473
	d8329fc1cc938780ffdd9f94e0d364e0ea74f579 tree   36 46 5316
	e3f094f522629ae358806b17daf78246c27c007b blob   1486 734 4352
	f8f51d7d8a1760462eca26eebafde32087499533 tree   106 107 749
	fa49b077972391ad58037050f2a75f74e3671e92 blob   9 18 856
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d commit 177 122 627
	chain length = 1: 1 object
	pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.pack: ok

Here, the `9bc1d` blob, which if you remember was the first version of your repo.rb file, is referencing the `05408` blob, which was the second version of the file. The third column in the output is the size of the object in the pack, so you can see that `05408` takes up 12K of the file but that `9bc1d` only takes up 7 bytes. What is also interesting is that the second version of the file is the one that is stored intact, whereas the original version is stored as a delta — this is because you’re most likely to need faster access to the most recent version of the file.

Здесь блоб `9b1cd`, который, как мы помним, был первой версией файла repo.rb, ссылается на `05408`, который был второй его версией. Третья колонка в полученных данных — размер объекта, можно заметить, что `9bc1d` занимает всего 7 килобайт. Что интересно, вторая версия сохраняется "как есть", а исходная — в виде изменений, т.к. более вероятно получение последней версии.

The really nice thing about this is that it can be repacked at any time. Git will occasionally repack your database automatically, always trying to save more space. You can also manually repack at any time by running `git gc` by hand.

Так же здорово, что переупаковку можно выполнять в любое время. Иногда она выполняется автоматически, если вдруг этого недостаточно, всегда можно выполнить `git gc` вручную.

## The Refspec ##

## Спецификации ссылок ##

Throughout this book, you’ve used simple mappings from remote branches to local references; but they can be more complex.
Suppose you add a remote like this:

Во всей книге использовались простые связи между ветками в удалённых репозиториях и локальными ветками, но они могут быть и более сложными.
Предположим, мы добавили следующую удалённую ветку:

	$ git remote add origin git@github.com:schacon/simplegit-progit.git

It adds a section to your `.git/config` file, specifying the name of the remote (`origin`), the URL of the remote repository, and the refspec for fetching:

Данный вызов добавляет секцию в файл `.git/config`, определяющую имя удалённого репозитория (`origin`), адрес и спецификацию ссылки:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/*:refs/remotes/origin/*

Формат спецификации следующий: опциональный `+`, далее пара `<src>:<dst>`, где `<src>` — шаблон ссылок в удалённом репозитории, а `<dst>` — соответствующий шаблон локальных ссылок. Символ `+` сообщает Git, что обновление необходимо выполнять даже в том случае, если оно не fast-forward.

In the default case that is automatically written by a `git remote add` command, Git fetches all the references under `refs/heads/` on the server and writes them to `refs/remotes/origin/` locally. So, if there is a `master` branch on the server, you can access the log of that branch locally via

В случае настроек по умолчанию, которые задаются при вызове `git remote add`, Git выбирает все ссылки из `refs/heads/` на стороне сервера, и записывает их в каталог `refs/remotes/origin/`. Поэтому, если на сервере есть ветка `master`, журнал данной ветки можно получить, вызвав:

	$ git log origin/master
	$ git log remotes/origin/master
	$ git log refs/remotes/origin/master

They’re all equivalent, because Git expands each of them to `refs/remotes/origin/master`.

Данные команды эквивалентны, любая запись разворачивается до `refs/remotes/origin/master`.

If you want Git instead to pull down only the `master` branch each time, and not every other branch on the remote server, you can change the fetch line to

Если хочется, чтобы Git забирал при обновлении только ветку `master`, а не все возможные, можно изменить соответствующую строку в конфигурации:

	fetch = +refs/heads/master:refs/remotes/origin/master

This is just the default refspec for `git fetch` for that remote. If you want to do something one time, you can specify the refspec on the command line, too. To pull the `master` branch on the remote down to `origin/mymaster` locally, you can run

Данный refspec выбирается по умолчанию при вызове `git fetch` для данного удалённого репозитория. Если хочется выполнить единоразовое действие, можно задать refspec в командной строке. Например, чтобы забрать ветку `master` из удалённого репозитория в локальную `origin/mymaster`, можно выполнить

	$ git fetch origin master:refs/remotes/origin/mymaster

You can also specify multiple refspecs. On the command line, you can pull down several branches like so:

Конечно, можно задать несколько спецификаций. Забрать несколько веток из командной строки можно так:

	$ git fetch origin master:refs/remotes/origin/mymaster \
	   topic:refs/remotes/origin/topic
	From git@github.com:schacon/simplegit
	 ! [rejected]        master     -> origin/mymaster  (non fast forward)
	 * [new branch]      topic      -> origin/topic

In this case, the  master branch pull was rejected because it wasn’t a fast-forward reference. You can override that by specifying the `+` in front of the refspec.

В данном случае, слияние ветки master выполнить не удалось, поскольку данная ветка новее, чем исходная в локальном репозитории. Данное поведение можно отключить, добавив перед спецификацией знак `+`.

You can also specify multiple refspecs for fetching in your configuration file. If you want to always fetch the master and experiment branches, add two lines:

Также можно задавать несколько спецификаций для получения обновлений в конфигурационном файле. Если хочется каждый раз получать обновления веток master и experiment (по умолчанию), это можно задать так:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/master:refs/remotes/origin/master
	       fetch = +refs/heads/experiment:refs/remotes/origin/experiment

You can’t use partial globs in the pattern, so this would be invalid:

Задавать сложные регулярные выражения в спецификации нельзя, следующая запись неверна:

	fetch = +refs/heads/qa*:refs/remotes/origin/qa*

However, you can use namespacing to accomplish something like that. If you have a QA team that pushes a series of branches, and you want to get the master branch and any of the QA team’s branches but nothing else, you can use a config section like this:

Однако, можно использовать пространства имён для получения ожидаемого результата. Если имеется команда QA, которая имеет несколько веток, и необходимо получать основную ветку проекта и все ветки QA, можно добавить в конфигурацию следующее:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/master:refs/remotes/origin/master
	       fetch = +refs/heads/qa/*:refs/remotes/origin/qa/*

If you have a complex workflow process that has a QA team pushing branches, developers pushing branches, and integration teams pushing and collaborating on remote branches, you can namespace them easily this way.

Если рабочий процесс является сложным, и разные команды комитят в разные ветки одного и того же проекта, пространства имён могут помочь с лёгкостью это организовать.

### Выгрузка в удалённые репозитории ###

It’s nice that you can fetch namespaced references that way, but how does the QA team get their branches into a `qa/` namespace in the first place? You accomplish that by using refspecs to push.

Итак, мы можем извлекать данные по спецификациям ссылок, содержащим пространства имён, но как загружать туда правки?

If the QA team wants to push their `master` branch to `qa/master` on the remote server, they can run

Если разработчик из команды QA хочет добавить изменения из локальной ветки `master` в `qa/master` на удалённом сервере, он может выполнить команду

	$ git push origin master:refs/heads/qa/master

If they want Git to do that automatically each time they run `git push origin`, they can add a `push` value to their config file:

Если хочется, чтобы Git автоматически выполнял это действие при вызове `git push origin`, можно добавить в конфигурацию параметр push:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/*:refs/remotes/origin/*
	       push = refs/heads/master:refs/heads/qa/master

Again, this will cause a `git push origin` to push the local `master` branch to the remote `qa/master` branch by default.

Это также приведёт к тому, что при вызове `git push origin` локальная ветка `master` будет по умолчанию реплицироваться в удалённую `qa/master`.

### Deleting References ###

### Удаление ссылок ###

You can also use the refspec to delete references from the remote server by running something like this:

Спецификации ссылок также можно использовать для удаления на удалённом сервере следующим образом:

	$ git push origin :topic

Because the refspec is `<src>:<dst>`, by leaving off the `<src>` part, this basically says to make the topic branch on the remote nothing, which deletes it. 

Т.к. спецификация ссылки задаётся в виде `<src>:<dst>`, опускание `<src>` означает, что тематическая ветка на удалённом сервере пуста, что приводит к её удалению.

## Transfer Protocols ##

## Протоколы передачи ##

Git can transfer data between two repositories in two major ways: over HTTP and via the so-called smart protocols used in the `file://`, `ssh://`, and `git://` transports. This section will quickly cover how these two main protocols operate.

Git может передавать данные между репозиториями одним из двух основных способов: через HTTP или через "умные" протоколы с транспортами `file://`, `ssh://`, `git://`. В данном разделе будут рассмотрены данные способы передачи.

### The Dumb Protocol ###

### Простой протокол ###

Git transport over HTTP is often referred to as the dumb protocol because it requires no Git-specific code on the server side during the transport process. The fetch process is a series of GET requests, where the client can assume the layout of the Git repository on the server. Let’s follow the `http-fetch` process for the simplegit library:

Транспорт Git через HTTP называют также простым протоколом потому что со стороны сервера не требуется никакого кода Git. Процесс клонирования — последовательность запросов GET, клиент обращается к стандартной структуре каталогов Git.

	$ git clone http://github.com/schacon/simplegit-progit.git

The first thing this command does is pull down the `info/refs` file. This file is written by the `update-server-info` command, which is why you need to enable that as a `post-receive` hook in order for the HTTP transport to work properly:

Первое действие, выполняемое данной командой — загрузка файла `info/refs`. Данный файл записывается командой `update-server-info`, поэтому для использования HTTP транспорта необходимо включить `post-receive` хук:

	=> GET info/refs
	ca82a6dff817ec66f44342007202690a93763949     refs/heads/master

Now you have a list of the remote references and SHAs. Next, you look for what the HEAD reference is so you know what to check out when you’re finished:

Теперь у нас имеется список удалённых веток и их хеши. Далее, Git смотрит куда ссылается HEAD, после этого можно получать данные.

	=> GET HEAD
	ref: refs/heads/master

You need to check out the `master` branch when you’ve completed the process. 
В итоге необходимо получить ветку `master.
At this point, you’re ready to start the walking process. Because your starting point is the `ca82a6` commit object you saw in the `info/refs` file, you start by fetching that:
На данном этапе можно начать обход дерева. Начальной точкой является коммит-объект `ca82a6`, полученный из файла `info/refs`, его можно загрузить так:

	=> GET objects/ca/82a6dff817ec66f44342007202690a93763949
	(179 bytes of binary data)

You get an object back — that object is in loose format on the server, and you fetched it over a static HTTP GET request. You can zlib-uncompress it, strip off the header, and look at the commit content:

Объект получен, он был в свободном формате, необходимо разархивировать его и удалить заголовок:

	$ git cat-file -p ca82a6dff817ec66f44342007202690a93763949
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

Next, you have two more objects to retrieve — `cfda3b`, which is the tree of content that the commit we just retrieved points to; and `085bb3`, which is the parent commit:

Далее, необходимо загрузить ещё два объекта: `cfda3b`, объект-дерево на который ссылается найденный коммит и `085bb3`, родительский:

	=> GET objects/08/5bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	(179 bytes of data)

That gives you your next commit object. Grab the tree object:

Таким образом, мы получаем следующий коммит-объект.

	=> GET objects/cf/da3bf379e4f8dba8717dee55aab78aef7f4daf
	(404 - Not Found)

Oops — it looks like that tree object isn’t in loose format on the server, so you get a 404 response back. There are a couple of reasons for this — the object could be in an alternate repository, or it could be in a packfile in this repository. Git checks for any listed alternates first:

Кажется, объекта-дерева в свободном формате нет на сервере, получаем ответ 404. У этого могут быть разные причины: объект в другом репозитории, или в упакованном файле текущего репозитория. Сперва Git обращается к списку альтернатив:

	=> GET objects/info/http-alternates
	(empty file)

If this comes back with a list of alternate URLs, Git checks for loose files and packfiles there — this is a nice mechanism for projects that are forks of one another to share objects on disk. However, because no alternates are listed in this case, your object must be in a packfile. To see what packfiles are available on this server, you need to get the `objects/info/packs` file, which contains a listing of them (also generated by `update-server-info`):

Если в данном списке есть адреса, Git обращается по ним в поиске свободных файлов и упакованных файлов, это такой способ для компактификации места на диске для форков. Так как в данном случае альтернатив нет, объект должен быть упакован. Для того, чтобы узнать, какие упакованные файлы есть на сервере, необходимо загрузить файл `objects/info/packs` (который также генерируется `update-server-info`):

	=> GET objects/info/packs
	P pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack

There is only one packfile on the server, so your object is obviously in there, but you’ll check the index file to make sure. This is also useful if you have multiple packfiles on the server, so you can see which packfile contains the object you need:

На сервере имеется только один упакованный файл, поэтому объект точно там, но необходимо проверить индексный файл для ясности:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.idx
	(4k of binary data)

Now that you have the packfile index, you can see if your object is in it — because the index lists the SHAs of the objects contained in the packfile and the offsets to those objects. Your object is there, so go ahead and get the whole packfile:

Теперь, когда мы получили индекс упакованных файлов, можно определить, в каком из них находится объект. Индексный файл содержит хеши объектов в упакованном файле и их смещения. Необходимый объект там присутствует, получим файл:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack
	(13k of binary data)

You have your tree object, so you continue walking your commits. They’re all also within the packfile you just downloaded, so you don’t have to do any more requests to your server. Git checks out a working copy of the `master` branch that was pointed to by the HEAD reference you downloaded at the beginning.

Итак, мы получаем объект-дерево, можно продолжить обход дерева. Все они внутри упакованного файла, так что более обращаться к серверу не надо. Git извлекает рабочую копию ветки `master`, на которую ссылается HEAD.

The entire output of this process looks like this:

Вывод данного процесса выглядит так:

	$ git clone http://github.com/schacon/simplegit-progit.git
	Initialized empty Git repository in /private/tmp/simplegit-progit/.git/
	got ca82a6dff817ec66f44342007202690a93763949
	walk ca82a6dff817ec66f44342007202690a93763949
	got 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Getting alternates list for http://github.com/schacon/simplegit-progit.git
	Getting pack list for http://github.com/schacon/simplegit-progit.git
	Getting index for pack 816a9b2334da9953e530f27bcac22082a9f5b835
	Getting pack 816a9b2334da9953e530f27bcac22082a9f5b835
	 which contains cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	walk 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	walk a11bef06a3f659402fe7563abf99ad00de2209e6

### The Smart Protocol ###

### Умный протокол ###

The HTTP method is simple but a bit inefficient. Using smart protocols is a more common method of transferring data. These protocols have a process on the remote end that is intelligent about Git — it can read local data and figure out what the client has or needs and generate custom data for it. There are two sets of processes for transferring data: a pair for uploading data and a pair for downloading data.

Метод HTTP прост, но неэффективен, поэтому чаще используются "умные" протоколы. Эти протоколы обслуживаются процессом на стороне сервера, который учитывает логику работы Git и генерирует специальные наборы данных. Существует два набора процессов передачи данных: процессы загрузки и выгрузки.

#### Uploading Data ####

#### Выгрузка данных ####

To upload data to a remote process, Git uses the `send-pack` and `receive-pack` processes. The `send-pack` process runs on the client and connects to a `receive-pack` process on the remote side.

Для выгрузки данных на удалённый сервер используются процессы `send-pack` и `receive-pack`. Процесс `send-pack` запускается на стороне клиента и подключается к `receive-pack` на стороне сервера.

For example, say you run `git push origin master` in your project, and `origin` is defined as a URL that uses the SSH protocol. Git fires up the `send-pack` process, which initiates a connection over SSH to your server. It tries to run a command on the remote server via an SSH call that looks something like this:

Например, выполяется команда `git push origin master` и `origin` определяется как URL с префиксом SSH. Git вызывает процесс `send-pack`, который создаёт подключение по протоколу SSH.

	$ ssh -x git@github.com "git-receive-pack 'schacon/simplegit-progit.git'"
	005bca82a6dff817ec66f4437202690a93763949 refs/heads/master report-status delete-refs
	003e085bb3bcb608e1e84b2432f8ecbe6306e7e7 refs/heads/topic
	0000

The `git-receive-pack` command immediately responds with one line for each reference it currently has — in this case, just the `master` branch and its SHA. The first line also has a list of the server’s capabilities (here, `report-status` and `delete-refs`).

Команда `git-receive-pack` отвечает строками, каждая из которых соответствует ссылке в наличии, в данном случае есть только ветка `master`. Первая строка также содержит возможности сервера (here, `report-status`, `delete-references`).

Each line starts with a 4-byte hex value specifying how long the rest of the line is. Your first line starts with 005b, which is 91 in hex, meaning that 91 bytes remain on that line. The next line starts with 003e, which is 62, so you read the remaining 62 bytes. The next line is 0000, meaning the server is done with its references listing.

Каждая строка начинается с 4-байтового значения, содержащего длину следующей строки. Первая строка начинается с 005b, 91 в 16-ричном виде, значит осталось прочитать 91 байт. Следующая строка начинается с 003e, что означает 62. Далее следует 0000, листинг закончился.

Now that it knows the server’s state, your `send-pack` process determines what commits it has that the server doesn’t. For each reference that this push will update, the `send-pack` process tells the `receive-pack` process that information. For instance, if you’re updating the `master` branch and adding an `experiment` branch, the `send-pack` response may look something like this:

Теперь процесс `send-pack` определяет коммиты, которые есть локально, но которых нет на сервере. Для каждой ссылки, которая будет обновленая, процесс `send-pack` передаёт процессу `receive-pack` данные. Например, если обновляется ветка `master`, а новые коммиты берутся из ветки `experiment`, `ответ `send-pack` выглядит следующим образом:

	0085ca82a6dff817ec66f44342007202690a93763949  15027957951b64cf874c3557a0f3547bd83b3ff6 refs/heads/master report-status
	00670000000000000000000000000000000000000000 cdfdb42577e2506715f8cfeacdbabc092bf63e8d refs/heads/experiment
	0000

The SHA-1 value of all '0's means that nothing was there before — because you’re adding the experiment reference. If you were deleting a reference, you would see the opposite: all '0's on the right side.

Значение с множеством нулей означает, что ранее ветка была пустой, т.е., её не существовало. Если производится удаление ветки, нули будут справа.

Git sends a line for each reference you’re updating with the old SHA, the new SHA, and the reference that is being updated. The first line also has the client’s capabilities. Next, the client uploads a packfile of all the objects the server doesn’t have yet. Finally, the server responds with a success (or failure) indication:

Git отправляет строку для каждой ссылки, для которой производится обновление. В строке содержится старый хеш, новый хеш и имя сссылки. Первая строка также содержит возможности клиента. Далее, клиент загружает упакованный файл со всеми объектами, которые сервер ещё не содержит. В конце, сервер отвечает статусным сообщением:

	000Aunpack ok

#### Загрузка данных ####

When you download data, the `fetch-pack` and `upload-pack` processes are involved. The client initiates a `fetch-pack` process that connects to an `upload-pack` process on the remote side to negotiate what data will be transferred down.

Если выполняется загрузка данных, используются процессы `fetch-pack` и `upload-pack`. Клиент запускает процесс `fetch-pack`, подключающийся к удалённому процессу `upload-pack` для определения, какие данные будут переданы.

There are different ways to initiate the `upload-pack` process on the remote repository. You can run via SSH in the same manner as the `receive-pack` process. You can also initiate the process via the Git daemon, which listens on a server on port 9418 by default. The `fetch-pack` process sends data that looks like this to the daemon after connecting:

Существует два способа запуска `upload-pack` на удалённом репозитории. Можно выполнить его через SSH так же, как и `receive-pack`. Ещё можно вызвать процесс через демон Gitm работающий на порту 9418 по умолчанию. Процесс `fetch-pack` отправляет при подключении данные примерно следующего вида:

	003fgit-upload-pack schacon/simplegit-progit.git\0host=myserver.com\0

It starts with the 4 bytes specifying how much data is following, then the command to run followed by a null byte, and then the server’s hostname followed by a final null byte. The Git daemon checks that the command can be run and that the repository exists and has public permissions. If everything is cool, it fires up the `upload-pack` process and hands off the request to it.

Начало размером 4 байта задаёт размер следующей строки, далее следует команда, завершаемая нулевым байтом, потом имя сервера и нулевой байт.  Демон Git проверяет возможность выполнения команды, существование репозитория и права доступа. Если всё хорошо, запускается процесс `upload-pack`, и запрос передаётся ему.

If you’re doing the fetch over SSH, `fetch-pack` instead runs something like this:

Если выборка производится через SSH, `fetch-pack` выполняет следующее:

	$ ssh -x git@github.com "git-upload-pack 'schacon/simplegit-progit.git'"

In either case, after `fetch-pack` connects, `upload-pack` sends back something like this:

В обоих случаях, после подключения `fetch-pack`, `upload-pack` передаёт следующее:

	0088ca82a6dff817ec66f44342007202690a93763949 HEAD\0multi_ack thin-pack \
	  side-band side-band-64k ofs-delta shallow no-progress include-tag
	003fca82a6dff817ec66f44342007202690a93763949 refs/heads/master
	003e085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 refs/heads/topic
	0000

This is very similar to what `receive-pack` responds with, but the capabilities are different. In addition, it sends back the HEAD reference so the client knows what to check out if this is a clone.

Это очень похоже на ответ `receive-pack`, но возможности другие. Также, он отправляет ссылку на HEAD, чтобы клиент понимал, какую ветку выбирать, если выполняется клонирование.

At this point, the `fetch-pack` process looks at what objects it has and responds with the objects that it needs by sending "want" and then the SHA it wants. It sends all the objects it already has with "have" and then the SHA. At the end of this list, it writes "done" to initiate the `upload-pack` process to begin sending the packfile of the data it needs:

На данном этапе процесс `fetch-pack` смотрит на объекты, имеющиеся в наличии и отвечает словом "want" с хешем для необходимых объектов. Далее, процесс отправляет хеши имеющихся объектов со словом "have". В конце списка идёт запись "done", которая инициирует `upload-pack`:

	0054want ca82a6dff817ec66f44342007202690a93763949 ofs-delta
	0032have 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	0000
	0009done

That is a very basic case of the transfer protocols. In more complex cases, the client supports `multi_ack` or `side-band` capabilities; but this example shows you the basic back and forth used by the smart protocol processes.

Это простой случай передачи данных. В более сложных данных, клиент поддерживает функции `multi_ack` или `side-band`.

## Обслуживание и восстановление данных ##

Occasionally, you may have to do some cleanup — make a repository more compact, clean up an imported repository, or recover lost work. This section will cover some of these scenarios.

Иногда, требуется выполнить очистку — сделать репозиторий более компактным, почистить импортированный репозиторий или восстановить потерянную работу. В данном разделе содержатся некоторые сценарии.

### Обслуживание ###

Occasionally, Git automatically runs a command called "auto gc". Most of the time, this command does nothing. However, if there are too many loose objects (objects not in a packfile) or too many packfiles, Git launches a full-fledged `git gc` command. The `gc` stands for garbage collect, and the command does a number of things: it gathers up all the loose objects and places them in packfiles, it consolidates packfiles into one big packfile, and it removes objects that aren’t reachable from any commit and are a few months old.

Иногда Git автоматически выполняет команду "auto gc". Чаще всего, эта команда ничего не делает. Однако, если неупакованных объектов  довольно много, или упакованных файлов довольно много, запускается команда `git gc`. Здесь `gc` означает "сборка мусора", эта команда выполняет несколько действий: сборка всех несжатых объектов и размещение их в упакованные файлы, консолидация упакованных файлов, удаление недостижимых объектов определённого возраста.

You can run auto gc manually as follows:

Также можно выполнить сборку мусора вручную:

	$ git gc --auto

Again, this generally does nothing. You must have around 7,000 loose objects or more than 50 packfiles for Git to fire up a real gc command. You can modify these limits with the `gc.auto` and `gc.autopacklimit` config settings, respectively.

Опять же, как правило, эта команда ничего не делает. Необходимо иметь 7000 несжатых объектов или более 50 упакованных файлов. Данные пределы можно изменить в параметрах `gc.auto` и `gc.autopacklimit` конфигурационного файла.

The other thing `gc` will do is pack up your references into a single file. Suppose your repository contains the following branches and tags:

Другое действие, выполняемое `gc` — упаковка ссылок в единый файл. Предположим, репозиторий содержит следующие ветки и теги:

	$ find .git/refs -type f
	.git/refs/heads/experiment
	.git/refs/heads/master
	.git/refs/tags/v1.0
	.git/refs/tags/v1.1

If you run `git gc`, you’ll no longer have these files in the `refs` directory. Git will move them for the sake of efficiency into a file named `.git/packed-refs` that looks like this:

Если выполнить `git gc`, данные файлы в каталоге `refs` перестанут существовать. Git перенесёт их в файл `.git/packed-refs` в угоду эффективности. Файл будет иметь следующий вид:

	$ cat .git/packed-refs 
	# pack-refs with: peeled 
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/heads/experiment
	ab1afef80fac8e34258ff41fc1b867c702daa24b refs/heads/master
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/tags/v1.0
	9585191f37f7b0fb9444f35a9bf50de191beadc2 refs/tags/v1.1
	^1a410efbd13591db07496601ebc7a059dd55cfe9

If you update a reference, Git doesn’t edit this file but instead writes a new file to `refs/heads`. To get the appropriate SHA for a given reference, Git checks for that reference in the `refs` directory and then checks the `packed-refs` file as a fallback. However, if you can’t find a reference in the `refs` directory, it’s probably in your `packed-refs` file.

Если выполнить обновление ссылки, Git не будет обновлять этот файл, а добавит новый в `refs/heads`. Для получения хеша для данной ссылки, Git проверит наличие ссылки в каталоге `refs`, а к файлу `packed-refs` обратится только в случае ошибки. Однако, если в каталоге `refs` файла нет, скорее всего, он в `packed-refs`.

Notice the last line of the file, which begins with a `^`. This means the tag directly above is an annotated tag and that line is the commit that the annotated tag points to.

Заметьте, последняя строка файла начинается на `^`. Это означает, что тег непосредственно над ним аннотирован и данная строка на него указывает.

### Восстановление данных ###

At some point in your Git journey, you may accidentally lose a commit. Generally, this happens because you force-delete a branch that had work on it, and it turns out you wanted the branch after all; or you hard-reset a branch, thus abandoning commits that you wanted something from. Assuming this happens, how can you get your commits back?

В каком-то случае коммит в Git может оказаться потерянным. Как правило, это случается при удалении ветки, изменения из которой не были импортированы в другую, либо после отмены локальных коммитов. Как же в таком случае заполучить их обратно?

Here’s an example that hard-resets the master branch in your test repository to an older commit and then recovers the lost commits. First, let’s review where your repository is at this point:

В данном примере после отмены локальных коммитов основная ветка будет восстановлена, а коммиты возвращены. Для начала, рассмотрим репозиторий на данном этапе:

	$ git log --pretty=oneline
	ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
	484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Now, move the `master` branch back to the middle commit:

Теперь, перенесём ветку `master` на несколько коммитов назад:

	$ git reset --hard 1a410efbd13591db07496601ebc7a059dd55cfe9
	HEAD is now at 1a410ef third commit
	$ git log --pretty=oneline
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

You’ve effectively lost the top two commits — you have no branch from which those commits are reachable. You need to find the latest commit SHA and then add a branch that points to it. The trick is finding that latest commit SHA — it’s not like you’ve memorized it, right?

Итак, теперь два коммита стали недоступны, потому что их нет ни в одной ветке. Необходимо найти хеш последнего коммита и добавить ветку, указывающую на него. Как же его найти, если не удалось его запомнить?

Often, the quickest way is to use a tool called `git reflog`. As you’re working, Git silently records what your HEAD is every time you change it. Each time you commit or change branches, the reflog is updated. The reflog is also updated by the `git update-ref` command, which is another reason to use it instead of just writing the SHA value to your ref files, as we covered in the "Git References" section of this chapter earlier.  You can see where you’ve been at any time by running `git reflog`:

Самый быстрый способ — использовать инструмент под названием `git reflog`. По ходу работы, Git записывает изменения ветки HEAD. Каждый раз при изменении веток или коммите, добавляется запись в reflog. Также обновление производится при вызове `git update-ref`, это, в частности, является причиной необходимости использования этой команды вместо записи значения хеша в ref-файл, как было рассмотрено в разделе про ссылки данной главы. Итак, изменения в хронологическом порядке можно увидеть, вызвав `git reflog`:

	$ git reflog
	1a410ef HEAD@{0}: 1a410efbd13591db07496601ebc7a059dd55cfe9: updating HEAD
	ab1afef HEAD@{1}: ab1afef80fac8e34258ff41fc1b867c702daa24b: updating HEAD

Here we can see the two commits that we have had checked out, however there is not much information here.  To see the same information in a much more useful way, we can run `git log -g`, which will give you a normal log output for your reflog.

Здесь мы видимо два коммита, которые были получены, однако информации не так много. Более интересный вывод можно получить, используя `git log -g`, что даст стандартный вывод лога для записей из reflog:

	$ git log -g
	commit 1a410efbd13591db07496601ebc7a059dd55cfe9
	Reflog: HEAD@{0} (Scott Chacon <schacon@gmail.com>)
	Reflog message: updating HEAD
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:22:37 2009 -0700

	    third commit

	commit ab1afef80fac8e34258ff41fc1b867c702daa24b
	Reflog: HEAD@{1} (Scott Chacon <schacon@gmail.com>)
	Reflog message: updating HEAD
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri May 22 18:15:24 2009 -0700

	     modified repo a bit

It looks like the bottom commit is the one you lost, so you can recover it by creating a new branch at that commit. For example, you can start a branch named `recover-branch` at that commit (ab1afef):

Похоже, что потерян самый нижний коммит, он может быть восстановлен созданием ветки, указывающей на него. Например, можно создать ветку `recover-branch`, указывающую на данный коммит (ab1afef):

	$ git branch recover-branch ab1afef
	$ git log --pretty=oneline recover-branch
	ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
	484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Cool — now you have a branch named `recover-branch` that is where your `master` branch used to be, making the first two commits reachable again. 
Next, suppose your loss was for some reason not in the reflog — you can simulate that by removing `recover-branch` and deleting the reflog. Now the first two commits aren’t reachable by anything:

Здорово, теперь у нас есть ветка `recover-branch`, указывающая туда, куда ранее указывала `master`, и потерянные коммиты вновь доступны. Теперь, положим, потерянная ветка по какой-то причине не попала в reflog, для этого удалим восстановленную ветку и весь reflog. Теперь два этих коммита совсем недоступны:

	$ git branch -D recover-branch
	$ rm -Rf .git/logs/

Because the reflog data is kept in the `.git/logs/` directory, you effectively have no reflog. How can you recover that commit at this point? One way is to use the `git fsck` utility, which checks your database for integrity. If you run it with the `--full` option, it shows you all objects that aren’t pointed to by another object:

Теперь данные из `.git/logs/` удалены, а значит и reflog больше нет. Как восстановить коммиты теперь? Один способ — использовать утилиту `git fsck`, проверяющую базу на целостность. Если выполнить её с ключом `--full`, будут показаны все недостижимые объекты:

	$ git fsck --full
	dangling blob d670460b4b4aece5915caf5c68d12f560a9fe3e4
	dangling commit ab1afef80fac8e34258ff41fc1b867c702daa24b
	dangling tree aea790b9a58f6cf6f2804eeac9f0abbe9631e4c9
	dangling blob 7108f7ecb345ee9d0084193f147cdad4d2998293

In this case, you can see your missing commit after the dangling commit. You can recover it the same way, by adding a branch that points to that SHA.

В данном случае потерянный коммит находится после "висячего" коммита. Его можно восстановить аналогичным образом, добавляя ветку, указывающую на данный хеш.

### Удаление объектов ###

There are a lot of great things about Git, but one feature that can cause issues is the fact that a `git clone` downloads the entire history of the project, including every version of every file. This is fine if the whole thing is source code, because Git is highly optimized to compress that data efficiently. However, if someone at any point in the history of your project added a single huge file, every clone for all time will be forced to download that large file, even if it was removed from the project in the very next commit. Because it’s reachable from the history, it will always be there.

У Git есть много замечательных особенностей, одна из них, способная вызывать проблемы — команда `git clone`, загружающая проект вместе со всей историей и всем версиями всех файлов. Это здорово, если в репозитории хранится только исходный код, Git оптимизирован именно под него. Однако, если когда-то в проект был добавлен большой файл, этот файл будет скачиваться всегда, даже если в следующем же коммите он был удалён. Просто потому, что он доступен в истории.

This can be a huge problem when you’re converting Subversion or Perforce repositories into Git. Because you don’t download the whole history in those systems, this type of addition carries few consequences. If you did an import from another system or otherwise find that your repository is much larger than it should be, here is how you can find and remove large objects.

С такой проблемой можно столкнуться, например, при конвертации репозиториев Subversion или Perforce в Git. В данных системах контроля версий вся история не загружается, что приводит к некоторым последствиям. Если при импорте с другой машины или каким-либо другим образом стало ясно, что репозиторий сильно больше, чем ожидается, можно воспользоваться способом поиска и удаления ненужных объектов.

Be warned: this technique is destructive to your commit history. It rewrites every commit object downstream from the earliest tree you have to modify to remove a large file reference. If you do this immediately after an import, before anyone has started to base work on the commit, you’re fine — otherwise, you have to notify all contributors that they must rebase their work onto your new commits.

Будьте внимательны, данный способ разрушителен по отношению к истории коммитов. Каждый коммит будет переписан начиная с того, в котором был добавлен данный файл. Если это выполнить непосредственно после импорта, когда никто ещё не работал с репозиторием, всё хорошо, иначе придётся сообщать всем участникам о необходимости перебазирования их правок в новое дерево.

To demonstrate, you’ll add a large file into your test repository, remove it in the next commit, find it, and remove it permanently from the repository. First, add a large object to your history:

Для примера, добавим большой файл в дерево, удалим его в следующем коммите, найдём и удалим его полностью. Сперва добавим файл:

	$ curl http://kernel.org/pub/software/scm/git/git-1.6.3.1.tar.bz2 > git.tbz2
	$ git add git.tbz2
	$ git commit -am 'added git tarball'
	[master 6df7640] added git tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 create mode 100644 git.tbz2

Oops — you didn’t want to add a huge tarball to your project. Better get rid of it:

Упс, кажется, этот файл нам не нужен. Удалим его:

	$ git rm git.tbz2 
	rm 'git.tbz2'
	$ git commit -m 'oops - removed large tarball'
	[master da3f30d] oops - removed large tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 delete mode 100644 git.tbz2

Now, `gc` your database and see how much space you’re using:

Теперь, "соберём мусор" в базе, и узнаем её размер:

	$ git gc
	Counting objects: 21, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (16/16), done.
	Writing objects: 100% (21/21), done.
	Total 21 (delta 3), reused 15 (delta 1)

You can run the `count-objects` command to quickly see how much space you’re using:

Для удобства, можно воспользоваться командой `count-objects`:

	$ git count-objects -v
	count: 4
	size: 16
	in-pack: 21
	packs: 1
	size-pack: 2016
	prune-packable: 0
	garbage: 0

The `size-pack` entry is the size of your packfiles in kilobytes, so you’re using 2MB. Before the last commit, you were using closer to 2K — clearly, removing the file from the previous commit didn’t remove it from your history. Every time anyone clones this repository, they will have to clone all 2MB just to get this tiny project, because you accidentally added a big file. Let’s get rid of it.

Запись `size-pack` — размер упакованных файлов в килобайтах, то есть, занято всего 2MB. Перед последним коммитом, было около 2К, то есть, удаление файла не удалило его из истории. При каждом клонировании придётся загружать эти 2MB заново, просто для того, чтобы начать работу над проектом. Попробуем избавиться от него.

First you have to find it. In this case, you already know what file it is. But suppose you didn’t; how would you identify what file or files were taking up so much space? If you run `git gc`, all the objects are in a packfile; you can identify the big objects by running another plumbing command called `git verify-pack` and sorting on the third field in the output, which is file size. You can also pipe it through the `tail` command because you’re only interested in the last few largest files:

Сперва найдём его. В данном случае, мы знаем, что это за файл. Но если бы не знали, можно было бы определить, какие файлы занимают место? При вызове `git gc` все объекты упаковываются в файл, поэтому определить самые крупные файлы можно командой `git verify-pack`, отсортировав её вывод по третьей колонке, в которой записан размер файла. Далее можно получить последние 3 значения, передав вывод команде `tail`:

	$ git verify-pack -v .git/objects/pack/pack-3f8c0...bb.idx | sort -k 3 -n | tail -3
	e3f094f522629ae358806b17daf78246c27c007b blob   1486 734 4667
	05408d195263d853f09dca71d55116663690c27c blob   12908 3478 1189
	7a9eb2fba2b1811321254ac360970fc169ba2330 blob   2056716 2056872 5401

The big object is at the bottom: 2MB. To find out what file it is, you’ll use the `rev-list` command, which you used briefly in Chapter 7. If you pass `--objects` to `rev-list`, it lists all the commit SHAs and also the blob SHAs with the file paths associated with them. You can use this to find your blob’s name:

Большой объект внизу, его размер — примерно 2MB. Для того, чтобы узнать, что это за файл, воспользуемся командой `rev-list`, которая описана в главе 7. Если передать ей ключ `--objects`, полученный список будет содержать хеши объектов и соответствующие им имена файлов. Воспользуемся этим для определения имени выбранного объекта:

	$ git rev-list --objects --all | grep 7a9eb2fb
	7a9eb2fba2b1811321254ac360970fc169ba2330 git.tbz2

Now, you need to remove this file from all trees in your past. You can easily see what commits modified this file:

Теперь необходимо удалить данный файл из всех деревьев в прошлом по истории. Лего получить все коммиты, которые меняли данный файл:

	$ git log --pretty=oneline -- git.tbz2
	da3f30d019005479c99eb4c3406225613985a1db oops - removed large tarball
	6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 added git tarball

You must rewrite all the commits downstream from `6df76` to fully remove this file from your Git history. To do so, you use `filter-branch`, which you used in Chapter 6:

Необходимо переписать все коммиты, начинная с `6df76` для полного удаления данного файла. Для этого воспользуемся командой `filter-branch`, которая приводилась в главе 6:

	$ git filter-branch --index-filter \
	   'git rm --cached --ignore-unmatch git.tbz2' -- 6df7640^..
	Rewrite 6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 (1/2)rm 'git.tbz2'
	Rewrite da3f30d019005479c99eb4c3406225613985a1db (2/2)
	Ref 'refs/heads/master' was rewritten

The `--index-filter` option is similar to the `--tree-filter` option used in Chapter 6, except that instead of passing a command that modifies files checked out on disk, you’re modifying your staging area or index each time. Rather than remove a specific file with something like `rm file`, you have to remove it with `git rm --cached` — you must remove it from the index, not from disk. The reason to do it this way is speed — because Git doesn’t have to check out each revision to disk before running your filter, the process can be much, much faster. You can accomplish the same task with `--tree-filter` if you want. The `--ignore-unmatch` option to `git rm` tells it not to error out if the pattern you’re trying to remove isn’t there. Finally, you ask `filter-branch` to rewrite your history only from the `6df7640` commit up, because you know that is where this problem started. Otherwise, it will start from the beginning and will unnecessarily take longer.

Опция `--index-filter` похожа на `--tree-filter` из главы 6, за исключением того, что вместо передачи команды, модифицирующей файлы на диске, изменяются файлы в индексе или подготовительной области. Вместо удаления файла чем-то вроде `rm file`, стоит удалить его командой `rm --cached` только из индекса, сохранив на диске. Причина, по которой данные действия выполняются — скорость, нет необходимости извлекать каждую ревизию на диск перед фильтрацией. Можно использовать и `tree-filter` для аналогичного действия. Опция `--ignore-unmatch` команды `git rm` отключает вывод сообщения об ошибке в случае отсутствия файлов, соответствующих маске. И последнее, команда `filter-branch` переписывает историю начиная с коммита `6df7640` потому, что известно, на каком коммите выявилась проблема. По умолчанию перезапись начинается с самого первого коммита, что потребует гораздо больше времени.

Your history no longer contains a reference to that file. However, your reflog and a new set of refs that Git added when you did the `filter-branch` under `.git/refs/original` still do, so you have to remove them and then repack the database. You need to get rid of anything that has a pointer to those old commits before you repack:

Теперь, история не содержит ссылки на данный файл. Однако, в reflog и новом наборе ссылок, добавленном Git после выполнения `filter-branch` по пути `.git/refs/original`, ссылки на него всё ещё присутствуют, поэтому необходимо их удалить, а потом переупаковать базу. Необходимо избавиться от всех возможных ссылок на старые коммиты перед переупаковкой:

	$ rm -Rf .git/refs/original
	$ rm -Rf .git/logs/
	$ git gc
	Counting objects: 19, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (19/19), done.
	Total 19 (delta 3), reused 16 (delta 1)

Let’s see how much space you saved.

Посмотрим, сколько места удалось сохранить:

	$ git count-objects -v
	count: 8
	size: 2040
	in-pack: 19
	packs: 1
	size-pack: 7
	prune-packable: 0
	garbage: 0

The packed repository size is down to 7K, which is much better than 2MB. You can see from the size value that the big object is still in your loose objects, so it’s not gone; but it won’t be transferred on a push or subsequent clone, which is what is important. If you really wanted to, you could remove the object completely by running `git prune --expire`.

Упакованный репозиторий весит 7К, что намного лучше, чем 2M. Можно заметить, что объект всё ещё хранится в несжатом виде, но при любой передаче наружу и последующем клонировании он будет опущен, что важно. Если очень хочется, можно удалить его локально, выполнив `git prune --expire`.

## Итоги ##

You should have a pretty good understanding of what Git does in the background and, to some degree, how it’s implemented. This chapter has covered a number of plumbing commands — commands that are lower level and simpler than the porcelain commands you’ve learned about in the rest of the book. Understanding how Git works at a lower level should make it easier to understand why it’s doing what it’s doing and also to write your own tools and helping scripts to make your specific workflow work for you.

Теперь вы довольно хорошо понимаете, что Git делает в фоне и, в некоторой степени, как он работает. В данной главе рассмотрены также служебные команды, находящиеся на уровень ниже остальных с точки зрения реализации. Понимание принципов работы Git на низком уровне упрощает понимание работы Git в целом и дает возможность написания собственных команд и сценариев для организации специфического процесса работы с Git.

Git as a content-addressable filesystem is a very powerful tool that you can easily use as more than just a VCS. I hope you can use your newfound knowledge of Git internals to implement your own cool application of this technology and feel more comfortable using Git in more advanced ways.

Git — контентно-адресуемая файловая система, очень мощный инструмент, который можно использовать не только как систему контроля версий. Надеюсь, полученное знание особенностей реализации Git поможет вам в реализации интересных приложений данной технологии и продвинутом её использовании.
