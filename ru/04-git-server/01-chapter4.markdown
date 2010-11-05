# Git на сервере #

К этому моменту вы уже должны уметь делать большую часть ежедневных задач для которых вы будете использовать Git. Однако, для совместной работы в Git, вам необходим удаленный репозиторий. Несмотря на то что технически вы можете отправлять и забирать изменения непосредственно из личных репозиториев, это может крайне легко повредить то, над чем работают другие, если вы не достаточно аккуратны. К тому же, вам бы наверняка хотелось чтобы остальные имели доступ к репозиторию даже если ваш компьютер выключен, поэтому наличие более надежного репозитория обычно весьма полезно. Поэтому предпочтительный метод взаимодействие с кем-либо ― это создание промежуточного репозитория к которому вы оба будете иметь доступ и отправка и получение изменений через него. Мы будем называть этот репозиторий "сервер Git", но обычно размещение репозитория Git требует очень небольшого количества ресурсов, поэтому вряд ли вам будет нужен целый сервер для этого.

At this point, you should be able to do most of the day-to-day tasks for which you’ll be using Git. However, in order to do any collaboration in Git, you’ll need to have a remote Git repository. Although you can technically push changes to and pull changes from individuals’ repositories, doing so is discouraged because you can fairly easily confuse what they’re working on if you’re not careful. Furthermore, you want your collaborators to be able to access the repository even if your computer is offline — having a more reliable common repository is often useful. Therefore, the preferred method for collaborating with someone is to set up an intermediate repository that you both have access to, and push to and pull from that. We’ll refer to this repository as a "Git server"; but you’ll notice that it generally takes a tiny amount of resources to host a Git repository, so you’ll rarely need to use an entire server for it.

Запустить Git-сервер просто. Для начала вам следует выбрать протокол, который вы будете использовать для связи с сервером. Первая часть этой главы описывает доступные протоколы и их достоинства и недостатки. Следующие части освещают базовые конфигурации с использованием этих протоколов, а также настройку вашего сервера для работы с ними. Наконец, мы рассмотрим несколько вариантов готового хостинга, если вы не против разместить ваш код на чьем-то сервере и вы не хотите мучиться с настройками и поддержкой вашего собственного сервера.

Running a Git server is simple. First, you choose which protocols you want your server to communicate with. The first section of this chapter will cover the available protocols and the pros and cons of each. The next sections will explain some typical setups using those protocols and how to get your server running with them. Last, we’ll go over a few hosted options, if you don’t mind hosting your code on someone else’s server and don’t want to go through the hassle of setting up and maintaining your own server.

Если вас не интересует настройка собственного сервера, вы можете перейти сразу к последней части этой главы для настройки аккаунта на Git-хостинге, и затем перейти к следующей главе, где мы обсудим различные аспекты работы с распределенной системой контроля версий.

If you have no interest in running your own server, you can skip to the last section of the chapter to see some options for setting up a hosted account and then move on to the next chapter, where we discuss the various ins and outs of working in a distributed source control environment.

Удаленный репозиторий обычно _чистый (голый, bare) репозиторий_ ― репозиторий Git не имеющий рабочего каталога. Поскольку этот репозиторий используется только для обмена, нет причин создавать рабочую копию на диске, и он содержит только данные Git. Проще говоря чистый репозиторий содержит только каталог `.git` вашего проекта и ничего больше.

A remote repository is generally a _bare repository_ — a Git repository that has no working directory. Because the repository is only used as a collaboration point, there is no reason to have a snapshot checked out on disk; it’s just the Git data. In the simplest terms, a bare repository is the contents of your project’s `.git` directory and nothing else.

## Протоколы ##

Git умеет работать с четырьмя сетевыми протоколами для передачи данных: локальный, Secure Shell (SSH), Git и HTTP. В этой части мы обсудим каждый из них и в каких случаях стоит (или не стоит) их использовать.

Git can use four major network protocols to transfer data: Local, Secure Shell (SSH), Git, and HTTP. Here we’ll discuss what they are and in what basic circumstances you would want (or not want) to use them.

Важно понимать, что за исключением протокола HTTP, все эти протоколы требуют, чтобы Git был установлен и работал на сервере.

It’s important to note that with the exception of the HTTP protocols, all of these require Git to be installed and working on the server.

### Локальный протокол ###

Базовым протоколом является _Локальный протокол_, при использовании которого удаленный репозиторий ― другой каталог на диске. Наиболее часто он используется если все члены команды имеют доступ к общей файловой системе, например к NFS, или, что менее вероятно, когда все работают на одном компьютере. Последний вариант не столь хорош, поскольку все копии вашего репозитория находятся на одном компьютере, делая возможность потерять все более вероятной.

The most basic is the _Local protocol_, in which the remote repository is in another directory on disk. This is often used if everyone on your team has access to a shared filesystem such as an NFS mount, or in the less likely case that everyone logs in to the same computer. The latter wouldn’t be ideal, because all your code repository instances would reside on the same computer, making a catastrophic loss much more likely.

Если у вас смонтирована общая файловая система, вы можете клонировать, отравлять и получать изменения из локального репозитория. Чтобы склонировать такой репозиторий или добавить его в качестве удаленного в существующий проект, используйте путь к репозиторию в качестве URL. Например для клонирования локального репозитория вы можете запустить что-то вроде этого:

If you have a shared mounted filesystem, then you can clone, push to, and pull from a local file-based repository. To clone a repository like this or to add one as a remote to an existing project, use the path to the repository as the URL. For example, to clone a local repository, you can run something like this:

	$ git clone /opt/git/project.git

Или этого:

Or you can do this:

	$ git clone file:///opt/git/project.git

Git работает немного по-другому если вы укажете префикс `file://` для вашего URL. Когда вы просто указываете путь, Git пытается использовать жесткие ссылки и копировать файлы когда это нужно. Если вы указываете `file://`, Git работает с данными также, как при использовании сетевых протоколов, что в целом менее эффективный способ передачи данных. Причиной для использования `file://` может быть необходимость создания чистой копии репозитория без лишних внешних ссылок и объектов, обычно после импорта из другой СУВ или чего-то похожего (см. главу 9 о задачах поддержки). Мы будем использовать обычные пути, поскольку это практически всегда быстрее.

Git operates slightly differently if you explicitly specify `file://` at the beginning of the URL. If you just specify the path, Git tries to use hardlinks or directly copy the files it needs. If you specify `file://`, Git fires up the processes that it normally uses to transfer data over a network which is generally a lot less efficient method of transferring the data. The main reason to specify the `file://` prefix is if you want a clean copy of the repository with extraneous references or objects left out — generally after an import from another version-control system or something similar (see Chapter 9 for maintenance tasks). We’ll use the normal path here because doing so is almost always faster.

Чтобы добавить локальный репозиторий в существующий проект, вы можете воспользоваться командой:

To add a local repository to an existing Git project, you can run something like this:

	$ git remote add local_proj /opt/git/project.git

Теперь, вы можете отправлять и получать изменения из этого репозитория так как вы это делали по сети.

Then, you can push to and pull from that remote as though you were doing so over a network.

#### Преимущества ####

Преимущества основанных на файлах хранилищ в том что они просты и используют существующие разграничения прав на файлы и сетевой доступ. Если у вас уже есть общая файловая система, доступ к которой имеет вся команда, настройка хранилища очень проста. Вы помещаете чистую копию хранилища туда, куда все имеют доступ, и выставляете права на чтение и запись как вы бы это сделали для любой другой общей директории. Мы обсудим как экспортировать чистую копию хранилища для этой цели в следующем разделе, "Установка Git на сервер".

The pros of file-based repositories are that they’re simple and they use existing file permissions and network access. If you already have a shared filesystem to which your whole team has access, setting up a repository is very easy. You stick the bare repository copy somewhere everyone has shared access to and set the read/write permissions as you would for any other shared directory. We’ll discuss how to export a bare repository copy for this purpose in the next section, “Getting Git on a Server.”

Также это хорошая возможность быстро получить наработки из чьего-то рабочего хранилища. Если вы и сотрудник работаете над одним и тем же проектом и он хочет, чтобы вы проверили что-то, то запуск команды вроде `git pull /home/john/project` зачастую проще чем если бы ваш коллега выкладывал на удалённый сервер и вы забирали бы оттуда.

This is also a nice option for quickly grabbing work from someone else’s working repository. If you and a co-worker are working on the same project and they want you to check something out, running a command like `git pull /home/john/project` is often easier than them pushing to a remote server and you pulling down.

#### Недостатки ####

Недостаток этого метода в том, что общий доступ обычно сложнее настроить и получить из разных мест чем простой сетевой доступ. Если вы хотите отправлять со своего ноутбука, когда вы дома, вы должны смонтировать удалённый диск, что может быть сложно и медленно по сравнению с сетевым доступом.

The cons of this method are that shared access is generally more difficult to set up and reach from multiple locations than basic network access. If you want to push from your laptop when you’re at home, you have to mount the remote disk, which can be difficult and slow compared to network-based access.

Также важно упомянуть что не всегда использование общей точки монтирования является быстрейшим вариантом. Локальное хранилище быстро только если вы имеете быстрый доступ к данным. Хранилище на NFS чаще бывает медленнее чем хранилище через SSH на том же сервере, позволяя Git'у использовать на полную локальные диски на каждой системе.

It’s also important to mention that this isn’t necessarily the fastest option if you’re using a shared mount of some kind. A local repository is fast only if you have fast access to the data. A repository on NFS is often slower than the repository over SSH on the same server, allowing Git to run off local disks on each system.

### Протокол SSH ###

Наверное, наиболее часто используемый транспортный протокол это SSH. Причина этого в том, что доступ по SSH уже есть на многих серверах, а если его нет, то его очень легко настроить. Кроме того SSH единственный из сетевых протоколов предоставляющий доступ и на чтение, и на запись. Два других сетевых протокола (HTTP и Git) в большинстве случаев дают доступ только на чтение, поэтому даже если они вам доступны, вам все равно понадобится SSH для записи. К тому же SSH протокол с аутентификацией, и благодаря его распространенности обычно его легко настроить и использовать.

Probably the most common transport protocol for Git is SSH. This is because SSH access to servers is already set up in most places — and if it isn’t, it’s easy to do. SSH is also the only network-based protocol that you can easily read from and write to. The other two network protocols (HTTP and Git) are generally read-only, so even if you have them available for the unwashed masses, you still need SSH for your own write commands. SSH is also an authenticated network protocol; and because it’s ubiquitous, it’s generally easy to set up and use.

Чтобы склонировать репозиторий Git через SSH, вы должны указать префикс ssh:// в URL, например:

To clone a Git repository over SSH, you can specify ssh:// URL like this:

	$ git clone ssh://user@server:project.git

Или вы можете не указывать протокол, Git подразумевает использование SSH если вы не указали протокол явно:

Or you can not specify a protocol — Git assumes SSH if you aren’t explicit:

	$ git clone user@server:project.git

Также вы можете не указывать имя пользователя, Git будет использовать то, под которым вы вошли в систему.

You can also not specify a user, and Git assumes the user you’re currently logged in as.

#### Достоинства ####

SSH имеет множество достоинств. Во-первых, вы должны его использовать когда вам нужен авторизованный доступ на запись к вашему репозиторию через сеть. Во-вторых, SSH достаточно легко настроить ― демоны SSH распространены, многие системные администраторы имеют опыт работы с ними, и многие дистрибутивы поставляются с ними или утилитами для управления ими. Также, доступ по SSH безопасен ― данные передаются зашифрованными по авторизованным каналам. Наконец, также как и Git-протокол и локальный протокол SSH эффективен, делая данные перед передачей максимально компактными.

The pros of using SSH are many. First, you basically have to use it if you want authenticated write access to your repository over a network. Second, SSH is relatively easy to set up — SSH daemons are commonplace, many network admins have experience with them, and many OS distributions are set up with them or have tools to manage them. Next, access over SSH is secure — all data transfer is encrypted and authenticated. Last, like the Git and Local protocols, SSH is efficient, making the data as compact as possible before transferring it.

#### Недостатки ####

Недостаток SSH в том, что, используя его, вы не можете обеспечить анонимный доступ к репозиторию. Клиенты должны иметь доступ к машине по SSH, даже для работы в режиме только чтение, что делает SSH неподходящим для open source проектов. Если вы используйте Git только внутри корпоративной сети, то возможно SSH единственный протокол с которым вам придется иметь дело. Если же вам нужен анонимный доступ на чтение для ваших проектов, вам придется настроить SSH для себя, чтобы выкладывать изменения, и что-нибудь другое для других, для скачивания.

