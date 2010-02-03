# Les trippes de Git #

Vous êtes peut-être arrivé à ce chapitre en en sautant certains chapitres ou après avoir parcouru tout le reste du livre. Dans tous les cas, c'est ici que l'on parle du fonctionnement interne et de la mise en œuvre de Git. Pour moi, leur apprentissage a été fondamental pour comprendre à quel point Git est utile et puissant, mais d'autres soutiennent que cela peut être source de confusion et être trop complexe pour les débutants. J'en ai donc fait le dernier chapitre de ce livre pour que vous puissiez le lire tôt ou plus tard lors de votre apprentissage. Je vous laisse le choix.

Maintenant que vous êtes ici, commençons. Tout d'abord, et même si ce n'est pas clair tout de suite, Git est fondamentalement un système de fichiers adressable par le contenu (content-addressable filesystem) avec l'interface utilisateur d'un VCS au-dessus. Vous en apprendrez plus à ce sujet dans quelques instants.

Aux premiers jours de Git (surtout avant la version 1.5), l'interface utilisateur était beaucoup plus complexe, car elle était centré sur le système de fichier plutôt que sur l'aspect VCS. Ces dernières années, l'interface
utilisateur a été peaufinée jusqu'à devenir aussi cohérente et facile à utiliser que n'importe quel autre système. Pour beaucoup, l'image du Git des début avec son interface utilisateur complexe et difficile à apprendre est toujours présente. La couche système de fichier adressable par le contenu est vraiment géniale et j'en parlerai dans ce chapitre. Ensuite, vous apprendrez les mécanismes de transport/transmission/communication ainsi que les tâches de maintenance d'un dépôt auxquelles vous serez confronté.

## Plomberie et porcelaine ##

Ce livre couvre l'utilisation de Git avec une trentaine de verbes comme `checkout`, `branch`, `remote` ... Mais, puisque Git était initialement une boîte à outils (N.d.T : Toolkit) pour VCS, plutôt d'un VCS complet et conviviale, il dispose de tout un ensemble d'action pour les tâches bas niveau qui étaient conçues pour être liées à la UNIX ou appelées depuis de scripts. Ces commandes sont dites commandes de "plomberie" (N.d.T "plumbing"), et les autres, plus conviviales sont appelées "porcelaines" (N.d.T : "porcelain").

Les huit premiers chapitres du livre concernent presque exclusivement les commandes porcelaine. Par contre, dans ce chapitre, vous serez principalement confrontés aux commandes de plomberie bas niveaux, car elles vous donnent accès au fonctionnement interne de Git et aident à montrer comment et pourquoi Git fonctionne comme il le fait. Ces commandes ne sont pas faites pour être utilisées à la main sur ligne de commandes, mais sont plutôt utilisées comme briques de bases pour écrire de nouveaux outils et scripts personnalisés.

Quand vous exécutez `git init` dans un répertoire nouveau ou existant, Git crée un répertoire `.git` qui contient presque tout ce que Git stocke et manipule. Si vous voulez sauvegarder ou cloner votre dépôt, copier ce seul répertoire suffira presque. Ce chapitre traite principalement de ce que contient ce répertoire. Voici à quoi il ressemble :

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

Vous y verrez sans doute d'autres fichiers, mais ceci est un dépôt qui vient d'être crée avec `git init`, et c'est ce que vous verrez par défaut. Le répertoire `branches` n'est pas utilisé par les versions récentes de Git, et le fichier `description` est utilisé uniquement par le programme GitWeb, il ne faut donc pas s'en soucier. Le fichier `config` contient les options de configuration spécifiques à votre projet, et le répertoire `info` contient un fichier listant les motifs que vous souhaitez ignorer et que vous ne voulez pas mettre dans un fichier .gitignore. Le répertoire `hooks` contient les scripts hooks??? (point d'ancrage/) côté client ou serveur, Ils sont décrits en détail dans le chapitre 6.

Il reste quatre éléments importants : les fichiers `HEAD` et `index`, ainsi que les répertoires `objects` et `refs`. Ce sont les parties centrales de Git. Le répertoire `objects` stocke le contenu de votre base de données, le répertoire `refs` stocke les pointeurs vers les objets commit de ces données (branches), le fichier `HEAD` pointe sur la branche qui est checked out???, et le fichier `index` est l'endroit où Git stocke les informations sur l'index???(staging area). Vous allez maintenant plonger en détail dans chacune de ces sections et voir comment Git fonctionne.

## Git Objects ##???

Git est un système de fichier adressable par le contenu. Super! Mais qu'est-ce que ça veut dire? Ça veut dire que le cœur de Git est un simple key-value data store???. Vous pouvez y insérer n'importe quel type de données???, et il vous retournera une clé que vous pourrez utiliser à n'importe quel moment pour récupérer ces données à nouveau. Pour illustrer cela, vous pouvez utiliser la commande de plomberie `hash-object`, qui prend des données, les stocke dans votre répertoire `.git`, puis retourne la clé sous laquelle les données sont stockées. Tout d'abord, créez un nouveau dépôt Git et vérifier que rien ne se trouve dans le répertoire `object` :

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

Git a initialisé le répertoire `objects` et y a crée les sous-répertoires `pack` et `info`, mais ils ne contiennent pas de fichier régulier. Maintenant, stockez du texte dans votre base donnée Git :

	$ echo 'test content' | git hash-object -w --stdin
	d670460b4b4aece5915caf5c68d12f560a9fe3e4

L'option `-w` spécifie à `hash-object` de stocker l'objet, sinon la commande dira seulement quelle serait la clé. `--stdin` spécifie à la commande de lire le contenu depuis stdin, sinon `hash-object` s'attend à un chemin vers un fichier. La sortie de la commande est une empreinte de 40 caractères. C'est l'empreinte SHA-1 : une somme de contrôle du contenu du fichier que vous stockez plus une en-tête, dont vous aurez bientôt des précision???. Voyez maintenant comment Git a stocké vos données :

	$ find .git/objects -type f 
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4

Vous pouvez voir un fichier dans le répertoire `objects`. C'est comme cela que Git stocke initialement du contenu : un fichier par contenu, nommé d'après la somme de contrôle SHA-1 du contenu et de son en-tête. Le sous-répertoire est nommé d'après les 2 premiers caractères de l'empreinte et le fichier d'après les 38 caractères restants.

Vous pouvez récupérer le contenu avec la commande `cat-file`. Cette commande est un peu le couteau suisse pour l'inspection des objets Git. Utiliser `-p` avec `cat-file` vous permet de connaître le type de contenu et de l'afficher clairement :

	$ git cat-file -p d670460b4b4aece5915caf5c68d12f560a9fe3e4
	test content

