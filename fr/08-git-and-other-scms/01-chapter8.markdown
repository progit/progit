# Git et les autres systèmes #

Le monde n'est pas parfait.
Habituellement, vous ne pouvez pas basculer immédiatement sous Git tous les projets que vous pourriez rencontrer.
Quelques fois, vous êtes bloqué sur un projet utilisant un autre VCS et très souvent ce système s'avère être Subversion.
Dans la première partie de ce chapitre, nous traiterons de `git svn`, la passerelle bidirectionnelle de Git pour Subversion.

À un moment, vous voudrez convertir votre projet à Git.
La seconde partie de ce chapitre traite la migration de votre projet dans Git : depuis Subversion, puis depuis Perforce et enfin par un script d'import personnalisé pour les cas non-standards.

## Git et Subversion ##

Aujourd'hui, la majorité des projets de développement libre et un grand nombre de projets dans les sociétés utilisent Subversion pour gérer leur code source.
C'est le VCS libre le plus populaire depuis une bonne décennie.
Il est aussi très similaire à CVS qui a été le grand chef des gestionnaires de source avant lui.

Une des grandes fonctionnalités de Git est sa passerelle vers Subversion, `git svn`.
Cet outil vous permet d'utiliser Git comme un client valide d'un serveur Subversion pour que vous puissiez utiliser les capacités de Git en local puis poussez sur le serveur Subversion comme si vous utilisiez Subversion localement.
Cela signifie que vous pouvez réaliser localement les embranchements et les fusions, utiliser l'index, utiliser le rebasage et la sélection de *commits*, etc, tandis que vos collaborateurs continuent de travailler avec leurs méthodes ancestrales et obscures.
C'est une bonne manière d'introduire Git dans un environnement professionnel et d'aider vos collègues développeurs à devenir plus efficaces tandis que vous ferez pression pour une modification de l'infrastructure vers l'utilisation massive de Git.
La passerelle Subversion n'est que la première dose vers la drogue du monde des DVCS.

### git svn ###

La commande de base dans Git pour toutes les commandes de passerelle est `git svn`.
Vous préfixerez tout avec cette paire de mots.
Les possibilités étant nombreuses, nous traiterons des plus communes pendant que nous détaillerons quelques petits modes de gestion.

Il est important de noter que lorsque vous utilisez `git svn`, vous interagissez avec Subversion qui est un système bien moins sophistiqué que Git.
Bien que vous puissiez simplement réaliser des branches locales et les fusionner, il est généralement conseillé de conserver votre historique le plus linéaire possible en rebasant votre travail et en évitant des activités telles qu'interagir dans le même temps avec un dépôt Git distant.

Ne réécrivez pas votre historique avant d'essayer de pousser à nouveau et ne poussez pas en parallèle dans un dépôt Git pour collaborer avec vos collègues développant avec Git.
Subversion ne supporte qu'un historique linéaire et l'égarer est très facile.
Si vous travaillez avec une équipe dont certains membres utilisent SVN et d'autres utilisent Git, assurez-vous que tout le monde n'utilise que le serveur SVN pour collaborer, cela vous rendra service.

### Installation ###

Pour montrer cette fonctionnalité, il faut un serveur SVN sur lequel vous avez des droits en écriture.
Pour copier ces exemples, faites une copie inscriptible de mon dépôt de test.
Dans cette optique, vous pouvez utiliser un outil appelé `svnsync` qui est livré avec les versions les plus récentes  de Subversion — il devrait être distribué avec les versions à partir de 1.4.
Pour ces tests, j'ai créé sur Google code un nouveau dépôt Subversion qui était une copie partielle du projet `protobuf` qui est un outil qui encode les données structurées pour une transmission par réseau.

En préparation, créez un nouveau dépôt local Subversion :

	$ mkdir /tmp/test-svn
	$ svnadmin create /tmp/test-svn

Ensuite, autorisez tous les utilisateurs à changer les revprops — le moyen le plus simple consiste à ajouter un script pre-revprop-change qui rend toujours 0 :

	$ cat /tmp/test-svn/hooks/pre-revprop-change
	#!/bin/sh
	exit 0;
	$ chmod +x /tmp/test-svn/hooks/pre-revprop-change

Vous pouvez à présent synchroniser ce projet sur votre machine locale en lançant `svnsync init` avec les dépôts source et cible.

	$ svnsync init file:///tmp/test-svn http://progit-example.googlecode.com/svn/

Cela initialise les propriétés nécessaires à la synchronisation.
Vous pouvez ensuite cloner le code en lançant :

	$ svnsync sync file:///tmp/test-svn
	Committed revision 1.
	Copied properties for revision 1.
	Committed revision 2.
	Copied properties for revision 2.
	Committed revision 3.
	...

Bien que cette opération ne dure que quelques minutes, si vous essayez de copier le dépôt original sur un autre dépôt distant au lieu d'un dépôt local, le processus durera près d'une heure, en dépit du fait qu'il y a moins de 100 *commits*.
Subversion doit cloner révision par révision puis pousser vers un autre dépôt — c'est ridiculement inefficace mais c'est la seule possibilité.

