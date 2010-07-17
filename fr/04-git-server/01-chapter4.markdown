# Git sur le serveur #

À présent, vous devriez être capable de réaliser la plupart des tâches quotidiennes impliquant Git.
Néanmoins, pour pouvoir collaborer avec d'autres personnes au moyen de Git, vous allez devoir disposer d'un dépôt distant Git.
Bien que vous puissiez techniquement tirer des modifications et pousser des modification avec des dépôts individuels, cette pratique est découragée parce qu'elle introduit très facilement une confusion avec votre travail actuel.
De plus, vous souhaitez que vos collaborateurs puissent accéder à votre dépôt de sources, y compris si vous n'êtes pas connecté — disposer d'un dépôt accessible en permanence peut s'avérer utile.
De ce fait, la méthode canonique pour collaborer consiste à instancier un dépôt intermédiaire auquel tous ont accès, que ce soit pour pousser ou tirer.
Nous nommerons ce dépôt le "serveur Git" mais vous vous apercevrez qu'héberger un serveur de dépôt Git ne consomme que peu de ressources et que de ce fait, on n'utilise que rarement une machine dédiée à cette tâche.

Un serveur Git est simple à lancer.
Premièrement, vous devez choisir quels protocoles seront supportés.
La première partie de ce chapitre traite des protocoles disponibles et de leurs avantages et inconvénients.
La partie suivante explique certaines configurations typiques avec ces protocoles et comment les mettre en œuvre.
Enfin, nous traiterons de quelques types d'hébergement, si vous souhaitez héberger votre code sur un serveur tiers, sans avoir à régler et maintenir un serveur par vous-même.

Si vous ne voyez pas d'intérêt à gérer votre propre serveur, vous pouvez sauter directement à la dernière partie de ce chapitre pour détailler les options pour mettre en place un compte hébergé, avant de continuer dans le chapitre suivant où les problématiques de développement distribué sont abordées.

Un dépôt distant est généralement un _dépôt nu_ ( _bare repository_ ), un dépôt Git qui n'a pas de copie de travail.
Comme ce dépôt n'est utilisé que comme centralisateur de collaboration, il n'y a aucune raison d'extraire un instantané sur le disque ; seules les données Git sont nécessaires.
Pour simplifier, un dépôt nu est le contenu du répertoire `.git` sans fioriture.

## Les protocoles ##

Git peut utiliser quatre protocoles réseau majeurs pour transporter des données : Local, Secure Shell (SSH), Git et HTTP.
Nous allons voir leur nature et dans quelles circonstances ils peuvent (ou ne peuvent pas) être utilisés.

Il est à noter que mis à part HTTP, tous le protocoles nécessitent l'installation de Git sur le serveur.

### Le protocole local ###

Le protocole de base est le protocole _local_ pour lequel le dépôt distant est un autre répertoire dans le système de fichier.
Il est souvent utilisé si tous les membres de l'équipe ont accès à un répertoire partagé via NFS par exemple ou dans le cas moins probable où tous les développeurs travaillent sur le même ordinateur.
Ce dernier cas n'est pas optimum car tous les dépôts seraient hébergés de fait sur le même ordinateur, rendant ainsi tout défaillance catastrophique.

Si vous disposez d'un système de fichiers partagé, vous pouvez cloner, pousser et tirer avec un dépôt local.
Pour cloner un dépôt ou pour l'utiliser comme dépôt distant d'un projet existant, utilisez le chemin vers le dépôt comme URL.
Par exemple, pour cloner un dépôt local, vous pouvez lancer ceci :

	$ git clone /opt/git/project.git

Ou bien cela :

	$ git clone file:///opt/git/project.git

Git opère légèrement différemment si vous spécifiez explicitement le protocole `file://` au début de l'URL.
Si vous spécifiez simplement le chemin, Git tente d'utiliser des liens durs ou une copie des fichiers nécessaires.
Si vous spécifiez le protocole `file://`, Git lancer un processus d'accès au travers du réseau, ce qui est généralement moins efficace.
La raison d'utiliser spécifiquement le préfixe `file://` est la volonté d'obtenir une copie propre du dépôt, sans aucune référence ou aucun objet supplémentaire qui pourraient résulter d'un import depuis un autre système de gestion de version ou d'un action similaire (voir chapitre 9 pour les tâches de maintenance).
Nous utiliserons les chemins normaux par la suite car c'est la méthode la plus efficace.

Pour ajouter un dépôt local à un projet Git existant, vous pouvez lancer ceci :

	$ git remote add local_proj /opt/git/project.git

Ensuite, vous pouvez pousser vers et tirer depuis ce dépôt distant de la même manière que vous le feriez pour un dépôt accessible sur le réseau.

#### Les avantages ####

Les avantages des dépôts accessibles sur le système de fichier sont qu'ils sont simples et qu'ils utilisent les permissions du système de fichier.
Si vous avez déjà un montage partagé auquel toute votre équipe a accès, déployer un dépôt est extrêmement facile.
Vous placez la copie du dépôt nu à un endroit accessible de tous et positionnez correctement les droits de lecture/écriture de la même manière que pour tout autre partage.
Nous aborderons la méthode pour exporter une copie de dépôt nu à cette fin dans la section suivante "Déployer Git sur un serveur".

C'est un choix satisfaisant pour partager rapidement le travail.
Si vous et votre coéquipier travaillez sur le même projet et qu'il souhaite partager son travail, lancer une commande telle que `git pull /home/john/project` est certainement plus simple que de passer par un serveur intermédiaire.

#### Les inconvénients ####

les inconvénients de cette méthode sont qu'il est généralement plus difficile de rendre disponible un partage réseau depuis de nombreux endroits que de simplement gérer des accès réseau.
Si vous souhaitez pousser depuis votre portable à la maison, vous devez monter le partage distant, ce qui peut s'avérer plus difficile et lent que d'accéder directement par un protocole réseau.

Il est aussi à mentionner que ce n'est pas nécessairement l'option la plus rapide à l'utilisation si un partage réseau est utilisé.
Un dépôt local n'est rapide que si l'accès aux fichiers est rapide.
Un dépôt accessible sur un montage NFS est souvent plus lent qu'un dépôt accessible via SSH sur le même serveur qui ferait tourner Git avec un accès au disques locaux.

### Le protocole SSH ###

