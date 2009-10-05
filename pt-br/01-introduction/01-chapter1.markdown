# Primeiros passos #

Esse capítulo trata dos primeiros passos usando o Git. Inicialmente explicaremos alguns fundamentos sobre ferramentas de controle de versão, e passaremos ao tópico de como instalar o Git no seu sistema e finalmente em como configurá-lo para começar a trabalhar. Ao final do capítulo você entenderá porque o Git está por aí, porque usá-lo e como usá-lo.

## Sobre Controle de Versão ##

O que é controle de versão, e por que você deve se importar? O controle de versão é um sistema que registra as mudanças feitas em um arquivo ou um conjunto de arquivos ao longo do tempo de forma que você possa recuperar versões específicas. Nos exemplos desse livro você colocará arquivos de código fonte sob controle de versão, embora você pudesse fazê-lo com praticamente qualquer tipo de arquivo de um computador.

Se você é um designer gráfico ou um web designer e quer manter todas as versões de uma imagem ou layout (o que você deve querer, com certeza), É uma sábia decisão usar um Sistema de Controle de Versão ou Version Control System (VCS). Ele permitirá reverter arquivos ou um projeto inteiro a um estado anterior. Comparar mudanças que foram feitas ao decorrer do tempo, ver quem foi o último a modificar alguma coisa que pode estar causando problemas, quem introduziu um bug, e quando, e muito mais. Usar um VCS normalmente significa que se você estragou algo ou perdeu arquivos, poderá facilmente reavê-los. Além disso, você pode controlar tudo sem maiores esforços.

### Sistemas de Controle de Versão Locais ###

O método mais escolhido por muitas pessoas de controlar versões é copiar arquivos e guardá-los em outro diretório (talvez um diretório com data/hora, se forem espertos). Esta abordagem é muito comum por ser tão simples, mas é também muito suscetível a erros. É facíl esquecer em qual diretório você estava e gravar acidentalmente sobre o arquivo errado ou sobrescrever arquivos sem querer.

Para lidar com esse problema, alguns programadores desenvolveram há muito tempo VCS's locais que armazenavam todas as alterações dos arquivos sob controle de versão/revisão (ver Figura 1-1).

Insert 18333fig0101.png 
Figura 1-1. Diagrama de controle de versão local

Uma das ferramentas de VCS mais populares foi um sistema chamado RCS, que ainda é distribuído em muitos computadores até hoje. Até o o popular Mac OS X inclui o comando rcs quando se instala o kit de ferramentas para desenvolvedores. Basicamente, essa ferramenta mantém conjuntos de patches (ou seja, as diferenças entre os arquivos) entre cada mudança em um arquivo especial; a partir daí qualquer arquivo em qualquer ponto na linha do tempo pode ser recriado ao juntar-se todos os patches.

### Sistemas de Controle de Versão Centralizado ###

Outro grande problema que as pessoas encontram está na necessidade de trabalhar em conjunto com outros desenvolvedores, que usam outros sistemas. Para lidar com isso, foram desenvolvidos Sistemas de Controle de Versão Centralizado (Centralized Version Control Systems, ou CVCS). Esses sistemas - como por exemplo o CVS, Subversion e Perforce - possuem um único servidor central que contém todos os arquivos versionados, e vários clients que podem resgatar (check out) os arquivos do servidor. Por muitos anos, esse foi o modelo padrão para controle de versão.

Insert 18333fig0102.png 
Figura 1-2. Diagrama de Controle de Versão Centralizado

Esse arranjo oferece muitas vantagens, especialmente sobre VCS locais. Por exemplo, todo mundo tem conhecimento razoável sobre o que todos os outros no projeto estão fazendo. Administradores têm controle especifíco sobre quem-faz-o-quê; sem falar que é bem mais fácil administrar um CVCS do que é lidar com bancos de dados locais em todo cliente.

Entretanto, esse arranjo também possui sérias desvantagens. O mais óbvio é que o servidor central é unm ponto único de falha. Se o servidor fica fora do ar por uma hora, então ninguém pode trabalhar em conjunto ou salvar novas versões dos arquivos durante esse período. Se o disco do servidor do banco de dados for corrompido e não existir um backup adequado, perde-se todo o histórico de mudanças no projeto exceto pelas cópias momentâneas que os desenvolvedores possuem em suas cópias locais. VCSs locais também sofrem desse problema - sempre que se tem o histórico em um único local, corre-se o risco de perder tudo.

