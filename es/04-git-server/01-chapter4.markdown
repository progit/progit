# Git en un servidor #

A estas alturas, podrás realizar la mayor parte de las tareas habituales trabajando con Git. Pero, para poder colaborar, necesitarás tener un repositorio remoto de Git. Aunque técnicamente es posible enviar (push) y recibir (pull) cambios directamente a o desde repositorios individuales, no es muy recomendable trabajar así por la gran facilidad de confundirte si no andas con sumo cuidado. Es más, si deseas que tus colaboradores puedan acceder a tu repositorio incluso cuando tu ordenador este apagado, puede ser de gran utilidad tener un repositorio común fiable. En este sentido, el método más recomendable para colaborar con otra persona es preparar un repositorio intermedio donde ambos tengais acceso, enviando (push) y recibiendo (pull) a o desde allí. Nos referiremos a este repositorio como "servidor Git"; pero en seguida te darás cuenta de que solo se necesitan unos pocos recursos para albergar un repositorio Git, y, por tanto, no será necesario utilizar todo un servidor entero para él.

Disponer un servidor Git es simple. Lo primero, has de elegir el/los protocolo/s que deseas para comunicarte con el servidor. La primera parte de este capítulo cubrirá la gama de protocolos disponibles, detallando los pros y contras de cada uno de ellos. Las siguientes secciones explicarán algunas de las típicas configuraciones utilizando esos protocolos, y cómo podemos poner en marcha nuestro servidor con ellos. Por último, repasaremos algunas opciones albergadas on-line; por si no te preocupa guardar tu código en servidores de terceros y no deseas enredarte preparando y manteniendo tu propio servidor.

Si este es el caso, si no tienes interés de tener tu propio servidor, puedes saltar directamente a la última sección del capítulo; donde verás algunas opciones para dar de alta una cuenta albergada. Y después puedes moverte al capítulo siguiente, donde vamos a discutir algunos de los mecanismos para trabajar en un entorno distribuido.

Un repositorio remoto es normalmente un _repositorio básico mínimo_, un repositorio Git sin carpeta de trabajo. Debido a que dicho repositorio se va a utilizar exclusivamente como un punto de colaboración, no tiene sentido el tener una instantánea de trabajo (snapshot) activa en el disco (checkout); nos basta con tener solamente los propios datos Git. Básicamente, un repositorio básico mínimo son los contenidos de la carpeta '.git', tal cual, sin nada más. 

## Los Protocolos ##

Git puede usar cuatro protocolos principales para transferir datos: Local, Secure Shell (SSH), Git y HTTP. Vamos a ver en qué consisten y las circunstancias en que querrás (o no) utilizar cada uno de ellos.

Merece destacar que, con la excepción del protocolo HTTP, todos los demás requieren que Git esté instalado y operativo en el servidor.

### Procolo Local ###

El más básico es el _Protocolo Local_, donde el repositorio remoto es simplemente otra carpeta en el disco. Se utiliza habitualmente cuando todos los miembros del equipo tienen acceso a un mismo sistema de archivos, como por ejemplo un punto de montaje NFS, o en los casos en que todos se conectan al mismo ordenador. Aunque este último caso no es precisamente el ideal, ya que todas las instancias del repositorio estarían en la misma máquina; aumentando las posibilidades de una pérdida catastrófica.

Si dispones de un sistema de archivos compartido, podrás clonar (clone), enviar (push) y recibir (pull) a/desde repositorios locales basado en archivos. Para clonar un repositorio como estos, o para añadirlo como remoto a un proyecto ya existente, usa el camino (path) del repositorio como su URL. Por ejemplo, para clonar un repositorio local, puedes usar algo como:

	$ git clone /opt/git/project.git

O como:

	$ git clone file:///opt/git/project.git

Git trabaja ligeramente distinto si indicas 'file://' de forma explícita al comienzo de la URL. Si escribes simplemente el camino, Git intentará usar enlaces rígidos (hardlinks) o copiar directamente los archivos que necesita. Si escribes con el prefijo 'file://', Git lanza el proceso que usa habitualmente para transferir datos sobre una red; proceso que suele ser mucho menos eficiente. La única razón que puedes tener para indicar expresamente el prefijo 'file://' puede ser el querer una copia limpia del repositorio, descartando referencias u objetos superfluos. Normalmente, tras haberlo importado desde otro sistema de control de versiones o algo similar (ver el Capítulo 9 sobre tareas de mantenimiento). Habitualmente, usaremos el camino (path) normal por ser casi siempre más rápido.

Para añadir un repositorio local a un proyecto Git existente, puedes usar algo como:

	$ git remote add local_proj /opt/git/project.git