The negative aspect of SSH is that you can’t serve anonymous access of your repository over it. People must have access to your machine over SSH to access it, even in a read-only capacity, which doesn’t make SSH access conducive to open source projects. If you’re using it only within your corporate network, SSH may be the only protocol you need to deal with. If you want to allow anonymous read-only access to your projects, you’ll have to set up SSH for you to push over but something else for others to pull over.

### Git-протокол ###

Следующий протокол ― Git-протокол. Вместе с Git поставляется специальный демон который слушает порт 9418 и предоставляет сервис схожий с протоколом ssh, но абсолютно без аутентификации. Чтобы использовать Git-протокол для репозитория, вы должны создать файл `git-export-daemon-ok`, иначе демон не будет работать с этим репозиторием, но следует помнить, что в протоколе отсутствуют средства безопасности. Соответственно любой репозиторий в Git может быть либо доступен для клонирования всем, либо не доступен никому. Как следствие обычно вы не можете отгружать изменения по этому протоколу. Вы можете открыть доступ на запись, но из-за отсутствия авторизации в этом случае кто угодно зная URL вашего проекта сможет его изменить. В общем это редко используемая возможность.

Next is the Git protocol. This is a special daemon that comes packaged with Git; it listens on a dedicated port (9418) that provides a service similar to the SSH protocol, but with absolutely no authentication. In order for a repository to be served over the Git protocol, you must create the `git-export-daemon-ok` file — the daemon won’t serve a repository without that file in it — but other than that there is no security. Either the Git repository is available for everyone to clone or it isn’t. This means that there is generally no pushing over this protocol. You can enable push access; but given the lack of authentication, if you turn on push access, anyone on the internet who finds your project’s URL could push to your project. Suffice it to say that this is rare.

#### Достоинства ####

Git-протокол ― самый быстрый из доступных протоколов. Если у вас проект с публичным доступом и большой трафик, или у вас очень большой проект, для которого не требуется авторизация пользователей для чтения, вам стоит настроить демон Git для вашего проекта. Он использует тот же механизм передачи данных, что и протокол SSH, но без дополнительных затрат на кодирование и аутентификацию.

The Git protocol is the fastest transfer protocol available. If you’re serving a lot of traffic for a public project or serving a very large project that doesn’t require user authentication for read access, it’s likely that you’ll want to set up a Git daemon to serve your project. It uses the same data-transfer mechanism as the SSH protocol but without the encryption and authentication overhead.

#### Недостатки ####

Недостатком Git-протокола является отсутствие аутентификации. Поэтому обычно не следует использовать этот протокол как единственный способ доступа к вашему проекту. Обычно он используется в паре с SSH разработчиков, имеющих доступ на запись, тогда как все остальные используют `git://` для доступа на чтение.
Кроме того это вероятно самый сложный для настройки протокол. Вы должны запустить собственно демон, не являющийся стандартным. Мы рассмотрим его настройку в разделе "Gitosis" этой главы. К тому же ему необходим сервис `xinetd` или ему подобный, что не всегда легко сделать. Также для работы необходимо настроить сетевой экран, чтобы открыть нестандартный порт 9418, который обычно закрыт на корпоративных брандмауэрах. За сетевыми экранами крупных корпораций этот неизвестный порт практически всегда заблокирован.

The downside of the Git protocol is the lack of authentication. It’s generally undesirable for the Git protocol to be the only access to your project. Generally, you’ll pair it with SSH access for the few developers who have push (write) access and have everyone else use `git://` for read-only access.
It’s also probably the most difficult protocol to set up. It must run its own daemon, which is custom — we’ll look at setting one up in the “Gitosis” section of this chapter — it requires `xinetd` configuration or the like, which isn’t always a walk in the park. It also requires firewall access to port 9418, which isn’t a standard port that corporate firewalls always allow. Behind big corporate firewalls, this obscure port is commonly blocked.

### Протокол HTTP/S ###

Последний доступный протокол ― HTTP. Прелесть протоколов HTTP и HTTPS в простоте их настройки. По сути, все что необходимо сделать ― поместить чистый репозиторий внутрь каталога с HTTP документами, установить обработчик `post-update` и все (подробнее об обработчиках рассказывается в главе 7). Теперь, каждый имеющий доступ к веб-серверу на котором был размещен репозиторий, может его склонировать. Таким образом, чтобы открыть доступ к вашему репозиторию на чтение через HTTP, нужно сделать что то наподобие этого:

Last we have the HTTP protocol. The beauty of the HTTP or HTTPS protocol is the simplicity of setting it up. Basically, all you have to do is put the bare Git repository under your HTTP document root and set up a specific `post-update` hook, and you’re done (See Chapter 7 for details on Git hooks). At that point, anyone who can access the web server under which you put the repository can also clone your repository. To allow read access to your repository over HTTP, do something like this:

	$ cd /var/www/htdocs/
	$ git clone --bare /path/to/git_project gitproject.git
	$ cd gitproject.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

Вот и все. Обработчик `post-update`, входящий в состав Git по умолчанию выполняет необходимую команду (`git update-server-info`), чтобы обеспечить правильное скачивание и клонирование репозитория. Эта команда выполняется когда вы обновляете репозиторий через SSH, благодаря чему его можно склонировать командой:

That’s all. The `post-update` hook that comes with Git by default runs the appropriate command (`git update-server-info`) to make HTTP fetching and cloning work properly. This command is run when you push to this repository over SSH; then, other people can clone via something like

	$ git clone http://example.com/gitproject.git

В рассмотренном примере, мы использовали каталог `/var/www/htdocs`, обычно используемый сервером Apache, но вы можете использовать любой веб-сервер, отдающий статические данные, расположив чистый репозиторий в нужном каталоге. Данные Git представляют собой обычные файлы (в главе 9 предоставление данных рассматривается более подробно).

In this particular case, we’re using the `/var/www/htdocs` path that is common for Apache setups, but you can use any static web server — just put the bare repository in its path. The Git data is served as basic static files (see Chapter 9 for details about exactly how it’s served).

Также возможна настройка Git, для доступа на запись через HTTP, однако этот способ мало распространен и требует от вас настройки WebDAV. Поскольку этот способ редко используется, мы не будем рассматривать его в рамках этой книги. Если вас интересует использование HTTP протокола с возможностью записи, вы можете почитать о подготовке репозитория в этой статье: `http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt`. Положительным моментом настройки Git для записи через HTTP является то, что вы можете использовать любой WebDAV сервер, без поддержки каких-либо специфичных для Git возможностей. Таким образом если ваш хостинг предоставляет WebDAV, вы можете обеспечить запись обновлений репозитория на ваш веб-сайт.

It’s possible to make Git push over HTTP as well, although that technique isn’t as widely used and requires you to set up complex WebDAV requirements. Because it’s rarely used, we won’t cover it in this book. If you’re interested in using the HTTP-push protocols, you can read about preparing a repository for this purpose at `http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt`. One nice thing about making Git push over HTTP is that you can use any WebDAV server, without specific Git features; so, you can use this functionality if your web-hosting provider supports WebDAV for writing updates to your web site.

#### Достоинства ####

Положительным аспектом использования протокола HTTP является простота настройки. Запуск всего нескольких команд дает вам возможность предоставить миру доступ к вашему репозиторию Git. Вам понадобится всего несколько минут, чтобы сделать это. Кроме того использование протокола HTTP не потребует много ресурсов вашего сервера. Поскольку в основном используется статический HTTP сервер, обычный сервер Apache может обрабатывать в среднем тысячи файлов в секунду, трудно перегрузить даже не большой сервер.

The upside of using the HTTP protocol is that it’s easy to set up. Running the handful of required commands gives you a simple way to give the world read access to your Git repository. It takes only a few minutes to do. The HTTP protocol also isn’t very resource intensive on your server. Because it generally uses a static HTTP server to serve all the data, a normal Apache server can serve thousands of files per second on average — it’s difficult to overload even a small server.

Также вы можете выставлять ваши репозитории в режиме только для чтения через HTTPS, т.е. вы можете шифровать трафик, или вы даже можете авторизовать клиентов по SSL сертификату. Обычно для этих целей легче использовать публичные ключи SSH, но в некоторых конкретных случаях лучшим решением может оказаться использование подписанных SSL сертификатов или других методов аутентификации основанных на HTTP, для доступа на чтение через HTTPS.

You can also serve your repositories read-only over HTTPS, which means you can encrypt the content transfer; or you can go so far as to make the clients use specific signed SSL certificates. Generally, if you’re going to these lengths, it’s easier to use SSH public keys; but it may be a better solution in your specific case to use signed SSL certificates or other HTTP-based authentication methods for read-only access over HTTPS.

Другим плюсом является то, что HTTP настолько широко используемый протокол, что корпоративные сетевые экраны часто настроены на пропускание всего трафика проходящего через этот порт.

Another nice thing is that HTTP is such a commonly used protocol that corporate firewalls are often set up to allow traffic through this port.

#### Недостатки ####

Обратной стороной использования протокола HTTP является его относительно низкая эффективность для клиента. Обычно клонирование или скачивание изменений из репозитория при использовании HTTP гораздо продолжительнее, а объем данных и нагрузка на сеть намного больше, чем у любого другого имеющегося сетевого протокола. Поскольку он не заботится о том, чтобы передавались только необходимые вам данные ― никакой динамической обработке на стороне сервера в этом случае не происходит ― протокол HTTP часто называют _тупым_ (dumb) протоколом. Более подробно о разнице в эффективности протокола HTTP и других протоколов рассказывается в главе 9.

The downside of serving your repository over HTTP is that it’s relatively inefficient for the client. It generally takes a lot longer to clone or fetch from the repository, and you often have a lot more network overhead and transfer volume over HTTP than with any of the other network protocols. Because it’s not as intelligent about transferring only the data you need — there is no dynamic work on the part of the server in these transactions — the HTTP protocol is often referred to as a _dumb_ protocol. For more information about the differences in efficiency between the HTTP protocol and the other protocols, see Chapter 9.

## Установка Git на сервер ##

Для того чтобы приступить к установке любого сервера Git, вы должны экспортировать существующий репозиторий в новый "голый" репозиторий, т.е. репозиторий без рабочего каталога. Обычно это не сложно сделать.
Чтобы склонировать ваш репозиторий и создать новый "голый" репозиторий, запустите команду clone с параметром `--bare`. По существующему соглашению, каталоги с "голыми" репозиториями должны заканчиваться на `.git`, например:

In order to initially set up any Git server, you have to export an existing repository into a new bare repository — a repository that doesn’t contain a working directory. This is generally straightforward to do.
In order to clone your repository to create a new bare repository, you run the clone command with the `--bare` option. By convention, bare repository directories end in `.git`, like so:

	$ git clone --bare my_project my_project.git
	Initialized empty Git repository in /opt/projects/my_project.git/

Вывод это команды слегка обескураживает. Поскольку `clone` по сути это `git init`, а затем `git fetch`, мы видим вывод от `git init`, который создает пустой каталог. Реальное перемещение объектов не имеет вывода, однако оно происходит. Теперь у вас должна быть копия данных из каталога Git в каталоге `my_project.git`.

The output for this command is a little confusing. Since `clone` is basically a `git init` then a `git fetch`, we see some output from the `git init` part, which creates an empty directory. The actual object transfer gives no output, but it does happen. You should now have a copy of the Git directory data in your `my_project.git` directory.

Грубо говоря, это что то наподобие этого:

This is roughly equivalent to something like

	$ cp -Rf my_project/.git my_project.git

Тут есть пара небольших различий в файле конфигурации, но в вашем случае эту разницу можно считать несущественной. Можно считать, что в этом случае берется собственно репозиторий Git без рабочего каталога, и создается каталог только для него.

There are a couple of minor differences in the configuration file; but for your purpose, this is close to the same thing. It takes the Git repository by itself, without a working directory, and creates a directory specifically for it alone.

### Размещение "голого" репозитория на сервере ###

Теперь, когда у вас есть голая копия вашего репозитория, все что вам нужно сделать это поместить ее на сервер и настроить протоколы. Условимся, что вы уже установили сервер `git.example.com`, имеете к нему доступ по SSH и хотите размещать все ваши репозитории Git в каталоге `/opt/git`. Вы можете добавить ваш новый репозиторий копированием голого репозитория:

Now that you have a bare copy of your repository, all you need to do is put it on a server and set up your protocols. Let’s say you’ve set up a server called `git.example.com` that you have SSH access to, and you want to store all your Git repositories under the `/opt/git` directory. You can set up your new repository by copying your bare repository over:

	$ scp -r my_project.git user@git.example.com:/opt/git

Теперь другие пользователи, имеющие доступ к серверу по SSH и право на чтение к каталогу `/opt/git` могут склонировать ваш репозиторий запустив:

At this point, other users who have SSH access to the same server which has read-access to the `/opt/git` directory can clone your repository by running

	$ git clone user@git.example.com:/opt/git/my_project.git

Если у пользователя сервера есть право на запись в каталог `/opt/git/my_project.git`, он автоматически получает возможность отгрузки изменений в репозиторий. Git автоматически добавляет правильные права на запись в репозиторий, если вы запустите команду `git init` с параметром `--shared`.

If a user SSHs into a server and has write access to the `/opt/git/my_project.git` directory, they will also automatically have push access.  Git will automatically add group write permissions to a repository properly if you run the `git init` command with the `--shared` option.

	$ ssh user@git.example.com
	$ cd /opt/git/my_project.git
	$ git init --bare --shared

Видите это просто взять репозиторий Git, создать "голую" версию и поместить ее на сервер, к которому вы и ваши коллеги имеете доступ по SSH. Теперь вы готовы работать вместе над одним проектом.

You see how easy it is to take a Git repository, create a bare version, and place it on a server to which you and your collaborators have SSH access. Now you’re ready to collaborate on the same project.

Важно отметить, что это практически все что вам нужно сделать чтобы получить рабочий сервер Git, к которому несколько человек имеют доступ ― просто добавьте учетные записи SSH на сервер, и положите голый репозиторий в место, к которому эти пользователи имеют доступ на чтение и запись. И все.

It’s important to note that this is literally all you need to do to run a useful Git server to which several people have access — just add SSH-able accounts on a server, and stick a bare repository somewhere that all those users have read and write access to. You’re ready to go — nothing else needed.

Из нескольких последующий разделов вы узнаете как получить более сложные конфигурации. В том числе как не создавать учетные записи для каждого пользователя, как сделать публичный доступ на чтение репозитория, как установить веб-интерфейс, как использовать Gitosis, и др. Однако, помните, что для совместной работы пары человек на закрытом проекте, все что вам _нужно_ ― это сервер SSH и "голый" репозиторий.

In the next few sections, you’ll see how to expand to more sophisticated setups. This discussion will include not having to create user accounts for each user, adding public read access to repositories, setting up web UIs, using the Gitosis tool, and more. However, keep in mind that to collaborate with a couple of people on a private project, all you _need_ is an SSH server and a bare repository.

### Малые установки ###

Если вы небольшая фирма, или вы только пробуете Git в вашей организации и у вас мало разработчиков, то все достаточно просто. Один из наиболее сложных аспектов настройки сервера Git ― управление пользователями. Если вы хотите чтобы некоторые репозитории было доступны некоторым пользователям только на чтение, а другие и на чтение и на запись, вам может быть весьма непросто привести права доступа в порядок.

If you’re a small outfit or are just trying out Git in your organization and have only a few developers, things can be simple for you. One of the most complicated aspects of setting up a Git server is user management. If you want some repositories to be read-only to certain users and read/write to others, access and permissions can be a bit difficult to arrange.

#### SSH доступ ####

Если у вас уже есть сервер, к которому все ваши разработчики имеют доступ по SSH проще всего разместить ваш первый репозиторий там, поскольку вам не нужно практически ничего делать (как мы уже обсудили в предыдущем разделе). Если вы хотите более сложного управления правами доступа в ваши репозитории, вы можете сделать это обычными правами файловой системы, предоставляемыми операционной системой вашего сервера.

If you already have a server to which all your developers have SSH access, it’s generally easiest to set up your first repository there, because you have to do almost no work (as we covered in the last section). If you want more complex access control type permissions on your repositories, you can handle them with the normal filesystem permissions of the operating system your server runs.

Если вы хотите разместить ваши репозитории на сервер, на котором нет учетных записей для каждого в вашей команде кому нужен доступ на запись, вы должны настроить доступ по SSH для них. Будем считать что если у вас есть сервер, на котором вы хотите это сделать, то SSH сервер на нем уже установлен, и через него вы имеете доступ к серверу.

If you want to place your repositories on a server that doesn’t have accounts for everyone on your team whom you want to have write access, then you must set up SSH access for them. We assume that if you have a server with which to do this, you already have an SSH server installed, and that’s how you’re accessing the server.

Есть несколько путей, чтобы дать доступ всем в вашей команде. Первый - настроить учетные записи для каждого, это просто, но может быть весьма обременительно. Вероятно вы не захотите запускать `adduser` и задавать временные пароли для каждого пользователя.

There are a few ways you can give access to everyone on your team. The first is to set up accounts for everybody, which is straightforward but can be cumbersome. You may not want to run `adduser` and set temporary passwords for every user.

Второй способ ― создать на машине одного пользователя 'git', попросить каждого пользователя кому нужен доступ на запись прислать вам публичный ключ SSH, и добавить эти ключи в файл `~/.ssh/authorized_keys` вашего нового пользователя 'git'. Теперь все будут иметь доступ к этой машине через пользователя 'git'. Это не влияет на данные коммита, в любом случае имя пользователя SSH, под которым вы соединяетесь с сервером, не влияет на данные которые вы сохраняете.

A second method is to create a single 'git' user on the machine, ask every user who is to have write access to send you an SSH public key, and add that key to the `~/.ssh/authorized_keys` file of your new 'git' user. At that point, everyone will be able to access that machine via the 'git' user. This doesn’t affect the commit data in any way — the SSH user you connect as doesn’t affect the commits you’ve recorded.

Другой способ сделать это ― использовать сервер SSH, аутентифицирующий по серверу LDAP или любому другому централизованному источнику, который у вас может быть уже настроен. Пока пользователь может получить доступ к консоли, любой способ аутентификации по SSH, какой вы только сможете придумать, должен работать.

Another way to do it is to have your SSH server authenticate from an LDAP server or some other centralized authentication source that you may already have set up. As long as each user can get shell access on the machine, any SSH authentication mechanism you can think of should work.

## Создание публичного SSH ключа ##

Как было уже сказано, многие сервера Git используют аутентификацию по открытым SSH ключам. Для того чтобы предоставить открытый ключ, пользователь должен его сгенерировать, если это не было сделано ранее. Это процесс похож во всех операционных системах. Сначала, вам стоит убедиться, что у вас еще нет ключа. По умолчанию пользовательские ключи SSH хранятся в каталоге `~/.ssh` этого пользователя. Вы можете легко проверить, есть ли у вас ключ, зайдя в этот каталог и посмотрев его содержимое:

That being said, many Git servers authenticate using SSH public keys. In order to provide a public key, each user in your system must generate one if they don’t already have one. This process is similar across all operating systems.
First, you should check to make sure you don’t already have a key. By default, a user’s SSH keys are stored in that user’s `~/.ssh` directory. You can easily check to see if you have a key already by going to that directory and listing the contents:

	$ cd ~/.ssh
	$ ls
	authorized_keys2  id_dsa       known_hosts
	config            id_dsa.pub

Ищите пару файлов с именами "что-нибудь" и "что-нибудь.pub", где "что-нибудь" обычно `id_dsa` или `id_rsa`. Файл с расширением `.pub` - это ваш открытый ключ, а второй файл - ваш закрытый ключ. Если у вас нет этих файлов (или даже нет каталога `.ssh`), вы можете создать их запустив программу `ssh-keygen`, которая входит в состав пакета SSH в системах Linux/Mac, а также поставляется в составе MSysGit для Windows:

You’re looking for a pair of files named something and something.pub, where the something is usually `id_dsa` or `id_rsa`. The `.pub` file is your public key, and the other file is your private key. If you don’t have these files (or you don’t even have a `.ssh` directory), you can create them by running a program called `ssh-keygen`, which is provided with the SSH package on Linux/Mac systems and comes with the MSysGit package on Windows:

	$ ssh-keygen 
	Generating public/private rsa key pair.
	Enter file in which to save the key (/Users/schacon/.ssh/id_rsa): 
	Enter passphrase (empty for no passphrase): 
	Enter same passphrase again: 
	Your identification has been saved in /Users/schacon/.ssh/id_rsa.
	Your public key has been saved in /Users/schacon/.ssh/id_rsa.pub.
	The key fingerprint is:
	43:c5:5b:5f:b1:f1:50:43:ad:20:a6:92:6a:1f:9a:3a schacon@agadorlaptop.local

Сначала необходимо ввести расположение, для сохранения ключа (`.ssh/id_rsa`), затем дважды ввести пароль, который вы можете оставить пустым, если не хотите его вводить каждый раз когда используете ключ.

First it confirms where you want to save the key (`.ssh/id_rsa`), and then it asks twice for a passphrase, which you can leave empty if you don’t want to type a password when you use the key.

Теперь, каждый пользователь должен послать свой открытый ключ вам, или тому кто администрирует сервер Git (предположим, что ваш сервер SSH уже настроен на работу с открытыми ключами). Для этого им нужно скопировать все содержимое файла с расширением `.pub` и отправить его по электронной почте. Открытый ключ выглядит как то так:

Now, each user that does this has to send their public key to you or whoever is administrating the Git server (assuming you’re using an SSH server setup that requires public keys). All they have to do is copy the contents of the `.pub` file and e-mail it. The public keys look something like this:

	$ cat ~/.ssh/id_rsa.pub 
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU
	GPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3
	Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XA
	t3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/En
	mZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbx
	NrRFi9wrf+M7Q== schacon@agadorlaptop.local

Более подробное руководство по созданию ключей SSH на различных системах вы можете найти в руководстве GitHub по ключам SSH на `http://github.com/guides/providing-your-ssh-key`.

For a more in-depth tutorial on creating an SSH key on multiple operating systems, see the GitHub guide on SSH keys at `http://github.com/guides/providing-your-ssh-key`.

## Настраиваем сервер ##

Давайте рассмотрим настройку доступа по SSH на стороне сервера. В этом примере мы будем использовать метод `authorized_keys` для аутентификации пользователей. Мы подразумеваем, что вы используете стандартный дистрибутив Linux типа Ubuntu. Для начала, создадим пользователя 'git' и каталог `.ssh` для этого пользователя:

Let’s walk through setting up SSH access on the server side. In this example, you’ll use the `authorized_keys` method for authenticating your users. We also assume you’re running a standard Linux distribution like Ubuntu. First, you create a 'git' user and a `.ssh` directory for that user.

	$ sudo adduser git
	$ su git
	$ cd
	$ mkdir .ssh

Затем, вам нужно добавить открытые ключи SSH нескольких разработчиков в файл `authorized_keys` этого пользователя. Предположим, вы уже получили несколько ключей по электронной почте и сохранили их во временные файлы. Напомню, открытый ключ выглядит как то так:

Next, you need to add some developer SSH public keys to the `authorized_keys` file for that user. Let’s assume you’ve received a few keys by e-mail and saved them to temporary files. Again, the public keys look something like this:

	$ cat /tmp/id_rsa.john.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCB007n/ww+ouN4gSLKssMxXnBOvf9LGt4L
	ojG6rs6hPB09j9R/T17/x4lhJA0F3FR1rP6kYBRsWj2aThGw6HXLm9/5zytK6Ztg3RPKK+4k
	Yjh6541NYsnEAZuXz0jTTyAUfrtU3Z5E003C4oxOj6H0rfIF1kKI9MAQLMdpGW1GYEIgS9Ez
	Sdfd8AcCIicTDWbqLAcU4UpkaX8KyGlLwsNuuGztobF8m72ALC/nLF6JLtPofwFBlgc+myiv
	O7TCUSBdLQlgMVOFq1I2uPWQOkOWQAHukEOmfjy2jctxSDBQ220ymjaNsHT4kgtZg2AYYgPq
	dAv8JggJICUvax2T9va5 gsg-keypair

Вы просто добавляете их к вашему файлу `authorized_keys`:

You just append them to your `authorized_keys` file:

	$ cat /tmp/id_rsa.john.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.josie.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.jessica.pub >> ~/.ssh/authorized_keys