### Démarrage ###

Avec des droits en écriture sur un dépôt Subversion, vous voici prêt à expérimenter une méthode typique.
Commençons par la commande `git svn clone` qui importe un dépôt Subversion complet dans un dépôt Git local.
Souvenez-vous que si vous importez depuis un dépôt Subversion hébergé sur Internet, il faut remplacer l'URL `file://tmp/test-svn` ci-dessous par l'URL de votre dépôt Subversion :

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
Le projet de test ne contient que 75 *commits* et la taille du code n'est pas extraordinaire, ce qui prend juste quelques minutes.
Cependant, Git doit extraire chaque version, une par une et les valider individuellement.
Pour un projet contenant des centaines ou des milliers de *commits*, cela peut prendre littéralement des heures ou même des jours à terminer.

La partie `-T trunk -b branches -t tags` indique à Git que ce dépôt Subversion suit les conventions de base en matière d'embranchement et d'étiquetage.
Si vous nommez votre trunk, vos branches ou vos étiquettes différemment, vous pouvez modifier ces options.
Comme cette organisation est la plus commune, ces options peuvent être simplement remplacées par `-s` qui signifie structure standard.
La commande suivante est équivalente :

	$ git svn clone file:///tmp/test-svn -s

À présent, vous disposez d'un dépôt Git valide qui a importé vos branches et vos étiquettes :

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

Pour un dépôt Git normal, cela ressemble plus à ceci :

	$ git show-ref
	83e38c7a0af325a9722f2fdc56b10188806d83a1 refs/heads/master
	3e15e38c198baac84223acfc6224bb8b99ff2281 refs/remotes/gitserver/master
	0a30dd3b0c795b80212ae723640d4e5d48cabdff refs/remotes/origin/master
	25812380387fdd55f916652be4881c6f11600d6f refs/remotes/origin/testing

Ici, vous disposez de deux serveurs distants : un nommé `gitserver` avec une branche `master` et un autre nommé `origin` avec deux branches `master` et `testing`.

Remarquez comme dans cet exemple de références distantes importées via `git svn`, les étiquettes sont ajoutées comme des branches distantes et non comme des vraies étiquettes Git.
Votre importation Subversion indique plutôt qu'il a un serveur distant appelé `tags` présentant des branches.

### Valider en retour sur le serveur Subversion ###

Comme vous disposez d'un dépôt en état de marche, vous pouvez commencer à travailler sur le projet et pousser vos *commits* en utilisant efficacement Git comme client SVN.
Si vous éditez un des fichiers et le validez, vous créez un *commit* qui existe localement dans Git mais qui n'existe pas sur le serveur Subversion :

	$ git commit -am 'Ajout d'instructions pour git-svn dans LISEZMOI'
	[master 97031e5] Ajout d'instructions pour git-svn dans LISEZMOI
	 1 files changed, 1 insertions(+), 1 deletions(-)