Con lo que podrás enviar (push) y recibir (pull) desde dicho remoto exactamente de la misma forma a como lo harías a través de una red.

### Ventajas ###

Las ventajas de los repositorios basados en carpetas y archivos, son su simplicicidad y el aprovechamiento de los permisos preexistentes de acceso. Si tienes un sistema de archivo compartido que todo el equipo pueda usar, preparar un repositorio es muy sencillo. Simplemente pones el repositorio básico en algún lugar donde todos tengan acceso a él y ajustas los permisos de lectura/escritura según proceda, tal y como lo harías para preparar cualquier otra carpeta compartida. En la próxima sección, "Disponiendo Git en un servidor", veremos cómo exportar un repositorio básico para conseguir esto.

Este camino es también util para recuperar rápidamente el contenido del repositorio de trabajo de alguna otra persona. Si tu y otra persona estais trabajando en el mismo proyecto y ella quiere mostrarte algo, el usar un comando tal como 'git pull /home/john/project' suele ser más sencillo que el que esa persona te lo envie (push) a un servidor remoto y luego tú lo recojas (pull) desde allí.

### Desventajas ###

La principal desventaja de los repositorios basados en carpetas y archivos es su dificultad de acceso desde distintas ubicaciones. Por ejemplo, si quieres enviar (push) desde tu portátil cuando estás en casa, primero tienes que montar el disco remoto; lo cual puede ser dificil y lento, en comparación con un acceso basado en red.

Cabe destacar también que una carpeta compartida no es precisamente la opción más rápida. Un repositorio local es rápido solamente en aquellas ocasiones en que tienes un acceso rápido a él. Normalmente un repositorio sobre NFS es más lento que un repositorio SSH en el mismo servidor, asumiendo que las pruebas se hacen con Git sobre discos locales en ambos casos. 

### El Procotolo SSH ###

Probablemente, SSH sea el protocolo más habitual para Git. Debido a disponibilidad en la mayor parte de los servidores; (pero, si no lo estuviera disponible, además es sencillo habilitarlo). Por otro lado, SSH es el único protocolo de red con el que puedes facilmente tanto leer como escribir. Los otros dos protocolos de red (HTTP y Git) suelen ser normalmente protocolos de solo-lectura; de tal forma que, aunque los tengas disponibles para el público en general, sigues necesitando SSH para tu propio uso en escritura. Otra ventaja de SSH es el su mecanismo de autentificación, sencillo de habilitar y de usar.

Para clonar un repositorio a través de SSH, puedes indicar una URL ssh:// tal como:

	$ git clone ssh://user@server:project.git

O puedes prescindir del protocolo; Git asume SSH si no indicas nada expresamente: $ git clone user@server:project.git

 Pudiendo asimismo prescindir del usuario; en cuyo caso Git asume el usuario con el que estés conectado en ese momento.

### Ventajas ###

El uso de SSH tiene múltiples ventajas. En primer lugar, necesitas usarlo si quieres un acceso de escritura autentificado a tu repositorio. En segundo lugar, SSH es sencillo de habilitar. Los demonios (daemons) SSH son de uso común, muchos administradores de red tienen experiencia con ellos y muchas distribuciones del SO los traen predefinidos o tienen herramientas para gestionarlos. Además, el acceso a través de SSH es seguro, estando todas las transferencias encriptadas y autentificadas. Y, por último, al igual que los procolos Git y Local, SSH es eficiente, comprimiendo los datos lo más posible antes de transferirlos.

### Desventajas ###

El aspecto negativo de SSH es su imposibilidad para dar acceso anónimo al repositorio. Todos han de tener configurado un acceso SSH al servidor, incluso aunque sea con permisos de solo lectura; lo que no lo hace recomendable para soportar proyectos abiertos. Si lo usas únicamente dentro de tu red corporativa, posiblemente sea SSH el único procolo que tengas que emplear. Pero si quieres también habilitar accesos anónimos de solo lectura, tendrás que reservar SSH para tus envios (push) y habilitar algún otro protocolo para las recuperaciones (pull) de los demás.

### El Protocolo Git ###

El protocolo Git  es un demonio (daemon) especial, que viene incorporado con Git. Escucha por un puerto dedicado (9418), y nos da un servicio similar al del protocolo SSH; pero sin ningún tipo de autentificación. Para que un repositorio pueda exponerse a través del protocolo Git, tienes que crear en él un archivo 'git-export-daemon-ok'; sin este archivo, el demonio no hará disponible el repositorio. Pero, aparte de esto, no hay ninguna otra medida de seguridad. O el repositorio está disponible para que cualquiera lo pueda clonar, o no lo está. Lo cual significa que, normalmente, no se podrá enviar (push) a través de este protocolo. Aunque realmente si que puedes habilitar el envio, si lo haces, dada la total falta de ningún mecanismo de autentificación, cualquiera que encuentre la URL a tu proyecto en Internet, podrá enviar (push) contenidos a él. Ni que decir tiene que esto solo lo necesitarás en contadas ocasiones.