Теперь, вы можете создать пустой репозиторий для них, запустив `git init` с параметром `--bare`, которая инициализирует репозиторий без рабочего каталога:

Now, you can set up an empty repository for them by running `git init` with the `--bare` option, which initializes the repository without a working directory:

	$ cd /opt/git
	$ mkdir project.git
	$ cd project.git
	$ git --bare init

Затем Джон, Жоси или Джессика могут положить первую версию их проекта в этот репозиторий добавив его как удаленный и отправив ветку. Заметьте, что кто то всегда должен заходить на сервер и создавать голый репозиторий каждый раз, когда вы хотите добавить проект. Пусть `gitserver` ― имя хоста сервера, на котором вы создали пользователя 'git' и репозиторий. Если он находится в вашей внутренней сети, вы можете настроить запись DNS для `gitserver`, ссылающуюся на этот сервер, и использовать эти команды:

Then, John, Josie, or Jessica can push the first version of their project into that repository by adding it as a remote and pushing up a branch. Note that someone must shell onto the machine and create a bare repository every time you want to add a project. Let’s use `gitserver` as the hostname of the server on which you’ve set up your 'git' user and repository. If you’re running it internally, and you set up DNS for `gitserver` to point to that server, then you can use the commands pretty much as is:

	# на компьютере Джона 
	$ cd myproject
	$ git init
	$ git add .
	$ git commit -m 'initial commit'
	$ git remote add origin git@gitserver:/opt/git/project.git
	$ git push origin master

Теперь остальные легко могут склонировать его и выкладывать изменения:

At this point, the others can clone it down and push changes back up just as easily:

	$ git clone git@gitserver:/opt/git/project.git
	$ vim README
	$ git commit -am 'fix for the README file'
	$ git push origin master

Этим способом вы можете быстро получить с сервер Git с доступом на чтение/запись для небольшой группы разработчиков.

With this method, you can quickly get a read/write Git server up and running for a handful of developers.

В качестве дополнительной меры предосторожности вы можете ограничить возможности пользователя 'git' только действиями связанными с Git с помощью ограниченной оболочки `git-shell` поставляемой вместе с Git. Если вы выставите ее в качестве командного интерпретатора пользователя 'git', то этот пользователь не сможет получить доступ к обычной командной оболочке на вашем сервере. Чтобы её использовать, укажите `git-shell`, вместо bash или csh в качестве командной оболочки пользователя. Для этого вы должны отредактировать файл `/etc/passwd`:

As an extra precaution, you can easily restrict the 'git' user to only doing Git activities with a limited shell tool called `git-shell` that comes with Git. If you set this as your 'git' user’s login shell, then the 'git' user can’t have normal shell access to your server. To use this, specify `git-shell` instead of bash or csh for your user’s login shell. To do so, you’ll likely have to edit your `/etc/passwd` file:

	$ sudo vim /etc/passwd

В конце вы должны найти строку, похожую на эту:

At the bottom, you should find a line that looks something like this:

	git:x:1000:1000::/home/git:/bin/sh

Замените `/bin/sh` на `/usr/bin/git-shell` (или запустите `which git-shell`, чтобы проверить куда она установлена). Отредактированная строка должна выглядеть как то так:

Change `/bin/sh` to `/usr/bin/git-shell` (or run `which git-shell` to see where it’s installed). The line should look something like this:

	git:x:1000:1000::/home/git:/usr/bin/git-shell

Теперь, пользователь 'git' может использовать SSH соединение только для работы с репозиториями Git, и не может зайти на машину. Вы можете попробовать и увидите, что вход в систему отклонен:

Now, the 'git' user can only use the SSH connection to push and pull Git repositories and can’t shell onto the machine. If you try, you’ll see a login rejection like this:

	$ ssh git@gitserver
	fatal: What do you think I am? A shell?
	Connection to gitserver closed.

## Открытый доступ ##

Что если вы хотите иметь анонимный доступ к вашему проекту на чтение? Возможно вместо размещения внутреннего закрытого проекта, вы хотите разместить проект open source. Или, может быть у вас есть автоматизированные серверы сборки или серверы непрерывной интеграции, которые часто изменяются, и вы не хотите постоянно перегенерировать ключи SSH, а вы просто хотите добавить анонимный доступ на чтение.

What if you want anonymous read access to your project? Perhaps instead of hosting an internal private project, you want to host an open source project. Or maybe you have a bunch of automated build servers or continuous integration servers that change a lot, and you don’t want to have to generate SSH keys all the time — you just want to add simple anonymous read access.

Вероятно наиболее простой способ для небольших конфигураций ― запустить статический веб-сервер, указав в качестве корневого каталога для документов каталог в котором расположены ваши репозитории Git, и разрешив хук `post-update`, как было показано в первой части этой главы. Давайте продолжим работу с предыдущего примера. Допустим ваши репозитории расположены в каталоге `/opt/git`, и сервер Apache запущен на вашей машине. Повторюсь, вы можете использовать любой веб-сервер, но в качестве примера мы покажем несколько основных конфигураций Apache, которые покажут основную идею что нужно сделать.

Probably the simplest way for smaller setups is to run a static web server with its document root where your Git repositories are, and then enable that `post-update` hook we mentioned in the first section of this chapter. Let’s work from the previous example. Say you have your repositories in the `/opt/git` directory, and an Apache server is running on your machine. Again, you can use any web server for this; but as an example, we’ll demonstrate some basic Apache configurations that should give you an idea of what you might need.

Для начала вам следует включить хук:

First you need to enable the hook:

	$ cd project.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

Если вы используете версию Git ниже 1.6, то команда `mv` не нужна ― именование примеров хуков с расширением .sample только недавно.

If you’re using a version of Git earlier than 1.6, the `mv` command isn’t necessary — Git started naming the hooks examples with the .sample postfix only recently. 

Что делает хук `post-update`? Обычно он выглядит так:

What does this `post-update` hook do? It looks basically like this:

	$ cat .git/hooks/post-update 
	#!/bin/sh
	exec git-update-server-info

Это означает, что когда вы отгружаете на сервер по SSH, Git будет запускать эту команду, чтобы обновить файлы необходимые для скачивания по HTTP.

This means that when you push to the server via SSH, Git will run this command to update the files needed for HTTP fetching.

Затем, вы должны добавить запись VirtualHost в конфигурацию вашего Apache с корневым каталогом документов в каталоге с вашими проектами Git. Здесь мы подразумеваем, что у ваш DNS сервер настроен на отправку `*.gitserver` на машину, которую вы используете, чтобы запустить все это:

Next, you need to add a VirtualHost entry to your Apache configuration with the document root as the root directory of your Git projects. Here, we’re assuming that you have wildcard DNS set up to send `*.gitserver` to whatever box you’re using to run all this:

	<VirtualHost *:80>
	    ServerName git.gitserver
	    DocumentRoot /opt/git
	    <Directory /opt/git/>
	        Order allow, deny
	        allow from all
	    </Directory>
	</VirtualHost>

Вам также понадобится задать Unix группу пользователей для каталога `/opt/git` в `www-data`, чтобы ваш веб-сервер получил доступ на чтение этих каталогов, поскольку (по умолчанию) Apache запускает CGI скрипты от имени такого пользователя:

You’ll also need to set the Unix user group of the `/opt/git` directories to `www-data` so your web server can read-access the repositories, because the Apache instance running the CGI script will (by default) be running as that user:

	$ chgrp -R www-data /opt/git

После перезапуска Apache, вы должны получить возможность склонировать ваши репозитории из того каталога указывая их в URL:

When you restart Apache, you should be able to clone your repositories under that directory by specifying the URL for your project:

	$ git clone http://git.gitserver/project.git

Таким образом, вы можете настроить доступ на чтение по HTTP к любому из ваших проектов для значительно количества пользователей за несколько минут. Другой простой способ дать открытый неаутентифицируемый доступ ― использовать демон Git, однако это требует запуска процесса демона. Мы рассмотрим этот вариант в следующей секции, если вы предпочитаете этот вариант.

This way, you can set up HTTP-based read access to any of your projects for a fair number of users in a few minutes. Another simple option for public unauthenticated access is to start a Git daemon, although that requires you to daemonize the process - we’ll cover this option in the next section, if you prefer that route.

## GitWeb ##

Теперь, когда у вас есть основной доступ на чтение и запись и доступ только на чтение к вашему проекту, вероятно вы захотите настроить простой веб визуализатор. Git поставляется в комплекте с CGI скриптом, называющимся GitWeb, который обычно используется для этого. Вы можете увидеть GitWeb в действии на таких сайтах как `http://git.kernel.org` (рис. 4-1).

Now that you have basic read/write and read-only access to your project, you may want to set up a simple web-based visualizer. Git comes with a CGI script called GitWeb that is commonly used for this. You can see GitWeb in use at sites like `http://git.kernel.org` (see Figure 4-1).

Insert 18333fig0401.png 
Figure 4-1. Веб-интерфейс GitWeb.

Если вы хотите проверить как GitWeb будет выглядеть для вашего проекта, Git поставляется с командой для быстрой установки временного экземпляра, если в вашей системе есть легковесный веб-сервер, такой как `lighttpd` или `webrick`. На машинах с Linux `lighttpd` часто установлен, поэтому возможно вы сможете его запустить выполнив `git instaweb` в вашем каталоге с вашим проектом. Если вы используете Mac, Leopard поставляется с предустановленным Ruby, поэтому `webrick` может быть лучшим выбором. Чтобы запустить `instaweb` с не ligttpd вы можете запустить команду с параметром `-httpd`.

If you want to check out what GitWeb would look like for your project, Git comes with a command to fire up a temporary instance if you have a lightweight server on your system like `lighttpd` or `webrick`. On Linux machines, `lighttpd` is often installed, so you may be able to get it to run by typing `git instaweb` in your project directory. If you’re running a Mac, Leopard comes preinstalled with Ruby, so `webrick` may be your best bet. To start `instaweb` with a non-lighttpd handler, you can run it with the `--httpd` option.

	$ git instaweb --httpd=webrick
	[2009-02-21 10:02:21] INFO  WEBrick 1.3.1
	[2009-02-21 10:02:21] INFO  ruby 1.8.6 (2008-03-03) [universal-darwin9.0]

Это запустит HTTPD сервер на порту 1234 и затем запустить веб-браузер, открытый на этой странице. Это очень просто. Когда вы закончили и хотите остановить сервер, вы можете запустить ту же команду с параметром `--stop`.

That starts up an HTTPD server on port 1234 and then automatically starts a web browser that opens on that page. It’s pretty easy on your part. When you’re done and want to shut down the server, you can run the same command with the `--stop` option:

	$ git instaweb --httpd=webrick --stop

Если вы хотите иметь постоянно работающий веб-интерфейс на сервере для вашей команды или для проекта с открытым кодом на хостинге, вам необходимо установить CGI скрипт на вашем веб-сервере. Некоторые дистрибутивы Linux имеют пакет `gitweb` который вы можете установить используя `apt` или `yum`, так что вы можете попробовать сначала этот способ. Мы рассмотрим установку GitWeb вручную очень вкратце. Для начала, вам нужно получить исходный код Git, с которым поставляется GitWeb и сгенерировать настроенный CGI скрипт:

If you want to run the web interface on a server all the time for your team or for an open source project you’re hosting, you’ll need to set up the CGI script to be served by your normal web server. Some Linux distributions have a `gitweb` package that you may be able to install via `apt` or `yum`, so you may want to try that first. We’ll walk though installing GitWeb manually very quickly. First, you need to get the Git source code, which GitWeb comes with, and generate the custom CGI script:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/
	$ make GITWEB_PROJECTROOT="/opt/git" \
	        prefix=/usr gitweb/gitweb.cgi
	$ sudo cp -Rf gitweb /var/www/

Помните, что вы должны указать команде где расположены ваши репозитории Git с помощью переменной `GITWEB_PROJECTROOT`. Теперь вы должны настроить Apache на использование этого скрипта, для чего вы можете добавить виртуальный хост:

Notice that you have to tell the command where to find your Git repositories with the `GITWEB_PROJECTROOT` variable. Now, you need to make Apache use CGI for that script, for which you can add a VirtualHost:

	<VirtualHost *:80>
	    ServerName gitserver
	    DocumentRoot /var/www/gitweb
	    <Directory /var/www/gitweb>
	        Options ExecCGI +FollowSymLinks +SymLinksIfOwnerMatch
	        AllowOverride All
	        order allow,deny
	        Allow from all
	        AddHandler cgi-script cgi
	        DirectoryIndex gitweb.cgi
	    </Directory>
	</VirtualHost>

