# Les branches avec Git #

Quasiment tous les VCSs ont une forme ou une autre de gestion de branche.
Faire une branche signifie diverger de la ligne principale de développement et continuer à travailler sans se préoccuper de cette ligne principale.
Dans de nombreux outils de gestion de version, cette fonctionnalité est souvent chère en ressources, et nécessite souvent de créer une nouvelle copie du répertoire de travail, ce qui peut prendre longtemps dans le cas de grands projets.

De nombreuses personnes font référence au modèle de gestion de branche de Git comme LA fonctionnalité et c'est sûrement la spécificité de Git par rapport à la communauté des gestionnaires de version.
Pourquoi est-elle si spéciale ?
La méthode de Git pour gérer les branches est particulièrement légère, permettant de réaliser des embranchements quasi instantanément et de basculer de branche généralement aussi rapidement.
À la différence de nombreux autres gestionnaires de version, Git encourage à travailler avec des méthodes qui privilégient la création et la fusion de branches, jusqu'à plusieurs fois par jour.
Bien comprendre et maîtriser cette fonctionnalité est un atout pour faire de Git un outil unique qui peut littéralement changer la manière de développer.

## Ce qu'est une branche ##

Pour réellement comprendre comment Git gère les branches, nous devons revenir en arrière et examiner de plus près comment Git stocke ses données.
Comme vous pouvez vous en souvenir du chapitre 1, Git ne stocke pas ses données comme une série de changesets ou deltas, mais comme une série d'instantanés.

Lors qu'on valide dans Git, Git stock un objet commit qui contient un pointeur vers l'instantané du contenu qui a été indexé, les méta-données d'auteur et de message, et zéro ou plusieurs pointeurs vers le ou les commits qui sont les parents directs de ce commit :
zéro parent pour la première validation, un parent pour un commit normal, et des parents multiples pour des commits qui sont le résultat de la fusion d'une ou plusieurs branches.

Pour visualiser ce concept, supposons un répertoire contenant trois fichiers, ces trois fichiers étant indexés puis validés.
Indexer les fichiers signifie calculer la somme de contrôle pour chacun (la fonction de hachage SHA-1 mentionnée au chapitre 1), stocker cette version du fichier dans le dépôt Git (Git les nomme blobs), et ajouter la somme de contrôle à la zone d'index :

	$ git add LISEZMOI test.rb LICENSE
	$ git commit -m 'commit initial de mon projet'

Lorsque vous créez le commit en lançant la commande `git commit`, Git calcule la somme de contrôle de chaque répertoire (ici, seulement pour le répertoire racine) et stocke ces objets arbres dans le dépôt Git.
Git crée alors un objet commit qui contient les méta-données et un pointeur vers l'arbre projet d'origine de manière à pouvoir recréer l'instantané si besoin.

Votre dépôt Git contient à présent cinq objets :
un blob pour le contenu de chacun des trois fichiers, un arbre qui liste les contenus des répertoires et spécifie quels noms de fichier sont attachés à quels blobs, et un objet commit avec le pointeur vers l'arbre d'origine et toutes les méta-données attachées au commit.
Conceptuellement, les données contenues dans votre dépôt git ressemblent à la Figure 3-1.

Insert 18333fig0301.png 
Figure 3-1. Données d'un unique commit.

Si vous réalisez des modifications et validez à nouveau, le prochain commit stocke un pointeur vers le commit immédiatement précédent.
Après deux autres validations, l'historique pourrait ressembler à la figure 3-2.

Insert 18333fig0302.png 
Figure 3-2. Données et objets Git pour des validations multiples.

Une branche dans Git est tout simplement un pointeur mobile léger vers un de ces objets commit.
La branche par défaut dans Git s'appelle master.
Au fur et à mesure des validations, la branche master pointe vers le dernier des commits réalisés.
À chaque validation, le pointeur de la branche master avance automatiquement.

Insert 18333fig0303.png 
Figure 3-3. Branche pointant dans l'historique des données de commit.

Que se passe-t-il si vous créez une nouvelle branche ?
Et bien, cela crée un nouveau pointeur à déplacer.
Supposons que vous créez une nouvelle branche nommée testing.
Vous utilisez la commande `git branch` :

	$ git branch testing

Cela crée un nouveau pointeur vers le commit actuel (Cf. figure 3-4).

Insert 18333fig0304.png 
Figure 3-4. Branches multiples pointant dans l'historique des données de commit.

Comment Git connaît-il la branche sur laquelle vous vous trouvez ?
Il conserve un pointeur spécial appelé HEAD.
Remarquez que sous cette appellation se cache un concept très différent de celui utilisé dans les autres VCSs tels que Subversion ou CVS.
Dans Git, c'est un pointeur sur la branche locale où vous vous trouvez.
Dans notre cas, vous vous trouvez toujours sur master.
La commande git branch n'a fait que créer une nouvelle branche — elle n'a pas fait basculer la copie de travail vers cette branche (Cf. figure 3-5).

Insert 18333fig0305.png 
Figure 3-5. fichier HEAD pointant sur la branche active

Pour basculer vers une branche existant, il suffit de lancer la commande `git checkout`.
Basculons vers la nouvelle branche testing :

	$ git checkout testing

Cela déplace HEAD pour le faire pointer vers la branche testing (voir figure 3-6)

Insert 18333fig0306.png
Figure 3-6. HEAD pointe vers une autre branche quand on bascule de branche

Qu'est-ce que cela signifie ?
Et bien, faisons une autre validation :

	$ vim test.rb
	$ git commit -a -m 'petite modification'

La figure 3-7 illustre le résultat.

Insert 18333fig0307.png 
Figure 3-7. La branche sur laquelle HEAD pointe avance avec chaque nouveau commit.

