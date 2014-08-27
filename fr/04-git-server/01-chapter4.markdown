# Git sur le serveur #

À présent, vous devriez être capable de réaliser la plupart des tâches quotidiennes impliquant Git.
Néanmoins, pour pouvoir collaborer avec d'autres personnes au moyen de Git, vous allez devoir disposer d'un dépôt distant Git.
Bien que vous puissiez techniquement tirer et pousser des modifications depuis et vers des dépôts personnels, cette pratique est déconseillée parce qu'elle introduit très facilement une confusion avec votre travail actuel.
De plus, vous souhaitez que vos collaborateurs puissent accéder à votre dépôt de sources, y compris si vous n'êtes pas connecté — disposer d'un dépôt accessible en permanence peut s'avérer utile.
De ce fait, la méthode canonique pour collaborer consiste à instancier un dépôt intermédiaire auquel tous ont accès, que ce soit pour pousser ou tirer.
Nous nommerons ce dépôt le « serveur Git » mais vous vous apercevrez qu'héberger un serveur de dépôt Git ne consomme que peu de ressources et qu'en conséquence, on n'utilise que rarement une machine dédiée à cette tâche.

Un serveur Git est simple à lancer.
Premièrement, vous devez choisir quels protocoles seront supportés.
La première partie de ce chapitre traite des protocoles disponibles et de leurs avantages et inconvénients.
La partie suivante explique certaines configurations typiques avec ces protocoles et comment les mettre en œuvre.
Enfin, nous traiterons de quelques types d'hébergement, si vous souhaitez héberger votre code sur un serveur tiers, sans avoir à installer et maintenir un serveur par vous-même.

Si vous ne voyez pas d'intérêt à gérer votre propre serveur, vous pouvez sauter directement à la dernière partie de ce chapitre pour détailler les options pour mettre en place un compte hébergé, avant de continuer dans le chapitre suivant où les problématiques de développement distribué sont abordées.

Un dépôt distant est généralement un _dépôt nu_ (*bare repository*), un dépôt Git qui n'a pas de copie de travail.
Comme ce dépôt n'est utilisé que comme centralisateur de collaboration, il n'y a aucune raison d'extraire un instantané sur le disque ; seules les données Git sont nécessaires.
Pour simplifier, un dépôt nu est le contenu du répertoire `.git` sans fioriture.

## Protocoles ##

Git peut utiliser quatre protocoles réseau majeurs pour transporter des données : local, *Secure Shell* (SSH), Git et HTTP.
Nous allons voir leur nature et dans quelles circonstances ils peuvent (ou ne peuvent pas) être utilisés.

Il est à noter que mis à part HTTP, tous les protocoles nécessitent l'installation de Git sur le serveur.

### Protocole local ###

Le protocole de base est le protocole _local_ pour lequel le dépôt distant est un autre répertoire dans le système de fichiers.
Il est souvent utilisé si tous les membres de l'équipe ont accès à un répertoire partagé via NFS par exemple ou dans le cas moins probable où tous les développeurs travaillent sur le même ordinateur.
Ce dernier cas n'est pas optimum car tous les dépôts seraient hébergés de fait sur le même ordinateur, rendant ainsi toute défaillance catastrophique.

Si vous disposez d'un système de fichiers partagé, vous pouvez cloner, pousser et tirer avec un dépôt local.
Pour cloner un dépôt ou pour l'utiliser comme dépôt distant d'un projet existant, utilisez le chemin vers le dépôt comme URL.
Par exemple, pour cloner un dépôt local, vous pouvez lancer ceci :

	$ git clone /opt/git/projet.git

Ou bien cela :

	$ git clone file:///opt/git/projet.git

Git opère légèrement différemment si vous spécifiez explicitement le protocole `file://` au début de l'URL.
Si vous spécifiez simplement le chemin et si la destination se trouve sur le même système de fichiers, Git tente d'utiliser des liens physiques pour le fichiers communs.
Si la destination se trouve sur un autre système de fichiers, Git fait une copie des fichiers nécessaires.
Si vous spécifiez le protocole `file://`, Git lance un processus d'accès au travers du réseau, ce qui est généralement moins efficace.
La raison d'utiliser spécifiquement le préfixe `file://` est la volonté d'obtenir une copie propre du dépôt, sans aucune référence ou aucun objet supplémentaire qui pourraient résulter d'un import depuis un autre système de gestion de version ou d'une action similaire (voir chapitre 9 pour les tâches de maintenance).
Nous utiliserons les chemins normaux par la suite car c'est la méthode la plus efficace.

Pour ajouter un dépôt local à un projet Git existant, lancez ceci :

	$ git remote add proj_local /opt/git/projet.git

Ensuite, vous pouvez pousser vers et tirer depuis ce dépôt distant de la même manière que vous le feriez pour un dépôt accessible sur le réseau.

#### Avantages ####

Les avantages des dépôts accessibles sur le système de fichiers sont qu'ils sont simples et qu'ils utilisent les permissions du système de fichiers.
Si vous avez déjà un montage partagé auquel toute votre équipe a accès, déployer un dépôt est extrêmement facile.
Vous placez la copie du dépôt nu à un endroit accessible de tous et positionnez correctement les droits de lecture/écriture de la même manière que pour tout autre partage.
Nous aborderons la méthode pour exporter une copie de dépôt nu à cette fin dans la section suivante « Déployer Git sur un serveur ».

C'est un choix satisfaisant pour partager rapidement le travail.
Si vous et votre coéquipier travaillez sur le même projet et qu'il souhaite partager son travail, lancer une commande telle que `git pull /home/john/project` est certainement plus simple que de passer par un serveur intermédiaire.

#### Inconvénients ####

Les inconvénients de cette méthode sont qu'il est généralement plus difficile de rendre disponible un partage réseau depuis de nombreux endroits que de simplement gérer des accès réseau.
Si vous souhaitez pousser depuis votre portable à la maison, vous devez monter le partage distant, ce qui peut s'avérer plus difficile et plus lent que d'y accéder directement via un protocole réseau.

Il est aussi à mentionner que ce n'est pas nécessairement l'option la plus rapide à l'utilisation si un partage réseau est utilisé.
Un dépôt local n'est rapide que si l'accès aux fichiers est rapide.
Un dépôt accessible sur un montage NFS est souvent plus lent qu'un dépôt accessible via SSH sur le même serveur qui ferait tourner Git avec un accès aux disques locaux.

### Protocole SSH ###

Le protocole SSH est probablement le protocole de transport de Git le plus utilisé.
Cela est dû au fait que l'accès SSH est déjà en place à de nombreux endroits et que si ce n'est pas le cas, cela reste très facile à faire.
Cela est aussi dû au fait que SSH est le seul protocole permettant facilement de lire et d'écrire à distance.
Les deux autres protocoles réseau (HTTP et Git) sont généralement en lecture seule et s'ils peuvent être utiles pour la publication, le protocole SSH est nécessaire pour les mises à jour.
SSH est un protocole authentifié ; et comme il est très répandu, il est généralement facile à mettre en œuvre et à utiliser.

Pour cloner un dépôt Git à travers SSH, spécifiez le préfixe `ssh://` dans l'URL comme ceci :

	$ git clone ssh://utilisateur@serveur/projet.git

ou vous pouvez utiliser la syntaxe scp habituelle avec le protocole SSH :

	$ git clone utilisateur@serveur:projet.git

Vous pouvez aussi ne pas spécifier de nom d'utilisateur et Git utilisera par défaut le nom de login.

#### Avantages ####

Les avantages liés à l'utilisation de SSH sont nombreux.
Primo, vous ne pourrez pas faire autrement si vous souhaitez gérer un accès authentifié en écriture à votre dépôt à travers le réseau.
Secundo, SSH est relativement simple à mettre en place, les *daemons* SSH sont facilement disponibles, les administrateurs réseaux sont habitués à les gérer et de nombreuses distributions de systèmes d'exploitation en disposent ou proposent des outils pour les gérer.
Ensuite, l'accès distant à travers SSH est sécurisé, toutes les données sont chiffrées et authentifiées.
Enfin, comme les protocoles Git et local, SSH est efficace et permet de comprimer autant que possible les données avant de les transférer.

#### Inconvénients ####

Le point négatif avec SSH est qu'il est impossible de proposer un accès anonyme au dépôt.
Les accès sont régis par les permissions SSH, même pour un accès en lecture seule, ce qui s'oppose à une optique open source.
Si vous souhaitez utiliser Git dans un environnement d'entreprise, SSH peut bien être le seul protocole nécessaire.
Si vous souhaitez proposer de l'accès anonyme en lecture seule à vos projets, vous aurez besoin de SSH pour vous permettre de pousser mais un autre protocole sera nécessaire pour permettre à d'autres de tirer.

### Protocole Git ###

