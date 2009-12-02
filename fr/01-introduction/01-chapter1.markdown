# Pour commencer #

Ce chapitre concernera la prise en main de Git. Nous commencerons par introduire les outils de suivi de version, puis continuerons avec l'installation de Git sur votre système pour terminer par sa configuration opérationnelle. A la fin de ce chapitre vous devriez comprendre pourquoi Git a été créé, pourquoi vous devrier l'utiliser et comment ce faire.

## A propos du suivi de version ##

Qu'est-ce que le suivi de version, et pourquoi devriez-vous vous en soucier ? Le suivi de version est un système qui enregistre les modifications apportées dans le temps à un fichier ou un lot de fichiers de manière à pouvoir en récupérer une copie spécifique ultérieurement. Dans le cadre des exemples fournis dans cet ouvrage, vous utiliserez du code source comme matière première à soumettre au suivi de version, mais en réalité vous pouvez le faire avec quasiment n'importe quel type de fichier présent sur votre ordinateur.

Si vous êtes graphiste ou concepteur de sites Web et désirez conserver chacune des versions d'une image ou d'un gabarit (ce que vous voulez certainement), un système de suivi de version (SSV) offre une sage solution. Il permet de restaurer un fichier à sa version précédente, rétablir à une version antérieure l'ensemble d'un projet, comparer les modifications au fil du temps, repérer qui a effectué récemment un changement susceptible d'être à la source d'un problème, quand est apparue une problématique et qui l'a introduite, etc. Utiliser un SSV signifie également la possibilité de se remettre facilement d'une catastrophe ou d'une perte de fichier. Tout cela, presque sans effort supplémentaire.

### Systèmes locaux de suivi de version ###

Pour de nombreuses personnes, la méthode de choix pour la sauvegarde consiste à copier des fichiers dans un autre répertoire (peut-être nommé après la date courante, dans le meilleur des cas). Cette approche est très populaire du fait de sa simplicité, mais aussi incroyablement susceptible d'erreur. Il est tellement simple d'oublier le répertoire courant et modifier accidentellement le mauvais fichier ou en écraser un autre sans le vouloir.

Afin d'éviter cet écueil, les programmeurs ont depuis longtemps développé des SSV dotés d'une base de données simple conservant les modifications apportées aux fichiers suivis (voir la figure 1-1).

Insert 18333fig0101.png
Figure 1-1. Diagramme du suivi local de version

RCS, l'un des SSV les plus populaires, est encore fourni avec la plupart des ordinateurs. Même le célèbre Mac OS X inclue la commande rcs lorsque vous installez la suite de développement. Schématiquement, cet outil fonctionne en conservant  dans un format spécial sur le disque des lots de corrections (c'est-à-dire les différences entre les fichiers) d'une sauvegarde à l'autre; il peut restituer l'état d'un fichier à un instant quelconque en appliquant l'ensemble des corrections jusqu'à cet instant.

### Systèmes centralisés de suivi de version ###

La problématique majeure que rencontre ensuite la plupart des gens est la nécessité de collaborer avec des développeurs sur d'autres systèmes. Les systèmes centralisés de suivi de version (SCSV) ont été créé pour répondre à ce besoin. Ces systèmes, tels CVS, Subversion et Perforce, disposent d'un serveur unique maintenant l'ensemble des des versions des fichiers suivis, et des clients qui récupèrent leurs copies depuis ce serveur centrale. Depuis des années ce modèle s'établit comme le standard du suivi de versions (voir la figure 1-2).

Insert 18333fig0102.png
Figure 1-2. Diagramme des systèmes centralisés de suivi de version.

Ce modèle offre de nombreux avantages, surtout comparé aux SSV locaux. Par exemple, chacun sait jusqu'à un certain point, ce à quoi tout les autres sur le projet est occupé. Les administrateurs disposent d'une maîtrise fine des prérogatives de chacun; et il est bien plus facile de gérer un SCSV que d'avoir à maintenir des bases de données locales sur chaque machine cliente.

Cependant, ce modèle souffre de sérieux écueils. Le plus évident concerne le point unique de panne que représente le serveur central. Si ce serveur devient indisponible pendant une heure, durant tout ce temps personne ne pourra collaborer ni sauvegarder les modifications de ses propres travaux en cours. Si le disque dur de la base de données centrale  est corrompu, et que des sauvegardes suffisantes n'ont pas été prévues, c'est l'ensemble du projet que vous pouvez perdre-incluant son historique, à l'exception de quelque copie intégrale dont pourraient disposer certaines personnes sur leurs propres machines. Les SSV locaux souffrent du même problème-dès que vous entreposez l'intégralité de l'historique d'un projet dans un endroit unique, vous risquez de tout perdre.

