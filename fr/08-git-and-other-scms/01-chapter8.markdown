# Git et les autres systèmes #

Le monde n'est pas parfait.
Habituellement, vous ne pouvez pas basculer immédiatement sous Git tous les projets que vous pourriez rencontrer.
Quelques fois, vous êtes bloqué sur un projet utilisant un autre VCS et très souvent ce système s'avère être Subversion.
Dans la première partie de ce chapitre, nous traiterons de `git svn`, la passerelle bidirectionnelle de Git pour Subversion.

À un moment, vous voudrez convertir votre projet à Git.
La seconde partie de ce chapitre traite la migration de votre projet dans Git : depuis Subversion, puis depuis Perforce et enfin par un script d'import personnalisé pour les cas non-standards.

## Git et Subversion ##

Aujourd'hui, la majorité des projets de développement libre et un grand nombre de projets dans les sociétés utilisent Subversion pour gérer leur code source.
C'est le VCS libre le plus populaire depuis une bonne décennie.
Il est aussi très similaire à CVS qui a été le grand chef des gestionnaires de source avant lui.

Une des grandes fonctionnalités de Git est sa passerelle vers subversion, `git svn`.
Cet outil vous permet d'utiliser Git comme un client valide d'un serveur Subversion pour que vous puissiez utiliser les capacités de Git en local puis poussez sur le serveur Subversion comme si vous utilisiez Subversion localement.
Cela signifie que vous pouvez réaliser localement les embranchements et les fusions, utiliser l'index, utiliser le rebasage et la sélection de commits, etc, tandis que vos collaborateurs continuent de travailler avec leurs méthodes ancestrales et obscures.
C'est une bonne manière d'introduire Git dans un environnement professionnel et d'aider vos collègues développeurs à devenir plus efficace tandis que vous ferez pression pour une modification de l'infrastructure vers l'utilisation massive de Git.
La passerelle Subversion n'est que la première dose vers la drogue du monde des DVCS.

### git svn ###

La commande de base dans Git pour toutes les commandes de passerelle est `git svn`.
Vous préposerez tout avec cette paire de mots.
Les possibilités étant nombreuses, nous traiterons des plus communes pendant que nous détaillerons quelques petits modes de gestion.

Il est important de noter que lorsque vous utilisez `git svn`, vous interagissez avec Subversion qui est un système bien moins sophistiqué que Git.
Bien que vous puissiez simplement réaliser des branches locales et les fusionner, il est généralement conseillé de conserver votre historique le plus linéaire possible en rebasant votre travail et évitant des activités telles que d'interagir dans le même temps avec un dépôt Git distant.

Ne réécrivez pas votre historique et avant d'essayer de pousser à nouveau et ne poussez pas en parallèle dans un dépôt Git pour collaborer avec vos collègues développant avec Git.
Subversion ne supporte qu'un historique linéaire et l'égarer est très facile.
Si vous travaillez avec une équipe dont certains membres utilisent svn et d'autres utilisent Git, assurez-vous que tout le monde n'utilise que le serveur svn pour collaborer, cela vous rendra service.

### Installation ###

Pour montrer cette fonctionnalité, il faut un serveur svn sur lequel vous avez des droits en écriture.
Pour copier ces exemples, faites une copie inscriptible de mon dépôt de test.
Dans cette optique, vous pouvez utiliser un outil appelé `svnsync` qui est livré avec les versions les plus récentes  de Subversion — il devrait être distribué avec les version à partir de 1.4.
Pour ces tests, j'ai créé sur Google code un nouveau dépôt Subversion qui était une copie partielle du projet `protobuf` qui est un outil qui encode les données structurées pour une transmission par réseau.

En préparation, créez un nouveau dépôt local Subversion :

	$ mkdir /tmp/test-svn
	$ svnadmin create /tmp/test-svn

Ensuite, autorisez tous les utilisateurs à changer les revprops — le moyen le plus simple consiste à ajouter un script pre-revprop-change que rend toujours 0 :

	$ cat /tmp/test-svn/hooks/pre-revprop-change 
	#!/bin/sh
	exit 0;
	$ chmod +x /tmp/test-svn/hooks/pre-revprop-change

Vous pouvez à présent synchroniser ce projet sur votre machine locale en lançant `svnsync init` avec les dépôt sources et cibles.

	$ svnsync init file:///tmp/test-svn http://progit-example.googlecode.com/svn/ 

Cela initialise les propriétés nécessaires à la synchronisation.
Vous pouvez ensuite cloner le code en lançant

	$ svnsync sync file:///tmp/test-svn
	Committed revision 1.
	Copied properties for revision 1.
	Committed revision 2.
	Copied properties for revision 2.
	Committed revision 3.
	...

Bien que cette opération ne dure que quelques minutes, si vous essayez de copier le dépôt original sur un autre dépôt distant au lieu d'un dépôt local, le processus durera près d'une heure, en dépit du fait qu'il y a moins de 100 commits.
Subversion doit cloner révision par révision puis pousser vers un autre dépôt — c'est ridiculement inefficace mais c'est la seule possibilité.

### Démarrage ###