Vient ensuite le protocole Git. Celui-ci est géré par un *daemon* spécial livré avec Git. Ce *daemon* (démon, processus en arrière plan) écoute sur un port dédié (9418) et propose un service similaire au protocole SSH, mais sans aucune sécurisation.
Pour qu'un dépôt soit publié via le protocole Git, le fichier `git-daemon-export-ok` doit exister mais mise à part cette condition sans laquelle le *daemon* refuse de publier un projet, il n'y a aucune sécurité.
Soit le dépôt Git est disponible sans restriction en lecture, soit il n'est pas publié.
Cela signifie qu'il ne permet pas de pousser des modifications.
Vous pouvez activer la capacité à pousser mais étant donné l'absence d'authentification, n'importe qui sur Internet ayant trouvé l'URL du projet peut pousser sur le dépôt.
Autant dire que ce mode est rarement recherché.

#### Avantages ####

Le protocole Git est le protocole le plus rapide.
Si vous devez servir un gros trafic pour un projet public ou un très gros projet qui ne nécessite pas d'authentification en lecture, il est très probable que vous devriez installer un *daemon* Git.
Il utilise le même mécanisme de transfert de données que SSH, la surcharge du chiffrement et de l'authentification en moins.

#### Inconvénients ####

Le défaut du protocole Git est le manque d'authentification.
N'utiliser que le protocole Git pour accéder à un projet n'est généralement pas suffisant.
Il faut le coupler avec un accès SSH pour quelques développeurs qui auront le droit de pousser (écrire) et le garder pour un accès `git://` en lecture seule.
C'est aussi le protocole le plus difficile à mettre en place.
Il doit être géré par son propre *daemon* qui est spécifique.
Nous traiterons de cette installation dans la section « Gitosis » de ce chapitre — elle nécessite la configuration d'un *daemon* `xinetd` ou apparenté, ce qui est loin d'être simple.
Il nécessite aussi un accès à travers le pare-feu au port 9418 qui n'est pas un port ouvert en standard dans les pare-feux professionnels.
Derrière les gros pare-feux professionnels, ce port obscur est tout simplement bloqué.

### Protocole HTTP/S ###

Enfin, il reste le protocole HTTP.
La beauté d'HTTP ou HTTPS tient dans la simplicité à le mettre en place.
Tout ce qu'il y a à faire, c'est de simplement copier un dépôt Git nu sous votre racine de document HTTP et de paramétrer un crochet `post-update` et c'est prêt (voir chapitre 7 pour les détails sur les crochets de Git).
À partir de ceci, toute personne possédant un accès au serveur web sur lequel vous avez copié votre dépôt peut le cloner.
Pour autoriser un accès en lecture à votre dépôt sur HTTP, faites ceci :

	$ cd /var/www/htdocs/
	$ git clone --bare /chemin/vers/git_projet projetgit.git
	$ cd projetgit.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

C'est tout.
Le crochet `post-update` qui est livré avec Git par défaut lance la commande appropriée (`git update-server-info`) pour permettre un fonctionnement correct du clonage et de la récupération par HTTP.
Cette commande est lancée lorsque vous poussez vers ce dépôt par SSH ; ainsi, les autres personnes peuvent cloner via la commande :

	$ git clone http://exemple.com/projetgit.git

Dans ce cas particulier, nous utilisons le chemin `/var/www/htdocs` qui est commun pour les installations d'Apache, mais vous pouvez utiliser n'importe quel serveur web de pages statiques — il suffit de placer le dépôt nu dans le chemin d'accès.
Les données Git sont servies comme des simples fichiers statiques (voir chapitre 9 pour la manière détaillée dont ils sont servis).

Il est possible de faire pousser Git à travers HTTP, bien que cette technique ne soit pas utilisée et nécessite de gérer les exigences complexes de WebDAV.
Comme elle est rarement utilisée, nous ne la détaillerons pas dans ce livre.
Si vous êtes tout de même intéressé par l'utilisation des protocoles de push-HTTP, vous pouvez vous référer à `http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt`.
Un des intérêts à permettre de pousser par HTTP est que vous pouvez utiliser n'importe quel serveur WebDAV, sans liaison avec Git.
Il est donc possible d'utiliser cette fonctionnalité si votre fournisseur d'hébergement web supporte WebDAV pour la mise à jour de vos sites.

#### Avantages ####

L'avantage d'utiliser le protocole HTTP est qu'il est très simple à mettre en œuvre.
Donner un accès public en lecture à votre dépôt Git ne nécessite que quelques commandes.
Cela ne prend que quelques minutes.
De plus, le protocole HTTP n'est pas très demandeur en ressources système.
Les besoins étant limités à servir des données statiques, un serveur Apache standard peut servir des milliers de fichiers par seconde en moyenne et il est très difficile de surcharger même un ordinateur moyen.

Vous pouvez aussi publier votre dépôt par HTTPS, ce qui signifie que vous pouvez chiffrer le contenu transféré.
Vous pouvez même obliger les clients à utiliser des certificats SSL spécifiques.
Généralement, si vous souhaitez pousser jusque là, il est préférable de passer par des clés SSH publiques.
Cependant, certains cas nécessitent l'utilisation de certificats SSL signés ou d'autres méthodes d'authentification basées sur HTTP pour les accès en lecture seule sur HTTPS.

Un autre avantage indéniable de HTTP est que c'est un protocole si commun que les pare-feux d'entreprise sont souvent paramétrés pour le laisser passer.

#### Inconvénients ####

L'inconvénient majeur de servir votre dépôt sur HTTP est que c'est relativement inefficace pour le client.
Cela prend généralement beaucoup plus longtemps de cloner ou tirer depuis le dépôt et il en résulte un plus grand trafic réseau et de plus gros volumes de transfert que pour les autres protocoles.
Le protocole HTTP est souvent appelé le protocole _idiot_ parce qu'il n'a pas l'intelligence de sélectionner seulement les données nécessaires à transférer du fait du manque de traitement dynamique côté serveur.
Pour plus d'information sur les différences d'efficacité entre le protocole HTTP et les autres, référez-vous au chapitre 9.

## Installation de Git sur un serveur ##

Pour réaliser l'installation initiale d'un serveur Git, il faut exporter un dépôt existant dans un nouveau dépôt nu — un dépôt qui ne contient pas de copie de répertoire de travail.
C'est généralement simple à faire.
Pour cloner votre dépôt en créant un nouveau dépôt nu, lancez la commande clone avec l'option `--bare`.
Par convention, les répertoires de dépôt nu finissent en `.git`, de cette manière :

	$ git clone --bare mon_project mon_project.git
	Initialized empty Git repository in /opt/projets/mon_project.git/

La sortie de cette commande est un peu déroutante.
Comme `clone` est un `git init` de base, suivi d'un `git fetch`, nous voyons les messages du `git init` qui crée un répertoire vide.
Le transfert effectif d'objets ne fournit aucune sortie, mais il a tout de même lieu.
Vous devriez maintenant avoir une copie des données de Git dans votre répertoire `mon_project.git`.

C'est grossièrement équivalent à :

	$ cp -Rf mon_project/.git mon_project.git

Il y a quelques légères différences dans le fichier de configuration mais pour l'utilisation envisagée, c'est très proche.
La commande extrait le répertoire Git sans répertoire de travail et crée un répertoire spécifique pour l'accueillir.

### Copie du dépôt nu sur un serveur ###

À présent que vous avez une copie nue de votre dépôt, il ne reste plus qu'à la placer sur un serveur et à régler les protocoles.
Supposons que vous avez mis en place un serveur nommé `git.exemple.com` auquel vous avez accès par SSH et que vous souhaitez stocker vos dépôts Git dans le répertoire `/opt/git`.
Vous pouvez mettre en place votre dépôt en copiant le dépôt nu :

	$ scp -r mon_projet.git utilisateur@git.exemple.com:/opt/git

À partir de maintenant, tous les autres utilisateurs disposant d'un accès SSH au serveur et ayant un accès en lecture seule au répertoire `/opt/git` peuvent cloner votre dépôt en lançant la commande :

	$ git clone utilisateur@git.exemple.com:/opt/git/mon_projet.git

Si un utilisateur se connecte par SSH au serveur et a accès en lecture au répertoire `/opt/git/mon_projet.git`, il aura automatiquement accès pour tirer.
Git ajoutera automatiquement les droits de groupe en écriture à un dépôt si vous lancez la commande `git init` avec l'option `--shared`.

	$ ssh utilisateur@git.exemple.com
	$ cd /opt/git/mon_projet.git
	$ git init --bare --shared

Vous voyez comme il est simple de prendre un dépôt Git, créer une version nue et la placer sur un serveur auquel vous et vos collaborateurs avez accès en SSH.
Vous voilà prêts à collaborer sur le même projet.

Il faut noter que c'est littéralement tout ce dont vous avez besoin pour démarrer un serveur Git utile auquel plusieurs personnes ont accès — ajoutez des comptes SSH sur un serveur, et collez un dépôt nu quelque part où tous les utilisateurs ont accès en lecture et écriture.
Vous êtes prêts à travailler, vous n'avez besoin de rien d'autre.

Dans les chapitres à venir, nous traiterons de mises en place plus sophistiquées.
Ces sujets incluront l'élimination du besoin de créer un compte système pour chaque utilisateur, l'accès public aux dépôts, la mise en place d'interfaces utilisateur web, l'utilisation de l'outil Gitosis, etc.
Néanmoins, gardez à l'esprit que pour collaborer avec quelques personnes sur un projet privé, tout ce qu'il faut, c'est un serveur SSH et un dépôt nu.