Повторюсь, GitWeb может быть установлен на любой веб-сервер, совместимый с CGI. Если вы предпочитаете использовать что то другое, настройка не должна стать для вас проблемой. К этому моменту вы должны иметь возможность зайти на `http://gitserver/` для просмотра ваших репозиториев онлайн, а также использовать `http://git.gitserver` для клонирования и скачивания ваших репозиториев по HTTP.

Again, GitWeb can be served with any CGI capable web server; if you prefer to use something else, it shouldn’t be difficult to set up. At this point, you should be able to visit `http://gitserver/` to view your repositories online, and you can use `http://git.gitserver` to clone and fetch your repositories over HTTP.

## Gitosis ##

Хранение публичных ключей всех пользователей в `authorized_keys` для предоставления доступа работает хорошо лишь на время. Когда у вас сотни пользователей это скорее похоже на пытку. Вы должны заходить на сервер каждый раз и нет никакого разграничения доступа — все перечисленные в файле имеют доступ на чтение и на запись к каждому проекту.

Keeping all users’ public keys in the `authorized_keys` file for access works well only for a while. When you have hundreds of users, it’s much more of a pain to manage that process. You have to shell onto the server each time, and there is no access control — everyone in the file has read and write access to every project.

На этой стадии вы можете захотеть обратиться к широко используемому ПО под названием Gitosis. Gitosis просто набор скриптов который поможет вам управляться с файлом `authorized_keys` и реализовать простой контроль доступа. Действительно интересно что интерфейсом для этого инструмента для добавления людей и определения доступа для них является не веб-интерфейс а специальный git-репозиторий. Вы настраиваете информацию в этом проекте и когда вы отправляете её в репозиторий, Gitosis перенастраивает сервер, основываясь на ней, что круто.

At this point, you may want to turn to a widely used software project called Gitosis. Gitosis is basically a set of scripts that help you manage the `authorized_keys` file as well as implement some simple access controls. The really interesting part is that the UI for this tool for adding people and determining access isn’t a web interface but a special Git repository. You set up the information in that project; and when you push it, Gitosis reconfigures the server based on that, which is cool.

Установка Gitosis не простейшая задача всех времен, но она и не так сложна. Проще всего использовать Linux-сервер для этого — данные примеры используют обычный Ubuntu 8.10 server.

Installing Gitosis isn’t the simplest task ever, but it’s not too difficult. It’s easiest to use a Linux server for it — these examples use a stock Ubuntu 8.10 server.

Gitosis'у нужны некоторые средства Python, так что первым делом вы должны установить пакет Python'а setuptools, который в Ubuntu называется python-setuptools:

Gitosis requires some Python tools, so first you have to install the Python setuptools package, which Ubuntu provides as python-setuptools:

	$ apt-get install python-setuptools

Затем вы клонируете и устанавливаете Gitosis с главного сайта проекта:

Next, you clone and install Gitosis from the project’s main site:

	$ git clone git://eagain.net/gitosis.git
	$ cd gitosis
	$ sudo python setup.py install

Эти команды установят несколько исполняемых файлов, которые будут использоваться Gitosis. Затем Gitosis хочет расположить свои репозитории в каталоге `/home/git`, что неплохо. Но вы уже установили репозитории в `/opt/git`, так что вместо перенастройки всего на свете вы сделаете символическую ссылку:

That installs a couple of executables that Gitosis will use. Next, Gitosis wants to put its repositories under `/home/git`, which is fine. But you have already set up your repositories in `/opt/git`, so instead of reconfiguring everything, you create a symlink:

	$ ln -s /opt/git /home/git/repositories

Gitosis будет управлять ключами за вас, так что вы должны удалить текущий файл, добавить ключи снова позже и предоставить Gitosis'у управлять файлом `authorized_keys` автоматически. Сейчас просто уберите этот файл с дороги:

Gitosis is going to manage your keys for you, so you need to remove the current file, re-add the keys later, and let Gitosis control the `authorized_keys` file automatically. For now, move the `authorized_keys` file out of the way:

	$ mv /home/git/.ssh/authorized_keys /home/git/.ssh/ak.bak

Затем вы должны вернуть пользователю git его командную оболочку, если вы меняли её на команду `git-shell`. Люди всё так же не смогут выполнить вход, но Gitosis будет контролировать это для вас. Итак, давайте поменяем эту строку в файле /etc/passwd

Next you need to turn your shell back on for the 'git' user, if you changed it to the `git-shell` command. People still won’t be able to log in, but Gitosis will control that for you. So, let’s change this line in your `/etc/passwd` file

	git:x:1000:1000::/home/git:/usr/bin/git-shell

обратно на эту:

back to this:

	git:x:1000:1000::/home/git:/bin/sh

Теперь самое время инициализировать Gitosis. Вы сделаете это выполнив команду `gitosis-init` с вашим персональным публичным ключом. Если вашего публичного ключа ещё нет на сервере вы должны будете скопировать его туда:

Now it’s time to initialize Gitosis. You do this by running the `gitosis-init` command with your personal public key. If your public key isn’t on the server, you’ll have to copy it there:

	$ sudo -H -u git gitosis-init < /tmp/id_dsa.pub
	Initialized empty Git repository in /opt/git/gitosis-admin.git/
	Reinitialized existing Git repository in /opt/git/gitosis-admin.git/

Это позволит пользователю с таким ключом изменять главный Git репозиторий что управляет настройкой Gitosis'а. Затем вы должны вручную установить бит исполнения на `post-update` скрипт в вашем новом управляющем репозитории.

This lets the user with that key modify the main Git repository that controls the Gitosis setup. Next, you have to manually set the execute bit on the `post-update` script for your new control repository.

	$ sudo chmod 755 /opt/git/gitosis-admin.git/hooks/post-update

Всё готово. Если вы всё настроили правильно, вы можете попытаться соединиться по SSH с вашим сервером в качестве пользователя, для которого вы добавили публичный ключ чтобы инициализировать Gitosis. Вы должны увидеть что-то вроде этого:

You’re ready to roll. If you’re set up correctly, you can try to SSH into your server as the user for which you added the public key to initialize Gitosis. You should see something like this:

	$ ssh git@gitserver
	PTY allocation request failed on channel 0
	fatal: unrecognized command 'gitosis-serve schacon@quaternion'
	  Connection to gitserver closed.

Это означает, что Gitosis узнал вас, но не пустил, потому что вы не пытались выполнить ни одну из команд Git. Ну так давайте выполним настоящую команду Git - вы склонируете управляющий репозиторий Gitosis:

That means Gitosis recognized you but shut you out because you’re not trying to do any Git commands. So, let’s do an actual Git command — you’ll clone the Gitosis control repository:

	# на вашем локальном компьютере
	$ git clone git@gitserver:gitosis-admin.git

Теперь у вас есть директория с именем `gitosis-admin`, в которой есть две главные части:

Now you have a directory named `gitosis-admin`, which has two major parts:

	$ cd gitosis-admin
	$ find .
	./gitosis.conf
	./keydir
	./keydir/scott.pub

Файл `gitosis-conf` - файл настройки, который вы используете чтобы указать пользователей, репозитории и права доступа. В директории `keydir` вы должны хранить публичные ключи всех пользователей у которых есть какой-либо доступ к вашим репозиториям — по файлу на пользователя. Имя файла в `keydir` (в предыдущем примере `scott.pub`) для вас будет отличаться — Gitosis берёт это имя из описания на конце публичного ключа, который был импортирован скриптом `gitosis-init`.

The `gitosis.conf` file is the control file you use to specify users, repositories, and permissions. The `keydir` directory is where you store the public keys of all the users who have any sort of access to your repositories — one file per user. The name of the file in `keydir` (in the previous example, `scott.pub`) will be different for you — Gitosis takes that name from the description at the end of the public key that was imported with the `gitosis-init` script.

Если вы посмотрите в файл `gitosis.conf`, там должна быть указана только информация о проекте `gitosis-admin`, который вы только что склонировали:

If you look at the `gitosis.conf` file, it should only specify information about the `gitosis-admin` project that you just cloned:

	$ cat gitosis.conf 
	[gitosis]

	[group gitosis-admin]
	writable = gitosis-admin
	members = scott

Это показывает, что пользователь scott — пользователь, чьим публичным ключом вы инициализировали Gitosis — единственный, кто имеет доступ к проекту `gitosis-admin`.

It shows you that the 'scott' user — the user with whose public key you initialized Gitosis — is the only one who has access to the `gitosis-admin` project.

А теперь давайте добавим новый проект. Вы добавите новую секцию с названием `mobile`, где вы перечислите всех разработчиков в вашей мобильной команде и проекты, к которым должны иметь доступ. Поскольку `scott` пока что единственный пользователь в системе, вы добавите его как единственного члена, и вы создадите новый проект под названием `iphone_project` чтобы начать:

Now, let’s add a new project for you. You’ll add a new section called `mobile` where you’ll list the developers on your mobile team and projects that those developers need access to. Because 'scott' is the only user in the system right now, you’ll add him as the only member, and you’ll create a new project called `iphone_project` to start on:

	[group mobile]
	writable = iphone_project
	members = scott

Когда вы вносите изменения в проект `gitosis-admin`, вы должны зафиксировать изменения и отправить их на сервер, чтобы они возымели эффект:

Whenever you make changes to the `gitosis-admin` project, you have to commit the changes and push them back up to the server in order for them to take effect:

	$ git commit -am 'add iphone_project and mobile group'
	[master]: created 8962da8: "changed name"
	 1 files changed, 4 insertions(+), 0 deletions(-)
	$ git push
	Counting objects: 5, done.
	Compressing objects: 100% (2/2), done.
	Writing objects: 100% (3/3), 272 bytes, done.
	Total 3 (delta 1), reused 0 (delta 0)
	To git@gitserver:/opt/git/gitosis-admin.git
	   fb27aec..8962da8  master -> master

Вы можете сделать вашу первую отправку в новый проект `iphone_project` добавлением вашего сервера в качестве удалённого в локальную версию проекта и отправкой. Больше вам не нужно вручную создавать чистые репозитории на сервере - Gitosis создаёт их сам автоматически когда видит первую отправку:

You can make your first push to the new `iphone_project` project by adding your server as a remote to your local version of the project and pushing. You no longer have to manually create a bare repository for new projects on the server — Gitosis creates them automatically when it sees the first push:

	$ git remote add origin git@gitserver:iphone_project.git
	$ git push origin master
	Initialized empty Git repository in /opt/git/iphone_project.git/
	Counting objects: 3, done.
	Writing objects: 100% (3/3), 230 bytes, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:iphone_project.git
	 * [new branch]      master -> master

Заметьте, что вам не нужно указывать путь (фактически, это не будет работать), только двоеточие и имя проекта - Gitosis найдёт его для вас.

Notice that you don’t need to specify the path (in fact, doing so won’t work), just a colon and then the name of the project — Gitosis finds it for you.

Вы хотите работать над проектом с вашими друзьями, так что вам нужно снова добавить их публичные ключи. Но вместо того, чтобы вручную добавлять их к файлу `~/.ssh/authorized_keys` на вашем сервере, добавьте их, один ключ на файл, в директорию `keydir`. Как вы назовёте ключи определит как вы будете ссылаться на них в `gitosis.conf`. Давайте добавим по-новой публичные ключи для Джона, Жози и Джессики:

You want to work on this project with your friends, so you’ll have to re-add their public keys. But instead of appending them manually to the `~/.ssh/authorized_keys` file on your server, you’ll add them, one key per file, into the `keydir` directory. How you name the keys determines how you refer to the users in the `gitosis.conf` file. Let’s re-add the public keys for John, Josie, and Jessica:

	$ cp /tmp/id_rsa.john.pub keydir/john.pub
	$ cp /tmp/id_rsa.josie.pub keydir/josie.pub
	$ cp /tmp/id_rsa.jessica.pub keydir/jessica.pub

Теперь вы можете добавить их всех в вашу 'мобильную' команду, чтобы они имели доступ на чтение и запись в `iphone_project`:

Now you can add them all to your 'mobile' team so they have read and write access to `iphone_project`:

	[group mobile]
	writable = iphone_project
	members = scott john josie jessica