C'est intéressant parce qu'à présent, votre branche testing a avancé, tandis que la branche master pointe toujours sur le commit sur lequel vous étiez lorsque vous avez lancé `git checkout` pour basculer de branche.
Retournons sur la branche master :

	$ git checkout master

La figure 3-8 montre le résultat.

Insert 18333fig0308.png 
Figure 3-8. HEAD se déplace sur une autre branche lors d'un checkout.

Cette commande a réalisé deux actions.
Elle a remis le pointeur HEAD sur la branche master et elle a replacé les fichiers de la copie de travail dans l'état pointé par master.
Cela signifie aussi que les modifications que vous réalisez à partir de maintenant divergeront de l'ancienne version du projet.
Cette commande retire les modifications réalisées dans la branche testing pour vous permettre de repartir dans une autre direction de développement.

Réalisons quelques autres modifications et validons à nouveau :

	$ vim test.rb
	$ git commit -a -m 'autres modifications'

Maintenant, l'historique du projet a divergé (voir figure 3-9).
Vous avez créé une branche et basculé dessus, avez réalisé des modifications, puis avez rebasculé sur la branche principale et réalisé d'autre modifications.
Ces deux modifications sont isolées dans des branches séparées.
Vous pouvez basculer d'une branche à l'autre et les fusionner quand vous êtes prêt.
Vous avez fait tout ceci avec de simples commandes `branch` et `checkout`.

Insert 18333fig0309.png 
Figure 3-9. Les historiques de branche ont divergé.

Parce que dans Git, une branche n'est en fait qu'un simple fichier contenant les 40 caractères de la somme de contrôle SHA-1 du commit sur lequel elle pointe, les branches ne coûtent rien à créer et détruire.
Créer une branche est aussi rapide qu'écrire un fichier de 41 caractères (40 caractères plus un retour chariot).

C'est une différence de taille avec la manière dont la plupart des VCSs gèrent les branches, qui implique de copier tous les fichiers du projet dans un second répertoire.
Cela peut durer plusieurs secondes ou même quelques minutes selon la taille du projet, alors que pour Git, le processus est toujours instantané.
De plus, comme nous enregistrons les parents quand nous validons les modifications, la détermination de l'ancêtre commun pour la fusion est réalisée automatiquement, et de manière très facile.
Ces fonctionnalités encouragent naturellement les développeurs à créer et utiliser souvent des branches. 

Voyons pourquoi vous devriez en faire autant.

## Brancher et fusionner : les bases ##

Suivons un exemple simple de branche et fusion dans une utilisation que vous feriez dans le monde réel.
Vous feriez les étapes suivantes :

1.	Travailler sur un site web
2.	Créer une branche pour une nouvelle Story sur laquelle vous souhaiteriez travailler
3.	Réaliser quelques tâches sur cette branche

À cette étape, vous recevez un appel pour vous dire qu'un problème critique a été découvert et qu'il faut le régler au plus tôt.
Vous feriez ce qui suit :

1.	Revenir à la branche de production
2.	Créer un branche et y développer le correctif
3.	Après qu'il a été testé, fusionner la branche de correctif et pousser le résultat à la production
4.	Rebasculer à la branche initiale et continuer le travail

### Le branchement de base ###

Premièrement, supposons que vous êtes à travailler sur votre projet et avez déjà quelques commits (voir figure 3-10).

Insert 18333fig0310.png 
Figure 3-10. Un historique simple et court.

Vous avez décidé de travailler sur le problème numéroté #53 dans le suivi de faits techniques que votre entreprise utilise.
Pour clarifier, Git n'est pas lié à un gestionnaire particulier de faits techniques.
Mais comme le problème #53 est un problème ciblé sur lequel vous voulez travailler, vous allez créer une nouvelle branche dédiée à sa résolution.
Pour créer une branche et y basculer tout de suite, vous pouvez lancer la commande `git checkout` avec l'option `-b` :

	$ git checkout -b prob53
	Switched to a new branch "prob53"

C'est un raccourci pour :

	$ git branch prob53
	$ git checkout prob53

La figure 3-11 illustre le résultat.

Insert 18333fig0311.png 
Figure 3-11. Création d'un nouveau pointeur de branche.

Vous travaillez sur votre site web et validez des modifications.
Ce faisant, la branche `prob53` avance, parce que vous l'avez extraite (c'est-à-dire que votre pointeur HEAD pointe dessus, voir figure 3-12) :

	$ vim index.html
	$ git commit -a -m 'ajout d'un pied de page [problème 53]'

Insert 18333fig0312.png 
Figure 3-12. La branche prob53 a avancé avec votre travail.

Maintenant vous recevez un appel qui vous apprend qu'il y a un problème sur le site web, un problème qu'il faut résoudre immédiatement.
Avec Git, vous n'avez pas besoin de déployer les modifications déjà validée pour `prob53` avec les correctifs du problème et vous n'avez pas non plus à suer pour éliminer ces modifications avant de pouvoir appliquer les correctifs du problème en production.
Tout ce que vous avez à faire, c'est simplement rebasculer sur la branche `master`.