### Petites installations ###

Si vous travaillez dans un petit groupe ou si vous n'êtes qu'en phase d'essai de Git au sein de votre société avec peu de développeurs, les choses peuvent rester simples.
Un des aspects les plus compliqués de la mise en place d'un serveur Git est la gestion des utilisateurs.
Si vous souhaitez que certains dépôts ne soient accessibles à certains utilisateurs qu'en lecture seule et en lecture/écriture pour d'autres, la gestion des accès et des permissions peut devenir difficile à régler.


#### Accès SSH ####

Si vous disposez déjà d'un serveur auquel tous vos développeurs ont un accès SSH, il est généralement plus facile d'y mettre en place votre premier dépôt car vous n'aurez quasiment aucun réglage supplémentaire à faire (comme nous l'avons expliqué dans le chapitre précédent).
Si vous souhaitez des permissions d'accès plus complexes, vous pouvez les mettre en place par le jeu des permissions standards sur le système de fichiers du système d'exploitation de votre serveur.

Si vous souhaitez placer vos dépôts sur un serveur qui ne dispose pas déjà de comptes pour chacun des membres de votre équipe qui aurait accès en écriture, alors vous devrez mettre en place un accès SSH pour eux.
En supposant que pour vos dépôts, vous disposiez déjà d'un serveur SSH installé et sur lequel vous avez accès.

Il y a quelques moyens de donner un accès à tout le monde dans l'équipe.
Le premier est de créer des comptes pour tout le monde, ce qui est logique mais peut s'avérer lourd.
Vous ne souhaiteriez sûrement pas lancer `adduser` et entrer un mot de passe temporaire pour chaque utilisateur.

Une seconde méthode consiste à créer un seul utilisateur Git sur la machine, demander à chaque développeur nécessitant un accès en écriture de vous envoyer une clé publique SSH et d'ajouter la-dite clé au fichier `~/.ssh/authorized_keys` de votre utilisateur Git.
À partir de là, tout le monde sera capable d'accéder à la machine via l'utilisateur Git.
Cela n'affecte en rien les données de *commit* — les informations de l'utilisateur SSH par lequel on se connecte n'affectent pas les données de *commit* enregistrées.

Une dernière méthode consiste à faire une authentification SSH auprès d'un serveur LDAP ou tout autre système d'authentification centralisé que vous utiliseriez déjà.
Tant que chaque utilisateur peut accéder à un shell sur la machine, n'importe quel schéma d'authentification SSH devrait fonctionner.

## Génération des clés publiques SSH ##

Cela dit, de nombreux serveurs Git utilisent une authentification par clés publiques SSH.
Pour fournir une clé publique, chaque utilisateur de votre système doit la générer s'il n'en a pas déjà.
Le processus est similaire sur tous les systèmes d'exploitation.
Premièrement, l'utilisateur doit vérifier qu'il n'en a pas déjà une.
Par défaut, les clés SSH d'un utilisateur sont stockées dans le répertoire `~/.ssh` du compte.
Vous pouvez facilement vérifier si vous avez déjà une clé en listant le contenu de ce répertoire :

	$ cd ~/.ssh
	$ ls
	authorized_keys2  id_dsa       known_hosts
	config            id_dsa.pub

Recherchez une paire de fichiers appelés *quelquechose* et *quelquechose*`.pub` où le *quelquechose* en question est généralement `id_dsa` ou `id_rsa`.
Le fichier en `.pub` est la clé publique tandis que l'autre est la clé privée.
Si vous ne voyez pas ces fichiers (ou n'avez même pas de répertoire `.ssh`), vous pouvez les créer en lançant un programme appelé `ssh-keygen` fourni par le paquet SSH sur les systèmes Linux/Mac et MSysGit pour Windows :

	$ ssh-keygen
	Generating public/private rsa key pair.
	Enter file in which to save the key (/Users/schacon/.ssh/id_rsa):
	Enter passphrase (empty for no passphrase):
	Enter same passphrase again:
	Your identification has been saved in /Users/schacon/.ssh/id_rsa.
	Your public key has been saved in /Users/schacon/.ssh/id_rsa.pub.
	The key fingerprint is:
	43:c5:5b:5f:b1:f1:50:43:ad:20:a6:92:6a:1f:9a:3a schacon@agadorlaptop.local


Premièrement, le programme demande confirmation pour l'endroit où vous souhaitez sauvegarder la clé (`.ssh/id_rsa`) puis il demande deux fois d'entrer un mot de passe qui peut être laissé vide si vous ne souhaitez pas devoir taper un mot de passe quand vous utilisez la clé.

Maintenant, chaque utilisateur ayant suivi ces indications doit envoyer la clé publique à la personne en charge de l'administration du serveur Git (en supposant que vous utilisez un serveur SSH réglé pour l'utilisation de clés publiques).
Ils doivent copier le contenu du fichier .pub et l'envoyer par e-mail.
Les clés publiques ressemblent à ceci :

	$ cat ~/.ssh/id_rsa.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU
	GPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3
	Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XA
	t3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/En
	mZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbx
	NrRFi9wrf+M7Q== schacon@agadorlaptop.local

Pour un tutoriel plus approfondi sur la création de clé SSH sur différents systèmes d'exploitation, référez-vous au guide GitHub sur les clés SSH à `http://github.com/guides/providing-your-ssh-key`.

## Mise en place du serveur ##

Parcourons les étapes de la mise en place d'un accès SSH côté serveur.
Dans cet exemple, vous utiliserez la méthode des `authorized_keys` pour authentifier vos utilisateurs.
Nous supposerons également que vous utilisez une distribution Linux standard telle qu'Ubuntu.
Premièrement, créez un utilisateur 'git' et un répertoire `.ssh` pour cet utilisateur.

	$ sudo adduser git
	$ su git
	$ cd
	$ mkdir .ssh

Ensuite, vous devez ajouter la clé publique d'un développeur au fichier `authorized_keys` de l'utilisateur Git.
Supposons que vous avez reçu quelques clés par e-mail et les avez sauvées dans des fichiers temporaires.
Pour rappel, une clé publique ressemble à ceci :

	$ cat /tmp/id_rsa.john.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCB007n/ww+ouN4gSLKssMxXnBOvf9LGt4L
	ojG6rs6hPB09j9R/T17/x4lhJA0F3FR1rP6kYBRsWj2aThGw6HXLm9/5zytK6Ztg3RPKK+4k
	Yjh6541NYsnEAZuXz0jTTyAUfrtU3Z5E003C4oxOj6H0rfIF1kKI9MAQLMdpGW1GYEIgS9Ez
	Sdfd8AcCIicTDWbqLAcU4UpkaX8KyGlLwsNuuGztobF8m72ALC/nLF6JLtPofwFBlgc+myiv
	O7TCUSBdLQlgMVOFq1I2uPWQOkOWQAHukEOmfjy2jctxSDBQ220ymjaNsHT4kgtZg2AYYgPq
	dAv8JggJICUvax2T9va5 gsg-keypair

Il suffit de les ajouter au fichier `authorized_keys` :

	$ cat /tmp/id_rsa.john.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.josie.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.jessica.pub >> ~/.ssh/authorized_keys


Maintenant, vous pouvez créer un dépôt vide nu en lançant la commande `git init` avec l'option `--bare`, ce qui initialise un dépôt sans répertoire de travail :

	$ cd /opt/git
	$ mkdir projet.git
	$ cd projet.git
	$ git --bare init

Alors, John, Josie ou Jessica peuvent pousser la première version de leur projet vers ce dépôt en l'ajoutant en tant que dépôt distant et en lui poussant une branche.
Notons que quelqu'un doit se connecter au serveur et créer un dépôt nu pour chaque ajout de projet.
Supposons que le nom du serveur soit `gitserveur`.
Si vous l'hébergez en interne et avez réglé le DNS pour faire pointer `gitserver` sur ce serveur, alors vous pouvez utiliser les commandes suivantes telles quelles :

	# Sur l'ordinateur de John
	$ cd monproject
	$ git init
	$ git add .
	$ git commit -m 'premiere validation'
	$ git remote add origin git@gitserveur:/opt/git/projet.git
	$ git push origin master

À présent, les autres utilisateurs peuvent cloner le dépôt et y pousser leurs modifications aussi simplement :

	$ git clone git@gitserveur:/opt/git/projet.git
	$ cd projet
	$ vim LISEZMOI
	$ git commit -am 'correction fichier LISEZMOI'
	$ git push origin master

De cette manière, vous pouvez rapidement mettre en place un serveur Git en lecture/écriture pour une poignée de développeurs.

En précaution supplémentaire, vous pouvez simplement restreindre l'utilisateur 'git' à des actions Git avec un shell limité appelé `git-shell` qui est fourni avec Git.
Si vous positionnez ce shell comme shell de login de l'utilisateur 'git', l'utilisateur 'git' ne peut pas avoir de shell normal sur ce serveur.
Pour utiliser cette fonction, spécifiez `git-shell` en lieu et place de bash ou csh pour shell de l'utilisateur.
Cela se réalise généralement en éditant le fichier `/etc/passwd` :

	$ sudo vim /etc/passwd

