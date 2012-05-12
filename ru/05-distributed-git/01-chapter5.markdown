# Распределённый Git #
Distributed Git

Теперь, когда вы имеете настроенный удаленный Git-репозиторий, являющийся некоей точкой для разработчиков, где они могут обмениваться своим кодом, и вы знакомы с основными командами Git-а для локального рабочего процесса, вы узнаете как использовать некоторые распределенные рабочие процессы, которые вам предлагает Git.

Now that you have a remote Git repository set up as a point for all the developers to share their code, and you’re familiar with basic Git commands in a local workflow, you’ll look at how to utilize some of the distributed workflows that Git affords you.

В этой главе вы увидите, как работать с Git при распределенном окружении, являясь при этом автором, который вносит свои наработки, и являясь системным интегратором. То есть вы научитесь успешно вносить свой код в проект, делая это как можно более просто и для вас и для владельца проекта, и также научитесь тому, как содержать в исправности проект с некоторым числом разработчиков.  

In this chapter, you’ll see how to work with Git in a distributed environment as a contributor and an integrator. That is, you’ll learn how to contribute code successfully to a project and make it as easy on you and the project maintainer as possible, and also how to maintain a project successfully with a number of developers contributing.

## Распределенные рабочие процессы ##
## Distributed Workflows ##

В отличии от централизованных систем контроля версий, распределенная природа Git-а позволяет вам быть гораздо более гибким в отношении участия разработчика в работе над проектом. В централизованных системах, каждый разработчик является узлом сети, работающим в более или менее равной степени на центральном хабе. В Git, однако, каждый разработчик потенциально является и узлом и хабом (концентратором) — то есть каждый разработчик может и вносить код в другие репозитории и содержать публичный репозиторий, основываясь на котором могут работать другие разработчики и в который они могут вносить свои изменения. Это открывает широкие возможности по ведению рабочего процесса для вас и/или для вашей команды, так что я рассмотрю несколько распространенных парадигм, которые используют преимущества такой гибкости. Я рассмотрю сильные стороны и возможные слабые места каждой из моделей; вы можете выбрать одну из них, а можете сочетать и совмещать особенности каждой.

Unlike Centralized Version Control Systems (CVCSs), the distributed nature of Git allows you to be far more flexible in how developers collaborate on projects. In centralized systems, every developer is a node working more or less equally on a central hub. In Git, however, every developer is potentially both a node and a hub — that is, every developer can both contribute code to other repositories and maintain a public repository on which others can base their work and which they can contribute to. This opens a vast range of workflow possibilities for your project and/or your team, so I’ll cover a few common paradigms that take advantage of this flexibility. I’ll go over the strengths and possible weaknesses of each design; you can choose a single one to use, or you can mix and match features from each.

### Централизованный рабочий процесс ###
### Centralized Workflow ###

В централизованных системах существует, как правило, одна модель совместной разработки — централизованный рабочий процесс. Один центральный хаб, или репозиторий, может принимать код, а все остальные синхронизируют свою работу с ним. Некоторое число разработчиков являются узлами — клиентами этого хаба — и синхронизируются с одним этим хабом (смотри Рисунок 5-1).

In centralized systems, there is generally a single collaboration model—the centralized workflow. One central hub, or repository, can accept code, and everyone synchronizes their work to it. A number of developers are nodes — consumers of that hub — and synchronize to that one place (see Figure 5-1).

Insert 18333fig0501.png
Рисунок 5-1. Централизованный рабочий процесс.

Figure 5-1. Centralized workflow.

Это значит, что если два разработчика выполняют клонирование с хаба и оба делают изменения в проекте, то первый из них, кто выкладывает свои изменения обратно на хаб, сделает это без проблем. Второй разработчик должен взять наработки первого и выполнить слияние до того, как начнет выкладывать свои изменения, так чтобы не перезаписать изменения первого разработчика. Эта концепция также применима в Git как и в Subversion (или любой другой CVCS), и в Git такая модель работает отлично.

This means that if two developers clone from the hub and both make changes, the first developer to push their changes back up can do so with no problems. The second developer must merge in the first one’s work before pushing changes up, so as not to overwrite the first developer’s changes. This concept is true in Git as it is in Subversion (or any CVCS), and this model works perfectly in Git.

Если вы имеете небольшую команду или уже комфортно чувствуете себя при применении централизованного рабочего процесса в вашей компании или команде, вы можете запросто продолжить использовать такой рабочий процесс в Git. Просто настройте один репозиторий и дайте каждому в вашей команде право записи (push access); Git не позволит пользователям перезаписывать наработки друг-друга. Если один разработчик выполняет клонирование, делает изменения, а затем пытается выложить эти изменения, в то время как другой разработчик уже успел выложить свои, сервер отклонит изменения этого разработчика. Ему будет сказано, что он пытается выложить изменения, для которых невозможно выполнить fast-forward и что надо сначала извлечь данные с сервера, выполнить слияние, а уже потом выкладывать свои изменения. Этот рабочий процесс привлекателен для большого количества людей, так как это та парадигма, с которой многие знакомы и которая многим понятна.

If you have a small team or are already comfortable with a centralized workflow in your company or team, you can easily continue using that workflow with Git. Simply set up a single repository, and give everyone on your team push access; Git won’t let users overwrite each other. If one developer clones, makes changes, and then tries to push their changes while another developer has pushed in the meantime, the server will reject that developer’s changes. They will be told that they’re trying to push non-fast-forward changes and that they won’t be able to do so until they fetch and merge. This workflow is attractive to a lot of people because it’s a paradigm that many are familiar and comfortable with.

### Рабочий процесс с менеджером по интеграции ###
### Integration-Manager Workflow ###

Так как Git позволяет вам иметь несколько удаленных репозиториев, существует возможность ведения рабочего процесса, когда каждый разработчик имеет право записи на свой собственный публичный репозиторий и право на чтение для всех остальных. Этот сценарий часто подразумевает существование канонического (основного) репозитория, который представляет "официальный" проект. Чтобы поучаствовать в этом проекте, вы создаете вашу собственную публичную копию этого проекта и выкладываете туда свои изменения. Потом вы можете отправить запрос владельцу основного проекта на внесение в него ваших изменений. Он может добавить ваш репозиторий как удаленный, протестировать локально ваши изменения, слить их со своей веткой и затем выложить обратно в публичный репозиторий. Этот процесс работает как описано далее (смотри Рисунок 5-2):

Because Git allows you to have multiple remote repositories, it’s possible to have a workflow where each developer has write access to their own public repository and read access to everyone else’s. This scenario often includes a canonical repository that represents the "official" project. To contribute to that project, you create your own public clone of the project and push your changes to it. Then, you can send a request to the maintainer of the main project to pull in your changes. They can add your repository as a remote, test your changes locally, merge them into their branch, and push back to their repository. The process works as follow (see Figure 5-2):

1.	Владелец проекта выкладывает информацию в публичный репозиторий.
2.	Участники проекта клонируют этот репозиторий и делают изменения.
3.	Участники выкладывают изменения в свои собственные публичные репозитории.
4.	Участник проекта отправляет владельцу на e-mail письмо с просьбой включения его изменений.
5.	Владелец проекта добавляет репозиторий участника как удаленный и локально выполняет слияние.
6.	Владелец выкладывает обновленный проект (с включенными изменениями) в основной репозиторий.

1.	The project maintainer pushes to their public repository.
2.	A contributor clones that repository and makes changes.
3.	The contributor pushes to their own public copy.
4.	The contributor sends the maintainer an e-mail asking them to pull changes.
5.	The maintainer adds the contributor’s repo as a remote and merges locally.
6.	The maintainer pushes merged changes to the main repository.

Insert 18333fig0502.png 
Рисунок 5-2. Рабочий процесс с менеджером по интеграции.

Figure 5-2. Integration-manager workflow.

Это очень распространенный рабочий процесс для такого сайта, как GitHub, где можно легко сделать ответвление от проекта и выкладывать свои изменения в свою ветку, так чтобы все могли их видеть. Одно из главных преимуществ этого подхода — вы можете продолжать работать, а владелец главного репозитория может включать себе ваши изменения в любое время. Участники проекта не должны ждать, пока в проект будут включены их изменения — каждый может работать на своей собственной площадке.

This is a very common workflow with sites like GitHub, where it’s easy to fork a project and push your changes into your fork for everyone to see. One of the main advantages of this approach is that you can continue to work, and the maintainer of the main repository can pull in your changes at any time. Contributors don’t have to wait for the project to incorporate their changes — each party can work at their own pace.

### Рабочий процесс с диктатором и помощниками ###
### Dictator and Lieutenants Workflow ###

Это разновидность рабочего процесса с большим количеством репозиториев. В основном он используется в огромных проектах с сотнями участников; ядро Linux яркий тому пример. Разные менеджеры по интеграции управляют разными группами репозиториев; их называют помощниками. Все помощники имеют одного менеджера по интеграции, которого называют благосклонным диктатором. Репозиторий благосклонного диктатора служит как опорный репозиторий, откуда все участники проекта должны забирать изменения. Процесс работает, как показано здесь (смотри Рисунок 5-3):

This is a variant of a multiple-repository workflow. It’s generally used by huge projects with hundreds of collaborators; one famous example is the Linux kernel. Various integration managers are in charge of certain parts of the repository; they’re called lieutenants. All the lieutenants have one integration manager known as the benevolent dictator. The benevolent dictator’s repository serves as the reference repository from which all the collaborators need to pull. The process works like this (see Figure 5-3):

1.	Обычные разработчики работают над своими тематическими ветками и перемещают (rebase) свою работу на вершину ветки master. Ветка master это та ветка, которая есть у диктатора.
2.	Помощники выполняют слияние тематических веток разработчиков со своими ветками master.
3.	Диктатор выполняет слияние веток master своих помощников со своей веткой master.
4.	Диктатор выкладывает свою ветку master в основной репозиторий, так что другие разработчики могут выполнять перемещение на нее.

1.	Regular developers work on their topic branch and rebase their work on top of master. The master branch is that of the dictator.
2.	Lieutenants merge the developers’ topic branches into their master branch.
3.	The dictator merges the lieutenants’ master branches into the dictator’s master branch.
4.	The dictator pushes their master to the reference repository so the other developers can rebase on it.

Insert 18333fig0503.png
Рисунок 5-3. Рабочий процесс с благосклонным диктатором.
  
Figure 5-3. Benevolent dictator workflow.

Этот вид рабочего процесса не является распространенным, но может быть полезен в очень больших проектах или в сильно иерархическом окружении, так как он позволяет лидеру проекта (диктатору) передать полномочия по выполнению большой части работ  и собирать код большими группами со многих точек перед его интеграцией.