Cependant, avant de le faire, notez que si votre copie de travail ou votre zone de préparation contient des modifications non validées qui sont en conflit avec la branche que vous extrayez, Git ne vous laissera pas basculer de branche.
Le mieux est d'avoir votre copie de travail dans un état propre au moment de basculer de branche.
Il y a des moyens de contourner ceci (précisément par la planque et l'amendement de commit) dont nous parlerons plus loin.
Pour l'instant, vous avez validé tous vos changements dans la branche `prob53` et vous pouvez donc rebasculer vers la branche `master` : 

	$ git checkout master
	Switched to branch "master"

À présent, votre répertoire de copie de travail est exactement dans l'état précédent les modifications pour le problème #53 et vous pouvez vous consacrer à votre correctif.
C'est un point important : Git réinitialise le répertoire de travail pour qu'il ressemble à l'instantané de la validation sur laquelle la branche que vous extrayez pointe.
Il ajoute, retire et modifie les fichiers automatiquement pour assurer que la copie de travail soit identique à ce qu'elle était lors de votre dernière validation sur la branche.

Ensuite, vous avez un correctif à faire.
Créons une branche de correctif sur laquelle travailler jusqu'à ce que ce soit terminé (voir figure 3-13) :

	$ git checkout -b 'correctif'
	Switched to a new branch "correctif"
	$ vim index.html
	$ git commit -a -m "correction d'une adresse mail incorrecte"
	[correctif]: created 3a0874c: "correction d'une adresse mail incorrecte"
	 1 files changed, 0 insertions(+), 1 deletions(-)

Insert 18333fig0313.png 
Figure 3-13. Branche de correctif basée à partir de la branche master.

Vous pouvez lancer vos tests, vous assurer que la correction est efficace, et la fusionner dans la branche master pour la déployer en production.
Vous réalisez ceci au moyen de la commande `git merge` :

	$ git checkout master
	$ git merge correctif
	Updating f42c576..3a0874c
	Fast forward
	 LISEZMOI |    1 -
	 1 files changed, 0 insertions(+), 1 deletions(-)

Vous noterez la mention "Fast forward" qui signifie avance rapide dans cette fusion.
Comme le commit pointé par la branche que vous avez fusionné était directement descendant du commit sur lequel vous vous trouvez, Git a avancé le pointeur en avant. 
Autrement dit, lorsque l'on cherche à fusionner un commit qui peut être joint en suivant l'historique depuis le commit d'origine, Git avance simplement le pointeur car il n'y a pas de travaux divergeant à réellement fusionner — ceci s'appelle l'avance rapide.

Votre modification est maintenant dans l'instantané du commit pointé par la branche `master`, et vous pouvez déployer votre modification (voir figure 3-14)

Insert 18333fig0314.png 
Figure 3-14. Après la fusion, votre branche master pointe au même endroit que la correction.

Après le déploiement de votre correction super-importante, vous voilà de nouveau prêt à travailler sur votre sujet précédent l'interruption.
Cependant, vous allez avant tout effacer la branche `correctif` parce que vous n'en avez plus besoin et la branche `master` pointe au même endroit.
Vous pouvez l'effacer avec l'option `-d` de la commande `git branch` :

	$ git branch -d correctif
	Deleted branch correctif (3a0874c).

Maintenant, il est temps de basculer sur la branch "travaux en cours" sur le problème #53 et de continuer à travailler dessus (voir figure 3-15) :

	$ git checkout prob53
	Switched to branch "prob53"
	$ vim index.html
	$ git commit -a -m 'Nouveau pied de page terminé [problème 53]'
	[prob53]: created ad82d7a: "Nouveau pied de page terminé [problème 53]"
	 1 files changed, 1 insertions(+), 0 deletions(-)

Insert 18333fig0315.png 
Figure 3-15. Votre branche prob53 peut avancer indépendamment de master.

Il est utile de noter que le travail réalisé dans `correctif` n'est pas contenu dans les fichiers de la branche `prob53`.
Si vous avez besoin de les y rapatrier, vous pouvez fusionner la branche `master` dans la branche `prob53` en lançant la commande `git merge master`, ou vous pouvez retarder l'intégration de ces modifications jusqu'à ce que vous décidiez plus tard de rapatrier la branche `prob53` dans `master`.

### Les bases de la fusion ###

Supposons que vous ayez décidé que le travail sur le problème #53 est terminé et se trouve donc prêt à être fusionné dans la branche `master`.
Pour ce faire, vous allez rapatrier votre branche `prob53` de la même manière que vous l'avez fait plus tôt pour la branche `correctif`.
Tout ce que vous avez à faire est d'extraire la branche dans laquelle vous souhaitez fusionner et lancer la commande `git merge` :

	$ git checkout master
	$ git merge prob53
	Merge made by recursive.
	 README |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Le comportement semble légèrement différent de celui observé pour la fusion précédente de `correctif`. Dans ce cas, l'historique de développement a divergé à un certain point.
Comme le commit sur la branche sur laquelle vous vous trouvez n'est plus un ancêtre direct de la branche que vous cherchez à fusionner, Git doit travailler.
Dans ce cas, Git réalise une simple fusion à trois sources, en utilisant les deux instantanés pointés par les sommets des branches et l'ancêtre commun des deux.
La figure 3-16 illustre les trois instantanés que Git utilise pour réaliser la fusion dans ce cas.

Insert 18333fig0316.png 
Figure 3-16. Git identifie automatiquement la meilleure base d'ancêtre commun pour réaliser la fusion.

Au lieu de simplement d'avancer le pointeur de branche, Git crée un nouvel instantané qui résulte de la fusion à trois branches et crée automatiquement un nouveau commit qui pointe dessus (voir figure 3-17).
On appelle ceci un commit de fusion, qui est spécial en ce qu'il comporte plus d'un parent.

Il est à noter que que Git détermine par lui-même le meilleur ancêtre commun à utiliser comme base de fusion ; ce comportement est très différent de celui de CVS ou Subversion (antérieur à la version 1.5), où le développeur en charge de la fusion doit trouver par lui-même la meilleure base de fusion.
Cela rend la fusion tellement plus facile dans Git que dans les autres systèmes.

Insert 18333fig0317.png 
Figure 3-17. Git crée automatiquement un nouvel objet commit qui contient le travail fusionné.

A présent que votre travail a été fusionné, vous n'avez plus besoin de la branche `prob53`.
Vous pouvez l'effacer et fermer manuellement le ticket dans votre outil de suivi de faits techniques :

	$ git branch -d prob53

### Conflits de fusion ###

Quelques fois, le processus ci-dessus ne se passe pas sans accroc.
Si vous avez modifié différemment la même partie du même fichier dans les deux branches que vous souhaitez fusionner, Git ne sera pas capable de réaliser proprement la fusion.
Si votre résolution du problème #53 a modifié la même section de fichier que le `correctif`, vous obtiendrez une conflit de fusion qui ressemble à ceci :

	$ git merge prob53
	Auto-merging index.html
	CONFLICT (content): Merge conflict in index.html
	Automatic merge failed; fix conflicts and then commit the result.

Git n'a pas automatiquement créé le commit du fusion.
Il a arrêté le processus le temps que vous résolviez le conflit.
Lancez `git status`  pour voir à tout moment  après l'apparition du conflit de fusion quels fichiers n'ont pas été fusionnés :

	[master*]$ git status
	index.html: needs merge
	# On branch master
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#	unmerged:   index.html
	#

Tout ce qui comporte des conflits de fusion et n'a pas été résolu est listé comme `unmerged`.
Git ajoute des marques de conflit standard dans les fichiers qui comportent des conflit, pour que vous puissiez les ouvrir et résoudre les conflits manuellement.
Votre fichier contient des sections qui ressemblent à ceci :

	<<<<<<< HEAD:index.html
	<div id="footer">contact : email.support@github.com</div>
	=======
	<div id="footer">
	  please contact us at support@github.com
	</div>
	>>>>>>> prob53:index.html

Cela signifie que la version dans HEAD (votre branche master, parce que c'est celle que vous aviez extraite quand vous avez lancé votre commande de fusion) est la partie supérieure de ce bloc (tout ce qui se trouve au dessus de la ligne `=======`), tandis que la version de la branche `prob53` se trouve en dessous.
Pour résoudre le conflit, vous devez choisir une partie ou l'autre ou bien fusionner leurs contenus par vous-même.
Par exemple, vous pourriez choisir de résoudre ce conflit en remplaçant tout le bloc par ceci :

	<div id="footer">
	please contact us at email.support@github.com
	</div>

Cette résolution comporte des parties de chaque section, et les lignes `<<<<<<<`, `=======`, et `>>>>>>>` ont été complètement effacées.
Après avoir résolu chacune de ces sections dans chaque fichier comportant un conflit, lancez `git add` sur chaque fichier pour le marquer comme résolu.
Préparer le fichier en zone de préparation suffit à le marquer résolu pour Git.
Si vous souhaitez utiliser un outil graphique pour résoudre ces problèmes, vous pouvez lancer `git mergetool` qui démarre l'outil graphique de fusion approprié et vous permet de naviguer dans les conflits :

	$ git mergetool
	merge tool candidates: kdiff3 tkdiff xxdiff meld gvimdiff opendiff emerge vimdiff
	Merging the files: index.html

	Normal merge conflict for 'index.html':
	  {local}: modified
	  {remote}: modified
	Hit return to start merge resolution tool (opendiff):

Si vous souhaitez utiliser un outil de fusion autre que celui par défaut (Git a choisi `opendiff` pour moi dans ce cas car j'utilise la commande sous Mac), vous pouvez voir tous les outils supportés après l'indication "merge tool candidates".
Tapez le nom de l'outil que vous préféreriez utiliser.
Au chapitre 7, nous expliquerons comment changer cette valeur par défaut dans votre environnement.

Après avoir quitté l'outil de fusion, Git vous demande si la fusion a été réussie.
Si vous répondez par la positive à l'outil, il indexe le fichier pour le marquer comme résolu.

Vous pouvez lancer à nouveau la commande `git status` pour vérifier que tous les conflits ont été résolus :

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	modified:   index.html
	#

Cela vous convient et vous avez vérifié que tout ce qui comportait un conflit a été indexé, vous pouvez taper la commande `git commit` pour finaliser le commit de fusion.
Le message de validation ressemble d'habitude à ceci :

	Merge branch 'prob53'

	Conflicts:
	  index.html
	#
	# It looks like you may be committing a MERGE.
	# If this is not correct, please remove the file
	# .git/MERGE_HEAD
	# and try again.
	#

Vous pouvez modifier ce message pour inclure les détails sur la résolution du conflit si vous pensez que cela peut être utile lors d'une revue ultérieure es— pourquoi vous avez fait ceci si ce n'est pas clair.

## Gestion de branches ##

Après avoir créé, fusionné et effacé des branches, regardons de plus près les outils de gestion de branche qui s'avèreront utiles lors d'une utilisation intensive des branches.

La commande `git branch` fait plus que créer et effacer des branches.
Si vous la lancez sans argument, vous obtenez la liste des branches courantes :

	$ git branch
	  prob53
	* master
	  testing

Notez le caractère `*` qui préfixe la branche `master`.
Ce caractère indique la branche qui a été extraite.
Ceci signifie que si vous validez des modifications, la branche `master` avancera avec votre travail.
Pour visualiser les dernière validations sur chaque branche, vous pouvez lancer le commande `git branch -v` :

	$ git branch -v
	  prob53   93b412c fix javascript issue
	* master  7a98805 Merge branch 'prob53'
	  testing 782fd34 add scott to the author list in the readmes

Une autre option permettant de voir l'état des branches permet de filtrer cette liste par les branches qui ont ou n'ont pas encore été fusionnées dans la branche courante.
Les options `--merged` et `--no-merge` sont disponibles depuis la version 1.5.6 de Git.
Pour voir quelles branches ont déjà été fusionnées dans votre branche actuelle, lancez `git branch --merged` :

	$ git branch --merged
	  prob53
	* master

Comme vous avez déjà fusionné `prob53` auparavant, vous le voyez dans votre liste.
Les branches de cette liste qui ne comportent pas l'étoile en préfixe peuvent généralement être effacées sans risque au moyen de `git branch -d` ; vous avez déjà incorporé leurs modifications dans une autre branche, et n'allez donc rien perdre.

Lancez `git branch --no-merged` pour visualiser les branches qui contiennent des travaux qui n'ont pas encore été fusionnés :

	$ git branch --no-merged
	  testing

Ceci montre votre autre branche.
Comme elle contient des modifications qui n'ont pas encore été fusionnées, un essai d'effacement par `git branch -d` se solde par un échec :

	$ git branch -d testing
	error: The branch 'testing' is not an ancestor of your current HEAD.
	If you are sure you want to delete it, run 'git branch -D testing'.

Si vous souhaitez réellement effacer cette branche et perdre ainsi le travail réalisé, vous pouvez forcer l'effacement avec l'option `-D`, comme l'indique justement le message.

## Travailler avec les branches ##

Après avoir acquis les bases pour brancher et fusionner, que pouvons-nous ou devons-nous en faire ?
Ce chapitre traite des différents style de développement que cette gestion de branche légère permet de mettre en place, pour vous aider à décider d'en incorporer une dans votre cycle de développement.

### Les branches au long cours ###

Comme Git utilise une fusion à 3 branches, fusionner une branche dans une autre plusieurs fois sur une longue période est généralement facile.
Cela signifie que vous pouvez travailler sur plusieurs branches ouvertes en permanence pendant plusieurs étapes de votre cycle de développement ; vous pouvez fusionner régulièrement certaines dans d'autres.

De nombreux développeurs utilisent Git avec une méthode que utilise cette approche, telle que n'avoir que du code entièrement stable et testé dans la branche `master`, voire du code que a été ou sera publié.
Ils ont une autre branche en parallèle appelée develop qui, lorsqu'elle devient stable, peut être fusionnée dans `master`.
Cette branche est utilisée pour tirer des branches spécifiques (branches avec une faible durée de vie, telles que notre branche `prob53`) quand elles sont prêtes, s'assurer qu'elles passent tous les tests et n'introduisent pas de bugs.

En réalité, nous parlons de pointeurs qui se déplacent le long des lignes des commits réalisés.
Les branches stables sont plus profond dans la ligne de l'historique des commits tandis que les branches des derniers développements sont plus en haut dans l'historique (voir figure 3-18).

Insert 18333fig0318.png 
Figure 3-18. Les branches les plus stables sont généralement plus bas dans l'historique des commits.

C'est généralement plus simple d'y penser en terme de silos de tâche, où un ensemble de commits évolue vers un silo plus stable quand il a été complètement testé (voir figure 3-19).

Insert 18333fig0319.png 
Figure 3-19. Représentation des branches comme des silos.

Vous pouvez reproduire ce schéma sur plusieurs niveaux de stabilité.
Des projets plus gros ont aussi une branche `proposed` ou `pu` (proposed updates) qui permet d'intégrer des branches qui ne sont pas encore prêtes pour la prochaine version ou pour `master`.
L'idée reste que les branches évoluent à différents niveaux de stabilité ; quand elles atteignent un niveau plus stable, elles peuvent être fusionnées dans la branche de stabilité supérieure.
Une fois encore, les branches au long cours ne sont pas nécessaires, mais s'avèrent souvent utiles, spécialement dans le cadre de projets gros ou complexes.

### Les branches de sujet ###

Les branches de sujet sont tout de même utiles quelle que soit la taille du projet.
Une branche de sujet est une branche de courte vie créée et utilisée pour une fonctionnalité ou une tâche particulière.
C'est une manière d'opérer que vous n'avez vraisemblablement jamais utilisée avec un autre VCS parce qu'il est généralement trop lourd de créer et fusionner des branches.
Mais dans Git, créer, développer, fusionner et effacer des branches plusieurs fois par jour est monnaie courante.

Vous l'avez remarqué dans la section précédent avec les branches `prob53` et `correctif` que vous avez créées.
Vous avez réalisé quelque validations sur elles et vous les avez effacées juste après les avoir fusionné dans votre branche principale.
Cette technique vous permet de basculer de contexte complètement et immédiatement. 
Il est beaucoup plus simple de réaliser des revues de code parce que votre travail est isolé dans des silos où toutes les modifications sont liées au sujet .
Vous pouvez entreposer vos modifications ici pendant des minutes, des jours ou des mois, puis les fusionner quand elles sont prêtes, indépendamment de l'ordre dans lequel elles ont été créées ou de développées.

Supposons un exemple où pendant un travail (sur `master`), vous branchiez pour un problème (`prob91`), travaillez un peu dessus, vous branchiez une seconde branche pour essayer de trouver une autre manière de le résoudre (`prob91v2`), vous retourniez sur la branche `master` pour y travailler pendant un moment pour finalement brancher sur un dernière branche (`ideeidiote`) pour laquelle vous n'êtes pas sûr que ce soit une bonne idée.
Votre historique de commit pourrait ressembler à la figure 3-20.

Insert 18333fig0320.png 
Figure 3-20. Votre historique de commit avec de multiples branches de sujet.

Maintenant, supposons que vous décidez que vous préférez la seconde solution pour le problème (`prob91v2`) et que vous ayez montré la branche `ideeidiote` à vos collègues qui vous ont dit qu'elle était géniale.
Vous pouvez jeter la branche `prob91` originale (en effaçant les commits C5 et C6) et fusionner les deux autres.
Votre historique ressemble à présent à la figure 3-21.

Insert 18333fig0321.png 
Figure 3-21. Votre historique après la fusion de `ideeidiote` et `prob91v2`.

Souvenez-vous que lors de la réalisation de ces actions, toutes ces branches sont complètement locales.
Lorsque vous branchez et fusionnez, tout est réalisé dans votre dépôt Git.
Aucune communication avec un serveur n'a lieu.

## Les branches distantes ##

Les branches distantes sont des références à l'état des branches sur votre dépôt distant.
Ce sont des branches locales qu'on ne peut pas modifier ; elles sont modifiées automatiquement lors de communications réseau.
Les branches distantes agissent comme des marques-pages pour vous aider à vous souvenir de l'état de votre dépôt distant lorsque vous vous y êtes connectés.

Elles prennent la forme de `(distant)/(branche)`.
Par exemple, si vous souhaitiez visualiser l'état de votre branche `master` sur le dépôt distant `origin` lors de votre dernière communication, il vous suffit de vérifier la branche `origin/master`.
Si vous étiez en train de travailler avec un collègue et qu'il a mis à jour la branche `prob53`, vous pourriez avoir votre propre branche `prob53` ; mais la branche sur le serveur pointerait sur le commit de `origin/prob53`.

Cela peut paraître déconcertant, alors éclaircissons les choses par un exemple.
Supposons que vous avez un serveur Git sur le réseau à l'adresse `git.notresociete.com`.
Si vous clones à partir de ce serveur, Git le nomme automatiquement `origin`, et en tire tout l'historique, crée un pointeur sur l'état actuel de la branche `master`, et l'appelle localement `origin/master` ; vous ne pouvez pas la modifier.
Git vous crée votre propre branche `master` qui démarre au même commit que la branche `master` d'origine, pour que vous puissiez commencer à travailler (voir figure 3-22).

Insert 18333fig0322.png 
Figure 3-22. Un clonage Git vous fournit une branche master et une branche origin/master pointant sur la branche master de l'origine.

Si vous travaillez sur votre branche locale `master`, et que dans le même temps, quelqu'un pousse vers `git.notresociete.com` et met à jour cette branche, alors vos deux historiques divergent.
Tant que vous restez sans contact avec votre serveur distant, votre pointeur `origin/master` n'avance pas (voir figure 3-23).

Insert 18333fig0323.png 
Figure 3-23. Les travaux locaux et les modifications poussées sur le serveur distant font diverger les deux historiques.

Lancez la commande `git fetch origin` pour synchroniser votre travail.
Cette commande recherche le serveur hébergeant origin (dans notre cas, `git.notresociete.com`), en récupère toutes les nouvelles données et met à jour votre base de donnée locale en déplaçant votre pointeur `origin/master` à sa valeur nouvelle à jour avec le serveur distant (voir figure 3-24).

Insert 18333fig0324.png 
Figure 3-24. La commande git fetch met à jour vos références distantes.

Pour démontrer l'usage de multiples serveurs distants et le fonctionnement avec des branches multiples, supposons que vous avez un autre serveur Git interne qui n'est utilisé pour le développement que par une équipe.
Ce serveur se trouve sur `git.equipe1.notresociete.com`.
Vous pouvez l'ajouter à vos références distantes de votre projet actuel en lançant la commande `git remote add` comme nous l'avons décrit au chapitre 2.
Nommez ce serveur distant `equipeun` qui sera le raccourci pour l'URL complète (voir figure 3-25).

Insert 18333fig0325.png 
Figure 3-25. Ajouter un autre serveur comme accès distant.

Maintenant, lancez `git fetch equipeun` pour récupérer l'ensemble des informations du serveur que vous ne possédez pas.
Comme ce serveur contient déjà un sous-ensemble des données du serveur `origin`, Git ne récupère aucune donnée mais positionne une branche distante appelée `equipeun/master` qui pointe sur le commit que `equipeun` a comme branche `master` (voir figure 3-26).

Insert 18333fig0326.png 
Figure 3-26. Vous récupérez une référence locale à la branch master de equipeun.

### Pousser vers un serveur ###

Lorsque vous souhaitez partager une branche avec le reste du monde, vous devez la pousser sur le serveur distant sur lequel vous avez accès en écriture.
Vos branches locales ne sont pas automatiquement synchronisées sur les serveurs distants — vous devez pousser explicitement les branches que vous souhaitez partager.
De cette manière, vous pouvez utiliser des branches privées pour le travail que vous ne souhaitez pas partager, et ne pousser que les branches sur lesquelles vous souhaitez collaborer.

Si vous possédez une branche nommée `correctionserveur` sur laquelle vous souhaitez travailler avec des tiers, vous pouvez la pousser de la même manière que vous avez poussé votre première branche.
Lancez `git push [serveur distant] [branche]` :

	$ git push origin correctionserveur
	Counting objects: 20, done.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (15/15), 1.74 KiB, done.
	Total 15 (delta 5), reused 0 (delta 0)
	To git@github.com:schacon/simplegit.git
	 * [new branch]      correctionserveur -> correctionserveur

C'est un raccourci.
En fait, Git étend le nom de branche `correctionserveur` en `refs/heads/correctionserveur:refs/heads/correctionserveur`, ce qui signifie « Prendre ma branche locale correctionserveur et la pousser pour mettre à jour la branche distante correctionserveur ».
Nous traiterons plus en détail la partie `refs/heads/` au chapitre 9, mais vous pouvez généralement l'oublier.
Vous pouvez aussi lancer `git push origin correctionserveur:correctionserveur`, qui réalise la même chose — ce qui signifie « Prendre ma branche correctionserveur et en faire la branche correctionserveur distante ».
Vous pouvez utiliser ce format pour pousser une branche locale vers une branche distante nommée différemment.
Si vous ne souhaitez pas l'appeler `correctionserveur` sur le serveur distant, vous pouvez lancer à la place `git push origin correctionserveur:branchegeniale` pour pousser votre branche locale `correctionserveur` sur la branche `branchegeniale` sur le projet distant.

La prochaine fois qu'un de vos collaborateurs récupère les données depuis le serveur, il récupérera une référence à l'état de la branche distante `origin/correctionserveur` :

	$ git fetch origin
	remote: Counting objects: 20, done.
	remote: Compressing objects: 100% (14/14), done.
	remote: Total 15 (delta 5), reused 0 (delta 0)
	Unpacking objects: 100% (15/15), done.
	From git@github.com:schacon/simplegit
	 * [new branch]      correctionserveur    -> origin/correctionserveur

Important : lorsque l'on récupère une nouvelle branche depuis un serveur distant, il n'y a pas de création automatique d'une copie locale éditable.
En d'autres termes, il n'y a pas de branche `correctionserveur`, seulement un pointeur sur la branche `origin/correctionserveur` qui n'est pas modifiable.

Pour fusionner ce travail dans votre branche actuelle de travail, vous pouvez lancer `git merge origin/correctionserveur`.
Si vous souhaitez créer votre propre branche `correctionserveur` pour pouvoir y travailler, vous pouvez la baser sur le pointeur distant :

	$ git checkout -b correctionserveur origin/correctionserveur
	Branch correctionserveur set up to track remote branch refs/remotes/origin/correctionserveur.
	Switched to a new branch "correctionserveur"

Cette commande vous fournit une branche locale modifiable basée sur l'état actuel de `origin/correctionserveur`.

### Suivre les branches ###

L'extraction d'une branche locale à partir d'une branche distante crée automatiquement ce qu'on appelle une _branche de suivi_.
Les branches de suivi sont des branches locales qui sont en relation directe avec une branche distante.
Si vous vous trouvez sur une branche de suivi et que vous tapez `git push`, Git sélectionne automatiquement le serveur vers lequel pousser vos modifications.
De même, `git pull` sur une de ces branches récupère toutes les références distantes et les fusionne automatiquement dans la branche distante correspondante.

Lorsque vous clonez un dépôt, il crée généralement automatiquement une branche `master` qui suit `origin/master`.
C'est pourquoi les commandes `git push` et `git pull` fonctionnent directement sans plus de paramétrage.
Vous pouvez néanmoins créer d'autres branches de suivi si vous le souhaitez, qui ne suivront pas `origin` ni la branche `master`.
Un cas d'utilisation simple est l'exemple précédent, en lançant `git checkout -b [branche] [nomdistant]/[branche]`.
Si vous avez Git version 1.6.2 ou plus, vous pouvez aussi utiliser l'option courte `--track` :

	$ git checkout --track origin/correctionserveur
	Branch correctionserveur set up to track remote branch refs/remotes/origin/correctionserveur.
	Switched to a new branch "serverfix"

Pour créer une branche local avec un nom différent de celui de la branche distante, vous pouvez simplement utiliser la première version avec un nom de branch locale différent :

	$ git checkout -b sf origin/correctionserveur
	Branch sf set up to track remote branch refs/remotes/origin/correctionserveur.
	Switched to a new branch "sf"

À présent, votre branche locale sf poussera vers et tirera automatiquement depuis origin/correctionserveur.

### Effacer des branches distantes ###

Suppose you’re done with a remote branch — say, you and your collaborators are finished with a feature and have merged it into your remote’s `master` branch (or whatever branch your stable codeline is in). You can delete a remote branch using the rather obtuse syntax `git push [remotename] :[branch]`. If you want to delete your `correctionserveur` branch from the server, you run the following:

	$ git push origin :correctionserveur
	To git@github.com:schacon/simplegit.git
	 - [deleted]         correctionserveur

Boom. No more branch on your server. You may want to dog-ear this page, because you’ll need that command, and you’ll likely forget the syntax. A way to remember this command is by recalling the `git push [remotename] [localbranch]:[remotebranch]` syntax that we went over a bit earlier. If you leave off the `[localbranch]` portion, then you’re basically saying, “Take nothing on my side and make it be `[remotebranch]`.”

## Rebasing ##

In Git, there are two main ways to integrate changes from one branch into another: the `merge` and the `rebase`. In this section you’ll learn what rebasing is, how to do it, why it’s a pretty amazing tool, and in what cases you won’t want to use it.

### The Basic Rebase ###

If you go back to an earlier example from the Merge section (see Figure 3-27), you can see that you diverged your work and made commits on two different branches.

Insert 18333fig0327.png 
Figure 3-27. Your initial diverged commit history.

The easiest way to integrate the branches, as we’ve already covered, is the `merge` command. It performs a three-way merge between the two latest branch snapshots (C3 and C4) and the most recent common ancestor of the two (C2), creating a new snapshot (and commit), as shown in Figure 3-28.

Insert 18333fig0328.png 
Figure 3-28. Merging a branch to integrate the diverged work history.

However, there is another way: you can take the patch of the change that was introduced in C3 and reapply it on top of C4. In Git, this is called _rebasing_. With the `rebase` command, you can take all the changes that were committed on one branch and replay them on another one.

In this example, you’d run the following:

	$ git checkout experiment
	$ git rebase master
	First, rewinding head to replay your work on top of it...
	Applying: added staged command

It works by going to the common ancestor of the two branches (the one you’re on and the one you’re rebasing onto), getting the diff introduced by each commit of the branch you’re on, saving those diffs to temporary files, resetting the current branch to the same commit as the branch you are rebasing onto, and finally applying each change in turn. Figure 3-29 illustrates this process.

Insert 18333fig0329.png 
Figure 3-29. Rebasing the change introduced in C3 onto C4.

At this point, you can go back to the master branch and do a fast-forward merge (see Figure 3-30).

Insert 18333fig0330.png 
Figure 3-30. Fast-forwarding the master branch.

Now, the snapshot pointed to by C3 is exactly the same as the one that was pointed to by C5 in the merge example. There is no difference in the end product of the integration, but rebasing makes for a cleaner history. If you examine the log of a rebased branch, it looks like a linear history: it appears that all the work happened in series, even when it originally happened in parallel.

Often, you’ll do this to make sure your commits apply cleanly on a remote branch — perhaps in a project to which you’re trying to contribute but that you don’t maintain. In this case, you’d do your work in a branch and then rebase your work onto `origin/master` when you were ready to submit your patches to the main project. That way, the maintainer doesn’t have to do any integration work — just a fast-forward or a clean apply.

Note that the snapshot pointed to by the final commit you end up with, whether it’s the last of the rebased commits for a rebase or the final merge commit after a merge, is the same snapshot — it’s only the history that is different. Rebasing replays changes from one line of work onto another in the order they were introduced, whereas merging takes the endpoints and merges them together.

### More Interesting Rebases ###

You can also have your rebase replay on something other than the rebase branch. Take a history like Figure 3-31, for example. You branched a topic branch (`server`) to add some server-side functionality to your project, and made a commit. Then, you branched off that to make the client-side changes (`client`) and committed a few times. Finally, you went back to your server branch and did a few more commits.

Insert 18333fig0331.png 
Figure 3-31. A history with a topic branch off another topic branch.

Suppose you decide that you want to merge your client-side changes into your mainline for a release, but you want to hold off on the server-side changes until it’s tested further. You can take the changes on client that aren’t on server (C8 and C9) and replay them on your master branch by using the `--onto` option of `git rebase`:

	$ git rebase --onto master server client

This basically says, “Check out the client branch, figure out the patches from the common ancestor of the `client` and `server` branches, and then replay them onto `master`.” It’s a bit complex; but the result, shown in Figure 3-32, is pretty cool.

Insert 18333fig0332.png 
Figure 3-32. Rebasing a topic branch off another topic branch.

Now you can fast-forward your master branch (see Figure 3-33):

	$ git checkout master
	$ git merge client

Insert 18333fig0333.png 
Figure 3-33. Fast-forwarding your master branch to include the client branch changes.

Let’s say you decide to pull in your server branch as well. You can rebase the server branch onto the master branch without having to check it out first by running `git rebase [basebranch] [topicbranch]` — which checks out the topic branch (in this case, `server`) for you and replays it onto the base branch (`master`):

	$ git rebase master server

This replays your `server` work on top of your `master` work, as shown in Figure 3-34.

Insert 18333fig0334.png 
Figure 3-34. Rebasing your server branch on top of your master branch.

Then, you can fast-forward the base branch (`master`):

	$ git checkout master
	$ git merge server

You can remove the `client` and `server` branches because all the work is integrated and you don’t need them anymore, leaving your history for this entire process looking like Figure 3-35:

	$ git branch -d client
	$ git branch -d server

Insert 18333fig0335.png 
Figure 3-35. Final commit history.

### The Perils of Rebasing ###

Ahh, but the bliss of rebasing isn’t without its drawbacks, which can be summed up in a single line:

**Do not rebase commits that you have pushed to a public repository.**

If you follow that guideline, you’ll be fine. If you don’t, people will hate you, and you’ll be scorned by friends and family.

When you rebase stuff, you’re abandoning existing commits and creating new ones that are similar but different. If you push commits somewhere and others pull them down and base work on them, and then you rewrite those commits with `git rebase` and push them up again, your collaborators will have to re-merge their work and things will get messy when you try to pull their work back into yours.

Let’s look at an example of how rebasing work that you’ve made public can cause problems. Suppose you clone from a central server and then do some work off that. Your commit history looks like Figure 3-36.

Insert 18333fig0336.png 
Figure 3-36. Clone a repository, and base some work on it.

Now, someone else does more work that includes a merge, and pushes that work to the central server. You fetch them and merge the new remote branch into your work, making your history look something like Figure 3-37.

Insert 18333fig0337.png 
Figure 3-37. Fetch more commits, and merge them into your work.

Next, the person who pushed the merged work decides to go back and rebase their work instead; they do a `git push --force` to overwrite the history on the server. You then fetch from that server, bringing down the new commits.

Insert 18333fig0338.png 
Figure 3-38. Someone pushes rebased commits, abandoning commits you’ve based your work on.

At this point, you have to merge this work in again, even though you’ve already done so. Rebasing changes the SHA-1 hashes of these commits so to Git they look like new commits, when in fact you already have the C4 work in your history (see Figure 3-39).

Insert 18333fig0339.png 
Figure 3-39. You merge in the same work again into a new merge commit.

You have to merge that work in at some point so you can keep up with the other developer in the future. After you do that, your commit history will contain both the C4 and C4' commits, which have different SHA-1 hashes but introduce the same work and have the same commit message. If you run a `git log` when your history looks like this, you’ll see two commits that have the same author date and message, which will be confusing. Furthermore, if you push this history back up to the server, you’ll reintroduce all those rebased commits to the central server, which can further confuse people.

If you treat rebasing as a way to clean up and work with commits before you push them, and if you only rebase commits that have never been available publicly, then you’ll be fine. If you rebase commits that have already been pushed publicly, and people may have based work on those commits, then you may be in for some frustrating trouble.

## Summary ##

We’ve covered basic branching and merging in Git. You should feel comfortable creating and switching to new branches, switching between branches and merging local branches together.  You should also be able to share your branches by pushing them to a shared server, working with others on shared branches and rebasing your branches before they are shared.