Tout au bas, vous devriez trouver une ligne qui ressemble à ceci :

	git:x:1000:1000::/home/git:/bin/sh

Modifiez `/bin/sh` en `/usr/bin/git-shell` (ou le résultat de la commande `which git-shell` qui indique où il est installé).
La ligne devrait maintenant ressembler à ceci :

	git:x:1000:1000::/home/git:/usr/bin/git-shell

À présent, l'utilisateur 'git' ne peut plus utiliser la connexion SSH que pour pousser et tirer sur des dépôts Git, il ne peut plus ouvrir un shell.
Si vous essayez, vous verrez un rejet de login :

	$ ssh git@gitserveur
	fatal: What do you think I am? A shell?
	Connection to gitserveur closed.

## Accès public ##

Et si vous voulez permettre des accès anonymes en lecture ?
Peut-être souhaitez-vous héberger un projet open source au lieu d'un projet interne privé.
Ou peut-être avez-vous quelques serveurs de compilation ou d'intégration continue qui changent souvent et vous ne souhaitez pas avoir à regénérer des clés SSH tout le temps — vous avez besoin d'un accès en lecture seule simple.

Le moyen le plus simple pour des petites installations est probablement d'installer un serveur web statique dont la racine pointe sur vos dépôts Git puis d'activer le crochet `post-update` mentionné à la première partie de ce chapitre.
Reprenons l'exemple précédent.
Supposons que vos dépôts soient dans le répertoire `/opt/git` et qu'un serveur Apache soit installé sur la machine.
Vous pouvez bien sûr utiliser n'importe quel serveur web mais nous utiliserons Apache pour montrer la configuration nécessaire.

Premièrement, il faut activer le crochet :

	$ cd projet.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

Quelle est l'action de ce crochet `post-update` ?
Il contient simplement ceci :

	$ cat .git/hooks/post-update
	#!/bin/sh
	exec git-update-server-info

Cela signifie que lorsque vous poussez vers le serveur via SSH, Git lance cette commande pour mettre à jour les fichiers nécessaires lorsqu'on tire par HTTP.

Ensuite, il faut ajouter dans la configuration Apache une entrée VirtualHost dont la racine pointe sur vos dépôts Git.
Ici, nous supposerons que vous avez réglé un DNS avec résolution générique qui renvoit `*.gitserveur` vers la machine qui héberge ce système :

	<VirtualHost *:80>
	    ServerName git.gitserveur
	    DocumentRoot /opt/git
	    <Directory /opt/git/>
	        Order allow, deny
	        allow from all
	    </Directory>
	</VirtualHost>

Vous devrez aussi positionner le groupe d'utilisateurs Unix du répertoire `/opt/git` à `www-data` de manière à ce que le serveur web puisse avoir accès en lecture seule aux répertoires si le serveur Apache lance le script CGI avec cet utilisateur (par défaut) :

	$ chgrp -R www-data /opt/git

Après avoir redémarré Apache, vous devriez être capable de cloner vos dépôts en spécifiant l'URL de votre projet :

	$ git clone http://git.gitserveur/projet.git

Ainsi, vous pouvez donner accès en lecture seule à tous vos projets à un grand nombre d'utilisateurs en quelques minutes.
Une autre option simple pour fournir un accès public non-authentifié consiste à lancer un *daemon* Git, bien que cela requière de démoniser le processus — nous traiterons cette option dans un chapitre ultérieur si vous préférez cette option.

## GitWeb ##

Après avoir réglé les accès de base en lecture/écriture et en lecture seule pour vos projets, vous souhaiterez peut-être mettre en place une interface web simple de visualisation.
Git fournit un script CGI appelé GitWeb qui est souvent utilisé à cette fin.
Vous pouvez voir GitWeb en action sur des sites tels que `http://git.kernel.org` (voir figure 4-1).

Insert 18333fig0401.png
Figure 4-1. L'interface web de visualisation GitWeb.

Si vous souhaitez vérifier à quoi GitWeb ressemblerait pour votre projet, Git fournit une commande pour démarrer une instance temporaire de serveur si vous avez un serveur léger tel que `lighttpd` ou `webrick` sur votre système.
Sur les machines Linux, `lighttpd` est souvent pré-installé et vous devriez pouvoir le démarrer en tapant `git instaweb` dans votre répertoire de travail.
Si vous utilisez un Mac, Ruby est installé de base avec Léopard, donc `webrick` est une meilleure option.
Pour démarrer `instaweb` avec un gestionnaire autre que lighttpd, vous pouvez le lancer avec l'option `--httpd`.

	$ git instaweb --httpd=webrick
	[2009-02-21 10:02:21] INFO  WEBrick 1.3.1
	[2009-02-21 10:02:21] INFO  ruby 1.8.6 (2008-03-03) [universal-darwin9.0]

Cette commande démarre un serveur HTTP sur le port 1234 et lance automatique un navigateur Internet qui ouvre la page d'accueil.
C'est vraiment très simple.
Pour arrêter le serveur, il suffit de lancer la même commande, mais avec l'option `--stop` :

	$ git instaweb --httpd=webrick --stop

Si vous souhaitez fournir l'interface web en permanence sur le serveur pour votre équipe ou pour un projet opensource que vous hébergez, il sera nécessaire d'installer le script CGI pour qu'il soit appelé par votre serveur web.
Quelques distributions Linux ont un package `gitweb` qu'il suffira d'installer via `apt` ou `yum`, ce qui est une possibilité.
Nous détaillerons tout de même rapidement l'installation manuelle de GitWeb.
Premièrement, le code source de Git qui fournit GitWeb est nécessaire pour pouvoir générer un script CGI personnalisé :

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/
	$ make GITWEB_PROJECTROOT="/opt/git" \
	        prefix=/usr gitweb
	$ sudo cp -Rf gitweb /var/www/

Notez que vous devez indiquer où trouver les dépôts Git au moyen de la variable `GITWEB_PROJECTROOT`.
Maintenant, il faut paramétrer dans Apache l'utilisation de CGI pour ce script, en spécifiant un nouveau VirtualHost :

	<VirtualHost *:80>
	    ServerName gitserveur
	    DocumentRoot /var/www/gitweb
	    <Directory /var/www/gitweb>
	        Options ExecCGI +FollowSymLinks +SymLinksIfOwnerMatch
	        AllowOverride All
	        order allow,deny
	        Allow from all
	        AddHandler cgi-script cgi
	        DirectoryIndex gitweb.cgi
	    </Directory>
	</VirtualHost>

Une fois de plus, GitWeb peut être géré par tout serveur web capable de prendre en charge CGI.
La mise en place ne devrait pas être plus difficile avec un autre serveur.
Après redémarrage du serveur, vous devriez être capable de visiter `http://gitserveur/` pour visualiser vos dépôts en ligne et de cloner et tirer depuis ces dépôts par HTTP sur `http://git.gitserveur`.

## Gitosis ##

Conserver les clés publiques de tous les utilisateurs dans le fichier `authorized_keys` n'est satisfaisant qu'un temps.
Avec des centaines d'utilisateurs, la gestion devient compliquée.
À chaque fois, il faut se connecter au serveur et il n'y a aucun contrôle d'accès — toute personne avec une clé dans le fichier a accès en lecture et écriture à tous les projets.

Il est temps de se tourner vers un logiciel largement utilisé appelé Gitosis.
Gitosis est une collection de scripts qui aident à gérer le fichier `authorized_keys` ainsi qu'à implémenter des contrôles d'accès simples.
La partie la plus intéressante de l'outil est que l'interface d'administration permettant d'ajouter des utilisateurs et de déterminer leurs droits n'est pas une interface web mais un dépôt Git spécial.
Vous paramétrez les informations dans ce projet et lorsque vous le poussez, Gitosis reconfigure les serveurs en fonction des données, ce qui est cool.

L'installation de Gitosis n'est pas des plus aisées.
Elle est plus simple sur un serveur Linux — les exemples qui suivent utilisent une distribution Ubuntu Server 8.10 de base.

Gitosis nécessite des outils Python.
Il faut donc installer le paquet Python setuptools qu'Ubuntu fournit en tant que python-setuptools :

	$ apt-get install python-setuptools

Ensuite, il faut cloner et installer Gitosis à partir du site principal du projet :

	$ git clone https://github.com/tv42/gitosis.git
	$ cd gitosis
	$ sudo python setup.py install

La dernière commande installe deux exécutables que Gitosis utilisera.
Ensuite, Gitosis veut gérer ses dépôts sous `/home/git`, ce qui est parfait.
Mais vous avez déjà installé vos dépôts sous `/opt/git`, donc au lieu de tout reconfigurer, créez un lien symbolique :

	$ ln -s /opt/git /home/git/repositories

Comme Gitosis gèrera vos clés pour vous, il faut effacer le fichier `authorized_keys`, réintroduire les clés plus tard, et laisser Gitosis contrôler le fichier automatiquement.
Pour l'instant, déplacez le fichier `authorized_keys` ailleurs :

	$ mv /home/git/.ssh/authorized_keys /home/git/.ssh/ak.bak