### Ventajas ###

El protocolo Git es el más rápido de todos los disponibles. Si has de servir mucho tráfico de un proyecto público o servir un proyecto muy grande, que no requiera autentificación para leer de él, un demonio Git es la respuesta. Utiliza los mismos mecanismos de transmisión de datos que el protocolo SSH, pero sin la sobrecarga de la encriptación ni de la autentificación.

### Desventajas ###

La pega del protocolo Git, es su falta de autentificación. No es recomendable tenerlo como único protocolo de acceso a tus proyectos. Habitualmente, lo combinarás con un acceso SSH para los pocos desarrolladores con acceso de escritura que envien (push) material. Usando 'git://' para los accesos solo-lectura del resto de personas.
Por otro lado, es también el protocolo más complicado de implementar. Necesita activar su propio demonio, (tal y como se explica en la sección "Gitosis", más adelante, en este capítulo); y necesita configurar 'xinetd' o similar, lo cual no suele estar siempre disponible en el sistema donde estés trabajando. Requiere además abrir expresamente acceso al puerto 9418 en el cortafuegos, ya que este no es uno de los puertos estandares que suelen estar habitualmente permitidos en los cortafuegos corporativos. Normalmente, este oscuro puerto suele estar bloqueado detrás de los cortafuegos corporativos.

### El protocolo HTTP/S ###

Por último, tenemos el protocolo HTTP.   Cuya belleza radica en la simplicidad para habilitarlo. Basta con situar el repositorio Git bajo la raiz de los documentos HTTP y preparar el enganche (hook) 'post-update' adecuado. (Ver el Capítulo 7 para detalles sobre los enganches Git.) A partir de ese momento, cualquiera con acceso al servidor web podrá clonar tu repositorio. Para permitir acceso a tu repositorio a través de HTTP, puedes hacer algo como esto:

	$ cd /var/www/htdocs/
	$ git clone --bare /path/to/git_project gitproject.git
	$ cd gitproject.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

Y eso es todo. El enganche 'post-update' que viene de serie con Git se encarga de lanzar el comando adecuado ('git update-server-info') para hacer funcionar la recuperación (fetching) y el clonado (cloning) vía HTTP. Este comando se lanza automáticamente cuando envias (push) a este repositorio vía SSh; de tal forma que otras personas puedan clonarlo usando un comando tal que:

	$ git clone http://example.com/gitproject.git

En este caso particular, estamos usando el camino '/var/www/htdocs', habitual en las configuraciones de Apache. Pero puedes utilizar cualquier servidor web estático, sin más que poner el repositorio en su camino. Los contenidos Git se sirven como archivos estáticos básicos (ver el Capitulo 9 para más detalles sobre servicios).

Es posible hacer que Git envie (push) a través de HTTP. Pero no se suele usar demasiado, ya que requiere lidiar con los complejos requerimientos de WebDAV. Y precisamente porque se usa raramente, no lo vamos a cubrir en este libro. Si estás interesado en utilizar los protocolos HTTP-push, puedes encotrar más información en  `http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt`. La utilidad de habilitar Git para enviar (push) a través de HTTP es la posibilidad de utilizar cualquier servidor WebDAV para ello, sin necesidad de requerimientos específicos para Git. De tal forma que puedes hacerlo incluso a través de tu proveedor de albergue web, si este soporta WebDAV para escribir actualizaciones en tu sitio web.

### Ventajas ###

La mejor parte del protocolo HTTP es su sencillez de preparación. Simplemente lanzando unos cuantos comandos, dispones de un método sencillo de dar al mundo entero acceso a tu repositorio Git. En tan solo unos minutos. Además, el procolo HTTP no requiere de grandes recursos en tu servidor. Por utilizar normalmente un servidor HTTP estático, un servidor Apache estandar puede con un tráfico de miles de archivos por segundo; siendo dificil de sobrecargar incluso con el más pequeño de los servidores.

Puedes también servir tus repositorios de solo lectura a través de HTTPS, teniendo así las transferencias encriptadas. O puedes ir más lejos aún, requiriendo el uso de certificados SSL específicos para cada cliente. Aunque, si pretendes ir tan lejos, es más sencillo utilizar claves públicas SSH; pero ahí está la posibilidad, por si en algún caso concreto sea mejor solución el uso de certificados SSL u otros medios de autentificación HTTP para el acceso de solo-lectura a través de HTTPS.