Ensuite, vous avez besoin de pousser vos modifications en amont.
Remarquez que cela modifie la manière de travailler par rapport à Subversion — vous pouvez réaliser plusieurs validations en mode déconnecté pour ensuite les pousser toutes en une fois sur le serveur Subversion.
Pour pousser sur un serveur Subversion, il faut lancer la commande `git svn dcommit` :

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      README.txt
	Committed r79
	       M      README.txt
	r79 = 938b1a547c2cc92033b74d32030e86468294a5c8 (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

Cette commande rassemble tous les *commits* que vous avez validés par dessus le code du serveur Subversion et réalise un *commit* sur le serveur pour chacun, puis réécrit l'historique Git local pour y ajouter un identifiant unique.
Cette étape est à souligner car elle signifie que toutes les sommes de contrôle SHA-1 de vos *commits* locaux ont changé.
C'est en partie pour cette raison que c'est une idée très périlleuse de vouloir travailler dans le même temps avec des serveurs Git distants.
L'examen du dernier *commit* montre que le nouveau `git-svn-id` a été ajouté :

	$ git log -1
	commit 938b1a547c2cc92033b74d32030e86468294a5c8
	Author: schacon <schacon@4c93b258-373f-11de-be05-5f7a86268029>
	Date:   Sat May 2 22:06:44 2009 +0000

	    Ajout d'instructions pour git-svn dans LISEZMOI

	    git-svn-id: file:///tmp/test-svn/trunk@79 4c93b258-373f-11de-be05-5f7a86268029

Remarquez que la somme de contrôle SHA qui commençait par `97031e5` quand vous avez validé commence à présent par `938b1a5`.
Si vous souhaitez pousser à la fois sur un serveur Git et un serveur Subversion, il faut obligatoirement pousser (`dcommit`) sur le serveur Subversion en premier, car cette action va modifier vos données des *commits*.

### Tirer des modifications ###

Quand vous travaillez avec d'autres développeurs, il arrive à certains moments que ce qu'un développeur a poussé provoque un conflit lorsqu'un autre voudra pousser à son tour.
Cette modification sera rejetée jusqu'à ce qu'elle soit fusionnée.
Dans `git svn`, cela ressemble à ceci :

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	Merge conflict during commit: Your file or directory 'README.txt' is probably \
	out-of-date: resource out of date; try updating at /Users/schacon/libexec/git-\
	core/git-svn line 482

Pour résoudre cette situation, vous pouvez lancer la commande `git svn rebase` qui tire depuis le serveur toute modification apparue entre temps et rebase votre travail sur le sommet de l'historique du serveur :

	$ git svn rebase
	       M      README.txt
	r80 = ff829ab914e8775c7c025d741beb3d523ee30bc4 (trunk)
	First, rewinding head to replay your work on top of it...
	Applying: first user change

À présent, tout votre travail se trouve au-delà de l'historique du serveur et vous pouvez effectivement réaliser un `dcommit` :

	$ git svn dcommit
	Committing to file:///tmp/test-svn/trunk ...
	       M      README.txt
	Committed r81
	       M      README.txt
	r81 = 456cbe6337abe49154db70106d1836bc1332deed (trunk)
	No changes between current HEAD and refs/remotes/trunk
	Resetting to the latest refs/remotes/trunk

Il est important de se souvenir qu'à la différence de Git qui requiert une fusion avec les modifications distantes non présentes localement avant de pouvoir pousser, `git svn` ne vous y contraint que si vos modifications provoquent un conflit.
Si une autre personne pousse une modification à un fichier et que vous poussez une modification à un autre fichier, votre `dcommit` passera sans problème :

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
Vous pouvez lancer `git svn fetch` pour tirer les nouveaux *commits*, mais `git svn rebase` tire non seulement les *commits* distants mais rebase aussi vos *commit* locaux.

	$ git svn rebase
	       M      generate_descriptor_proto.sh
	r82 = bd16df9173e424c6f52c337ab6efa7f7643282f1 (trunk)
	First, rewinding head to replay your work on top of it...
	Fast-forwarded master to refs/remotes/trunk.

Lancer `git svn rebase` de temps en temps vous assure que votre travail est toujours synchronisé avec le serveur.
Vous devrez cependant vous assurer que votre copie de travail est propre quand vous la lancez.
Si vous avez des modifications locales, il vous faudra soit remiser votre travail, soit valider temporairement vos modifications avant de lancer `git svn rebase`, sinon la commande s'arrêtera si elle détecte que le rebasage provoquerait un conflit de fusion.

### Le problème avec les branches Git ###

Après vous être habitué à la manière de faire avec Git, vous souhaiterez sûrement créer des branches thématiques, travailler dessus, puis les fusionner.
Si vous poussez sur un serveur Subversion via `git svn`, vous souhaiterez à chaque fois rebaser votre travail sur une branche unique au lieu de fusionner les branches ensemble.
La raison principale en est que Subversion gère un historique linéaire et ne gère pas les fusions comme Git y excelle.
De ce fait, `git svn` suit seulement le premier parent lorsqu'il convertit les instantanés en *commits* Subversion.

Supposons que votre historique ressemble à ce qui suit. Vous avez créé une branche `experience`, avez réalisé deux validations puis les avez fusionnées dans `master`.
Lors du `dcommit`, vous voyez le résultat suivant :

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

Lancer `dcommit` sur une branche avec un historique fusionné fonctionne correctement, à l'exception que l'examen de l'historique du projet Git indique qu'il n'a réécrit aucun des *commits* réalisés sur la branche `experience`, mais que toutes les modifications introduites apparaissent dans la version SVN de l'unique *commit* de fusion.

Quand quelqu'un d'autre clone ce travail, tout ce qu'il voit, c'est le *commit* de la fusion avec toutes les modifications injectées en une fois.
Il ne voit aucune information sur son origine ni sur sa date de validation.

### Les embranchements dans Subversion ###

La gestion de branches dans Subversion n'a rien à voir avec celle de Git.
Évitez de l'utiliser tant que possible.
Cependant vous pouvez créer des branches et valider dessus dans Subversion en utilisant `git svn`.

#### Créer une nouvelle branche SVN ####

Pour créer une nouvelle branche dans Subversion, vous pouvez utiliser la commande `git svn branch [nom de la branche]` :

	Copying file:///tmp/test-svn/trunk at r87 to file:///tmp/test-svn/branches/opera...
	Found possible branch point: file:///tmp/test-svn/trunk => \
	  file:///tmp/test-svn/branches/opera, 87
	Found branch parent: (opera) 1f6bfe471083cbca06ac8d4176f7ad4de0d62e5f
	Following parent with do_switch
	Successfully followed parent
	r89 = 9b6fe0b90c5c9adf9165f700897518dbc54a7cbf (opera)

Cela est équivalent à la commande Subversion `svn copy trunk branches/opera` et réalise l'opération sur le serveur Subversion.
Remarquez que cette commande ne vous bascule pas sur cette branche ; si vous validez, le *commit* s'appliquera à `trunk` et non à la branche `opera`.

### Basculer de branche active ###

Git devine la branche cible des `dcommits` en se référant au sommet des branches Subversion dans votre historique — vous ne devriez en avoir qu'un et celui-ci devrait être le dernier possédant un `git-svn-id` dans l'historique actuel de votre branche.

Si vous souhaitez travailler simultanément sur plusieurs branches, vous pouvez régler vos branches locales pour que le `dcommit` arrive sur une branche Subversion spécifique en les démarrant sur le *commit* de cette branche importée depuis Subversion.
Si vous voulez une branche `opera` sur laquelle travailler séparément, vous pouvez lancer :

	$ git branch opera remotes/opera

À présent, si vous voulez fusionner votre branche `opera` dans `trunk` (votre branche `master`), vous pouvez le faire en réalisant un `git merge` normal.
Mais vous devez préciser un message de validation descriptif (via `-m`), ou la fusion indiquera simplement « Merge branch opera » au lieu d'un message plus informatif.

Souvenez-vous que bien que vous utilisez `git merge` qui facilitera l'opération de fusion par rapport à Subversion (Git détectera automatiquement l'ancêtre commun pour la fusion), ce n'est pas un *commit* de fusion normal de Git.
Vous devrez pousser ces données finalement sur le serveur Subversion qui ne sait pas tracer les *commits* possédant plusieurs parents.
Donc, ce sera un *commit* unique qui englobera toutes les modifications de l'autre branche.
Après avoir fusionné une branche dans une autre, il est difficile de continuer à travailler sur cette branche, comme vous le feriez normalement dans Git.
La commande `dcommit` qui a été lancée efface toute information sur la branche qui a été fusionnée, ce qui rend faux tout calcul d'antériorité pour la fusion.
`dcommit` fait ressembler le résultat de `git merge` à celui de `git merge --squash`.
Malheureusement, il n'y a pas de moyen efficace de remédier à ce problème — Subversion ne stocke pas cette information et vous serez toujours contraints par ses limitations si vous l'utilisez comme serveur.
Pour éviter ces problèmes, le mieux reste d'effacer la branche locale (dans notre cas, `opera`) dès qu'elle a été fusionnée dans `trunk`.