После того, как вы зафиксируете и отправите изменения, все четыре пользователя будут иметь возможность читать и писать в проект.

After you commit and push that change, all four users will be able to read from and write to that project.

В Gitosis также есть простой контроль доступа. Если вы хотите, чтобы Джон имел только доступ на чтение к этому проекту, вы можете вместо этого сделать:

Gitosis has simple access controls as well. If you want John to have only read access to this project, you can do this instead:

	[group mobile]
	writable = iphone_project
	members = scott josie jessica

	[group mobile_ro]
	readonly = iphone_project
	members = john

Теперь Джон может клонировать проект и получать обновления, но Gitosis не позволит ему отправлять обратно в проект. Вы можете создать таких групп сколько хотите, каждую содержащую разные проекты и пользователей. Вы также можете указать другую группу как одного из пользователей (используя `@` как префикс), чтобы унаследовать всех её членов автоматически:

Now John can clone the project and get updates, but Gitosis won’t allow him to push back up to the project. You can create as many of these groups as you want, each containing different users and projects. You can also specify another group as one of the members (using `@` as prefix), to inherit all of its members automatically:

	[group mobile_committers]
	members = scott josie jessica

	[group mobile]
	writable  = iphone_project
	members   = @mobile_committers

	[group mobile_2]
	writable  = another_iphone_project
	members   = @mobile_committers john

Если у вас возникли какие-то проблемы, полезным может быть добавить `loglevel=DEBUG` в секции `[gitosis]`. Если вы потеряли доступ к отправке отправив неверную конфигурацию, вы можете вручную поправить файл `/home/git/.gitosis.conf` на сервере — файл, из которого Gitosis читает свою информацию. Отправка в проект берёт файл `gitosis.conf`, который вы только что отправили, и помещает его туда. Если вы отредактируете этот файл вручную, он останется таким до следующей успешной отправки в проект `gitosis-admin`.

If you have any issues, it may be useful to add `loglevel=DEBUG` under the `[gitosis]` section. If you’ve lost push access by pushing a messed-up configuration, you can manually fix the file on the server under `/home/git/.gitosis.conf` — the file from which Gitosis reads its info. A push to the project takes the `gitosis.conf` file you just pushed up and sticks it there. If you edit that file manually, it remains like that until the next successful push to the `gitosis-admin` project.

## Gitolite ##

Git has started to become very popular in corporate environments, which tend to have some additional requirements in terms of access control.  Gitolite was created to help with those requirements.

Gitolite allows you to specify permissions not just by repository (like Gitosis does), but also by branch or tag names within each repository.  That is, you can specify that certain people (or groups of people) can only push certain "refs" (branches or tags) but not others.

### Installing ###

Installing Gitolite is very easy, even if you don't read the extensive documentation that comes with it.  You need an account on a Unix server of some kind; various Linux flavours, and Solaris 10, have been tested.  You do not need root access, assuming git, perl, and an openssh compatible ssh server are already installed.  In the examples below, we will use the `gitolite` account on a host called `gitserver`.

Curiously, Gitolite is installed by running a script *on the workstation*, so your workstation must have a bash shell available.  Even the bash that comes with msysgit will do, in case you're wondering.

You start by obtaining public key based access to your server, so that you can log in from your workstation to the server without getting a password prompt.  The following method works on Linux; for other workstation OSs you may have to do this manually.  We assume you already had a key pair generated using `ssh-keygen`.

	$ ssh-copy-id -i ~/.ssh/id_rsa gitolite@gitserver

This will ask you for the password to the gitolite account, and then set up public key access.  This is **essential** for the install script, so check to make sure you can run a command without getting a password prompt:

	$ ssh gitolite@gitserver pwd
	/home/gitolite

Next, you clone Gitolite from the project's main site and run the "easy install" script (the third argument is your name as you would like it to appear in the resulting gitolite-admin repository):

	$ git clone git://github.com/sitaramc/gitolite
	$ cd gitolite/src
	$ ./gl-easy-install -q gitolite gitserver sitaram

And you're done!  Gitolite has now been installed on the server, and you now have a brand new repository called `gitolite-admin` in the home directory of your workstation.  You administer your gitolite setup by making changes to this repository and pushing (just like Gitosis).

[By the way, *upgrading* gitolite is also done the same way.  Also, if you're interested, run the script without any arguments to get a usage message.]

That last command does produce a fair amount of output, which might be interesting to read.  Also, the first time you run this, a new keypair is created; you will have to choose a passphrase or hit enter for none.  Why a second keypair is needed, and how it is used, is explained in the "ssh troubleshooting" document that comes with Gitolite.  (Hey the documentation has to be good for *something*!)

### Customising the Install ###

While the default, quick, install works for most people, there are some ways to customise the install if you need to.  If you omit the `-q` argument, you get a "verbose" mode install -- detailed information on what the install is doing at each step.  The verbose mode also allows you to change certain server-side parameters, such as the location of the actual repositories, by editing an "rc" file that the server uses.  This "rc" file is liberally commented so you should be able to make any changes you need quite easily, save it, and continue.  This file also contains various settings that you can change to enable or disable some of gitolite's advanced features.

### Config File and Access Control Rules ###

So once the install is done, you switch to the `gitolite-admin` repository (placed in your HOME directory) and poke around to see what you got:

	$ cd ~/gitolite-admin/
	$ ls
	conf/  keydir/
	$ find conf keydir -type f
	conf/gitolite.conf
	keydir/sitaram.pub
	$ cat conf/gitolite.conf
	#gitolite conf
	# please see conf/example.conf for details on syntax and features

	repo gitolite-admin
	    RW+                 = sitaram

	repo testing
	    RW+                 = @all

Notice that "sitaram" (the last argument in the `gl-easy-install` command you gave earlier) has read-write permissions on the `gitolite-admin` repository as well as a public key file of the same name.

The config file syntax for Gitolite is *quite* different from Gitosis.  Again, this is liberally documented in `conf/example.conf`, so we'll only mention some highlights here.

You can group users or repos for convenience.  The group names are just like macros; when defining them, it doesn't even matter whether they are projects or users; that distinction is only made when you *use* the "macro".

	@oss_repos      = linux perl rakudo git gitolite
	@secret_repos   = fenestra pear

	@admins         = scott     # Adams, not Chacon, sorry :)
	@interns        = ashok     # get the spelling right, Scott!
	@engineers      = sitaram dilbert wally alice
	@staff          = @admins @engineers @interns

You can control permissions at the "ref" level.  In the following example, interns can only push the "int" branch.  Engineers can push any branch whose name starts with "eng-", and tags that start with "rc" followed by a digit.  And the admins can do anything (including rewind) to any ref.

	repo @oss_repos
	    RW  int$                = @interns
	    RW  eng-                = @engineers
	    RW  refs/tags/rc[0-9]   = @engineers
	    RW+                     = @admins

The expression after the `RW` or `RW+` is a regular expression (regex) that the refname (ref) being pushed is matched against.  So we call it a "refex"!  Of course, a refex can be far more powerful than shown here, so don't overdo it if you're not comfortable with perl regexes.

Also, as you probably guessed, Gitolite prefixes `refs/heads/` as a syntactic convenience if the refex does not begin with `refs/`.

An important feature of the config file's syntax is that all the rules for a repository need not be in one place.  You can keep all the common stuff together, like the rules for all `oss_repos` shown above, then add specific rules for specific cases later on, like so:

	repo gitolite
	    RW+                     = sitaram

That rule will just get added to the ruleset for the `gitolite` repository.

At this point you might be wondering how the access control rules are actually applied, so let's go over that briefly.

There are two levels of access control in gitolite.  The first is at the repository level; if you have read (or write) access to *any* ref in the repository, then you have read (or write) access to the repository.  This is the only access control that Gitosis had.

The second level, applicable only to "write" access, is by branch or tag within a repository.  The username, the access being attempted (`W` or `+`), and the refname being updated are known.  The access rules are checked in order of appearance in the config file, looking for a match for this combination (but remember that the refname is regex-matched, not merely string-matched).  If a match is found, the push succeeds.  A fallthrough results in access being denied.

### Advanced Access Control with "deny" rules ###

So far, we've only seen permissions to be one or `R`, `RW`, or `RW+`.  However, gitolite allows another permission: `-`, standing for "deny".  This gives you a lot more power, at the expense of some complexity, because now fallthrough is not the *only* way for access to be denied, so the *order of the rules now matters*!

Let us say, in the situation above, we want engineers to be able to rewind any branch *except* master and integ.  Here's how to do that:

	    RW  master integ    = @engineers
	    -   master integ    = @engineers
	    RW+                 = @engineers

Again, you simply follow the rules top down until you hit a match for your access mode, or a deny.  Non-rewind push to master or integ is allowed by the first rule.  A rewind push to those refs does not match the first rule, drops down to the second, and is therefore denied.  Any push (rewind or non-rewind) to refs other than master or integ won't match the first two rules anyway, and the third rule allows it.

### Restricting pushes by files changed ###

In addition to restricting what branches a user can push changes to, you can also restrict what files they are allowed to touch.  For example, perhaps the Makefile (or some other program) is really not supposed to be changed by just anyone, because a lot of things depend on it or would break if the changes are not done *just right*.  You can tell gitolite:

    repo foo
        RW                  =   @junior_devs @senior_devs

        RW  NAME/           =   @senior_devs
        -   NAME/Makefile   =   @junior_devs
        RW  NAME/           =   @junior_devs

This powerful feature is documented in `conf/example.conf`.

### Personal Branches ###

Gitolite also has a feature called "personal branches" (or rather, "personal branch namespace") that can be very useful in a corporate environment.

A lot of code exchange in the git world happens by "please pull" requests.  In a corporate environment, however, unauthenticated access is a no-no, and a developer workstation cannot do authentication, so you have to push to the central server and ask someone to pull from there.

This would normally cause the same branch name clutter as in a centralised VCS, plus setting up permissions for this becomes a chore for the admin.

Gitolite lets you define a "personal" or "scratch" namespace prefix for each developer (for example, `refs/personal/<devname>/*`), with full permissions for that dev only, and read access for everyone else.  Just choose a verbose install and set the `$PERSONAL` variable in the "rc" file to `refs/personal`.  That's all; it's pretty much fire and forget as far as the admin is concerned, even if there is constant churn in the project team composition.

### "Wildcard" repositories ###

Gitolite allows you to specify repositories with wildcards (actually perl regexes), like, for example `assignments/s[0-9][0-9]/a[0-9][0-9]`, to pick a random example.  This is a *very* powerful feature, which has to be enabled by setting `$GL_WILDREPOS = 1;` in the rc file.  It allows you to assign a new permission mode ("C") which allows users to create repositories based on such wild cards, automatically assigns ownership to the specific user who created it, allows him/her to hand out R and RW permissions to other users to collaborate, etc.  This feature is documented in `doc/4-wildcard-repositories.mkd`.

### Other Features ###

We'll round off this discussion with a bunch of other features, all of which are described in great detail in the "faqs, tips, etc" document.

**Logging**: Gitolite logs all successful accesses.  If you were somewhat relaxed about giving people rewind permissions (`RW+`) and some kid blew away "master", the log file is a life saver, in terms of easily and quickly finding the SHA that got hosed.

**Git outside normal PATH**: One extremely useful convenience feature in gitolite is support for git installed outside the normal `$PATH` (this is more common than you think; some corporate environments or even some hosting providers refuse to install things system-wide and you end up putting them in your own directories).  Normally, you are forced to make the *client-side* git aware of this non-standard location of the git binaries in some way.  With gitolite, just choose a verbose install and set `$GIT_PATH` in the "rc" files.  No client-side changes are required after that :-)

**Access rights reporting**: Another convenient feature is what happens when you try and just ssh to the server.  Older versions of gitolite used to complain about the `SSH_ORIGINAL_COMMAND` environment variable being empty (see the ssh documentation if interested).  Now Gitolite comes up with something like this:

	hello sitaram, the gitolite version here is v0.90-9-g91e1e9f
	you have the following permissions:
	  R     anu-wsd
	  R     entrans
	  R  W  git-notes
	  R  W  gitolite
	  R  W  gitolite-admin
	  R     indic_web_input
	  R     shreelipi_converter

**Delegation**: For really large installations, you can delegate responsibility for groups of repositories to various people and have them manage those pieces independently.  This reduces the load on the main admin, and makes him less of a bottleneck.  This feature has its own documentation file in the `doc/` directory.