Otro detalle muy util de emplear HTTP, es que, al ser un protocolo de uso común, la mayoría de los cortafuegos corporativos suelen tener habilitado el tráfico a traves de este puerto.

### Desventajas ###

La pega de servir un repositorio a través de HTTP es su relativa ineficiencia para el cliente. Suele requerir mucho más tiempo el clonar o el recuperar (fetch), debido a la mayor carga de procesamiento y  al mayor volumen de transferencia que se da sobre HTTP respecto de otros protocolos de red. Y precisamente por esto, porque no es tan inteligente y no transfiere solamente los datos imprescindibles, (no hay un trabajo dinámico por parte del servidor), el protocolo HTTP suele ser conocido como el protocolo _estúpido_. Para más información sobre diferencias de eficiencia entre el protocolo HTTP y los otros protocolos, ver el Capítulo 9.

## Getting Git on a Server ##

In order to initially set up any Git server, you have to export an existing repository into a new bare repository — a repository that doesn’t contain a working directory. This is generally straightforward to do.
In order to clone your repository to create a new bare repository, you run the clone command with the `--bare` option. By convention, bare repository directories end in `.git`, like so:

	$ git clone --bare my_project my_project.git
	Initialized empty Git repository in /opt/projects/my_project.git/

The output for this command is a little confusing. Since `clone` is basically a `git init` then a `git fetch`, we see some output from the `git init` part, which creates an empty directory. The actual object transfer gives no output, but it does happen. You should now have a copy of the Git directory data in your `my_project.git` directory.

This is roughly equivalent to something like

	$ cp -Rf my_project/.git my_project.git

There are a couple of minor differences in the configuration file; but for your purpose, this is close to the same thing. It takes the Git repository by itself, without a working directory, and creates a directory specifically for it alone.

### Putting the Bare Repository on a Server ###

Now that you have a bare copy of your repository, all you need to do is put it on a server and set up your protocols. Let’s say you’ve set up a server called `git.example.com` that you have SSH access to, and you want to store all your Git repositories under the `/opt/git` directory. You can set up your new repository by copying your bare repository over:

	$ scp -r my_project.git user@git.example.com:/opt/git

At this point, other users who have SSH access to the same server which has read-access to the `/opt/git` directory can clone your repository by running

	$ git clone user@git.example.com:/opt/git/my_project.git

If a user SSHs into a server and has write access to the `/opt/git/my_project.git` directory, they will also automatically have push access.  Git will automatically add group write permissions to a repository properly if you run the `git init` command with the `--shared` option.

	$ ssh user@git.example.com
	$ cd /opt/git/my_project.git
	$ git init --bare --shared

You see how easy it is to take a Git repository, create a bare version, and place it on a server to which you and your collaborators have SSH access. Now you’re ready to collaborate on the same project.

It’s important to note that this is literally all you need to do to run a useful Git server to which several people have access — just add SSH-able accounts on a server, and stick a bare repository somewhere that all those users have read and write access to. You’re ready to go — nothing else needed.

In the next few sections, you’ll see how to expand to more sophisticated setups. This discussion will include not having to create user accounts for each user, adding public read access to repositories, setting up web UIs, using the Gitosis tool, and more. However, keep in mind that to collaborate with a couple of people on a private project, all you _need_ is an SSH server and a bare repository.

### Small Setups ###

If you’re a small outfit or are just trying out Git in your organization and have only a few developers, things can be simple for you. One of the most complicated aspects of setting up a Git server is user management. If you want some repositories to be read-only to certain users and read/write to others, access and permissions can be a bit difficult to arrange.

#### SSH Access ####

If you already have a server to which all your developers have SSH access, it’s generally easiest to set up your first repository there, because you have to do almost no work (as we covered in the last section). If you want more complex access control type permissions on your repositories, you can handle them with the normal filesystem permissions of the operating system your server runs.

If you want to place your repositories on a server that doesn’t have accounts for everyone on your team whom you want to have write access, then you must set up SSH access for them. We assume that if you have a server with which to do this, you already have an SSH server installed, and that’s how you’re accessing the server.

There are a few ways you can give access to everyone on your team. The first is to set up accounts for everybody, which is straightforward but can be cumbersome. You may not want to run `adduser` and set temporary passwords for every user.

A second method is to create a single 'git' user on the machine, ask every user who is to have write access to send you an SSH public key, and add that key to the `~/.ssh/authorized_keys` file of your new 'git' user. At that point, everyone will be able to access that machine via the 'git' user. This doesn’t affect the commit data in any way — the SSH user you connect as doesn’t affect the commits you’ve recorded.

Another way to do it is to have your SSH server authenticate from an LDAP server or some other centralized authentication source that you may already have set up. As long as each user can get shell access on the machine, any SSH authentication mechanism you can think of should work.