### Les commandes Subversion ###

La boîte à outil `git svn` fournit des commandes de nature à faciliter la transition vers Git en mimant certaines commandes disponibles avec Subversion.
Voici quelques commandes qui vous fournissent les mêmes services que Subversion.

#### L'historique dans le style Subversion ####

Si vous êtes habitué à Subversion, vous pouvez lancer `git svn log` pour visualiser votre historique dans un format SVN :

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

Deux choses importantes à connaître sur `git svn log` : premièrement, à la différence de la commande réelle `svn log` qui interroge le serveur, cette commande fonctionne hors connexion ; deuxièmement, elle ne montre que les *commits* qui ont été effectivement remontés sur le serveur Subversion.
Les *commits* locaux qui n'ont pas encore été remontés via `dcommit` n'apparaissent pas, pas plus que ceux qui auraient été poussés sur le serveur par des tiers entre deux `git svn rebase`.
Cela donne plutôt le dernier état connu des *commits* sur le serveur Subversion.

#### Les annotations SVN ####

De la même manière que `git svn log` simule une commande `svn log` déconnectée, vous pouvez obtenir l'équivalent de `svn annotate` en lançant `git svn blame [fichier]`.
Le résultat ressemble à ceci :

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

Ici aussi, tous les *commits* locaux dans Git ou ceux poussé sur Subversion dans l'intervalle n'apparaissent pas.

#### L'information sur le serveur SVN ####

Vous pouvez aussi obtenir le même genre d'information que celle fournie par `svn info` en lançant `git svn info` :

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

La seconde commande est `git svn show-ignore` qui affiche sur `stdout` les lignes nécessaires à un fichier `.gitignore` qu'il suffira de rediriger  dans votre fichier d'exclusion de projet :

	$ git svn show-ignore > .git/info/exclude

De cette manière, vous ne parsemez pas le projet de fichiers `.gitignore`.
C'est une option optimale si vous êtes le seul utilisateur de Git dans une équipe Subversion et que vos coéquipiers ne veulent pas voir de fichiers `.gitignore` dans le projet.

### Résumé sur Git-Svn ###

Les outils `git svn` sont utiles si vous êtes bloqué avec un serveur Subversion pour le moment ou si vous devez travailler dans un environnement de développement qui nécessite un serveur Subversion.
Il faut cependant les considérer comme une version tronquée de Git ou vous pourriez rencontrer des problèmes de conversion synonymes de troubles pour vous et vos collaborateurs.
Pour éviter tout problème, essayez de suivre les principes suivants :

* Garder un historique Git linéaire qui ne contient pas de *commits* de fusion issus de `git merge`. Rebasez tout travail réalisé en dehors de la branche principale sur celle-ci ; ne la fusionnez pas.
* Ne mettez pas en place et ne travaillez pas en parallèle sur un serveur Git. Si nécessaire, montez-en un pour accélérer les clones pour de nouveaux développeurs mais n'y poussez rien qui n'ait déjà une entrée `git-svn-id`. Vous devriez même y ajouter un crochet `pre-receive` qui vérifie la présence de `git-svn-id` dans chaque message de validation et rejette les remontées dont un des *commits* n'en contiendrait pas.

