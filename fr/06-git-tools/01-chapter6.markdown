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

#### Plusieurs points ####

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

### Creating a Branch from a Stash ###

If you stash some work, leave it there for a while, and continue on the branch from which you stashed the work, you may have a problem reapplying the work.
If the apply tries to modify a file that you’ve since modified, you’ll get a merge conflict and will have to try to resolve it.
If you want an easier way to test the stashed changes again, you can run `git stash branch`, which creates a new branch for you, checks out the commit you were on when you stashed your work, reapplies your work there, and then drops the stash if it applies successfully:

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

This is a nice shortcut to recover stashed work easily and work on it in a new branch.

## Rewriting History ##

Many times, when working with Git, you may want to revise your commit history for some reason.
One of the great things about Git is that it allows you to make decisions at the last possible moment.
You can decide what files go into which commits right before you commit with the staging area, you can decide that you didn’t mean to be working on something yet with the stash command, and you can rewrite commits that already happened so they look like they happened in a different way.
This can involve changing the order of the commits, changing messages or modifying files in a commit, squashing together or splitting apart commits, or removing commits entirely — all before you share your work with others.

In this section, you’ll cover how to accomplish these very useful tasks so that you can make your commit history look the way you want before you share it with others.

### Changing the Last Commit ###

Changing your last commit is probably the most common rewriting of history that you’ll do.
You’ll often want to do two basic things to your last commit: change the commit message, or change the snapshot you just recorded by adding, changing and removing files.

If you only want to modify your last commit message, it’s very simple:

	$ git commit --amend

That drops you into your text editor, which has your last commit message in it, ready for you to modify the message.
When you save and close the editor, the editor writes a new commit containing that message and makes it your new last commit.

If you’ve committed and then you want to change the snapshot you committed by adding or changing files, possibly because you forgot to add a newly created file when you originally committed, the process works basically the same way.
You stage the changes you want by editing a file and running `git add` on it or `git rm` to a tracked file, and the subsequent `git commit --amend` takes your current staging area and makes it the snapshot for the new commit.

You need to be careful with this technique because amending changes the SHA-1 of the commit.
It’s like a very small rebase — don’t amend your last commit if you’ve already pushed it.

### Changing Multiple Commit Messages ###

To modify a commit that is farther back in your history, you must move to more complex tools.
Git doesn’t have a modify-history tool, but you can use the rebase tool to rebase a series of commits onto the HEAD they were originally based on instead of moving them to another one.
With the interactive rebase tool, you can then stop after each commit you want to modify and change the message, add files, or do whatever you wish.
You can run rebase interactively by adding the `-i` option to `git rebase`.
You must indicate how far back you want to rewrite commits by telling the command which commit to rebase onto.

For example, if you want to change the last three commit messages, or any of the commit messages in that group, you supply as an argument to `git rebase -i` the parent of the last commit you want to edit, which is `HEAD~2^` or `HEAD~3`.
It may be easier to remember the `~3` because you’re trying to edit the last three commits; but keep in mind that you’re actually designating four commits ago, the parent of the last commit you want to edit:

	$ git rebase -i HEAD~3

Remember again that this is a rebasing command — every commit included in the range `HEAD~3..HEAD` will be rewritten, whether you change the message or not.
Don’t include any commit you’ve already pushed to a central server — doing so will confuse other developers by providing an alternate version of the same change.

Running this command gives you a list of commits in your text editor that looks something like this:

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

It’s important to note that these commits are listed in the opposite order than you normally see them using the `log` command.
If you run a `log`, you see something like this:

	$ git log --pretty=format:"%h %s" HEAD~3..HEAD
	a5f4a0d added cat-file
	310154e updated README formatting and added blame
	f7f3f6d changed my name a bit

Notice the reverse order.
The interactive rebase gives you a script that it’s going to run.
It will start at the commit you specify on the command line (`HEAD~3`) and replay the changes introduced in each of these commits from top to bottom.
It lists the oldest at the top, rather than the newest, because that’s the first one it will replay.

You need to edit the script so that it stops at the commit you want to edit.
To do so, change the word pick to the word edit for each of the commits you want the script to stop after.
For example, to modify only the third commit message, you change the file to look like this:

	edit f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