### Sistemas de Controle de Versão Distribuídos ###

É aqui que surgem os Sistemas de Controle de Versão Distribuídos (Distributed Version Control Systems, ou DVCSs). Em um DVCS (tais como Git, Mercurial, Bazaar or Darcs), os clientes não apenas fazem cópias momentâneas dos arquivos: eles são cópias completas do repositório. Assim, se um servidor falha, qualquer um dos repositórios dos clientes pode ser copiado de volta para o servidor para restaurá-lo. Cada checkout é na prática um backup completo de todos os dados (veja Figura 1-3).

Insert 18333fig0103.png 
Figura 1-3. Diagrama de Controle de Versão Distribuído

Além disso, muitos desses sistemas lidam muito bem com o aspecto de ter vários repositórios remotos com os quais eles podem colaborar, permitindo que vc trabalhe em conjunto com diferentes grupos de pessoas, de diversas maneiras, no mesmo projeto, simultaneamente. Isso permite que você estabeleça diferentes tipos de workflow que não são possíveis em sistemas centralizados, como exemplo direto o uso de modelos heiráquicos.

## Uma Breve História do Git ##

Assim como muitas coisas importantes na vida, o Git começou com um tanto de destruição criativa e acirrada controvérsia. O kernel do Linux é um projeto de software de código aberto de escopo razoavelmente grande. Durante a maior parte de sua existência (1991-2002), as mudanças no software eram repassadas como patches e arquivos compactados. Em 2002, o projeto do kernel do Linux começou a usar um sistema proprietário distribuído chamado BitKeeper.

Em 2005, o relacionamento entre a comunidade que desenvolvia o kernel e a empresa que desenvolvia comercialmente o BitKeeper se desfez, e o status de isento-de-pagamento da ferramenta foi revogado. Isso levou a comunidade de desenvolvedores do Linux (em particular Linus Torvalds, o criador do Linux) a desenvolver sua própria ferramenta baseada nas lições que eles aprenderam ao usar o BitKeeper. Alguns dos objetivos do novo sistema eram:

*	Velocidade
*	Design Simples
*	Robusto Suporte a desenvolvimento não linear (milhares de branches paralelos)
*	Totalmente distribuído
*	Capaz de lidar eficientemente com grandes projetos como o kernel do Linux (velocidade e volume de dados)

Desde sua concepção em 2005, o Git evoluiu e amadureceu a ponto de ser um sistema fácil de ser usado e ainda mantém suas características iniciais. É incrivelmente rápido, bastante eficiente com grandes projetos e possui um sistema impressionante para desenvolvimento não-linear (Veja no Capítulo 3).

## Git Básico ##

Enfim, como fazer uma descrição sucinta do Git? Essa é uma seção importante para assimiliar, já que usá-lo será muito mais fácil se você entender o que é o Git e os fundamentos de sua operação. À medida que você aprende a usar o Git, tente não pensar no que você já sabe sobre outros VCS como Subversion e Perforce; assim você consegue escapar de pequenas confusões que podem surgir usando a ferramenta. Git armazena e pensa sobre informação de uma forma totalmente diferente desses outros sistemas, apesar de possuir uma interface similar; entendendo essas diferenças lhe auxiliarão a ficar confuso.

### Capturas Instantâneas, ao invés de diferenças  ###

A maior diferença entre Git e qualquer outro VCS (Subversion e similares incluso) estão nos conceitos que o Git tem sobre os dados. Conceitualmente, a maior parte dos outros sistemas armazena informação como uma lista de mudanças por arquivo. Esses sistemas (CVS, Subversion, Perforce, Bazaar, etc) tratam a informação que eles mantém como um conjunto de arquivos e as mudanças feitas a cada arquivo ao longo do tempo, conforme ilustrado na Figura 1.4.

Insert 18333fig0104.png 
Figura 1-4. Outros sistemas costumam armazenar dados como mudanças em uma versão-base de cada arquivo.