**Gitweb support**: Gitolite supports gitweb in several ways.  You can specify which repos are visible via gitweb.  You can set the "owner" and "description" for gitweb from the gitolite config file.  Gitweb has a mechanism for you to implement access control based on HTTP authentication, so you can make it use the "compiled" config file that gitolite produces, which means the same access control rules (for read access) apply for gitweb and gitolite.

## Демон Git ##

Для публичного, неидентифицированного доступа на чтение к вашим проектам вы можете захотеть продвинуться дальше, чем HTTP протокол и начать использовать Git протокол. Главная причина — скорость. Git протокол гораздо эффективнее и поэтому быстрее чем HTTP, поэтому используя его вы можете сэкономить вашим пользователям время.

For public, unauthenticated read access to your projects, you’ll want to move past the HTTP protocol and start using the Git protocol. The main reason is speed. The Git protocol is far more efficient and thus faster than the HTTP protocol, so using it will save your users time.

Повторимся, это для доступа только на чтение без авторизации. Если вы запустите его на сервере за пределами вашего сетевого экрана, он должен использоваться для проектов, которые публично видны миру. Если сервер, на котором вы его запускаете, в пределах вашего сетевого экрана, вы можете использовать его для проектов, к которым большее число людей или компьютеров (серверов непрерывной интеграции или сборки) должно иметь доступ на чтение, когда вы не хотите для каждого заводить SSH ключ.

Again, this is for unauthenticated read-only access. If you’re running this on a server outside your firewall, it should only be used for projects that are publicly visible to the world. If the server you’re running it on is inside your firewall, you might use it for projects that a large number of people or computers (continuous integration or build servers) have read-only access to, when you don’t want to have to add an SSH key for each.

В любом случае, протокол Git относительно просто установить. Упрощённо, вам нужно запустить следующую команду в демонизированной форме:

In any case, the Git protocol is relatively easy to set up. Basically, you need to run this command in a daemonized manner:

	git daemon --reuseaddr --base-path=/opt/git/ /opt/git/

`--reuseaddr` позволит серверу перезапуститься без ожидания истечения старых подключений, `--base-path` позволит людям не указывать полный путь чтобы склонировать проект, а путь на конце говорит демону Git, где искать экспортируемые репозитории. Если у вас запущен сетевой экран, вы должны проколоть в нём дырочку, открыв порт 9418 на машину, на которой это всё запущено.

`--reuseaddr` allows the server to restart without waiting for old connections to time out, the `--base-path` option allows people to clone projects without specifying the entire path, and the path at the end tells the Git daemon where to look for repositories to export. If you’re running a firewall, you’ll also need to punch a hole in it at port 9418 on the box you’re setting this up on.

Вы можете демонизировать этот процесс несколькими путями, в зависимости от операционной системы. На машине с Ubuntu используйте Upstart скрипт. Итак, в этом файле

You can daemonize this process a number of ways, depending on the operating system you’re running. On an Ubuntu machine, you use an Upstart script. So, in the following file

	/etc/event.d/local-git-daemon

поместите такой скрипт:

you put this script:

	start on startup
	stop on shutdown
	exec /usr/bin/git daemon \
	    --user=git --group=git \
	    --reuseaddr \
	    --base-path=/opt/git/ \
	    /opt/git/
	respawn

По соображениям безопасности крайне приветствуется, если вы будете запускать этого демона как пользователя с правами только на чтение на репозитории — вы легко можете сделать это, создав пользователя 'git-ro' и запустив этого демона из-под него. Для простоты мы запустим его от того же пользователя 'git', от которого запущен Gitosis.

For security reasons, it is strongly encouraged to have this daemon run as a user with read-only permissions to the repositories – you can easily do this by creating a new user 'git-ro' and running the daemon as them.  For the sake of simplicity we’ll simply run it as the same 'git' user that Gitosis is running as.

Когда вы перезапустите машину, Git демон запустится автоматически, и возродится, если вдруг завершится. Чтобы запустить его без перезагрузки машины, вы можете выполнить это:

When you restart your machine, your Git daemon will start automatically and respawn if it goes down. To get it running without having to reboot, you can run this:

	initctl start local-git-daemon

На других системах вы можете использовать `xinetd`, скрипт вашей системы `sysvinit`, или что-то другое — если вы сможете эту команду как-либо демонизировать и перезапускать в случае завершения.

On other systems, you may want to use `xinetd`, a script in your `sysvinit` system, or something else — as long as you get that command daemonized and watched somehow.

Затем, вы должны указать Gitosis серверу, к каким репозиториям предоставить неидентифицированный доступ через Git сервер. Если вы добавили по секции для каждого репозитория, вы можете указать, из каких позволено читать демону Git& Если вы хотите предоставить доступ через Git протокол к вашему iphone проекту, добавьте это в конец вашего файла `gitosis.conf`:

Next, you have to tell your Gitosis server which repositories to allow unauthenticated Git server-based access to. If you add a section for each repository, you can specify the ones from which you want your Git daemon to allow reading. If you want to allow Git protocol access for your iphone project, you add this to the end of the `gitosis.conf` file:

	[repo iphone_project]
	daemon = yes

Когда это зафиксировано и отправлено, ваш запущенный демон должен начать обслуживать запросы к проекту от всех, у кого есть доступ к порту 9418 на вашем сервере.

When that is committed and pushed up, your running daemon should start serving requests for the project to anyone who has access to port 9418 on your server.

Если вы решили не использовать Gitosis, но хотите установить Git демон, вы должны запустить это в каждом проекте, который должен обслуживаться Git демоном:

If you decide not to use Gitosis, but you want to set up a Git daemon, you’ll have to run this on each project you want the Git daemon to serve:

	$ cd /path/to/project.git
	$ touch git-daemon-export-ok

Присутствие этого файла скажет Git'у, что можно обслуживать этот проект без аутентификации.

The presence of that file tells Git that it’s OK to serve this project without authentication.

Gitosis также может контролировать, какие проекты будет показывать GitWeb. Вам нужно добавить что-то вроде этого в файл `/etc/gitweb.conf`:

Gitosis can also control which projects GitWeb shows. First, you need to add something like the following to the `/etc/gitweb.conf` file:

	$projects_list = "/home/git/gitosis/projects.list";
	$projectroot = "/home/git/repositories";
	$export_ok = "git-daemon-export-ok";
	@git_base_url_list = ('git://gitserver');

Вы можете контролировать, какие проекты GitWeb будет позволять просматривать пользователям, добавляя или удаляя настройку `gitweb` в конфигурационном файле Gitosis. Например, если вы хотите, чтобы ваше iphone проект показывался в GitWeb, пусть ваша секция `repo` выглядит как-то так:

You can control which projects GitWeb lets users browse by adding or removing a `gitweb` setting in the Gitosis configuration file. For instance, if you want the iphone project to show up on GitWeb, you make the `repo` setting look like this:

	[repo iphone_project]
	daemon = yes
	gitweb = yes

Теперь, если вы зафиксируете и отправите изменения, GitWeb автоматически начнёт показывать ваш iphone проект.

Now, if you commit and push the project, GitWeb will automatically start showing your iphone project.

## Git хостинг ##

Если вы не хотите связываться со всей работой по установке собственного Git сервера, у вас есть несколько вариантов размещения ваших Git проектов на внешних специальных хостинг сайтах. Это предоставляет множество преимуществ: на хостинг сайте обычно быстро настроить и запустить проект и нет никакого мониторинга или поддержки сервера. Даже если вы установили и запустили свой собственный внутренний сервер, вы можете захотеть использовать публичный хостинг сайт для вашего открытого кода — обычно сообществу открытого кода так будет проще вас найти и помочь.

If you don’t want to go through all of the work involved in setting up your own Git server, you have several options for hosting your Git projects on an external dedicated hosting site. Doing so offers a number of advantages: a hosting site is generally quick to set up and easy to start projects on, and no server maintenance or monitoring is involved. Even if you set up and run your own server internally, you may still want to use a public hosting site for your open source code — it’s generally easier for the open source community to find and help you with.

В наши дни у вас есть огромное количество вариантов хостинга чтобы выбирать, все со своими преимуществами и недостатками. Чтобы увидеть актуальный список, проверьте страницу GitHosting в главной вики Git:

These days, you have a huge number of hosting options to choose from, each with different advantages and disadvantages. To see an up-to-date list, check out the GitHosting page on the main Git wiki:

	http://git.or.cz/gitwiki/GitHosting

Поскольку мы не можем рассмотреть их все, и поскольку я работаю на один из них, мы в этом разделе рассмотрим процесс создания учётной записи и нового проекта на GitHub. Это даст вам представление о вовлечённых в него вещах.

Because we can’t cover all of them, and because I happen to work at one of them, we’ll use this section to walk through setting up an account and creating a new project at GitHub. This will give you an idea of what is involved. 

GitHub пока что крупнейший Git хостинг сайт открытого кода и также один из очень немногих, предоставляющих и публичный и приватный хостинг, так что вы можете хранить ваш открытый и коммерческий код в одном месте. На самом деле, мы использовали GitHub чтобы закрыто совместно писать эту книгу (прим. переводчика: и открыто переводить после её издания).

GitHub is by far the largest open source Git hosting site and it’s also one of the very few that offers both public and private hosting options so you can keep your open source and private commercial code in the same place. In fact, we used GitHub to privately collaborate on this book.

### GitHub ###

GitHub немного отличается от других хостингов кода способом группировки проектов. Вместо того, чтобы быть основанным главным образом на проектах, он ориентируется на пользователей. Это значит, что когда я размещаю свой проект `grit` на GitHub, вы найдёте его как `github.com/schacon/grit` вместо `github.com/grit`. Нет никакой канонической версии проекта, что позволяет проекту беспрепятственно переходить от пользователя к другому пользователю, если первый забросил проект.

GitHub is slightly different than most code-hosting sites in the way that it namespaces projects. Instead of being primarily based on the project, GitHub is user centric. That means when I host my `grit` project on GitHub, you won’t find it at `github.com/grit` but instead at `github.com/schacon/grit`. There is no canonical version of any project, which allows a project to move from one user to another seamlessly if the first author abandons the project.

GitHub также коммерческая компания, которая взимает плату за аккаунты с приватными репозиториями, но кто угодно может быстро получить бесплатную учётную запись чтобы разместить сколь угодно открытых проектов. Мы быстро рассмотрим, как это устроено.

GitHub is also a commercial company that charges for accounts that maintain private repositories, but anyone can quickly get a free account to host as many open source projects as they want. We’ll quickly go over how that is done.

### Настройка учётной записи ###

Первая вещь, которую вам нужно сделат, это настройка учётной записи. Если вы посетите страницу Тарифные планы по адресу `http://github.com/plans` и нажмёте на кнопку "Создать бесплатный аккаунт" (см. рисунок 4-2), вы попадёте на страницу регистрации.

The first thing you need to do is set up a free user account. If you visit the Pricing and Signup page at `http://github.com/plans` and click the "Sign Up" button on the Free account (see figure 4-2), you’re taken to the signup page.

Insert 18333fig0402.png
Рисунок 4-2. Страница тарифных планов GitHub.

Здесь вы должны выбрать имя пользователя, которое ещё не занято в системе, и ввести адрес электронной почты, который будет сопоставлен аккаунту, и пароль (см. рис. 4-3).

Here you must choose a username that isn’t yet taken in the system and enter an e-mail address that will be associated with the account and a password (see Figure 4-3).

Insert 18333fig0403.png 
Рисунок 4-3. Страница регистрации пользователя GitHub.

Если есть возможность, сейчас также хорошее время добавить ваш публичный SSH ключ. Мы рассмотрели, как создать ключ, ранее, в разделе "Создание публичного SSH ключа". Возьмите содержимое публичного ключа из этой пары и вставьте в поле ввода публичного SSH ключа. Ссылка "Нужна помощь с публичными ключами?" направит вас к детальным инструкциям как это сделать на всех основных операционных системах.
Нажатие на кнопку "Создать учётную запись" откроет приборную панель вашего нового пользователя (см. рис. 4-4).

If you have it available, this is a good time to add your public SSH key as well. We covered how to generate a new key earlier, in the "Simple Setups" section. Take the contents of the public key of that pair, and paste it into the SSH Public Key text box. Clicking the "explain ssh keys" link takes you to detailed instructions on how to do so on all major operating systems.
Clicking the "I agree, sign me up" button takes you to your new user dashboard (see Figure 4-4).