This kind of workflow isn’t common but can be useful in very big projects or in highly hierarchical environments, because as it allows the project leader (the dictator) to delegate much of the work and collect large subsets of code at multiple points before integrating them.

Это несколько широко применяемых рабочих процессов, которые доступны при работе с такой распределенной системой, как Git, но вы можете увидеть, что возможно множество их вариаций, чтобы удовлетворить требованиям вашего реального рабочего процесса. Теперь, когда вы можете (я надеюсь) определить, какая комбинация рабочих процессов может послужить вам, я рассмотрю некоторые более специфичные примеры выполнения основных действий, являющихся частью разных процессов.

These are some commonly used workflows that are possible with a distributed system like Git, but you can see that many variations are possible to suit your particular real-world workflow. Now that you can (I hope) determine which workflow combination may work for you, I’ll cover some more specific examples of how to accomplish the main roles that make up the different flows.

## Содействие проекту ##
## Contributing to a Project ##

Вы знаете различные рабочие процессы, также у вас должно быть достаточно хорошее понимание основ использования Git. В этом разделе вы узнаете о нескольких типичных способах содействия проекту.

You know what the different workflows are, and you should have a pretty good grasp of fundamental Git usage. In this section, you’ll learn about a few common patterns for contributing to a project.

Главная трудность в описании этого процесса в том, что существует огромное количество вариаций того, как это устроено. Поскольку Git очень гибок, люди могут делать совместную работу многими способами, и проблематично описать, как вы должны содействовать проекту - каждый проект немного отличается. Некоторые из вовлечённых переменных это количество активных участников, выбранный рабочий процесс, ваш доступ к внесению изменений, и, возможно, внешний способ сотрудничества.

The main difficulty with describing this process is that there are a huge number of variations on how it’s done. Because Git is very flexible, people can and do work together many ways, and it’s problematic to describe how you should contribute to a project — every project is a bit different. Some of the variables involved are active contributor size, chosen workflow, your commit access, and possibly the external contribution method.

Первая переменная это количество активных участников. Как много пользователей активно вносят свой вклад в проект и как часто? Во многих случаях это два-три разработчика с несколькими коммитами в день, возможно, меньше, для вялотекущих проектов. В по-настоящему больших компаниях или проектах число разработчиков может измеряться тысячами, с десятками или даже сотнями ежедневно поступающих патчей. Это важно, поскольку с увеличением числа разработчиков вам становится труднее убедиться, что ваш код ляжет чисто или может быть легко влит. Изменения, которые вы отправляете, могут оказаться устаревшими или частично сломанными той работой, которая была влита пока вы работали или пока ваши изменения ожидали утверждения или применения. Как вы можете сохранять ваш код согласованным и ваши патчи верными?

The first variable is active contributor size. How many users are actively contributing code to this project, and how often? In many instances, you’ll have two or three developers with a few commits a day, or possibly less for somewhat dormant projects. For really large companies or projects, the number of developers could be in the thousands, with dozens or even hundreds of patches coming in each day. This is important because with more and more developers, you run into more issues with making sure your code applies cleanly or can be easily merged. Changes you submit may be rendered obsolete or severely broken by work that is merged in while you were working or while your changes were waiting to be approved or applied. How can you keep your code consistently up to date and your patches valid?

Следующая переменная это рабочий процесс, используемый в проекте. Он централизован, и каждый разработчик имеет равные права на запись в главное хранилище? Есть у проекта хранитель или менеджер по интеграции кто проверяет патчи? Проверяются ли все патчи другими и утверждаются ли? Вы вовлечены в этот процесс? Присутствует ли система помощников и должны ли вы сначала отправлять свою работу им?

The next variable is the workflow in use for the project. Is it centralized, with each developer having equal write access to the main codeline? Does the project have a maintainer or integration manager who checks all the patches? Are all the patches peer-reviewed and approved? Are you involved in that process? Is a lieutenant system in place, and do you have to submit your work to them first?

Следующая проблема это доступ на отправку изменений. Рабочий процесс, требуемый для внесения вклада в проект сильно отличается в зависимости от того, имеете ли вы доступ на запись или нет. Если у вас нету доступа на запись, как в проекте принято принимать вклад в работу? Вообще, существует ли какая-либо политика? Как много работы вы вкладываете за раз? Как часто вы это делаете?

The next issue is your commit access. The workflow required in order to contribute to a project is much different if you have write access to the project than if you don’t. If you don’t have write access, how does the project prefer to accept contributed work? Does it even have a policy? How much work are you contributing at a time? How often do you contribute?

Все эти вопросы могу повлиять на то, как эффективно вы будете вносить вклад в проект и какой рабочий процесс предпочтителен или доступен вам. Я расскажу об аспектах каждого из них в серии примеров использования, продвигаясь от простых к более сложным; вы сможете создать специфический рабочий процесс, нужный вам, из этих примеров.

All these questions can affect how you contribute effectively to a project and what workflows are preferred or available to you. I’ll cover aspects of each of these in a series of use cases, moving from simple to more complex; you should be able to construct the specific workflows you need in practice from these examples.

### Руководства по созданию коммитов ###

### Commit Guidelines ###

Прежде чем рассматривать специфичные примеры использования, вот короткая заметка о сообщениях к коммиту. Обладание хорошим руководством по созданию коммитов и следование ему делает работу с Git'ом и сотрудничество с другими намного проще. Проект Git предоставляет документ с хорошими советами по созданию коммитов, из которых можно делать патчи — вы можете прочитать его в исходном коде Git в файле `Documentation/SubmittingPatches`.

Before you start looking at the specific use cases, here’s a quick note about commit messages. Having a good guideline for creating commits and sticking to it makes working with Git and collaborating with others a lot easier. The Git project provides a document that lays out a number of good tips for creating commits from which to submit patches — you can read it in the Git source code in the `Documentation/SubmittingPatches` file.

Во-первых, не отсылайте никаких ошибочных пробелов. Git предоставляет простой способ проверки — перед коммитом, запустите `git diff --check`, это определит возможные проблемы и перечислит их вам. Вот пример, в котором я заменил красный цвет терминала символами `X`:

First, you don’t want to submit any whitespace errors. Git provides an easy way to check for this — before you commit, run `git diff --check`, which identifies possible whitespace errors and lists them for you. Here is an example, where I’ve replaced a red terminal color with `X`s:

	$ git diff --check
	lib/simplegit.rb:5: trailing whitespace.
	+    @git_dir = File.expand_path(git_dir)XX
	lib/simplegit.rb:7: trailing whitespace.
	+ XXXXXXXXXXX
	lib/simplegit.rb:26: trailing whitespace.
	+    def command(git_cmd)XXXX

Если вы запустите эту команду перед коммитом, вы сможете сказать, собираетесь ли вы отправить коммит с проблемными пробелами, что может раздражать других разработчиков.

If you run that command before committing, you can tell if you’re about to commit whitespace issues that may annoy other developers.

Затем, старайтесь делать каждый коммит логически отдельным набором изменений. Если можете, старайтесь делать ваши изменения обозримыми — не надо программировать все выходные или работать над пятью проблемами и затем отправлять их все массивным коммитом в понедельник. Даже если вы не коммитили в течение выходных, используйте индекс для разбиения вашей работы как минимум на один коммит для каждой проблемы, с полезным сообщением к каждому. Если некоторые из изменений затрагивают один и тот же файл, попробуйте использовать `git add --patch` чтобы частично проиндексировать файлы (рассмотрено в деталях в Главе 6). Слепок проекта на кончике ветки будет идентичным, сделаете ли вы пять коммитов или один, покуда все ваши изменения будут добавлены в какой-то момент, так что попытайтесь облегчить жизнь вашим коллегам разработчикам, когда они должны будут сделать ревю вашим изменениям.

Next, try to make each commit a logically separate changeset. If you can, try to make your changes digestible — don’t code for a whole weekend on five different issues and then submit them all as one massive commit on Monday. Even if you don’t commit during the weekend, use the staging area on Monday to split your work into at least one commit per issue, with a useful message per commit. If some of the changes modify the same file, try to use `git add --patch` to partially stage files (covered in detail in Chapter 6). The project snapshot at the tip of the branch is identical whether you do one commit or five, as long as all the changes are added at some point, so try to make things easier on your fellow developers when they have to review your changes. This approach also makes it easier to pull out or revert one of the changesets if you need to later. Chapter 6 describes a number of useful Git tricks for rewriting history and interactively staging files — use these tools to help craft a clean and understandable history.

Последняя вещь, которую стоит иметь в виду это сообщение коммита. Хорошая привычка создания качественных сообщений коммита делает использование и сотрудничество посредством Git гораздо проще. По общему правилу, ваши сообщения должны начинаться с единственной строки не длиннее 50 символов, лаконично описывающей набор изменений, затем пустая строка, затем более детальное описание. Проект Git требует, чтобы более детально объяснение включало вашу мотивацию на изменения и противопоставляло эту реализацию с предыдущим поведением — хорошее руководство к действию. Также хорошая идея использование  ??? 

The last thing to keep in mind is the commit message. Getting in the habit of creating quality commit messages makes using and collaborating with Git a lot easier. As a general rule, your messages should start with a single line that’s no more than about 50 characters and that describes the changeset concisely, followed by a blank line, followed by a more detailed explanation. The Git project requires that the more detailed explanation include your motivation for the change and contrast its implementation with previous behavior — this is a good guideline to follow. It’s also a good idea to use the imperative present tense in these messages. In other words, use commands. Instead of "I added tests for" or "Adding tests for," use "Add tests for."

Вот шаблон, изначально написанный Tim Pope на tpope.net:

    Краткое (50 символов и менее) описание изменений

    Более детальное объяснение, если необходимо. Перенос на 72 символе
    или около того. В некоторых контекстах, первая строка считается
    как тема письма, а остальное телом. Пустая строка, отделяющая сводку
    от тела важна (если вы не опустили тело целиком); инструменты, такие
    как rebase, могут воспринять неправильно, если вы оставите их вместе.

    Дальнейшие параграфы идут после пустых строк

     - также можно применять маркеры списков

     - обычно дефис или звёздочка используются как маркер списка, с
       одним пробелом перед и пустой строкой после каждого пункта, но
       соглашения могут разниться

Here is a template originally written by Tim Pope at tpope.net:

	Short (50 chars or less) summary of changes

	More detailed explanatory text, if necessary.  Wrap it to about 72
	characters or so.  In some contexts, the first line is treated as the
	subject of an email and the rest of the text as the body.  The blank
	line separating the summary from the body is critical (unless you omit
	the body entirely); tools like rebase can get confused if you run the
	two together.

	Further paragraphs come after blank lines.

	 - Bullet points are okay, too

	 - Typically a hyphen or asterisk is used for the bullet, preceded by a
	   single space, with blank lines in between, but conventions vary here