Le protocole SSH est probablement le protocole de transport de Git le plus utilisé.
Cela est du au fait que l'accès SSH est déjà mis en place à de nombreux endroits et que si ce n'est pas le cas, cela reste très facile à faire.
Cela est aussi du au fait que SSH est le seul protocole permettant facilement de lire et d'écrire à distance.
Les deux autres protocoles réseau (HTTP et Git) sont généralement en lecture seule et s'ils peuvent être utiles pour la publication, le protocole SSH est nécessaire pour les mises à jour de par ce qu'il permet l'écriture.
SSH est un protocole authentifié suffisamment répandu et sa mise œuvre est simplifiée.

Pour cloner une dépôt Git à travers SSH, vous pouvez spécifier le préfixe `ssh://` dans l'URL comme ceci :

	$ git clone ssh://user@server:project.git

ou vous pouvez ne pas spécifier de protocole du tout — Git choisit SSH par défaut si vous n'êtes pas explicite :
	
	$ git clone user@server:project.git

Vous pouvez aussi ne pas spécifier de nom d'utilisateur et Git utilisera par défaut le nom de login.

#### Les avantages ####

Les avantages liés à l'utilisation de SSH sont nombreux.
Primo, vous ne pourrez pas faire autrement si vous souhaitez gérer un accès authentifié en écriture à votre dépôt au travers le réseau.
Secundo, SSH est relativement simple à mettre en place, les daemons SSH sont facilement disponibles, les administrateurs réseaux sont habitués à les gérer et de nombreuses distributions de systèmes d'exploitation en disposent et proposent des outils de gestion.
Ensuite, l'accès distant à travers SSH est sécurisé, toutes les données sont chiffrées et authentifiées.
Enfin, comme les protocoles Git et local, SSH est efficace et permet de comprimer autant que possible les données avant de les transférer.

#### Les inconvénients ####

Le point négatif avec SSH est qu'il est impossible de proposer un accès anonyme au dépôt.
Les accès sont régis par les permission SSH, même pour un accès en lecture seule, ce qui s'oppose à une optique open-source.
Si vous souhaitez utiliser Git dans un environnement d'entreprise, SSH peut bien être le seul protocole nécessaire.
Si vous souhaitez proposer de l'accès anonyme en lecture seule à vos projets, vous aurez besoin de SSH pour vous permettre de pousser mais un autre protocole sera nécessaire pour permettre à d'autre de tirer.

### Le protocole Git ###

Vient ensuite le protocole Git. Celui-ci est géré par un daemon spécial qui est livré avec Git. Ce démon écoute sur un port dédié (9418) qui propose en service similaire au protocole SSH, mais sans aucune sécurisation.
Pour qu'un dépôt soit publié via le protocole Git, le fichier `git-export-daemon-ok` doit exister mais mise à part cette condition sans laquelle le daemon refuse de publier un projet, il n'y a aucune sécurité.
Soit le dépôt Git est disponible sans restriction en lecture, soit il n'est pas publié.
Cela signifie qu'il ne permet de pousser des modifications.
Vous pouvez activer la capacité à pousser mais étant donné l'absence d'authentification, n'importe qui sur internet peut pousser sur le dépôt.
Autant dire que ce mode est rarement recherché.

#### Les avantages ####

Le protocole Git est le protocole le plus rapide.
Si vous devez servir un gros trafic pour un projet public ou un très gros projet qui ne nécessite pas d'authentification en lecture, il est très probable que vous deviez installer un daemon Git.
Il utilise le même mécanisme de transfert de données que SSH, la surcharge du chiffrement et de l'authentification en moins.

#### Les inconvénients ####

Le défaut du protocole Git est le manque d'authentification.
N'utiliser que le protocole Git pour accéder à un projet n'est généralement pas suffisant.
Il faut le coupler avec un accès SSH pour quelques développeurs qui auront le droit de pousser (écrire) et le garder pour un accès `git://` en lecture seule.
C'est aussi le protocole le plus difficile à mettre en place.
Il doit être géré par son propre daemon qui est spécifique.
Nous traiterons de cette installation dans la section « Gitosis » de ce chapitre — elle nécessite la configuration d'un daemon `xinetd` ou apparenté, ce qui est loin d'être simple.
Il nécessite aussi un accès à travers le pare-feu au port 9418 qui n'est pas un port ouvert en standard dans les pare-feux professionnels.
Derrière les gros pare-feux professionnels, ce port obscur est tout simplement bloqué.

### Le protocole HTTP/S ###

Enfin, il reste le protocole HTTP.
La beauté d'HTTP ou HTTPS tient dans la simplicité à le mettre en place.
Tout ce qu'il y a à faire, c'est de simplement copier un dépôt Git nu sous votre racine de document HTTP et de paramétrer un crochet `post-update` et c'est prêt (voir chapitre 7 pour les détails sur les ???hook?? de Git).
À partir de ceci, toute personne possédant un accès au serveur web sur lequel vous avez copié votre dépôt peut le cloner.
Pour autoriser un accès en lecture à votre dépôt sur HTTP, faîtes ceci :

	$ cd /var/www/htdocs/
	$ git clone --bare /path/to/git_project gitproject.git
	$ cd gitproject.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

C'est tout.
Le hook `post-update` qui est livré avec Git par défaut lance la commande appropriée (`git update-server-info`) pour permettre un fonctionnement correct du clonage et de la récupération par HTTP.
Cette commande est lancée lorsque vous poussez vers ce dépôt par SSH ; ainsi, les autres personnes peuvent cloner via la commande

	$ git clone http://example.com/gitproject.git

Dans ce cas particulier, nous utilisons le chemin `/var/www/htdocs` qui est commun pour les installations d'Apache, mais vous pouvez utiliser n'importe quel serveur web de pages statiques — il suffit de placer le dépôt nu dans le chemin d'accès.
Les données Git sont servies comme des simples fichiers statiques (voir chapitre 9 pour la manière détaillée dont ils sont servis).

Il est possible de faire Git pousser à travers HTTP, bien que cette technique ne soit pas utilisée et nécessite de gérer les exigences complexes de WebDAV.
Comme elle est rarement utilisée, nous ne la détaillerons pas dans ce livre.
Si vous êtes tout de même intéressé par l'utilisation des protocoles de push-HTTP, vous pouvez vous référer à `http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt`.
Un des intérêts à permettre de pousser par HTTP est que vous pouvez utiliser n'importe quel serveur WebDAV, sans liaison avec Git.
Il est donc possible d'utiliser cette fonctionnalité si votre fournisseur d'hébergement web supporte WebDAV pour la mise à jour de vos sites.