Si vous suivez ces principes, le travail avec un serveur Subversion peut être supportable.
Cependant, si le basculement sur un vrai serveur Git est possible, votre équipe y gagnera beaucoup.

## Migrer sur Git ##

Si vous avez une base de code dans un autre VCS et que vous avez décidé d'utiliser Git, vous devez migrer votre projet d'une manière ou d'une autre.
Ce chapitre traite d'outils d'import inclus dans Git avec des systèmes communs et démontre comment développer votre propre outil.

### Importer ###

Nous allons détailler la manière d'importer des données à partir de deux des plus grands systèmes SCM utilisés en milieu professionnel, Subversion et Perforce, pour les raisons combinées qu'ils regroupent la majorité des utilisateurs que je connais migrer vers Git et que des outils de grande qualité pour ces deux systèmes sont distribués avec Git.

### Subversion ###

Si vous avez lu la section précédente sur l'utilisation de `git svn`, vous pouvez facilement utiliser ces instructions pour réaliser un `git svn clone` du dépôt.
Ensuite, arrêtez d'utiliser le serveur Subversion, poussez sur un nouveau serveur Git et commencez à l'utiliser.
Si vous voulez l'historique, vous pouvez l'obtenir aussi rapidement que vous pourrez tirer les données du serveur Subversion (ce qui peut prendre un certain temps).

Cependant, l'import n'est pas parfait ; et comme cela prend autant de temps, autant le faire bien.
Le premier problème est l'information d'auteur.
Dans Subversion, chaque personne qui valide dispose d'un compte sur le système qui est enregistré dans l'information de validation.
Les exemples de la section précédente montrent `schacon` à certains endroits, tels que la sortie de `blame` ou de `git svn log`.
Si vous voulez transposer ces données vers des données d'auteur au format Git, vous avez besoin d'une correspondance entre les utilisateurs Subversion et les auteurs Git.
Créez un fichier appelé `users.txt` contenant cette équivalence dans le format suivant :

	schacon = Scott Chacon <schacon@geemail.com>
	selse = Someo Nelse <selse@geemail.com>

Pour récupérer la liste des noms d'auteurs utilisés par SVN, vous pouvez utiliser la ligne suivante :

	$ svn log ^/ --xml | grep -P "^<author" | sort -u | \
	      perl -pe 's/<author>(.*?)<\/author>/$1 = /' > users.txt

Cela génère une sortie au format XML — vous pouvez visualiser les auteurs, créer une liste unique puis éliminer l'XML.
Évidemment, cette ligne ne fonctionne que sur une machine disposant des commandes `grep`, `sort` et `perl`.
Ensuite, redirigez votre sortie dans votre fichier users.txt pour pouvoir y ajouter en correspondance les données équivalentes Git.

Vous pouvez alors fournir ce fichier à `git svn` pour l'aider à convertir les données d'auteur plus précisément.
Vous pouvez aussi indiquer à `git svn` de ne pas inclure les méta-données que Subversion importe habituellement en passant l'option `--no-metadata` à la commande `clone` ou `init`.
Au final, votre commande d'import ressemble à ceci :

	$ git svn clone http://mon-projet.googlecode.com/svn/ \
	      --authors-file=users.txt --no-metadata -s my_project

Maintenant, l'import depuis Subversion dans le répertoire `my_project` est plus présentable.
En lieu et place de *commits* qui ressemblent à ceci :

	commit 37efa680e8473b615de980fa935944215428a35a
	Author: schacon <schacon@4c93b258-373f-11de-be05-5f7a86268029>
	Date:   Sun May 3 00:12:22 2009 +0000

	    fixed install - go to trunk

	    git-svn-id: https://my-project.googlecode.com/svn/trunk@94 4c93b258-373f-11de-
	    be05-5f7a86268029

les *commits* ressemblent à ceci :

	commit 03a8785f44c8ea5cdb0e8834b7c8e6c469be2ff2
	Author: Scott Chacon <schacon@geemail.com>
	Date:   Sun May 3 00:12:22 2009 +0000

	    fixed install - go to trunk

Non seulement le champ auteur a meilleure mine, mais de plus, le champ `git-svn-id` a disparu.

Il est encore nécessaire de faire un peu de ménage `post-import`. Déjà, vous devriez nettoyer les références bizarres que `git svn` crée.
Premièrement, déplacez les étiquettes pour qu'elles soient de vraies étiquettes plutôt que des branches distantes étranges, ensuite déplacez le reste des branches pour qu'elles deviennent locales.

Pour déplacer les étiquettes et en faire de vraies étiquettes Git, lancez :

	$ git for-each-ref refs/remotes/tags | cut -d / -f 4- | grep -v @ | while read tagname; do
	git tag "$tagname" "tags/$tagname"; git branch -r -d "tags/$tagname";
	done