Если все ваши сообщения о коммитах будут выглядеть как это, всё будет намного проще для вас и для разработчиков с которыми вы работаете. Проект Git содержит хорошо отформатированные сообщения о коммитах - я советую вам запустить `git log --no-merges` там, чтобы вы увидели, как красиво может выглядеть хорошо отформатированная история коммитов проекта.

If all your commit messages look like this, things will be a lot easier for you and the developers you work with. The Git project has well-formatted commit messages — I encourage you to run `git log --no-merges` there to see what a nicely formatted project-commit history looks like.

В последующих примерах и в большей части книги для краткости я не форматирую сообщения так красиво, как это; вместо этого я использую опцию `-m` команды `git commit`. Делайте как я говорю, а не как я делаю.

In the following examples, and throughout most of this book, for the sake of brevity I don’t format messages nicely like this; instead, I use the `-m` option to `git commit`. Do as I say, not as I do.

### Отдельная маленькая команда ###

### Private Small Team ###

Наиболее простая задача, с которой вы легко можете столкнуться — отдельный проект с одним или двумя другими разработчиками. Под термином отдельный я подразумеваю закрытый код, недоступный для чтения остальному миру. Вы, вместе с другими разработчиками, имеете право записи в репозиторий.

The simplest setup you’re likely to encounter is a private project with one or two other developers. By private, I mean closed source — not read-accessible to the outside world. You and the other developers all have push access to the repository.

В этом окружении вы можете последовать рабочему процессу, похожему на тот, который вы использовали бы в Subversion или другой централизованной системе. Вы по-прежнему получаете такие преимущества, как локальные коммиты (коммиты в offline) и возможность гораздо более простого ветвления и слияния, но сам рабочий процесс может оставаться очень похожим; главное отличие — во время выполнения коммита слияние происходит на стороне клиента, а не на сервере.
Давайте посмотрим, как это может выглядеть, когда два разработчика начинают работать вместе с общим репозиторием. Первый разработчик, Джон, клонирует репозиторий, делает изменения, выполняет локальный коммит. (Я заменяю служебные сообщения знаком `...` в этих примерах, чтобы немного их сократить.)

In this environment, you can follow a workflow similar to what you might do when using Subversion or another centralized system. You still get the advantages of things like offline committing and vastly simpler branching and merging, but the workflow can be very similar; the main difference is that merges happen client-side rather than on the server at commit time.
Let’s see what it might look like when two developers start to work together with a shared repository. The first developer, John, clones the repository, makes a change, and commits locally. (I’m replacing the protocol messages with `...` in these examples to shorten them somewhat.)

	# John's Machine
	$ git clone john@githost:simplegit.git
	Initialized empty Git repository in /home/john/simplegit/.git/
	...
	$ cd simplegit/
	$ vim lib/simplegit.rb 
	$ git commit -am 'removed invalid default value'
	[master 738ee87] removed invalid default value
	 1 files changed, 1 insertions(+), 1 deletions(-)

Второй разработчик, Джессика, выполняет тоже самое — клонирует репозиторий и делает коммит с изменениями:

The second developer, Jessica, does the same thing — clones the repository and commits a change:

	# Jessica's Machine
	$ git clone jessica@githost:simplegit.git
	Initialized empty Git repository in /home/jessica/simplegit/.git/
	...
	$ cd simplegit/
	$ vim TODO 
	$ git commit -am 'add reset task'
	[master fbff5bc] add reset task
	 1 files changed, 1 insertions(+), 0 deletions(-)

Теперь Джессика выкладывает свою работу на сервер:

Now, Jessica pushes her work up to the server:

	# Jessica's Machine
	$ git push origin master
	...
	To jessica@githost:simplegit.git
	   1edee6b..fbff5bc  master -> master

Джон также пытается выложить свои изменения:

John tries to push his change up, too:

	# John's Machine
	$ git push origin master
	To john@githost:simplegit.git
	 ! [rejected]        master -> master (non-fast forward)
	error: failed to push some refs to 'john@githost:simplegit.git'

Джон не может выполнить отправку изменений, так как за это время Джессика уже отправила свои. Очень важно это понимать, если вы использовали Subversion, так как вы видите, что два разработчика не редактировали один и тот же файл. Хотя Subversion и выполняет автоматическое слияние на сервере, если были отредактированы разные файлы, используя Git вы должны слить коммиты локально. Прежде чем Джон сможет отправить свои изменения на сервер, он должен извлечь наработки Джессики и выполнить слияние:

John isn’t allowed to push because Jessica has pushed in the meantime. This is especially important to understand if you’re used to Subversion, because you’ll notice that the two developers didn’t edit the same file. Although Subversion automatically does such a merge on the server if different files are edited, in Git you must merge the commits locally. John has to fetch Jessica’s changes and merge them in before he will be allowed to push:

	$ git fetch origin
	...
	From john@githost:simplegit
	 + 049d078...fbff5bc master     -> origin/master

На этот момент, локальный репозиторий Джона выглядит так, как показано на Рисунке 5-4.

At this point, John’s local repository looks something like Figure 5-4.

Insert 18333fig0504.png
Рисунок 5-4. Начальный репозиторий Джона.
 
Figure 5-4. John’s initial repository.

Джон имеет ссылку на изменения, выложенные Джессикой, и он должен слить их вместе со своей работой до того, как сможет отправить ее на сервер:

John has a reference to the changes Jessica pushed up, but he has to merge them into his own work before he is allowed to push:

	$ git merge origin/master
	Merge made by recursive.
	 TODO |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Слияние происходит без проблем — история коммитов Джона теперь выглядит как на Рисунке 5-5.

The merge goes smoothly — John’s commit history now looks like Figure 5-5.

Insert 18333fig0505.png
Рисунок 5-5. Репозиторий Джона после слияния с версией origin/master.
 
Figure 5-5. John’s repository after merging origin/master.

Теперь Джон может протестировать его код, дабы удостовериться, что он по-прежнему работает нормально, а затем выложить свою работу, уже объединенную с работой Джессики, на сервер:

Now, John can test his code to make sure it still works properly, and then he can push his new merged work up to the server:

	$ git push origin master
	...
	To john@githost:simplegit.git
	   fbff5bc..72bbc59  master -> master

В результате, история коммитов Джона выглядит как на Рисунке 5-6.

Finally, John’s commit history looks like Figure 5-6.

Insert 18333fig0506.png 
Рисунок 5-6. История коммитов Джона после отправки изменений на сервер.

Figure 5-6. John’s history after pushing to the origin server.

Тем временем, Джессика работала над тематической веткой. Она создала тематическую ветку с названием `issue54` и сделала три коммита в этой ветке. Она еще не извлекала изменения Джонна, так что ее история коммитов выглядит как на Рисунке 5-7.

In the meantime, Jessica has been working on a topic branch. She’s created a topic branch called `issue54` and done three commits on that branch. She hasn’t fetched John’s changes yet, so her commit history looks like Figure 5-7.

Insert 18333fig0507.png 
Рисунок 5-7. Начальная история коммитов Джессики.

Figure 5-7. Jessica’s initial commit history.

Джессика хочет синхронизировать свою работу с Джоном, так что она извлекает изменения с сервера:

Jessica wants to sync up with John, so she fetches:

	# Jessica's Machine
	$ git fetch origin
	...
	From jessica@githost:simplegit
	   fbff5bc..72bbc59  master     -> origin/master

Эта команда извлекает наработки Джона, которые он успел выложить. История коммитов Джессики теперь выглядит как на Рисунке 5-8.

That pulls down the work John has pushed up in the meantime. Jessica’s history now looks like Figure 5-8.

Insert 18333fig0508.png
Рисунок 5-8. История коммитов Джессики после извлечения изменений Джона.
 
Figure 5-8. Jessica’s history after fetching John’s changes.

Джессика полагает, что ее тематическая ветка закончена, но она хочет узнать, как выполнить слияние своей работы, чтобы она могла выложить ее на сервер. Она выполняет команду `git log` чтобы выяснить это:

Jessica thinks her topic branch is ready, but she wants to know what she has to merge her work into so that she can push. She runs `git log` to find out:

	$ git log --no-merges origin/master ^issue54
	commit 738ee872852dfaa9d6634e0dea7a324040193016
	Author: John Smith <jsmith@example.com>
	Date:   Fri May 29 16:01:27 2009 -0700

	    removed invalid default value

Теперь Джессика может слить свою тематическую ветку с ее основной веткой, слить работу Джона (`origin/master`) с ее веткой `master` и, затем, отправить изменения на сервер. Сначала она переключается на свою основную ветку, чтобы объединить всю эту работу:

Now, Jessica can merge her topic work into her master branch, merge John’s work (`origin/master`) into her `master` branch, and then push back to the server again. First, she switches back to her master branch to integrate all this work:

	$ git checkout master
	Switched to branch "master"
	Your branch is behind 'origin/master' by 2 commits, and can be fast-forwarded.

Сначала она может слить ветку `origin/master` или `issue54` — обе они находятся выше в истории коммитов, так что не важно какой порядок слияния она выберет. Конечное состояние репозитория должно быть идентично независимо от того, какой порядок слияния она выбрала; только история коммитов будет немного разная. Сначала она выполняет слияние для ветки `issue54`:

She can merge either `origin/master` or `issue54` first — they’re both upstream, so the order doesn’t matter. The end snapshot should be identical no matter which order she chooses; only the history will be slightly different. She chooses to merge in `issue54` first:

	$ git merge issue54
	Updating fbff5bc..4af4298
	Fast forward
	 README           |    1 +
	 lib/simplegit.rb |    6 +++++-
	 2 files changed, 6 insertions(+), 1 deletions(-)

Никаких проблем не возникает; как вы видите, это был обычный fast-forward. Теперь Джессика выполняет слияние с работой Джона (`origin/master`):

No problems occur; as you can see it, was a simple fast-forward. Now Jessica merges in John’s work (`origin/master`):

	$ git merge origin/master
	Auto-merging lib/simplegit.rb
	Merge made by recursive.
	 lib/simplegit.rb |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)

Слияние проходит нормально, и теперь история коммитов Джессики выглядит как на Рисунке 5-9.

Everything merges cleanly, and Jessica’s history looks like Figure 5-9.

Insert 18333fig0509.png
Рисунок 5-9. История коммитов Джессики после слияния с изменениями Джона.
 
Figure 5-9. Jessica’s history after merging John’s changes.

Теперь указатель `origin/master` доступен из ветки `master` Джессики, так что она может спокойно выкладывать свои изменения (полагая, что Джон не выкладывал свои изменения в это время):