Git não pensa na informação dessa forma, nem a armazena com esse princípio. Ao invés disso, o Git considera que os dados são como um conjunto de capturas instântaneas (snapshots) de um mini-sistema de arquivos. Cada vez que você faz um commit ou salva o estado do seu projeto no Git, o que basicamente o Git faz é tirar uma foto de todos os seus arquivos naquele momento e armazena uma referência para essa captura. Para ser eficiente, se nenhum arquivo foi alterado, a informação não é armazenada novamente - apenas um link para o arquivo idêntico anterior que já foi armazenado. A figura 1-5 representa melhor a forma que o Git lida com dados.

Insert 18333fig0105.png 
Figura 1-5. Git armazena dados como snapshots do projeto ao longo do tempo.

Essa é uma distinção importante entre Git e quase todos os outros VCSs. Isso leva o Git a reconsiderar quase todos os aspectos de controle de versão que os outros sistemas copiaram da geração anterior. Também faz com que o Git se comporte mais como um mini-sistema de arquivos com algumas poderosas ferramentas construídas em cima dele, ao invés de um simples VCS. Nós vamos explorar alguns dos benefícios que você tem ao lidar com dados dessa forma, quando tratarmos do assunto de branching no Capítulo 3.

### Quase Toda Operação É Local ###

A maior parte das operações no Git precisa apenas de recursos e arquivos locais para seu funcionamento - geralmente nenhuma outra informação é necessária de outro computador na sua rede. Se você está acostumado a um CVCS onde a maior parte das operações possui latência por conta de comunicação com a rede, esse aspecto do Git fará com que você pense que os deuses da velocidade abençoaram Git com poderes sobrenaturais. Uma vez que todos o histórico do projeto está no seu disco local, a maior parte das operações parece ser instantânea.

Por exemplo, para navegar o histórico do projeto, o Git não precisa requisitar ao servidor o histórico para que possa apresentar a você - basta apenas uma leitura da base de dados local. Isso significa que você vê o histórico do projeto de quase instanteneamente. Se você quiser ver todas as mudanças introduzidas entre a versão atual de um arquivo e a versão de um mês atrás, o Git pode buscar o arquivo de um mês atrás e fazer um cálculo de diferenças localmente, ao invés de ter que requisitar ao servidor que faça o cálculo, ou pedir o arquivo antigo para que o cálculo possa ser feito localmente.

Isso também significa que há pouca coisa que você não pode fazer, se estiver offline ou sem acesso a uma VPN. Se você entra em um avião ou trem e quiser trabalhar, você pode fazer commits livre de preocupações até o instante que você tem acesso a rede novamente. Se você estiver indo para casa e seu cliente de VPN não estiver funcionando, você ainda pode trabalhar. Em outros sistemas, fazer isso ou é impossível ou uma tarefa árdua. No Perforce, por exemplo, você não pode fazer muita coisa quando não está conectado ao servidor; e no Subversion e CVS, você pode até editar os arquivos, mas não pode fazer commits das mudanças já que sua base de dados estará offline. Pode até parecer que não é grande coisa, mas você pode se surpreender com o tanto de diferença que pode lhe trazer.

### Git Possui Integridade ###

Tudo no Git tem seu checksum calculado antes que seja armazenado e é referenciado pelo checksum. Isso significada que é impossível mudar o conteúdo de qualquer arquivo ou diretório sem que o Git tenha conhecimento da ação tomada. Essa funcionalidade é parte fundamental do Git e é integral à sua filosofia. Você não pode perder informação em trânsito ou ter arquivos corrompidos sem que o Git seja capaz de detectar o ocorrido.

O mecanismo que o Git usa para fazer o checksum é chamado de hash SHA-1, uma string de 40 caracteres composta de characteres hexadecimais que é calculado a partir do conteúdo de um arquivo ou estrutura de um diretório no Git. Um hash SHA-1 parece com algo mais ou menos assim:

	24b9da6552252987aa493b52f8696cd6d3b00373

Você vai encontrar esses hashes em todo canto, uma vez que Git os utiliza tanto. Na verdade, tudo que o Git armazena é identificado não por nome do arquivo mas pelo valor do hash do seu conteúdo.