Cela récupère les références déclarées comme branches distantes commençant par `tags/` et les transforme en vraies étiquettes (légères).

Ensuite, déplacez le reste des références sous `refs/remotes` en branches locales :

	$ git for-each-ref refs/remotes | cut -d / -f 3- | grep -v @ | while read branchname; do
	git branch "$branchname" "refs/remotes/$branchname"; git branch -r -d "$branchname";
	done

À présent, toutes les vieilles branches sont des vraies branches Git et toutes les vieilles étiquettes sont de vraies étiquettes Git.
La dernière activité consiste à ajouter votre nouveau serveur Git comme serveur distant et à y pousser votre projet transformé.
Pour pousser le tout, y compris branches et étiquettes, lancez :

	$ git push origin --tags

Toutes vos données, branches et tags sont à présent disponibles sur le serveur Git comme import propre et naturel.

### Perforce ###

L'autre système duquel on peut souhaiter importer les données est Perforce.
Un outil d'import Perforce est aussi distribué avec Git.
Si votre version de Git est antérieures à 1.7.11, celui-ci n'est disponible que dans la section `contrib` du code source.
Dans ce dernier cas, pour le lancer, il vous faut récupérer le code source de Git que vous pouvez télécharger à partir de `git.kernel.org` :

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/contrib/fast-import

Dans ce répertoire `fast-import`, vous devriez trouver un script exécutable Python appelé `git-p4`.
Python et l'outil `p4` doivent être installés sur votre machine pour que cet import fonctionne.
Par exemple, nous importerons le projet Jam depuis le Perforce Public Depot.
Pour installer votre client, vous devez exporter la variable d'environnement `P4PORT` qui pointe sur le dépôt Perforce :

	$ export P4PORT=public.perforce.com:1666

Lancez la commande `git-p4 clone` pour importer le projet Jam depuis le serveur Perforce, en fournissant le dépôt avec le chemin du projet et le chemin dans lequel vous souhaitez importer le projet :

	$ git-p4 clone //public/jam/src@all /opt/p4import
	Importing from //public/jam/src@all into /opt/p4import
	Reinitialized existing Git repository in /opt/p4import/.git/
	Import destination: refs/remotes/p4/master
	Importing revision 4409 (100%)

Si vous vous rendez dans le répertoire  `/opt/p4import` et lancez la commande `git log`, vous pouvez examiner votre projet importé :

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

Vous pouvez visualiser l'identifiant `git-p4` de chaque *commit*.
Il n'y a pas de problème à garder cet identifiant ici, au cas où vous auriez besoin de référencer dans l'avenir le numéro de modification Perforce.
Cependant, si vous souhaitez supprimer l'identifiant, c'est le bon moment, avant de commencer à travailler avec le nouveau dépôt.
Vous pouvez utiliser `git filter-branch` pour faire un retrait en masse des chaînes d'identifiant :

	$ git filter-branch --msg-filter '
	        sed -e "/^\[git-p4:/d"
	'
	Rewrite 1fd4ec126171790efd2db83548b85b1bbbc07dc2 (123/123)
	Ref 'refs/heads/master' was rewritten

Si vous lancez `git log`, vous vous rendez compte que toutes les sommes de contrôle SHA-1 des *commits* ont changé, mais aussi que plus aucune chaîne `git-p4` n'apparaît dans les messages de validation :

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

Votre import est fin prêt pour être poussé sur un nouveau serveur Git.

### Un outil d'import personnalisé ###

Si votre système n'est ni Subversion, ni Perforce, vous devriez rechercher sur Internet un outil d'import spécifique — il en existe de bonne qualité pour CVS, Clear Case, Visual Source Safe ou même pour un répertoire d'archives.
Si aucun de ses outils ne fonctionne pour votre cas, que vous ayez un outil plus rare ou que vous ayez besoin d'un mode d'import personnalisé, `git fast-import` peut être la solution.
Cette commande lit de simples instructions sur `stdin` pour écrire les données spécifiques Git.
C'est tout de même plus simple pour créer les objets Git que de devoir utiliser les commandes Git brutes ou d'essayer d'écrire directement les objets (voir chapitre 9 pour plus d'information).
De cette façon, vous écrivez un script d'import qui lit les informations nécessaires depuis le système d'origine et affiche des instructions directes sur `stdout`.
Vous pouvez alors simplement lancer ce programme et rediriger sa sortie dans `git fast-import`.

Pour démontrer rapidement cette fonctionnalité, nous allons écrire un script simple d'import.
Supposons que vous travailliez dans `en_cours` et que vous fassiez des sauvegardes de temps en temps dans des répertoires nommés avec la date `back_AAAA_MM_JJ` et que vous souhaitiez importer ceci dans Git.
Votre structure de répertoire ressemble à ceci :

	$ ls /opt/import_depuis
	back_2009_01_02
	back_2009_01_04
	back_2009_01_14
	back_2009_02_03
	en_cours