Now `origin/master` is reachable from Jessica’s `master` branch, so she should be able to successfully push (assuming John hasn’t pushed again in the meantime):

	$ git push origin master
	...
	To jessica@githost:simplegit.git
	   72bbc59..8059c15  master -> master

Каждый разработчик несколько раз выполнял коммиты и успешно сливал свою работу с работой другого; смотри Рисунок 5-10.

Each developer has committed a few times and merged each other’s work successfully; see Figure 5-10.

Insert 18333fig0510.png
Рисунок 5-10. История коммитов Джессики после отправки всех изменений обратно на сервер.
 
Figure 5-10. Jessica’s history after pushing all changes back to the server.

Это один из простейших рабочих процессов. Вы работаете некоторое время, преимущественно в тематической ветке, и, когда приходит время, сливаете ее в вашу ветку master. Когда вы готовы поделиться этой работой с другими, вы сливаете ее в вашу ветку master, извлекаете изменения из `origin/master` и выполняете слияние (если за это время произошли изменения), и, наконец, отправляете изменения в ветку `master` на сервер. Общая последовательность действий выглядит так, как показано на Рисунке 5-11.

That is one of the simplest workflows. You work for a while, generally in a topic branch, and merge into your master branch when it’s ready to be integrated. When you want to share that work, you merge it into your own master branch, then fetch and merge `origin/master` if it has changed, and finally push to the `master` branch on the server. The general sequence is something like that shown in Figure 5-11.

Insert 18333fig0511.png
Рисунок 5-11. Общая последовательность событий для простого рабочего процесса в Git'е с несколькими разработчиками.
 
Figure 5-11. General sequence of events for a simple multiple-developer Git workflow.

### Отдельная команда с менеджером ###

### Private Managed Team ###

В этом сценарии мы рассмотрим роли участников проекта, являющихся членами больших отдельных групп. Вы научитесь работе в окружении, где маленькие группы совместно работают над задачами, результаты деятельности которых, впоследствии, объединяется отдельной группой лиц.

In this next scenario, you’ll look at contributor roles in a larger private group. You’ll learn how to work in an environment where small groups collaborate on features and then those team-based contributions are integrated by another party.

Давайте представим, что Джон и Джессика работают вместе над одной задачей, в то время как Джессика и Джози работают над другой. В этом случае компания использует рабочий процесс с менеджером по интеграции, когда работа частных групп объединяется только определенными инженерами (обновление ветки `master` главного репозитория может осуществляться только этими инженерами). В этом случае вся работа выполняется в ветках отдельных команд разработчиков и, впоследствии, объединяется вместе менеджерами по интеграции.

Let’s say that John and Jessica are working together on one feature, while Jessica and Josie are working on a second. In this case, the company is using a type of integration-manager workflow where the work of the individual groups is integrated only by certain engineers, and the `master` branch of the main repo can be updated only by those engineers. In this scenario, all work is done in team-based branches and pulled together by the integrators later.

Давайте рассмотрим рабочий процесс Джессики, которая работает над двумя задачами и, таким образом, одновременно принимает участие в работе с двумя другими разработчиками. Полагая, что она уже имеет ее собственную копию репозитория, Джессика решает сначала взяться за задачу `featureA`. Для этого она создает новую ветку и выполняет на ней некоторую работу:

Let’s follow Jessica’s workflow as she works on her two features, collaborating in parallel with two different developers in this environment. Assuming she already has her repository cloned, she decides to work on `featureA` first. She creates a new branch for the feature and does some work on it there:

	# Jessica's Machine
	$ git checkout -b featureA
	Switched to a new branch "featureA"
	$ vim lib/simplegit.rb
	$ git commit -am 'add limit to log function'
	[featureA 3300904] add limit to log function
	 1 files changed, 1 insertions(+), 1 deletions(-)

На этом этапе ей требуется поделиться своей работой с Джоном, так что она отправляет коммиты, выполненные на ветке `featureA`, на сервер. Так как Джессика не имеет право на изменения ветки `master` на сервере — только менеджеры по интеграции могут делать это — она вынуждена отправлять изменения в другую ветку, чтобы иметь возможность работать вместе с Джоном:

At this point, she needs to share her work with John, so she pushes her `featureA` branch commits up to the server. Jessica doesn’t have push access to the `master` branch — only the integrators do — so she has to push to another branch in order to collaborate with John:

	$ git push origin featureA
	...
	To jessica@githost:simplegit.git
	 * [new branch]      featureA -> featureA

Джессика сообщает по электронной почте Джону, что она выложила некоторые наработки в ветку `featureA`, и что он может проверить их. Пока Джессика ждет ответа от Джона, она решает начать работу над веткой `featureB` вместе с Джози. Для начала она создает новую ветку для этой задачи, используя в качестве основы ветку `master` на сервере:

Jessica e-mails John to tell him that she’s pushed some work into a branch named `featureA` and he can look at it now. While she waits for feedback from John, Jessica decides to start working on `featureB` with Josie. To begin, she starts a new feature branch, basing it off the server’s `master` branch:

	# Jessica's Machine
	$ git fetch origin
	$ git checkout -b featureB origin/master
	Switched to a new branch "featureB"

Теперь Джессика выполняет пару коммитов в ветке `featureB`:

Now, Jessica makes a couple of commits on the `featureB` branch:

	$ vim lib/simplegit.rb
	$ git commit -am 'made the ls-tree function recursive'
	[featureB e5b0fdc] made the ls-tree function recursive
	 1 files changed, 1 insertions(+), 1 deletions(-)
	$ vim lib/simplegit.rb
	$ git commit -am 'add ls-files'
	[featureB 8512791] add ls-files
	 1 files changed, 5 insertions(+), 0 deletions(-)

Репозиторий Джессики выглядит как на Рисунке 5-12.

Jessica’s repository looks like Figure 5-12.

Insert 18333fig0512.png 
Рисунок 5-12. Начальная история коммитов Джессики.

Figure 5-12. Jessica’s initial commit history.

Джессика уже готова выложить на сервер свою работу, но получает сообщение от Джози, говорящее о том, что некоторые наработки уже были выложены на сервер в ветку `featureBee`. Поэтому Джессика должна сначала слить эти изменения со своими, прежде чем она сможет отправить свою работу на сервер. Она может извлечь изменения Джози командой `git fetch`:

She’s ready to push up her work, but gets an e-mail from Josie that a branch with some initial work on it was already pushed to the server as `featureBee`. Jessica first needs to merge those changes in with her own before she can push to the server. She can then fetch Josie’s changes down with `git fetch`:

	$ git fetch origin
	...
	From jessica@githost:simplegit
	 * [new branch]      featureBee -> origin/featureBee

Теперь Джессика может слить эти изменения со своими наработками командой `git merge`:

Jessica can now merge this into the work she did with `git merge`:

	$ git merge origin/featureBee
	Auto-merging lib/simplegit.rb
	Merge made by recursive.
	 lib/simplegit.rb |    4 ++++
	 1 files changed, 4 insertions(+), 0 deletions(-)

Есть небольшая проблема — ей нужно выложить изменения из ее ветки `featureB` в ветку `featureBee` на сервере. Она может сделать это при помощи команды `git push`, последовательно указывая название локальной и удаленной веток, разделенные знаком двоеточия:

There is a bit of a problem — she needs to push the merged work in her `featureB` branch to the `featureBee` branch on the server. She can do so by specifying the local branch followed by a colon (:) followed by the remote branch to the `git push` command:

	$ git push origin featureB:featureBee
	...
	To jessica@githost:simplegit.git
	   fba9af8..cd685d1  featureB -> featureBee

Это называется _refspec_. Смотри Главу 9, где более детально обсуждаются спецификации ссылок и различные вещи, которые вы можете делать с ними.

This is called a _refspec_. See Chapter 9 for a more detailed discussion of Git refspecs and different things you can do with them.

Далее, Джон сообщает Джессике по почте, что он добавил некоторые изменения в ветку `featureA` и просит ее проверить их. Она выполняет `git fetch` чтобы получить внесенные Джоном изменения:

Next, John e-mails Jessica to say he’s pushed some changes to the `featureA` branch and ask her to verify them. She runs a `git fetch` to pull down those changes:

	$ git fetch origin
	...
	From jessica@githost:simplegit
	   3300904..aad881d  featureA   -> origin/featureA

Затем, применяя команду `git log` она смотрит, что же было изменено:

Then, she can see what has been changed with `git log`:

	$ git log origin/featureA ^featureA
	commit aad881d154acdaeb2b6b18ea0e827ed8a6d671e6
	Author: John Smith <jsmith@example.com>
	Date:   Fri May 29 19:57:33 2009 -0700

	    changed log output to 30 from 25

Наконец, она сливает работу Джона в свою собственную ветку `featureA`:

Finally, she merges John’s work into her own `featureA` branch:

	$ git checkout featureA
	Switched to branch "featureA"
	$ git merge origin/featureA
	Updating 3300904..aad881d
	Fast forward
	 lib/simplegit.rb |   10 +++++++++-
	1 files changed, 9 insertions(+), 1 deletions(-)

Джессика хочет кое-что подправить, так что она опять делает коммит и затем выкладывает изменения на сервер:

Jessica wants to tweak something, so she commits again and then pushes this back up to the server:

	$ git commit -am 'small tweak'
	[featureA ed774b3] small tweak
	 1 files changed, 1 insertions(+), 1 deletions(-)
	$ git push origin featureA
	...
	To jessica@githost:simplegit.git
	   3300904..ed774b3  featureA -> featureA

История коммитов Джессики теперь выглядит так, как показано на Рисунке 5-13.

Jessica’s commit history now looks something like Figure 5-13.

Insert 18333fig0513.png 
Рисунок 5-13. История Джессики после внесения коммитов в ветку с решаемой задачей.

Figure 5-13. Jessica’s history after committing on a feature branch.

Джессика, Джози и Джон информируют менеджеров по интеграции, что ветки `featureA` и `featureBee` на сервере готовы к внесению в основную версию разработки. После того, как они внесут эти ветки в основную версию, извлечение данных с сервера (fetch) приведет к появлению новых коммитов слияния. Таким образом, история коммитов станет выглядеть как на Рисунке 5-14.

Jessica, Josie, and John inform the integrators that the `featureA` and `featureBee` branches on the server are ready for integration into the mainline. After they integrate these branches into the mainline, a fetch will bring down the new merge commits, making the commit history look like Figure 5-14. 

Insert 18333fig0514.png 
Рисунок 5-14. История коммитов Джессики после слияния двух тематических веток.

Figure 5-14. Jessica’s history after merging both her topic branches.

