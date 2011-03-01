# Personnaliser Git #

Jusqu'ici, nous avons traité les bases du fonctionnement et de l'utilisation de Git et introduit un certain nombre d'outils fournis par Git pour travailler plus facilement et plus efficacement.
Dans ce chapitre, nous traiterons quelques opérations permettant d'utiliser Git de manière plus personnalisée en vous présentant quelques paramètres de configuration importants et le système d'interceptions.
Grâce à ces outils, il devient enfantin de faire fonctionner Git exactement comme vous, votre société ou votre communauté en avez besoin.

## La configuration de Git ##

Comme vous avez pu l'entrevoir au Chapitre 1, vous pouvez spécifier les paramètres de configuration de Git avec la commande `git config`.
Une des premières choses que vous avez faites a été de paramétrer votre nom et votre adresse e-mail :

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

À présent, vous allez apprendre quelques unes des options similaires les plus intéressantes pour paramétrer votre usage de Git.

Vous avez vu des détails de configuration simple de Git dans le premier chapitre, mais nous allons les réviser.
Git utilise une série de fichiers de configuration pour déterminer son comportement selon votre personnalisation.
Le premier endroit que Git visite est le fichier `/etc/gitconfig` qui contient des valeurs pour tous les utilisateurs du système et tous leurs dépôts.
Si vous passez l'option `--system` à `git config`, il lit et écrit ce fichier.

L'endroit suivant visité par Git est le fichier `~/.gitconfig` qui est spécifique à chaque utilisateur.
Vous pouvez faire lire et écrire Git dans ce fichier au moyen de l'option `--global`.

Enfin, Git recherche des valeurs de configuration dans le fichier de configuration du répertoire Git (`.git/config`) du dépôt en cours d'utilisation.
Ces valeurs sont spécifiques à un unique dépôt.
Chaque niveau surcharge le niveau précédent, ce qui signifie que les valeurs dans `.git/config` écrasent celles dans `/etc/gitconfig`.
Vous pouvez positionner ces valeurs manuellement en éditant le fichier et en utilisant la syntaxe correcte, mais il reste généralement plus facile de lancer la commande `git config`.

### Configuration de base d'un client ###

Les options de configuration reconnues par Git tombent dans deux catégories : côté client et côté serveur.
La grande majorité se situe côté client pour coller à vos préférences personnelles de travail.
Parmi les tonnes d'options disponibles, seules les plus communes ou affectant significativement la manière de travailler seront traitées.
De nombreuses options ne s'avèrent utiles que sur des cas rares et ne seront pas traitées.
Pour voir la liste des toutes les options que votre version de Git reconnaît, vous pouvez lancer :

	$ git config --help

La page de manuel pour `git config` liste aussi les options disponibles avec un bon niveau de détail.

#### core.editor ####

Par défaut, Git utilise votre éditeur par défaut ou se replie sur l'éditeur Vi pour la création et l'édition des messages de validation et de balisage.
Pour modifier ce comportement par défaut pour un autre, vous pouvez utiliser le paramètre `core.editor` :

	$ git config --global core.editor emacs

Maintenant, quelque soit votre éditeur par défaut, Git démarrera Emacs pour éditer les messages.

#### commit.template ####

Si vous réglez ceci sur le chemin d'un fichier sur votre système, Git utilisera ce fichier comme message par défaut quand vous validez.
Par exemple, supposons que vous créez un fichier modèle dans `$HOME/.gitmessage.txt` qui ressemble à ceci :

	ligne de sujet

	description

	[ticket: X]

Pour indiquer à Git de l'utiliser pour le message par défaut qui apparaîtra dans votre éditeur quand vous lancerez `git commit`, réglez le paramètre de configuration `commit.template` :

	$ git config --global commit.template $HOME/.gitmessage.txt
	$ git commit

Ainsi, votre éditeur ouvrira quelque chose ressemblant à ceci comme modèle de message de validation :

	ligne de sujet

	description

	[ticket: X]
	# Please enter the commit message for your changes. Lines starting
	# with '#' will be ignored, and an empty message aborts the commit.
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	# modified:   lib/test.rb
	#
	~
	~
	".git/COMMIT_EDITMSG" 14L, 297C

Si vous avez une règle de messages de validation, placer un modèle de cette règle sur votre système et configurer Git pour qu'il l'utiliser par défaut améliorera les chances que cette règle soit effectivement suivie.

#### core.pager ####

Le paramètre `core.pager` détermine quel pager est utilisé lorsque des pages de Git sont émises, par exemple lors d'un `log` ou d'un `diff`.
Vous pouvez le fixer à `more` ou à votre pager favori (par défaut, il vaut `less`) ou vous pouvez le désactiver en fixant sa valeur à une chaîne vide :

	$ git config --global core.pager ''

si vous lancez cela, Git affichera la totalité de le résultat de toutes les commandes d'une traite, quelque soit sa longueur.

#### user.signingkey ####

Si vous faîtes des balises annotées signées (comme décrit au Chapitre 2), simplifiez-vous la vie en définissant votre clé GPG de signature en paramètre de configuration.
Définissez votre ID de clé ainsi :

	$ git config --global user.signingkey <gpg-key-id>

Maintenant, vous pouvez signer vos balises sans devoir spécifier votre clé à chaque fois à la commande `git tag` :

	$ git tag -s <nom-balise>

#### core.excludesfile ####

Comme décrit au Chapitre 2, vous pouvez ajouter des patrons dans le fichier `.gitignore` de votre projet pour indiquer à Git de ne pas considérer certains fichiers comme non suivis ou les indexer lorsque vous lancez `git add` sur eux.
Cependant, si vous souhaitez qu'un autre fichier à l'extérieur du projet contiennent ces informations ou d'autres supplémentaires, vous pouvez indiquer à Git où se trouve se fichier grâce au paramètre `core.excludesfile`.
Fixez le simplement sur le chemin du fichier qui contient les informations similaires à celles de `.gitignore`.

#### help.autocorrect ####

Cette option n'est disponible qu'à partir de la version 1.6.1.
Si vous avez fait une faute de frappe en tapant une commande dans Git 1.6, il vous affichera quelque chose une liste de commandes ressemblantes :

	$ git com
	git: 'com' is not a git-command. See 'git --help'.

	Did you mean this?
	     commit

Si vous positionnez le paramètre `help.autocorrect` à 1, Git lancera automatiquement de lui-même la commande si une seule commande ressemblante a été trouvée.

### Les couleurs dans Git ###

Git peut coloriser ses affichages dans votre terminal, ce qui peut faciliter le parcours visuel des résultats.
Un certain nombre d'options peuvent vous aider à régler la colorisation à votre goût.

#### color.ui ####

Git colorise automatiquement la plupart de ses affichages si vous le lui demandez.
Vous pouvez néanmoins vouloir être plus précis sur ce que vous souhaitez voir colorié et comment vous le souhaitez.
Pour activer toute la colorisation par défaut, fixez `color.ui` à `true` :

	$ git config --global color.ui true

Lorsque ce paramètre est fixé, Git colorie sa sortie si celle-ci est destinée à un terminal.
D'autres réglages possibles sont `false` qui désactive complètement la colorisation et `always` qui active la colorisation, même si vous envoyez la commande Git dans un fichier ou l'entrée d'une autre commande.
Ce réglage a été ajouté dans Git 1.5.5.
Si vous avez une version antérieure, vous devrez spécifier les règles de colorisation individuellement.