Vous pouvez maintenant ajouter du contenu à Git et le récupérer. Vous pouvez aussi faire ceci avec des fichiers. Par exemple, vous pouvez mettre en œuvre une gestion de version simple d'un fichier. D'abord, créez un nouveau fichier et enregistrez son contenu dans la base de données :

	$ echo 'version 1' > test.txt
	$ git hash-object -w test.txt 
	83baae61804e65cc73a7201a7252750c76066a30

Puis, modifiez le contenu du fichier, et enregistrez le à nouveau :

	$ echo 'version 2' > test.txt
	$ git hash-object -w test.txt 
	1f7a7a472abf3dd9643fd615f6da379c4acb3e3a

Votre base de données contient les 2 versions du fichier, ainsi que le premier contenu que vous avez stocké ici :

	$ find .git/objects -type f 
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4

Vous pouvez restaurer le fichier à sa première version :

	$ git cat-file -p 83baae61804e65cc73a7201a7252750c76066a30 > test.txt 
	$ cat test.txt 
	version 1

ou à sa seconde version :

	$ git cat-file -p 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a > test.txt 
	$ cat test.txt 
	version 2

Ce souvenir de la clé SHA-1 de chaque version de votre fichier n'est pas pratique. En plus, vous ne stockez pas le fichier lui-même, mais seulement son contenu, dans votre base. Ce type d'objets est appelé un blob. Git peut vous donnez le type d'objet de n'importe quel objet Git, étant donné sa clé SHA-1, avec `cat-file -t` :

	$ git cat-file -t 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a
	blob

### Objets Arbre ###???

Le prochain type que vous allez étudier est l'objet arbre (N.d.t 'tree'), il est une solution au problème de stockage d'un groupe de fichier. Git stocke du contenu de la manière, mais plus simplement, qu'un système de fichier UNIX. Tout le contenu est stocké comme des objets de type arbre ou blob : un arbre correspondant à un répertoire UNIX et un blob correspond à peu près à un i-noeud ou au contenu d'un fichier. Un unique arbre contient un ou plusieurs entrées de type arbre, chacune incluant un pointeur SHA-1 vers un blob, un sous-arbre (N.d.T sub-tree), ainsi que le mode???, le type et le nom de fichier. L'arbre le plus récent du projet simplegit pourrai ressembler, par exemple à ceci :

	$ git cat-file -p master^{tree}
	100644 blob a906cb2a4a904a152e80877d4088654daad0c859      README
	100644 blob 8f94139338f9404f26296befa88755fc2598c289      Rakefile
	040000 tree 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0      lib

La syntaxe `master^{tree}` spécifie l'objet arbre qui est pointé par le dernier commit de la branche `master`. Remarquez que le sous-répertoire `lib` n'est pas un blob, mais un pointeur vers un autre arbre :

	$ git cat-file -p 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0
	100644 blob 47c6340d6459e05787f644c2447d2595f5d3a54b      simplegit.rb

Conceptuellement, les données que Git stocke ressemblent à ceci Figure 9-1.

Insert 18333fig0901.png 
Figure 9-1. Une version simple du modèle des données de Git.

Vous pouvez créer votre propre arbre. Git crée habituellement un arbre à partir de l'état de la staging aren??? ou de l'index???. Pour créer un objet arbre, vous devez donc d'abord mettre en place un index en staging??? quelques fichiers. Pour créer un index contenant une entrée — la première version de votre fichier text.txt — vous pouvez utilisez la commande de plomberie `update-index`. Vous pouvez utiliser cette commande pour ajouter artificiellement une version plus ancienne à une nouvelle staging area. Vous devez utiliser les options `--add` car le fichier n'existe pas encore dans votre staging area (vous n'avez même pas encore mise en place une staging area) et `--cacheinfo` car le fichier que vous ajoutez n'est pas dans votre répertoire, mais est dans la base de données. Vous pouvez ensuite préciser le mode, SHA-1, et le nom de fichier :

	$ git update-index --add --cacheinfo 100644 \
	  83baae61804e65cc73a7201a7252750c76066a30 test.txt

Dans ce cas, vous précisez le mode `100644`, qui signifie que c'est un fichier normale. Les alternatives sont `100755`, qui signifie que c'est un exécutable et `120000`, qui précise que c'est un lien symbolique. Le concept de « mode » a été repris des mode UNIX, mais est beaucoup moins flexible : ces trois modes sont les seuls valides pour Git, pour les fichiers (blobs) (bien que d'autres modes soient utilisés pour les répertoires et sous-modules). 

Vous pouvez utiliser maintenant la commande `write-tree` pour écrire la staging area dans un objet arbre. L'option' `-w` n'est inutile ( appeler `write-tree` crée automatiquement un objet arbre à partir de l'état de l'index si cet arbre n'existe pas :

	$ git write-tree
	d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	$ git cat-file -p d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	100644 blob 83baae61804e65cc73a7201a7252750c76066a30      test.txt

Vous pouvez aussi vérifier que c'est un objet arbre :

	$ git cat-file -t d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	tree

Vous allez créer maintenant un nouvel arbre avec la seconde version de test.txt et un nouveau fichier :

	$ echo 'new file' > new.txt
	$ git update-index test.txt 
	$ git update-index --add new.txt 

Votre staging area??? contient maintenant la nouvelle version de test.txt ainsi qu'un nouveau fichier new.txt. Écrivez??? cet arbre (i.e. enregistrez l'état de la staging area??? ou de l'index dans un objet arbre) :

	$ git write-tree
	0155eb4229851634a0f03eb265b69f5a2d56f341
	$ git cat-file -p 0155eb4229851634a0f03eb265b69f5a2d56f341
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a      test.txt

Remarquez que cet arbre contiens des entrées pour les deux fichiers et que l'empreinte SHA de test.txt est l'empreinte de la « version 2 » de tout à l'heure (`1f7a7a`). Pour le plaisir, ajoutez le premier arbre à celui-ci, en tant que sous-répertoire. Vous pouvez maintenant lire???observer un arbre de votre staging area en exécutant `read-tree`. Dans ce cas, vous pouvez lire un arbre existant dans votre staging area comme??? un sous-arbre en utilisant l'option `--prefix` de `read-tree` :

	$ git read-tree --prefix=bak d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	$ git write-tree
	3c4e9cd789d88d8d89c1073707c3585e41b0e614
	$ git cat-file -p 3c4e9cd789d88d8d89c1073707c3585e41b0e614
	040000 tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579      bak
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a      test.txt

Si vous avez créer un répertoire de travail à partir du nouvel arbre que vous venez d'enregistrer, vous aurez deux fichiers en haut??? du répertoire de travail, ainsi qu'un sous-répertoire appelé `bak` qui contient la première version du fichier test.txt. Vous pouvez vous représenter les données que Git utilise pour ces structures comme sur la Figure 9-2.

Insert 18333fig0902.png 
Figure 9-2. Structure des données actuelles de Git???.

### Objets Commit ###