When you save and exit the editor, Git rewinds you back to the last commit in that list and drops you on the command line with the following message:

	$ git rebase -i HEAD~3
	Stopped at 7482e0d... updated the gemspec to hopefully work better
	You can amend the commit now, with

	       git commit --amend

	Once you’re satisfied with your changes, run

	       git rebase --continue

These instructions tell you exactly what to do.
Type

	$ git commit --amend

Change the commit message, and exit the editor.
Then, run

	$ git rebase --continue

This command will apply the other two commits automatically, and then you’re done.
If you change pick to edit on more lines, you can repeat these steps for each commit you change to edit.
Each time, Git will stop, let you amend the commit, and continue when you’re finished.

### Reordering Commits ###

You can also use interactive rebases to reorder or remove commits entirely.
If you want to remove the "added cat-file" commit and change the order in which the other two commits are introduced, you can change the rebase script from this

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

to this:

	pick 310154e updated README formatting and added blame
	pick f7f3f6d changed my name a bit

When you save and exit the editor, Git rewinds your branch to the parent of these commits, applies `310154e` and then `f7f3f6d`, and then stops.
You effectively change the order of those commits and remove the "added cat-file" commit completely.

### Squashing a Commit ###

It’s also possible to take a series of commits and squash them down into a single commit with the interactive rebasing tool.
The script puts helpful instructions in the rebase message:

	#
	# Commands:
	#  p, pick = use commit
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	# However, if you remove everything, the rebase will be aborted.
	#

If, instead of "pick" or "edit", you specify "squash", Git applies both that change and the change directly before it and makes you merge the commit messages together.
So, if you want to make a single commit from these three commits, you make the script look like this:

	pick f7f3f6d changed my name a bit
	squash 310154e updated README formatting and added blame
	squash a5f4a0d added cat-file

When you save and exit the editor, Git applies all three changes and then puts you back into the editor to merge the three commit messages:

	# This is a combination of 3 commits.
	# The first commit's message is:
	changed my name a bit

	# This is the 2nd commit message:

	updated README formatting and added blame

	# This is the 3rd commit message:

	added cat-file

When you save that, you have a single commit that introduces the changes of all three previous commits.

### Splitting a Commit ###

Splitting a commit undoes a commit and then partially stages and commits as many times as commits you want to end up with.
For example, suppose you want to split the middle commit of your three commits.
Instead of "updated README formatting and added blame", you want to split it into two commits: "updated README formatting" for the first, and "added blame" for the second.
You can do that in the `rebase -i` script by changing the instruction on the commit you want to split to "edit":

	pick f7f3f6d changed my name a bit
	edit 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

Then, when the script drops you to the command line, you reset that commit, take the changes that have been reset, and create multiple commits out of them.
When you save and exit the editor, Git rewinds to the parent of the first commit in your list, applies the first commit (`f7f3f6d`), applies the second (`310154e`), and drops you to the console.
There, you can do a mixed reset of that commit with `git reset HEAD^`, which effectively undoes that commit and leaves the modified files unstaged.
Now you can stage and commit files until you have several commits, and run `git rebase --continue` when you’re done:

	$ git reset HEAD^
	$ git add README
	$ git commit -m 'updated README formatting'
	$ git add lib/simplegit.rb
	$ git commit -m 'added blame'
	$ git rebase --continue

Git applies the last commit (`a5f4a0d`) in the script, and your history looks like this:

	$ git log -4 --pretty=format:"%h %s"
	1c002dd added cat-file
	9b29157 added blame
	35cfb2b updated README formatting
	f3cc40e changed my name a bit

Once again, this changes the SHAs of all the commits in your list, so make sure no commit shows up in that list that you’ve already pushed to a shared repository.

### The Nuclear Option: filter-branch ###

There is another history-rewriting option that you can use if you need to rewrite a larger number of commits in some scriptable way — for instance, changing your e-mail address globally or removing a file from every commit.
The command is `filter-branch`, and it can rewrite huge swaths of your history, so you probably shouldn’t use it unless your project isn’t yet public and other people haven’t based work off the commits you’re about to rewrite.
However, it can be very useful.
You’ll learn a few of the common uses so you can get an idea of some of the things it’s capable of.