Множество групп переходят на Git именно из-за возможности работы нескольких команд в параллели с последующим объединением разных линий разработки. Огромное преимущество Git'а — возможность маленьких подгрупп большой команды работать вместе через удаленные ветки, не мешая при этом всей команде. Последовательность событий в рассмотренном здесь рабочем процессе представлена на Рисунке 5-15.

Many groups switch to Git because of this ability to have multiple teams working in parallel, merging the different lines of work late in the process. The ability of smaller subgroups of a team to collaborate via remote branches without necessarily having to involve or impede the entire team is a huge benefit of Git. The sequence for the workflow you saw here is something like Figure 5-15.

Insert 18333fig0515.png 
Рисунок 5-15. Основная последовательность действий для рабочего процесса в команде с менеджером по интеграции.

Figure 5-15. Basic sequence of this managed-team workflow.

### Небольшой открытый проект ###

### Public Small Project ###

Работа в открытом проекте является несколько иной задачей. Так как вы не имеете права на прямое изменение веток проекта, требуется некоторый другой путь для обмена наработками с мейнтейнерами. Первый пример описывает участие в проекте через разветвление (fork) на хосте Git'а, выполнять которое достаточно просто. Оба сайта, repo.or.cz и Github, поддерживают такую возможность, и большая часть мейнтейнеров проектов придерживаются такого способа содействия. В следующем разделе рассматриваются проекты, в которых патчи принимаются по e-mail.

Contributing to public projects is a bit different. Because you don’t have the permissions to directly update branches on the project, you have to get the work to the maintainers some other way. This first example describes contributing via forking on Git hosts that support easy forking. The repo.or.cz and GitHub hosting sites both support this, and many project maintainers expect this style of contribution. The next section deals with projects that prefer to accept contributed patches via e-mail.

Сначала вы скорее всего захотите клонировать основной репозиторий, создать тематическую ветку одного или нескольких патчей, которые вы собираетесь внести в проект, и выполнить здесь некоторую работу. Последовательность действий выглядит следующим образом:

First, you’ll probably want to clone the main repository, create a topic branch for the patch or patch series you’re planning to contribute, and do your work there. The sequence looks basically like this:

	$ git clone (url)
	$ cd project
	$ git checkout -b featureA
	$ (work)
	$ git commit
	$ (work)
	$ git commit

Возможно вы захотите использовать `rebase -i`, чтобы сжать ваши наработки в единый коммит, или таким образом реорганизовать наработки в коммитах, чтобы их было проще воспринимать мейнтейнерам проекта. Смотри Главу 6 для более детальной информации об интерактивном перемещении.

You may want to use `rebase -i` to squash your work down to a single commit, or rearrange the work in the commits to make the patch easier for the maintainer to review — see Chapter 6 for more information about interactive rebasing.

Когда вы закончили работу с веткой и готовы поделиться наработками с мейнтейнерами, перейдите на страницу исходного проекта и нажмите кнопку "Fork", создав таким образом вашу собственную ветвь проекта с правами записи в нее. Далее вы должны добавить URL этого нового репозитория в список удаленных репозиториев, назвав его, например как в этом случае, `myfork`:  

When your branch work is finished and you’re ready to contribute it back to the maintainers, go to the original project page and click the "Fork" button, creating your own writable fork of the project. You then need to add in this new repository URL as a second remote, in this case named `myfork`:

	$ git remote add myfork (url)

Свои наработки вы должны выкладывать в этот репозиторий. Гораздо проще добавить в ваш репозиторий ветку, над которой вы работаете, как удаленную, чем сливать ее в вашу ветку master и выкладывать. Это объясняется тем следующим образом — если ваша работа не принята или частично отобрана вы не должны перематывать вашу ветку master. Если мейнтейнеры выполняют слияние, перемещение или частично отбирают вашу работу, вы, в конечном счете, можете получить ее обратно скачивая (pulling) из их репозитория:

You need to push your work up to it. It’s easiest to push the remote branch you’re working on up to your repository, rather than merging into your master branch and pushing that up. The reason is that if the work isn’t accepted or is cherry picked, you don’t have to rewind your master branch. If the maintainers merge, rebase, or cherry-pick your work, you’ll eventually get it back via pulling from their repository anyhow:

	$ git push myfork featureA

Когда ваши наработки были отправлены в ваш репозиторий, вы должны уведомить мейнтейнера. Часто это называется запросом на включение (pull request) и вы можете либо сгенерировать его через сайт — на GitHub'е есть кнопка "pull request", автоматически уведомляющая мейнтейнера — либо выполнить команду `git request-pull` и вручную отправить ее вывод по почте мейнтейнеру.

When your work has been pushed up to your fork, you need to notify the maintainer. This is often called a pull request, and you can either generate it via the website — GitHub has a "pull request" button that automatically messages the maintainer — or run the `git request-pull` command and e-mail the output to the project maintainer manually.

Команда `request-pull` принимает в качестве аргумента название базовой ветки, в которую вы хотите включить вашу работу, и URL репозитория, из которого эти наработки могут быть получены. Команда выводит в список всех изменений, которые вы просите включить в проект. Например, если Джессика хочет послать Джону pull request когда она сделала пару коммитов в тематической ветке, которую она только что выложила, ей следует выполнить:

The `request-pull` command takes the base branch into which you want your topic branch pulled and the Git repository URL you want them to pull from, and outputs a summary of all the changes you’re asking to be pulled in. For instance, if Jessica wants to send John a pull request, and she’s done two commits on the topic branch she just pushed up, she can run this:

	$ git request-pull origin/master myfork
	The following changes since commit 1edee6b1d61823a2de3b09c160d7080b8d1b3a40:
	  John Smith (1):
	        added a new function

	are available in the git repository at:

	  git://githost/simplegit.git featureA

	Jessica Smith (2):
	      add limit to log function
	      change log output to 30 from 25

	 lib/simplegit.rb |   10 +++++++++-
	 1 files changed, 9 insertions(+), 1 deletions(-)

Вывод может быть отправлен мейнтейнеру — он содержит список коммитов, информацию о том, где начинается ветка с изменениями, указывает, откуда забрать эти изменения.

The output can be sent to the maintainer—it tells them where the work was branched from, summarizes the commits, and tells where to pull this work from.

Для проекта, мейнтейнером которого вы не являетесь, проще иметь ветку `master`, которая отслеживает ветку `origin/master`, и выполнять работу в тематических ветках, которые вы легко можете удалить, если они были отклонены. Если вы распределяете свои наработки по различным темам внутри тематических веток, вам проще выполнить перемещение своей работы, в случае если верхушка главного репозитория была передвинута за это время и ваши коммиты уже не получается применить без конфликтов. Например, если вы хотите выполнить работу по второй теме, не продолжайте работу внутри тематической ветки, которую вы только что отправили - начните снова с ветки `master` главного репозитория:

On a project for which you’re not the maintainer, it’s generally easier to have a branch like `master` always track `origin/master` and to do your work in topic branches that you can easily discard if they’re rejected.  Having work themes isolated into topic branches also makes it easier for you to rebase your work if the tip of the main repository has moved in the meantime and your commits no longer apply cleanly. For example, if you want to submit a second topic of work to the project, don’t continue working on the topic branch you just pushed up — start over from the main repository’s `master` branch:

	$ git checkout -b featureB origin/master
	$ (work)
	$ git commit
	$ git push myfork featureB
	$ (email maintainer)
	$ git fetch origin

Теперь каждая из ваших тем представляет собой нечто похожее на очередь из патчей, которую вы можете перезаписывать, перемещать, модифицировать без взаимного влияния одной на другую, как показано на Рисунке 5-16.

Now, each of your topics is contained within a silo — similar to a patch queue — that you can rewrite, rebase, and modify without the topics interfering or interdepending on each other as in Figure 5-16.

Insert 18333fig0516.png
Рисунок 5-16. Начальная история коммитов при работе в featureB.
 
Figure 5-16. Initial commit history with featureB work.

Давайте представим, что мейнтейнер проекта включил в основную версию группу патчей. Далее он попытается включить вашу первую ветку, но слияние уже не проходит гладко. В этом случае вы можете попробовать переместить эту ветку на верхушку ветки `origin/master`, разрешить конфликты для мейнтейнера и, затем, заново предложить ваши изменения:

Let’s say the project maintainer has pulled in a bunch of other patches and tried your first branch, but it no longer cleanly merges. In this case, you can try to rebase that branch on top of `origin/master`, resolve the conflicts for the maintainer, and then resubmit your changes:

	$ git checkout featureA
	$ git rebase origin/master
	$ git push -f myfork featureA

Это изменит вашу историю коммитов, и она станет выглядеть как на Рисунке 5-17.

This rewrites your history to now look like Figure 5-17.

Insert 18333fig0517.png 
Рисунок 5-17. История коммитов после работы в featureA.

Figure 5-17. Commit history after featureA work.

Так как вы переместили ветку, в команде push вы должны указать опцию `-f`, чтобы иметь возможность заменить ветку `featureA` на сервере. Есть альтернатива — выложить новую работу в другую ветку на сервере (возможно, назвав ее `featureAv2`).

Because you rebased the branch, you have to specify the `-f` to your push command in order to be able to replace the `featureA` branch on the server with a commit that isn’t a descendant of it. An alternative would be to push this new work to a different branch on the server (perhaps called `featureAv2`).

Давайте рассмотрим более возможный сценарий: мейнтейнер просмотрел на вашу работу во второй ветке и ему понравилась идея, но он хотел бы, чтобы вы изменили некоторые детали реализации. Также вы используете эту возможность для того, чтобы переместить вашу работу так, чтобы она базировалась на текущей версии ветки `master` проекта. Вы создадите новую ветку, базирующуюся на текущей ветке `origin/master`, сожмете изменения из ветки `featureB`, решите все конфликты, которые могут возникнуть, выполните требуемые изменения в реализации вашей идеи и, затем, выложите все это в виде новой ветки:

Let’s look at one more possible scenario: the maintainer has looked at work in your second branch and likes the concept but would like you to change an implementation detail. You’ll also take this opportunity to move the work to be based off the project’s current `master` branch. You start a new branch based off the current `origin/master` branch, squash the `featureB` changes there, resolve any conflicts, make the implementation change, and then push that up as a new branch:

	$ git checkout -b featureBv2 origin/master
	$ git merge --no-commit --squash featureB
	$ (change implementation)
	$ git commit
	$ git push myfork featureBv2

Опция `--squash` берет все работу на сливаемой ветке (featureB) и сжимает ее в non-merge коммит (коммит без слияния) на верхушку ветки, на которой вы сейчас находитесь. Опция `--no-commit` сообщает Git'у, что не нужно автоматически записывать коммит в историю. Это позволяет вам внести все изменения с другой ветки и, затем, сделать еще ряд изменений перед записыванием нового коммита.