### Git Generally Only Adds Data ###

When you do actions in Git, nearly all of them only add data to the Git database. It is very difficult to get the system to do anything that is undoable or make it erase data in any way. As in any VCS, you can lose or mess up changes you haven’t committed yet; but after you commit a snapshot into Git, it is very difficult to lose, especially if you regularly push your database to another repository.

This makes using Git a joy because we know we can experiment without the danger of severely screwing things up. For a more in-depth look at how Git stores its data and how you can recover data that seems lost, see “Under the Covers” in Chapter 9.

### The Three States ###

Now, pay attention. This is the main thing to remember about Git if you want the rest of your learning process to go smoothly. Git has three main states that your files can reside in: committed, modified, and staged. Committed means that the data is safely stored in your local database. Modified means that you have changed the file but have not committed it to your database yet. Staged means that you have marked a modified file in its current version to go into your next commit snapshot.

This leads us to the three main sections of a Git project: the Git directory, the working directory, and the staging area.

Insert 18333fig0106.png 
Figure 1-6. Working directory, staging area, and git directory

The Git directory is where Git stores the metadata and object database for your project. This is the most important part of Git, and it is what is copied when you clone a repository from another computer.

The working directory is a single checkout of one version of the project. These files are pulled out of the compressed database in the Git directory and placed on disk for you to use or modify.

The staging area is a simple file, generally contained in your Git directory, that stores information about what will go into your next commit. It’s sometimes referred to as the index, but it’s becoming standard to refer to it as the staging area.

The basic Git workflow goes something like this:

1.	You modify files in your working directory.
2.	You stage the files, adding snapshots of them to your staging area.
3.	You do a commit, which takes the files as they are in the staging area and stores that snapshot permanently to your Git directory.

If a particular version of a file is in the git directory, it’t considered committed. If it’s modified but has been added to the staging area, it is staged. And if it was changed since it was checked out but has not been staged, it is modified. In Chapter 2, you’ll learn more about these states and how you can either take advantage of them or skip the staged part entirely.

## Installing Git ##

Let’s get into using some Git. First things first—you have to install it. You can get it a number of ways; the two major ones are to install it from source or to install an existing package for your platform.

### Installing from Source ###

If you can, it’s generally useful to install Git from source, because you’ll get the most recent version. Each version of Git tends to include useful UI enhancements, so getting the latest version is often the best route if you feel comfortable compiling software from source. It is also the case that many Linux distributions contain very old packages; so unless you’re on a very up-to-date distro or are using backports, installing from source may be the best bet.

To install Git, you need to have the following libraries that Git depends on: curl, zlib, openssl, expat, and libiconv. For example, if you’re on a system that has yum (such as Fedora) or apt-get (such as a Debian based system), you can use one of these commands to install all of the dependencies:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel
	
When you have all the necessary dependencies, you can go ahead and grab the latest snapshot from the Git web site:

	http://git-scm.com/download
	
Then, compile and install:

	$ tar -zxf git-1.6.0.5.tar.gz
	$ cd git-1.6.0.5
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

After this is done, you can also get Git via Git itself for updates:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	
### Installing on Linux ###

If you want to install Git on Linux via a binary installer, you can generally do so through the basic package-management tool that comes with your distribution. If you’re on Fedora, you can use yum:

	$ yum install git-core

Or if you’re on a Debian-based distribution like Ubuntu, try apt-get:

	$ apt-get instal git-core

### Installing on Mac ###

There are two easy ways to install Git on a Mac. The easiest is to use the graphical Git installer, which you can download from the Google Code page (see Figure 1-7):

	http://code.google.com/p/git-osx-installer

Insert 18333fig0107.png 
Figure 1-7. Git OS X installer

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
*	config file in the git directory (that is, `.git/config`) of whatever repository you’re currently using: Specific to that single repository. Each level overrides values in the previous level, so values in `.git/config` trump those in `/etc/sysconfig`.

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

## Summary ##

You should have a basic understanding of what Git is and how it’s different from the CVCS you may have been using. You should also now have a working version of Git on your system that’s set up with your personal identity. It’s now time to learn some Git basics.