## Generating Your SSH Public Key ##

That being said, many Git servers authenticate using SSH public keys. In order to provide a public key, each user in your system must generate one if they don’t already have one. This process is similar across all operating systems.
First, you should check to make sure you don’t already have a key. By default, a user’s SSH keys are stored in that user’s `~/.ssh` directory. You can easily check to see if you have a key already by going to that directory and listing the contents:

	$ cd ~/.ssh
	$ ls
	authorized_keys2  id_dsa       known_hosts
	config            id_dsa.pub

You’re looking for a pair of files named something and something.pub, where the something is usually `id_dsa` or `id_rsa`. The `.pub` file is your public key, and the other file is your private key. If you don’t have these files (or you don’t even have a `.ssh` directory), you can create them by running a program called `ssh-keygen`, which is provided with the SSH package on Linux/Mac systems and comes with the MSysGit package on Windows:

	$ ssh-keygen 
	Generating public/private rsa key pair.
	Enter file in which to save the key (/Users/schacon/.ssh/id_rsa): 
	Enter passphrase (empty for no passphrase): 
	Enter same passphrase again: 
	Your identification has been saved in /Users/schacon/.ssh/id_rsa.
	Your public key has been saved in /Users/schacon/.ssh/id_rsa.pub.
	The key fingerprint is:
	43:c5:5b:5f:b1:f1:50:43:ad:20:a6:92:6a:1f:9a:3a schacon@agadorlaptop.local

First it confirms where you want to save the key (`.ssh/id_rsa`), and then it asks twice for a passphrase, which you can leave empty if you don’t want to type a password when you use the key.

Now, each user that does this has to send their public key to you or whoever is administrating the Git server (assuming you’re using an SSH server setup that requires public keys). All they have to do is copy the contents of the `.pub` file and e-mail it. The public keys look something like this:

	$ cat ~/.ssh/id_rsa.pub 
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU
	GPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3
	Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XA
	t3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/En
	mZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbx
	NrRFi9wrf+M7Q== schacon@agadorlaptop.local

For a more in-depth tutorial on creating an SSH key on multiple operating systems, see the GitHub guide on SSH keys at `http://github.com/guides/providing-your-ssh-key`.

## Setting Up the Server ##

Let’s walk through setting up SSH access on the server side. In this example, you’ll use the `authorized_keys` method for authenticating your users. We also assume you’re running a standard Linux distribution like Ubuntu. First, you create a 'git' user and a `.ssh` directory for that user.

	$ sudo adduser git
	$ su git
	$ cd
	$ mkdir .ssh

Next, you need to add some developer SSH public keys to the `authorized_keys` file for that user. Let’s assume you’ve received a few keys by e-mail and saved them to temporary files. Again, the public keys look something like this:

	$ cat /tmp/id_rsa.john.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCB007n/ww+ouN4gSLKssMxXnBOvf9LGt4L
	ojG6rs6hPB09j9R/T17/x4lhJA0F3FR1rP6kYBRsWj2aThGw6HXLm9/5zytK6Ztg3RPKK+4k
	Yjh6541NYsnEAZuXz0jTTyAUfrtU3Z5E003C4oxOj6H0rfIF1kKI9MAQLMdpGW1GYEIgS9Ez
	Sdfd8AcCIicTDWbqLAcU4UpkaX8KyGlLwsNuuGztobF8m72ALC/nLF6JLtPofwFBlgc+myiv
	O7TCUSBdLQlgMVOFq1I2uPWQOkOWQAHukEOmfjy2jctxSDBQ220ymjaNsHT4kgtZg2AYYgPq
	dAv8JggJICUvax2T9va5 gsg-keypair

You just append them to your `authorized_keys` file:

	$ cat /tmp/id_rsa.john.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.josie.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.jessica.pub >> ~/.ssh/authorized_keys

Now, you can set up an empty repository for them by running `git init` with the `--bare` option, which initializes the repository without a working directory:

	$ cd /opt/git
	$ mkdir project.git
	$ cd project.git
	$ git --bare init

Then, John, Josie, or Jessica can push the first version of their project into that repository by adding it as a remote and pushing up a branch. Note that someone must shell onto the machine and create a bare repository every time you want to add a project. Let’s use `gitserver` as the hostname of the server on which you’ve set up your 'git' user and repository. If you’re running it internally, and you set up DNS for `gitserver` to point to that server, then you can use the commands pretty much as is:

	# on Johns computer
	$ cd myproject
	$ git init
	$ git add .
	$ git commit -m 'initial commit'
	$ git remote add origin git@gitserver:/opt/git/project.git
	$ git push origin master