#### Removing a File from Every Commit ####

This occurs fairly commonly.
Someone accidentally commits a huge binary file with a thoughtless `git add .`, and you want to remove it everywhere.
Perhaps you accidentally committed a file that contained a password, and you want to make your project open source.
`filter-branch` is the tool you probably want to use to scrub your entire history.
To remove a file named passwords.txt from your entire history, you can use the `--tree-filter` option to `filter-branch`:

	$ git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
	Rewrite 6b9b3cf04e7c5686a9cb838c3f36a8cb6a0fc2bd (21/21)
	Ref 'refs/heads/master' was rewritten

The `--tree-filter` option runs the specified command after each checkout of the project and then recommits the results.
In this case, you remove a file called passwords.txt from every snapshot, whether it exists or not.
If you want to remove all accidentally committed editor backup files, you can run something like `git filter-branch --tree-filter 'rm -f *~' HEAD`.

You’ll be able to watch Git rewriting trees and commits and then move the branch pointer at the end.
It’s generally a good idea to do this in a testing branch and then hard-reset your master branch after you’ve determined the outcome is what you really want.
To run `filter-branch` on all your branches, you can pass `--all` to the command.

#### Making a Subdirectory the New Root ####

Suppose you’ve done an import from another source control system and have subdirectories that make no sense (trunk, tags, and so on).
If you want to make the `trunk` subdirectory be the new project root for every commit, `filter-branch` can help you do that, too:

	$ git filter-branch --subdirectory-filter trunk HEAD
	Rewrite 856f0bf61e41a27326cdae8f09fe708d679f596f (12/12)
	Ref 'refs/heads/master' was rewritten

Now your new project root is what was in the `trunk` subdirectory each time.
Git will also automatically remove commits that did not affect the subdirectory.

#### Changing E-Mail Addresses Globally ####

Another common case is that you forgot to run `git config` to set your name and e-mail address before you started working, or perhaps you want to open-source a project at work and change all your work e-mail addresses to your personal address.
In any case, you can change e-mail addresses in multiple commits in a batch with `filter-branch` as well.
You need to be careful to change only the e-mail addresses that are yours, so you use `--commit-filter`:

	$ git filter-branch --commit-filter '
	        if [ "$GIT_AUTHOR_EMAIL" = "schacon@localhost" ];
	        then
	                GIT_AUTHOR_NAME="Scott Chacon";
	                GIT_AUTHOR_EMAIL="schacon@example.com";
	                git commit-tree "$@";
	        else
	                git commit-tree "$@";
	        fi' HEAD

This goes through and rewrites every commit to have your new address.
Because commits contain the SHA-1 values of their parents, this command changes every commit SHA in your history, not just those that have the matching e-mail address.

## Debugging with Git ##

Git also provides a couple of tools to help you debug issues in your projects.
Because Git is designed to work with nearly any type of project, these tools are pretty generic, but they can often help you hunt for a bug or culprit when things go wrong.

### File Annotation ###

If you track down a bug in your code and want to know when it was introduced and why, file annotation is often your best tool.
It shows you what commit was the last to modify each line of any file.
So, if you see that a method in your code is buggy, you can annotate the file with `git blame` to see when each line of the method was last edited and by whom.
This example uses the `-L` option to limit the output to lines 12 through 22:

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

Notice that the first field is the partial SHA-1 of the commit that last modified that line.
The next two fields are values extracted from that commit—the author name and the authored date of that commit — so you can easily see who modified that line and when.
After that come the line number and the content of the file.
Also note the `^4832fe2` commit lines, which designate that those lines were in this file’s original commit.
That commit is when this file was first added to this project, and those lines have been unchanged since.
This is a tad confusing, because now you’ve seen at least three different ways that Git uses the `^` to modify a commit SHA, but that is what it means here.