Vous avez trois arbres qui représentent??? différentes instantanés du projet que vous suivez, mais certains problèmes persiste : vous devez vous souvenir des valeurs des trois empreintes SHA-1 pour accéder aux instantanés. Vous n'avez pas non plus d'information sur qui a enregistré les instantanés, quand et pourquoi. Ce sont les informations élémentaires qu'un objet commit stocke pour vous.

Pour créer un objet commit, il suffit d'exécuter `commit-tree`, de préciser l'empreinte SHA-1 et quel objet commit, s'il y a en, le précède directement. Commencez avec le premier arbre que vous avez créé :

	$ echo 'first commit' | git commit-tree d8329f
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d

Vous pouvez voir votre nouvel objet commit avec `cat-file`:

	$ git cat-file -p fdf4fc3
	tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	author Scott Chacon <schacon@gmail.com> 1243040974 -0700
	committer Scott Chacon <schacon@gmail.com> 1243040974 -0700

	first commit

Le format d'un commit est simple : il contient le top-level??? arbre de l'instantané du projet à ce moment, les informations sur l'auteur et le commiteur qui sont extraite des variables de configuration `user.name` et `user.email`accompagné d'un horodatage, une ligne vide et le message de commit.

Ensuite, vous enregistrez les deux autres objets commit, chacun référençant le commit dont il est issu :

	$ echo 'second commit' | git commit-tree 0155eb -p fdf4fc3
	cac0cab538b970a37ea1e769cbbde608743bc96d
	$ echo 'third commit'  | git commit-tree 3c4e9c -p cac0cab
	1a410efbd13591db07496601ebc7a059dd55cfe9

Chacun des trois objets commit pointe sur un arbre instantané que vous avez créez. Curieusement, vous disposez maintenant d'un historique Git complet??? que vous pouvez visualiser avec la commande `git log`, si vous la lancez la lancez sur le SHA-1 du dernier commit :

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