### Les systèmes distribués de suivi de version ###

C'est là que les systèmes distribués de suivi de version apparaissent. Dans un SDSV (comme Git, Mercurial, Bazaar ou Darcs), les clients ne récupèrent pas seulement la dernière copie des fichiers : ils maintiennent localement un miroir fidèle du dépôt. Si l'un quelconque des serveurs disparait, et que ces systèmes collaboraient avec lui, chacun des clients saura fournir une copie identique à restaurer sur ce serveur. Chaque synchronisation génère en fait une sauvegarde complète de l'intégralité des données (voir la figure 1-3).

Insert 18333fig0103.png
Figure 1-3. Diagramme des systèmes distribués de suivi de version.

En outre, nombre de ces systèmes offre une bonne gestion de multiples dépôts distants avec lesquels travailler, de manière à collaborer avec différents groupes et procéder de différentes manières simultanément au sein d'un même projet. Cela permet la mise en oeuvre de plusieurs méthodes de travail impossible à mettre en place avec des systèmes centralisés, comme des modèles hiérarchiques.

## Une brève histoire de Git ##

Comme pour de nombreuses grandes choses de la vie, Git commença par un brin de destruction créatrice et une sauvage controverse. Le noyau Linux est un projet libre qu'on peut qualifier de grande envergure. Durant la majeure partie de la vie du maintien du noyau Linux (1991-2002), les modifications apportées au logiciel circulaient sous formes de corrections (_patches_) et d'archives de fichiers. En 2002, le projet du noyau Linux adopta un SDSV propriétaire nommé BitKeeper.

En 2005, les relations entre la communauté qui développait le noyau Linux et l'entreprise commerciale qui développait BitKeeper furent brisées et la charte d'utilisation gratuite révoquée. Cela força la communauté qui développe Linux (et en particulier son créateur, Linux Torvalds) à développer son propre outil issu des leçons-apprises en utilisant BitKeeper. Voici résumés quelques-uns des objectifs du nouveau système :

* rapidité
* architecture simple
* support natif du développement non-linéaire (des milliers de branches parallèles)
* entièrement distribué
* capacité de gérer de gros projets tels le noyau Linux efficacement (vitesse et taille des données)

Depuis sa naissance en 2005, Git a évolué vers la mâturité en restant simple d'utilisation tout en conservant ces qualités initiales. Il est incroyablement rapide, très efficient avec les gros projets, et dispose d'un superbe système de gestion des branches pour le développement non-linéaire (voire chapitre 3).

## Les fondements de Git ##

Alors, qu'est-ce que Git en deux mots ? C'est une section importante à absorber, parce que si vous comprenez ce qu'est Git et les fondements de son fonctionnement, alors utiliser Git efficacement viendra bien plus aisément pour vous. Durant l'apprentissage de Git, tâchez d'évacuer de votre esprit ce que vous avez appris d'autres SSV, tels Subversion ou Perforce; ce faisant, vous éviterez de subtiles confusion lorsque vous utiliserez l'outil. Git enregistre et approche les données très différemment des autres systèmes, malgré la similarité des interfaces pour l'utilisateur; comprendre ces différences vous permettra d'éviter la confusion lorsque vous l'utiliserez.

### Sauvegardes au lieu de différences ###

Comment Git "pense" ses données : la différence majeure entre Git et les autres SSV (y compris Subversion et compagnie). Conceptuellement, la plupart des systèmes alternatifs enregistre l'information comme une liste de modifications-par-fichier. Ces systèmes (CVS, Subversion, Perforce, Bazaar, etc.) "pensent" que l'information qu'ils maintiennent s'applique à des lots de fichiers et aux changements effectués dans le temps pour chaque fichier, tel qu'illustré à la figure 1-4.

Insert 18333fig0104.png
Figure 1-4. Les autres systèmes tendent à enregistrer les données comme modifications à une version étalon de chaque fichier.