#### Les avantages ####

L'avantage d'utiliser le protocole HTTP est qu'il est très simple à mettre en œuvre.
Donner un accès public en lecture à votre dépôt Git ne nécessite que quelques commandes.
Cela ne prend que quelque minutes.
De plus, le protocole HTTP n'est pas très demandeur en ressources système.
Les besoins étant limités à servir des données statiques, un serveur Apache standard peut servir des milliers de fichiers par seconde en moyenne et il est très difficile de surcharger même un ordinateur moyen.

Vous pouvez aussi publier votre dépôt par HTTPS, ce qui signifie que vous pouvez chiffrer le contenu transféré.
Vous pouvez même obliger les clients à utiliser des certificats SSL spécifiques.
Généralement, si vous souhaitez pousser jusque là, il est préférable d'utiliser par des clés SSH publiques.
Cependant, certains cas nécessitent l'utilisation de certificats SSL signés ou d'autres méthodes d'authentification basées sur HTTP pour les accès en lecture seule sur HTTPS.

Un autre avantage indéniable de HTTP est que c'est un protocole si commun que les pare-feu d'entreprise sont souvent paramétrés pour le laisser passer.

#### Les inconvénients ####

L'inconvénient majeur de servir votre dépôt sur HTTP est que c'est relativement inefficace pour le client.
Cela prend généralement beaucoup plus longtemps de cloner ou tirer depuis le dépôt et il en résulte un plus grand trafic réseau et de plus gros volumes de transfert que pour les autres protocoles.
Le protocole HTTP est souvent appelé le protocole _idiot_ parce qu'il n'a pas l'intelligence de sélectionner seulement les données nécessaires à transférer du fait du manque de traitement dynamique côté serveur.
Pour plus d'information sur les différences d'efficacité entre le protocole HTTP et les autres, référez-vous au chapitre 9.

## Installer Git sur un serveur ##

Pour réaliser l'installation initiale d'un serveur Git, il faut exporter une dépôt existant dans un nouveau dépôt nu — un dépôt qui ne contient pas de copie de répertoire de travail.
C'est généralement simple à faire.
Pour cloner votre dépôt en créant un nouveau dépôt nu, lancez la commande clone avec l'option `--bare`.
Par convention, les répertoires de dépôt nu finissent en `.git`, de cette manière :

	$ git clone --bare my_project my_project.git
	Initialized empty Git repository in /opt/projects/my_project.git/

La sortie de cette commande est un peu déroutante.
Comme `clone` est un `git init` de base, suivi d'un `git fetch`, nous voyons les messages du `git init` qui crée un répertoire vide.
Le transfert effectif d'objet ne fournit aucune sortie, mais il a tout de même lieu.
Vous devriez maintenant avoir une copie des données de Git dans votre répertoire `my_project.git`.

C'est grossièrement équivalent à 

	$ cp -Rf my_project/.git my_project.git

Il y a quelques légères différences dans le fichier de configuration mais pour l'utilisation envisagée, c'est très proche.
La commande extrait le répertoire Git sans répertoire de travail et crée un répertoire spécifique pour l'accueillir.

### Placer le dépôt nu sur un serveur ###

À présent que vous avez une copie nue de votre dépôt, il ne reste plus qu'à le placer sur un serveur et à régler les protocoles.
Supposons que vous avez mis en place un serveur nommé `git.exemple.com` auquel vous avez accès par SSH et que vous souhaitez stocker vos dépôts Git dans le répertoire `/opt/git`.
Vous pouvez mettre en place votre dépôt en copiant le dépôt nu :

	$ scp -r my_project.git user@git.example.com:/opt/git

A partir de maintenant, tous les autres utilisateurs disposant d'un accès SSH au serveur et ayant un accès en lecture seule au répertoire `/opt/git` peut cloner votre dépôt en lançant la commande

	$ git clone user@git.example.com:/opt/git/my_project.git

Si un utilisateur se connecte par SSH au serveur et a accès en lecture au répertoire `/opt/git/my_project.git`, il aura automatiquement accès en pull.
Git ajoutera automatiquement les droits de groupe en écriture à un dépôt si vous lancez la commande `git init` avec l'option `--shared`.

	$ ssh user@git.example.com
	$ cd /opt/git/my_project.git
	$ git init --bare --shared

Vous voyez comme il est simple de prendre un dépôt Git, créer une version nue et de la placer sur un serveur auquel vous et vos collaborateurs avez accès en SSH.
Vous voilà prêts à collaborer sur le même projet.

Il faut noter que c'est littéralement tout ce dont vous avez besoin pour démarrer un serveur Git utile auquel plusieurs personnes ont accès — ajoutez des coptes SSH sur un serveur, et collez un dépôt nu quelque part où tous les utilisateurs ont accès en lecture et écriture.
Vous êtes prêts à travailler, vous n'avez besoin de rien d'autre.

Dans les chapitres à venir, nous traiterons de mises en places plus sophistiquées.
Ces sujets incluront l'élimination du besoin de créer un compte système pour chaque utilisateur, l'accès public aux dépôts, la mise en place d'interfaces utilisateurs web, l'utilisation de l'outil Gitosis, etc.
Néanmoins, gardez à l'esprit que pour collaborer avec quelques personnes sur un projet privé, tout ce qu'il faut, c'est un serveur SSH et un dépôt nu.

### Les petites installations ###

Si vous travaillez dans un petit groupe ou si vous n'êtes qu'en phase d'essai de Git au sein de votre société avec peu de développeurs, les choses peuvent rester simples.
Un des aspects les plus compliqués de la mise en place d'un serveur Git est la gestion des utilisateurs.
Si vous souhaitez que certains dépôts ne soient accessibles à certains utilisateurs qu'en lecture seule et en lecture/écriture pour d'autres, la gestion des accès et des permissions peut devenir difficile à régler.


#### L'accès SSH ####

Si vous disposez déjà d'un serveur auquel tous vos développeurs ont un accès SSH, il est généralement plus facile d'y mettre en place votre premier dépôt car vous n'aurez quasiment aucun réglage supplémentaire à faire (comme nous l'avons expliqué dans le chapitre précédent).
Si vous souhaitez des permissions d'accès plus complexes, vous pouvez les mettre en place par le jeu des permissions standards sur le système de fichier du système d'exploitation de votre serveur.