Fantastique. Vous venez d'effectuer les opérations bas niveaux pour construire un historique Git sans avoir utilisé aucune des commandes haut niveau. C'est l'essence de ce que fait Git quand vous exécutez les commandes `git add` et `git commit`. Il stocke les blobs correspondant aux fichiers modifiés, met à jour l'index, écrit les arbres??? et ajoute les objets commit qui référence les top-level??? arbres venant juste avant eux. Ces trois objets principaux(le blob, l'arbre et le commit) sont initialement stockés dans des fichiers séparés du répertorier `.git/objects`. Voici tous les objets contenu dans le répertoire exemple, commenté avec ce qu'il contiennent :

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

Si vous suivez les pointeurs interne à ces objets, vous obtenez un graphe comme celui de la Figure 9-3.

Insert 18333fig0903.png 
Figure 9-3. Tous les objets de votre répertoire Git.

### Stockage des objets ###

On a parlé plutôt de l'en-tête présent avec le contenu.
Prenons un moment pour étudier la façon dont Git stocke les objets.
On verra comment stocker interactivement un objet Blob (ici, la chaîne "what is
up, doc?") avec le langage Ruby.
Vous pouvez démarrer Ruby en mode interactif avec la commande `irb`:

	$ irb
	>> content = "what is up, doc?"
	=> "what is up, doc?"

Git construit un en-tête qui commence avec le type de l'objet, ici un blob.
Ensuite, il ajoute un espace suivi de taille du contenu, et enfin un octet nul :

	>> header = "blob #{content.length}\0"
	=> "blob 16\000"

Git concatène l'en-tête avec le contenu original et calcule l'empreinte SHA-1 du nouveau contenu.
En Ruby, vous pouvez calculer l'empreinte SHA-1 d'une chaîne, en incluant la
bibliothèque « digest/SHA-1 » via la commande `require`, puis en appelant
`Digest::SHA1.hexdigest()` sur la chaîne :

	>> store = header + content
	=> "blob 16\000what is up, doc?"
	>> require 'digest/sha1'
	=> true
	>> sha1 = Digest::SHA1.hexdigest(store)
	=> "bd9dbf5aae1a3862dd1526723246b20206e5fc37"

Git compresse le nouveau contenu avec zlib, ce que vous pouvez faire avec la bibliothèque zlib.
Vous devez inclure la bibliothèque et exécuter `Zlib::Deflate.deflate()` sur le contenu :

	>> require 'zlib'
	=> true
	>> zlib_content = Zlib::Deflate.deflate(store)
	=> "x\234K\312\311OR04c(\317H,Q\310,V(-\320QH\311O\266\a\000_\034\a\235"

Enfin, vous enregistrerez le contenu compressé dans un objet sur le disque.
Vous déterminerez le chemin de l'objet que vous voulez enregistrer (les deux premiers
caractères de l'empreinte SHA-1 formeront le nom du sous-répertoires, et les 38
derniers formeront le nom du fichier dans ce répertoire).
En Ruby, on peut utiliser la fonction `FileUtils.mkdir_p()` pour créer un sous-répertoire s'il
n'existe pas.
Ensuite, ouvrez le fichier avec `File.open()` et enregistrez le contenu
compressé en appelant la fonction `write()` sur le fichier handle??? :

	>> path = '.git/objects/' + sha1[0,2] + '/' + sha1[2,38]
	=> ".git/objects/bd/9dbf5aae1a3862dd1526723246b20206e5fc37"
	>> require 'fileutils'
	=> true
	>> FileUtils.mkdir_p(File.dirname(path))
	=> ".git/objects/bd"
	>> File.open(path, 'w') { |f| f.write zlib_content }
	=> 32

C'est tout ! Vous venez juste de créer un objet Blob valide.
Tout les objets Git sont stockés de la même façon, mais avec des types différents : l'en-tête
commencera par « commit » ou « arbre » au lieu de la chaîne « blob ».
Bien que le contenu d'un blob puisse être presque n'importe quoi, le contenu  d'un commit ou
d'un arbre est formaté d'une façon particulière.

## Références  Git ##

On peut exécuter quelque chose comme `git log 1a410e` pour visualiser tout
l'historique, mais il faut se souvenir que `1a410e` est le dernier commit afin
de parcourir l'historique et trouver tout ces objets.
Vous avez besoin d'un fichier ayant un nom simple qui contienne l'empreinte
SHA-1 afin d'utiliser ce pointeur plutôt que l'empreinte SHA-1 elle-même.

Git les appelle ces pointeur des « références », ou « refs ».
On trouve ces fichiers contenant des empreintes SHA-1 dans le répertoire
`git/refs`.
Dans le projet actuel, ce répertoire ne contient aucun fichier, mais possède une
structure simple :

	$ find .git/refs
	.git/refs
	.git/refs/heads
	.git/refs/tags
	$ find .git/refs -type f
	$

Pour créer une nouvelle référence servant à ce souvenir du dernier commit, vous
pouvez simplement faire ceci :

	$ echo "1a410efbd13591db07496601ebc7a059dd55cfe9" > .git/refs/heads/master

Vous pouvez maintenant utiliser la head??? référence que vous venez de créer à
la place de l'empreinte SHA-1 dans vos commandes Git :

	$ git log --pretty=oneline  master
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Il n'est pas conseillé d'éditer directement les fichiers des références. Git
propose une manière sûre de mettre à jour une référence, c'est la commande
`update-ref` :

	$ git update-ref refs/heads/master 1a410efbd13591db07496601ebc7a059dd55cfe9

Dans Git, une branche est simplement ceci : a pointer ou référence sur le
dernier état (N.d.T « head ») d'un travail en cours???.
Pour créer une branche à partir du deuxième commit, vous pouvez faire ceci :

	$ git update-ref refs/heads/test cac0ca

Cette branche contiendra seulement le travail effectué jusqu'à ce commit :

	$ git log --pretty=oneline test
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

La base de donnée Git ressemble maintenant à quelque chose comme la Figure 9-4.

Insert 18333fig0904.png 
Figure 9-4. Le répertoire d'objet de Git y compris la référence au dernier
état???
de la branche.

Quand on exécute un commande comme  `git branch (nomdebranche)`, Git exécute
basiquement??? la commande `update-ref` pour ajouter l'empreinte SHA-1 du
dernier commit dans la référence que l'on veut créer.

### The HEAD ###

On peut se poser la question, quand on exécute `git branch (branchname)`,
comment Git peut avoir connaissance de l'empreinte SHA-1 du dernier commit ?
La réponse est dans le fichier HEAD.
Le fichier HEAD est une référence symbolique à la branche courante. Par
référence symbolique, j'entends que contrairement à une référence normal, elle
contient contient pas une empreinte SHA-1, mais plutôt un pointeur vers une
autre référence.
Si vous regardez ce fichier, vous devriez voir quelque chose comme ceci :

	$ cat .git/HEAD 
	ref: refs/heads/master

Si vous exécutez `git checkout test`, Git met à jour ce fichier, qui ressemblera
à ceci :

	$ cat .git/HEAD 
	ref: refs/heads/test

Quand vous exécutez `git commit`, il crée l'objet commit en spécifiant le parent
du commit comme étant l'empreinte SHA-1 pointé par la référence du fichier HEAD :

On peut éditer manuellement ce fichier, mais encore un fois, il existe une
commande plus pour le faire : `symbolic-ref`.
Vous pouvez lire le contenu de votre fichier HEAD avec cette commande :

	$ git symbolic-ref HEAD
	refs/heads/master

Vous pouvez aussi initialiser la valeur de HEAD :

	$ git symbolic-ref HEAD refs/heads/test
	$ cat .git/HEAD 
	ref: refs/heads/test

Vous ne pouvez pas initialiser une référence symbolique à une valeur non contenu
dans refs :

	$ git symbolic-ref HEAD test
	fatal: Refusing to point HEAD outside of refs/

### Tags ###

Nous venons de parcourir les trois types d'objet utilisé par Git, mais il existe
un quatrième objet.
L'objet tag ressemble beaucoup à un objet commit. Il contient un taggeur???, une
date, un message, et un pointeur.
La principale différence est que le tag pointe vers un commit plutôt qu'un
arbre.
Il est comme un référence à une branche, mais il ne bouge jamais : il pointe
toujours vers le même commit, lui donnant un nom plus sympathique.

Comme discuté??? au chapitre 2, il existe deux types de tags : annoté et léger.
Vous pouvez créer un tag léger comme ceci :

	$ git update-ref refs/tags/v1.0 cac0cab538b970a37ea1e769cbbde608743bc96d

Un tag léger est simplement léger ceci : une branche qui ne bouge??? jamais. Un
tag annoté est plus complexe.
Quand on crée un tag annoté, Git crée un objet tag, puis enregistre une
référence qui pointe vers lui plutôt que directement vers le commit.
Vous pouvez voir ceci en créant un tag annoté (`-a` spécifie que c'est un tag
annoté) :

	$ git tag -a v1.1 1a410efbd13591db07496601ebc7a059dd55cfe9 –m 'test tag'

Voici l'empreinte SHA-1 de l'objet créé :

	$ cat .git/refs/tags/v1.1 
	9585191f37f7b0fb9444f35a9bf50de191beadc2

Exécutez ensuite, la commande `cat-file` sur l'empreinte SHA-1 :

	$ git cat-file -p 9585191f37f7b0fb9444f35a9bf50de191beadc2
	object 1a410efbd13591db07496601ebc7a059dd55cfe9
	type commit
	tag v1.1
	tagger Scott Chacon <schacon@gmail.com> Sat May 23 16:48:58 2009 -0700

	test tag

Remarquez que le contenu??? de l'objet pointe vers l'empreinte SHA-1 du commit
que vous avez taggué. Remarquez qu'il n'est pas nécessaire qu'il pointe vers un
commit. On peut tagger n'importe quel objet. Par exemple, dans le code source de
Git, le mainteneur a ajouté ses clé GPG dans un blob et l'a taggé. Vous pouvez
voir la clé publique en exécutant

	$ git cat-file blob junio-gpg-pub

dans le code source de Git. Le noyau linux contient aussi un tag ne pointant pas
vers un commit : le premier tag crée pointe vers l'arbre initial crée lors de
l'importation du code source.

### Remotes??? ###

Le troisième type de références que l'on étudiera sont les références distantes
(N.d.T remotes).
Si l'on ajoute une référence distante et que l'on pousse des objets vers elle,
Git stocke la valeur que vous avez poussé en dernière vers cette référence pour
chaque branche dans le répertoire `refs/remotes`.
Vous pouvez par exemple, ajouter une référence distante nommée `origin` et y
pousser votre branche `master` :

	$ git remote add origin git@github.com:schacon/simplegit-progit.git
	$ git push origin master
	Counting objects: 11, done.
	Compressing objects: 100% (5/5), done.
	Writing objects: 100% (7/7), 716 bytes, done.
	Total 7 (delta 2), reused 4 (delta 1)
	To git@github.com:schacon/simplegit-progit.git
	   a11bef0..ca82a6d  master -> master

Ensuite, vous pouvez voir l'état de la branche `master` dans la référence
distante `origin` la dernière fois que vous avez communiqué avec le serveur en
regardant le fichier `refs/remotes/origin/master` :

	$ cat .git/refs/remotes/origin/master 
	ca82a6dff817ec66f44342007202690a93763949

Les références distantes diffèrent des branches (références `refs/heads`)
principalement parcequ'on ne peut pas les checked out???.
Git les modifie comme des marque-pages du dernier état de ces branches sur le
serveur.

## Packfiles ##

Revenons à la base de donnée d'objet de notre dépôt Git de test. Pour l'instant,
il contient 11 objets : 4 blobs, 3 arbres, 3 commits, et 1 tag :

	$ find .git/objects -type f
	.git/objects/01/55eb4229851634a0f03eb265b69f5a2d56f341 # arbre 2
	.git/objects/1a/410efbd13591db07496601ebc7a059dd55cfe9 # commit 3
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a # test.txt v2
	.git/objects/3c/4e9cd789d88d8d89c1073707c3585e41b0e614 # arbre 3
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30 # test.txt v1
	.git/objects/95/85191f37f7b0fb9444f35a9bf50de191beadc2 # tag
	.git/objects/ca/c0cab538b970a37ea1e769cbbde608743bc96d # commit 2
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4 # 'test content'
	.git/objects/d8/329fc1cc938780ffdd9f94e0d364e0ea74f579 # arbre 1
	.git/objects/fa/49b077972391ad58037050f2a75f74e3671e92 # new.txt
	.git/objects/fd/f4fc3344e67ab068f836878b6c4951e3b15f3d # commit 1

Git compresse le contenu de ces fichiers avec zlib, et on ne stocke pas grand
chose, et au final, tous ces fichiers occupent seulement 925 octets.
Ajoutons de plus gros contenu au dépôt pour montrer une foncitonnalité
intéressante de Git.
Ajoutez le fichier repo.rb de la bibliothèque Grit que vous avez manipuler plus
tôt. Il représente environ 12Ko de code source :

	$ curl http://github.com/mojombo/grit/raw/master/lib/grit/repo.rb > repo.rb
	$ git add repo.rb 
	$ git commit -m 'added repo.rb'
	[master 484a592] added repo.rb
	 3 files changed, 459 insertions(+), 2 deletions(-)
	 delete mode 100644 bak/test.txt
	 create mode 100644 repo.rb
	 rewrite test.txt (100%)

Si vous observez l'arbre qui en résulte, vous verrez l'empreinte SHA-1 du blob
contenant le fichier repo.rb :

	$ git cat-file -p master^{tree}
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e      repo.rb
	100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

Vous pouvez utlisez `git cat-file` pour connaitre la taille de l'objet :

	$ git cat-file -s 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e
	12898

Maintenant, modifiez le fichier un peu, et voyez ce qui arrive :

	$ echo '# testing' >> repo.rb 
	$ git commit -am 'modified repo a bit'
	[master ab1afef] modified repo a bit
	 1 files changed, 1 insertions(+), 0 deletions(-)

Regardez l'arbre créer par ce commit, et vous verrez quelquechose
d'interressant :

	$ git cat-file -p master^{tree}
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 05408d195263d853f09dca71d55116663690c27c      repo.rb
	100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

The blob is now a different blob, which means that although you added only a single line to the end of a 400-line file, Git stored that new content as a completely new object:

	$ git cat-file -s 05408d195263d853f09dca71d55116663690c27c
	12908

You have two nearly identical 12K objects on your disk. Wouldn’t it be nice if Git could store one of them in full but then the second object only as the delta between it and the first?

It turns out that it can. The initial format in which Git saves objects on disk is called a loose object format. However, occasionally Git packs up several of these objects into a single binary file called a packfile in order to save space and be more efficient. Git does this if you have too many loose objects around, if you run the `git gc` command manually, or if you push to a remote server. To see what happens, you can manually ask Git to pack up the objects by calling the `git gc` command:

	$ git gc
	Counting objects: 17, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (13/13), done.
	Writing objects: 100% (17/17), done.
	Total 17 (delta 1), reused 10 (delta 0)

If you look in your objects directory, you’ll find that most of your objects are gone, and a new pair of files has appeared:

	$ find .git/objects -type f
	.git/objects/71/08f7ecb345ee9d0084193f147cdad4d2998293
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4
	.git/objects/info/packs
	.git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.idx
	.git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.pack

The objects that remain are the blobs that aren’t pointed to by any commit — in this case, the "what is up, doc?" example and the "test content" example blobs you created earlier. Because you never added them to any commits, they’re considered dangling and aren’t packed up in your new packfile.

The other files are your new packfile and an index. The packfile is a single file containing the contents of all the objects that were removed from your filesystem. The index is a file that contains offsets into that packfile so you can quickly seek to a specific object. What is cool is that although the objects on disk before you ran the `gc` were collectively about 12K in size, the new packfile is only 6K. You’ve halved your disk usage by packing your objects.

How does Git do this? When Git packs objects, it looks for files that are named and sized similarly, and stores just the deltas from one version of the file to the next. You can look into the packfile and see what Git did to save space. The `git verify-pack` plumbing command allows you to see what was packed up:

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

The really nice thing about this is that it can be repacked at any time. Git will occasionally repack your database automatically, always trying to save more space. You can also manually repack at any time by running `git gc` by hand.

## The Refspec ##

Throughout this book, you’ve used simple mappings from remote branches to local references; but they can be more complex.
Suppose you add a remote like this:

	$ git remote add origin git@github.com:schacon/simplegit-progit.git

It adds a section to your `.git/config` file, specifying the name of the remote (`origin`), the URL of the remote repository, and the refspec for fetching:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/*:refs/remotes/origin/*

The format of the refspec is an optional `+`, followed by `<src>:<dst>`, where `<src>` is the pattern for references on the remote side and `<dst>` is where those references will be written locally. The `+` tells Git to update the reference even if it isn’t a fast-forward.

In the default case that is automatically written by a `git remote add` command, Git fetches all the references under `refs/heads/` on the server and writes them to `refs/remotes/origin/` locally. So, if there is a `master` branch on the server, you can access the log of that branch locally via

	$ git log origin/master
	$ git log remotes/origin/master
	$ git log refs/remotes/origin/master

They’re all equivalent, because Git expands each of them to `refs/remotes/origin/master`.

If you want Git instead to pull down only the `master` branch each time, and not every other branch on the remote server, you can change the fetch line to

	fetch = +refs/heads/master:refs/remotes/origin/master

This is just the default refspec for `git fetch` for that remote. If you want to do something one time, you can specify the refspec on the command line, too. To pull the `master` branch on the remote down to `origin/mymaster` locally, you can run

	$ git fetch origin master:refs/remotes/origin/mymaster

You can also specify multiple refspecs. On the command line, you can pull down several branches like so:

	$ git fetch origin master:refs/remotes/origin/mymaster \
	   topic:refs/remotes/origin/topic
	From git@github.com:schacon/simplegit
	 ! [rejected]        master     -> origin/mymaster  (non fast forward)
	 * [new branch]      topic      -> origin/topic

In this case, the  master branch pull was rejected because it wasn’t a fast-forward reference. You can override that by specifying the `+` in front of the refspec.

You can also specify multiple refspecs for fetching in your configuration file. If you want to always fetch the master and experiment branches, add two lines:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/master:refs/remotes/origin/master
	       fetch = +refs/heads/experiment:refs/remotes/origin/experiment

You can’t use partial globs in the pattern, so this would be invalid:

	fetch = +refs/heads/qa*:refs/remotes/origin/qa*

However, you can use namespacing to accomplish something like that. If you have a QA team that pushes a series of branches, and you want to get the master branch and any of the QA team’s branches but nothing else, you can use a config section like this:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/master:refs/remotes/origin/master
	       fetch = +refs/heads/qa/*:refs/remotes/origin/qa/*

If you have a complex workflow process that has a QA team pushing branches, developers pushing branches, and integration teams pushing and collaborating on remote branches, you can namespace them easily this way.

### Pushing Refspecs ###

It’s nice that you can fetch namespaced references that way, but how does the QA team get their branches into a `qa/` namespace in the first place? You accomplish that by using refspecs to push.

If the QA team wants to push their `master` branch to `qa/master` on the remote server, they can run

	$ git push origin master:refs/heads/qa/master

If they want Git to do that automatically each time they run `git push origin`, they can add a `push` value to their config file:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/*:refs/remotes/origin/*
	       push = refs/heads/master:refs/heads/qa/master

Again, this will cause a `git push origin` to push the local `master` branch to the remote `qa/master` branch by default.

### Deleting References ###

You can also use the refspec to delete references from the remote server by running something like this:

	$ git push origin :topic

Because the refspec is `<src>:<dst>`, by leaving off the `<src>` part, this basically says to make the topic branch on the remote nothing, which deletes it. 

## Transfer Protocols ##

Git can transfer data between two repositories in two major ways: over HTTP and via the so-called smart protocols used in the `file://`, `ssh://`, and `git://` transports. This section will quickly cover how these two main protocols operate.

### The Dumb Protocol ###

Git transport over HTTP is often referred to as the dumb protocol because it requires no Git-specific code on the server side during the transport process. The fetch process is a series of GET requests, where the client can assume the layout of the Git repository on the server. Let’s follow the `http-fetch` process for the simplegit library:

	$ git clone http://github.com/schacon/simplegit-progit.git

The first thing this command does is pull down the `info/refs` file. This file is written by the `update-server-info` command, which is why you need to enable that as a `post-receive` hook in order for the HTTP transport to work properly:

	=> GET info/refs
	ca82a6dff817ec66f44342007202690a93763949     refs/heads/master

Now you have a list of the remote references and SHAs. Next, you look for what the HEAD reference is so you know what to check out when you’re finished:

	=> GET HEAD
	ref: refs/heads/master

You need to check out the `master` branch when you’ve completed the process. 
At this point, you’re ready to start the walking process. Because your starting point is the `ca82a6` commit object you saw in the `info/refs` file, you start by fetching that:

	=> GET objects/ca/82a6dff817ec66f44342007202690a93763949
	(179 bytes of binary data)

You get an object back — that object is in loose format on the server, and you fetched it over a static HTTP GET request. You can zlib-uncompress it, strip off the header, and look at the commit content:

	$ git cat-file -p ca82a6dff817ec66f44342007202690a93763949
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

Next, you have two more objects to retrieve — `cfda3b`, which is the tree of content that the commit we just retrieved points to; and `085bb3`, which is the parent commit:

	=> GET objects/08/5bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	(179 bytes of data)

That gives you your next commit object. Grab the tree object:

	=> GET objects/cf/da3bf379e4f8dba8717dee55aab78aef7f4daf
	(404 - Not Found)

Oops — it looks like that tree object isn’t in loose format on the server, so you get a 404 response back. There are a couple of reasons for this — the object could be in an alternate repository, or it could be in a packfile in this repository. Git checks for any listed alternates first:

	=> GET objects/info/http-alternates
	(empty file)

If this comes back with a list of alternate URLs, Git checks for loose files and packfiles there — this is a nice mechanism for projects that are forks of one another to share objects on disk. However, because no alternates are listed in this case, your object must be in a packfile. To see what packfiles are available on this server, you need to get the `objects/info/packs` file, which contains a listing of them (also generated by `update-server-info`):

	=> GET objects/info/packs
	P pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack

There is only one packfile on the server, so your object is obviously in there, but you’ll check the index file to make sure. This is also useful if you have multiple packfiles on the server, so you can see which packfile contains the object you need:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.idx
	(4k of binary data)

Now that you have the packfile index, you can see if your object is in it — because the index lists the SHAs of the objects contained in the packfile and the offsets to those objects. Your object is there, so go ahead and get the whole packfile:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack
	(13k of binary data)

You have your tree object, so you continue walking your commits. They’re all also within the packfile you just downloaded, so you don’t have to do any more requests to your server. Git checks out a working copy of the `master` branch that was pointed to by the HEAD reference you downloaded at the beginning.

The entire output of this process looks like this:

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

The HTTP method is simple but a bit inefficient. Using smart protocols is a more common method of transferring data. These protocols have a process on the remote end that is intelligent about Git — it can read local data and figure out what the client has or needs and generate custom data for it. There are two sets of processes for transferring data: a pair for uploading data and a pair for downloading data.

#### Uploading Data ####

To upload data to a remote process, Git uses the `send-pack` and `receive-pack` processes. The `send-pack` process runs on the client and connects to a `receive-pack` process on the remote side.

For example, say you run `git push origin master` in your project, and `origin` is defined as a URL that uses the SSH protocol. Git fires up the `send-pack` process, which initiates a connection over SSH to your server. It tries to run a command on the remote server via an SSH call that looks something like this:

	$ ssh -x git@github.com "git-receive-pack 'schacon/simplegit-progit.git'"
	005bca82a6dff817ec66f4437202690a93763949 refs/heads/master report-status delete-refs
	003e085bb3bcb608e1e84b2432f8ecbe6306e7e7 refs/heads/topic
	0000

The `git-receive-pack` command immediately responds with one line for each reference it currently has — in this case, just the `master` branch and its SHA. The first line also has a list of the server’s capabilities (here, `report-status` and `delete-refs`).

Each line starts with a 4-byte hex value specifying how long the rest of the line is. Your first line starts with 005b, which is 91 in hex, meaning that 91 bytes remain on that line. The next line starts with 003e, which is 62, so you read the remaining 62 bytes. The next line is 0000, meaning the server is done with its references listing.

Now that it knows the server’s state, your `send-pack` process determines what commits it has that the server doesn’t. For each reference that this push will update, the `send-pack` process tells the `receive-pack` process that information. For instance, if you’re updating the `master` branch and adding an `experiment` branch, the `send-pack` response may look something like this:

	0085ca82a6dff817ec66f44342007202690a93763949  15027957951b64cf874c3557a0f3547bd83b3ff6 refs/heads/master report-status
	00670000000000000000000000000000000000000000 cdfdb42577e2506715f8cfeacdbabc092bf63e8d refs/heads/experiment
	0000

The SHA-1 value of all '0's means that nothing was there before — because you’re adding the experiment reference. If you were deleting a reference, you would see the opposite: all '0's on the right side.

Git sends a line for each reference you’re updating with the old SHA, the new SHA, and the reference that is being updated. The first line also has the client’s capabilities. Next, the client uploads a packfile of all the objects the server doesn’t have yet. Finally, the server responds with a success (or failure) indication:

	000Aunpack ok

#### Downloading Data ####

When you download data, the `fetch-pack` and `upload-pack` processes are involved. The client initiates a `fetch-pack` process that connects to an `upload-pack` process on the remote side to negotiate what data will be transferred down.

There are different ways to initiate the `upload-pack` process on the remote repository. You can run via SSH in the same manner as the `receive-pack` process. You can also initiate the process via the Git daemon, which listens on a server on port 9418 by default. The `fetch-pack` process sends data that looks like this to the daemon after connecting:

	003fgit-upload-pack schacon/simplegit-progit.git\0host=myserver.com\0

It starts with the 4 bytes specifying how much data is following, then the command to run followed by a null byte, and then the server’s hostname followed by a final null byte. The Git daemon checks that the command can be run and that the repository exists and has public permissions. If everything is cool, it fires up the `upload-pack` process and hands off the request to it.

If you’re doing the fetch over SSH, `fetch-pack` instead runs something like this:

	$ ssh -x git@github.com "git-upload-pack 'schacon/simplegit-progit.git'"

In either case, after `fetch-pack` connects, `upload-pack` sends back something like this:

	0088ca82a6dff817ec66f44342007202690a93763949 HEAD\0multi_ack thin-pack \
	  side-band side-band-64k ofs-delta shallow no-progress include-tag
	003fca82a6dff817ec66f44342007202690a93763949 refs/heads/master
	003e085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 refs/heads/topic
	0000

This is very similar to what `receive-pack` responds with, but the capabilities are different. In addition, it sends back the HEAD reference so the client knows what to check out if this is a clone.

At this point, the `fetch-pack` process looks at what objects it has and responds with the objects that it needs by sending "want" and then the SHA it wants. It sends all the objects it already has with "have" and then the SHA. At the end of this list, it writes "done" to initiate the `upload-pack` process to begin sending the packfile of the data it needs:

	0054want ca82a6dff817ec66f44342007202690a93763949 ofs-delta
	0032have 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	0000
	0009done

That is a very basic case of the transfer protocols. In more complex cases, the client supports `multi_ack` or `side-band` capabilities; but this example shows you the basic back and forth used by the smart protocol processes.

## Maintenance and Data Recovery ##

Occasionally, you may have to do some cleanup — make a repository more compact, clean up an imported repository, or recover lost work. This section will cover some of these scenarios.

### Maintenance ###

Occasionally, Git automatically runs a command called "auto gc". Most of the time, this command does nothing. However, if there are too many loose objects (objects not in a packfile) or too many packfiles, Git launches a full-fledged `git gc` command. The `gc` stands for garbage collect, and the command does a number of things: it gathers up all the loose objects and places them in packfiles, it consolidates packfiles into one big packfile, and it removes objects that aren’t reachable from any commit and are a few months old.

You can run auto gc manually as follows:

	$ git gc --auto

Again, this generally does nothing. You must have around 7,000 loose objects or more than 50 packfiles for Git to fire up a real gc command. You can modify these limits with the `gc.auto` and `gc.autopacklimit` config settings, respectively.

The other thing `gc` will do is pack up your references into a single file. Suppose your repository contains the following branches and tags:

	$ find .git/refs -type f
	.git/refs/heads/experiment
	.git/refs/heads/master
	.git/refs/tags/v1.0
	.git/refs/tags/v1.1

If you run `git gc`, you’ll no longer have these files in the `refs` directory. Git will move them for the sake of efficiency into a file named `.git/packed-refs` that looks like this:

	$ cat .git/packed-refs 
	# pack-refs with: peeled 
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/heads/experiment
	ab1afef80fac8e34258ff41fc1b867c702daa24b refs/heads/master
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/tags/v1.0
	9585191f37f7b0fb9444f35a9bf50de191beadc2 refs/tags/v1.1
	^1a410efbd13591db07496601ebc7a059dd55cfe9

If you update a reference, Git doesn’t edit this file but instead writes a new file to `refs/heads`. To get the appropriate SHA for a given reference, Git checks for that reference in the `refs` directory and then checks the `packed-refs` file as a fallback. However, if you can’t find a reference in the `refs` directory, it’s probably in your `packed-refs` file.

Notice the last line of the file, which begins with a `^`. This means the tag directly above is an annotated tag and that line is the commit that the annotated tag points to.

### Data Recovery ###

At some point in your Git journey, you may accidentally lose a commit. Generally, this happens because you force-delete a branch that had work on it, and it turns out you wanted the branch after all; or you hard-reset a branch, thus abandoning commits that you wanted something from. Assuming this happens, how can you get your commits back?

Here’s an example that hard-resets the master branch in your test repository to an older commit and then recovers the lost commits. First, let’s review where your repository is at this point:

	$ git log --pretty=oneline
	ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
	484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Now, move the `master` branch back to the middle commit:

	$ git reset --hard 1a410efbd13591db07496601ebc7a059dd55cfe9
	HEAD is now at 1a410ef third commit
	$ git log --pretty=oneline
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

You’ve effectively lost the top two commits — you have no branch from which those commits are reachable. You need to find the latest commit SHA and then add a branch that points to it. The trick is finding that latest commit SHA — it’s not like you’ve memorized it, right?

Often, the quickest way is to use a tool called `git reflog`. As you’re working, Git silently records what your HEAD is every time you change it. Each time you commit or change branches, the reflog is updated. The reflog is also updated by the `git update-ref` command, which is another reason to use it instead of just writing the SHA value to your ref files, as we covered in the "Git References" section of this chapter earlier.  You can see where you’ve been at any time by running `git reflog`:

	$ git reflog
	1a410ef HEAD@{0}: 1a410efbd13591db07496601ebc7a059dd55cfe9: updating HEAD
	ab1afef HEAD@{1}: ab1afef80fac8e34258ff41fc1b867c702daa24b: updating HEAD

Here we can see the two commits that we have had checked out, however there is not much information here.  To see the same information in a much more useful way, we can run `git log -g`, which will give you a normal log output for your reflog.

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

	$ git branch recover-branch ab1afef
	$ git log --pretty=oneline recover-branch
	ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
	484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Cool — now you have a branch named `recover-branch` that is where your `master` branch used to be, making the first two commits reachable again. 
Next, suppose your loss was for some reason not in the reflog — you can simulate that by removing `recover-branch` and deleting the reflog. Now the first two commits aren’t reachable by anything:

	$ git branch –D recover-branch
	$ rm -Rf .git/logs/

Because the reflog data is kept in the `.git/logs/` directory, you effectively have no reflog. How can you recover that commit at this point? One way is to use the `git fsck` utility, which checks your database for integrity. If you run it with the `--full` option, it shows you all objects that aren’t pointed to by another object:

	$ git fsck --full
	dangling blob d670460b4b4aece5915caf5c68d12f560a9fe3e4
	dangling commit ab1afef80fac8e34258ff41fc1b867c702daa24b
	dangling tree aea790b9a58f6cf6f2804eeac9f0abbe9631e4c9
	dangling blob 7108f7ecb345ee9d0084193f147cdad4d2998293

In this case, you can see your missing commit after the dangling commit. You can recover it the same way, by adding a branch that points to that SHA.

### Removing Objects ###

There are a lot of great things about Git, but one feature that can cause issues is the fact that a `git clone` downloads the entire history of the project, including every version of every file. This is fine if the whole thing is source code, because Git is highly optimized to compress that data efficiently. However, if someone at any point in the history of your project added a single huge file, every clone for all time will be forced to download that large file, even if it was removed from the project in the very next commit. Because it’s reachable from the history, it will always be there.

This can be a huge problem when you’re converting Subversion or Perforce repositories into Git. Because you don’t download the whole history in those systems, this type of addition carries few consequences. If you did an import from another system or otherwise find that your repository is much larger than it should be, here is how you can find and remove large objects.

Be warned: this technique is destructive to your commit history. It rewrites every commit object downstream from the earliest tree you have to modify to remove a large file reference. If you do this immediately after an import, before anyone has started to base work on the commit, you’re fine — otherwise, you have to notify all contributors that they must rebase their work onto your new commits.

To demonstrate, you’ll add a large file into your test repository, remove it in the next commit, find it, and remove it permanently from the repository. First, add a large object to your history:

	$ curl http://kernel.org/pub/software/scm/git/git-1.6.3.1.tar.bz2 > git.tbz2
	$ git add git.tbz2
	$ git commit -am 'added git tarball'
	[master 6df7640] added git tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 create mode 100644 git.tbz2

Oops — you didn’t want to add a huge tarball to your project. Better get rid of it:

	$ git rm git.tbz2 
	rm 'git.tbz2'
	$ git commit -m 'oops - removed large tarball'
	[master da3f30d] oops - removed large tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 delete mode 100644 git.tbz2

Now, `gc` your database and see how much space you’re using:

	$ git gc
	Counting objects: 21, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (16/16), done.
	Writing objects: 100% (21/21), done.
	Total 21 (delta 3), reused 15 (delta 1)

You can run the `count-objects` command to quickly see how much space you’re using:

	$ git count-objects -v
	count: 4
	size: 16
	in-pack: 21
	packs: 1
	size-pack: 2016
	prune-packable: 0
	garbage: 0

The `size-pack` entry is the size of your packfiles in kilobytes, so you’re using 2MB. Before the last commit, you were using closer to 2K — clearly, removing the file from the previous commit didn’t remove it from your history. Every time anyone clones this repository, they will have to clone all 2MB just to get this tiny project, because you accidentally added a big file. Let’s get rid of it.

First you have to find it. In this case, you already know what file it is. But suppose you didn’t; how would you identify what file or files were taking up so much space? If you run `git gc`, all the objects are in a packfile; you can identify the big objects by running another plumbing command called `git verify-pack` and sorting on the third field in the output, which is file size. You can also pipe it through the `tail` command because you’re only interested in the last few largest files:

	$ git verify-pack -v .git/objects/pack/pack-3f8c0...bb.idx | sort -k 3 -n | tail -3
	e3f094f522629ae358806b17daf78246c27c007b blob   1486 734 4667
	05408d195263d853f09dca71d55116663690c27c blob   12908 3478 1189
	7a9eb2fba2b1811321254ac360970fc169ba2330 blob   2056716 2056872 5401

The big object is at the bottom: 2MB. To find out what file it is, you’ll use the `rev-list` command, which you used briefly in Chapter 7. If you pass `--objects` to `rev-list`, it lists all the commit SHAs and also the blob SHAs with the file paths associated with them. You can use this to find your blob’s name:

	$ git rev-list --objects --all | grep 7a9eb2fb
	7a9eb2fba2b1811321254ac360970fc169ba2330 git.tbz2

Now, you need to remove this file from all trees in your past. You can easily see what commits modified this file:

	$ git log --pretty=oneline -- git.tbz2
	da3f30d019005479c99eb4c3406225613985a1db oops - removed large tarball
	6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 added git tarball

You must rewrite all the commits downstream from `6df76` to fully remove this file from your Git history. To do so, you use `filter-branch`, which you used in Chapter 6:

	$ git filter-branch --index-filter \
	   'git rm --cached --ignore-unmatch git.tbz2' -- 6df7640^..
	Rewrite 6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 (1/2)rm 'git.tbz2'
	Rewrite da3f30d019005479c99eb4c3406225613985a1db (2/2)
	Ref 'refs/heads/master' was rewritten

The `--index-filter` option is similar to the `--tree-filter` option used in Chapter 6, except that instead of passing a command that modifies files checked out on disk, you’re modifying your staging area or index each time. Rather than remove a specific file with something like `rm file`, you have to remove it with `git rm --cached` — you must remove it from the index, not from disk. The reason to do it this way is speed — because Git doesn’t have to check out each revision to disk before running your filter, the process can be much, much faster. You can accomplish the same task with `--tree-filter` if you want. The `--ignore-unmatch` option to `git rm` tells it not to error out if the pattern you’re trying to remove isn’t there. Finally, you ask `filter-branch` to rewrite your history only from the `6df7640` commit up, because you know that is where this problem started. Otherwise, it will start from the beginning and will unnecessarily take longer.

Your history no longer contains a reference to that file. However, your reflog and a new set of refs that Git added when you did the `filter-branch` under `.git/refs/original` still do, so you have to remove them and then repack the database. You need to get rid of anything that has a pointer to those old commits before you repack:

	$ rm -Rf .git/refs/original
	$ rm -Rf .git/logs/
	$ git gc
	Counting objects: 19, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (19/19), done.
	Total 19 (delta 3), reused 16 (delta 1)

Let’s see how much space you saved.

	$ git count-objects -v
	count: 8
	size: 2040
	in-pack: 19
	packs: 1
	size-pack: 7
	prune-packable: 0
	garbage: 0

The packed repository size is down to 7K, which is much better than 2MB. You can see from the size value that the big object is still in your loose objects, so it’s not gone; but it won’t be transferred on a push or subsequent clone, which is what is important. If you really wanted to, you could remove the object completely by running `git prune --expire`.

## Summary ##

You should have a pretty good understanding of what Git does in the background and, to some degree, how it’s implemented. This chapter has covered a number of plumbing commands — commands that are lower level and simpler than the porcelain commands you’ve learned about in the rest of the book. Understanding how Git works at a lower level should make it easier to understand why it’s doing what it’s doing and also to write your own tools and helping scripts to make your specific workflow work for you.

Git as a content-addressable filesystem is a very powerful tool that you can easily use as more than just a VCS. I hope you can use your newfound knowledge of Git internals to implement your own cool application of this technology and feel more comfortable using Git in more advanced ways.