The `--squash` option takes all the work on the merged branch and squashes it into one non-merge commit on top of the branch you’re on. The `--no-commit` option tells Git not to automatically record a commit. This allows you to introduce all the changes from another branch and then make more changes before recording the new commit.

Теперь вы можете отправить мейнтейнеру сообщение о том, что вы сделали требуемые изменения и они могут быть найдены в вашей ветке `featureBv2` (смотри Рисунок 5-18).

Now you can send the maintainer a message that you’ve made the requested changes and they can find those changes in your `featureBv2` branch (see Figure 5-18).

Insert 18333fig0518.png
Рисунок 5-18. История коммитов после работы на featureBv2.
 
Figure 5-18. Commit history after featureBv2 work.

### Большой открытый проект ###

### Public Large Project ###

Много более крупных проектов уже установили некоторый алгоритм принятия патчей — вам потребуется выяснять точные правила для каждого проекта, так как они будут отличаться. Однако, много крупных открытых проектов принимают патчи через список адресов разработчиков, так что сейчас мы рассмотрим пример такого приема.

Many larger projects have established procedures for accepting patches — you’ll need to check the specific rules for each project, because they will differ. However, many larger public projects accept patches via a developer mailing list, so I’ll go over an example of that now.

Рабочий процесс похож на описанный ранее — вы создаете тематическую ветку для каждой серии патчей, над которой вы работаете. Отличие состоит в процессе внесения этих изменений в проект. Вместо того, чтобы создавать ответвление от проекта (forking) и отправлять наработки в ваш собственный репозиторий (для которого вы имеете право записи), вы генерируете e-mail версию каждой серии коммитов и отправляете ее по списку адресов разработчиков:

The workflow is similar to the previous use case — you create topic branches for each patch series you work on. The difference is how you submit them to the project. Instead of forking the project and pushing to your own writable version, you generate e-mail versions of each commit series and e-mail them to the developer mailing list:

	$ git checkout -b topicA
	$ (work)
	$ git commit
	$ (work)
	$ git commit

Теперь у вас есть два коммита, которые вы хотите отправить по списку адресов. Вы используете команду `git format-patch`, чтобы сгенерировать файлы в формате mbox, которые вы можете отправить по почте по списку адресов. Эта команда превращает каждый коммит в электронное сообщение, темой которого является первая строка сообщения коммита, а оставшаяся часть сообщения коммита и патч, который он представляет, являются телом электронного сообщения. Хорошей особенностью является то, что применение патча из сгенерированного командой `format-patch` электронного сообщения сохраняет всю информацию о коммите. Вы увидите это в следующей части, когда будете применять эти коммиты:

Now you have two commits that you want to send to the mailing list. You use `git format-patch` to generate the mbox-formatted files that you can e-mail to the list — it turns each commit into an e-mail message with the first line of the commit message as the subject and the rest of the message plus the patch that the commit introduces as the body. The nice thing about this is that applying a patch from an e-mail generated with `format-patch` preserves all the commit information properly, as you’ll see more of in the next section when you apply these commits:

	$ git format-patch -M origin/master
	0001-add-limit-to-log-function.patch
	0002-changed-log-output-to-30-from-25.patch

Команда `format-patch` создает файлы с патчами и выводит их названия. Опция `-M` сообщает Git'у, что переименования нужно отслеживать. В итоге файлы выглядят так: 

The `format-patch` command prints out the names of the patch files it creates. The `-M` switch tells Git to look for renames. The files end up looking like this:

	$ cat 0001-add-limit-to-log-function.patch 
	From 330090432754092d704da8e76ca5c05c198e71a8 Mon Sep 17 00:00:00 2001
	From: Jessica Smith <jessica@example.com>
	Date: Sun, 6 Apr 2008 10:17:23 -0700
	Subject: [PATCH 1/2] add limit to log function

	Limit log functionality to the first 20

	---
	 lib/simplegit.rb |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)

	diff --git a/lib/simplegit.rb b/lib/simplegit.rb
	index 76f47bc..f9815f1 100644
	--- a/lib/simplegit.rb
	+++ b/lib/simplegit.rb
	@@ -14,7 +14,7 @@ class SimpleGit
	   end

	   def log(treeish = 'master')
	-    command("git log #{treeish}")
	+    command("git log -n 20 #{treeish}")
	   end

	   def ls_tree(treeish = 'master')
	-- 
	1.6.2.rc1.20.g8c5b.dirty

Вы также можете отредактировать эти файлы патчей, чтобы добавить в электронное сообщение некую информацию, которую вы не хотите показывать в сообщении коммита. Если вы добавляете текст между строкой `--` и началом патча (строка `lib/simplegit.rb`), то разработчик сможет ее прочитать, но в применении патча она участвовать не будет.

You can also edit these patch files to add more information for the e-mail list that you don’t want to show up in the commit message. If you add text between the `--` line and the beginning of the patch (the `lib/simplegit.rb` line), then developers can read it; but applying the patch excludes it.

Чтобы отправить эти файлы по списку адресов вы можете вставить файл в сообщение в вашем почтовом клиенте или отправить его через программу в командной строке. Вставка текста часто приводит к ошибкам форматирования, особенно в "умных" клиентах, которые не защищают символы перевода строки и пробельные символы. К счастью, Git предоставляет инструмент, позволяющий вам передавать через IMAP правильно отформатированные патчи. Для вас, применение этого инструмента может быть легче. Я покажу как отсылать патчи через Gmail, так как именно этот агент я и использую; вы можете прочесть подробные инструкции для большого числа почтовых программ в вышеупомянутом файле `Documentation/SubmittingPatches`, находящемся в исходном коде Git'а.

To e-mail this to a mailing list, you can either paste the file into your e-mail program or send it via a command-line program. Pasting the text often causes formatting issues, especially with "smarter" clients that don’t preserve newlines and other whitespace appropriately. Luckily, Git provides a tool to help you send properly formatted patches via IMAP, which may be easier for you. I’ll demonstrate how to send a patch via Gmail, which happens to be the e-mail agent I use; you can read detailed instructions for a number of mail programs at the end of the aforementioned `Documentation/SubmittingPatches` file in the Git source code.

Для начала вам следует внести секцию imap в файл `~/.gitconfig`. Вы можете добавлять каждое значение отдельно серией команд `git config`, или же добавить их все сразу вручную; но, в итоге, ваш файл конфигурации должен выглядеть примерно так:

First, you need to set up the imap section in your `~/.gitconfig` file. You can set each value separately with a series of `git config` commands, or you can add them manually; but in the end, your config file should look something like this:

	[imap]
	  folder = "[Gmail]/Drafts"
	  host = imaps://imap.gmail.com
	  user = user@gmail.com
	  pass = p4ssw0rd
	  port = 993
	  sslverify = false

Если ваш IMAP сервер не использует SSL, две последние строки могут отсутствовать, а параметр host примет значение `imap://` вместо `imaps://`. Когда необходимые параметры внесены в ваш файл конфигурации, вы можете использовать команду `git send-email` для перемещение серии патчей в папку Drafts на указанном IMAP сервере:

If your IMAP server doesn’t use SSL, the last two lines probably aren’t necessary, and the host value will be `imap://` instead of `imaps://`.
When that is set up, you can use `git send-email` to place the patch series in the Drafts folder of the specified IMAP server:

	$ git send-email *.patch
	0001-added-limit-to-log-function.patch
	0002-changed-log-output-to-30-from-25.patch
	Who should the emails appear to be from? [Jessica Smith <jessica@example.com>] 
	Emails will be sent from: Jessica Smith <jessica@example.com>
	Who should the emails be sent to? jessica@example.com
	Message-ID to be used as In-Reply-To for the first email? y

Затем Git выдает группу служебных сообщений, выглядящую примерно следующим образом, для каждого патча, который вы отсылаете: 

Then, Git spits out a bunch of log information looking something like this for each patch you’re sending:

	(mbox) Adding cc: Jessica Smith <jessica@example.com> from 
	  \line 'From: Jessica Smith <jessica@example.com>'
	OK. Log says:
	Sendmail: /usr/sbin/sendmail -i jessica@example.com
	From: Jessica Smith <jessica@example.com>
	To: jessica@example.com
	Subject: [PATCH 1/2] added limit to log function
	Date: Sat, 30 May 2009 13:29:15 -0700
	Message-Id: <1243715356-61726-1-git-send-email-jessica@example.com>
	X-Mailer: git-send-email 1.6.2.rc1.20.g8c5b.dirty
	In-Reply-To: <y>
	References: <y>

	Result: OK

Теперь вы должны иметь возможности перейти в вашу папку Drafts, заполнить поле 'To' в соответствии со списком адресов, по которым вы рассылаете патчи, указать, если нужно, адрес мейнтейнера или ответственного за эту секцию лица в поле 'CC', и отправить сообщение.

At this point, you should be able to go to your Drafts folder, change the To field to the mailing list you’re sending the patch to, possibly CC the maintainer or person responsible for that section, and send it off.

### Итоги ###

### Summary ###

В этом разделе был рассмотрен ряд общепринятых рабочих процессов, применяемых в нескольких непохожих друг на друга типах проектов (использующих Git), c которыми вы вероятно столкнетесь. Также здесь были представлены два новых инструмента, призванных помочь вам в организации этих процессов. Далее вы увидите рабочий процесс совсем с другой стороны: управление проектом в Git. Вы научитесь роли благосклонного диктатора или роли менеджера по интеграции.

This section has covered a number of common workflows for dealing with several very different types of Git projects you’re likely to encounter and introduced a couple of new tools to help you manage this process. Next, you’ll see how to work the other side of the coin: maintaining a Git project. You’ll learn how to be a benevolent dictator or integration manager.

## Управление проектом ##

## Maintaining a Project ##

В дополнении к тому, как эффективно работать над проектов, вам наверняка необходимо также знать как самому управлять им. Управление проектом может заключаться в принятии патчей, сгенерированных с помощью 'format-patch' и отправленных вам по почте или в интеграции изменений в ветки удаленных репозиториев. Неважно, управляете ли вы главным репозитарием проекта или хотите помочь с проверкой или включением патчей, вам необходимо выработать метод приема подобных патчей, который будет наиболее доступным для других участников и не будет изменяться вами в течении длительного срока.

In addition to knowing how to effectively contribute to a project, you’ll likely need to know how to maintain one. This can consist of accepting and applying patches generated via `format-patch` and e-mailed to you, or integrating changes in remote branches for repositories you’ve added as remotes to your project. Whether you maintain a canonical repository or want to help by verifying or approving patches, you need to know how to accept work in a way that is clearest for other contributors and sustainable by you over the long run.

### Работа с тематическими ветками ###

### Working in Topic Branches ###