Git n'approche pas l'enregistrement des données ainsi. A la place, Git conçoit ses données plutôt comme des copies instantanées d'un mini-système-de-fichiers. Chaque fois que vous _committez_, que vous sauvegardez l'état de votre projet dans Git, il prend un instantané de l'état de vos fichiers à ce moment-là et enregistre la référence à cet instantané. Pour plus d'efficacité, si les fichiers n'ont pas changé, Git ne l'enregistre pas de nouveau mais conserve un lien vers la version identique qu'il a déjà enregistrée. La figure 1-5 ressemble à comment Git conçoit ses données.

Insert 18333fig0105.png
Figure 1-5. Git enregistre les données comme instantanés d'un projet dans le temps.

Il s'agit là d'une distinction importante entre Git et les autres SSV. Dans Git, presque tout les aspects du suivi de version que les autres systèmes ont hérité des générations précédentes sont reconsidérés. Cela fait de Git plus un mini-système-de-fichiers sur lequel s'appuient quelques outils d'une puissance incroyable, qu'un simple SSV. Nous reviendrons aux bénéfices de concevoir les données ainsi lorsque nous nous intéresserons aux branches dans le chapitre 3.

### Quasiment toutes les opérations sont locales ###

La plupart des opérations dans Git nécessite seulement des fichiers et ressources locales pour fonctionner--généralement, il n'y a besoin d'aucune information en provenance d'un autre ordinateur sur votre réseau. Si vous avez l'habitude d'un SCSV où la majorité des opérations souffrent de la latence du réseau, cet aspect de Git vous laissera penser que les dieux de la vitesse lui ont transmis ces pouvoirs. En raison de la présence de l'intégralité de l'historique du projet sur votre disque local, presque toutes les opérations semblent instantanées.

Par exemple, pour accéder à l'historique du projet, Git n'a pas besoin d'interroger un serveur distant : il le lit directement depuis votre base de données locale. Cela signifie que vous visualisez l'historique du projet presque instantanément. Si vous voulez consulter les modifications introduites entre la version courante d'un fichier et sa création un mois auparavant, Git peut accéder à l'état du fichier le mois précédent et effectuer un calcul des différences localement, au lieu d'interroger un serveur distant ou récupérer une version précédente du fichier pour faire le calcul localement.

Cela signifie également qu'il y a très peu de choses que vous ne puissiez faire hors-connexion, ou déconnecté(e) du réseau privé virtuel. Si vous prenez l'avion ou le train et désirez profiter du trajet pour travailler un peu, vous pouvez soumettre vos modifications avec bonheur jusqu'à ce que vous puissiez vous connecter pour synchroniser vos données. Une fois à la maison, si vous ne parvenez pas à restaurer la connexion vers votre réseau privé virtuel, vous pouvez tout de même travailler. Avec d'autres systèmes, ces situations s'avèrent impossibles ou très difficiles à mettre en oeuvre. Dans Perforce, par exemple, vous ne pouvez pas faire grand chose sans une connexion au serveur ; et dans Subversion ou CVS, vous pouvez modifier des fichiers, mais vous ne pouvez soumettre aucune modification (parce que votre base de données est déconnectée). Cela peut sembler anodin, mais vous pourriez être surpris(e) de la grande différence que cela peut constituer.

### Git possède l'intégrité ###

Tout dans Git est soumis à une somme de contrôle, qui deviendra la référence, avant d'être enregistré. Cela veut dire qu'il est impossible de modifier le contenu d'aucun fichier ou répertoire sans que Git ne le sache. Cette fonctionnalité est intégrée dans Git au plus bas niveau aussi bien que dans sa philosophie. Vous ne pouvez perdre de l'information pendant les transferts, ni obtenir un fichier corrompu sans que Git ne puisse le détecter.

Git utilise une signature SHA-1 pour les sommes de contrôle. Il s'agit d'une chaîne de 40 caractères hexadécimaux (de 0 à 9 et de A à F), une empreinte unique issue du contenu du fichier ou de la structure des répertoires dans Git. Une empreinte SHA-1 ressemble à ceci :

	24b9da6552252987aa493b52f8696cd6d3b00373

Vous verrez ce genre d'empreintes un peu partout dans Git car il les utilise partout. En fait, Git enregistre tout non par nom de fichier, mais dans une base de données addressable par la signature SHA-1 des contenus.

### Git ne fait (presque) qu'ajouter des données ###