`color.ui = always` est rarement utile.
Dans les plupart des cas, si vous tenez vraiment à colorer dans vos sorties redirigées, vous pourrez passer le drapeau `--color` à la commande Git pour la forcer à utiliser les codes de couleur.
Le réglage `color.ui = true` est donc le plus utilisé.

#### color.* ####

Si vous souhaitez être plus spécifique concernant les commandes colorisées ou si vous avez une ancienne version, Git propose des paramètres de colorisation par action.
Chacun peut être fixé à `true`, `false` ou `always`.

	color.branch
	color.diff
	color.interactive
	color.status

De plus, chacun d'entre eux dispose d'un sous-ensemble de paramètres qui permettent de surcharger les couleurs pour des parties des affichages.
Par exemple, pour régler les couleurs de méta-informations du diff avec une écriture en bleu gras (`bold` en anglais) sur fond noir :

	$ git config --global color.diff.meta “blue black bold”

La couleur peut prendre les valeurs suivantes : normal, black, red, green, yellow, blue, magenta, cyan ou white.
Si vous souhaitez ajouter un attribut de casse, les valeurs disponibles sont bold, dim, ul, blink et reverse.

Référez-vous à la page de manuel de `git config` pour tous les sous-réglages disponibles.

### Les outils externes de fusion et de différence ###

Bien que Git ait une implémentation interne de diff que vous avez déjà utilisée, vous pouvez sélectionner à la place un outil externe.
Vous pouvez aussi sélectionner un outil graphique pour la fusion et la résolution de conflit au lieu de devoir résoudre les conflits manuellement.
Je démontrerai le paramétrage avec Perforce Merge Tool (P4Merge) pour visualiser vos différences et résoudre vos fusions parce que c'est un outil graphique agréable et gratuit.

Si vous voulez l'essayer, P4Merge fonctionne sur tous les systèmes d'exploitation principaux.
Dans cet exemple, je vais utiliser la forme des chemins usitée sur Mac et Linux.
Pour Windows, vous devrez changer `/usr/local/bin` pour le chemin d'exécution dans votre environnement.

Vous pouvez télécharger P4Merge ici :

	http://www.perforce.com/perforce/downloads/component.html

Pour commencer, vous créerez un script d'appel externe pour lancer vos commandes.
Je vais utiliser le chemin Mac pour l'exécutable ; dans d'autres systèmes, il résidera où votre binaire `p4merge` a été installé.
Créez un script enveloppe nommé `extMerge` qui appelle votre binaire avec tous les arguments fournis :

	$ cat /usr/local/bin/extMerge
	#!/bin/sh
	/Applications/p4merge.app/Contents/MacOS/p4merge $*

L'enveloppe diff s'assure que sept arguments ont été fournis et en passe deux à votre script de fusion.
Par défaut, Git passe au programme de diff les arguments suivants :

	chemin ancien-fichier ancien-hex ancien-mode nouveau-fichier nouveau-hex nouveau-mode