Avec des droits en écriture sur un dépôt Subversion, vous voici prêt à expérimenter une méthode typique.
Commençons par la commande `git svn clone` qui importe un dépôt Subversion complet dans un dépôt Git local.
Souvenez-vous que si vous importez depuis un dépôt Subversion hébergé sur internet, il faut remplacer l'URL `file://tmp/test-svn` ci-dessous par l'URL de votre dépôt Subversion :

	$ git svn clone file:///tmp/test-svn -T trunk -b branches -t tags
	Initialized empty Git repository in /Users/schacon/projects/testsvnsync/svn/.git/
	r1 = b4e387bc68740b5af56c2a5faf4003ae42bd135c (trunk)
	      A    m4/acx_pthread.m4
	      A    m4/stl_hash.m4
	...
	r75 = d1957f3b307922124eec6314e15bcda59e3d9610 (trunk)
	Found possible branch point: file:///tmp/test-svn/trunk => \
	    file:///tmp/test-svn /branches/my-calc-branch, 75
	Found branch parent: (my-calc-branch) d1957f3b307922124eec6314e15bcda59e3d9610
	Following parent with do_switch
	Successfully followed parent
	r76 = 8624824ecc0badd73f40ea2f01fce51894189b01 (my-calc-branch)
	Checked out HEAD:
	 file:///tmp/test-svn/branches/my-calc-branch r76

Cela équivaut à lancer `git svn init` suivi de `git svn fetch` sur l'URL que vous avez fournie.
Cela peut prendre un certain temps.
Le projet de test ne contient que 75 commits et la taille du code n'est pas extraordinaire, ce qui prend juste quelques minutes.
Cependant, Git doit extraire chaque version, une par une et les valider individuellement.
Pour un projet contenant des centaines ou des milliers de commits, cela peut prendre littéralement des heures ou même des jours à terminer.

La partie `-T trunk -b branches -t tags` indique à Git que ce dépôt Subversion suit les conventions de base en matière d'embranchement et de balisage.
Si vous nommez votre trunk, vos branches ou vos balises différemment, vous pouvez modifier ces options.
Comme cette organisation est la plus commune, ces options peuvent être simplement remplacées par `-s` qui signifie structure standard.
La commande suivante est équivalente :

	$ git svn clone file:///tmp/test-svn -s

À présent, vous disposez d'un dépôt Git valide qui a importé vos branches et vos balises :

	$ git branch -a
	* master
	  my-calc-branch
	  tags/2.0.2
	  tags/release-2.0.1
	  tags/release-2.0.2
	  tags/release-2.0.2rc1
	  trunk

Il est important de remarquer comment cet outil sous-classe vos références distantes différemment.
Quand vous clonez un dépôt Git normal, vous obtenez toutes les branches distantes localement sous la forme `origin/[branch]` avec un espace de nom correspondant au dépôt distant.
Cependant, `git svn` assume que vous n'aurez pas de multiples dépôts distants et enregistre toutes ses références pour qu'elles pointent sur le dépôt distant.
Cependant, vous pouvez utiliser la commande Git de plomberie `show-ref` pour visualiser toutes vos références.

	$ git show-ref
	1cbd4904d9982f386d87f88fce1c24ad7c0f0471 refs/heads/master
	aee1ecc26318164f355a883f5d99cff0c852d3c4 refs/remotes/my-calc-branch
	03d09b0e2aad427e34a6d50ff147128e76c0e0f5 refs/remotes/tags/2.0.2
	50d02cc0adc9da4319eeba0900430ba219b9c376 refs/remotes/tags/release-2.0.1
	4caaa711a50c77879a91b8b90380060f672745cb refs/remotes/tags/release-2.0.2
	1c4cb508144c513ff1214c3488abe66dcb92916f refs/remotes/tags/release-2.0.2rc1
	1cbd4904d9982f386d87f88fce1c24ad7c0f0471 refs/remotes/trunk

Pour un dépôt Git normal, cela ressemble plus à ceci :

	$ git show-ref
	83e38c7a0af325a9722f2fdc56b10188806d83a1 refs/heads/master
	3e15e38c198baac84223acfc6224bb8b99ff2281 refs/remotes/gitserver/master
	0a30dd3b0c795b80212ae723640d4e5d48cabdff refs/remotes/origin/master
	25812380387fdd55f916652be4881c6f11600d6f refs/remotes/origin/testing

Ici, vous disposez de deux serveurs distants : un nommé `gitserver` avec une branche `master` et un autre nommé `origin` avec deux branches `master` et `testing`.

Remarquez comme dans cet exemple de références distantes importées via `git svn`, les balises sont ajoutées comme des branches distantes et non comme des vraies balises Git.
Votre importation Subversion indique plutôt qu'il a un serveur distant appelé `tags` présentant des branches.

### Valider en retour sur le serveur Subversion ###

Comme vous disposez d'un dépôt en état de marche, vous pouvez commencer à travailler sur le projet et pousser vos commits en utilisant efficacement Git comme client SVN.
Si vous éditez un des fichiers et le validez, vous créez un commit qui existe localement dans Git mais qui n'existe pas sur le serveur Subversion :

	$ git commit -am 'Adding git-svn instructions to the README'
	[master 97031e5] Adding git-svn instructions to the README
	 1 files changed, 1 insertions(+), 1 deletions(-)