Si vous souhaitez placer vos dépôts sur un serveur qui ne dispose pas déjà de comptes pour chacun des membres de votre équipe qui aurait accès en écriture, alors vous devrez mettre en place un accès SSH pour eux.
En supposant que pour vos dépôts, vous disposez déjà d'un serveur SSH installé et sur lequel vous avez accès.

Il y a quelques moyens de donner un accès à tout le monde dans l'équipe.
Le premier est de créer des comptes pour tout le monde, ce qui est logique mais peut s'avérer lourd.
Vous ne souhaiteriez sûrement pas lancer `adduser` et entrer un mot de passe temporaire pour chaque utilisateur.

Une seconde méthode consiste à créer un seul utilisateur git sur la machine, demander à chaque développeur nécessitant un accès en écriture de vous envoyer une clef publique SSH et d'ajouter la dite clef au fichier `~/.ssh/authorized_keys` de votre utilisateur git.
À partir de là, tout le monde sera capable d'accéder à la machine via l'utilisateur git.
Cela n'affecte en rien les données de commit — les informations de l'utilisateur SSH par lequel on se connecte n'affectent pas les données de commit enregistrées.

Une dernière méthode consiste à faire une authentification SSH auprès d'un serveur LDAP ou tout autre système d'authentification centralisé que vous utiliseriez déjà.
Tant que chaque utilisateur peut accéder à un shell sur la machine, n'importe quel schéma d'authentification SSH devrait fonctionner.

## Génération des clefs publiques SSH ##

Cela dit, de nombreux serveurs Git utilisent une authentification par clefs publiques SSH.
Pour fournir une clef publique, chaque utilisateur de votre système doit la générer s'il n'en ont pas déjà.
Le processus est similaire sur tous les systèmes d'exploitation.
Premièrement, l'utilisateur doit vérifier qu'il n'en a pas déjà une.
Par défaut, les clefs SSH d'un utilisateur sont stockées dans le répertoire `~/.ssh` du compte.
Vous pouvez facilement vérifier si vous avez déjà une clef en listant le contenu de ce répertoire :

	$ cd ~/.ssh
	$ ls
	authorized_keys2  id_dsa       known_hosts
	config            id_dsa.pub

Recherchez une paire de fichiers appelés quelquechose et quelquechose.pub où le quelquechose en question est généralement `id_dsa` ou `id_rsa`.
Le fichier en `.pub` est la clef publique tandis que l'autre est la clef privée.
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


Premièrement, le programme demande confirmation pour l'endroit où vous souhaitez sauvegarder la clef (`.ssh/id_rsa`) puis il demande deux fois d'entrer un mot de passe qui peut être laissé vide si vous ne souhaitez pas devoir taper un mot de passe quand vous utilisez la clef.

Maintenant, chaque utilisateur ayant suivi ces indications doit envoyer la clef publique à la personne en charge de l'administration du serveur Git (en supposant que vous utilisez un serveur SSH réglé pour l'utilisation de clefs publiques).
Ils doivent copier le contenu du fichier .pub et l'envoyer par e-mail.
Les clefs publiques ressemblent à ceci :

	$ cat ~/.ssh/id_rsa.pub 
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU
	GPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3
	Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XA
	t3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/En
	mZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbx
	NrRFi9wrf+M7Q== schacon@agadorlaptop.local

Pour un tutoriel plus approfondi sur la création de clef SSH sur différents systèmes d'exploitation, référez-vous au guide GitHub sur les clefs SSH à `http://github.com/guides/providing-your-ssh-key`.

## Mise en place du serveur ##

Parcourons les étapes de la mise en place d'un accès SSH côté serveur.
Dans cet exemple, vous utiliserez la méthode des `authorized_keys` pour authentifier vos utilisateurs.
Nous supposerons également que vous utilisez une distribution Linux standard telle qu'Ubuntu.
Premièrement, créez un utilisateur 'git' et un répertoire `.ssh` pour cet utilisateur.

	$ sudo adduser git
	$ su git
	$ cd
	$ mkdir .ssh

Ensuite, vous devez ajouter la clef publique d'un développeur au fichier `authorized_keys` de l'utilisateur git.
Supposons que vous avez reçu quelques clefs par e-mail et les avez sauvées dans des fichiers temporaires.
Pour rappel, une clef publique ressemble à ceci :

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
	$ mkdir project.git
	$ cd project.git
	$ git --bare init

Alors, John, Josie ou Jessica peuvent pousser la première version de leur projet vers ce dépôt en l'ajoutant en tant que dépôt distant et en lui poussant une branche.
Notons que quelqu'un doit se connecter au serveur et créer un dépôt nu pour chaque ajout de projet.
Supposons que le nom du serveur soit `gitserver`.
Si vous l'hébergez en interne et avez réglé le DNS pour faire pointer `gitserver` sur ce serveur, alors vous pouvez utiliser les commandes suivantes telle quelle :

	# Sur l'ordinateur de John
	$ cd monproject
	$ git init
	$ git add .
	$ git commit -m 'premiere validation'
	$ git remote add origin git@gitserver:/opt/git/project.git
	$ git push origin master

À présent, les autres utilisateurs peuvent cloner le dépôt et y pousser leurs modifications aussi simplement :

	$ git clone git@gitserver:/opt/git/project.git
	$ vim LISEZMOI
	$ git commit -am 'correction fichier LISEZMOI'
	$ git push origin master

De cette manière, vous pouvez rapidement mettre en place un serveur Git en lecture/écriture pour une poignée de développeurs.

En précaution supplémentaire, vous pouvez simplement restreindre l'utilisateur 'git' à des actions Git avec un shell limité appelé `git-shell` qui est fourni avec Git.
Si vous positionnez ce shell comme shell de login de l'utilisateur 'git', l'utilisateur git ne peut pas avoir de shell normal sur ce serveur.
Pour utiliser cette fonction, spécifiez `git-shell` en lieu et place de bash ou csh pour shell de l'utilisateur.
Cela se réalise généralement en éditant le fichier `/etc/passwd` :

	$ sudo vim /etc/passwd

Tout au bas, vous devriez trouver une ligne qui ressemble à ceci :

	git:x:1000:1000::/home/git:/bin/sh