Comme seuls les arguments `ancien-fichier` et `nouveau-fichier` sont nécessaires, vous utilisez le script d'enveloppe pour passer ceux dont vous avez besoin.

	$ cat /usr/local/bin/extDiff 
	#!/bin/sh
	[ $# -eq 7 ] && /usr/local/bin/extMerge "$2" "$5"

Vous devez aussi vous assurer que ces outils sont exécutables :

	$ sudo chmod +x /usr/local/bin/extMerge 
	$ sudo chmod +x /usr/local/bin/extDiff

À présent, vous pouvez régler votre fichier de config pour utiliser vos outils personnalisés de résolution de fusion et de différence.
Pour cela, il faut un certain nombre de personnalisation : `merge.tool` pour indiquer à Git quelle stratégie utiliser, `mergetool.*.cmd` pour spécifier comment lancer cette commande, `mergetool.trustExitCode` pour indiquer à Git si le code de sortie du programme indique une résolution de fusion réussie ou non et `diff.external` pour indiquer à Git quelle commander lancer pour les différences.
Ainsi, vous pouvez lancer les quatre commandes

	$ git config --global merge.tool extMerge
	$ git config --global mergetool.extMerge.cmd \
	    'extMerge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
	$ git config --global mergetool.trustExitCode false
	$ git config --global diff.external extDiff

Ou vous pouvez éditer votre fichier `~/.gitconfig` pour y ajouter ces lignes :

	[merge]
	  tool = extMerge
	[mergetool "extMerge"]
	  cmd = extMerge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"
	  trustExitCode = false
	[diff]
	  external = extDiff

Après avoir régler tout ceci, si vous lancez des commandes de diff telles que celle-ci :
	
	$ git diff 32d1776b1^ 32d1776b1

Au lieu d'obtenir la sortie du diff dans le terminal, Git lance P4Merge, ce qui ressemble à la Figure 7-1.

Insert 18333fig0701.png 
Figure 7-1. P4Merge.

Si vous essayez de fusionner deux branches et créez des conflits de fusion, vous pouvez lancer la commande `git mergetool` qui démarrera P4Merge pour vous laisser résoudre les conflits au moyen d'un outil graphique.

Le point agréable avec cette méthode d'enveloppe est que vous pouvez changer facilement d'outils de diff et de fusion.
Par exemple, pour changer vos outils `extDiff` et `extMerge` pour une utilisation de l'outil KDiff3, il vous suffit d'éditer le fichier `extMerge` :

	$ cat /usr/local/bin/extMerge
	#!/bin/sh	
	/Applications/kdiff3.app/Contents/MacOS/kdiff3 $*

À présent, Git va utiliser l'outil KDiff3 pour visualiser les différences et résoudre les conflits de fusion.

Git est livré préréglé avec un certain nombre d'autre outils de résolution de fusion pour vous éviter d'avoir à régler la configuration cmd.
Vous pouvez sélectionner votre outil de fusion parmi kdiff3, opendiff, tkdiff, meld, xxdiff, emerge, vimdiff ou gvimdiff.
Si KDiff3 ne vous intéresse pas pour gérer les différences mais seulement pour la résolution de fusion et qu'il est présent dans votre chemin d'exécution, vous pouvez lancer

	$ git config --global merge.tool kdiff3

Si vous lancez ceci au lieu de modifier les fichiers `extMerge` ou `extDiff`, Git utilisera KDif3 pour les résolutions de fusion et l'outil diff normal de Git pour les différences.

### Formatage and espaces blancs ###

Les problèmes de formatage et de blancs font partie des plus subtiles et frustrants des problèmes que les développeurs rencontrent lorsqu'ils collabore, spécifiquement sur plusieurs plate-formes.
Il est très facile d'introduire des modifications subtiles de blancs lors de soumission de patchs ou d'autres modes de collaboration car les éditeurs de textes les insèrent silencieusement ou les programmeurs Windows ajoutent de retour chariot à la fin des lignes qu'il modifient.
Git dispose de quelques options de configuration pour traiter ces problèmes.

#### core.autocrlf ####

Si vous programmez vous-même sous Windows ou si vous utilisez un autre système d'exploitation mais devez travailler avec des personnes travaillant sous Windows, vous rencontrerez à un moment ou à un autre des problèmes de caractères de fin de ligne.
Ceci est du au fait que Windows utilise pour marquer les fins de ligne dans ses fichiers  un caractère « retour chariot » (carriage return, CR)suivi d'un caractère « saut de ligne » (line feed, LF), tandis que Mac et Linux utilisent seulement le caractère « saut de ligne ».
C'est un cas subtile mais incroyablement ennuyeux de problème généré par la collaboration inter plate-forme.

Git peut gérer ce cas en convertissant automatiquement les fins de ligne CRLF en LF lorsque vous validez, et inversement lorsqu'il extrait des fichiers sur votre système.
Vous pouvez activer cette fonctionnalité au moyen du paramètre `core.autcrlf`.
Si vous avez une machine Windows, positionnez-le à `true`.
Git convertira les fins de de ligne de LF en CRLF lorsque vous extrayez votre code :

	$ git config --global core.autocrlf true

Si vous utilisez un système Linux ou Mac qui utilise les fins de ligne LF, vous ne souhaitez sûrement pas que Git les convertisse automatiquement lorsque vous extrayez des fichiers.
Cependant, si un fichier contenant des CRLF est accidentellement introduit en version, vous souhaitez que Git le corrige .
Vous pouvez indiquer à Git de convertir CRLF en LF lors de la validation mais pas dans l'autre sens en fixant `core.autocrlf` à `input` :

	$ git config --global core.autocrlf input

Ce réglage devrait donner des fins de ligne en CRLF lors d'extraction sous Windows mais en LF sous Mac et Linux et dans le dépôt.

Si vous êtes un programmeur Windows gérant un projet spécifique à Windows, vous pouvez désactiver cette fonctionnalité et forcer l'enregistrement des « retour chariot » dans le dépôt en réglant la valeur du paramètre à `false` :

	$ git config --global core.autocrlf false

#### core.whitespace ####

Git est paramétré par défaut pour détecter et corriger certains problèmes de blancs.
Il peut rechercher quatre problèmes de base de blancs.
La correction de deux problèmes est activée par défaut et peut être désactivée et celle des deux autres n'est pas activée par défaut mais peut être activée.

Les deux activées par défaut sont `trailing-space` qui détecter les espaces en fin de ligne et `space-before-tab` qui recherche les espaces avant les tabulations au début d'une ligne.

Les deux autres qui sont désactivées par défaut mais peuvent être activées sont `indent-with-non-tab` qui recherche des lignes qui commencent par huit espaces ou plus au lieu de tabulations et `cr-at-eol` qui indique à Git que les « retour chariot » en fin de ligne sont acceptés.

Vous pouvez indiquer à Git quelle correction vous voulez activer en fixant `core.whitespace` avec les valeurs que vous voulez ou non, séparées par des virgules.
Vous pouvez désactiver des réglages en les éliminant de la chaîne de paramétrage ou en les préfixant avec un `-`.
Par exemple, si vous souhaiter activer tout sauf `cr-at-eol`, vous pouvez lancer ceci :

	$ git config --global core.whitespace \
	    trailing-space,space-before-tab,indent-with-non-tab

Git va détecter ces problèmes quand vous lancez une commande `git diff` et essayer de les colorer pour vous permettre de les régler avant de valider.
Il utilisera aussi ces paramètres pour vous aider quand vous appliquez des patchs avec `git apply`.
Quand vous appliquez des patchs, vous pouvez paramétrer Git pour qu'il vous avertisse s'il doit appliquer des patchs qui présente les défauts de blancs :

	$ git apply --whitespace=warn <patch>

Ou vous pouvez indiquer à Git d'essayer de corriger automatiquement le problème avant d'appliquer le patch :

	$ git apply --whitespace=fix <patch>

Ces option s'appliquent aussi à `git rebase`.
Si vous avez validé avec des problèmes de blancs mais n'avez pas encore poussé en amont, vous pouvez lancer un `rebase` avec l'option `--whitespace=fix` pour faire corriger à Git les erreurs de blancs pendant qu'il réécrit les patchs.

### Configuration du serveur ###

Il n'y a pas autant d'options de configuration de Git côté serveur, mais en voici quelques unes intéressantes dont il est utile de prendre note.

#### receive.fsckObjects ####

Par défaut, Git ne vérifie pas la cohérence entre les objets qu'on lui pousse.
Bien que Git puisse vérifier que chaque objet correspond bien à sa somme de contrôle et pointe vers des objets valides, il ne le fait pas par défaut sur chaque poussée.
C'est opération relativement lourde qui peut énormément allonger ???les poussées??? selon la taille du dépôt ou de la ???poussée???.
Si vous voulez que Git vérifie la cohérence des objets à chaque ???poussée???, vous pouvez le forcer en fixant le paramètre `receive.fsckObjects` à true :

	$ git config --system receive.fsckObjects true

Maintenant, Git va vérifier l'intégrité de votre dépôt avant que chaque poussée ne soit acceptée pour s'assurer que des clients défectueux n'introduisent pas des données corrompues.

#### receive.denyNonFastForwards ####

Si vous rebasez des commits que vous avez déjà poussés, puis essayez de pousser à nouveau, ou inversemement, si vous essayez de pousser un commit sur une branche distante qui ne contient pas le commit sur lequel la branche distante pointe, votre essai échouera.
C'est généralement une bonne politique, mais dans le cas d'un rebasage, vous pouvez décider que vous savez ce que vous faîtes et forcer la mise à jour de la branche distante en ajoutant l'option `-f` à votre commande.

Pour désactiver la possibilité de forcer la mise à jour des branches distantes vers des références pas en avance rapide, réglez `receive.denyNonFastForwards` :

	$ git config --system receive.denyNonFastForwards true

L'autre moyen d'obtenir ce résultat réside dans les crochets de réception côté-serveur, qui seront abordés en partie.
Cette approche vous permet de faire des choses plus complexes tel qu'interdire les modifications sans avance rapide à un certain groupe d'utilisateurs.

#### receive.denyDeletes ####

Un contournement possible de la politique `denyNonFastForwards` consiste à effacer la branche puis à la repousser avec ses nouvelles références.
Dans les versions  les plus récentes de Git (à partir de la version 1.6.1), vous pouvez régler `receive.denyDeletes` à true :

	$ git config --system receive.denyDeletes true

Cela interdit totalement l'effacement de branche et de balise.
Aucun utilisateur n'en a le droit.
Pour pouvoir effacer des branches distantes, vous devez effacer manuellement les fichiers de référence sur le serveur.
Il existe aussi des moyens plus intéressants de gérer cette politique utilisateur par utilisateur au moyen des listes de contrôle d'accès, point qui sera abordé à la fin de ce chapitre.

## Les attributs Git ##

Certains de ces réglages peuvent aussi s'appliquer sur un chemin, de telle sorte que Git ne les applique que sur un sous-répertoire ou un sous-ensemble de fichiers.
Ces réglages par chemin sont appelés attributs Git et sont définis soit dans une fichier `.gitattributes` dans un répertoire (normalement la racine du projet), soit dans un fichier `.git/info/attributes` si vous ne souhaitez pas que la fichier de description des attributs fasse partie du projet.

Les attributs permettent de spécifier des stratégies de fusion différentes pour certains fichiers ou répertoires dans votre projet, d'indiquer à Git la manière de calculer les différences pour certains fichiers non-texte, ou de faire filtrer à Git le contenu avant qu'il ne soit validé ou extrait.
Dans ce chapitre, nous traiterons certains attributs applicables aux chemins et détaillerons quelques exemples de leur utilisation en pratique.

### Les fichiers binaires ###

Un des trucs malins auxquels les attributs Git sont utilisés est d'indiquer à Git quels fichiers sont binaires (dans les cas où il ne pourrait pas le deviner par lui-même) et de lui donner les instructions spécifiques pour les traiter.
Par exemple, certains fichiers peuvent être générés par machine et impossible à traiter par diff, tandis que pour certains autres fichiers binaires, les différences peuvent être calculées.
Nous détaillerons comment indiquer à Git l'un et l'autre.

#### Identifier les fichiers binaires ####

Certains fichiers ressemblent à des fichiers texte mais doivent en tout état de cause être traités comme des fichiers binaires.
Par exemple, les projets Xcode sous Mac contiennent un fichier finissant en `.pbxproj`, qui est en fait un jeu de données JSON (format de données en texte javascript) enregistré par l'application EDI pour y sauver les réglages entre autres de compilation.
Bien que ce soit techniquement un fichier texte en ASCII, il n'y a aucun intérêt à le gérer comme tel parce que c'est en fait une mini base de données.
Il est impossible de fusionner les contenus si deux utilisateurs le modifient et les calculs de différence par défaut sont inutiles.
Ce fichier n'est destiné qu'à être manipulé par un programme
En résumé, ce fichier doit être considéré comme un fichier binaire.  

Pour indiquer à Git de traiter tous le fichiers `pbxproj` comme binaires, ajoutez la ligne suivante à votre fichier `.gitattributes` :

	*.pbxproj -crlf -diff

À présent, Git n'essaiera pas de convertir ou de corriger les problèmes des CRLF, ni de calculer ou d'afficher les différences pour ces fichiers quand vous lancez git show ou git diff sur votre projet.
Dans la branche 1.6 de Git, vous pouvez aussi utiliser une macro fournie qui signifie `-crlf -diff` :

	*.pbxproj binary

#### Comparer les fichiers binaires ####

Dans la branche 1.6 de Git, vous pouvez utiliser la fonctionnalité des attributs Git pour effectivement comparer les fichiers binaires.
Pour ce faire, indiquez à Git comment convertir vos données binaires en format texte qui peut être comparé via un diff normal.

Comme c'est une fonctionnalité plutôt cool et peu connue, nous allons en voir quelques exemples.
Premièrement, nous utiliserons cette technique pour résoudre un des problèmes les plus ennuyeux de l'humanité : gérer en contrôle de version les document Word.
Tout le monde convient que Word est l'éditeur de texte le plus horrible qui existe, mais bizarrement, tout le monde persiste à l'utiliser.
Si vous voulez gérer en version des documents Word, vous pouvez les coller dans un dépôt Git et les valider de temps à autres.
Mais qu'est-ce que ça vous apporte ?
Si vous lancez `git diff` normalement, vous verrez quelque chose comme :

	$ git diff 
	diff --git a/chapter1.doc b/chapter1.doc
	index 88839c4..4afcb7c 100644
	Binary files a/chapter1.doc and b/chapter1.doc differ

Vous ne pouvez pas comparer directement les versions à moins de les extraire et de les parcourir manuellement.
En fait, vous pouvez faire la même chose plutôt bien en utilisant les attributs Git.
ajoutez la ligne suivante dans votre fichier `.gitattributes` :

	*.doc diff=word

Cette ligne indique à Git que tout fichier correspondant au patron (.doc) doit utiliser le filtre `word` pour visualiser le diff des modifications.
Qu'est-ce que le filtre « word » ?
Nous devons le définir.
Vous allez configurer Git à utiliser le programme `strings` pour convertir les documents Word en fichiers texte lisibles qu'il pourra alors comparer correctement :

	$ git config diff.word.textconv strings

À présent, Git sait que s'il essaie de faire un diff entre deux instantanés et qu'un des fichiers finit en `.doc`, il devrait faire passer ces fichiers par le filtre `word` définit comme le programme `strings`.
Cette méthode fait effectivement des jolie versions texte de vos fichiers Word avant d'essayer de les comparer.

Voici un exemple.
J'ai mis le chapitre 1 de ce livre dans Git, ajouté du texte à un paragraphe et sauvegardé le document.
Puis, j'ai lancé `git diff` pour visualiser ce qui a changé :

	$ git diff
	diff --git a/chapter1.doc b/chapter1.doc
	index c1c8a0a..b93c9e4 100644
	--- a/chapter1.doc
	+++ b/chapter1.doc
	@@ -8,7 +8,8 @@ re going to cover Version Control Systems (VCS) and Git basics
	 re going to cover how to get it and set it up for the first time if you don
	 t already have it on your system.
	 In Chapter Two we will go over basic Git usage - how to use Git for the 80% 
	-s going on, modify stuff and contribute changes. If the book spontaneously 
	+s going on, modify stuff and contribute changes. If the book spontaneously 
	+Let's see if this works.

Git réussit à m'indiquer succinctement que j'ai ajouté la chaîne « Let's see if this works », ce qui est correct.
Ce n'est pas parfait, car il y a toujours un tas de données aléatoire à la fin, mais c'est suffisant.
Si vous êtes capable d'écrire un convertisseur Word vers texte qui fonctionne suffisamment bien, cette solution peut s'avérer très efficace.
Cependant, `strings` est disponible sur la plupart des systèmes Mac et Linux et peut donc constituer un bon début pour de nombreux formats binaires.

Un autre problème intéressant concerne la comparaison de fichiers d'images.
Une méthode consiste à faire passer les fichiers JPEG à travers un filtre qui extrait les données EXIF, les méta-données enregistrées avec la plupart de formats d'image.
Si vous téléchargez et installez le programme `exiftool`, vous pouvez l'utiliser pour convertir vos images en texte de méta-données de manière que le diff puisse au moins montrer une représentation textuelle des modifications pratiquées :

	$ echo '*.png diff=exif' >> .gitattributes
	$ git config diff.exif.textconv exiftool

Si vous remplacez une images dans votre projet et lancez `git diff`, vous verrez ceci :

	diff --git a/image.png b/image.png
	index 88839c4..4afcb7c 100644
	--- a/image.png
	+++ b/image.png
	@@ -1,12 +1,12 @@
	 ExifTool Version Number         : 7.74
	-File Size                       : 70 kB
	-File Modification Date/Time     : 2009:04:21 07:02:45-07:00
	+File Size                       : 94 kB
	+File Modification Date/Time     : 2009:04:21 07:02:43-07:00
	 File Type                       : PNG
	 MIME Type                       : image/png
	-Image Width                     : 1058
	-Image Height                    : 889
	+Image Width                     : 1056
	+Image Height                    : 827
	 Bit Depth                       : 8
	 Color Type                      : RGB with Alpha

Vous pouvez réaliser rapidement que la taille du fichier et les dimensions des images ont toutes deux changé.

### Expansion des mots-clés###

L'expansion de mots-clés dans le style de CVS ou de SVN est souvent une fonctionnalité demandée par les développeurs habitués.
Le problème principal de ce système avec Git et que vous ne pouvez pas modifier un fichier avec l'information concernant le commit après la validation parce que Git calcule justement la somme de contrôle sur son contenu.
Cependant, vous pouvez injecter des informations textuelles dans un fichier au moment où il est extrait et la retirer avant qu'il ne soit ajouté à une validation.
Les attributs Git vous fournissent deux manière de le faire.

Premièrement, vous pouvez injecter automatiquement la somme de contrôle SHA-1 d'un blob dans un champ `$Id$` d'un fichier.
Si vous positionnez cet attribut pour un fichier ou un ensemble de fichiers, la prochaine fois que vous extrairez cette branche, Git remplacera chaque champ avec le SHA-1 du blob.
Il est à noter que ce n'est pas le SHA du commit mais celui du blob lui-même :

	$ echo '*.txt ident' >> .gitattributes
	$ echo '$Id$' > test.txt

À la prochain extraction de ce fichier, Git injecte le SHA du blob :

	$ rm text.txt
	$ git checkout -- text.txt
	$ cat test.txt 
	$Id: 42812b7653c7b88933f8a9d6cad0ca16714b9bb3 $

Néanmoins, ce résultat n'a que peu d'intérêt.
Si vous avez utilisé la substitution avec CVS ou Subversion, il est possible d'inclure la date.
Le code SHA n'est pas des plus utiles car il est plutôt aléatoire et ne vous permet pas de distinguer si tel SHA est plus récent ou ancien que tel autre.

Il apparaît que vous pouvez écrire vos propres filtres pour réaliser des substitutions dans les fichiers lors des validations/extractions.
Ces filtres s'appellent « clean » et « smudge ».
Dans le fichier `.gitattributes`, vous pouvez indiquer un filtre pour des chemins particuliers puis créer des scripts qui traiterons ces fichiers avant qu'ils soient validés (« clean », voir figure 7-2) et juste avant qu'il soient extraits (« smudge », voir figure 7-3).
Ces filtres peuvent servir à faire toutes sortes de choses sympa.

Insert 18333fig0702.png 
Figure 7-2. Le filtre « smudge » est lancé lors d'une extraction.

Insert 18333fig0703.png 
Figure 7-3. Le filtre « clean » est lancé lorsque les fichiers sont indexés.

Le message de validation d'origine pour cette fonctionnalité donne un exemple simple permettant de passer tout votre code C par le programme `indent` avant de valider.
Vous pouvez le faire en réglant l'attribut `filter` dans votre fichier `.gitattributes` pour filtrer les fichiers `*.c` avec le filtre « indent » :

	*.c     filter=indent

Ensuite, indiquez à Git ce que le filtre « indent » fait sur smudge et clean :

	$ git config --global filter.indent.clean indent
	$ git config --global filter.indent.smudge cat

Dans ce cas, quand vous validez des fichiers qui correspondent à `*.c`, Git les fera passer par le programme indent avant de les valider et les fera passer par le programme « cat » avant de les extraire sur votre disque.
Le programme `cat` ne  fait rien : il se contente de régurgiter les données tels qu'il les a lues.
Cette combinaison filtre effectivement tous le fichiers de code source C par `indent` avant leur validation.

Un autre exemple intéressant fournit l'expansion du mot-clé `$Date$` dans le style RCS.
Pour le réaliser correctement, vous avez besoin d'un petit script qui prend un nom de fichier, calcule la date de la dernière validation pour le projet, et l'insère la date dans le fichier.
Voici un petit script Ruby qui le fait :

	#! /usr/bin/env ruby
	data = STDIN.read
	last_date = `git log --pretty=format:"%ad" -1`
	puts data.gsub('$Date$', '$Date: ' + last_date.to_s + '$')

Tout ce que le script fait, c'est récupérer la date de la dernière validation à partir de la commande `git log`, la coller dans toutes les chaînes `$Date$` qu'il trouve et afficher le résultat.
Ce devrait être simple dans n'importe quel langage avec lequel vous êtes à l'aise.
Si vous appelez ce fichier `expand_date` et que vous le placez dans votre chemin.
À présent, il faut paramétrer un filtre dans Git (appelons le `dater`) et le lui indiquer d'utiliser le filtre `expand_date` en tant que `smudge` sur les fichiers à extraire.
Nous utiliserons une expression Perl pour nettoyer lors d'une validation :

	$ git config filter.dater.smudge expand_date
	$ git config filter.dater.clean 'perl -pe "s/\\\$Date[^\\\$]*\\\$/\\\$Date\\\$/"'

Cette commande Perl extrait tout ce qu'elle trouve dans une chaîne `$Date$` et la réinitialise.
Le filtre prêt, on peut le tester en écrivant le mot-clé `$Date$` dans un fichier, puis créer un attribut Git pour ce fichier qui fait référence au nouveau filtre :

	$ echo '# $Date$' > date_test.txt
	$ echo 'date*.txt filter=dater' >> .gitattributes

S vous validez ces modifications et extrayez le fichier à nouveau, vous remarquez le mot-clé correctement substitué :

	$ git add date_test.txt .gitattributes
	$ git commit -m "Testing date expansion in Git"
	$ rm date_test.txt
	$ git checkout date_test.txt
	$ cat date_test.txt
	# $Date: Tue Apr 21 07:26:52 2009 -0700$

Vous pouvez voir à quel point cette technique peut être puissante pour des applications personnalisées.
Il rester néanmoins vigilant car le fichier `.gitattributes` est validé et inclus dans le projet tandis que le gestionnaire (ici, `dater`) ne l'est pas.
Du coup, ça ne marchera pas partout.
Lorsque vous créez ces filtres, ils devraient pouvoir avoir un mode dégradé qui n'empêche pas le projet de fonctionner.

### Exporter votre dépôt ###

Les données d'attribut Git permettent aussi de faire des choses intéressantes quand vous exportez une archive du projet.

#### export-ignore ####

Vous pouvez dire à Git de ne pas exporter certains fichiers ou répertoires lors de la génération d'archive.
S'il y a un sous-répertoire ou un fichier que vous ne souhaitez pas inclure dans le fichier archive mais que vous souhaitez extraire dans votre projet, vous pouvez indiquer ces fichiers via l'attribut `export-ignore`.

Par exemple, disons que vous avez des fichiers de test dans le sous-répertoire `test/` et que ce n'est pas raisonnable de les inclure dans l'archive d'export de votre projet.
Vous pouvez ajouter la ligne suivante dans votre fichier d'attribut Git :

	test/ export-ignore

À présent, quand vous lancez git archive pour créer une archive tar de votre projet, ce répertoire ne sera plus inclus dans l'archive.

#### export-subst ####

Une autre chose à faire pour vos archives est une simple substitution de mots-clés.
Git vous permet de placer la chaîne `$Format:$` dans n'importe quel fichier avec n'importe quel code de format du type `--pretty=format` que vous avez pu voir au chapitre 2.
Par exemple, si vous voulez inclure un fichier appelé `LAST_COMMIT` dans votre projet et y injecter automatiquement la date de dernière validation lorsque `git archive` est lancé, vous pouvez créer un fichier comme ceci :

	$ echo 'Last commit date: $Format:%cd$' > LAST_COMMIT
	$ echo "LAST_COMMIT export-subst" >> .gitattributes
	$ git add LAST_COMMIT .gitattributes
	$ git commit -am 'adding LAST_COMMIT file for archives'

Quand vous lancez `git archive`, le contenu de ce fichier inclus dans le fichiers ressemblera à ceci :

	$ cat LAST_COMMIT
	Last commit date: $Format:Tue Apr 21 08:38:48 2009 -0700$

### Merge Strategies ###

You can also use Git attributes to tell Git to use different merge strategies for specific files in your project. One very useful option is to tell Git to not try to merge specific files when they have conflicts, but rather to use your side of the merge over someone else’s.

This is helpful if a branch in your project has diverged or is specialized, but you want to be able to merge changes back in from it, and you want to ignore certain files. Say you have a database settings file called database.xml that is different in two branches, and you want to merge in your other branch without messing up the database file. You can set up an attribute like this:

	database.xml merge=ours

If you merge in the other branch, instead of having merge conflicts with the database.xml file, you see something like this:

	$ git merge topic
	Auto-merging database.xml
	Merge made by recursive.

In this case, database.xml stays at whatever version you originally had.

## Git Hooks ##

Like many other Version Control Systems, Git has a way to fire off custom scripts when certain important actions occur. There are two groups of these hooks: client side and server side. The client-side hooks are for client operations such as committing and merging. The server-side hooks are for Git server operations such as receiving pushed commits. You can use these hooks for all sorts of reasons, and you’ll learn about a few of them here.

### Installing a Hook ###

The hooks are all stored in the `hooks` subdirectory of the Git directory. In most projects, that’s `.git/hooks`. By default, Git populates this directory with a bunch of example scripts, many of which are useful by themselves; but they also document the input values of each script. All the examples are written as shell scripts, with some Perl thrown in, but any properly named executable scripts will work fine — you can write them in Ruby or Python or what have you. For post-1.6 versions of Git, these example hook files end with .sample; you’ll need to rename them. For pre-1.6 versions of Git, the example files are named properly but are not executable.

To enable a hook script, put a file in the `hooks` subdirectory of your Git directory that is named appropriately and is executable. From that point forward, it should be called. I’ll cover most of the major hook filenames here.

### Client-Side Hooks ###

There are a lot of client-side hooks. This section splits them into committing-workflow hooks, e-mail–workflow scripts, and the rest of the client-side scripts.

#### Committing-Workflow Hooks ####

The first four hooks have to do with the committing process. The `pre-commit` hook is run first, before you even type in a commit message. It’s used to inspect the snapshot that’s about to be committed, to see if you’ve forgotten something, to make sure tests run, or to examine whatever you need to inspect in the code. Exiting non-zero from this hook aborts the commit, although you can bypass it with `git commit --no-verify`. You can do things like check for code style (run lint or something equivalent), check for trailing whitespace (the default hook does exactly that), or check for appropriate documentation on new methods.

The `prepare-commit-msg` hook is run before the commit message editor is fired up but after the default message is created. It lets you edit the default message before the commit author sees it. This hook takes a few options: the path to the file that holds the commit message so far, the type of commit, and the commit SHA-1 if this is an amended commit. This hook generally isn’t useful for normal commits; rather, it’s good for commits where the default message is auto-generated, such as templated commit messages, merge commits, squashed commits, and amended commits. You may use it in conjunction with a commit template to programmatically insert information.

The `commit-msg` hook takes one parameter, which again is the path to a temporary file that contains the current commit message. If this script exits non-zero, Git aborts the commit process, so you can use it to validate your project state or commit message before allowing a commit to go through. In the last section of this chapter, I’ll demonstrate using this hook to check that your commit message is conformant to a required pattern.

After the entire commit process is completed, the `post-commit` hook runs. It doesn’t take any parameters, but you can easily get the last commit by running `git log -1 HEAD`. Generally, this script is used for notification or something similar.

The committing-workflow client-side scripts can be used in just about any workflow. They’re often used to enforce certain policies, although it’s important to note that these scripts aren’t transferred during a clone. You can enforce policy on the server side to reject pushes of commits that don’t conform to some policy, but it’s entirely up to the developer to use these scripts on the client side. So, these are scripts to help developers, and they must be set up and maintained by them, although they can be overridden or modified by them at any time.

#### E-mail Workflow Hooks ####

You can set up three client-side hooks for an e-mail–based workflow. They’re all invoked by the `git am` command, so if you aren’t using that command in your workflow, you can safely skip to the next section. If you’re taking patches over e-mail prepared by `git format-patch`, then some of these may be helpful to you.

The first hook that is run is `applypatch-msg`. It takes a single argument: the name of the temporary file that contains the proposed commit message. Git aborts the patch if this script exits non-zero. You can use this to make sure a commit message is properly formatted or to normalize the message by having the script edit it in place.

The next hook to run when applying patches via `git am` is `pre-applypatch`. It takes no arguments and is run after the patch is applied, so you can use it to inspect the snapshot before making the commit. You can run tests or otherwise inspect the working tree with this script. If something is missing or the tests don’t pass, exiting non-zero also aborts the `git am` script without committing the patch.

The last hook to run during a `git am` operation is `post-applypatch`. You can use it to notify a group or the author of the patch you pulled in that you’ve done so. You can’t stop the patching process with this script.

#### Other Client Hooks ####

The `pre-rebase` hook runs before you rebase anything and can halt the process by exiting non-zero. You can use this hook to disallow rebasing any commits that have already been pushed. The example `pre-rebase` hook that Git installs does this, although it assumes that next is the name of the branch you publish. You’ll likely need to change that to whatever your stable, published branch is.

After you run a successful `git checkout`, the `post-checkout` hook runs; you can use it to set up your working directory properly for your project environment. This may mean moving in large binary files that you don’t want source controlled, auto-generating documentation, or something along those lines.

Finally, the `post-merge` hook runs after a successful `merge` command. You can use it to restore data in the working tree that Git can’t track, such as permissions data. This hook can likewise validate the presence of files external to Git control that you may want copied in when the working tree changes.

### Server-Side Hooks ###

In addition to the client-side hooks, you can use a couple of important server-side hooks as a system administrator to enforce nearly any kind of policy for your project. These scripts run before and after pushes to the server. The pre hooks can exit non-zero at any time to reject the push as well as print an error message back to the client; you can set up a push policy that’s as complex as you wish.

#### pre-receive and post-receive ####

The first script to run when handling a push from a client is `pre-receive`. It takes a list of references that are being pushed from stdin; if it exits non-zero, none of them are accepted. You can use this hook to do things like make sure none of the updated references are non-fast-forwards; or to check that the user doing the pushing has create, delete, or push access or access to push updates to all the files they’re modifying with the push.

The `post-receive` hook runs after the entire process is completed and can be used to update other services or notify users. It takes the same stdin data as the `pre-receive` hook. Examples include e-mailing a list, notifying a continuous integration server, or updating a ticket-tracking system — you can even parse the commit messages to see if any tickets need to be opened, modified, or closed. This script can’t stop the push process, but the client doesn’t disconnect until it has completed; so, be careful when you try to do anything that may take a long time.

#### update ####

The update script is very similar to the `pre-receive` script, except that it’s run once for each branch the pusher is trying to update. If the pusher is trying to push to multiple branches, `pre-receive` runs only once, whereas update runs once per branch they’re pushing to. Instead of reading from stdin, this script takes three arguments: the name of the reference (branch), the SHA-1 that reference pointed to before the push, and the SHA-1 the user is trying to push. If the update script exits non-zero, only that reference is rejected; other references can still be updated.

## An Example Git-Enforced Policy ##

In this section, you’ll use what you’ve learned to establish a Git workflow that checks for a custom commit message format, enforces fast-forward-only pushes, and allows only certain users to modify certain subdirectories in a project. You’ll build client scripts that help the developer know if their push will be rejected and server scripts that actually enforce the policies.

I used Ruby to write these, both because it’s my preferred scripting language and because I feel it’s the most pseudocode-looking of the scripting languages; thus you should be able to roughly follow the code even if you don’t use Ruby. However, any language will work fine. All the sample hook scripts distributed with Git are in either Perl or Bash scripting, so you can also see plenty of examples of hooks in those languages by looking at the samples.

### Server-Side Hook ###

All the server-side work will go into the update file in your hooks directory. The update file runs once per branch being pushed and takes the reference being pushed to, the old revision where that branch was, and the new revision being pushed. You also have access to the user doing the pushing if the push is being run over SSH. If you’ve allowed everyone to connect with a single user (like "git") via public-key authentication, you may have to give that user a shell wrapper that determines which user is connecting based on the public key, and set an environment variable specifying that user. Here I assume the connecting user is in the `$USER` environment variable, so your update script begins by gathering all the information you need:

	#!/usr/bin/env ruby

	$refname = ARGV[0]
	$oldrev  = ARGV[1]
	$newrev  = ARGV[2]
	$user    = ENV['USER']

	puts "Enforcing Policies... \n(#{$refname}) (#{$oldrev[0,6]}) (#{$newrev[0,6]})"

Yes, I’m using global variables. Don’t judge me — it’s easier to demonstrate in this manner.

#### Enforcing a Specific Commit-Message Format ####

Your first challenge is to enforce that each commit message must adhere to a particular format. Just to have a target, assume that each message has to include a string that looks like "ref: 1234" because you want each commit to link to a work item in your ticketing system. You must look at each commit being pushed up, see if that string is in the commit message, and, if the string is absent from any of the commits, exit non-zero so the push is rejected.

You can get a list of the SHA-1 values of all the commits that are being pushed by taking the `$newrev` and `$oldrev` values and passing them to a Git plumbing command called `git rev-list`. This is basically the `git log` command, but by default it prints out only the SHA-1 values and no other information. So, to get a list of all the commit SHAs introduced between one commit SHA and another, you can run something like this:

	$ git rev-list 538c33..d14fc7
	d14fc7c847ab946ec39590d87783c69b031bdfb7
	9f585da4401b0a3999e84113824d15245c13f0be
	234071a1be950e2a8d078e6141f5cd20c1e61ad3
	dfa04c9ef3d5197182f13fb5b9b1fb7717d2222a
	17716ec0f1ff5c77eff40b7fe912f9f6cfd0e475

You can take that output, loop through each of those commit SHAs, grab the message for it, and test that message against a regular expression that looks for a pattern.

You have to figure out how to get the commit message from each of these commits to test. To get the raw commit data, you can use another plumbing command called `git cat-file`. I’ll go over all these plumbing commands in detail in Chapter 9; but for now, here’s what that command gives you:

	$ git cat-file commit ca82a6
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

A simple way to get the commit message from a commit when you have the SHA-1 value is to go to the first blank line and take everything after that. You can do so with the `sed` command on Unix systems:

	$ git cat-file commit ca82a6 | sed '1,/^$/d'
	changed the version number

You can use that incantation to grab the commit message from each commit that is trying to be pushed and exit if you see anything that doesn’t match. To exit the script and reject the push, exit non-zero. The whole method looks like this:

	$regex = /\[ref: (\d+)\]/

	# enforced custom commit message format
	def check_message_format
	  missed_revs = `git rev-list #{$oldrev}..#{$newrev}`.split("\n")
	  missed_revs.each do |rev|
	    message = `git cat-file commit #{rev} | sed '1,/^$/d'`
	    if !$regex.match(message)
	      puts "[POLICY] Your message is not formatted correctly"
	      exit 1
	    end
	  end
	end
	check_message_format

Putting that in your `update` script will reject updates that contain commits that have messages that don’t adhere to your rule.

#### Enforcing a User-Based ACL System ####

Suppose you want to add a mechanism that uses an access control list (ACL) that specifies which users are allowed to push changes to which parts of your projects. Some people have full access, and others only have access to push changes to certain subdirectories or specific files. To enforce this, you’ll write those rules to a file named `acl` that lives in your bare Git repository on the server. You’ll have the `update` hook look at those rules, see what files are being introduced for all the commits being pushed, and determine whether the user doing the push has access to update all those files.

The first thing you’ll do is write your ACL. Here you’ll use a format very much like the CVS ACL mechanism: it uses a series of lines, where the first field is `avail` or `unavail`, the next field is a comma-delimited list of the users to which the rule applies, and the last field is the path to which the rule applies (blank meaning open access). All of these fields are delimited by a pipe (`|`) character.

In this case, you have a couple of administrators, some documentation writers with access to the `doc` directory, and one developer who only has access to the `lib` and `tests` directories, and your ACL file looks like this:

	avail|nickh,pjhyett,defunkt,tpw
	avail|usinclair,cdickens,ebronte|doc
	avail|schacon|lib
	avail|schacon|tests

You begin by reading this data into a structure that you can use. In this case, to keep the example simple, you’ll only enforce the `avail` directives. Here is a method that gives you an associative array where the key is the user name and the value is an array of paths to which the user has write access:

	def get_acl_access_data(acl_file)
	  # read in ACL data
	  acl_file = File.read(acl_file).split("\n").reject { |line| line == '' }
	  access = {}
	  acl_file.each do |line|
	    avail, users, path = line.split('|')
	    next unless avail == 'avail'
	    users.split(',').each do |user|
	      access[user] ||= []
	      access[user] << path
	    end
	  end
	  access
	end

On the ACL file you looked at earlier, this `get_acl_access_data` method returns a data structure that looks like this:

	{"defunkt"=>[nil],
	 "tpw"=>[nil],
	 "nickh"=>[nil],
	 "pjhyett"=>[nil],
	 "schacon"=>["lib", "tests"],
	 "cdickens"=>["doc"],
	 "usinclair"=>["doc"],
	 "ebronte"=>["doc"]}

Now that you have the permissions sorted out, you need to determine what paths the commits being pushed have modified, so you can make sure the user who’s pushing has access to all of them.

You can pretty easily see what files have been modified in a single commit with the `--name-only` option to the `git log` command (mentioned briefly in Chapter 2):

	$ git log -1 --name-only --pretty=format:'' 9f585d

	README
	lib/test.rb

If you use the ACL structure returned from the `get_acl_access_data` method and check it against the listed files in each of the commits, you can determine whether the user has access to push all of their commits:

	# only allows certain users to modify certain subdirectories in a project
	def check_directory_perms
	  access = get_acl_access_data('acl')

	  # see if anyone is trying to push something they can't
	  new_commits = `git rev-list #{$oldrev}..#{$newrev}`.split("\n")
	  new_commits.each do |rev|
	    files_modified = `git log -1 --name-only --pretty=format:'' #{rev}`.split("\n")
	    files_modified.each do |path|
	      next if path.size == 0
	      has_file_access = false
	      access[$user].each do |access_path|
	        if !access_path  # user has access to everything
	          || (path.index(access_path) == 0) # access to this path
	          has_file_access = true 
	        end
	      end
	      if !has_file_access
	        puts "[POLICY] You do not have access to push to #{path}"
	        exit 1
	      end
	    end
	  end  
	end

	check_directory_perms

Most of that should be easy to follow. You get a list of new commits being pushed to your server with `git rev-list`. Then, for each of those, you find which files are modified and make sure the user who’s pushing has access to all the paths being modified. One Rubyism that may not be clear is `path.index(access_path) == 0`, which is true if path begins with `access_path` — this ensures that `access_path` is not just in one of the allowed paths, but an allowed path begins with each accessed path. 

Now your users can’t push any commits with badly formed messages or with modified files outside of their designated paths.

#### Enforcing Fast-Forward-Only Pushes ####

The only thing left is to enforce fast-forward-only pushes. In Git versions 1.6 or newer, you can set the `receive.denyDeletes` and `receive.denyNonFastForwards` settings. But enforcing this with a hook will work in older versions of Git, and you can modify it to do so only for certain users or whatever else you come up with later.

The logic for checking this is to see if any commits are reachable from the older revision that aren’t reachable from the newer one. If there are none, then it was a fast-forward push; otherwise, you deny it:

	# enforces fast-forward only pushes 
	def check_fast_forward
	  missed_refs = `git rev-list #{$newrev}..#{$oldrev}`
	  missed_ref_count = missed_refs.split("\n").size
	  if missed_ref_count > 0
	    puts "[POLICY] Cannot push a non fast-forward reference"
	    exit 1
	  end
	end

	check_fast_forward

Everything is set up. If you run `chmod u+x .git/hooks/update`, which is the file you into which you should have put all this code, and then try to push a non-fast-forwarded reference, you get something like this:

	$ git push -f origin master
	Counting objects: 5, done.
	Compressing objects: 100% (3/3), done.
	Writing objects: 100% (3/3), 323 bytes, done.
	Total 3 (delta 1), reused 0 (delta 0)
	Unpacking objects: 100% (3/3), done.
	Enforcing Policies... 
	(refs/heads/master) (8338c5) (c5b616)
	[POLICY] Cannot push a non-fast-forward reference
	error: hooks/update exited with error code 1
	error: hook declined to update refs/heads/master
	To git@gitserver:project.git
	 ! [remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'

There are a couple of interesting things here. First, you see this where the hook starts running.

	Enforcing Policies... 
	(refs/heads/master) (fb8c72) (c56860)

Notice that you printed that out to stdout at the very beginning of your update script. It’s important to note that anything your script prints to stdout will be transferred to the client.

The next thing you’ll notice is the error message.

	[POLICY] Cannot push a non fast-forward reference
	error: hooks/update exited with error code 1
	error: hook declined to update refs/heads/master

The first line was printed out by you, the other two were Git telling you that the update script exited non-zero and that is what is declining your push. Lastly, you have this:

	To git@gitserver:project.git
	 ! [remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'

You’ll see a remote rejected message for each reference that your hook declined, and it tells you that it was declined specifically because of a hook failure.

Furthermore, if the ref marker isn’t there in any of your commits, you’ll see the error message you’re printing out for that.

	[POLICY] Your message is not formatted correctly

Or if someone tries to edit a file they don’t have access to and push a commit containing it, they will see something similar. For instance, if a documentation author tries to push a commit modifying something in the `lib` directory, they see

	[POLICY] You do not have access to push to lib/test.rb

That’s all. From now on, as long as that `update` script is there and executable, your repository will never be rewound and will never have a commit message without your pattern in it, and your users will be sandboxed.

### Client-Side Hooks ###

The downside to this approach is the whining that will inevitably result when your users’ commit pushes are rejected. Having their carefully crafted work rejected at the last minute can be extremely frustrating and confusing; and furthermore, they will have to edit their history to correct it, which isn’t always for the faint of heart.

The answer to this dilemma is to provide some client-side hooks that users can use to notify them when they’re doing something that the server is likely to reject. That way, they can correct any problems before committing and before those issues become more difficult to fix. Because hooks aren’t transferred with a clone of a project, you must distribute these scripts some other way and then have your users copy them to their `.git/hooks` directory and make them executable. You can distribute these hooks within the project or in a separate project, but there is no way to set them up automatically.

To begin, you should check your commit message just before each commit is recorded, so you know the server won’t reject your changes due to badly formatted commit messages. To do this, you can add the `commit-msg` hook. If you have it read the message from the file passed as the first argument and compare that to the pattern, you can force Git to abort the commit if there is no match:

	#!/usr/bin/env ruby
	message_file = ARGV[0]
	message = File.read(message_file)

	$regex = /\[ref: (\d+)\]/

	if !$regex.match(message)
	  puts "[POLICY] Your message is not formatted correctly"
	  exit 1
	end

If that script is in place (in `.git/hooks/commit-msg`) and executable, and you commit with a message that isn’t properly formatted, you see this:

	$ git commit -am 'test'
	[POLICY] Your message is not formatted correctly

No commit was completed in that instance. However, if your message contains the proper pattern, Git allows you to commit:

	$ git commit -am 'test [ref: 132]'
	[master e05c914] test [ref: 132]
	 1 files changed, 1 insertions(+), 0 deletions(-)

Next, you want to make sure you aren’t modifying files that are outside your ACL scope. If your project’s `.git` directory contains a copy of the ACL file you used previously, then the following `pre-commit` script will enforce those constraints for you:

	#!/usr/bin/env ruby

	$user    = ENV['USER']

	# [ insert acl_access_data method from above ]

	# only allows certain users to modify certain subdirectories in a project
	def check_directory_perms
	  access = get_acl_access_data('.git/acl')

	  files_modified = `git diff-index --cached --name-only HEAD`.split("\n")
	  files_modified.each do |path|
	    next if path.size == 0
	    has_file_access = false
	    access[$user].each do |access_path|
	    if !access_path || (path.index(access_path) == 0)
	      has_file_access = true
	    end
	    if !has_file_access
	      puts "[POLICY] You do not have access to push to #{path}"
	      exit 1
	    end
	  end
	end

	check_directory_perms

This is roughly the same script as the server-side part, but with two important differences. First, the ACL file is in a different place, because this script runs from your working directory, not from your Git directory. You have to change the path to the ACL file from this

	access = get_acl_access_data('acl')

to this:

	access = get_acl_access_data('.git/acl')

The other important difference is the way you get a listing of the files that have been changed. Because the server-side method looks at the log of commits, and, at this point, the commit hasn’t been recorded yet, you must get your file listing from the staging area instead. Instead of

	files_modified = `git log -1 --name-only --pretty=format:'' #{ref}`

you have to use

	files_modified = `git diff-index --cached --name-only HEAD`

But those are the only two differences — otherwise, the script works the same way. One caveat is that it expects you to be running locally as the same user you push as to the remote machine. If that is different, you must set the `$user` variable manually.

The last thing you have to do is check that you’re not trying to push non-fast-forwarded references, but that is a bit less common. To get a reference that isn’t a fast-forward, you either have to rebase past a commit you’ve already pushed up or try pushing a different local branch up to the same remote branch.

Because the server will tell you that you can’t push a non-fast-forward anyway, and the hook prevents forced pushes, the only accidental thing you can try to catch is rebasing commits that have already been pushed.

Here is an example pre-rebase script that checks for that. It gets a list of all the commits you’re about to rewrite and checks whether they exist in any of your remote references. If it sees one that is reachable from one of your remote references, it aborts the rebase:

	#!/usr/bin/env ruby

	base_branch = ARGV[0]
	if ARGV[1]
	  topic_branch = ARGV[1]
	else
	  topic_branch = "HEAD"
	end

	target_shas = `git rev-list #{base_branch}..#{topic_branch}`.split("\n")
	remote_refs = `git branch -r`.split("\n").map { |r| r.strip }

	target_shas.each do |sha|
	  remote_refs.each do |remote_ref|
	    shas_pushed = `git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}`
	    if shas_pushed.split(“\n”).include?(sha)
	      puts "[POLICY] Commit #{sha} has already been pushed to #{remote_ref}"
	      exit 1
	    end
	  end
	end

This script uses a syntax that wasn’t covered in the Revision Selection section of Chapter 6. You get a list of commits that have already been pushed up by running this:

	git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}

The `SHA^@` syntax resolves to all the parents of that commit. You’re looking for any commit that is reachable from the last commit on the remote and that isn’t reachable from any parent of any of the SHAs you’re trying to push up — meaning it’s a fast-forward.

The main drawback to this approach is that it can be very slow and is often unnecessary — if you don’t try to force the push with `-f`, the server will warn you and not accept the push. However, it’s an interesting exercise and can in theory help you avoid a rebase that you might later have to go back and fix.

## Summary ##

You’ve covered most of the major ways that you can customize your Git client and server to best fit your workflow and projects. You’ve learned about all sorts of configuration settings, file-based attributes, and event hooks, and you’ve built an example policy-enforcing server. You should now be able to make Git fit nearly any workflow you can dream up.

<!--  LocalWords:  simplifiez-vous
 -->