At this point, the others can clone it down and push changes back up just as easily:

	$ git clone git@gitserver:/opt/git/project.git
	$ vim README
	$ git commit -am 'fix for the README file'
	$ git push origin master

With this method, you can quickly get a read/write Git server up and running for a handful of developers.

As an extra precaution, you can easily restrict the 'git' user to only doing Git activities with a limited shell tool called `git-shell` that comes with Git. If you set this as your 'git' user’s login shell, then the 'git' user can’t have normal shell access to your server. To use this, specify `git-shell` instead of bash or csh for your user’s login shell. To do so, you’ll likely have to edit your `/etc/passwd` file:

	$ sudo vim /etc/passwd

At the bottom, you should find a line that looks something like this:

	git:x:1000:1000::/home/git:/bin/sh

Change `/bin/sh` to `/usr/bin/git-shell` (or run `which git-shell` to see where it’s installed). The line should look something like this:

	git:x:1000:1000::/home/git:/usr/bin/git-shell

Now, the 'git' user can only use the SSH connection to push and pull Git repositories and can’t shell onto the machine. If you try, you’ll see a login rejection like this:

	$ ssh git@gitserver
	fatal: What do you think I am? A shell?
	Connection to gitserver closed.

## Public Access ##

What if you want anonymous read access to your project? Perhaps instead of hosting an internal private project, you want to host an open source project. Or maybe you have a bunch of automated build servers or continuous integration servers that change a lot, and you don’t want to have to generate SSH keys all the time — you just want to add simple anonymous read access.

Probably the simplest way for smaller setups is to run a static web server with its document root where your Git repositories are, and then enable that `post-update` hook we mentioned in the first section of this chapter. Let’s work from the previous example. Say you have your repositories in the `/opt/git` directory, and an Apache server is running on your machine. Again, you can use any web server for this; but as an example, we’ll demonstrate some basic Apache configurations that should give you an idea of what you might need.

First you need to enable the hook:

	$ cd project.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

If you’re using a version of Git earlier than 1.6, the `mv` command isn’t necessary — Git started naming the hooks examples with the .sample postfix only recently. 

What does this `post-update` hook do? It looks basically like this:

	$ cat .git/hooks/post-update 
	#!/bin/sh
	exec git-update-server-info

This means that when you push to the server via SSH, Git will run this command to update the files needed for HTTP fetching.

Next, you need to add a VirtualHost entry to your Apache configuration with the document root as the root directory of your Git projects. Here, we’re assuming that you have wildcard DNS set up to send `*.gitserver` to whatever box you’re using to run all this:

	<VirtualHost *:80>
	    ServerName git.gitserver
	    DocumentRoot /opt/git
	    <Directory /opt/git/>
	        Order allow, deny
	        allow from all
	    </Directory>
	</VirtualHost>

You’ll also need to set the Unix user group of the `/opt/git` directories to `www-data` so your web server can read-access the repositories, because the Apache instance running the CGI script will (by default) be running as that user:

	$ chgrp -R www-data /opt/git

When you restart Apache, you should be able to clone your repositories under that directory by specifying the URL for your project:

	$ git clone http://git.gitserver/project.git

This way, you can set up HTTP-based read access to any of your projects for a fair number of users in a few minutes. Another simple option for public unauthenticated access is to start a Git daemon, although that requires you to daemonize the process - we’ll cover this option in the next section, if you prefer that route.

## GitWeb ##

Now that you have basic read/write and read-only access to your project, you may want to set up a simple web-based visualizer. Git comes with a CGI script called GitWeb that is commonly used for this. You can see GitWeb in use at sites like `http://git.kernel.org` (see Figure 4-1).

Insert 18333fig0401.png 
Figure 4-1. The GitWeb web-based user interface.

If you want to check out what GitWeb would look like for your project, Git comes with a command to fire up a temporary instance if you have a lightweight server on your system like `lighttpd` or `webrick`. On Linux machines, `lighttpd` is often installed, so you may be able to get it to run by typing `git instaweb` in your project directory. If you’re running a Mac, Leopard comes preinstalled with Ruby, so `webrick` may be your best bet. To start `instaweb` with a non-lighttpd handler, you can run it with the `--httpd` option.

	$ git instaweb --httpd=webrick
	[2009-02-21 10:02:21] INFO  WEBrick 1.3.1
	[2009-02-21 10:02:21] INFO  ruby 1.8.6 (2008-03-03) [universal-darwin9.0]

That starts up an HTTPD server on port 1234 and then automatically starts a web browser that opens on that page. It’s pretty easy on your part. When you’re done and want to shut down the server, you can run the same command with the `--stop` option:

	$ git instaweb --httpd=webrick --stop