Pour importer un répertoire dans Git, vous devez savoir comment Git stocke ses données.
Comme vous pouvez vous en souvenir, Git est à la base une liste chaînée d'objets de *commits* qui pointent sur un instantané de contenu.
Tout ce qu'il y a à faire donc, et d'indiquer à `fast-import` ce que sont les instantanés de contenu, quelles données de *commit* pointent dessus et l'ordre dans lequel ils s'enchaînent.
La stratégie consistera à parcourir les instantanés un par un et à créer des *commits* avec le contenu de chaque répertoire, en le reliant à son prédécesseur.

Comme déjà fait dans la section « Un exemple de règle appliquée par Git » du chapitre 7, nous l'écrirons en Ruby parce que c'est le langage avec lequel je travaille en général et qu'il est assez facile à lire.
Vous pouvez facilement retranscrire cet exemple dans votre langage de prédilection, la seule contrainte étant qu'il doit pouvoir afficher les informations appropriées sur `stdout`.
Si vous travaillez sous Windows, cela signifie que vous devrez faire particulièrement attention à ne pas introduire de retour chariot à la fin de vos lignes.
`git fast-import` n'accepte particulièrement que les sauts de ligne (line feed LF) et pas les retour chariot saut de ligne (CRLF) utilisés par Windows.

Pour commencer, déplaçons-nous dans le répertoire cible et identifions chaque sous-répertoire, chacun représentant un instantané que vous souhaitez importer en tant que *commit*.
Nous visiterons chaque sous-répertoire et afficherons les commandes nécessaires à son export.
La boucle principale ressemble à ceci :

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

Dans chaque répertoire, nous lançons `print_export` qui prend le manifeste et la marque de l'instantané précédent et retourne le manifeste et la marque de l'actuel ; de cette manière, vous pouvez les chaîner correctement.
« Marque » est le terme de `fast-import` pour nommer un identifiant que vous donnez à un *commit*.
Au fur et à mesure de la création des *commits*, vous leur attribuez une marque individuelle qui pourra être utilisée pour y faire référence depuis d'autres *commits*.
La première chose à faire dans `print_export` est donc de générer une marque à partir du nom du répertoire :

	mark = convert_dir_to_mark(dir)

Cela sera réalisé en créant un tableau des répertoires et en utilisant l'indice comme marque, celle-ci devant être un nombre entier.
Votre méthode ressemble à ceci :

	$marks = []
	def convert_dir_to_mark(dir)
	  if !$marks.include?(dir)
	    $marks << dir
	  end
	  ($marks.index(dir) + 1).to_s
	end

Après une représentation entière de votre *commit*, vous avez besoin d'une date pour les méta-données du *commit*.
La date est présente dans le nom du répertoire, alors analysons-le.
La ligne suivante du fichier `print_export` est donc :

	date = convert_dir_to_date(dir)

où `convert_dir_to_date` est défini comme :

	def convert_dir_to_date(dir)
	  if dir == 'en_cours'
	    return Time.now().to_i
	  else
	    dir = dir.gsub('back_', '')
	    (year, month, day) = dir.split('_')
	    return Time.local(year, month, day).to_i
	  end
	end

Elle retourne une nombre entier pour la date de chaque répertoire.
La dernière partie des méta-informations nécessaires à chaque *commit* est l'information du validateur qui sera stockée en dur dans une variable globale :

	$author = 'Scott Chacon <schacon@example.com>'

Nous voilà prêt à commencer à écrire les informations de *commit* du script d'import.
La première information indique qu'on définit un objet *commit* et la branche sur laquelle il se trouve, suivi de la marque qui a été générée, l'information du validateur et le message de validation et enfin le *commit* précédent, s'il existe.
Le code ressemble à ceci :

	# print the import information
	puts 'commit refs/heads/master'
	puts 'mark :' + mark
	puts "committer #{$author} #{date} -0700"
	export_data('imported from ' + dir)
	puts 'from :' + last_mark if last_mark

Nous codons en dur le fuseau horaire (-0700) car c'est simple.
Si vous importez depuis un autre système, vous devez spécifier le fuseau horaire comme un décalage.
Le message de validation doit être exprimé dans un format spécial :

	data (taille)\n(contenu)

Le format est composé du mot « data », la taille des données à lire, un caractère saut de ligne, et finalement les données.
Ce format est réutilisé plus tard, alors autant créer une méthode auxiliaire, `export_data` :

	def export_data(string)
	  print "data #{string.size}\n#{string}"
	end

Il reste seulement à spécifier le contenu en fichiers de chaque instantané.
C'est facile, car vous les avez dans le répertoire.
Git va alors enregistrer de manière appropriée chaque instantané :

	puts 'deleteall'
	Dir.glob("**/*").each do |file|
	  next if !File.file?(file)
	  inline_data(file)
	end