Lorsque vous effectuez des opérations dans Git, presque toutes ne font qu'ajouter des données dans la base de données de Git. Il est très difficile de forcer le système à faire quelque chose qu'on ne puisse défaire ou à effacer des données d'un quelconque manière. Comme dans tous les SSV, vous pouvez perdre ou casser des modifications que vous n'avez pas encore consignées ; mais une fois que vous avez consigné une image de vos changements dans Git, il devient très difficile de les perdre, d'autant plus si vous synchronisez régulièrement votre dépôt vers un autre dépôt.

Cela rend Git agréable à utiliser parce que nous savons que nous pouvons expérimenter sans danger de détruire le projet. Pour une vision plus approfondie de la manière dont Git enregistre ses données, et les moyens de récupérer des données qui semblent perdues, voir "Sous le couvercle" dans la chapitre 9.

### Les trois états ###

A présent, prêtez attention. Il s'agit de la chose principale à retenir concernant Git si vous voulez que le reste de votre apprentissage se passe sans encombre. Git possède trois états principaux dans lesquels vos fichiers peuvent se trouver : consigné, modifié ou en attente. Consigné signifie que les données sont enregistrées, à l'abri, dans votre base de données locale. Modifié veut dire que des changements ont eu lieu, mais qu'ils ne sont pas encore consignés. En attente implique que vous avez marqué un fichier modifié dans sa version courante pour qu'il intègre la prochaine image consignée.

Cela nous amène aux trois principales sections d'un projet Git : le répertoire Git, le répertoire de travail et la zone d'attente.

Insert 18333fig0106.png
Figure 1-6. Le répertoire de travail, zone d'attente et le répertoire Git.

Le répertoire Git est l'endroit ou Git enregistre les méta-données et la base de données d'objets pour votre projet. C'est la partie la plus importante de Git, et c'est ce qui est copié lors d'une opération de clonage du dépôt depuis une autre machine.

Le répertoire de travail est un retrait unique d'une version du projet. Ces fichiers sont retirés de la base de données compressée dans le répertoire Git et placés sur le disque pour être utilisés ou modifiés.

La zone d'attente est un simple fichier, généralement placé dans le répertoire Git, qui contient l'information relative aux modifications qui intègreront la prochaine consignation. On l'appelle parfois l'index, mais l'appellation courante, qui devient le standard, est la zone d'attente.

L'usage fondamental de Git peut se décrire ainsi :

1.  Vous modifiez des fichiers dans votre répertoire de travail.
2.  Vous mettez les fichiers en attente, en ajoutant leur image à la zone d'attente.
3.  Vous consignez les fichiers, ce qui prend un instantané des fichiers en attente et l'enregistre définitivement dans votre répertoire Git.

Si une version particulière d'un fichier est présente dans le répertoire Git, elle est considérée comme consignée. Si elle est modifiée mais présente dans la zone d'attente, elle est en attente. Et si elle a été modifiée depuis le dernier retrait, mais n'est pas encore en attente, alors elle est considérée comme modifiée. Dans le chapitre 2, vous en apprendrez plus sur ces états et comment vous pouvez en tirez avantage ou éviter la zone d'attente entièrement.

## Installing Git ##

Let’s get into using some Git. First things first—you have to install it. You can get it a number of ways; the two major ones are to install it from source or to install an existing package for your platform.

### Installing from Source ###

If you can, it’s generally useful to install Git from source, because you’ll get the most recent version. Each version of Git tends to include useful UI enhancements, so getting the latest version is often the best route if you feel comfortable compiling software from source. It is also the case that many Linux distributions contain very old packages; so unless you’re on a very up-to-date distro or are using backports, installing from source may be the best bet.

To install Git, you need to have the following libraries that Git depends on: curl, zlib, openssl, expat, and libiconv. For example, if you’re on a system that has yum (such as Fedora) or apt-get (such as a Debian based system), you can use one of these commands to install all of the dependencies:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev

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

	$ apt-get install git-core

### Installing on Mac ###

There are two easy ways to install Git on a Mac. The easiest is to use the graphical Git installer, which you can download from the Google Code page (see Figure 1-7):

	http://code.google.com/p/git-osx-installer

Insert 18333fig0107.png
Figure 1-7. Git OS X installer.

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

## Summary ##

You should have a basic understanding of what Git is and how it’s different from the CVCS you may have been using. You should also now have a working version of Git on your system that’s set up with your personal identity. It’s now time to learn some Git basics.