If you want to run the web interface on a server all the time for your team or for an open source project you’re hosting, you’ll need to set up the CGI script to be served by your normal web server. Some Linux distributions have a `gitweb` package that you may be able to install via `apt` or `yum`, so you may want to try that first. We’ll walk though installing GitWeb manually very quickly. First, you need to get the Git source code, which GitWeb comes with, and generate the custom CGI script:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/
	$ make GITWEB_PROJECTROOT="/opt/git" \
	        prefix=/usr gitweb/gitweb.cgi
	$ sudo cp -Rf gitweb /var/www/

Notice that you have to tell the command where to find your Git repositories with the `GITWEB_PROJECTROOT` variable. Now, you need to make Apache use CGI for that script, for which you can add a VirtualHost:

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

Again, GitWeb can be served with any CGI capable web server; if you prefer to use something else, it shouldn’t be difficult to set up. At this point, you should be able to visit `http://gitserver/` to view your repositories online, and you can use `http://git.gitserver` to clone and fetch your repositories over HTTP.

## Gitosis ##

Keeping all users’ public keys in the `authorized_keys` file for access works well only for a while. When you have hundreds of users, it’s much more of a pain to manage that process. You have to shell onto the server each time, and there is no access control — everyone in the file has read and write access to every project.

At this point, you may want to turn to a widely used software project called Gitosis. Gitosis is basically a set of scripts that help you manage the `authorized_keys` file as well as implement some simple access controls. The really interesting part is that the UI for this tool for adding people and determining access isn’t a web interface but a special Git repository. You set up the information in that project; and when you push it, Gitosis reconfigures the server based on that, which is cool.

Installing Gitosis isn’t the simplest task ever, but it’s not too difficult. It’s easiest to use a Linux server for it — these examples use a stock Ubuntu 8.10 server.

Gitosis requires some Python tools, so first you have to install the Python setuptools package, which Ubuntu provides as python-setuptools:

	$ apt-get install python-setuptools

Next, you clone and install Gitosis from the project’s main site:

	$ git clone git://eagain.net/gitosis.git
	$ cd gitosis
	$ sudo python setup.py install

That installs a couple of executables that Gitosis will use. Next, Gitosis wants to put its repositories under `/home/git`, which is fine. But you have already set up your repositories in `/opt/git`, so instead of reconfiguring everything, you create a symlink:

	$ ln -s /opt/git /home/git/repositories

Gitosis is going to manage your keys for you, so you need to remove the current file, re-add the keys later, and let Gitosis control the `authorized_keys` file automatically. For now, move the `authorized_keys` file out of the way:

	$ mv /home/git/.ssh/authorized_keys /home/git/.ssh/ak.bak

Next you need to turn your shell back on for the 'git' user, if you changed it to the `git-shell` command. People still won’t be able to log in, but Gitosis will control that for you. So, let’s change this line in your `/etc/passwd` file

	git:x:1000:1000::/home/git:/usr/bin/git-shell

back to this:

	git:x:1000:1000::/home/git:/bin/sh

Now it’s time to initialize Gitosis. You do this by running the `gitosis-init` command with your personal public key. If your public key isn’t on the server, you’ll have to copy it there:

	$ sudo -H -u git gitosis-init < /tmp/id_dsa.pub
	Initialized empty Git repository in /opt/git/gitosis-admin.git/
	Reinitialized existing Git repository in /opt/git/gitosis-admin.git/

This lets the user with that key modify the main Git repository that controls the Gitosis setup. Next, you have to manually set the execute bit on the `post-update` script for your new control repository.

	$ sudo chmod 755 /opt/git/gitosis-admin.git/hooks/post-update

You’re ready to roll. If you’re set up correctly, you can try to SSH into your server as the user for which you added the public key to initialize Gitosis. You should see something like this:

	$ ssh git@gitserver
	PTY allocation request failed on channel 0
	fatal: unrecognized command 'gitosis-serve schacon@quaternion'
	  Connection to gitserver closed.

That means Gitosis recognized you but shut you out because you’re not trying to do any Git commands. So, let’s do an actual Git command — you’ll clone the Gitosis control repository:

	# on your local computer
	$ git clone git@gitserver:gitosis-admin.git

Now you have a directory named `gitosis-admin`, which has two major parts:

	$ cd gitosis-admin
	$ find .
	./gitosis.conf
	./keydir
	./keydir/scott.pub

The `gitosis.conf` file is the control file you use to specify users, repositories, and permissions. The `keydir` directory is where you store the public keys of all the users who have any sort of access to your repositories — one file per user. The name of the file in `keydir` (in the previous example, `scott.pub`) will be different for you — Gitosis takes that name from the description at the end of the public key that was imported with the `gitosis-init` script.

