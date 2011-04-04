# Utilitaires Git #

A présent, vous avez appris les commandes et modes de fonctionnements usuels requis pour gérer et maintenir un dépôt Git pour la gestion de votre code source.
Vous avez déroulé les routines de suivi (*tracking*) et de consignation (*committing*) de fichiers, vous avez exploité la puissance de la zone d'attente (*staging area*), de la création et de la fusion de branches locales de travail.

Maintenant, vous allez explorer un certain nombre de fonctionnalités particulièrement efficaces, fonctionnalités que vous n'utiliserez que rarement mais dont vous pourriez avoir l'usage à un moment ou à un autre.

## Sélection des versions ##

Git vous permet d'adresser certains *commits* ou un ensemble de *commits* de différentes façons.
Si elles ne sont pas toutes évidentes il est bon de les connaître.

### Révisions ponctuelles ###

Naturellement, vous pouvez référencer un commit par la signature SHA-1, mais il existe des méthodes plus confortables pour le genre humain.
Cette section présente les méthodes pour référencer un commit simple.

### Empreinte SHA courte ###

Git est capable de deviner de quel commit vous parlez si vous ne fournissez que quelques caractères au début de la signature, tant que votre SHA-1 partiel comporte au moins 4 caractères et ne génère pas de collision.
Dans ces conditions, un seul objet correspondra à ce SHA-1.

Par exemple, pour afficher un commit précis, supposons que vous exécutiez `git log` et que vous identifiez le commit où vous avez introduit une fonctionnalité précise.

	$ git log
	commit 734713bc047d87bf7eac9674765ae793478c50d3
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Jan 2 18:32:33 2009 -0800

	    fixed refs handling, added gc auto, updated tests

	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Merge: 1c002dd... 35cfb2b...
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

	commit 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 14:58:32 2008 -0800

	    added some blame and merge stuff

Pour cet exemple, choisissons `1c002dd....`
Si vous affichez le contenu de ce commit via `git show`, les commandes suivantes sont équivalentes (en partant du principe que les SHA-1 courts ne sont pas ambigüs).

	$ git show 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	$ git show 1c002dd4b536e7479f
	$ git show 1c002d

Git peut déterminer un SHA tout à la fois le plus court possible et non ambigü.
Ajoutez l'option `--abbrev-commit` à la commande `git log` et le résultat affiché utilisera des valeurs plus courtes mais uniques; par défaut git retiendra 7 caractères et augmentera au besoin :

	$ git log --abbrev-commit --pretty=oneline
	ca82a6d changed the version number
	085bb3b removed unnecessary test code
	a11bef0 first commit

En règle générale, entre 8 et 10 caractères sont largement suffisant pour assurer l'unicité dans un projet.
Un des plus gros projets utilisant Git, le kernel Linux, nécessite de plus en plus fréquemment 12 caractères sur les 40 possibles pour assurer l'unicité.

### QUELQUES MOTS SUR SHA-1 ###

Beaucoup de gens se soucient qu'à un moment donné ils auront, par des circonstances hasardeuses, deux objets dans leur référentiel de hachage de même empreinte SHA-1.
Qu'en est-il réellement ?

S'il vous arrivait de consigner (*commit*) un objet qui se hache de la même empreinte SHA-1 d'un objet existant dans votre référentiel, Git verrez l'objet existant déjà dans votre base de données et Git présumera qu'il était déjà enregistré.
Si vous essayez de récupérer l'objet de nouveau à un moment donné, vous aurez toujours les données du premier objet.

Quoi qu'il en soit, vous devriez être conscient à quel point ce scénario est ridiculement improbable.
Une empreinte SHA-1 porte sur 20 octets soit 160bits.
Le nombre d'objet aléatoires à hasher requis pour assurer une probabilité de collision de 50% vaut environ 2^80 (la formule pour calculer la probabilité de collision est `p = (n(n-1)/2) * (1/2^160))`.
2^80 vaut 1.2 x 10^24 soit 1 million de milliards de milliards.
Cela représente 1200 fois le nombre de grains de sable sur terre.