Modifiez `/bin/sh` en `/usr/bin/git-shell` (ou le résultat de la commande `which git-shell` qui indique où il est installé).
La ligne devrait maintenant ressembler à ceci :

	git:x:1000:1000::/home/git:/usr/bin/git-shell

À présent, l'utilisateur 'git' ne peut plus utiliser la connexion SSH que pour pousser et tirer sur des dépôts Git, il ne peut plus ouvrir un shell.
Si vous essayez, vous verrez une réjection de login :

	$ ssh git@gitserver
	fatal: What do you think I am? A shell?
	Connection to gitserver closed.

## Accès publique ##

Et si vous voulez permettre des accès anonymes en lecture ?
Peut-être souhaitez-vous héberger un projet open source au lieu d'un projet interne privé.
Ou peut-être avez-vous quelques serveurs de compilation ou d'intégration continue qui changent souvent et vous ne souhaitez pas avoir à regénérer des clefs SSH tout le temps — vous avez besoin d'un accès en lecture seule simple.

Le moyen le plus simple pour des petites installations est probablement d'installer un serveur web statique dont la racine pointe sur vos dépôts Git puis d'activer le ???hook??? `post-update` mentionné à la première partie de ce chapitre.
Reprenons l'exemple précédent.
Supposons que vos dépôts sont dans le répertoire `/opt/git` et qu'un serveur Apache soit installé sur la machine.
Vous pouvez bien sur utiliser n'importe quel serveur web mais nous utiliserons Apache pour montrer le nécessaire d'une configuration.

Premièrement, il faut activer le ???hook??? :

	$ cd project.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

Si vous utilisez une version de Git antérieure à 1.6, la commande `mv` n'est pas nécessaire car Git n'a commencé à utiliser le nommage des exemples de ???hook??? en utilisant le postfixe .sample que récemment.

Quelle est l'action de ce ???hook??? `post-update` ?
Il contient simplement ceci :

	$ cat .git/hooks/post-update 
	#!/bin/sh
	exec git-update-server-info

Cela signifie que lorsque vous poussez vers le serveur via SSH, Git lance cette commande pour mettre à jour les fichiers nécessaires lorsqu'on tire par HTTP.

Ensuite, il faut ajouter une entrée VirtualHost à la configuration Apache dont la racine pointe sur vos dépôts Git.
Ici, nous supposerons que vous avez réglé un DNS avec résolution générique qui renvoit `*.gitserver` vers la machine qui héberge ce système :

	<VirtualHost *:80>
	    ServerName git.gitserver
	    DocumentRoot /opt/git
	    <Directory /opt/git/>
	        Order allow, deny
	        allow from all
	    </Directory>
	</VirtualHost>

Vous devrez aussi positionner le groupe d'utilisateur Unix du répertoire `/opt/git` à `www-data` de manière à ce que le serveur web puisse avoir accès en lecture seule aux répertoires si le serveur Apache lance le script CGI avec cet utilisateur (par défaut) :

	$ chgrp -R www-data /opt/git

Après avoir redémarré Apache, vous devriez être capacle de cloner vos dépôts en spécifiant l'URL de votre projet :

	$ git clone http://git.gitserver/project.git

Ainsi, vous pouvez donner accès en lecture seule à tous vos projets à un grand nombre d'utilisateurs en quelques minutes.
Une autre option simple pour fournir un accès public non-authentifié consiste à lancer un daemon Git, bien que cela requiert de daemoniser le processus ─ nous traiterons cette option dans un chapitre ultérieur si vous préférez cette option.

## GitWeb ##

Après avoir réglé les accès de base en lecture/écriture et en lecture seule pour vos projets, vous souhaiterez peut-être mettre en place une interface web simple de visualisation.
Git fournit un script CGI appelé GitWeb qui est souvent utilisé à cette fin.
Vous pouvez voir GitWeb en action sur des sites tels que `http://git.kernel.org` (voir figure 4-1).

Insert 18333fig0401.png 
Figure 4-1. L'interface web de visualisation GitWeb

Si vous souhaitez vérifier à quoi GitWeb ressemblerait pour votre projet, Git fournit une commande pour démarrer une instance temporaire de serveur si vous avez un serveur léger sur votre système, tel que `lighttpd` ou `webrick`.
Sur les machines Linux, `lighttpd` est souvent pré-installé et vous devriez pouvoir le démarrer en tapant `git instaweb` dans votre répertoire de travail.
Si vous utilisez un Mac, Ruby est installé de base avec Léopard, donc `webrick` est une meilleure option.
Pour démarrer `instaweb` avec un gestionnaire autre que lighttpd, vous pouvez le lancer avec l'option `--httpd`.

	$ git instaweb --httpd=webrick
	[2009-02-21 10:02:21] INFO  WEBrick 1.3.1
	[2009-02-21 10:02:21] INFO  ruby 1.8.6 (2008-03-03) [universal-darwin9.0]

Cette commande démarre un serveur HTTP sur le port 1234 et lance automatique un navigateur internet qui ouvre la page d'accueil.
C'est vraiment très simple.
Pour arrêter le serveur, il suffit de lancer la même commande mais avec l'option `--stop` :

	$ git instaweb --httpd=webrick --stop

Si vous souhaiter fournir l'interface web en permanence sur le serveur pour votre équipe ou pour un projet opensource que vous hébergez, il sera nécessaire d'installer le script CGI pour qu'il soit appelé paqr votre serveur web.
Quelques distributions Linux ont un package `gitweb` qu'il suffira d'installer via `apt` ou `yum`, ce qui est une possibilité.
Nous détaillerons tout de même rapidement l'installation manuelle de GitWeb.
Premièrement, le code source de Git qui fournit GitWeb est nécessaire pour pouvoir générer un script CGI personnalisé :

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/
	$ make GITWEB_PROJECTROOT="/opt/git" \
	        prefix=/usr gitweb/gitweb.cgi
	$ sudo cp -Rf gitweb /var/www/

Notez que vous devez indiquer où trouver les dépôts Git au moyen de la variable `GITWEB_PROJECTROOT`.
Maintenant, il faut installer dans Apache l'utilisation de CGI pour ce script, en spécifiant un nouveau VirtualHost :

	<VirtualHost *:80>
	    ServerName gitserver
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

Une fois de plus, GitWeb peut être géré par tout serveur Web capable de prendre en charge CGI.
La mise en place ne devrait pas être plus difficile avec un autre serveur.
Après redémarrage du serveur, vous devriez être capable de visiter `http://gitserver/` pour visualiser vos dépôts en ligne et de cloner et tirer depuis ces dépôts par HTTP sur `http://git.gitserver`.