Ensuite, il faut réactiver le shell pour l'utilisateur « git » si vous l'avez désactivé au moyen de `git-shell`.
Les utilisateurs ne pourront toujours pas se connecter car Gitosis contrôlera cet accès.
Modifions la ligne dans le fichier `/etc/passwd` :

	git:x:1000:1000::/home/git:/usr/bin/git-shell

pour la version d'origine :

	git:x:1000:1000::/home/git:/bin/sh

Vous pouvez maintenant initialiser Gitosis en lançant la commande `gitosis-init` avec votre clé publique.
Si votre clé publique n'est pas présente sur le serveur, il faut l'y télécharger :

	$ sudo -H -u git gitosis-init < /tmp/id_dsa.pub
	Initialized empty Git repository in /opt/git/gitosis-admin.git/
	Reinitialized existing Git repository in /opt/git/gitosis-admin.git/

Cela permet à l'utilisateur disposant de cette clé de modifier le dépôt Git qui contrôle le paramétrage de Gitosis.
Ensuite, il faudra positionner manuellement le bit « execute » du script `post-update` du dépôt de contrôle nouvellement créé.

	$ sudo chmod 755 /opt/git/gitosis-admin.git/hooks/post-update

Vous voilà prêt.
Si tout est réglé correctement, vous pouvez essayer de vous connecter par SSH au serveur en tant que l'utilisateur pour lequel vous avez ajouté la clé publique lors de l'initialisation de Gitosis.
Vous devriez voir quelque chose comme :

	$ ssh git@gitserveur
	PTY allocation request failed on channel 0
	fatal: unrecognized command 'gitosis-serve schacon@quaternion'
	  Connection to gitserveur closed.

Cela signifie que Gitosis vous a bien reconnu mais vous a rejeté car vous ne lancez pas de commandes Git.
Lançons donc une vraie commande Git en clonant le dépôt de contrôle Gitosis :

	# sur votre ordinateur local
	$ git clone git@gitserveur:gitosis-admin.git

Vous avez à présent un répertoire `gitosis-admin` qui contient deux entrées :

	$ cd gitosis-admin
	$ find .
	./gitosis.conf
	./keydir
	./keydir/scott.pub

Le fichier `gitosis.conf` est le fichier de configuration qui permet de spécifier les utilisateurs, les dépôts et les permissions.
Le répertoire `keydir` stocke les clés publiques de tous les utilisateurs qui peuvent avoir un accès à vos dépôts — un fichier par utilisateur.
Le nom du fichier dans `keydir` (dans l'exemple précédent, `scott.pub`) sera différent pour vous — Gitosis utilise le nom issu de la description à la fin de la clé publique qui a été importée par le script `gitosis-init`.

Le fichier `gitosis.conf` contient la configuration du projet `gitosis-admin` cloné à l'instant :

	$ cat gitosis.conf
	[gitosis]

	[group gitosis-admin]
	writable = gitosis-admin
	members = scott

Il indique que l'utilisateur « scott » — l'utilisateur dont la clé publique a servi à initialiser Gitosis — est le seul à avoir accès au projet `gitosis-admin`.

À présent, ajoutons un nouveau projet.
Ajoutons une nouvelle section appelée `mobile` où vous listez les développeurs de votre équipe mobile et les projets auxquels ces développeurs ont accès.
Comme « scott » est le seul utilisateur déclaré pour l'instant, vous devrez l'ajouter comme membre unique et vous créerez un nouveau projet appelé `iphone_projet` pour commencer :

	[group mobile]
	writable = iphone_projet
	members = scott

À chaque modification du projet `gitosis-admin`, il est nécessaire de valider les changements et de les pousser sur le serveur pour qu'ils prennent effet :

	$ git commit -am 'ajout iphone_projet et groupe mobile'
	[master]: created 8962da8: "changed name"
	 1 files changed, 4 insertions(+), 0 deletions(-)
	$ git push
	Counting objects: 5, done.
	Compressing objects: 100% (2/2), done.
	Writing objects: 100% (3/3), 272 bytes, done.
	Total 3 (delta 1), reused 0 (delta 0)
	To git@gitserver:/opt/git/gitosis-admin.git
	   fb27aec..8962da8  master -> master

Vous pouvez pousser vers le nouveau `iphone_projet` en ajoutant votre serveur comme dépôt distant dans votre dépôt local de projet et en poussant.
Vous n'avez plus besoin de créer manuellement un dépôt nu sur le serveur pour les nouveaux projets.
Gitosis les crée automatiquement dès qu'il voit la première poussée :

	$ git remote add origin git@gitserveur:iphone_projet.git
	$ git push origin master
	Initialized empty Git repository in /opt/git/iphone_projet.git/
	Counting objects: 3, done.
	Writing objects: 100% (3/3), 230 bytes, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:iphone_project.git
	 * [new branch]      master -> master

Notez qu'il est inutile de spécifier le chemin distant (en fait, c'est interdit), juste deux points et le nom du projet.
Gitosis gère les chemins.

Souhaitant travailler sur ce projet avec vos amis, vous devrez rajouter leurs clés publiques.
Plutôt que de les accoler manuellement au fichier `~/.ssh/authorized_keys` de votre serveur, il faut les ajouter, une clé par fichier, dans le répertoire `keydir`.
Le nom de fichier détermine le nom de l'utilisateur dans le fichier `gitosis.conf`.
Rajoutons les clés publiques de John, Josie et Jessica :

	$ cp /tmp/id_rsa.john.pub keydir/john.pub
	$ cp /tmp/id_rsa.josie.pub keydir/josie.pub
	$ cp /tmp/id_rsa.jessica.pub keydir/jessica.pub

Vous pouvez maintenant les ajouter tous à votre équipe `mobile` pour qu'ils aient accès en lecture/écriture à `iphone_projet` :

	[group mobile]
	writable = iphone_project
	members = scott john josie jessica

Après validation et poussée vers le serveur, les quatre utilisateurs sont admis à lire et écrire sur ce projet.

Gitosis fournit aussi des permissions simples.
Si vous souhaitez que John n'ait qu'un accès en lecture à ce projet, vous pouvez configurer ceci plutôt :

	[group mobile]
	writable = iphone_projet
	members = scott josie jessica

	[group mobile_ro]
	readonly = iphone_projet
	members = john

À présent, John peut cloner le projet et récupérer les mises à jour, mais Gitosis lui refusera de pousser sur ce projet.
Vous pouvez créer autant que groupes que vous désirez contenant des utilisateurs et projets différents.
Vous pouvez aussi spécifier un autre groupe comme membre du groupe (avec le préfixe `@`) pour faire hériter ses membres automatiquement :

	[group mobile_committers]
	members = scott josie jessica

	[group mobile]
	writable  = iphone_projet
	members   = @mobile_committers

	[group mobile_2]
	writable  = autre_iphone_projet
	members   = @mobile_committers john

Si vous rencontrez des problèmes, il peut être utile d'ajouter `loglevel=DEBUG` sous la section `[gitosis]`.
Si vous avez perdu le droit de pousser en envoyant une configuration vérolée, vous pouvez toujours réparer le fichier `/home/git/.gitosis.conf` sur le serveur — le fichier dans lequel Gitosis lit sa configuration.
Pousser sur le projet `gitosis-admin` provoque la recopie du fichier `gitosis.conf` à cet endroit.
Si vous éditez ce fichier à la main, il restera dans cet état jusqu'à la prochaine poussée.

## Gitolite ##

Cette section constitue une introduction à Gitolite et fournit des instructions de base pour son installation et sa mise en œuvre.
Elle ne peut pas cependant se substituer à l'importante quantité de [documentation][gldpg] fournie avec Gitolite.
Il se peut qu'elle subisse aussi occasionnellement quelques corrections qui sont disponibles [ici][gltoc].

[gldpg]: http://sitaramc.github.com/gitolite/progit.html
[gltoc]: http://sitaramc.github.com/gitolite/master-toc.html

Gitolite est une couche de gestion d'accès posée au dessus de Git, reposant sur `sshd` et `httpd` pour l'authentification.
L'authentification consiste à identifier l'utilisateur, la gestion d'accès permet de décider si celui-ci est autorisé à accomplir ce qu'il s'apprête à faire.

### Installation ###

L'installation de Gitolite est très simple, même sans lire la documentation extensive qui l'accompagne.
Vous n'avez besoin que d'un compte sur un serveur de type Unix.
Vous n'avez pas besoin d'accès root si Git, Perl et un serveur compatible OpenSSH sont déjà installés.
Dans les exemples qui suivent, un compte `git` sur un serveur `gitserver` sera utilisé.