Another cool thing about Git is that it doesn’t track file renames explicitly.
It records the snapshots and then tries to figure out what was renamed implicitly, after the fact.
One of the interesting features of this is that you can ask it to figure out all sorts of code movement as well.
If you pass `-C` to `git blame`, Git analyzes the file you’re annotating and tries to figure out where snippets of code within it originally came from if they were copied from elsewhere.
Recently, I was refactoring a file named `GITServerHandler.m` into multiple files, one of which was `GITPackUpload.m`.
By blaming `GITPackUpload.m` with the `-C` option, I could see where sections of the code originally came from:

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

This is really useful.
Normally, you get as the original commit the commit where you copied the code over, because that is the first time you touched those lines in this file.
Git tells you the original commit where you wrote those lines, even if it was in another file.

### Binary Search ###

Annotating a file helps if you know where the issue is to begin with.
If you don’t know what is breaking, and there have been dozens or hundreds of commits since the last state where you know the code worked, you’ll likely turn to `git bisect` for help.
The `bisect` command does a binary search through your commit history to help you identify as quickly as possible which commit introduced an issue.

Let’s say you just pushed out a release of your code to a production environment, you’re getting bug reports about something that wasn’t happening in your development environment, and you can’t imagine why the code is doing that.
You go back to your code, and it turns out you can reproduce the issue, but you can’t figure out what is going wrong.
You can bisect the code to find out.
First you run `git bisect start` to get things going, and then you use `git bisect bad` to tell the system that the current commit you’re on is broken.
Then, you must tell bisect when the last known good state was, using `git bisect good [good_commit]`:

	$ git bisect start
	$ git bisect bad
	$ git bisect good v1.0
	Bisecting: 6 revisions left to test after this
	[ecb6e1bc347ccecc5f9350d878ce677feb13d3b2] error handling on repo

Git figured out that about 12 commits came between the commit you marked as the last good commit (v1.0) and the current bad version, and it checked out the middle one for you.
At this point, you can run your test to see if the issue exists as of this commit.
If it does, then it was introduced sometime before this middle commit; if it doesn’t, then the problem was introduced sometime after the middle commit.
It turns out there is no issue here, and you tell Git that by typing `git bisect good` and continue your journey:

	$ git bisect good
	Bisecting: 3 revisions left to test after this
	[b047b02ea83310a70fd603dc8cd7a6cd13d15c04] secure this thing

Now you’re on another commit, halfway between the one you just tested and your bad commit.
You run your test again and find that this commit is broken, so you tell Git that with `git bisect bad`:

	$ git bisect bad
	Bisecting: 1 revisions left to test after this
	[f71ce38690acf49c1f3c9bea38e09d82a5ce6014] drop exceptions table

This commit is fine, and now Git has all the information it needs to determine where the issue was introduced.
It tells you the SHA-1 of the first bad commit and show some of the commit information and which files were modified in that commit so you can figure out what happened that may have introduced this bug:

	$ git bisect good
	b047b02ea83310a70fd603dc8cd7a6cd13d15c04 is first bad commit
	commit b047b02ea83310a70fd603dc8cd7a6cd13d15c04
	Author: PJ Hyett <pjhyett@example.com>
	Date:   Tue Jan 27 14:48:32 2009 -0800

	    secure this thing

	:040000 040000 40ee3e7821b895e52c1695092db9bdc4c61d1730
	f24d3c6ebcfc639b1a3814550e62d60b8e68a8e4 M  config

When you’re finished, you should run `git bisect reset` to reset your HEAD to where you were before you started, or you’ll end up in a weird state:

	$ git bisect reset

This is a powerful tool that can help you check hundreds of commits for an introduced bug in minutes.
In fact, if you have a script that will exit 0 if the project is good or non-0 if the project is bad, you can fully automate `git bisect`.
First, you again tell it the scope of the bisect by providing the known bad and good commits.
You can do this by listing them with the `bisect start` command if you want, listing the known bad commit first and the known good commit second:

	$ git bisect start HEAD v1.0
	$ git bisect run test-error.sh

Doing so automatically runs `test-error.sh` on each checked-out commit until Git finds the first broken commit.
You can also run something like `make` or `make tests` or whatever you have that runs automated tests for you.

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