## Gitosis ##

Conserver les clefs publiques de tous les utilisateurs dans le fichier `authorized_keys` n'est satisfaisant qu'un temps.
Avec des centaines d'utilisateurs, la gestion devient compliquée.
À chaque fois, il faut se connecter au serveur et il n'y a aucun contrôle d'accès — toute personne avec une clef dans le fichier a accès en lecture et écriture à tous les projets.

Il est temps de se tourner vers un logiciel largement utilisé appelé Gitosis.
Gitosis est une collection de scripts qui aident à gérer le fichier `authorize_keys` ainsi qu'à implémenter des contrôles d'accès simples.
La partie la plus intéressante de l'outil est que l'interface d'administration permettant d'ajouter des utilisateurs et de déterminer leurs droits n'est pas une interface web mais un dépôt Git spécial.
Vous paramétrez les informations dans ce projet et lorsque vous le poussez, Gitosis reconfigure les serveurs en fonction des données, ce qui est cool.

L'installation de Gitosis n'est pas des plus aisées.
Elle est plus simple sur un serveur Linux — les exemples qui suivent utilisent une distribution Ubuntu Server 8.10 de base.

Gitosis nécessite des outils Python.
Il faut donc installer le paquet Python setuptools qu'Ubuntu fournit en tant que python-setuptools :

	$ apt-get install python-setuptools

Ensuite, il faut cloner et installer Gitosis à partir du site principal du projet :

	$ git clone git://eagain.net/gitosis.git
	$ cd gitosis
	$ sudo python setup.py install

La dernière commande installe deux exécutables que Gitosis utilisera.
Ensuite, Gitosis veut gérer ses dépôts sous `/home/git`, ce qui est parfait.
Mais vous avez déjà installé vos dépots sous `/opt/git`, donc au lieu de tout reconfigurer, créez un lien symbolique :

	$ ln -s /opt/git /home/git/repositories

Comme Gitosis gérera vos clefs pour vous, il faut effacer le fichier `authorized_keys`, ré-ajouter les clefs plus tard et laisser Gitosis contrôler le fichier automatiquement.
Pour l'instant, déplacez le fichier `authorized_keys` ailleurs :

	$ mv /home/git/.ssh/authorized_keys /home/git/.ssh/ak.bak

Ensuite, il faut réactiver le shell pour l'utilisateur « git » si vous l'avez désactivé au moyen de `git-shell`.
Les utilisateurs ne pourront toujours pas se connecter car Gitosis contrôlera cet accès.
Modifions la ligne dans le fichier `/etc/passwd`

	git:x:1000:1000::/home/git:/usr/bin/git-shell

pour la version d'origine :

	git:x:1000:1000::/home/git:/bin/sh

Vous pouvez maintenant initialiser Gitosis en lançant la commande `gitosis-init` avec votre clef publique.
Si votre clef publique n'est pas présente sur le serveur, il faut l'y télécharger :

	$ sudo -H -u git gitosis-init < /tmp/id_dsa.pub
	Initialized empty Git repository in /opt/git/gitosis-admin.git/
	Reinitialized existing Git repository in /opt/git/gitosis-admin.git/

Cela permet à l'utilisateur disposant de cette clef de modifier les dépôt Git qui contrôle le paramétrage de Gitosis.
Ensuite, il faudra positionner manuellement le bit « execute » du script `post-update` du dépôt de contrôle nouvellement créé.

	$ sudo chmod 755 /opt/git/gitosis-admin.git/hooks/post-update

Vous voilà prêt.
Si tout est réglé correctement, vous pouvez essayer de vous connecter par SSH au serveur en tant que l'utilisateur pour lequel vous avez ajouté la clef publique lors de l'initialisation de Gitosis..
Vous devriez voir quelque chose comme :

	$ ssh git@gitserver
	PTY allocation request failed on channel 0
	fatal: unrecognized command 'gitosis-serve schacon@quaternion'
	  Connection to gitserver closed.

Cela signifie que Gitosis vous a bien reconnu mais vous a rejeté car vous ne lancez pas de commandes Git.
Lançons donc une vraie commande Git — en clonant le dépôt de contrôle Gitosis :

	# on your local computer
	$ git clone git@gitserver:gitosis-admin.git

Vous avez à présent un répertoire `gitosis-admin` qui contient deux entrées :

	$ cd gitosis-admin
	$ find .
	./gitosis.conf
	./keydir
	./keydir/scott.pub