Pour commencer, créez un utilisateur nommé `git` et loggez-vous avec cet utilisateur.
Copiez votre clé publique SSH depuis votre station de travail en la renommant `<votrenom>.pub` (nous utiliserons `scott.pub` pour l'exemple de cette section).
Ensuite, lancez les commandes ci-dessous :

	$ git clone git://github.com/sitaramc/gitolite
	$ gitolite/install -ln
	  # suppose que $HOME/bin existe et apparaît dans $PATH
	$ gitolite setup -pk $HOME/scott.pub

Cette dernière commande crée un nouveau dépôt Git appelé `gitolite-admin` sur le serveur.

Enfin, de retour sur la station de travail, lancez `git clone git@gitserver:gitolite-admin`.
C'est fini !
Gitolite est à présent installé sur le serveur ainsi qu'un nouveau dépôt appelé `gitolite-admin` qui a été cloné sur la station de travail.
L'administration de Gitolite passe par des modifications dans ce dépôt suivies d'une poussée sur le serveur.


### Personnalisation de l'installation ###

L'installation rapide par défaut suffit à la majorité des besoins, mais il existe des moyens de la paramétrer plus finement.
Ces modifications sont réalisées en éditant le fichier « rc » utilisé par le serveur, mais si cela ne s'avère pas suffisant, il existe plus d'information dans la documentation sur la personnalisation de Gitolite.

### Fichier de configuration et règles de contrôle d'accès ###

Une fois l'installation terminée, vous pouvez basculer vers le clone `gitolite-admin` présent sur votre station de travail et inspecter ce qui s'y trouve :

	$ cd ~/gitolite-admin/
	$ ls
	conf/  keydir/
	$ find conf keydir -type f
	conf/gitolite.conf
	keydir/scott.pub
	$ cat conf/gitolite.conf

	repo gitolite-admin
	    RW+                 = scott

	repo testing
	    RW+                 = @all

Notez que « scott » (le nom de la clé publique pour la commande `gl-setup` ci-dessus) détient les permissions en lecture/écriture sur le dépôt `gitolite-admin` ainsi qu'une clé publique du même nom.

L'ajout d'utilisateurs est simple.
Pour ajouter une utilisatrice appelée « alice », demandez-lui de vous fournir une clé publique SSH, renommez-la `alice.pub`, et placez-la dans le répertoire `keydir` du clone du dépôt `gitolite-admin` sur la station de travail.
Validez le fichier dans le dépôt et poussez les modifications sur le serveur.
L'utilisatrice « alice » vient d'être ajoutée.

Le fichier de configuration est richement commenté et nous n'allons donc mentionner ici que quelques points principaux.

Pour vous simplifier la tâche, vous pouvez grouper les utilisateurs et les dépôts.
Les noms de groupes sont juste comme des macros.
À leur définition, il importe peu que ce soient des projets ou des utilisateurs.
Cette distinction ne sert que lors de *l'utilisation* de la « macro ».

	@oss_repos      = linux perl rakudo git gitolite
	@secret_repos   = fenestra pear

	@admins         = scott
	@interns        = ashok
	@engineers      = sitaram dilbert wally alice
	@staff          = @admins @engineers @interns

Vous pouvez contrôler les permissions au niveau « ref ».
Dans l'exemple suivant, les stagiaires (intern) ne peuvent pousser que sur la branche « int ».
Les ingénieurs peuvent pousser toutes les branches dont le nom commence par « eng » et les étiquettes qui commencent par « rc » suivi d'un chiffre.
Les administrateurs ont tous les droits (y compris le rembobinage) sur toutes les `refs`.

	repo @oss_repos
	    RW  int$                = @interns
	    RW  eng-                = @engineers
	    RW  refs/tags/rc[0-9]   = @engineers
	    RW+                     = @admins

L'expression après les `RW` ou les `RW+` est une expression rationnelle (*regular expression* ou regex) qui filtre le nom de la référence (`ref`).
Elle s'appelle donc une « refex » !
Bien entendu, une « refex » peut être bien plus puissante que celles montrées ci-dessus et il est inutile de trop chercher si vous n'êtes pas à l'aise avec les regex Perl.

De plus, logiquement, Gitolite préfixe les refex qui ne commencent pas par `refs/` avec la chaîne `refs/heads/`.

Une autre particularité importante de la syntaxe du fichier de configuration est que toutes les règles ne sont pas nécessairement à un seul endroit.
On peut conserver toute la configuration commune, telle que l'ensemble des règles pour tous les dépôts `oss_repo` ci-dessus au début puis ajouter des règles spécifiques plus loin, comme :

	repo gitolite
	    RW+                     = sitaram

Cette règle sera juste ajoutée à l'ensemble des règles préexistantes du dépôt `gitolite`.

Du coup, il est nécessaire d'expliciter la politique d'application des règles de contrôle d'accès.

Il existe deux niveaux de contrôle d'accès dans Gitolite.
Le premier réside au niveau du dépôt.
Si vous avez un droit d'accès en lecture (resp. en écriture) à *n'importe quelle* `ref` du dépôt, alors vous avez accès en lecture (resp. en écriture) au dépôt.

Le second niveau, applicable seulement pour l'accès en écriture, se focalise sur les branches et les étiquettes dans un dépôt.
L'utilisateur, le type d'accès en cours (`W` ou `+`) et le nom de la référence permettent de définir les critères.
Les règles d'accès sont vérifiées par ordre d'apparition dans le fichier de configuration, par recherche d'une correspondance sur cette combinaison (en se souvenant que la correspondance de référence est une refex, non une simple comparaison).
Si une correspondance est trouvée, l'accès en poussée est accepté.
Si aucune correspondance n'est trouvée, l'accès est refusé.

### Contrôle d'accès avancé avec les règles « deny » ###

Jusqu'ici, les seuls types de permissions rencontrés ont été `R`, `RW` ou `RW+`.
Néanmoins, Gitolite connaît une autre permission : `-` qui signifie « deny », accès refusé.
Cela vous donne bien plus de possibilités, au prix d'une complexité accrue car à présent l'absence de correspondance n'est plus la *seule* manière de refuser l'accès, mais il devient nécessaire de faire attention à l'ordre des règles !

Supposons que dans la situation ci-dessus, nous souhaitons que les ingénieurs soient capables de rembobiner n'importe quelle branche *excepté* master et integ.
Voici comment faire :

	    RW  master integ    = @engineers
	    -   master integ    = @engineers
	    RW+                 = @engineers

Une fois encore, il suffit de suivre simplement les règles de haut en bas jusqu'à rencontrer une correspondance pour votre mode d'accès ou de refus.
Les poussées en non-rembobinage sur master ou integ sont permises par la première règle.
Les poussées en rembobinage à ces références n'ont pas de correspondance dans la première règle et se poursuivent par la seconde qui les refuse.
Toute poussée (en rembobinage ou non) à des `refs` autres que master ou integ ne correspondra pas aux deux premières règles et sera permise par la troisième.

### Restriction des poussées sur les fichiers modifiés ###

En sus de la restriction sur les branches utilisables par un utilisateur, il est possible de mettre en place des restrictions sur les fichiers qu'il aura droit de toucher.
Par exemple, un Makefile (ou tout autre script) n'est pas supposé être modifié par n'importe qui, du fait que de nombreuses choses en dépendent et qu'une modification non maîtrisée pourrait casser beaucoup de choses.
Vous pouvez indiquer à Gitolite :

    repo foo
        RW                      =   @junior_devs @senior_devs

        RW  NAME/               =   @senior_devs
        -   NAME/Makefile       =   @junior_devs
        RW  NAME/               =   @junior_devs
		-   VREF/NAME/Makefile  =   @junior_devs

Les utilisateurs migrant depuis une version précédente de Gitolite pourront noter qu'il y a une modification significative du comportement de cette fonctionnalité.
Référez-vous au guide de migration pour plus de détails.

### Branches personnelles ###

Gitolite a aussi une fonction appelée « branches personnelles » (ou plutôt « espace de branches personnelles ») qui peut s'avérer très utiles en environnement professionnel.

Dans le monde de Git, une grande quantité d'échange de code se passe par requêtes de tirage.
En environnement professionnel, cependant, les accès non-authentifiés sont inimaginables et une authentification poste à poste est impossible.
Il est donc nécessaire de pousser sur le serveur central et demander à quelqu'un d'en tirer.

Cela provoquerait normalement le même bazar de branches que dans les VCS centralisés, avec en plus la surcharge pour l'administrateur de la gestion des permissions.

Gitolite permet de définir un préfixe d'espace de nom « personnel » ou « brouillon » pour chaque développeur (par exemple, `refs/personnel/<nom du dev>/*`).
Référez-vous à la documentation pour plus de détails.

### Dépôts « joker » ###

Gitolite permet de spécifier des dépôts avec jokers (en fait des regex Perl), comme par exemple, au hasard, `devoirs/s[0-9][0-9]/a[0-9][0-9]`.
Un nouveau mode de permission devient accessible (`C`).
En suivant ces schémas de nommage, les utilisateurs peuvent alors créer des dépôts dont ils seront automatiquement propriétaires, leur permettant ainsi de leur assigner des droits en lecture ou lecture/écriture pour d'autres utilisateurs avec lesquels ils souhaitent collaborer.
Référez-vous à la documentation pour plus de détail.

### Autres fonctionnalités ###

Nous terminerons cette section avec quelques échantillons d'autres fonctions qui sont toutes décrites, ainsi que d'autres dans la documentation.

**Journalisation** : Gitolite enregistre tous les accès réussis.
Si vous étiez réticent à donner aux utilisateurs des droits de rembobiner (`RW+`) et qu'un plaisantin a complètement cassé « master », le journal des activités est là pour vous aider à trouver facilement et rapidement le SHA qui a tout déclenché.

**Rapport sur les droits d'accès** : une autre fonctionnalité très utile concerne la prise en charge de la connexion SSH au serveur.
Gitolite vous affiche à quels dépôts vous pouvez accéder et avec quels droits.
Ci-dessous un exemple :

	hello scott, this is git@git running gitolite3 \
	v3.01-18-g9609868 on git 1.7.4.4

	         R     anu-wsd
             R     entrans
             R  W  git-notes
             R  W  gitolite
             R  W  gitolite-admin
             R     indic_web_input
             R     shreelipi_converter

**Délégation** : Pour les grands déploiements, il est possible de déléguer la responsabilité de groupes de dépôts à différentes personnes en leur permettant de les gérer de manière autonome.
Cela permet de réduire la charge de travail de l'administrateur principal et évite d'en faire un goulet d'étranglement.

**Miroirs** : Gitolite peut vous aider à maintenir de multiples miroirs et à basculer simplement entre eux si le miroir principal tombe en panne.

## Le *daemon* Git ##

Pour garantir les accès publics non authentifiés en lecture à vos projets, il est préférable de dépasser le protocole HTTP et de commencer à utiliser le protocole Git.
La raison principale en est la vitesse.
Le protocole Git est bien plus efficace et de ce fait plus rapide que le protocole HTTP et fera gagner du temps à vos utilisateurs.

Ce système n'est valable que pour les accès non authentifiés en lecture seule.
Si vous mettez ceci en place sur un serveur à l'extérieur de votre pare-feu, il ne devrait être utilisé que pour des projets qui sont destinés à être visibles publiquement par le monde entier.
Si  le serveur est derrière le pare-feu, il peut être utilisé pour des projets avec accès en lecture seule pour un grand nombre d'utilisateurs ou des ordinateurs (intégration continue ou serveur de compilation) pour lequels vous ne souhaitez pas avoir à gérer des clés SSH.

En tout cas, le protocole Git est relativement facile à mettre en place.
Grossièrement, il suffit de lancer la commande suivante en tant que *daemon* :

	git daemon --reuseaddr --base-path=/opt/git/ /opt/git/

`--reuseaddr` autorise le serveur à redémarrer sans devoir attendre que les anciennes connexions expirent, l'option `--base-path` autorise les gens à cloner des projets sans devoir spécifier le chemin complet, et le chemin en fin de ligne indique au *daemon* Git l'endroit où chercher des dépôts à exporter.
Si vous utilisez un pare-feu, il sera nécessaire de rediriger le port 9418 sur la machine hébergeant le serveur.

Transformer ce processus en *daemon* se réalise par différentes manières qui dépendent du système d'exploitation sur lequel il est lancé.
Sur une machine Ubuntu, c'est un script Upstart.
Donc dans le fichier :

	/etc/event.d/local-git-daemon

vous mettez le script suivant :

	start on startup
	stop on shutdown
	exec /usr/bin/git daemon \
	    --user=git --group=git \
	    --reuseaddr \
	    --base-path=/opt/git/ \
	    /opt/git/
	respawn

Par sécurité, ce *daemon* devrait être lancé par un utilisateur n'ayant que des droits de lecture seule sur les dépôts — simplement en créant un nouvel utilisateur « git-ro » qui servira à lancer le *daemon*.
Par simplicité, nous le lancerons avec le même utilisateur « git » qui est utilisé par Gitosis.

Au rédémarrage de la machine, votre *daemon* Git démarrera automatiquement et redémarrera s'il meurt.
Pour le lancer sans avoir à redémarrer, vous pouvez lancer ceci :

	initctl start local-git-daemon

Sur d'autres systèmes, le choix reste large, allant de `xinetd` à un script de système `sysvinit` ou à tout autre moyen — tant que le programme est démonisé et surveillé.

Ensuite, il faut spécifier à votre serveur Gitosis les dépôts à autoriser en accès Git.
Si vous ajoutez une section pour chaque dépôt, vous pouvez indiquer ceux que vous souhaitez servir en lecture via votre *daemon* Git.
Par exemple, si vous souhaitez un accès par protocole Git à votre projet iphone, ajoutez ceci à la fin du fichier `gitosis.conf` :

	[repo iphone_projet]
	daemon = yes

Une fois cette configuration validée et poussée, votre *daemon* devrait commencer à servir des requêtes pour ce projet à toute personne ayant accès au port 9518 de votre serveur.

Si vous décidez de ne pas utiliser Gitosis, mais d'utiliser un *daemon* Git, il faudra lancer les commandes suivantes sur chaque projet que vous souhaitez faire servir par le *daemon* Git :

	$ cd /chemin/au/projet.git
	$ touch git-daemon-export-ok

La présence de ce fichier indique à Git que ce projet peut être servi sans authentification.

Gitosis peut aussi contrôler les projets que GitWeb publie.
Premièrement, il faut ajouter au fichier `/etc/gitweb.conf` quelque chose comme :

	$projects_list = "/home/git/gitosis/projects.list";
	$projectroot = "/home/git/repositories";
	$export_ok = "git-daemon-export-ok";
	@git_base_url_list = ('git://gitserver');

Vous pouvez contrôler les projets publiés sur GitWeb en ajoutant ou retirant une propriété `gitweb` au fichier de configuration de Gitosis.
Par exemple, si vous voulez que le projet iphone soit visible sur GitWeb, le paramétrage `repo` doit être le suivant :

	[repo iphone_projet]
	daemon = yes
	gitweb = yes

Maintenant, si vous validez et poussez le projet `gitosis-admin`, GitWeb commencera automatiquement à publier votre projet iphone.

## Git hébergé ##

Si vous ne vous ne voulez pas vous investir dans la mise en place de votre propre serveur Git, il reste quelques options pour héberger vos projets Git sur un site externe dédié à l'hébergement.
Cette méthode offre de nombreux avantages : un site en hébergement est généralement rapide à créer et facilite le démarrage de projets, et n'implique pas de maintenance et de surveillance de serveur.
Même si vous montez et faites fonctionner votre serveur en interne, vous souhaiterez surement utiliser un site d'hébergement public pour votre code open source — cela rend généralement plus facile l'accès et l'aide par la communauté.

Aujourd'hui, vous avez à disposition un nombre impressionnant d'options d'hébergement, chacune avec différents avantages et désavantages.
Pour une liste à jour, référez-vous à la page suivante :

	https://git.wiki.kernel.org/index.php/GitHosting

Comme nous ne pourrons pas les passer toutes en revue, et comme de plus, il s'avère que je travaille pour l'une d'entre elles, nous utiliserons ce chapitre pour détailler la création d'un compte et d'un nouveau projet sur GitHub.
Cela vous donnera une idée de ce qui est nécessaire.

GitHub est de loin le plus grand site d'hébergement open source sur Git et c'est aussi un des rares à offrir à la fois des options d'hébergement public et privé, ce qui vous permet de conserver vos codes open source et privés au même endroit.
En fait, nous avons utilisé GitHub pour collaborer en privé sur ce livre.

### GitHub ###

GitHub est légèrement différent de la plupart des sites d'hébergement de code dans le sens où il utilise un espace de noms pour les projets.
Au lieu d'être principalement orienté projet, GitHub est orienté utilisateur.
Cela signifie que lorsque j'héberge mon projet `grit` sur GitHub, vous ne le trouverez pas à `github.com/grit` mais plutôt à `github.com/schacon/grit`.
Il n'y a pas de dépôt canonique d'un projet, ce qui permet à un projet de se déplacer d'un utilisateur à l'autre sans transition si le premier auteur abandonne le projet.

GitHub est aussi une société commerciale qui facture les comptes qui utilisent des dépôts privés, mais tout le monde peut rapidement obtenir un compte gratuit pour héberger autant de projets libres que désiré.
Nous allons détailler comment faire.

### Création d'un compte utilisateur ###

La première chose à faire, c'est de créer un compte utilisateur gratuit.
Visitez la page « Plans and pricing » (plans et prix) à `https://github.com/pricing` et cliquez sur le bouton « Create a free account » (créer un compte gratuit) de la zone  « Free for open source » (gratuit pour l'open source) (voir figure 4-2) qui vous amène à la page d'enregistrement.

Insert 18333fig0402.png
Figure 4-2. La page des différents plans de GitHub.

Vous devez choisir un nom d'utilisateur qui n'est pas déjà utilisé dans le système et saisir une adresse e-mail qui sera associée au compte et un mot de passe (voir figure 4-3).

Insert 18333fig0403.png
Figure 4-3. La page d'enregistrement de GitHub.

Si vous l'avez, c'est le bon moment pour ajouter votre clé publique SSH.
Nous avons détaillé comment en générer précédemment au chapitre « Petites installations ».
Copiez le contenu de la clé publique et collez-le dans la boîte à texte « SSH Public Keys » (clés SSH publiques).
En cliquant sur le lien « Need help with public keys? » (besoin d'aide avec les clés publiques ?), vous aurez accès aux instructions (en anglais) pour créer des clés sur la majorité des systèmes d'exploitation.
Cliquez sur le bouton « I agree, sign me up » (j'accepte, enregistrez-moi) pour avoir accès à votre tableau de bord de nouvel utilisateur (voir figure 4-4).

Insert 18333fig0404.png
Figure 4-4. Le tableau de bord d'utilisateur de GitHub.

Vous pouvez ensuite procéder à la création d'un nouveau dépôt.

### Création d'un nouveau dépôt ###

Commencez en cliquant sur le bouton gris « New Repository » juste à côté de « Your Repositories » (vos dépôts) sur le tableau de bord utilisateur.
Un formulaire « Create a New Repository » (créer un nouveau dépôt) apparaît pour vous guider dans la création d'un nouveau dépôt (voir figure 4-5).

Insert 18333fig0405.png
Figure 4-5. Création d'un nouveau dépôt sur GitHub.

Le strict nécessaire consiste à fournir un nom au projet, mais vous pouvez aussi ajouter une description.
Ensuite, cliquez sur le bouton « Create Repository » (créer un dépôt).
Voilà un nouveau dépôt sur GitHub (voir figure 4-6).

Insert 18333fig0406.png
Figure 4-6. Information principale d'un projet GitHub.

Comme il n'y a pas encore de code, GitHub affiche les instructions permettant de créer un nouveau projet, de pousser un projet Git existant ou d'importer un projet depuis un dépôt Subversion public (voir figure 4-7).

Insert 18333fig0407.png
Figure 4-7. Instructions pour un nouveau dépôt.

Ces instructions sont similaires à ce que nous avons déjà décrit.
Pour initialiser un projet qui n'est pas déjà dans Git, tapez :

	$ git init
	$ git add .
	$ git commit -m 'premiere validation'

Dans le cas d'un projet Git local, ajoutez GitHub comme dépôt distant et poussez-y votre branche master :

	$ git remote add origin git@github.com:testinguser/iphone_projet.git
	$ git push origin master

Votre projet est à présent hébergé sur GitHub et vous pouvez fournir l'URL à toute personne avec qui vous souhaitez le partager.
Dans notre cas, il s'agit de `http://github.com/testinguser/iphone_projet`.
Vous pouvez aussi voir dans l'en-tête de la page de chaque projet qu'il y a deux URL Git (voir figure 4-8).

Insert 18333fig0408.png
Figure 4-8. En-tête de projet avec une URL publique et une URL privée.

L'URL « Git Read-Only » (Git en lecture seule) est une URL Git publique en lecture seule que tout le monde peut cloner.
Utilisez cette URL pour publier et partager votre dépôt sur un site web ou autre.

Votre URL « SSH » est une URL SSH en lecture/écriture qui ne vous permet de lire et écrire que si vous possédez la clé privée associée à la clé publique téléchargée pour votre utilisateur.
Quand d'autres utilisateurs visiteront cette page de projet, ils ne verront pas cette URL, ils ne verront que l'URL publique.

### Import depuis Subversion ###

Si vous souhaitez importer un projet public sous Subversion dans Git, GitHub peut vous faciliter la tâche.
Il y a un lien  « Importing a SVN Repo? Click here » (Vous importez un dépôt Subversion ? Cliquez ici) au bas de la page d'instructions.
En le cliquant, vous accédez à un formulaire contenant des informations sur le processus d'import et une boîte à texte où vous pouvez coller l'URL de votre dépôt public Subversion (voir figure 4-9).

Insert 18333fig0409.png
Figure 4-9. Interface d'import depuis Subversion.

Si votre projet est très gros, ne suit pas les standards de nommage ou est privé, cette méthode risque de ne pas fonctionner.
Au chapitre 7, nous traiterons des imports manuels plus compliqués de projets.

### Ajout des collaborateurs ###

Ajoutons le reste de l'équipe.
Si John, Josie et Jessica ouvrent tous un compte sur GitHub, et que vous souhaitez leur donner un accès en écriture à votre dépôt, vous pouvez les ajouter à votre projet comme collaborateurs.
Cela leur permettra de pousser leur travail sur le dépôt avec leurs clés privées.

Cliquez sur le bouton « Admin » dans l'en-tête du projet pour accéder à la page d'administration de votre projet GitHub (voir figure 4-10).

Insert 18333fig0410.png
Figure 4-10. Page d'administration GitHub.

Pour accorder à un autre utilisateur l'accès en écriture au projet, cliquez sur l'onglet « Collaborators » (Collaborateurs).
Vous pouvez entrer le nom de l'utilisateur dans la boîte à texte qui apparaît.
Au fur et à mesure de votre frappe, une liste déroulante affiche les noms qui correspondent aux caractères tapés.
Lorsque vous avez trouvé l'utilisateur correct, cliquez sur le bouton « Add » (Ajouter) pour ajouter l'utilisateur comme collaborateur au projet (voir figure 4-11).

Insert 18333fig0411.png
Figure 4-11. Ajout d'un collaborateur à votre projet.

Lorsque vous avez fini d'ajouter des collaborateurs, vous devriez les voir en liste dans la boîte « Repository Collaborators » (voir figure 4-12).

Insert 18333fig0412.png
Figure 4-12. Une liste des collaborateurs sur votre projet.

Si vous devez révoquer l'accès à certaines personnes, vous pouvez cliquer sur la croix rouge leur correspondant et leur accès en écriture sera effacé.
Pour des projets futurs vous pouvez aussi copier des groupes de collaborateurs en copiant les permissions d'un projet existant.

### Votre projet ###

Une fois que vous avez poussé votre projet ou l'avez importé depuis Subversion, votre page principale de projet ressemble à la figure 4-13.

Insert 18333fig0413.png
Figure 4-13. Un page principale de projet GitHub.

Lorsqu'on visite votre projet, on voit cette page.
Elle contient des onglets vers différentes vues des projets.
L'onglet « Commits » (validations) affiche une liste des validations dans l'ordre chronologique inverse, similaire à ce qu'afficherait la commande `git log`.
L'onglet « Network » (réseau) affiche tous les utilisateurs ayant dupliqué votre projet et contribué.
L'onglet « Downloads » (téléchargements) vous permet de télécharger les exécutables du projet ou de fournir des archives des sources aux points étiquetés de votre projet.
L'onglet « Wiki » fournit un wiki où vous pouvez commencer à écrire la documentation ou d'autres informations du projet.
L'onglet « Graphs » permet de visualiser les contributions et les statistiques.
L'onglet principal « Source » sur lequel vous arrivez par défaut affiche le contenu du répertoire principal du projet et met en forme dessous le fichier README s'il en contient un.
Cet onglet affiche aussi une boîte contenant les informations de la dernière validation.

### Duplication de projets ###

Si vous souhaitez contribuer à un projet auquel vous n'avez pas accès en écriture, GitHub encourage à dupliquer le projet.
Si le projet vous semble intéressant et que vous souhaitez le modifier, vous pouvez cliquer sur le bouton « Fork » (dupliquer) visible dans l'en-tête du projet pour faire copier ce projet par GitHub vers votre utilisateur pour que vous puissiez pousser dessus.

De cette manière, les administrateurs de projet n'ont pas à se soucier d'ajouter des utilisateurs comme collaborateurs pour leur donner un accès en écriture.
On peut dupliquer un projet et pousser dessus, et le mainteneur principal du projet peut tirer ces modifications en ajoutant les projets dupliqués comme dépôts distants et en fusionnant les changements.

Pour dupliquer un projet, visitez la page du projet (par exemple mojombo/chronic), et cliquez sur le bouton « Fork » (dupliquer) dans l'en-tête (voir figure 4-14).

Insert 18333fig0414.png
Figure 4-14. Obtenir un copie modifiable et publiable d'un dépôt en cliquant sur le bouton « Fork ».

Quelques secondes plus tard, vous êtes redirigé vers une nouvelle page de projet qui indique que ce projet est un duplicata d'un autre (voir figure 4-15).

Insert 18333fig0415.png
Figure 4-15. Votre duplicata d'un projet.

### Résumé sur GitHub ###

C'est tout ce que nous dirons de GitHub, mais il faut souligner que tous ces processus sont très rapides.
Vous pouvez créer un compte, ajouter un nouveau projet et commencer à pousser dessus en quelques minutes.
Si votre projet est libre, vous pouvez aussi construire une importante communauté de développeurs qui ont à présent la visibilité sur votre projet et peuvent à tout moment le dupliquer et commencer à contribuer.
Tout au moins, cela peut s'avérer une manière rapide de démarrer avec Git et de l'essayer.

## Résumé ##

Vous disposez de plusieurs moyens de mettre en place un dépôt Git distant pour pouvoir collaborer avec d'autres et partager votre travail.

Gérer votre propre serveur vous donne une grande maîtrise et vous permet de l'installer derrière un pare-feu, mais un tel serveur nécessite généralement une certaine quantité de travail pour l'installation et la maintenance.
Si vous placez vos données sur un serveur hébergé, c'est très simple à installer et maintenir.
Cependant vous devez pouvoir héberger votre code sur des serveurs tiers et certaines politiques d'organisation ne le permettent pas.

Choisir la meilleure solution ou combinaison de solutions pour votre cas ou celui de votre société ne devrait pas poser de problème.