Когда вы решаете интегрировать новую разработку хорошей идеей является опробовать разработку в тематической ветке - временной ветке, специально созданной для теста. Таким образом становится легко изменять код данной разработки, не затрагивая весь проект целиком(всегда можно приостановить разработку нового функционала и вернуться к ней позднее). Если вы выбираете простое имя для ветки, созданное на базе того, над чем вы именно работаете, например, 'ruby_client', или что-то аналогичное по описанию, то вы сможете легко вспомнить, зачем нужна данная ветка, если вдруг вам придется отложить работу над данным функционалом и вернуться к ней позднее. Управляющий проектом, как правило, создает ветки с указанием пространства имен - к примеру, 'sc/ruby_client', где 'sc' является, допустим, никнеймом автора вносимых изменений.
Как вы уже знаете, вы можете создать ветку, основанную на вашей главной ветке, следующим образом:

When you’re thinking of integrating new work, it’s generally a good idea to try it out in a topic branch — a temporary branch specifically made to try out that new work. This way, it’s easy to tweak a patch individually and leave it if it’s not working until you have time to come back to it. If you create a simple branch name based on the theme of the work you’re going to try, such as `ruby_client` or something similarly descriptive, you can easily remember it if you have to abandon it for a while and come back later. The maintainer of the Git project tends to namespace these branches as well — such as `sc/ruby_client`, where `sc` is short for the person who contributed the work. 
As you’ll remember, you can create the branch based off your master branch like this:

	$ git branch sc/ruby_client master

Или, если вы хотите немедленно переключиться на создаваемую ветку, вы можете использовать опцию `checkout -b`:

Or, if you want to also switch to it immediately, you can use the `checkout -b` option:

	$ git checkout -b sc/ruby_client master

Теперь вы готовы к тому, чтобы принять изменения в данную временную тематическую ветку и определить, хотите ли вы влить ее в ваши "более постоянные" ветки.

Now you’re ready to add your contributed work into this topic branch and determine if you want to merge it into your longer-term branches.

### Applying Patches from E-mail ###

If you receive a patch over e-mail that you need to integrate into your project, you need to apply the patch in your topic branch to evaluate it. There are two ways to apply an e-mailed patch: with `git apply` or with `git am`.

#### Applying a Patch with apply ####

If you received the patch from someone who generated it with the `git diff` or a Unix `diff` command, you can apply it with the `git apply` command. Assuming you saved the patch at `/tmp/patch-ruby-client.patch`, you can apply the patch like this:

	$ git apply /tmp/patch-ruby-client.patch

This modifies the files in your working directory. It’s almost identical to running a `patch -p1` command to apply the patch, although it’s more paranoid and accepts fewer fuzzy matches than patch. It also handles file adds, deletes, and renames if they’re described in the `git diff` format, which `patch` won’t do. Finally, `git apply` is an "apply all or abort all" model where either everything is applied or nothing is, whereas `patch` can partially apply patchfiles, leaving your working directory in a weird state. `git apply` is overall much more paranoid than `patch`. It won’t create a commit for you — after running it, you must stage and commit the changes introduced manually.

You can also use git apply to see if a patch applies cleanly before you try actually applying it — you can run `git apply --check` with the patch:

	$ git apply --check 0001-seeing-if-this-helps-the-gem.patch 
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply

If there is no output, then the patch should apply cleanly. This command also exits with a non-zero status if the check fails, so you can use it in scripts if you want.

#### Applying a Patch with am ####

If the contributor is a Git user and was good enough to use the `format-patch` command to generate their patch, then your job is easier because the patch contains author information and a commit message for you. If you can, encourage your contributors to use `format-patch` instead of `diff` to generate patches for you. You should only have to use `git apply` for legacy patches and things like that.

To apply a patch generated by `format-patch`, you use `git am`. Technically, `git am` is built to read an mbox file, which is a simple, plain-text format for storing one or more e-mail messages in one text file. It looks something like this:

	From 330090432754092d704da8e76ca5c05c198e71a8 Mon Sep 17 00:00:00 2001
	From: Jessica Smith <jessica@example.com>
	Date: Sun, 6 Apr 2008 10:17:23 -0700
	Subject: [PATCH 1/2] add limit to log function

	Limit log functionality to the first 20

This is the beginning of the output of the format-patch command that you saw in the previous section. This is also a valid mbox e-mail format. If someone has e-mailed you the patch properly using git send-email, and you download that into an mbox format, then you can point git am to that mbox file, and it will start applying all the patches it sees. If you run a mail client that can save several e-mails out in mbox format, you can save entire patch series into a file and then use git am to apply them one at a time. 

However, if someone uploaded a patch file generated via `format-patch` to a ticketing system or something similar, you can save the file locally and then pass that file saved on your disk to `git am` to apply it:

	$ git am 0001-limit-log-function.patch 
	Applying: add limit to log function

You can see that it applied cleanly and automatically created the new commit for you. The author information is taken from the e-mail’s `From` and `Date` headers, and the message of the commit is taken from the `Subject` and body (before the patch) of the e-mail. For example, if this patch was applied from the mbox example I just showed, the commit generated would look something like this:

	$ git log --pretty=fuller -1
	commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Author:     Jessica Smith <jessica@example.com>
	AuthorDate: Sun Apr 6 10:17:23 2008 -0700
	Commit:     Scott Chacon <schacon@gmail.com>
	CommitDate: Thu Apr 9 09:19:06 2009 -0700

	   add limit to log function

	   Limit log functionality to the first 20

The `Commit` information indicates the person who applied the patch and the time it was applied. The `Author` information is the individual who originally created the patch and when it was originally created. 

But it’s possible that the patch won’t apply cleanly. Perhaps your main branch has diverged too far from the branch the patch was built from, or the patch depends on another patch you haven’t applied yet. In that case, the `git am` process will fail and ask you what you want to do:

	$ git am 0001-seeing-if-this-helps-the-gem.patch 
	Applying: seeing if this helps the gem
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply
	Patch failed at 0001.
	When you have resolved this problem run "git am --resolved".
	If you would prefer to skip this patch, instead run "git am --skip".
	To restore the original branch and stop patching run "git am --abort".

This command puts conflict markers in any files it has issues with, much like a conflicted merge or rebase operation. You solve this issue much the same way — edit the file to resolve the conflict, stage the new file, and then run `git am --resolved` to continue to the next patch:

	$ (fix the file)
	$ git add ticgit.gemspec 
	$ git am --resolved
	Applying: seeing if this helps the gem

If you want Git to try a bit more intelligently to resolve the conflict, you can pass a `-3` option to it, which makes Git attempt a three-way merge. This option isn’t on by default because it doesn’t work if the commit the patch says it was based on isn’t in your repository. If you do have that commit — if the patch was based on a public commit — then the `-3` option is generally much smarter about applying a conflicting patch:

	$ git am -3 0001-seeing-if-this-helps-the-gem.patch 
	Applying: seeing if this helps the gem
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply
	Using index info to reconstruct a base tree...
	Falling back to patching base and 3-way merge...
	No changes -- Patch already applied.

In this case, I was trying to apply a patch I had already applied. Without the `-3` option, it looks like a conflict.

If you’re applying a number of patches from an mbox, you can also run the `am` command in interactive mode, which stops at each patch it finds and asks if you want to apply it:

	$ git am -3 -i mbox
	Commit Body is:
	--------------------------
	seeing if this helps the gem
	--------------------------
	Apply? [y]es/[n]o/[e]dit/[v]iew patch/[a]ccept all 

This is nice if you have a number of patches saved, because you can view the patch first if you don’t remember what it is, or not apply the patch if you’ve already done so.

When all the patches for your topic are applied and committed into your branch, you can choose whether and how to integrate them into a longer-running branch.

### Checking Out Remote Branches ###

If your contribution came from a Git user who set up their own repository, pushed a number of changes into it, and then sent you the URL to the repository and the name of the remote branch the changes are in, you can add them as a remote and do merges locally.

For instance, if Jessica sends you an e-mail saying that she has a great new feature in the `ruby-client` branch of her repository, you can test it by adding the remote and checking out that branch locally:

	$ git remote add jessica git://github.com/jessica/myproject.git
	$ git fetch jessica
	$ git checkout -b rubyclient jessica/ruby-client

If she e-mails you again later with another branch containing another great feature, you can fetch and check out because you already have the remote setup.

This is most useful if you’re working with a person consistently. If someone only has a single patch to contribute once in a while, then accepting it over e-mail may be less time consuming than requiring everyone to run their own server and having to continually add and remove remotes to get a few patches. You’re also unlikely to want to have hundreds of remotes, each for someone who contributes only a patch or two. However, scripts and hosted services may make this easier — it depends largely on how you develop and how your contributors develop.

The other advantage of this approach is that you get the history of the commits as well. Although you may have legitimate merge issues, you know where in your history their work is based; a proper three-way merge is the default rather than having to supply a `-3` and hope the patch was generated off a public commit to which you have access.

If you aren’t working with a person consistently but still want to pull from them in this way, you can provide the URL of the remote repository to the `git pull` command. This does a one-time pull and doesn’t save the URL as a remote reference:

	$ git pull git://github.com/onetimeguy/project.git
	From git://github.com/onetimeguy/project
	 * branch            HEAD       -> FETCH_HEAD
	Merge made by recursive.

### Determining What Is Introduced ###

Now you have a topic branch that contains contributed work. At this point, you can determine what you’d like to do with it. This section revisits a couple of commands so you can see how you can use them to review exactly what you’ll be introducing if you merge this into your main branch.

It’s often helpful to get a review of all the commits that are in this branch but that aren’t in your master branch. You can exclude commits in the master branch by adding the `--not` option before the branch name. For example, if your contributor sends you two patches and you create a branch called `contrib` and applied those patches there, you can run this:

	$ git log contrib --not master
	commit 5b6235bd297351589efc4d73316f0a68d484f118
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Oct 24 09:53:59 2008 -0700

	    seeing if this helps the gem

	commit 7482e0d16d04bea79d0dba8988cc78df655f16a0
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Mon Oct 22 19:38:36 2008 -0700

	    updated the gemspec to hopefully work better

To see what changes each commit introduces, remember that you can pass the `-p` option to `git log` and it will append the diff introduced to each commit.

To see a full diff of what would happen if you were to merge this topic branch with another branch, you may have to use a weird trick to get the correct results. You may think to run this:

	$ git diff master

This command gives you a diff, but it may be misleading. If your `master` branch has moved forward since you created the topic branch from it, then you’ll get seemingly strange results. This happens because Git directly compares the snapshots of the last commit of the topic branch you’re on and the snapshot of the last commit on the `master` branch. For example, if you’ve added a line in a file on the `master` branch, a direct comparison of the snapshots will look like the topic branch is going to remove that line.