Le fichier `gitosis.conf` est le fichier de configuration qui permet de spécifier les utilisateurs, les dépôts et les permissions.
le répertoire `keydir` stocke les clefs publiques de tous les utilisateurs qui peuvent avoir un accès à vos dépôts — un fichier par utilisateur.
Le nom du fichier dans `keydir` (dans l'exemple précédent, `scott.pub`) sera différente pour vous — Gitosis utilise le nom issu de la description à la fin de la clef publique qui a été importée par le script `gitosis-init`.

Le fichier `gitosis.conf` contient la configuration du projet `gitosis-admin` cloné à l'instant :

	$ cat gitosis.conf 
	[gitosis]

	[group gitosis-admin]
	writable = gitosis-admin
	members = scott

Il indique que l'utilisateur scott — l'utilisateur dont la clef publique a servi à initialiser Gitosis — est le seul à avoir accès au projet `gitosis-admin`.

A présent, ajoutons un nouveau projet.
Ajoutons une nouvelle section appelée `mobile` où vous listez les développeurs de votre équipe mobile et les projets auquels ces développeurs ont accès.
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
Gitosis crée les automatiquement dès qu'il voit le premier push :

	$ git remote add origin git@gitserver:iphone_projet.git
	$ git push origin master
	Initialized empty Git repository in /opt/git/iphone_projet.git/
	Counting objects: 3, done.
	Writing objects: 100% (3/3), 230 bytes, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:iphone_project.git
	 * [new branch]      master -> master

Notez qu'il n'est pas nécessaire de spécifier le chemin distant (en fait, c'est interdit), juste deux points et le nom du projet.
Gitosis gère les chemins.

Souhaitant travailler sur ce projet avec vos amis, vous devrez rajouter leurs clefs publics.
Plutôt que de les accoler manuellement au fichier `~/.ssh/authorized_keys` de votre serveur, il faut les ajouter, une clef par fichier dans le répertoire `keydir`.
Le nom de fichier détermine les noms de utilisateurs dans le fichier `gitosis.conf`.
Rajoutons les clefs publiques de John, Josie et Jessica :

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
i
	[group mobile]
	writable = iphone_projet
	members = scott josie jessica

	[group mobile_ro]
	readonly = iphone_projet
	members = john

A présent, John peut cloner le projet et récupérer les mises à jour, mais Gitosis lui refusera de pousser sur ce projet.
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

Si vous rencontrez de problèmes, il peut être utile d'ajouter `loglevel=DEBUG` sous la section `[gitosis]`.
Si vous avez perdu le droit de pousser en poussant une configuration vérolée, vous pouvez toujours réparer le fichier `/home/git/.gitosis.conf` sur le serveur — le fichier dans lequel Gitosis lit sa configuration.
Pousser sur le projet `gitosis-admin` provoque la recopie du fichier `gitosis.conf` à cet endroit.
Si vous éditez ce fichier à la main, il restera dans cet état jusqu'à la prochaine poussée.

## Git Daemon ##

For public, unauthenticated read access to your projects, you’ll want to move past the HTTP protocol and start using the Git protocol. The main reason is speed. The Git protocol is far more efficient and thus faster than the HTTP protocol, so using it will save your users time.

Again, this is for unauthenticated read-only access. If you’re running this on a server outside your firewall, it should only be used for projects that are publicly visible to the world. If the server you’re running it on is inside your firewall, you might use it for projects that a large number of people or computers (continuous integration or build servers) have read-only access to, when you don’t want to have to add an SSH key for each.

In any case, the Git protocol is relatively easy to set up. Basically, you need to run this command in a daemonized manner:

	git daemon --reuseaddr --base-path=/opt/git/ /opt/git/

`--reuseaddr` allows the server to restart without waiting for old connections to time out, the `--base-path` option allows people to clone projects without specifying the entire path, and the path at the end tells the Git daemon where to look for repositories to export. If you’re running a firewall, you’ll also need to punch a hole in it at port 9418 on the box you’re setting this up on.

You can daemonize this process a number of ways, depending on the operating system you’re running. On an Ubuntu machine, you use an Upstart script. So, in the following file

	/etc/event.d/local-git-daemon

you put this script:

	start on startup
	stop on shutdown
	exec /usr/bin/git daemon \
	    --user=git --group=git \
	    --reuseaddr \
	    --base-path=/opt/git/ \
	    /opt/git/
	respawn

For security reasons, it is strongly encouraged to have this daemon run as a user with read-only permissions to the repositories – you can easily do this by creating a new user 'git-ro' and running the daemon as them.  For the sake of simplicity we’ll simply run it as the same 'git' user that Gitosis is running as.

When you restart your machine, your Git daemon will start automatically and respawn if it goes down. To get it running without having to reboot, you can run this:

	initctl start local-git-daemon

On other systems, you may want to use `xinetd`, a script in your `sysvinit` system, or something else — as long as you get that command daemonized and watched somehow.

Next, you have to tell your Gitosis server which repositories to allow unauthenticated Git server-based access to. If you add a section for each repository, you can specify the ones from which you want your Git daemon to allow reading. If you want to allow Git protocol access for your iphone project, you add this to the end of the `gitosis.conf` file:

	[repo iphone_projet]
	daemon = yes

When that is committed and pushed up, your running daemon should start serving requests for the project to anyone who has access to port 9418 on your server.

If you decide not to use Gitosis, but you want to set up a Git daemon, you’ll have to run this on each project you want the Git daemon to serve:

	$ cd /path/to/project.git
	$ touch git-daemon-export-ok

The presence of that file tells Git that it’s OK to serve this project without authentication.

Gitosis can also control which projects GitWeb shows. First, you need to add something like the following to the `/etc/gitweb.conf` file:

	$projects_list = "/home/git/gitosis/projects.list";
	$projectroot = "/home/git/repositories";
	$export_ok = "git-daemon-export-ok";
	@git_base_url_list = ('git://gitserver');

You can control which projects GitWeb lets users browse by adding or removing a `gitweb` setting in the Gitosis configuration file. For instance, if you want the iphone project to show up on GitWeb, you make the `repo` setting look like this:

	[repo iphone_projet]
	daemon = yes
	gitweb = yes

Now, if you commit and push the project, GitWeb will automatically start showing your iphone project.

## Hosted Git ##

If you don’t want to go through all of the work involved in setting up your own Git server, you have several options for hosting your Git projects on an external dedicated hosting site. Doing so offers a number of advantages: a hosting site is generally quick to set up and easy to start projects on, and no server maintenance or monitoring is involved. Even if you set up and run your own server internally, you may still want to use a public hosting site for your open source code — it’s generally easier for the open source community to find and help you with.

These days, you have a huge number of hosting options to choose from, each with different advantages and disadvantages. To see an up-to-date list, check out the GitHosting page on the main Git wiki:

	http://git.or.cz/gitwiki/GitHosting

Because we can’t cover all of them, and because I happen to work at one of them, we’ll use this section to walk through setting up an account and creating a new project at GitHub. This will give you an idea of what is involved. 

GitHub is by far the largest open source Git hosting site and it’s also one of the very few that offers both public and private hosting options so you can keep your open source and private commercial code in the same place. In fact, we used GitHub to privately collaborate on this book.

### GitHub ###

GitHub is slightly different than most code-hosting sites in the way that it namespaces projects. Instead of being primarily based on the project, GitHub is user centric. That means when I host my `grit` project on GitHub, you won’t find it at `github.com/grit` but instead at `github.com/schacon/grit`. There is no canonical version of any project, which allows a project to move from one user to another seamlessly if the first author abandons the project.

GitHub is also a commercial company that charges for accounts that maintain private repositories, but anyone can quickly get a free account to host as many open source projects as they want. We’ll quickly go over how that is done.

### Setting Up a User Account ###

The first thing you need to do is set up a free user account. If you visit the Pricing and Signup page at `http://github.com/plans` and click the "Sign Up" button on the Free account (see figure 4-2), you’re taken to the signup page.

Insert 18333fig0402.png
Figure 4-2. The GitHub plan page.

Here you must choose a username that isn’t yet taken in the system and enter an e-mail address that will be associated with the account and a password (see Figure 4-3).

Insert 18333fig0403.png 
Figure 4-3. The GitHub user signup form.

If you have it available, this is a good time to add your public SSH key as well. We covered how to generate a new key earlier, in the "Simple Setups" section. Take the contents of the public key of that pair, and paste it into the SSH Public Key text box. Clicking the "explain ssh keys" link takes you to detailed instructions on how to do so on all major operating systems.
Clicking the "I agree, sign me up" button takes you to your new user dashboard (see Figure 4-4).

Insert 18333fig0404.png 
Figure 4-4. The GitHub user dashboard.

Next you can create a new repository. 

### Creating a New Repository ###

Start by clicking the "create a new one" link next to Your Repositories on the user dashboard. You’re taken to the Create a New Repository form (see Figure 4-5).

Insert 18333fig0405.png 
Figure 4-5. Creating a new repository on GitHub.

All you really have to do is provide a project name, but you can also add a description. When that is done, click the "Create Repository" button. Now you have a new repository on GitHub (see Figure 4-6).

Insert 18333fig0406.png 
Figure 4-6. GitHub project header information.

Since you have no code there yet, GitHub will show you instructions for how create a brand-new project, push an existing Git project up, or import a project from a public Subversion repository (see Figure 4-7).

Insert 18333fig0407.png 
Figure 4-7. Instructions for a new repository.

These instructions are similar to what we’ve already gone over. To initialize a project if it isn’t already a Git project, you use

	$ git init
	$ git add .
	$ git commit -m 'initial commit'

When you have a Git repository locally, add GitHub as a remote and push up your master branch:

	$ git remote add origin git@github.com:testinguser/iphone_projet.git
	$ git push origin master

Now your project is hosted on GitHub, and you can give the URL to anyone you want to share your project with. In this case, it’s `http://github.com/testinguser/iphone_projet`. You can also see from the header on each of your project’s pages that you have two Git URLs (see Figure 4-8).

Insert 18333fig0408.png 
Figure 4-8. Project header with a public URL and a private URL.

The Public Clone URL is a public, read-only Git URL over which anyone can clone the project. Feel free to give out that URL and post it on your web site or what have you.

The Your Clone URL is a read/write SSH-based URL that you can read or write over only if you connect with the SSH private key associated with the public key you uploaded for your user. When other users visit this project page, they won’t see that URL—only the public one.

### Importing from Subversion ###

If you have an existing public Subversion project that you want to import into Git, GitHub can often do that for you. At the bottom of the instructions page is a link to a Subversion import. If you click it, you see a form with information about the import process and a text box where you can paste in the URL of your public Subversion project (see Figure 4-9).

Insert 18333fig0409.png 
Figure 4-9. Subversion importing interface.

If your project is very large, nonstandard, or private, this process probably won’t work for you. In Chapter 7, you’ll learn how to do more complicated manual project imports.

### Adding Collaborators ###

Let’s add the rest of the team. If John, Josie, and Jessica all sign up for accounts on GitHub, and you want to give them push access to your repository, you can add them to your project as collaborators. Doing so will allow pushes from their public keys to work.

Click the "edit" button in the project header or the Admin tab at the top of the project to reach the Admin page of your GitHub project (see Figure 4-10).

Insert 18333fig0410.png 
Figure 4-10. GitHub administration page.

To give another user write access to your project, click the “Add another collaborator” link. A new text box appears, into which you can type a username. As you type, a helper pops up, showing you possible username matches. When you find the correct user, click the Add button to add that user as a collaborator on your project (see Figure 4-11).

Insert 18333fig0411.png 
Figure 4-11. Adding a collaborator to your project.

When you’re finished adding collaborators, you should see a list of them in the Repository Collaborators box (see Figure 4-12).

Insert 18333fig0412.png 
Figure 4-12. A list of collaborators on your project.

If you need to revoke access to individuals, you can click the "revoke" link, and their push access will be removed. For future projects, you can also copy collaborator groups by copying the permissions of an existing project.

### Your Project ###

After you push your project up or have it imported from Subversion, you have a main project page that looks something like Figure 4-13.

Insert 18333fig0413.png 
Figure 4-13. A GitHub main project page.

When people visit your project, they see this page. It contains tabs to different aspects of your projects. The Commits tab shows a list of commits in reverse chronological order, similar to the output of the `git log` command. The Network tab shows all the people who have forked your project and contributed back. The Downloads tab allows you to upload project binaries and link to tarballs and zipped versions of any tagged points in your project. The Wiki tab provides a wiki where you can write documentation or other information about your project. The Graphs tab has some contribution visualizations and statistics about your project. The main Source tab that you land on shows your project’s main directory listing and automatically renders the README file below it if you have one. This tab also shows a box with the latest commit information.

### Forking Projects ###

If you want to contribute to an existing project to which you don’t have push access, GitHub encourages forking the project. When you land on a project page that looks interesting and you want to hack on it a bit, you can click the "fork" button in the project header to have GitHub copy that project to your user so you can push to it.

This way, projects don’t have to worry about adding users as collaborators to give them push access. People can fork a project and push to it, and the main project maintainer can pull in those changes by adding them as remotes and merging in their work.

To fork a project, visit the project page (in this case, mojombo/chronic) and click the "fork" button in the header (see Figure 4-14).

Insert 18333fig0414.png 
Figure 4-14. Get a writable copy of any repository by clicking the "fork" button.

After a few seconds, you’re taken to your new project page, which indicates that this project is a fork of another one (see Figure 4-15).

Insert 18333fig0415.png 
Figure 4-15. Your fork of a project.

### GitHub Summary ###

That’s all we’ll cover about GitHub, but it’s important to note how quickly you can do all this. You can create an account, add a new project, and push to it in a matter of minutes. If your project is open source, you also get a huge community of developers who now have visibility into your project and may well fork it and help contribute to it. At the very least, this may be a way to get up and running with Git and try it out quickly.

## Summary ##

You have several options to get a remote Git repository up and running so that you can collaborate with others or share your work.

Running your own server gives you a lot of control and allows you to run the server within your own firewall, but such a server generally requires a fair amount of your time to set up and maintain. If you place your data on a hosted server, it’s easy to set up and maintain; however, you have to be able to keep your code on someone else’s servers, and some organizations don’t allow that.

It should be fairly straightforward to determine which solution or combination of solutions is appropriate for you and your organization.