Voici un exemple pour vous donner une idée de ce qui pourrait provoquer une collision du SHA-1.
Si tous les 6,5 milliards d'humains sur Terre programmait et que chaque seconde, chacun produisait du code équivalent à l'historique entier du noyaux Linux (1 million d'objets Git) et le poussait sur un énorme dépôt Git, cela prendrait 5 ans pour que ce dépôt contienne assez d'objets pour avoir une probabilité de 50% qu'une seule collision SHA-1 existe.
Il y a une probabilité plus grande que tous les membres de votre équipe de programmation serait attaqués et tués par des loups dans des incidents sans relation la même nuit.

### Références de branches ###

La méthode la plus commune pour désigner un commit est une branche y pointant.
Dès lors, vous pouvez utiliser le nom de la branche dans toute commande utilisant un objet de type commit ou un SHA-1.
Par exemple, si vous souhaitez afficher le dernier commit d'une branche, les commandes suivantes sont équivalentes, en supposant que la branche `sujet1` pointe sur `ca82a6d` :

	$ git show ca82a6dff817ec66f44342007202690a93763949
	$ git show sujet1

Pour connaître l'empreinte SHA sur lequel pointe une branche, ou pour savoir parmi tous les exemples précédents ce que cela donne en terme de SHA, vous pouvez utiliser la commande de plomberie nommée `rev-parse`.
Se référer au chapitre 9 pour plus d'informations sur les commandes de plomberie; en résumé, `rev-parse` est là pour les opérations de bas niveau et n'est pas conçue pour être utilisée au jour le jour.
Quoi qu'il en soit, cela peut se révéler utile pour comprendre ce qui se passe.
Je vous invite à tester `rev-parse` sur votre propre branche.

	$ git rev-parse sujet1
	ca82a6dff817ec66f44342007202690a93763949

### Raccourcis RefLog ###

Git maintient en arrière-plan un historique des références où sont passées HEAD et vos branches sur les dernieres mois - ceci s'appelle le reflog.

Vous pouvez le consulter avec la commande `git reflog` :

	$ git reflog
	734713b... HEAD@{0}: commit: fixed refs handling, added gc auto, updated
	d921970... HEAD@{1}: merge phedders/rdocs: Merge made by recursive.
	1c002dd... HEAD@{2}: commit: added some blame and merge stuff
	1c36188... HEAD@{3}: rebase -i (squash): updating HEAD
	95df984... HEAD@{4}: commit: # This is a combination of two commits.
	1c36188... HEAD@{5}: rebase -i (squash): updating HEAD
	7e05da5... HEAD@{6}: rebase -i (pick): updating HEAD

À chaque fois que l'extrémité de votre branche est modifiée, Git enregistre cette information pour vous dans son historique temporaire.
Vous pouvez référencer d'anciens commits avec cette donnée.
Si vous souhaitez consulter le n-ième antécédent de votre HEAD, vous pouvez utiliser la référence `@{n}` du reflog, 5 dans cet exemple :

	$ git show HEAD@{5}

Vous pouvez également remonter le temps et savoir où en était une branche à un moment donné.
Par exemple, pour savoir où en était la branche `master` hier (yesterday en anglais), tapez :

	$ git show master@{yesterday}

Cette technique fonctionne uniquement si l'information est encore présente dans le reflog, vous ne pourrez donc pas consulter les commits trop anciens.

Pour consulter le reflog au format `git log`, exécutez: `git log -g` :

	$ git log -g master
	commit 734713bc047d87bf7eac9674765ae793478c50d3
	Reflog: master@{0} (Scott Chacon <schacon@gmail.com>)
	Reflog message: commit: fixed refs handling, added gc auto, updated 
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Jan 2 18:32:33 2009 -0800

	    fixed refs handling, added gc auto, updated tests

	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Reflog: master@{1} (Scott Chacon <schacon@gmail.com>)
	Reflog message: merge phedders/rdocs: Merge made by recursive.
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

Veuillez noter que le reflog ne stocke que des informations locales, c'est un historique de ce que vous avez fait dans votre dépôt.
Les références ne sont pas copiées dans un autre dépôt; et juste après le clone d'un dépôt, votre reflog sera vide, puisque qu'aucune activité ne s'y sera produite.
Exécuter `git show` HEAD@{2.months.ago}` ne fonctionnera que si vous avez dupliqué ce projet depuis au moins 2 mois — si vous l'avez dupliqué il y a 5 minutes, vous n'obtiendrez rien.

### Références passées ###

Une solution fréquente de référencer un commit est d'utiliser son ancêtre.
Si vous suffixez une référence par `^`, Git la résoudra comme étant le parent de cette référence.
Supposons que vous consultiez votre historique :

	$ git log --pretty=format:'%h %s' --graph
	* 734713b fix sur la gestion des refs, ajout gc auto, mise à jour des tests
	*   d921970 Merge commit 'phedders/rdocs'
	|\  
	| * 35cfb2b modifs minor rdoc
	* | 1c002dd ajout blame and merge
	|/  
	* 1c36188 ignore *.gem
	* 9b29157 ajout open3_detach à la liste des fichiers gemspcec

Alors, vous pouvez consulter le commit précédent en spécifiant `HEAD^`, ce qui signifie "le parent de HEAD" :

	$ git show HEAD^
	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Merge: 1c002dd... 35cfb2b...
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

Vous pouvez également spécifier un nombre après `^` — par exemple, `d921970^2` signifie "le second parent de d921970.".
Cette syntaxe ne sert que pour les commits de fusion, qui ont plus d'un parent.
Le premier parent est la branche où vous avez fusionné, et le second est le commit de la branche que vous avez fusionnée : 

	$ git show d921970^
	commit 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 14:58:32 2008 -0800

	    ajout blame and merge

	$ git show d921970^2
	commit 35cfb2b795a55793d7cc56a6cc2060b4bb732548
	Author: Paul Hedderly <paul+git@mjr.org>
	Date:   Wed Dec 10 22:22:03 2008 +0000

	    modifs minor rdoc

Une autre solution courante pour spécifier une référence est le `~`.
Il fait également référence au premier parent, donc `HEAD~` et `HEAD^` sont équivalents.
La différence se fait sentir si vous spécifiez un nombre.
`HEAD~2` signifie "le premier parent du premier parent," ou bien "le grand-parent"; ça remonte les premiers parents autant de fois que demandé.
Par exemple, dans l'historique précédemment présenté, `HEAD~3` serait :

	$ git show HEAD~3
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

Cela aura bien pu être écrit `HEAD^^^`, qui là encore est le premier parent du premier parent du premier parent :

	$ git show HEAD^^^
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

Vous pouvez également combiner ces syntaxes — vous pouvez obtenir le second parent de la référence précédente (en supposant que c'était un commit de fusion) en utilisant `HEAD~3^2`, etc.

### Plages de commits ###

A présent que vous pouvez spécifier des commits individuels, voyons comme spécifier une place de commits.
Ceci est particulièrement pratique pour la gestion des branches — si vous avez beaucoup de branches, vous pouvez utiliser les plages pour adresser des problèmes tels que "Quelle activité sur cette branche n'ai-je pas encore fusionné sur ma branche principale ?".

#### Double point ####

La plus fréquente spécification de plage de commit est la syntaxe double-point.
En gros, cela demande à Git de résoudre la plage des commits qui sont accessible depuis un commit mais ne le sont pas depuis un autre.
Par exemple, disons que votre historique ressemble à celui de la Figure 6-1.

Insert 18333fig0601.png 
Figure 6-1. Exemple d'historique pour la sélection de plages de commits.

Si vous voulez savoir ce que n'a pas encore été fusionné sur votre branche master depuis votre branche `experiment`, vous pouvez demandez à Git de vous montrer un listing des commits avec `master..experiment` — ce qui signifie "tous les commits accessibles par experiment qui ne le sont pas par master.".
Dans un souci de brièveté et de clarté de ces exemples, je vais utiliser les lettres des commits issus du diagramme à la place du vrai listing dans l'ordre où ils auraient dû être affichés :

	$ git log master..experiment
	D
	C

D'un autre côté, si vous souhaitez voir l'opposé — tous les commits dans `master` mais pas encore dans `experiment` — vous pouvez inverser les noms de branches, `experiment..master` vous montre tout ce que `master` accède mais qu'experiment ne voit pas :

	$ git log experiment..master
	F
	E

C'est pratique si vous souhaitez maintenir `experiment` à jour et anticiper les fusions.
Une autre cas d'utilisation fréquent et de voir ce que vous vous appréter à pousser sur une branche distante :

	$ git log origin/master..HEAD

Cette commande vous affiche tous les commits de votre branche courante qui ne sont pas sur la branche `master` du dépôt distant `origin`.
Si vous exécutez `git push` et que votre branche courante suit `origin/master`, les commits listés par `git log origin/master..HEAD` sont les commits qui seront transférés sur le serveur.
Vous pouvez également laisser tomber une borne de la syntaxe pour faire comprendre à Git que vous parlez de HEAD.
Par exemple, vous pouvez obtenir les mêmes résultats que précédemment en tapant `git log origin/master..` — Git utilise HEAD si une des bornes est manquante.

#### Emplacements multiples ####

La syntaxe double-point est pratique comme raccourci; mais peut-être souhaitez-vous utiliser plus d'une branche pour spécifier une révision, comme pour voir quels commits sont dans plusieurs branches mais qui sont absents de la branche courante.
Git vous permets cela avec `^` or `--not` en préfixe de toute référence de laquelle vous ne souhaitez pas voir les commits.
Les 3 commandes ci-après sont équivalentes :

	$ git log refA..refB
	$ git log ^refA refB
	$ git log refB --not refA

C'est utile car cela vous permets de spécifier plus de 2 références dans votre requête, ce que vous ne pouvez accomplir avec la syntaxe double-point.
Par exemple, si vous souhaitez voir les commits qui sont accessibles depuis `refA` et `refB` mais pas depuis `refC`, vous pouvez taper ces 2 commandes :

	$ git log refA refB ^refC
	$ git log refA refB --not refC

Ceci vous fournit un système de requêtage des révisions très puissant, pour vous aider à saisir ce qui se trouve sur vos branches.

#### Triple point ####

La dernière syntaxe majeure de sélection de plage de commits est la syntaxe triple-point, qui spécifie tous les commits accessible par l'une des deux référence, exclusivement.
Toujours avec l'exemple d'historique à la figure 6-1, si vous voulez voir ce qui ce trouve sur `master` ou `experiment` mais pas sur les 2, exécutez :

	$ git log master...experiment
	F
	E
	D
	C

Encore une fois, cela vous donne un `log` normal mais ne vous montre les informations que pour ces quatre commits, dans l'ordre naturel des dates de commit.

Une option courante à utiliser avec la commande `log` dans ce cas est `--left-right` qui vous montre de quelle borne de la plage ce commit fait partie.
Cela rend les données plus utiles :

	$ git log --left-right master...experiment
	< F
	< E
	> D
	> C

Avec ces outils, vous pourrez utiliser Git pour savoir quels commits inspecter.

## Mise en attente interactive ##

Git propose quelques scripts qui rendent les opérations en ligne de commande plus simple.
Nous allons à présent découvrir des commandes interactives vous permettant de choisir les fichiers ou une partie d'un fichier à incorporer à un commit.
Ces outils sont particulièrement pratiques si vous modifiez un large périmètre de fichiers et que vous souhaitez les commiter séparement plutôt que massivement.
De la sorte, vous vous assurez que vos commits sont des ensembles cohérents et qu'ils peuvent être facilement revus par vos collaborateurs.
Si vous exécutez `git add` avec l'option `-i` ou `--interactive`, Git rentre en mode interactif, affichant quelque chose comme :

	$ git add -i
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 

Vous vous apercevrez que cette commande propose une vue bien différente de votre zone d'attente; en gros, c'est la même information que vous auriez obtenue avec `git status` mais en plus succint et plus instructif.
Cela liste les modifications que vous avez mises en attente à gauche, et celles en cours à droite.

En dessous vient la section des commandes (*** Commands ***).
Vous pourrez y faire bon nombre de choses, notamment mettre en attente des fichiers, les enlever de la zone d'attente, mettre en attente des parties de fichiers, ajouter des fichiers non indexés, et vérifier les différences de ce que vous avez mis en attente.

### Mettre en attente des fichiers ###

Si vous tapez `2` ou `u` au prompt `What now>`, le script vous demande quels fichiers vous voulez mettre en attente :

	What now> 2
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

Pour mettre en attente les fichiers TODO et index.html, vous pouvez taper ces nombres :

	Update>> 1,2
	           staged     unstaged path
	* 1:    unchanged        +0/-1 TODO
	* 2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

Le caractère `*` au début de la ligne de chaque fichier indique que celui-ci est sélectionné.
Si vous tapez Entrée sur une invite `Update>>` vide, Git prend tout ce qui est sélectionné et le met en attente pour vous :

	Update>> 
	updated 2 paths

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 1
	           staged     unstaged path
	  1:        +0/-1      nothing TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

À présent, vous pouvez voir que les fichiers TODO et index.html sont mis en attente (staged en anglais) et que simplgit.rb ne l'est toujours pas.
Si vous souhaitez enlever de la zone d'attente le fichier TODO, utilisez `3` (ou `r` pour revert en anglais) :

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 3
	           staged     unstaged path
	  1:        +0/-1      nothing TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Revert>> 1
	           staged     unstaged path
	* 1:        +0/-1      nothing TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Revert>> [enter]
	reverted one path

Un aperçu rapide à votre statut Git et vous pouvez voir que vous avez enlever de la zone d'attente le fichier TODO :

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

Pour voir la modification que vous avez mise en attente, utilisez `6` ou `d` (pour diff en anglais).
Cela vous affiche la liste des fichiers en attente et vous pouvez choisir ceux pour lesquels vous voulez consulter la différence.
C'est équivalent à `git diff --cached` en ligne de commande :

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 6
	           staged     unstaged path
	  1:        +1/-1      nothing index.html
	Review diff>> 1
	diff --git a/index.html b/index.html
	index 4d07108..4335f49 100644
	--- a/index.html
	+++ b/index.html
	@@ -16,7 +16,7 @@ Date Finder

	 <p id="out">...</p>

	-<div id="footer">contact : support@github.com</div>
	+<div id="footer">contact : email.support@github.com</div>

	 <script type="text/javascript">

Avec ces commandes élémentaires, vous pouvez utiliser l'ajout interactif pour manipuler votre zone d'attente un peu plus facilement.

### Patches de Staging ###

Git est également capable de mettre en attente certaines parties d'un fichier.
Par exemple, si vous modifiez en 2 endroits votre fichier simplegit.rb et que vous souhaitez mettre en attente l'une d'entre elles seulement, cela peut se faire très aisément avec Git.
En mode interactif, tapez `5` ou `p` (pour patch en anglais).
Git vous demandera quels fichiers vous voulez mettre en attente partiellement, puis, pour chaque section des fichiers sélectionnés, il affichera les parties de fichiers où il y a des différences et vous demandera si vous souhaitez les mettre en attente, un par un :

	diff --git a/lib/simplegit.rb b/lib/simplegit.rb
	index dd5ecc4..57399e0 100644
	--- a/lib/simplegit.rb
	+++ b/lib/simplegit.rb
	@@ -22,7 +22,7 @@ class SimpleGit
	   end

	   def log(treeish = 'master')
	-    command("git log -n 25 #{treeish}")
	+    command("git log -n 30 #{treeish}")
	   end

	   def blame(path)
	Stage this hunk [y,n,a,d,/,j,J,g,e,?]? 

A cette étape, vous disposez de bon nombre d'options.
`?` vous liste les actions possibles, voici une traduction :

	Mettre en attente cette partie [y,n,a,d,/,j,J,g,e,?]? ?
	y - mettre en attente cette partie
	n - ne pas mettre en attente cette partie
	a - mettre en attente cette partie et toutes celles restantes dans ce fichier
	d - ne pas mettre en attente cette partie ni aucune de celles restantes dans ce fichier
	g - sélectionner un partie à voir
	/ - chercher une partie correspondant à la regexp donnée
	j - laisser cette partie non décidée, voir la prochaine partie non encore décidée
	J - laisser cette partie non décidée, voir la prochaine partie
	k - laisser cette partie non décidée, voir la partie non encore décidée précendente
	K - laisser cette partie non décidée, voir la partie précédente
	s - couper la partie courante en parties plus petites
	e - modifier manuellement la partie courante
	? - afficher l'aide

En règle générale, vous choisirez `y` ou `n` pour mettre en attente ou non chacun des blocs, mais tout mettre en attente pour certains fichiers ou remettre à plus tard le choix pour un bloc peut également être utile.
Si vous mettez en attente une partie d'un fichier et laissez une autre partie non en attente, vous statut ressemblera à peu près à ceci :

	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:        +1/-1        +4/-0 lib/simplegit.rb

Le statut pour le fichier simplegit.rb est intéressant.
Il vous montre que quelques lignes sont en attente et d'autres non.
Vous avez mis partiellement ce fichier en attente.
Dès lors, vous pouvez quitter l'ajout interactif et exécuter `git commit` pour commiter les fichiers partiellement en attente.

Enfin, vous pouvez vous passer du mode interactif pour mettre partiellement un fichier en attente; vous pouvez faire de même avec `git add -p` ou `git add --patch` en ligne de commande.

## La remise ##

Souvent, lorsque vous avez travaillé sur une partie de votre projet, les choses sont dans un état instable mais vous voulez changer de branches pour un peu de travailler sur autre chose.
Le problème est que vous ne voulez pas consigner (commit) un travail à moitié fait seulement pour pouvoir y revenir plus tard.
La réponse à cette problématique est la commande `git stash`.

Remiser prend l'état en cours de votre répertoire de travail, c'est-à-dire les fichiers modifiés et la zone d'attente, et l'enregistre dans la pile des modifications non finies que vous pouvez réappliquer à n'importe quel moment.

### Remiser votre travail ###

Pour démontrer cette possibilité, vous allez dans votre projet et commencez à travailler sur quelques fichiers et mettre en zone d'attente l'un de ces changements.
Si vous exécutez `git status`, vous pouvez voir votre état instable:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#

À ce moment là, vous voulez changer de branche, mais vous ne voulez pas encore consigner ce travail; vous allez donc remiser vos modifications.
Pour créer une nouvelle remise sur votre pile, exécutez `git stash` :

	$ git stash
	Saved working directory and index state \
	  "WIP on master: 049d078 added the index file"
	HEAD is now at 049d078 added the index file
	(To restore them type "git stash apply")

Votre répertoire de travail est propre :

	$ git status
	# On branch master
	nothing to commit (working directory clean)

À ce moment, vous pouvez facilement changer de branche et travailler autre part; vos modifications sont conservées dans votre pile.
Pour voir quelles remises vous avez sauvegardées, vous pouvez utiliser la commande `git stash list` :

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051... Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5... added number to log

Dans ce cas, deux remises on été créées précédemment, vous avez donc accès à trois travaux remisés différents.
Vous pouvez réappliquer celui que vous venez juste de remisé en utilisant la commande affichée dans la sortie d'aide de la première commande de remise : `git stash apply`.
Si vous voulez appliquer une remise plus ancienne, vous pouvez la spécifier en la nommant, comme ceci : `git stash apply stash@{2}`.
Si vous ne spécifier pas une remise, Git présume que vous voulez la remise la plus récente et essayes de l'appliquer.

	$ git stash apply
	# On branch master
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   index.html
	#      modified:   lib/simplegit.rb
	#

Vous pouvez observer que Git remodifie les fichiers non consignés lorsque vous avez créé la remise.
Dans ce cas, vous aviez un répertoire de travail propre lorsque vous avez essayer d'appliquer la remise, et vous l'avez fait sur la même branche que celle où vous l'aviez créée; mais avoir un répertoire de travail propre et l'appliquer sur la même branche n'est pas nécessaire pour réussir à appliquer une remise.
Vous pouvez très bien créer une remise sur une branche, changer de branche et essayer d'appliquer les modifications.
Vous pouvez même avoir des fichiers modifiés et non consignés dans votre répertoire de travail quand vous appliquez une remise, Git vous fournit les conflits de fusions si quoique ce soit ne s'applique pas proprement.

Par défaut, les modifications de vos fichiers sont réappliqués, mais pas les mises en attente.
Pour cela, vous devez exécutez la commande `git stash apply` avec l'option `--index` pour demandez à Git d'essayer de réappliquer les modifications de votre zone d'attente.
Si vous exécutez cela à la place de la commande précédente, vous vous retrouvez dans la position d'origine de la remise :

	$ git stash apply --index
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#

L'option `apply` essaye seulement d'appliquer le travail remisé, vous aurez toujours la remise dans votre pile.
Pour la supprimer, vous pouvez exécuter `git stash drop` avec le nom de la remise à supprimer :

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051... Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5... added number to log
	$ git stash drop stash@{0}
	Dropped stash@{0} (364e91f3f268f0900bc3ee613f9f733e82aaed43)

Vous pouvez également exécutez `git stash pop` pour appliquer et supprimer immédiatement la remise de votre pile.

### Créer une branche depuis une remise ###

Si vous remiser votre travail, l'oubliez pendant un temps en continuant sur la branche où vous avez créé la remise, vous pouvez avoir un problème en réappliquant le travail.
Si l'application de la remise essaye de modifier un fichier que vous avez modifié depuis, vous allez obtenir des conflits de fusion et vous devrez essayer de les résoudre.
Si vous voulez un moyen plus facile de tester une nouvelle fois les modifications remisées, vous pouvez exécuter `git stash branch`, qui créera une nouvelle branche à votre place, récupérant le commit où vous étiez lorsque vous avez créé la remise, réappliquera votre travail dedans, et supprimera finalement votre remise si cela a réussi :

	$ git stash branch testchanges
	Switched to a new branch "testchanges"
	# On branch testchanges
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#
	Dropped refs/stash@{0} (f0dfc4d5dc332d1cee34a634182e168c4efc3359)

C'est un bon raccourci pour récupérer du travail remisé facilement et de pouvoir travailler dessus dans une nouvelle branche.

## Réécrire l'historique ##

Bien souvent, lorsque vous travaillez avec Git, vous souhaitez modifier votre historique de consignation pour une raison quelconque.
Une des choses merveilleuses de Git est qu'il vous permet de prendre des décisions le plus tard possible.
Vous pouvez décider quels fichiers vont dans quel commit avant que vous ne consigniez la zone d'attente, vous pouvez décider que vous ne voulez pas encore montrer que vous travailler sur quelque chose avec les remises, et vous pouvez réécrire les commits afin déjà sauvegardé pour qu'ils ressemblent à quelque chose d'autre.
Cela peut signifier changer l'ordre des commits, modifier les messages ou modifier les fichiers appartenant au commit, rassembler ou séparer des commits, ou supprimer complètement des commits; tout ceci avant de les partager avec les autres.

Danc cette section, nous expliquerons comment accomplir ces tâches très utiles pour que vous pussiez faire ressembler votre historique de consignation de la manière que vous voulez avant de le partager avec autrui.

### Modifier la dernière consignation ###

Modifier votre dernière consignation est probablement la plus habituelle réécriture de l'historique que vous allez faire.
Vous voudrez souvent faire deux choses basiques à votre dernier commit : modifier le message de consignation, ou changer le contenu que vous avez enregistré en ajoutant, modifiant ou supprimant des fichiers.

Si vous voulez seulement modifier votre dernier message de consignation, c'est vraiment simple :

	$ git commit --amend

Cela vous ouvre votre éditeur de texte contenant votre dernier message, prêt à être modifié.
Lorsque vous sauvegardez et fermez l'éditeur, Git enregistre la nouvelle consignation contenant le message et en fait votre dernier commit.

Si vous avez vouler modifier le contenu de votre consignation, en ajoutant ou modifiant des fichiers, sûrement parce que vous avez oublié d'ajouter les fichiers nouvellement créés quand vous avez consigné la première fois, la procédure fonctionne grosso-modo de la même manière.
Vous mettez les modifications que vous voulez en attente en exécutant `git add` ou `git rm`, et le prochain `git commit --amend` prendra votre zone d'attente courante et en fera le contenu de votre nouvelle consignation.

Vous devez être prudent avec cette technique car votre modification modifie également le SHA-1 du commit.
Cela ressemble à un tout petit `rebase`.
Ne modifiez pas votre dernière consignation si vous l'avez déjà publié !

### Modifier plusieurs messages de consignation ###

Pour modifier une consignation qui est plus loin dans votre historique, vous devez utilisez des outils plus complexes.
Git ne contient pas d'outil de modification d'historique, mais vous pouvez utiliser l'outil `rebase` pour rebaser une suite de commits depuis la branche HEAD plutôt que de les déplacer vers une autre branche.
Avec l'outil rebase interactif, vous pouvez vous arrêter après chaque commit que vous voulez modifiez et changer le message, ajouter des fichiers ou quoique ce soit que vous voulez.
Vous pouvez exécuter rebase interactivement en ajoutant l'option `-i` à `git rebase`.
Vous devez indiquer jusqu'à quand remonter dans votre historique en donnant à la commande le commit sur lequel vous voulez vous rebaser.

Par exemple, si vous voulez modifier les 3 derniers messages de consignation, ou n'importe lequel des messages dans ce groupe, vous fournissez à `git rebase -i` le parent du dernier commit que vous voulez éditer, qui est `HEAD~2^` or `HEAD~3`.
Il peut être plus facile de ce souvenir de `~3`, car vous essayer de modifier les 3 derniers commits, mais gardez à l'esprit que vous désignez le 4e, le parent du dernier commit que vous voulez modifier :

	$ git rebase -i HEAD~3

Souvenez-vous également que ceci est une commande de rebasement, chaque commit include dans l'intervalle `HEAD~3..HEAD` sera réécrit, que vous changiez le message ou non.
N'incluez pas dans cette commande de commit que vous avez déjà poussé sur un serveur central.
Le faire entrainera la confusion chez les autres développeurs en leur fournissant une version altérée des mêmes modifications.

Exécuter cette commande vous donne la liste des consignations dans votre éditeur de texte, ce qui ressemble à :

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

	# Rebase 710f0f8..a5f4a0d onto 710f0f8
	#
	# Commands:
	#  p, pick = use commit
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	# However, if you remove everything, the rebase will be aborted.
	#

Il est important de signaler que les commits sont listés dans l'ordre opposé que vous voyez normalement en utilisant la commande `log`.
Si vous exécutez la commande `log`, vous verrez quelque chose de ce genre :

	$ git log --pretty=format:"%h %s" HEAD~3..HEAD
	a5f4a0d added cat-file
	310154e updated README formatting and added blame
	f7f3f6d changed my name a bit

Remarquez l'ordre inverse.
Le rebasage interactif va créer un script à exécuter.
Il commencera au commit que vous spécifiez sur la ligne de commande (`HEAD~3`) et refait les modifications introduites dans chacun des commits du début à la fin.
Il ordonne donc le plus vieux au début, plutôt que le plus récent, car c'est celui qu'il refera en premier.

Vous devez éditer le script afin qu'il s'arrête au commit que vous voulez modifier.
Pour cela, remplacer le mot "pick" par le mot "edit" pour chaque commit après lequel vous voulez que le script s'arrête.
Par exemple, pour modifier uniquement le message du troisième commit, vous modifiez le fichier pour ressembler à :

	edit f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

Au moment où vous sauvegardez et quittez l'éditeur, Git revient au dernier commit de cette liste et vous laisse sur une ligne de commande avec le message suivant :

	$ git rebase -i HEAD~3
	Stopped at 7482e0d... updated the gemspec to hopefully work better
	You can amend the commit now, with

	       git commit --amend

	Once you’re satisfied with your changes, run

	       git rebase --continue

Ces instructions vous disent exactement quoi faire.
Entrez :

	$ git commit --amend

Modifiez le message de commit et quittez l'éditeur.
Puis exécutez :

	$ git rebase --continue

Cette commande appliquera les deux autres commits automatiquement, c'est fait.
Si vous remplacez "pick" en "edit" sur plusieurs lignes, vous pouvez répéter ces étapes pour chaque commit que vous avez remplacé pour modification.
Chaque fois, Git s'arrêtera, vous laissant modifier le commit et continuera lorsque vous aurez fini.

### Réordonner les commits ###

Vous pouvez également utilisez les rebasages interactifs afin de réordonner ou supprimer entièrement des commits.
Si vous voulez supprimer le commit "added cat-file" et modifier l'ordre dans lequel les deux autres commits se trouvent dans l'historique, vous pouvez modifier le script de rebasage :

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

afin qu'il ressemble à ceci :

	pick 310154e updated README formatting and added blame
	pick f7f3f6d changed my name a bit

Lorsque vous sauvegardez et quittez l'éditeur, Git remet votre branche au niveau du parent de ces commits, applique `310154e` puis `f7f3f6d` et s'arrête.
Vous venez de modifier l'ordre de ces commits et de supprimer entièrement le commit "added cat-file".

### Rassembler des commits ###

Il est également possible de prendre une série de commits et de les rassembler en un seul avec l'outil de rebasage interactif.
Le script affiche des instructions utiles dans le message de rebasage :

	#
	# Commands:
	#  p, pick = use commit
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	# However, if you remove everything, the rebase will be aborted.
	#

Si, à la place de "pick" ou "edit", vous spécifiez "squash", Git applique cette modification et la modification juste précédente et fusionne les messages de consignation.
Donc, si vous voulez faire un seul commit de ces trois consignations, vous faites en sorte que le script ressemble à ceci :

	pick f7f3f6d changed my name a bit
	squash 310154e updated README formatting and added blame
	squash a5f4a0d added cat-file

Lorsque vous sauvegardez et quittez l'éditeur, Git applique ces trois modifications et vous remontre l'éditeur contenant maintenant la fusion des 3 messages de consignation :

	# This is a combination of 3 commits.
	# The first commit's message is:
	changed my name a bit

	# This is the 2nd commit message:

	updated README formatting and added blame

	# This is the 3rd commit message:

	added cat-file

Lorsque vous sauvegardez cela, vous obtenez un seul commit amenant les modifications des trois commits précédents.

### Diviser un commit ###

Pour diviser un commit, il doit être défait, puis partiellement mis en zone d'attente et consigner autant de fois que vous voulez pour en finir avec lui.
Par exemple, supposons que vous voulez diviser le commit du milieu dans l'exemple des trois commits précédents.
Plutôt que "updated README formatting and added blame", vous voulez le diviser en deux commits : "updated README formatting" pour le premier, et "added blame" pour le deuxième.
Vous pouvez le faire avec le script `rebase -i` en remplaçant l'instruction sur le commit que vous voulez divisez en "edit" :

	pick f7f3f6d changed my name a bit
	edit 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

Puis, lorsque le script vous laissera accès à la ligne de commande, vous annulerez (reset) ce commit, vous reprendrez les modifications que vous voulez pour créer plusieurs commits.
En reprenant l'exemple, lorsque vous sauvegardez et quittez l'éditeur, Git revient au parent de votre premier commit de votre liste, applique le premier commit (`f7f3f6d`), applique le deuxième (`310154e`), et vous laisse accès à la console.
Là, vous pouvez faire une réinitialisation mélangée (mixed reset) de ce commit avec `git reset HEAD^`, qui défait ce commit et laisse les fichiers modifiés non mis en attente.
Maintenant, vous pouvez mettre en attente et consigner les fichiers sur plusieurs consignations, et exécuter `git rebase --continue` quand vous avez fini :

	$ git reset HEAD^
	$ git add README
	$ git commit -m 'updated README formatting'
	$ git add lib/simplegit.rb
	$ git commit -m 'added blame'
	$ git rebase --continue

Git applique le dernier commit (`a5f4a0d`) de votre script, et votre historique ressemblera alors à :

	$ git log -4 --pretty=format:"%h %s"
	1c002dd added cat-file
	9b29157 added blame
	35cfb2b updated README formatting
	f3cc40e changed my name a bit

Une fois encore, ceci modifie les empreintes SHA de tous les commits dans votre liste, soyez donc sûr qu'aucun commit de cette liste ait été poussé dans un dépôt partagé.

### L'option nucléaire : filter-branch ###

Il existe une autre option de la réécriture d'historique que vous pouvez utiliser si vous avez besoin de réécrire un grand nombre de commits d'une manière scriptable; par exemple, modifier globalement votre adresse mail ou supprimer un fichier de tous les commits.
La commande est `filter-branch`, et elle peut réécrire des pans entiers de votre historique, vous ne devriez donc pas l'utiliser à moins que votre projet ne soit pas encore public ou que personne n'a encore travaillé sur les commits que vous allez réécrire.
Cependant, cela peut être très utile.
Vous allez maintenant apprendre quelques usages communs pour vous donner une idée de ses capacités.

#### Supprimer un fichier de chaque commit ####

Cela arrive asser fréquemment.
Quelqu'un a accidentellement commité un énorme fichier binaire avec une commande `git add .` irréfléchie, and vous voulez le supprimer partout.
Vous avez peut-être consigné un fichier contenant un mot de passe, et que vous voulez rendre votre projet open source.
`filter-branch` est l'outil que vous voulez probablement utiliser pour nettoyer votre historique entier.
Pour supprimer un fichier nommé "passwords.txt" de tout votre historique, vous pouvez utiliser l'option `--tree-filter` de `filter-branch` :

	$ git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
	Rewrite 6b9b3cf04e7c5686a9cb838c3f36a8cb6a0fc2bd (21/21)
	Ref 'refs/heads/master' was rewritten

L'option `--tree-filter` exécute la commande spécifiée pour chaque commit et les reconsigne ensuite
Dans le cas présent, vous supprimez le fichier nommé "passwords.txt" de chaque contenu, qu'il existait ou non.
Si vous voulez supprimez tous les fichiers temporaires des éditeurs consignés accidentellement, vous pouvez exécuter une commande telle que `git filter-branch --tree-filter 'rm -f *~' HEAD`.

Vous pourrez alors regarder Git réécrire l'arbre des commits et reconsigner à chaque fois, pour finir en modifiant la référence de la branche.
C'est généralement une bonne idée de le faire dans un branche de test puis de faire une forte réinitialisation (hard-reset) de votre branche `master` si le résultat vous convient.
Pour exécuter `filter-branch` sur toutes vos branches, vous pouvez ajouter `--all` à la commande.

#### Faire d'un sous-répertoire la nouvelle racine ####

Supposons que vous avez importer votre projet depuis un autre système de gestion de configuration et que vous avez des sous-répertoires qui n'ont aucun sens (trunk, tags, etc).
Si vous voulez faire en sorte que le sous-répertoire `trunk` soit la nouvelle racine de votre projet pour tous les commits, `filter-branch` peut aussi vous aider à le faire :

	$ git filter-branch --subdirectory-filter trunk HEAD
	Rewrite 856f0bf61e41a27326cdae8f09fe708d679f596f (12/12)
	Ref 'refs/heads/master' was rewritten

Maintenant votre nouvelle racine est remplacé par le contenu du répertoire `trunk`.
De plus, Git supprimera automatiquement les commits qui n'affectent pas ce sous-répertoire.

#### Modifier globalement l'adresse mail ####

Un autre cas habituel est que vous oubliez d'exécuter `git config` pour configurer votre nom et votre adresse mail avant de commencer à travailler, ou vous voulez peut-être rendre un projet du boulot open source et donc changer votre adresse professionnelle pour celle personnelle.
Dans tous les cas, vous pouvez modifier l'adresse mail dans plusieurs commits avec un script `filter-branch`
Vous devez faire attention de ne changer que votre adresse mail, utilisez donc `--commit-filter` :

	$ git filter-branch --commit-filter '
	        if [ "$GIT_AUTHOR_EMAIL" = "schacon@localhost" ];
	        then
	                GIT_AUTHOR_NAME="Scott Chacon";
	                GIT_AUTHOR_EMAIL="schacon@example.com";
	                git commit-tree "$@";
	        else
	                git commit-tree "$@";
	        fi' HEAD

Cela passe sur chaque commit et le réécrit pour avoir votre nouvelle adresse.
Mais puisque les commits contiennent l'empreinte SHA-1 de leur parent, cette commande modifie tous les commits dans votre historique, pas seulement ceux correspondant à votre adresse mail.

## Deboguer avec Git ##

Git fournit aussi quelques outils pour vous aider à déboguer votre projet.
Puisque Git est conçu pour fonctionner avec pratiquement tout type de projet, ces outils sont plutôt génériques, mais ils peuvent souvent vous aider à traquer un bogue ou au moins cerner où cela tourne mal.

### Fichier annoté ###

Si vous traquez un bogue dans votre code et que vous voulez savoir quand il est apparu et pourquoi, annoter les fichiers est souvent le meilleur moyen.
Cela vous montre le dernier commit qui a modifié chaque ligne de votre fichier.
Donc, si vous voyez une méthode dans votre code qui est boguée, vous pouvez annoter le fichier avec `git blame` pour voir quand chaque ligne de la méthode a été modifiée pour la dernière fois et par qui.
Cet exemple utilise l'option `-L` pour limiter la sortie des lignes 12 à 22 :

	$ git blame -L 12,22 simplegit.rb 
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 12)  def show(tree = 'master')
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 13)   command("git show #{tree}")
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 14)  end
	^4832fe2 (Scott Chacon  2008-03-15 10:31:28 -0700 15)
	9f6560e4 (Scott Chacon  2008-03-17 21:52:20 -0700 16)  def log(tree = 'master')
	79eaf55d (Scott Chacon  2008-04-06 10:15:08 -0700 17)   command("git log #{tree}")
	9f6560e4 (Scott Chacon  2008-03-17 21:52:20 -0700 18)  end
	9f6560e4 (Scott Chacon  2008-03-17 21:52:20 -0700 19) 
	42cf2861 (Magnus Chacon 2008-04-13 10:45:01 -0700 20)  def blame(path)
	42cf2861 (Magnus Chacon 2008-04-13 10:45:01 -0700 21)   command("git blame #{path}")
	42cf2861 (Magnus Chacon 2008-04-13 10:45:01 -0700 22)  end

Remarquez que le premier champ est le SHA-1 partiel du dernier commit a avoir modifié la ligne.
Les deux champs suivants sont des valeurs extraites du commit : l'auteur et la date du commit, vous pouvez donc facilement voir qui a modifié la ligne et quand.
Ensuite arrive le numéro de ligne et son contenu.
Remarquez également les lignes dont le commit est `^4832fe2`, elles désignent les lignes qui étaient dans la version du fichier lors du premier commit de ce fichier.
Ce commit contient le premier ajout de ce fichier, et ces lignes n'ont pas été modifiées depuis.
Tout ça est un peu confus, parce que vous connaissez maintenant au moins trois façons différentes que Git interprète `^` pour modifier l'empreinte SHA, mais au moins, vous savez ce qu'il signifie ici.

Une autre chose sympa sur Git, c'est qu'il ne suit pas explicitement les renommages de fichier.
Il enregistre les contenus puis essaye de deviner ce qui a été renommé implicitement, après coup.
Ce qui nous permet d'utiliser cette fonctionnalité intéressante pour suivre toute sorte de mouvement de code.
Si vous passez `-C` à `git blame`, Git analyse le fichier que vous voulez annoter et essaye de devenir d'où les bouts de code proviennent par copie ou déplacement.
Récemment, j'ai remanié un fichier nommé `GITServerHandler.m` en le divisant en plusieurs fichiers, dont le fichier `GITPackUpload.m`.
En annotant `GITPackUpload.m` avec l'option `-C`, je peux voir quelles sections de code en est originaire :

	$ git blame -C -L 141,153 GITPackUpload.m 
	f344f58d GITServerHandler.m (Scott 2009-01-04 141) 
	f344f58d GITServerHandler.m (Scott 2009-01-04 142) - (void) gatherObjectShasFromC
	f344f58d GITServerHandler.m (Scott 2009-01-04 143) {
	70befddd GITServerHandler.m (Scott 2009-03-22 144)         //NSLog(@"GATHER COMMI
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 145)
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 146)         NSString *parentSha;
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 147)         GITCommit *commit = [g
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 148)
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 149)         //NSLog(@"GATHER COMMI
	ad11ac80 GITPackUpload.m    (Scott 2009-03-24 150)
	56ef2caf GITServerHandler.m (Scott 2009-01-05 151)         if(commit) {
	56ef2caf GITServerHandler.m (Scott 2009-01-05 152)                 [refDict setOb
	56ef2caf GITServerHandler.m (Scott 2009-01-05 153)

C'est vraiment utile, non ?
Normalement, vous obtenez comme commit original, celui dont votre code a été copié, puisque ce fut la première fois que vous avez touché à ces lignes dans ce fichier.
Git vous montre le commit d'origine, celui où vous avez écrit ces lignes, même si c'était dans un autre fichier.

### La recherche dichotomique ###

Annoter un fichier peut aider si vous savez déjà où le problème se situe.
Si vous ne savez pas ce qui a cassé le code, il peut y avoir des douzaines, voire des centaines de commits depuis le dernier état où votre code fonctionnait, et vous aimeriez certainement exécuter `git bisect` pour l'aide qu'il procure.
La commande `bisect` effectue une recherche par dichotomie dans votre historique pour vous aider à identifier aussi vite que possible quel commit a vu le bogue naitre.

Disons que vous venez juste de pousser une version finale de votre code en production, vous récupérez un rapport de bogue à propos de quelque chose qui n'arrivait pas dans votre environnement de développement, et vous n'arrivez pas à trouver pourquoi votre code le fait.
Vous retournez sur votre code, et il apparait que vous pouvez reproduire le bogue, mais vous ne savez pas ce qui se passe mal.
Vous pouvez faire une recherche par dichotomie pour trouver ce qui ne va pas.
D'abord, exécutez `git bisect start` pour démarrer la procédure, puis utilisez la commande `git bisect bad` pour dire que le commit courant est bogué.
Ensuite, dites à `bisect` quand le code fonctionnait, en utilisant `git bisect good [bonne_version]` :

	$ git bisect start
	$ git bisect bad
	$ git bisect good v1.0
	Bisecting: 6 revisions left to test after this
	[ecb6e1bc347ccecc5f9350d878ce677feb13d3b2] error handling on repo

Git trouve qu'il y a environ 12 commits entre celui que vous avez marqué comme le dernier bon connu (v1.0) et la version courante qui n'est pas bonne, et il a récupéré le commit au milieu à votre place.
À ce moment, vous pouvez dérouler vos tests pour voir si le bogue existait dans ce commit.
Si c'est le cas, il a été introduit quelque part avant ce commit médian, sinon, il l'a été évidemment introduit après.
Il apparait que le bogue ne se reproduit pas ici, vous le dites à Git en tapant `git bisect good` et continuez votre périple :

	$ git bisect good
	Bisecting: 3 revisions left to test after this
	[b047b02ea83310a70fd603dc8cd7a6cd13d15c04] secure this thing

Vous êtes maintenant sur un autre commit, à mi-chemin entre celui que vous venez de tester et votre commit bogué.
Vous exécutez une nouvelle fois votre test et trouvez que ce commit est bogué, vous le dites à Git avec `git bisect bad` :

	$ git bisect bad
	Bisecting: 1 revisions left to test after this
	[f71ce38690acf49c1f3c9bea38e09d82a5ce6014] drop exceptions table

Ce commit-ci est bon, et Git a maintenant toutes les informations dont il a besoin pour déterminer où le bogue a été créé.
Il vous affiche le SHA-1 du premier commit bogué, quelques informations du commit et quels fichiers ont été modifiés dans celui-ci, vous pouvez donc trouver ce qui s'est passé pour créer ce bogue :

	$ git bisect good
	b047b02ea83310a70fd603dc8cd7a6cd13d15c04 is first bad commit
	commit b047b02ea83310a70fd603dc8cd7a6cd13d15c04
	Author: PJ Hyett <pjhyett@example.com>
	Date:   Tue Jan 27 14:48:32 2009 -0800

	    secure this thing

	:040000 040000 40ee3e7821b895e52c1695092db9bdc4c61d1730
	f24d3c6ebcfc639b1a3814550e62d60b8e68a8e4 M  config

Lorsque vous avez fini, vous devez exécuter `git bisect reset` pour réinitialiser votre HEAD où vous étiez avant de commencer, ou vous travaillerez dans un répertoire de travail non clairement défini :

	$ git bisect reset

C'est un outil puissant qui vous aidera à vérifier des centaines de commits en quelques minutes.
En réalité, si vous avez un script qui sort avec une valeur 0 s'il est bon et autre chose sinon, vous pouvez même automatiser `git bisect`.
Premièrement vous lui spécifiez l'intervalle en lui fournissant les bon et mauvais commits connus.
Vous pouvez faire cela en une ligne en les entrant à la suite de la commande `bisect start`, le mauvais commit d'abord :

	$ git bisect start HEAD v1.0
	$ git bisect run test-error.sh

Cela exécute automatiquement `test-error.sh` sur chaque commit jusqu'à ce que Git trouve le premier commit bogué.
Vous pouvez également exécuter des commandes comme `make` ou `make tests` ou quoique ce soit qui exécute des tests automatisés à votre place.

## Submodules ##

It often happens that while working on one project, you need to use another project from within it.
Perhaps it’s a library that a third party developed or that you’re developing separately and using in multiple parent projects.
A common issue arises in these scenarios: you want to be able to treat the two projects as separate yet still be able to use one from within the other.

Here’s an example.
Suppose you’re developing a web site and creating Atom feeds.
Instead of writing your own Atom-generating code, you decide to use a library.
You’re likely to have to either include this code from a shared library like a CPAN install or Ruby gem, or copy the source code into your own project tree.
The issue with including the library is that it’s difficult to customize the library in any way and often more difficult to deploy it, because you need to make sure every client has that library available.
The issue with vendoring the code into your own project is that any custom changes you make are difficult to merge when upstream changes become available.

Git addresses this issue using submodules.
Submodules allow you to keep a Git repository as a subdirectory of another Git repository.
This lets you clone another repository into your project and keep your commits separate.

### Starting with Submodules ###

Suppose you want to add the Rack library (a Ruby web server gateway interface) to your project, possibly maintain your own changes to it, but continue to merge in upstream changes.
The first thing you should do is clone the external repository into your subdirectory.
You add external projects as submodules with the `git submodule add` command:

	$ git submodule add git://github.com/chneukirchen/rack.git rack
	Initialized empty Git repository in /opt/subtest/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 422 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.

Now you have the Rack project under a subdirectory named `rack` within your project.
You can go into that subdirectory, make changes, add your own writable remote repository to push your changes into, fetch and merge from the original repository, and more.
If you run `git status` right after you add the submodule, you see two things:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      new file:   .gitmodules
	#      new file:   rack
	#

First you notice the `.gitmodules` file.
This is a configuration file that stores the mapping between the project’s URL and the local subdirectory you’ve pulled it into:

	$ cat .gitmodules 
	[submodule "rack"]
	      path = rack
	      url = git://github.com/chneukirchen/rack.git

If you have multiple submodules, you’ll have multiple entries in this file.
It’s important to note that this file is version-controlled with your other files, like your `.gitignore` file.
It’s pushed and pulled with the rest of your project.
This is how other people who clone this project know where to get the submodule projects from.

The other listing in the `git status` output is the rack entry.
If you run `git diff` on that, you see something interesting:

	$ git diff --cached rack
	diff --git a/rack b/rack
	new file mode 160000
	index 0000000..08d709f
	--- /dev/null
	+++ b/rack
	@@ -0,0 +1 @@
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

Although `rack` is a subdirectory in your working directory, Git sees it as a submodule and doesn’t track its contents when you’re not in that directory.
Instead, Git records it as a particular commit from that repository.
When you make changes and commit in that subdirectory, the superproject notices that the HEAD there has changed and records the exact commit you’re currently working off of; that way, when others clone this project, they can re-create the environment exactly.

This is an important point with submodules: you record them as the exact commit they’re at.
You can’t record a submodule at `master` or some other symbolic reference.

When you commit, you see something like this:

	$ git commit -m 'first commit with submodule rack'
	[master 0550271] first commit with submodule rack
	 2 files changed, 4 insertions(+), 0 deletions(-)
	 create mode 100644 .gitmodules
	 create mode 160000 rack

Notice the 160000 mode for the rack entry.
That is a special mode in Git that basically means you’re recording a commit as a directory entry rather than a subdirectory or a file.

You can treat the `rack` directory as a separate project and then update your superproject from time to time with a pointer to the latest commit in that subproject.
All the Git commands work independently in the two directories:

	$ git log -1
	commit 0550271328a0038865aad6331e620cd7238601bb
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Apr 9 09:03:56 2009 -0700

	    first commit with submodule rack
	$ cd rack/
	$ git log -1
	commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433
	Author: Christian Neukirchen <chneukirchen@gmail.com>
	Date:   Wed Mar 25 14:49:04 2009 +0100

	    Document version change

### Cloning a Project with Submodules ###

Here you’ll clone a project with a submodule in it.
When you receive such a project, you get the directories that contain submodules, but none of the files yet:

	$ git clone git://github.com/schacon/myproject.git
	Initialized empty Git repository in /opt/myproject/.git/
	remote: Counting objects: 6, done.
	remote: Compressing objects: 100% (4/4), done.
	remote: Total 6 (delta 0), reused 0 (delta 0)
	Receiving objects: 100% (6/6), done.
	$ cd myproject
	$ ls -l
	total 8
	-rw-r--r--  1 schacon  admin   3 Apr  9 09:11 README
	drwxr-xr-x  2 schacon  admin  68 Apr  9 09:11 rack
	$ ls rack/
	$

The `rack` directory is there, but empty.
You must run two commands: `git submodule init` to initialize your local configuration file, and `git submodule update` to fetch all the data from that project and check out the appropriate commit listed in your superproject:

	$ git submodule init
	Submodule 'rack' (git://github.com/chneukirchen/rack.git) registered for path 'rack'
	$ git submodule update
	Initialized empty Git repository in /opt/myproject/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 173 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.
	Submodule path 'rack': checked out '08d709f78b8c5b0fbeb7821e37fa53e69afcf433'

Now your `rack` subdirectory is at the exact state it was in when you committed earlier.
If another developer makes changes to the rack code and commits, and you pull that reference down and merge it in, you get something a bit odd:

	$ git merge origin/master
	Updating 0550271..85a3eee
	Fast forward
	 rack |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)
	[master*]$ git status
	# On branch master
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#      modified:   rack
	#

You merged in what is basically a change to the pointer for your submodule; but it doesn’t update the code in the submodule directory, so it looks like you have a dirty state in your working directory:

	$ git diff
	diff --git a/rack b/rack
	index 6c5e70b..08d709f 160000
	--- a/rack
	+++ b/rack
	@@ -1 +1 @@
	-Subproject commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

This is the case because the pointer you have for the submodule isn’t what is actually in the submodule directory.
To fix this, you must run `git submodule update` again:

	$ git submodule update
	remote: Counting objects: 5, done.
	remote: Compressing objects: 100% (3/3), done.
	remote: Total 3 (delta 1), reused 2 (delta 0)
	Unpacking objects: 100% (3/3), done.
	From git@github.com:schacon/rack
	   08d709f..6c5e70b  master     -> origin/master
	Submodule path 'rack': checked out '6c5e70b984a60b3cecd395edd5b48a7575bf58e0'

You have to do this every time you pull down a submodule change in the main project.
It’s strange, but it works.

One common problem happens when a developer makes a change locally in a submodule but doesn’t push it to a public server.
Then, they commit a pointer to that non-public state and push up the superproject.
When other developers try to run `git submodule update`, the submodule system can’t find the commit that is referenced, because it exists only on the first developer’s system.
If that happens, you see an error like this:

	$ git submodule update
	fatal: reference isn’t a tree: 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Unable to checkout '6c5e70b984a60b3cecd395edd5ba7575bf58e0' in submodule path 'rack'

You have to see who last changed the submodule:

	$ git log -1 rack
	commit 85a3eee996800fcfa91e2119372dd4172bf76678
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Apr 9 09:19:14 2009 -0700

	    added a submodule reference I will never make public. hahahahaha!

Then, you e-mail that guy and yell at him.

### Superprojects ###

Sometimes, developers want to get a combination of a large project’s subdirectories, depending on what team they’re on.
This is common if you’re coming from CVS or Subversion, where you’ve defined a module or collection of subdirectories, and you want to keep this type of workflow.

A good way to do this in Git is to make each of the subfolders a separate Git repository and then create superproject Git repositories that contain multiple submodules.
A benefit of this approach is that you can more specifically define the relationships between the projects with tags and branches in the superprojects.

### Issues with Submodules ###

Using submodules isn’t without hiccups, however.
First, you must be relatively careful when working in the submodule directory.
When you run `git submodule update`, it checks out the specific version of the project, but not within a branch.
This is called having a detached head — it means the HEAD file points directly to a commit, not to a symbolic reference.
The issue is that you generally don’t want to work in a detached head environment, because it’s easy to lose changes.
If you do an initial `submodule update`, commit in that submodule directory without creating a branch to work in, and then run `git submodule update` again from the superproject without committing in the meantime, Git will overwrite your changes without telling you.
 Technically you won’t lose the work, but you won’t have a branch pointing to it, so it will be somewhat difficult to retrieive.

To avoid this issue, create a branch when you work in a submodule directory with `git checkout -b work` or something equivalent.
When you do the submodule update a second time, it will still revert your work, but at least you have a pointer to get back to.

Switching branches with submodules in them can also be tricky.
If you create a new branch, add a submodule there, and then switch back to a branch without that submodule, you still have the submodule directory as an untracked directory:

	$ git checkout -b rack
	Switched to a new branch "rack"
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/myproj/rack/.git/
	...
	Receiving objects: 100% (3184/3184), 677.42 KiB | 34 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.
	$ git commit -am 'added rack submodule'
	[rack cc49a69] added rack submodule
	 2 files changed, 4 insertions(+), 0 deletions(-)
	 create mode 100644 .gitmodules
	 create mode 160000 rack
	$ git checkout master
	Switched to branch "master"
	$ git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#      rack/

You have to either move it out of the way or remove it, in which case you have to clone it again when you switch back—and you may lose local changes or branches that you didn’t push up.

The last main caveat that many people run into involves switching from subdirectories to submodules.
If you’ve been tracking files in your project and you want to move them out into a submodule, you must be careful or Git will get angry at you.
Assume that you have the rack files in a subdirectory of your project, and you want to switch it to a submodule.
If you delete the subdirectory and then run `submodule add`, Git yells at you:

	$ rm -Rf rack/
	$ git submodule add git@github.com:schacon/rack.git rack
	'rack' already exists in the index

You have to unstage the `rack` directory first.
Then you can add the submodule:

	$ git rm -r rack
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/testsub/rack/.git/
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 88 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.

Now suppose you did that in a branch.
If you try to switch back to a branch where those files are still in the actual tree rather than a submodule — you get this error:

	$ git checkout master
	error: Untracked working tree file 'rack/AUTHORS' would be overwritten by merge.

You have to move the `rack` submodule directory out of the way before you can switch to a branch that doesn’t have it:

	$ mv rack /tmp/
	$ git checkout master
	Switched to branch "master"
	$ ls
	README	rack

Then, when you switch back, you get an empty `rack` directory.
You can either run `git submodule update` to reclone, or you can move your `/tmp/rack` directory back into the empty directory.

## Subtree Merging ##

Now that you’ve seen the difficulties of the submodule system, let’s look at an alternate way to solve the same problem.
When Git merges, it looks at what it has to merge together and then chooses an appropriate merging strategy to use.
If you’re merging two branches, Git uses a _recursive_ strategy.
If you’re merging more than two branches, Git picks the _octopus_ strategy.
These strategies are automatically chosen for you because the recursive strategy can handle complex three-way merge situations — for example, more than one common ancestor — but it can only handle merging two branches.
The octopus merge can handle multiple branches but is more cautious to avoid difficult conflicts, so it’s chosen as the default strategy if you’re trying to merge more than two branches.

However, there are other strategies you can choose as well.
One of them is the _subtree_ merge, and you can use it to deal with the subproject issue.
Here you’ll see how to do the same rack embedding as in the last section, but using subtree merges instead.

The idea of the subtree merge is that you have two projects, and one of the projects maps to a subdirectory of the other one and vice versa.
When you specify a subtree merge, Git is smart enough to figure out that one is a subtree of the other and merge appropriately — it’s pretty amazing.

You first add the Rack application to your project.
You add the Rack project as a remote reference in your own project and then check it out into its own branch:

	$ git remote add rack_remote git@github.com:schacon/rack.git
	$ git fetch rack_remote
	warning: no common commits
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 4 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.
	From git@github.com:schacon/rack
	 * [new branch]      build      -> rack_remote/build
	 * [new branch]      master     -> rack_remote/master
	 * [new branch]      rack-0.4   -> rack_remote/rack-0.4
	 * [new branch]      rack-0.9   -> rack_remote/rack-0.9
	$ git checkout -b rack_branch rack_remote/master
	Branch rack_branch set up to track remote branch refs/remotes/rack_remote/master.
	Switched to a new branch "rack_branch"

Now you have the root of the Rack project in your `rack_branch` branch and your own project in the `master` branch.
If you check out one and then the other, you can see that they have different project roots:

	$ ls
	AUTHORS	       KNOWN-ISSUES   Rakefile      contrib	       lib
	COPYING	       README         bin           example	       test
	$ git checkout master
	Switched to branch "master"
	$ ls
	README

You want to pull the Rack project into your `master` project as a subdirectory.
You can do that in Git with `git read-tree`.
You’ll learn more about `read-tree` and its friends in Chapter 9, but for now know that it reads the root tree of one branch into your current staging area and working directory.
You just switched back to your `master` branch, and you pull the `rack` branch into the `rack` subdirectory of your `master` branch of your main project:

	$ git read-tree --prefix=rack/ -u rack_branch

When you commit, it looks like you have all the Rack files under that subdirectory — as though you copied them in from a tarball.
What gets interesting is that you can fairly easily merge changes from one of the branches to the other.
So, if the Rack project updates, you can pull in upstream changes by switching to that branch and pulling:

	$ git checkout rack_branch
	$ git pull

Then, you can merge those changes back into your master branch.
You can use `git merge -s subtree` and it will work fine; but Git will also merge the histories together, which you probably don’t want.
To pull in the changes and prepopulate the commit message, use the `--squash` and `--no-commit` options as well as the `-s subtree` strategy option:

	$ git checkout master
	$ git merge --squash -s subtree --no-commit rack_branch
	Squash commit -- not updating HEAD
	Automatic merge went well; stopped before committing as requested

All the changes from your Rack project are merged in and ready to be committed locally.
You can also do the opposite — make changes in the `rack` subdirectory of your master branch and then merge them into your `rack_branch` branch later to submit them to the maintainers or push them upstream.

To get a diff between what you have in your `rack` subdirectory and the code in your `rack_branch` branch — to see if you need to merge them — you can’t use the normal `diff` command.
Instead, you must run `git diff-tree` with the branch you want to compare to:

	$ git diff-tree -p rack_branch

Or, to compare what is in your `rack` subdirectory with what the `master` branch on the server was the last time you fetched, you can run

	$ git diff-tree -p rack_remote/master

## Summary ##

You’ve seen a number of advanced tools that allow you to manipulate your commits and staging area more precisely.
When you notice issues, you should be able to easily figure out what commit introduced them, when, and by whom.
If you want to use subprojects in your project, you’ve learned a few ways to accommodate those needs.
At this point, you should be able to do most of the things in Git that you’ll need on the command line day to day and feel comfortable doing so.