If `master` is a direct ancestor of your topic branch, this isn’t a problem; but if the two histories have diverged, the diff will look like you’re adding all the new stuff in your topic branch and removing everything unique to the `master` branch.

What you really want to see are the changes added to the topic branch — the work you’ll introduce if you merge this branch with master. You do that by having Git compare the last commit on your topic branch with the first common ancestor it has with the master branch.

Technically, you can do that by explicitly figuring out the common ancestor and then running your diff on it:

	$ git merge-base contrib master
	36c7dba2c95e6bbb78dfa822519ecfec6e1ca649
	$ git diff 36c7db 

However, that isn’t convenient, so Git provides another shorthand for doing the same thing: the triple-dot syntax. In the context of the `diff` command, you can put three periods after another branch to do a `diff` between the last commit of the branch you’re on and its common ancestor with another branch:

	$ git diff master...contrib

This command shows you only the work your current topic branch has introduced since its common ancestor with master. That is a very useful syntax to remember.

### Integrating Contributed Work ###

When all the work in your topic branch is ready to be integrated into a more mainline branch, the question is how to do it. Furthermore, what overall workflow do you want to use to maintain your project? You have a number of choices, so I’ll cover a few of them.

#### Merging Workflows ####

One simple workflow merges your work into your `master` branch. In this scenario, you have a `master` branch that contains basically stable code. When you have work in a topic branch that you’ve done or that someone has contributed and you’ve verified, you merge it into your master branch, delete the topic branch, and then continue the process.  If we have a repository with work in two branches named `ruby_client` and `php_client` that looks like Figure 5-19 and merge `ruby_client` first and then `php_client` next, then your history will end up looking like Figure 5-20.

Insert 18333fig0519.png 
Figure 5-19. History with several topic branches.

Insert 18333fig0520.png
Figure 5-20. After a topic branch merge.

That is probably the simplest workflow, but it’s problematic if you’re dealing with larger repositories or projects.

If you have more developers or a larger project, you’ll probably want to use at least a two-phase merge cycle. In this scenario, you have two long-running branches, `master` and `develop`, in which you determine that `master` is updated only when a very stable release is cut and all new code is integrated into the `develop` branch. You regularly push both of these branches to the public repository. Each time you have a new topic branch to merge in (Figure 5-21), you merge it into `develop` (Figure 5-22); then, when you tag a release, you fast-forward `master` to wherever the now-stable `develop` branch is (Figure 5-23).

Insert 18333fig0521.png 
Figure 5-21. Before a topic branch merge.

Insert 18333fig0522.png 
Figure 5-22. After a topic branch merge.

Insert 18333fig0523.png 
Figure 5-23. After a topic branch release.

This way, when people clone your project’s repository, they can either check out master to build the latest stable version and keep up to date on that easily, or they can check out develop, which is the more cutting-edge stuff.
You can also continue this concept, having an integrate branch where all the work is merged together. Then, when the codebase on that branch is stable and passes tests, you merge it into a develop branch; and when that has proven itself stable for a while, you fast-forward your master branch.

#### Large-Merging Workflows ####

The Git project has four long-running branches: `master`, `next`, and `pu` (proposed updates) for new work, and `maint` for maintenance backports. When new work is introduced by contributors, it’s collected into topic branches in the maintainer’s repository in a manner similar to what I’ve described (see Figure 5-24). At this point, the topics are evaluated to determine whether they’re safe and ready for consumption or whether they need more work. If they’re safe, they’re merged into `next`, and that branch is pushed up so everyone can try the topics integrated together.

Insert 18333fig0524.png 
Figure 5-24. Managing a complex series of parallel contributed topic branches.

If the topics still need work, they’re merged into `pu` instead. When it’s determined that they’re totally stable, the topics are re-merged into `master` and are then rebuilt from the topics that were in `next` but didn’t yet graduate to `master`. This means `master` almost always moves forward, `next` is rebased occasionally, and `pu` is rebased even more often (see Figure 5-25).

Insert 18333fig0525.png 
Figure 5-25. Merging contributed topic branches into long-term integration branches.

When a topic branch has finally been merged into `master`, it’s removed from the repository. The Git project also has a `maint` branch that is forked off from the last release to provide backported patches in case a maintenance release is required. Thus, when you clone the Git repository, you have four branches that you can check out to evaluate the project in different stages of development, depending on how cutting edge you want to be or how you want to contribute; and the maintainer has a structured workflow to help them vet new contributions.

#### Rebasing and Cherry Picking Workflows ####

Other maintainers prefer to rebase or cherry-pick contributed work on top of their master branch, rather than merging it in, to keep a mostly linear history. When you have work in a topic branch and have determined that you want to integrate it, you move to that branch and run the rebase command to rebuild the changes on top of your current master (or `develop`, and so on) branch. If that works well, you can fast-forward your `master` branch, and you’ll end up with a linear project history.

The other way to move introduced work from one branch to another is to cherry-pick it. A cherry-pick in Git is like a rebase for a single commit. It takes the patch that was introduced in a commit and tries to reapply it on the branch you’re currently on. This is useful if you have a number of commits on a topic branch and you want to integrate only one of them, or if you only have one commit on a topic branch and you’d prefer to cherry-pick it rather than run rebase. For example, suppose you have a project that looks like Figure 5-26.

Insert 18333fig0526.png 
Figure 5-26. Example history before a cherry pick.

If you want to pull commit `e43a6` into your master branch, you can run

	$ git cherry-pick e43a6fd3e94888d76779ad79fb568ed180e5fcdf
	Finished one cherry-pick.
	[master]: created a0a41a9: "More friendly message when locking the index fails."
	 3 files changed, 17 insertions(+), 3 deletions(-)

This pulls the same change introduced in `e43a6`, but you get a new commit SHA-1 value, because the date applied is different. Now your history looks like Figure 5-27.

Insert 18333fig0527.png 
Figure 5-27. History after cherry-picking a commit on a topic branch.

Now you can remove your topic branch and drop the commits you didn’t want to pull in.

### Tagging Your Releases ###

When you’ve decided to cut a release, you’ll probably want to drop a tag so you can re-create that release at any point going forward. You can create a new tag as I discussed in Chapter 2. If you decide to sign the tag as the maintainer, the tagging may look something like this:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gmail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

If you do sign your tags, you may have the problem of distributing the public PGP key used to sign your tags. The maintainer of the Git project has solved this issue by including their public key as a blob in the repository and then adding a tag that points directly to that content. To do this, you can figure out which key you want by running `gpg --list-keys`:

	$ gpg --list-keys
	/Users/schacon/.gnupg/pubring.gpg
	---------------------------------
	pub   1024D/F721C45A 2009-02-09 [expires: 2010-02-09]
	uid                  Scott Chacon <schacon@gmail.com>
	sub   2048g/45D02282 2009-02-09 [expires: 2010-02-09]

Then, you can directly import the key into the Git database by exporting it and piping that through `git hash-object`, which writes a new blob with those contents into Git and gives you back the SHA-1 of the blob:

	$ gpg -a --export F721C45A | git hash-object -w --stdin
	659ef797d181633c87ec71ac3f9ba29fe5775b92

Now that you have the contents of your key in Git, you can create a tag that points directly to it by specifying the new SHA-1 value that the `hash-object` command gave you:

	$ git tag -a maintainer-pgp-pub 659ef797d181633c87ec71ac3f9ba29fe5775b92

If you run `git push --tags`, the `maintainer-pgp-pub` tag will be shared with everyone. If anyone wants to verify a tag, they can directly import your PGP key by pulling the blob directly out of the database and importing it into GPG:

	$ git show maintainer-pgp-pub | gpg --import

They can use that key to verify all your signed tags. Also, if you include instructions in the tag message, running `git show <tag>` will let you give the end user more specific instructions about tag verification.

### Generating a Build Number ###

Because Git doesn’t have monotonically increasing numbers like 'v123' or the equivalent to go with each commit, if you want to have a human-readable name to go with a commit, you can run `git describe` on that commit. Git gives you the name of the nearest tag with the number of commits on top of that tag and a partial SHA-1 value of the commit you’re describing:

	$ git describe master
	v1.6.2-rc1-20-g8c5b85c

This way, you can export a snapshot or build and name it something understandable to people. In fact, if you build Git from source code cloned from the Git repository, `git --version` gives you something that looks like this. If you’re describing a commit that you have directly tagged, it gives you the tag name.

The `git describe` command favors annotated tags (tags created with the `-a` or `-s` flag), so release tags should be created this way if you’re using `git describe`, to ensure the commit is named properly when described. You can also use this string as the target of a checkout or show command, although it relies on the abbreviated SHA-1 value at the end, so it may not be valid forever. For instance, the Linux kernel recently jumped from 8 to 10 characters to ensure SHA-1 object uniqueness, so older `git describe` output names were invalidated.

### Preparing a Release ###

Now you want to release a build. One of the things you’ll want to do is create an archive of the latest snapshot of your code for those poor souls who don’t use Git. The command to do this is `git archive`:

	$ git archive master --prefix='project/' | gzip > `git describe master`.tar.gz
	$ ls *.tar.gz
	v1.6.2-rc1-20-g8c5b85c.tar.gz

If someone opens that tarball, they get the latest snapshot of your project under a project directory. You can also create a zip archive in much the same way, but by passing the `--format=zip` option to `git archive`:

	$ git archive master --prefix='project/' --format=zip > `git describe master`.zip

You now have a nice tarball and a zip archive of your project release that you can upload to your website or e-mail to people.

### The Shortlog ###

It’s time to e-mail your mailing list of people who want to know what’s happening in your project. A nice way of quickly getting a sort of changelog of what has been added to your project since your last release or e-mail is to use the `git shortlog` command. It summarizes all the commits in the range you give it; for example, the following gives you a summary of all the commits since your last release, if your last release was named v1.0.1:

	$ git shortlog --no-merges master --not v1.0.1
	Chris Wanstrath (8):
	      Add support for annotated tags to Grit::Tag
	      Add packed-refs annotated tag support.
	      Add Grit::Commit#to_patch
	      Update version and History.txt
	      Remove stray `puts`
	      Make ls_tree ignore nils

	Tom Preston-Werner (4):
	      fix dates in history
	      dynamic version method
	      Version bump to 1.0.2
	      Regenerated gemspec for version 1.0.2

You get a clean summary of all the commits since v1.0.1, grouped by author, that you can e-mail to your list.

## Итоги ##

You should feel fairly comfortable contributing to a project in Git as well as maintaining your own project or integrating other users’ contributions. Congratulations on being an effective Git developer! In the next chapter, you’ll learn more powerful tools and tips for dealing with complex situations, which will truly make you a Git master.