If you look at the `gitosis.conf` file, it should only specify information about the `gitosis-admin` project that you just cloned:

	$ cat gitosis.conf 
	[gitosis]

	[group gitosis-admin]
	writable = gitosis-admin
	members = scott

It shows you that the 'scott' user — the user with whose public key you initialized Gitosis — is the only one who has access to the `gitosis-admin` project.

Now, let’s add a new project for you. You’ll add a new section called `mobile` where you’ll list the developers on your mobile team and projects that those developers need access to. Because 'scott' is the only user in the system right now, you’ll add him as the only member, and you’ll create a new project called `iphone_project` to start on:

	[group mobile]
	writable = iphone_project
	members = scott

Whenever you make changes to the `gitosis-admin` project, you have to commit the changes and push them back up to the server in order for them to take effect:

	$ git commit -am 'add iphone_project and mobile group'
	[master]: created 8962da8: "changed name"
	 1 files changed, 4 insertions(+), 0 deletions(-)
	$ git push
	Counting objects: 5, done.
	Compressing objects: 100% (2/2), done.
	Writing objects: 100% (3/3), 272 bytes, done.
	Total 3 (delta 1), reused 0 (delta 0)
	To git@gitserver:/opt/git/gitosis-admin.git
	   fb27aec..8962da8  master -> master

You can make your first push to the new `iphone_project` project by adding your server as a remote to your local version of the project and pushing. You no longer have to manually create a bare repository for new projects on the server — Gitosis creates them automatically when it sees the first push:

	$ git remote add origin git@gitserver:iphone_project.git
	$ git push origin master
	Initialized empty Git repository in /opt/git/iphone_project.git/
	Counting objects: 3, done.
	Writing objects: 100% (3/3), 230 bytes, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:iphone_project.git
	 * [new branch]      master -> master

Notice that you don’t need to specify the path (in fact, doing so won’t work), just a colon and then the name of the project — Gitosis finds it for you.

You want to work on this project with your friends, so you’ll have to re-add their public keys. But instead of appending them manually to the `~/.ssh/authorized_keys` file on your server, you’ll add them, one key per file, into the `keydir` directory. How you name the keys determines how you refer to the users in the `gitosis.conf` file. Let’s re-add the public keys for John, Josie, and Jessica:

	$ cp /tmp/id_rsa.john.pub keydir/john.pub
	$ cp /tmp/id_rsa.josie.pub keydir/josie.pub
	$ cp /tmp/id_rsa.jessica.pub keydir/jessica.pub

Now you can add them all to your 'mobile' team so they have read and write access to `iphone_project`:

	[group mobile]
	writable = iphone_project
	members = scott john josie jessica

After you commit and push that change, all four users will be able to read from and write to that project.

Gitosis has simple access controls as well. If you want John to have only read access to this project, you can do this instead:

	[group mobile]
	writable = iphone_project
	members = scott josie jessica

	[group mobile_ro]
	readonly = iphone_project
	members = john

Now John can clone the project and get updates, but Gitosis won’t allow him to push back up to the project. You can create as many of these groups as you want, each containing different users and projects. You can also specify another group as one of the members (using `@` as prefix), to inherit all of its members automatically:

	[group mobile_committers]
	members = scott josie jessica

	[group mobile]
	writable  = iphone_project
	members   = @mobile_committers

	[group mobile_2]
	writable  = another_iphone_project
	members   = @mobile_committers john

If you have any issues, it may be useful to add `loglevel=DEBUG` under the `[gitosis]` section. If you’ve lost push access by pushing a messed-up configuration, you can manually fix the file on the server under `/home/git/.gitosis.conf` — the file from which Gitosis reads its info. A push to the project takes the `gitosis.conf` file you just pushed up and sticks it there. If you edit that file manually, it remains like that until the next successful push to the `gitosis-admin` project.

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

	[repo iphone_project]
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

	[repo iphone_project]
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

	$ git remote add origin git@github.com:testinguser/iphone_project.git
	$ git push origin master

Now your project is hosted on GitHub, and you can give the URL to anyone you want to share your project with. In this case, it’s `http://github.com/testinguser/iphone_project`. You can also see from the header on each of your project’s pages that you have two Git URLs (see Figure 4-8).

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

## Recapitulación ##

You have several options to get a remote Git repository up and running so that you can collaborate with others or share your work.

Running your own server gives you a lot of control and allows you to run the server within your own firewall, but such a server generally requires a fair amount of your time to set up and maintain. If you place your data on a hosted server, it’s easy to set up and maintain; however, you have to be able to keep your code on someone else’s servers, and some organizations don’t allow that.

It should be fairly straightforward to determine which solution or combination of solutions is appropriate for you and your organization.