Ensuite, vous avez besoin de pousser vos modifications en amont.
Remarquez que cela modifie la manière de travailler par rapport à Subversion — vous pouvez réalisez plusieurs validations en mode déconnecté pour ensuite les pousser toutes en une fois sur le serveur Subversion.
Pour pousser sur un serveur Subversion, il faut lancer la commande `git svn dcommit` :

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      README.txt
	Committed r79
	       M      README.txt
	r79 = 938b1a547c2cc92033b74d32030e86468294a5c8 (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

Cette commande rassemble tous les commits que vous avez validés par dessus le code du serveur Subversion et réalise un commit sur le serveur pour chacun, puis réécrit l'historique Git local pour y ajouter un identifiant unique.
Cette étape est à souligner car elle signifie que toutes les sommes de contrôle SHA-1 de vos commits locaux ont changé.
C'est en partie pour cette raison que c'est une idée très périlleuse de vouloir travailler dans le même temps avec des serveurs Git distants.
L'examen du dernier commit montre que le nouveau `git-svn-id` a été ajouté :

	$ git log -1
	commit 938b1a547c2cc92033b74d32030e86468294a5c8
	Author: schacon <schacon@4c93b258-373f-11de-be05-5f7a86268029>
	Date:   Sat May 2 22:06:44 2009 +0000

	    Adding git-svn instructions to the README

	    git-svn-id: file:///tmp/test-svn/trunk@79 4c93b258-373f-11de-be05-5f7a86268029

Remarquez que la somme de contrôle SHA qui commençait par `97031e5` quand vous avez validé commence à présent par `938b1a5`.
Si vous souhaitez pousser à la fois sur un serveur Git et un serveur Subversion, il faut obligatoirement pousser (`dcommit`) sur le serveur Subversion en premier, car cette action va modifier vos données des commits.

### Tirer des modifications ###

Quand vous travaillez avec d'autres développeurs, il arrive à certains moments que ce qu'un développeur a poussé provoque un conflit lorsqu'un autre voudra pousser à son tour.
Cette modification sera rejetée jusqu'à ce qu'elle soit fusionnée.
Dans `git svn`, cela ressemble à ceci :

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	Merge conflict during commit: Your file or directory 'README.txt' is probably \
	out-of-date: resource out of date; try updating at /Users/schacon/libexec/git-\
	core/git-svn line 482

Pour résoudre cette situation, vous pouvez lancer la commande `git svn rebase` qui tire depuis le serveur toute modification apparue entre temps et rebase votre travail sur le sommet de l'historique du serveur :

	$ git svn rebase
	       M      README.txt
	r80 = ff829ab914e8775c7c025d741beb3d523ee30bc4 (trunk)
	First, rewinding head to replay your work on top of it...
	Applying: first user change

À présent, tout votre travail se trouve au delà de l'historique du serveur et vous pouvez effectivement réaliser un `dcommit` :

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      README.txt
	Committed r81
	       M      README.txt
	r81 = 456cbe6337abe49154db70106d1836bc1332deed (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

Il est important de se souvenir qu'à la différence de Git qui requiert une fusion avec les modifications distantes non présentes localement avant de pouvoir pousser, `git svn` ne vous y contraint que si vos modifications provoquent un conflit.
Si une autre personne pousse une modification à un fichier et que vous poussez une modification à un autre fichier, votre `dcommit` passera sans problème :

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      configure.ac
	Committed r84
	       M      autogen.sh
	r83 = 8aa54a74d452f82eee10076ab2584c1fc424853b (trunk)
	       M      configure.ac
	r84 = cdbac939211ccb18aa744e581e46563af5d962d0 (trunk)
	W: d2f23b80f67aaaa1f6f5aaef48fce3263ac71a92 and refs/remotes/trunk differ, \
	  using rebase:
	:100755 100755 efa5a59965fbbb5b2b0a12890f1b351bb5493c18 \
	  015e4c98c482f0fa71e4d5434338014530b37fa6 M   autogen.sh
	First, rewinding head to replay your work on top of it...
	Nothing to do.

Il faut s'en souvenir car le résultat de ces actions est un état du dépôt qui n'existait pas sur aucun des ordinateurs quand vous avez poussé.
Si les modifications sont incompatibles mais ne créent pas de conflits, vous pouvez créer des défauts qui seront très difficiles à diagnostiquer.
C'est une grande différence avec un serveur Git — dans Git, vous pouvez tester complètement l'état du projet sur votre système client avant de le publier, tandis qu'avec SVN, vous ne pouvez jamais être totalement certain que les états avant et après validation sont identiques.

Vous devrez aussi lancer cette commande pour tirer les modifications depuis le serveur Subversion, même si vous n'êtes pas encore prêt à valider.
Vous pouvez lancer `git svn fetch` pour tirer les nouveaux commits, mais `git svn rebase` tire non seulement les commits distants mais rebase aussi vos commit locaux.

	$ git svn rebase
	       M      generate_descriptor_proto.sh
	r82 = bd16df9173e424c6f52c337ab6efa7f7643282f1 (trunk)
	First, rewinding head to replay your work on top of it...
	Fast-forwarded master to refs/remotes/trunk.

Lancer `git svn rebase` de temps en temps vous assure que votre travail est toujours synchronisé avec le serveur.
Vous devrez cependant vous assurer que votre copie de travail est propre quand vous la lancez.
Si vous avez des modifications locales, il vous faudra soit remiser votre travail, soit valider temporairement vos modificaiton avant de lancer `git svn rebase`, sinon la commande s'arrêtera si elle détecte que le rebasage provoquerait un conflit de fusion.

### Le problème avec les branches Git ###

Après vous être habitué à la manière de faire avec Git, vous souhaiterez sûrement créer des branches thématiques, travailler dessus, puis les fusionner.
Si vous poussez sur un serveur Subversion via git svn, vous souhaiterez à chaque fois rebaser votre travail sur une branche unique au lieu de fusionner les branches ensemble.
La raison principale en est que Subversion gère un historique linéaire et ne gère pas les fusions comme Git y excelle.
De ce fait, git svn suit seulement le premier parent lorsqu'il convertit les instantanés en commits Subversion.

Supposons que votre historique ressemble à ce qui suit. Vous avez créé une branche `experience`, avez réalisé deux validations puis les avez fusionnées dans master.
Lors du `dcommit`, vous voyez le résultat suivant :

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      CHANGES.txt
	Committed r85
	       M      CHANGES.txt
	r85 = 4bfebeec434d156c36f2bcd18f4e3d97dc3269a2 (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk
	COPYING.txt: locally modified
	INSTALL.txt: locally modified
	       M      COPYING.txt
	       M      INSTALL.txt
	Committed r86
	       M      INSTALL.txt
	       M      COPYING.txt
	r86 = 2647f6b86ccfcaad4ec58c520e369ec81f7c283c (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

Lancer `dcommit` sur une branche avec un historique fusionné fonctionne correctement, à l'exception que l'examen de l'historique du projet Git indique qu'il n'a réécrit aucun des commits réalisés sur la branche `experience`, mais que toutes les modifications introduites apparaissent dans la version SVN de l'unique commit de fusion.

Quand quelqu'un d'autre clone ce travail, tout ce qu'il voit, c'est le commit de la fusion avec toutes les modifications injectées en une fois.
Il ne voit aucune information sur son origine ni sur sa date de validation.

### Les embranchements dans Subversion ###

La gestion de branches dans Subversion n'a rien à voir avec celle de Git.
Évitez de l'utiliser tant que possible.
Cependant vous pouvez créer des branches et valider dessus dans Subversion en utilisant git svn.

#### Créer une nouvelle branche SVN ####

Pour créer une nouvelle branche dans Subversion, vous pouvez utiliser la commande `git svn branch [nom de la branche]` :

	Copying file:///tmp/test-svn/trunk at r87 to file:///tmp/test-svn/branches/opera...
	Found possible branch point: file:///tmp/test-svn/trunk => \
	  file:///tmp/test-svn/branches/opera, 87
	Found branch parent: (opera) 1f6bfe471083cbca06ac8d4176f7ad4de0d62e5f
	Following parent with do_switch
	Successfully followed parent
	r89 = 9b6fe0b90c5c9adf9165f700897518dbc54a7cbf (opera)

Cela est équivalent à la commande Subversion `svn copy trunk branches/opera` et réalise l'opération sur le serveur Subversion.
Remarquez que cette commande ne vous bascule pas sur cette branche ; si vous validez, le commit s'appliquera à `trunk` et non à la branche `opera`.

### Basculer de branche active ###

Git devine la branche cible des dcommits en se référant au sommet des branches Subversion dans votre historique — vous ne devriez en avoir qu'un et celui-ci devrait être le dernier possédant un `git-svn-id` dans l'historique actuel de votre branche.

Si vous souhaitez travailler simultanément sur plusieurs branches, vous pouvez régler vos branches locales pour que le `dcommit` arrive sur une branche Subversion spécifique en les démarrant sur le commit de cette branche importé depuis Subversion.
Si vous voulez une branche `opera` sur laquelle travailler séparément, vous pouvez lancer

	$ git branch opera remotes/opera

À présent, si vous voulez fusionner votre branche `opera` dans `trunk` (votre branche `master`), vous pouvez le faire en réalisant un `git merge` normal.
Mais vous devez préciser un message de validation descriptif (via `-m`), ou la fusion indiquera simplement "Merge branch opera" au lieu d'un message plus informatif.

Souvenez-vous que bien que vous utilisez `git merge` qui facilitera l'opération de fusion par rapport à Subversion (Git détectera automatiquement l'ancêtre commun pour la fusion), ce n'est pas un commit de fusion normal de Git.
Vous devrez pousser ces données finalement sur le serveur Subversion qui ne sait pas tracer les commits possédant plusieurs parents.
Donc, ce sera un commit unique qui englobera toutes les modifications de l'autre branche.
Après avoir fusionné une branche dans une autre, il est difficile de continuer à travailler sur cette branche, comme vous le feriez normalement dans Git.
La commande `dcommit` qui a été lancée efface toute information sur la branche qui a été fusionnée, ce qui rend faux tout calcul d'antériorité pour la fusion.
`dcommit` fait ressembler le résultat de `git merge` à celui de `git merge --squash`.
Malheureusement, il n'y a pas de moyen efficace de remédier à ce problème — Subversion ne stocke pas cette information et vous serez toujours contraints par ses limitations si vous l'utilisez comme serveur.
Pour éviter ces problèmes, le mieux reste d'effacer la branche locale (dans notre cas, `opera`) dès qu'elle a été fusionnée dans `trunk`.

### Les commandes Subversion ###

La boîte à outil `git svn` fournit des commandes de nature à faciliter la transition vers Git en mimant certaines commandes disponibles avec Subversion.
Voici quelques commandes qui vous fournissent les mêmes services que Subversion.

#### L'historique dans le style Subversion ####

Si vous êtes habitué à Subversion, vous pouvez lancer `git svn log` pour visualiser votre historique dans un format SVN :

	$ git svn log
	------------------------------------------------------------------------
	r87 | schacon | 2009-05-02 16:07:37 -0700 (Sat, 02 May 2009) | 2 lines

	autogen change

	------------------------------------------------------------------------
	r86 | schacon | 2009-05-02 16:00:21 -0700 (Sat, 02 May 2009) | 2 lines

	Merge branch 'experiment'

	------------------------------------------------------------------------
	r85 | schacon | 2009-05-02 16:00:09 -0700 (Sat, 02 May 2009) | 2 lines
	
	updated the changelog
	
Deux choses importantes à connaître sur `git svn log` : premièrement, à la différence de la commande réelle `svn log` qui interroge le serveur, cette commande fonctionne hors connexion ; deuxièmement, elle ne montre que les commits qui ont été effectivement remontés sur le serveur Subversion.
Les commits locaux qui n'ont pas encore été remontés via `dcommit` n'apparaissent pas, pas plus que ceux qui auraient été poussés sur le serveur par des tiers entre deux `git svn rebase`.
Cela donne plutôt le dernier état connu des commits sur le serveur Subversion.

#### Les annotations SVN ####

De la même manière que `git svn log` simule une commande `svn log` déconnectée, vous pouvez obtenir l'équivalent de `svn annotate` en lançant `git svn blame [FICHIER]`.
Le résultat ressemble à ceci :

	$ git svn blame README.txt 
	 2   temporal Protocol Buffers - Google's data interchange format
	 2   temporal Copyright 2008 Google Inc.
	 2   temporal http://code.google.com/apis/protocolbuffers/
	 2   temporal 
	22   temporal C++ Installation - Unix
	22   temporal =======================
	 2   temporal 
	79    schacon Committing in git-svn.
	78    schacon 
	 2   temporal To build and install the C++ Protocol Buffer runtime and the Protocol
	 2   temporal Buffer compiler (protoc) execute the following:
	 2   temporal 

Ici aussi, tous les commits locaux dans Git ou ceux poussé sur Subversion dans l'intervalle n'apparaissent pas.

#### L'information sur la serveur SVN ####

Vous pouvez aussi obtenir le même genre d'information que celle fournie par `svn info` en lançant `git svn info` :

	$ git svn info
	Path: .
	URL: https://schacon-test.googlecode.com/svn/trunk
	Repository Root: https://schacon-test.googlecode.com/svn
	Repository UUID: 4c93b258-373f-11de-be05-5f7a86268029
	Revision: 87
	Node Kind: directory
	Schedule: normal
	Last Changed Author: schacon
	Last Changed Rev: 87
	Last Changed Date: 2009-05-02 16:07:37 -0700 (Sat, 02 May 2009)

Comme `blame` et `log`, cette commande travaille hors connexion et n'est à jour qu'à la dernière date à laquelle vous avez communiqué avec le serveur Subversion.

#### Ignorer ce que Subversion ignore ####

Si vous clonez un dépôt Subversion contenant des propriétés  `svn:ignore`, vous souhaiterez sûrement paramétrer les fichiers `.gitignore` en correspondance pour vous éviter de valider accidentellement des fichiers interdits.
`git svn` dispose de deux commandes pour le faire.

La première est `git svn create-ignore` qui crée automatiquement pour vous les fichiers `.gitignore` prêts pour l'inclusion dans votre prochaine validation.

La seconde commande est `git svn show-ignore` qui affiche sur stdout les lignes nécessaires à un fichier `.gitignore` qu'il suffira de rediriger  dans votre fichier d'exclusion de projet :

	$ git svn show-ignore > .git/info/exclude

De cette manière, vous ne parsemez pas le projet de fichiers `.gitignore`.
C'est une option optimale si vous êtes le seul utilisateur de Git dans une équipe Subversion et que vos coéquipiers ne veulent pas voir de fichiers `.gitignore` dans le projet.

### Résumé sur Git-Svn ###

Les outils `git svn` sont utiles si vous êtes bloqué avec un serveur Subversion pour le moment ou si vous devez travailler dans un environnement de développement qui nécessite un serveur Subversion.
Il faut cependant les considérer comme une version tronquée de Git ou vous pourriez rencontrer des problèmes de conversion synonymes de troubles pour vous et vos collaborateurs.
Pour éviter tout problème, essayez de suivre les principes suivants :

* Garder un historique Git linéaire qui ne contient pas de commits de fusion issus de `git merge`. Rebasez tout travail réalisé en dehors de la branche principale sur celle-ci ; ne la fusionnez pas.
* Ne mettez pas en place et ne travaillez pas en parallèle sur un serveur Git. Si nécessaire, montez-en un pour accélérer les clones pour de nouveaux développeurs mais n'y poussez rien qui n'ait déjà une entrée `git-svn-id`. Vous devriez même y ajouter un crochet `pre-receive` qui vérifie la présence de `git-svn-id` dans chaque message de validation et rejette les remontées dont un des commits n'en contiendrait pas.

Si vous suivez ces principes, le travail avec un serveur Subversion peut être supportable.
Cependant, si le basculement sur un vrai serveur Git est possible, votre équipe y gagnera beaucoup.

## Migrer sur Git ##

Si vous avez une base de code dans un autre VCS et que vous avez décidé d'utiliser Git, vous devez migrer votre projet d'une manière ou d'une autre.
Ce chapitre traite d'outils d'import inclus dans Git avec des systèmes communs et démontre comment développer votre propre outil.

### Importer ###

You’ll learn how to import data from two of the bigger professionally used SCM systems — Subversion and Perforce — both because they make up the majority of users I hear of who are currently switching, and because high-quality tools for both systems are distributed with Git.

### Subversion ###

Si vous avez lu la section précédente sur l'utilisation de `git svn`, vous pouvez facilement utiliser ces instructions pour réaliser un `git svn clone` du dépôt.
Ensuite, arrêtez d'utiliser le serveur Subversion, poussez sur un nouveau serveur Git et commencez à l'utiliser.
Si vous voulez l'historique, vous pouvez l'obtenir aussi rapidement que vous pourrez tirer les données du serveur Subversion (ce qui peut prendre un certain temps).

Cependant, l'import n'est pas parfait ; et comme cela prend autant de temps, autant le faire bien.
Le premier problème est l'information d'auteur.
Dans Subversion, chaque personne qui valide dispose d'un compte sur le système qui est enregistré dans l'information de validation.
Les exemples de la section précédente montrent `schacon` à certains endroits, tels que la sortie de `blame` ou de `git svn log`.
Si vous voulez transposer ces données vers des données d'auteur au format Git, vous avez besoin d'une correspondance entre les utilisateurs Subversion et les auteurs Git.
Créez un fichier appelé `users.txt` contenant cette équivalence dans le format suivant :

	schacon = Scott Chacon <schacon@geemail.com>
	selse = Someo Nelse <selse@geemail.com>

Pour récupérer la liste des noms d'auteurs utilisés par SVN, vous pouvez utiliser la ligne suivante :

	$ svn log --xml | grep author | sort -u | perl -pe 's/.>(.?)<./$1 = /'

Cela génère une sortie au foramt XML — vous pouvez visualiser les auteurs, créer une liste unique puis éliminer l'XML.
Évidemment, cette ligne ne fonctionne que sur une machine disposant des commandes `grep`, `sort` et `perl`.
Ensuite, redirigez votre sortie dans votre fichier users.txt pour pouvoir y ajouter en correspondance les données équivalentes Git.

Vous pouvez alors fournir ce fichier à `git svn` pour l'aider à convertir les données d'auteur plus précisément.
Vous pouvez aussi indiquer à `git svn` de ne pas inclure les métadonnées que Subversion importe habituellement en passant l'option `--no-metadata` à la commande `clone` ou `init`.
Au final, votre commande d'import ressemble à ceci :

	$ git-svn clone http://my-project.googlecode.com/svn/ \
	      --authors-file=users.txt --no-metadata -s my_project

Maintenant, l'import depuis Subversion dans le répertoire `my_project` est plus présentable.
En lieu et place de commits qui ressemblent à ceci :

	commit 37efa680e8473b615de980fa935944215428a35a
	Author: schacon <schacon@4c93b258-373f-11de-be05-5f7a86268029>
	Date:   Sun May 3 00:12:22 2009 +0000

	    fixed install - go to trunk

	    git-svn-id: https://my-project.googlecode.com/svn/trunk@94 4c93b258-373f-11de-
	    be05-5f7a86268029

les commits ressemblent à ceci :

	commit 03a8785f44c8ea5cdb0e8834b7c8e6c469be2ff2
	Author: Scott Chacon <schacon@geemail.com>
	Date:   Sun May 3 00:12:22 2009 +0000

	    fixed install - go to trunk

Non seulement le champ auteur a meilleure mine, mais de plus le champ `git-svn-id` a disparu.

Il est encore nécessaire de faire un peu de ménage `post-import`. Déjà, vous devriez nettoyer les références bizarres que `git svn` crée.
Premièrement, déplacez les balises pour qu'elles soient de vraies balises plutôt que des branches distantes étranges, ensuite déplacez le reste des branches pour qu'elles deviennent locales.

Pour déplacer les balises et en faire de vraies balises Git, lancez

	$ cp -Rf .git/refs/remotes/tags/* .git/refs/tags/
	$ rm -Rf .git/refs/remotes/tags

Cela récupère les références déclarées comme branches distantes commençant par `tag/` et les transforme en vraies balises (légères).

Ensuite, déplacez le reste des références sous `refs/remotes` en branches locales :

	$ cp -Rf .git/refs/remotes/* .git/refs/heads/
	$ rm -Rf .git/refs/remotes

À présent, toutes les vieilles branches sont des vraies branches Git et toutes les vieilles balises sont de vraies balises Git.
La dernière activité consiste à ajouter votre nouveau serveur Git comme serveur distant et à y pousser votre projet transformé.
Pour pousser tout, y compris branches et balises, lancez :

	$ git push origin --all

Toutes vos données, branches et tags sont à présent disponibles sur le serveur Git comme import propre et naturel.

### Perforce ###

The next system you’ll look at importing from is Perforce. A Perforce importer is also distributed with Git, but only in the `contrib` section of the source code — it isn’t available by default like `git svn`. To run it, you must get the Git source code, which you can download from git.kernel.org:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/contrib/fast-import

In this `fast-import` directory, you should find an executable Python script named `git-p4`. You must have Python and the `p4` tool installed on your machine for this import to work. For example, you’ll import the Jam project from the Perforce Public Depot. To set up your client, you must export the P4PORT environment variable to point to the Perforce depot:

	$ export P4PORT=public.perforce.com:1666

Run the `git-p4 clone` command to import the Jam project from the Perforce server, supplying the depot and project path and the path into which you want to import the project:

	$ git-p4 clone //public/jam/src@all /opt/p4import
	Importing from //public/jam/src@all into /opt/p4import
	Reinitialized existing Git repository in /opt/p4import/.git/
	Import destination: refs/remotes/p4/master
	Importing revision 4409 (100%)

If you go to the `/opt/p4import` directory and run `git log`, you can see your imported work:

	$ git log -2
	commit 1fd4ec126171790efd2db83548b85b1bbbc07dc2
	Author: Perforce staff <support@perforce.com>
	Date:   Thu Aug 19 10:18:45 2004 -0800

	    Drop 'rc3' moniker of jam-2.5.  Folded rc2 and rc3 RELNOTES into
	    the main part of the document.  Built new tar/zip balls.

	    Only 16 months later.

	    [git-p4: depot-paths = "//public/jam/src/": change = 4409]

	commit ca8870db541a23ed867f38847eda65bf4363371d
	Author: Richard Geiger <rmg@perforce.com>
	Date:   Tue Apr 22 20:51:34 2003 -0800

	    Update derived jamgram.c

	    [git-p4: depot-paths = "//public/jam/src/": change = 3108]

You can see the `git-p4` identifier in each commit. It’s fine to keep that identifier there, in case you need to reference the Perforce change number later. However, if you’d like to remove the identifier, now is the time to do so — before you start doing work on the new repository. You can use `git filter-branch` to remove the identifier strings en masse:

	$ git filter-branch --msg-filter '
	        sed -e "/^\[git-p4:/d"
	'
	Rewrite 1fd4ec126171790efd2db83548b85b1bbbc07dc2 (123/123)
	Ref 'refs/heads/master' was rewritten

If you run `git log`, you can see that all the SHA-1 checksums for the commits have changed, but the `git-p4` strings are no longer in the commit messages:

	$ git log -2
	commit 10a16d60cffca14d454a15c6164378f4082bc5b0
	Author: Perforce staff <support@perforce.com>
	Date:   Thu Aug 19 10:18:45 2004 -0800

	    Drop 'rc3' moniker of jam-2.5.  Folded rc2 and rc3 RELNOTES into
	    the main part of the document.  Built new tar/zip balls.

	    Only 16 months later.

	commit 2b6c6db311dd76c34c66ec1c40a49405e6b527b2
	Author: Richard Geiger <rmg@perforce.com>
	Date:   Tue Apr 22 20:51:34 2003 -0800

	    Update derived jamgram.c

Your import is ready to push up to your new Git server.

### A Custom Importer ###

If your system isn’t Subversion or Perforce, you should look for an importer online — quality importers are available for CVS, Clear Case, Visual Source Safe, even a directory of archives. If none of these tools works for you, you have a rarer tool, or you otherwise need a more custom importing process, you should use `git fast-import`. This command reads simple instructions from stdin to write specific Git data. It’s much easier to create Git objects this way than to run the raw Git commands or try to write the raw objects (see Chapter 9 for more information). This way, you can write an import script that reads the necessary information out of the system you’re importing from and prints straightforward instructions to stdout. You can then run this program and pipe its output through `git fast-import`.

To quickly demonstrate, you’ll write a simple importer. Suppose you work in current, you back up your project by occasionally copying the directory into a time-stamped `back_YYYY_MM_DD` backup directory, and you want to import this into Git. Your directory structure looks like this:

	$ ls /opt/import_from
	back_2009_01_02
	back_2009_01_04
	back_2009_01_14
	back_2009_02_03
	current

In order to import a Git directory, you need to review how Git stores its data. As you may remember, Git is fundamentally a linked list of commit objects that point to a snapshot of content. All you have to do is tell `fast-import` what the content snapshots are, what commit data points to them, and the order they go in. Your strategy will be to go through the snapshots one at a time and create commits with the contents of each directory, linking each commit back to the previous one.

As you did in the "An Example Git Enforced Policy" section of Chapter 7, we’ll write this in Ruby, because it’s what I generally work with and it tends to be easy to read. You can write this example pretty easily in anything you’re familiar with — it just needs to print the appropriate information to stdout. And, if you are running on Windows, this means you'll need to take special care to not introduce carriage returns at the end your lines — git fast-import is very particular about just wanting line feeds (LF) not the carriage return line feeds (CRLF) that Windows uses.

To begin, you’ll change into the target directory and identify every subdirectory, each of which is a snapshot that you want to import as a commit. You’ll change into each subdirectory and print the commands necessary to export it. Your basic main loop looks like this:

	last_mark = nil

	# loop through the directories
	Dir.chdir(ARGV[0]) do
	  Dir.glob("*").each do |dir|
	    next if File.file?(dir)

	    # move into the target directory
	    Dir.chdir(dir) do 
	      last_mark = print_export(dir, last_mark)
	    end
	  end
	end

You run `print_export` inside each directory, which takes the manifest and mark of the previous snapshot and returns the manifest and mark of this one; that way, you can link them properly. "Mark" is the `fast-import` term for an identifier you give to a commit; as you create commits, you give each one a mark that you can use to link to it from other commits. So, the first thing to do in your `print_export` method is generate a mark from the directory name:

	mark = convert_dir_to_mark(dir)

You’ll do this by creating an array of directories and using the index value as the mark, because a mark must be an integer. Your method looks like this:

	$marks = []
	def convert_dir_to_mark(dir)
	  if !$marks.include?(dir)
	    $marks << dir
	  end
	  ($marks.index(dir) + 1).to_s
	end

Now that you have an integer representation of your commit, you need a date for the commit metadata. Because the date is expressed in the name of the directory, you’ll parse it out. The next line in your `print_export` file is

	date = convert_dir_to_date(dir)

where `convert_dir_to_date` is defined as

	def convert_dir_to_date(dir)
	  if dir == 'current'
	    return Time.now().to_i
	  else
	    dir = dir.gsub('back_', '')
	    (year, month, day) = dir.split('_')
	    return Time.local(year, month, day).to_i
	  end
	end

That returns an integer value for the date of each directory. The last piece of meta-information you need for each commit is the committer data, which you hardcode in a global variable:

	$author = 'Scott Chacon <schacon@example.com>'

Now you’re ready to begin printing out the commit data for your importer. The initial information states that you’re defining a commit object and what branch it’s on, followed by the mark you’ve generated, the committer information and commit message, and then the previous commit, if any. The code looks like this:

	# print the import information
	puts 'commit refs/heads/master'
	puts 'mark :' + mark
	puts "committer #{$author} #{date} -0700"
	export_data('imported from ' + dir)
	puts 'from :' + last_mark if last_mark

You hardcode the time zone (-0700) because doing so is easy. If you’re importing from another system, you must specify the time zone as an offset. 
The commit message must be expressed in a special format:

	data (size)\n(contents)

The format consists of the word data, the size of the data to be read, a newline, and finally the data. Because you need to use the same format to specify the file contents later, you create a helper method, `export_data`:

	def export_data(string)
	  print "data #{string.size}\n#{string}"
	end

All that’s left is to specify the file contents for each snapshot. This is easy, because you have each one in a directory — you can print out the `deleteall` command followed by the contents of each file in the directory. Git will then record each snapshot appropriately:

	puts 'deleteall'
	Dir.glob("**/*").each do |file|
	  next if !File.file?(file)
	  inline_data(file)
	end

Note:	Because many systems think of their revisions as changes from one commit to another, fast-import can also take commands with each commit to specify which files have been added, removed, or modified and what the new contents are. You could calculate the differences between snapshots and provide only this data, but doing so is more complex — you may as well give Git all the data and let it figure it out. If this is better suited to your data, check the `fast-import` man page for details about how to provide your data in this manner.

The format for listing the new file contents or specifying a modified file with the new contents is as follows:

	M 644 inline path/to/file
	data (size)
	(file contents)

Here, 644 is the mode (if you have executable files, you need to detect and specify 755 instead), and inline says you’ll list the contents immediately after this line. Your `inline_data` method looks like this:

	def inline_data(file, code = 'M', mode = '644')
	  content = File.read(file)
	  puts "#{code} #{mode} inline #{file}"
	  export_data(content)
	end

You reuse the `export_data` method you defined earlier, because it’s the same as the way you specified your commit message data. 

The last thing you need to do is to return the current mark so it can be passed to the next iteration:

	return mark

NOTE: If you are running on Windows you'll need to make sure that you add one extra step. As metioned before, Windows uses CRLF for new line characters while git fast-import expects only LF. To get around this problem and make git fast-import happy, you need to tell ruby to use LF instead of CRLF:

	$stdout.binmode

That’s it. If you run this script, you’ll get content that looks something like this:

	$ ruby import.rb /opt/import_from 
	commit refs/heads/master
	mark :1
	committer Scott Chacon <schacon@geemail.com> 1230883200 -0700
	data 29
	imported from back_2009_01_02deleteall
	M 644 inline file.rb
	data 12
	version two
	commit refs/heads/master
	mark :2
	committer Scott Chacon <schacon@geemail.com> 1231056000 -0700
	data 29
	imported from back_2009_01_04from :1
	deleteall
	M 644 inline file.rb
	data 14
	version three
	M 644 inline new.rb
	data 16
	new version one
	(...)

To run the importer, pipe this output through `git fast-import` while in the Git directory you want to import into. You can create a new directory and then run `git init` in it for a starting point, and then run your script:

	$ git init
	Initialized empty Git repository in /opt/import_to/.git/
	$ ruby import.rb /opt/import_from | git fast-import
	git-fast-import statistics:
	---------------------------------------------------------------------
	Alloc'd objects:       5000
	Total objects:           18 (         1 duplicates                  )
	      blobs  :            7 (         1 duplicates          0 deltas)
	      trees  :            6 (         0 duplicates          1 deltas)
	      commits:            5 (         0 duplicates          0 deltas)
	      tags   :            0 (         0 duplicates          0 deltas)
	Total branches:           1 (         1 loads     )
	      marks:           1024 (         5 unique    )
	      atoms:              3
	Memory total:          2255 KiB
	       pools:          2098 KiB
	     objects:           156 KiB
	---------------------------------------------------------------------
	pack_report: getpagesize()            =       4096
	pack_report: core.packedGitWindowSize =   33554432
	pack_report: core.packedGitLimit      =  268435456
	pack_report: pack_used_ctr            =          9
	pack_report: pack_mmap_calls          =          5
	pack_report: pack_open_windows        =          1 /          1
	pack_report: pack_mapped              =       1356 /       1356
	---------------------------------------------------------------------

As you can see, when it completes successfully, it gives you a bunch of statistics about what it accomplished. In this case, you imported 18 objects total for 5 commits into 1 branch. Now, you can run `git log` to see your new history:

	$ git log -2
	commit 10bfe7d22ce15ee25b60a824c8982157ca593d41
	Author: Scott Chacon <schacon@example.com>
	Date:   Sun May 3 12:57:39 2009 -0700

	    imported from current

	commit 7e519590de754d079dd73b44d695a42c9d2df452
	Author: Scott Chacon <schacon@example.com>
	Date:   Tue Feb 3 01:00:00 2009 -0700

	    imported from back_2009_02_03

There you go — a nice, clean Git repository. It’s important to note that nothing is checked out — you don’t have any files in your working directory at first. To get them, you must reset your branch to where `master` is now:

	$ ls
	$ git reset --hard master
	HEAD is now at 10bfe7d imported from current
	$ ls
	file.rb  lib

You can do a lot more with the `fast-import` tool — handle different modes, binary data, multiple branches and merging, tags, progress indicators, and more. A number of examples of more complex scenarios are available in the `contrib/fast-import` directory of the Git source code; one of the better ones is the `git-p4` script I just covered.

## Summary ##

You should feel comfortable using Git with Subversion or importing nearly any existing repository into a new Git one without losing data. The next chapter will cover the raw internals of Git so you can craft every single byte, if need be.