Note:   Comme de nombreux systèmes conçoivent leurs révisions comme des modifications d'un *commit* à l'autre, fast-import accepte aussi avec chaque *commit* des commandes qui spécifient quels fichiers ont été ajoutés, effacés ou modifiés et ce que sont les nouveaux contenus.
Vous pourriez calculer les différences entre chaque instantané et ne fournir que ces données, mais cela est plus complexe — vous pourriez tout aussi bien fournir à Git toutes les données et lui laisser faire le travail.
Si c'est ce qui convient mieux à vos données, référez-vous à la page de manuel de `fast-import` pour savoir comment fournir les données de cette façon.

Le format pour lister le contenu d'un nouveau fichier ou spécifier le nouveau contenu d'un fichier modifié est comme suit :

	M 644 inline chemin/du/fichier
	data (taille)
	(contenu du fichier)

Ici, 644 est le mode (si vous avez des fichiers exécutables, vous devez le détecter et spécifier plutôt 755), « inline » signifie que le contenu du fichier sera listé immédiatement après cette ligne.
La méthode `inline_data` ressemble à ceci :

	def inline_data(file, code = 'M', mode = '644')
	  content = File.read(file)
	  puts "#{code} #{mode} inline #{file}"
	  export_data(content)
	end

Nous réutilisons la méthode `export_data` définie plus tôt, car c'est la même méthode que pour spécifier les données du message de validation.

La dernière chose à faire consiste à retourner la marque actuelle pour pouvoir la passer à la prochaine itération :

	return mark

NOTE : si vous utilisez Windows, vous devrez vous assurer d'ajouter une étape supplémentaire.
Comme mentionné auparavant, Windows utilise CRLF comme caractère de retour à la ligne tandis que `git fast-import` s'attend à LF.
Pour contourner ce problème et satisfaire `git fast-import`, il faut forcer Ruby à utiliser LF au lieu de CRLF :

	$stdout.binmode

Et voilà.
Si vous lancez ce script, vous obtiendrez un contenu qui ressemble à ceci :

	$ ruby import.rb /opt/import_from
	commit refs/heads/master
	mark :1
	committer Scott Chacon <schacon@geemail.com> 1230883200 -0700
	data 29
	imported from back_2009_01_02deleteall
	M 644 inline file.rb
	data 12
	version two
	commit refs/heads/master
	mark :2
	committer Scott Chacon <schacon@geemail.com> 1231056000 -0700
	data 29
	imported from back_2009_01_04from :1
	deleteall
	M 644 inline file.rb
	data 14
	version three
	M 644 inline new.rb
	data 16
	new version one
	(...)

Pour lancer l'outil d'import, redirigez cette sortie dans `git fast-import` alors que vous vous trouvez dans le projet Git dans lequel vous souhaitez importer.
Vous pouvez créer un nouveau répertoire, puis l'initialiser avec `git init`, puis lancer votre script :

	$ git init
	Initialized empty Git repository in /opt/import_to/.git/
	$ ruby import.rb /opt/import_from | git fast-import
	git-fast-import statistics:
	---------------------------------------------------------------------
	Alloc'd objects:       5000
	Total objects:           18 (         1 duplicates                  )
	      blobs  :            7 (         1 duplicates          0 deltas)
	      trees  :            6 (         0 duplicates          1 deltas)
	      commits:            5 (         0 duplicates          0 deltas)
	      tags   :            0 (         0 duplicates          0 deltas)
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

Comme vous pouvez le remarquer, lorsqu'il se termine avec succès, il affiche quelques statistiques sur ses réalisations.
Dans ce cas, 18 objets ont été importés en 5 validations dans 1 branche.
À présent, `git log` permet de visualiser le nouvel historique :

	$ git log -2
	commit 10bfe7d22ce15ee25b60a824c8982157ca593d41
	Author: Scott Chacon <schacon@example.com>
	Date:   Sun May 3 12:57:39 2009 -0700

	    imported from en_cours

	commit 7e519590de754d079dd73b44d695a42c9d2df452
	Author: Scott Chacon <schacon@example.com>
	Date:   Tue Feb 3 01:00:00 2009 -0700

	    imported from back_2009_02_03

Et voilà !
Un joli dépôt Git tout propre.
Il est important de noter que rien n'a été extrait.
Présentement, aucun fichier n'est présent dans votre copie de travail.
Pour les avoir, vous devez réinitialiser votre branche sur `master` :

	$ ls
	$ git reset --hard master
	HEAD is now at 10bfe7d imported from en_cours
	$ ls
	file.rb  lib

Vous pouvez faire bien plus avec l'outil `fast-import` — gérer différents modes, les données binaires, les branches multiples et la fusion, les étiquettes, les indicateurs de progrès, et plus encore.
Des exemples de scénarios plus complexes sont disponibles dans le répertoire `contrib/fast-import` du code source Git ; un des meilleurs est justement le script `git-p4` traité précédemment.

## Résumé ##

Vous devriez être à l'aise à l'utilisation de Git avec Subversion ou pour l'import de quasiment toutes les sortes de dépôts dans un nouveau Git sans perdre de données.
Le chapitre suivant traitera des structures internes de Git pour vous permettre d'en retailler chaque octet, si le besoin s'en fait sentir.