Insert 18333fig0404.png 
Рисунок 4-4. Приборная панель GitHub.

Затем вы можете создать новый репозиторий.

Next you can create a new repository.

### Создание нового репозитория ###

Начните с клика на ссылку "Новый репозиторий" рядом с разделом "Твои репозитории" на пользовательской приборной панели. Вы перейдёте на форму "Создать новый репозиторий" (см. рис. 4-5).

Start by clicking the "create a new one" link next to Your Repositories on the user dashboard. You’re taken to the Create a New Repository form (see Figure 4-5).

Insert 18333fig0405.png 
Рисунок 4-5. Создание нового репозитория на GitHub.

Всё что вам действительно необходимо сделать, это указать имя проекта, но также можно добавить и описание. Когда это сделано, нажмите на кнопку "Создать репозиторий". Теперь у вас есть новый репозиторий на GitHub (см. рис. 4-6).

All you really have to do is provide a project name, but you can also add a description. When that is done, click the "Create Repository" button. Now you have a new repository on GitHub (see Figure 4-6).

Insert 18333fig0406.png 
Рисунок 4-6. Заглавная информация проекта GitHub.

Поскольку у вас ещё нет кода, GitHub покажет вам инструкцию, как создать совершенно новый проект, отправить существующий или импортировать проект из публичного репозитория Subversion (см. рис. 4-7). 

Since you have no code there yet, GitHub will show you instructions for how create a brand-new project, push an existing Git project up, or import a project from a public Subversion repository (see Figure 4-7).

Insert 18333fig0407.png 
Рисунок 4-7. Инструкции для нового репозитория.

Эти инструкции похожи на те, что мы уже прошли. Чтобы инициализировать проект, если это ешщё не проект Git, вы пишете

These instructions are similar to what we’ve already gone over. To initialize a project if it isn’t already a Git project, you use

	$ git init
	$ git add .
	$ git commit -m 'initial commit'

Если у вас есть локальный Git репозиторий, добавьте GitHub как удалённый сервер и отправьте вашу ветку master:

When you have a Git repository locally, add GitHub as a remote and push up your master branch:

	$ git remote add origin git@github.com:testinguser/iphone_project.git
	$ git push origin master

Теперь ваш проект размещён на GitHub и вы можете дать ссылку на него любому, с кем вы захотите разделить проект. В этом случае, это `http://github.com/testinguser/iphone_project`. Вы также можете в заголовке каждой страницы проекта, что у вас две Git ссылки (см. рис. 4-8).

Now your project is hosted on GitHub, and you can give the URL to anyone you want to share your project with. In this case, it’s `http://github.com/testinguser/iphone_project`. You can also see from the header on each of your project’s pages that you have two Git URLs (see Figure 4-8).

Insert 18333fig0408.png 
Рисунок 4-8. Заголовок проекта с публичной и приватной ссылками.

Ссылка "Git, только чтение" это публичная ссылка только для чтения через которую кто угодно может склонировать проект. Можете давать эту ссылку или размещать её на вашем сайте или делать с ней что угодно.

The Public Clone URL is a public, read-only Git URL over which anyone can clone the project. Feel free to give out that URL and post it on your web site or what have you.

Ссылка SSH это основанная на SSH ссылка на чтение и запись, через которую вы можете читать и писать только если вы соединяетесь имея приватный ключ из пары публичного SSH ключа, загруженного вашим пользователем. Когда другие пользователи посещают страницу проекта, они не увидят этой ссылки — только публичную.

The Your Clone URL is a read/write SSH-based URL that you can read or write over only if you connect with the SSH private key associated with the public key you uploaded for your user. When other users visit this project page, they won’t see that URL—only the public one.

### Импорт из Subversion ###

Если у вас есть существующий публичный Subversion проект, который вы хотите импортировать в Git, GitHub часто может сделать это за вас. Внизу страницы инструкций есть ссылка на импорт из Subversion. Если вы кликнете по ней, вы увидите форму с информацией о процессе импорта и текстовое поле, где вы можете вставить ссылку на ваш публичный Subversion проект (см. рис. 4-9).

If you have an existing public Subversion project that you want to import into Git, GitHub can often do that for you. At the bottom of the instructions page is a link to a Subversion import. If you click it, you see a form with information about the import process and a text box where you can paste in the URL of your public Subversion project (see Figure 4-9).

Insert 18333fig0409.png 
Рисунок 4-9. Интерфейс импорта из Subversion.

Если ваш проект очень большой, нестандартный или приватный, этот процесс, возможно, не сработает для вас. В главе 7 вы узнаете, как делать более сложные импорты вручную.

If your project is very large, nonstandard, or private, this process probably won’t work for you. In Chapter 7, you’ll learn how to do more complicated manual project imports.

### Добавление участников ###

Давайте добавим остальную команду. Если Джон, Жоси и Джессика зарегистрированы на GitHub, и вы хотите дать им доступ на отправку в ваш репозиторий, вы можете добавить их к вашему проекту как участников. Это позволит им отправлять с использованием их приватных ключей.

Let’s add the rest of the team. If John, Josie, and Jessica all sign up for accounts on GitHub, and you want to give them push access to your repository, you can add them to your project as collaborators. Doing so will allow pushes from their public keys to work.

Нажмите на кнопке "Редактировать" в заголовке проекта или вкладку "Администратор" вверху чтобы попасть на страницу администратора вашего GitHub проекта (см. рис. 4-10).

Click the "edit" button in the project header or the Admin tab at the top of the project to reach the Admin page of your GitHub project (see Figure 4-10).

Insert 18333fig0410.png 
Рисунок 4-10. Страница администратора GitHub.

Чтобы дать другому пользователю доступ на запись в ваш проект, кликните по ссылке “Добавить другого участника”. Появится новое текстовое поле, в котором вы можете набрать имя пользователя. По мере набора всплывёт подсказка, показывая вам возможные совпадения имён. Когда вы найдёте нужного пользователя, нажмите на кнопке Добавить чтобы добавить пользователя как участника вашего проекта (см. рис. 4-11).

To give another user write access to your project, click the “Add another collaborator” link. A new text box appears, into which you can type a username. As you type, a helper pops up, showing you possible username matches. When you find the correct user, click the Add button to add that user as a collaborator on your project (see Figure 4-11).

Insert 18333fig0411.png 
Рисунок 4-11. Добавление участника в ваш проект.

Когда вы закончите добавлять участников, вы должны увидеть их список в разделе Участники (см. рис. 4-12).

When you’re finished adding collaborators, you should see a list of them in the Repository Collaborators box (see Figure 4-12).

Insert 18333fig0412.png 
Рисунок 4-12. Список участников вашего проекта.

Если вам нужно отозвать доступ, вы можете кликнуть на ссылке "отозвать", и их доступ на отправку будет удалён. Для будущих проектов вы можете также скопировать группы участников копируя разрешения существующего проекта.

If you need to revoke access to individuals, you can click the "revoke" link, and their push access will be removed. For future projects, you can also copy collaborator groups by copying the permissions of an existing project.

### Ваш проект ###

После того как вы отправили ваш проект или импортировали его из Subversion, у вас есть главная страница проекта, которая выглядит как на рис. 4-13.

After you push your project up or have it imported from Subversion, you have a main project page that looks something like Figure 4-13.

Insert 18333fig0413.png 
Рисунок 4-13. Главная страница проекта на GitHub.

Когда люди посещают ваш проект, они видят эту страницу. Она содержит вкладки по различным аспектам вашего проекта. Вкладка Коммиты показывает список коммитов в обратном хронологическом порядке, похоже на вывод команды `git log`. Вкладка Сеть показывает всех людей отделивших ваш проект и возвративших свои наработки. Вкладка Файлы позволит вам выложить бинарные файлы проекта и ссылки на архивы любых помеченных точек вашего проекта. Вкладка Вики предоставляет вики, где вы можете писать документацию или другую информацию о вашем проекте. Вкладка Графики показывает некоторую информацию о вкладе участников и статистику о вашем проекте. Главная вкладка Исходный код показывает листинг коневой директории проекта и автоматически отрисовывает README файл под ней, если он у вас есть. Эта вкладка также показывает информацию о последнем коммите.

When people visit your project, they see this page. It contains tabs to different aspects of your projects. The Commits tab shows a list of commits in reverse chronological order, similar to the output of the `git log` command. The Network tab shows all the people who have forked your project and contributed back. The Downloads tab allows you to upload project binaries and link to tarballs and zipped versions of any tagged points in your project. The Wiki tab provides a wiki where you can write documentation or other information about your project. The Graphs tab has some contribution visualizations and statistics about your project. The main Source tab that you land on shows your project’s main directory listing and automatically renders the README file below it if you have one. This tab also shows a box with the latest commit information.

### Ответвления проектов ###

Если вы хотите внести вклад в существующий проект, в который у вас нет права на отправку, GitHub приветствует ответвления. Когда вы смотрите на страницу проекта, который выглядит интересно и вы не прочь немного поработать над ним, вы можете нажать на кнопку Форк в заголовке проекта, чтобы GitHub скопировал проект вашему пользователю, чтобы вы могли отправлять туда.

If you want to contribute to an existing project to which you don’t have push access, GitHub encourages forking the project. When you land on a project page that looks interesting and you want to hack on it a bit, you can click the "fork" button in the project header to have GitHub copy that project to your user so you can push to it.

Таким образом, проектам не нужно беспокоиться о добавлении пользователей как участников для предоставления им доступа на отправку. Люди могут ответвить проект и отправить в него, хранитель главного проекта может вернуть эти изменения, добавив их как удалённые серверы и вливая их работу.

This way, projects don’t have to worry about adding users as collaborators to give them push access. People can fork a project and push to it, and the main project maintainer can pull in those changes by adding them as remotes and merging in their work.

Чтобы ответвить проект, посетите страницу проекта (в нашем случае mojombo/chronic) и нажмите на кнопку Форк в заголовке (см. рис. 4-14).

To fork a project, visit the project page (in this case, mojombo/chronic) and click the "fork" button in the header (see Figure 4-14).

Insert 18333fig0414.png 
Рисунок 4-14. Получение доступной для записи копии любого репозитория.

После нескольких секунд вы будете направлены на страницу вашего нового проекта, которая показывает, что данный проект является ответвлением другого (см. рис. 4-15).

After a few seconds, you’re taken to your new project page, which indicates that this project is a fork of another one (see Figure 4-15).

Insert 18333fig0415.png 
Рисунок 4-15. Вы ответвили проект.

### GitHub Summary ###

Это всё, что мы хотели бы рассказать про GitHub, но важно отметить, как быстро вы можете сделать всё это. Вы можете создать аккаунт, добавить новый проект и отправить в него за минуты.Если ваш проект с открытым кодом, вы также можете получить огромное сообщество разработчиков, кто может увидеть ваш проект и ответвить его и помочь, внеся в него свой вклад. И наконец, это может быть способ начать с Git и быстро попробовать его.

That’s all we’ll cover about GitHub, but it’s important to note how quickly you can do all this. You can create an account, add a new project, and push to it in a matter of minutes. If your project is open source, you also get a huge community of developers who now have visibility into your project and may well fork it and help contribute to it. At the very least, this may be a way to get up and running with Git and try it out quickly.

## Заключение ##

У вас есть несколько вариантов получения удалённого Git репозитория так, чтобы вы могли принимать участие в проекте вместе с другими или поделиться работой.

You have several options to get a remote Git repository up and running so that you can collaborate with others or share your work.

Запуск своего сервера даёт полный контроль и позволит вам запустить сервер в пределах вашего сетевого экрана, но такой сервер обычно требует некоторой части вашего времени на настройку и поддержку. Если вы разместите ваши данные на хостинге, его просто настроить и поддерживать; однако вы должны иметь возможность хранить код на чужом сервере, а некоторые организации этого не позволяют.

Running your own server gives you a lot of control and allows you to run the server within your own firewall, but such a server generally requires a fair amount of your time to set up and maintain. If you place your data on a hosted server, it’s easy to set up and maintain; however, you have to be able to keep your code on someone else’s servers, and some organizations don’t allow that.

Легко определить, какое решение или комбинация решений подойдёт вам и вашей организации.

It should be fairly straightforward to determine which solution or combination of solutions is appropriate for you and your organization.
