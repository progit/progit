# Git en un servidor #

A estas alturas, ya podrás realizar la mayor parte de las tareas habituales trabajando con Git. Pero, para poder colaborar, necesitarás tener un repositorio remoto de Git. Aunque técnicamente es posible enviar (push) y recibir (pull) cambios directamente a o desde repositorios individuales, no es muy recomendable trabajar así por la gran facilidad de confundirte si no andas con sumo cuidado. Es más, si deseas que tus colaboradores puedan acceder a tu repositorio, incluso cuando tu ordenador este apagado, puede ser de gran utilidad disponer de un repositorio común fiable. En este sentido, el método más recomendable para colaborar con otra persona es preparar un repositorio intermedio donde ambos tengais acceso, enviando (push) y recibiendo (pull) a o desde allí. Nos referiremos a este repositorio como "servidor Git"; pero en seguida te darás cuenta de que solo se necesitan unos pocos recursos para albergar un repositorio Git, y, por tanto, no será necesario utilizar todo un servidor entero para él.

Disponer un servidor Git es simple. Lo primero, has de elegir el/los protocolo/s que deseas para comunicarte con el servidor. La primera parte de este capítulo cubrirá la gama de protocolos disponibles, detallando los pros y contras de cada uno de ellos. Las siguientes secciones explicarán algunas de las típicas configuraciones utilizando esos protocolos, y cómo podemos poner en marcha nuestro servidor con ellos. Por último, repasaremos algunas opciones albergadas on-line; por si no te preocupa guardar tu código en servidores de terceros y no deseas enredarte preparando y manteniendo tu propio servidor.

Si este es el caso, si no tienes interés de tener tu propio servidor, puedes saltar directamente a la última sección del capítulo; donde verás algunas opciones para dar de alta una cuenta albergada. Y después puedes moverte al capítulo siguiente, donde vamos a discutir algunos de los mecanismos para trabajar en un entorno distribuido.

Un repositorio remoto es normalmente un _repositorio básico mínimo_, un repositorio Git sin carpeta de trabajo. Debido a que dicho repositorio se va a utilizar exclusivamente como un punto de colaboración, no tiene sentido el tener una instantánea de trabajo (snapshot) activa en el disco (checkout); nos basta con tener solamente los propios datos Git. Básicamente, un repositorio básico mínimo son los contenidos de la carpeta '.git', tal cual, sin nada más. 

## Los Protocolos ##

Git puede usar cuatro protocolos principales para transferir datos: Local, Secure Shell (SSH), Git y HTTP. Vamos a ver en qué consisten y las circunstancias en que querrás (o no) utilizar cada uno de ellos.

Merece destacar que, con la excepción del protocolo HTTP, todos los demás protocolos requieren que Git esté instalado y operativo en el servidor.

### Protocolo Local ###

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

	$ git clone ssh://user@server/project.git

O puedes prescindir del protocolo; Git asume SSH si no indicas nada expresamente: $ git clone user@server:project.git

 Pudiendo asimismo prescindir del usuario; en cuyo caso Git asume el usuario con el que estés conectado en ese momento.

### Ventajas ###

El uso de SSH tiene múltiples ventajas. En primer lugar, necesitas usarlo si quieres un acceso de escritura autentificado a tu repositorio. En segundo lugar, SSH es sencillo de habilitar. Los demonios (daemons) SSH son de uso común, muchos administradores de red tienen experiencia con ellos y muchas distribuciones del SO los traen predefinidos o tienen herramientas para gestionarlos. Además, el acceso a través de SSH es seguro, estando todas las transferencias encriptadas y autentificadas. Y, por último, al igual que los procolos Git y Local, SSH es eficiente, comprimiendo los datos lo más posible antes de transferirlos.

### Desventajas ###

El aspecto negativo de SSH es su imposibilidad para dar acceso anónimo al repositorio. Todos han de tener configurado un acceso SSH al servidor, incluso aunque sea con permisos de solo lectura; lo que no lo hace recomendable para soportar proyectos abiertos. Si lo usas únicamente dentro de tu red corporativa, posiblemente sea SSH el único procolo que tengas que emplear. Pero si quieres también habilitar accesos anónimos de solo lectura, tendrás que reservar SSH para tus envios (push) y habilitar algún otro protocolo para las recuperaciones (pull) de los demás.

### El Protocolo Git ###

El protocolo Git  es un demonio (daemon) especial, que viene incorporado con Git. Escucha por un puerto dedicado (9418), y nos da un servicio similar al del protocolo SSH; pero sin ningún tipo de autentificación. Para que un repositorio pueda exponerse a través del protocolo Git, tienes que crear en él un archivo 'git-daemon-export-ok'; sin este archivo, el demonio no hará disponible el repositorio. Pero, aparte de esto, no hay ninguna otra medida de seguridad. O el repositorio está disponible para que cualquiera lo pueda clonar, o no lo está. Lo cual significa que, normalmente, no se podrá enviar (push) a través de este protocolo. Aunque realmente si que puedes habilitar el envio, si lo haces, dada la total falta de ningún mecanismo de autentificación, cualquiera que encuentre la URL a tu proyecto en Internet, podrá enviar (push) contenidos a él. Ni que decir tiene que esto solo lo necesitarás en contadas ocasiones.

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

## Poniendo Git en un Servidor ##

El primer paso para preparar un servidor Git, es exportar un repositorio existente a un nuevo repositorio básico, a un repositorio sin carpeta de trabajo. Normalmente suele ser sencillo.
Tan solo has de utilizar el comando 'clone' con la opción '--bare'. Por convenio, los nombres de los repositorios básicos suelen terminar en '.git', por lo que lanzaremos:

	$ git clone --bare my_project my_project.git
	Initialized empty Git repository in /opt/projects/my_project.git/

El resultado de este comando es un poco confuso. Como 'clone' es fundamentalmente un 'git init' seguido de un 'git fetch', veremos algunos de los mensajes de la parte 'init', concretamente de la parte en que se crea una carpeta vacia. La copia de objetos no da ningún mensaje, pero también se realiza. Tras esto, tendrás una copia de los datos en tu carpeta 'my_project.git'.

Siendo el proceso mas o menos equivalente a haber realizado:

	$ cp -Rf my_project/.git my_project.git

Realmente hay un par de pequeñas diferencias en el archivo de configuración; pero, a efectos prácticos es casi lo mismo. Se coge el repositorio Git en sí mismo, sin la carpeta de trabajo, y se crea una copia en una nueva carpeta específica para él solo.

### Poniendo el repositorio básico en un servidor ###

Ahora que ya tienes una copia básica de tu repositorio, todo lo que te resta por hacer es colocarlo en un servidor y ajustar los protocolos. Supongamos que has preparado un servidor denominado 'git.example.com', con acceso SSH. Y que quieres guardar todos los repositorios Git bajo la carpeta '/opt/git'. Puedes colocar tu nuevo repositorio simplemente copiandolo:

	$ scp -r my_project.git user@git.example.com:/opt/git

A partir de entonces, cualquier otro usuario con acceso de lectura SSH a la carpeta '/opt/git' del servidor, podrá clonar el repositorio con la orden:

	$ git clone user@git.example.com:/opt/git/my_project.git

Y cualquier usuario SSH que tenga acceso de escritura a la carpeta '/opt/git/my_project.git', tendrá también automáticamente acceso de volcado (push).  Git añadirá automáticamente permisos de escritura al grupo sobre cualquier repositorio donde lances el comando 'git init' con la opción '--shared'.

	$ ssh user@git.example.com
	$ cd /opt/git/my_project.git
	$ git init --bare --shared

Como se vé, es sencillo crear un repositorio básico a partir de un repositorio Git, y ponerlo en un servidor donde tanto tú como tus colaboradores tengais acceso SSH. Ahora ya estás preparado para trabajar con ellos en el proyecto común.

Es importante destacar que esto es, literalmente, todo lo necesario para preparar un servidor Git compartido. Habilitar unas cuantas cuentas SSH en un servidor; colocar un repositorio básico en algún lugar donde esos usuarios tengan acceso de lectura/escritura; y.... ¡listo!, eso es todo lo que necesitas.

En los siguientes apartados, se mostrará como ir más allá y preparar disposiciones más sofisticadas. Incluyendo temas tales como el evitar crear cuentas para cada usuario, el añadir acceso público de lectura, el disponer interfaces de usuario web, el usar la herramienta Gitosis, y mucho más. Pero, ten presente que para colaborar con un pequeño grupo de personas en un proyecto privado, todo lo que necesitas es un servidor SSH y un repositorio básico.

### Pequeños despliegues ###

Si tienes un proyecto reducido o estás simplemente probando Git en tu empresa y sois unos pocos desarrolladores, el despliegue será sencillo. Porque la gestión de usuarios es precisamente uno de los aspectos más complicados de preparar un servidor Git. En caso de requerir varios repositorios de solo lectura para ciertos usuarios y de lectura/escritura para otros, preparar el acceso y los permisos puede dar bastante trabajo.

#### Acceso SSH ####

Si ya dispones de un servidor donde todos los desarrolladores tengan acceso SSH, te será facil colocar los repositorios en él (tal y como se verá en el próximo apartado). En caso de que necesites un control más complejo y fino sobre cada repositorio, puedes manejarlos a través de los permisos estandar del sistema de archivos.

Si deseas colocar los repositorios en un servidor donde no todas las personas de tu equipo tengan cuentas de acceso, tendrás que dar acceso SSH a aquellas que no lo tengan. Suponiendo que ya tengas el servidor, que el servicio SSH esté instalado y que sea esa la vía de acceso que tú estés utilizando para acceder a él.

Tienes varias maneras para dar acceso a todos los miembros de tu equipo. La primera forma es el habilitar cuentas para todos; es la manera más directa, pero también la más laboriosa. Ya que tendrias que lanzar el comando 'adduser' e inventarte contraseñas temporales para cada uno.

La segunda forma es el crear un solo usuario 'git' en la máquina y solicitar a cada persona que te envie una clave pública SSH, para que puedas añadirlas al archivo  `~/.ssh/authorized_keys` de dicho usuario 'git'. De esta forma, todos pueden acceder a la máquina a través del usuario 'git'. Esto no afecta a los datos de las confirmaciones (commit), ya que el usuario SSH con el que te conectes no es relevante para las confirmaciones de cambios que registres.

Y una tercera forma es el preparar un servidor SSH autenficado desde un servidor LDAP o desde alguna otra fuente de autenficación externa ya disponible. Tan solo con que cada usuario pueda tener acceso al shell de la máquina, es válido cualquier mecanismo de autentificación SSH que se emplee para ello.

## Generando tu clave pública SSH ##

Tal y como se ha comentado, muchos servidores Git utilizan la autentificación a través de claves públicas SSH. Y, para ello, cada usuario del sistema ha de generarse una, si es que no la tiene ya. El proceso para hacerlo es similar en casi cualquier sistema operativo.
Ante todo,  asegurarte que no tengas ya una clave. Por defecto, las claves de cualquier usuario SSH se guardan en la carpeta `~/.ssh` de dicho usuario. Puedes verificar si tienes ya unas claves, simplemente situandote sobre dicha carpeta y viendo su contenido:

	$ cd ~/.ssh
	$ ls
	authorized_keys2  id_dsa       known_hosts
	config            id_dsa.pub

Has de buscar un par de archivos con nombres tales como 'algo' y 'algo.pub'; siendo ese "algo" normalmente 'id_dsa' o 'id_rsa'. El archivo terminado en '.pub' es tu clave pública, y el otro archivo es tu clave privada. Si no tienes esos archivos (o no tienes ni siquiera la carpeta '.ssh'), has de crearlos; utilizando un programa llamado 'ssh-keygen', que viene incluido en el paquete SSH de los sistemas Linux/Mac o en el paquete MSysGit en los sistemas Windows:

	$ ssh-keygen 
	Generating public/private rsa key pair.
	Enter file in which to save the key (/Users/schacon/.ssh/id_rsa): 
	Enter passphrase (empty for no passphrase): 
	Enter same passphrase again: 
	Your identification has been saved in /Users/schacon/.ssh/id_rsa.
	Your public key has been saved in /Users/schacon/.ssh/id_rsa.pub.
	The key fingerprint is:
	43:c5:5b:5f:b1:f1:50:43:ad:20:a6:92:6a:1f:9a:3a schacon@agadorlaptop.local

Como se vé, este comando primero solicita confirmación de dónde van a a guardarse las claves ('.ssh/id_rsa'), y luego solicita, dos veces, una contraseña (passphrase), contraseña que puedes dejar en blanco si no deseas tener que teclearla cada vez que uses la clave.

Tras generarla, cada usuario ha de encargarse de enviar su clave pública a quienquiera que administre el servidor Git (en el caso de que este esté configurado con SSH y así lo requiera). Esto se puede realizar simplemente copiando los contenidos del archivo terminado en '.pub' y enviandoselos por correo electrónico. La clave pública será una serie de números, letras y signos, algo así como esto:

	$ cat ~/.ssh/id_rsa.pub 
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU
	GPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3
	Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XA
	t3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/En
	mZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbx
	NrRFi9wrf+M7Q== schacon@agadorlaptop.local

Para más detalles sobre cómo crear unas claves SSH en variados sistemas operativos, consultar la correspondiente guia en GitHub:  `http://github.com/guides/providing-your-ssh-key`.

## Preparando el servidor ##

Vamos a avanzar en los ajustes de los accesos SSH en el lado del servidor. En este ejemplo, usarás el método de las 'claves autorizadas' para autentificar a tus usuarios. Se asume que tienes un servidor en marcha, con una distribución estandar de Linux, tal como Ubuntu. Comienzas creando un usuario 'git' y una carpeta '.ssh' para él.

	$ sudo adduser git
	$ su git
	$ cd
	$ mkdir .ssh

Y a continuación añades las claves públicas de los desarrolladores al archivo 'autorized_keys' del usuario 'git' que has creado. Suponiendo que hayas recibido las claves por correo electrónico y que las has guardado en archivos temporales. Y recordando que las claves públicas son algo así como:

	$ cat /tmp/id_rsa.john.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCB007n/ww+ouN4gSLKssMxXnBOvf9LGt4L
	ojG6rs6hPB09j9R/T17/x4lhJA0F3FR1rP6kYBRsWj2aThGw6HXLm9/5zytK6Ztg3RPKK+4k
	Yjh6541NYsnEAZuXz0jTTyAUfrtU3Z5E003C4oxOj6H0rfIF1kKI9MAQLMdpGW1GYEIgS9Ez
	Sdfd8AcCIicTDWbqLAcU4UpkaX8KyGlLwsNuuGztobF8m72ALC/nLF6JLtPofwFBlgc+myiv
	O7TCUSBdLQlgMVOFq1I2uPWQOkOWQAHukEOmfjy2jctxSDBQ220ymjaNsHT4kgtZg2AYYgPq
	dAv8JggJICUvax2T9va5 gsg-keypair

No tienes más que añadirlas al archivo 'authorized_keys':

	$ cat /tmp/id_rsa.john.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.josie.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.jessica.pub >> ~/.ssh/authorized_keys

Tras esto, puedes preparar un repositorio básico vacio para ellos, usando el comando 'git init' con la opción '--bare' para inicializar el repositorio sin carpeta de trabajo:

	$ cd /opt/git
	$ mkdir project.git
	$ cd project.git
	$ git --bare init

Y John, Josie o Jessica podrán enviar (push) la primera versión de su proyecto a dicho repositorio, añadiendolo como remoto y enviando (push) una rama (branch). Cabe indicar que alguien tendrá que iniciar sesión en la máquina y crear un repositorio básico, cada vez que se desee añadir un nuevo proyecto. Suponiendo, por ejemplo, que se llame 'gitserver' el servidor donde has puesto el usuario 'git' y los repositorios; que dicho servidor es interno a vuestra red y que está asignado el nombre 'gitserver' en vuestro DNS.  Podrás utlizar comandos tales como:

	# en la máquina de John
	$ cd myproject
	$ git init
	$ git add .
	$ git commit -m 'initial commit'
	$ git remote add origin git@gitserver:/opt/git/project.git
	$ git push origin master

Tras lo cual, otros podrán clonarlo y enviar cambios de vuelta:

	$ git clone git@gitserver:/opt/git/project.git
	$ vim README
	$ git commit -am 'fix for the README file'
	$ git push origin master

Con este método, puedes preparar rápidamente un servidor Git con acceso de lectura/escritura para un grupo de desarrolladores.

Para una mayor protección, puedes restringir facilmente el usuario 'git' a realizar solamente actividades relacionadas con Git. Utilizando un shell limitado llamado 'git-shell', que viene incluido en Git. Si lo configuras como el shell de inicio de sesión de tu usuario 'git', dicho usuario no tendrá acceso al shell normal del servidor. Para especificar el 'git-shell' en lugar de bash o de csh como el shell de inicio de sesión de un usuario, Has de editar el archivo '/etc/passwd':

	$ sudo vim /etc/passwd

Localizar, al fondo, una línea parecida a:

	git:x:1000:1000::/home/git:/bin/shgit:x:1000:1000::/home/git:/bin/sh

Y cambiar '/bin/sh' por '/usr/bin/git-shell' (nota: puedes utilizar el comando 'which git-shell' para ver dónde está instalado dicho shell). Quedará una linea algo así como:

	git:x:1000:1000::/home/git:/usr/bin/git-shellgit:x:1000:1000::/home/git:/usr/bin/git-shell

De esta forma dejamos al usuario 'git' limitado a utilizar la conexión SSH solamente para enviar (push) y recibir (pull) repositorios, sin posibilidad de iniciar una sesión normal en el servidor. Si pruebas a hacerlo, recibiras un rechazo de inicio de sesión:

	$ ssh git@gitserver
	fatal: What do you think I am? A shell?
	Connection to gitserver closed.

## Acceso público ##

¿Qué hacer si necesitas acceso anónimo de lectura a tu proyecto? Por ejemplo, si en lugar de albergar un proyecto privado interno, quieres albergar un proyecto de código abierto. O si tienes un grupo de servidores de integración automatizados o servidores de integración continua que cambian muy a menudo, y no quieres estar todo el rato generando claves SSH. Es posible que desees añadirles un simple acceso anónimo de lectura.

La manera más sencilla de hacerlo para pequeños despliegues, es el preparar un servidor web estático cuya raiz de documentos sea la ubicación donde tengas tus repositorios Git; y luego activar el anclaje (hook) 'post-update' que se ha mencionado en la primera parte de este capítulo. Si utilizamos el mismo ejemplo usado anteriormente, suponiendo que tengas los repositorios en la carpeta '/opt/git', y que hay un servidor Apache en marcha en tu máquina. Veremos algunas configuraciones básicas de Apache, para que puedas hacerte una idea de lo que puedes necesitar. (Recordar que esto es solo un ejemplo, y que puedes utilizar cualquier otro servidor web.)

Lo primero, es activar el anclaje (hook):

	$ cd project.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

Si utilizas una versión de Git anterior a la 1.6, el comando 'mv' no es necesario, ya que solo recientemente lleva Git los anclajes de ejemplo con el sufijo .sample 

¿Que hace este anclaje 'post-update'? Pues tiene una pinta tal como:

	$ cat .git/hooks/post-update 
	#!/bin/sh
	exec git-update-server-info

Lo que significa que cada vez que envias (push) algo al servidor vía SSH, Git lanzará este comando y actualizará así los archivos necesarios para HTTP fetching. (_i_pendientedetraducir) 

A continuación, has de añadir una entrada VirtualHost al archivo de configuración de Apache, fijando su raiz de documentos a la ubicación donde tengas tus proyectos Git. Aquí, estamos asumiendo que tienes un DNS comodin para redirigir `*.gitserver` hacia cualquier máquina que estés utilizando para todo esto:

	<VirtualHost *:80>
	    ServerName git.gitserver
	    DocumentRoot /opt/git
	    <Directory /opt/git/>
	        Order allow, deny
	        allow from all
	    </Directory>
	</VirtualHost>

Asimismo, has de ajustar el grupo Unix de las carpetas bajo '/opt/git' a 'www-data', para que tu servidor web tenga acceso de lectura a los repositorios contenidos en ellas; porque la instancia de Apache que maneja los scripts CGI trabaja bajo dicho usuario:

	$ chgrp -R www-data /opt/git

Una vez reinicies Apache, ya deberias ser capaz de clonar tus repositorios bajo dicha carpeta, simplemente indicando la URL de tu projecto:

	$ git clone http://git.gitserver/project.git

De esta manera, puedes preparar en cuestión de minutos accesos de lectura basados en HTTP a tus proyectos, para grandes cantidades de usuarios. Otra opción simple para habilitar accesos públicos sin autentificar, es arrancar el demonio Git, aunque esto supone demonizar el proceso. (Se verá esta opción en la siguiente sección.)

## GitWeb ##

Ahora que ya tienes acceso básico de lectura/escritura y de solo-lectura a tu proyecto, puedes querer instalar un visualizador web. Git trae un script CGI, denominado GitWeb, que es el que usaremos para este propósito. Puedes ver a GitWeb en acción en sitios como `http://git.kernel.org` (ver figura 4-1)

Insert 18333fig0401.png 
Figura 4-1. El interface web GitWeb.

Si quieres comprobar cómo podría quedar GitWeb con tu proyecto, Git dispone de un comando para activar una instancia temporal, si en tu sistema tienes un servidor web ligero, como por ejemplo 'lighttup' o 'webrick'. En las máquinas Linux, 'lighttpd' suele estar habitualmente instalado. Por lo que tan solo has de activarlo lanzando el comando 'git instaweb', estando en la carpeta de tu proyecto. Si tienes una máquina Mac, Leopard trae preinstalado Ruby, por lo que 'webrick' puede ser tu mejor apuesta. Para instalar 'instaweb' disponiendo de un controlador no-lighttpd, puedes lanzarlo con la opción '--httpd'.  

	$ git instaweb --httpd=webrick
	[2009-02-21 10:02:21] INFO  WEBrick 1.3.1
	[2009-02-21 10:02:21] INFO  ruby 1.8.6 (2008-03-03) [universal-darwin9.0]

Esto arranca un servidor HTTPD en el puerto 1234, y luego arranca un navegador que abre esa página. Es realmente sencillo. Cuando ya has terminado y quieras apagar el servidor, puedes lanzar el mismo comando con la opción '--stop'.

	$ git instaweb --httpd=webrick --stop

Si quieres disponer permanentemente de un interface web para tu equipo o para un proyecto de código abierto que alberges, necesitarás ajustar el script CGI para ser servido por tu servidor web habitual. Algunas distribuciones Linux suelen incluir el paquete 'gitweb', y podrás instalarlo a través de las utilidades 'apt' o 'yum'; merece la pena probarlo en primer lugar. Enseguida vamos a revisar el proceso de instalar GitWeb manualmente. Primero, necesitas el código fuente de Git, que viene con GitWeb, para generar un script CGI personalizado:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/
	$ make GITWEB_PROJECTROOT="/opt/git" \
	        prefix=/usr gitweb/gitweb.cgi
	$ sudo cp -Rf gitweb /var/www/

Fijate que es necesario indicar la ubicación donde se encuentran los repositorios Git, utilizando la variable 'GITWEB_PROJECTROOT'. A continuación, tienes que preparar Apache para que utilice dicho script, Para ello, puedes añadir un VirtualHost:

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

Recordar una vez más que GitWeb puede servirse desde cualquier servidor web con capacidades CGI. Por lo que si prefieres utilizar algún otro, no debería ser dificil de configurarlo. En este momento, deberias poder visitar 'http://gitserver/' para ver tus repositorios online. Y utilizar 'http://git.gitserver' para clonar (clone) y recuperar (fetch) tus repositorios a través de HTTP.

## Gitosis ##

Mantener claves públicas, para todos los usuarios, en el archivo 'authorized_keys', puede ser una buena solución inicial. Pero, cuanto tengas cientos de usuarios, se hace bastante pesado gestionar así ese proceso. Tienes que iniciar sesión en el servidor cada vez. Y, ademas, no tienes control de acceso --todo el mundo presente en el archivo tiene permisos de lectura y escritura a todos y cada uno de los proyectos--.

En este punto, es posible que desees cambiar a un popular programa llamado Gitosis. Gitosis es básicamente un conjunto de scripts que te ayudarán a gestionar el archivo 'authorized_keys', así como a implementar algunos controles de acceso simples. Lo interesante de la interfaz de usuario para esta herramienta de gestión de usuarios y de control de accesos, es que, en lugar de un interface web, es un repositorio especial de Git. Preparas la información en ese proyecto especial, y cuando la envias (push), Gitosis reconfigura el servidor en base a ella. ¡Realmente interesante!.

Instalar Gitosis no es precisamente sencillo. Pero tampoco demasiado complicado. Es más sencillo hacerlo si utilizas un servidor Linux --estos ejemplos se han hecho sobre un servidor Ubuntu 8.10--.

Gitosis necesita de ciertas herramientas Python, por lo que la  primera tarea será instalar el paquete de herramientas Pyton. En Ubuntu viene como el paquete python-setuptools:

	$ sudo apt-get install python-setuptools

A continuación, has de clonar e instalar Gitosis desde el repositorio principal de su proyecto:

	$ git clone https://github.com/tv42/gitosis.git
	$ cd gitosis
	$ sudo python setup.py install

Esto instala un par de ejecutables, que serán los que Gitosis utilice. Gitosis intentará instalar sus repositorios bajo la carpeta '/home/git', lo cual está bien. Pero si, en lugar de en esa, has instalado tus repositorios bajo la carpeta '/opt/git'. Sin necesidad de reconfigurarlo todo, tan solo has de crear un enlace virtual:

	$ ln -s /opt/git /home/git/repositories

Gitosis manejará tus claves por tí, por lo que tendrás que quitar el archivo actual, añadir de nuevo las claves más tarde, y dejar que Gitosis tome automáticamente el control del archivo 'authorized_keys'. Para empezar, mueve el archivo 'authorized_keys a otro lado:

	$ mv /home/git/.ssh/authorized_keys /home/git/.ssh/ak.bak

A continuación, restaura el inicio de sesión (shell) para el usuario 'git', (si es que lo habias cambiado al comando 'git-shell'). Los usuarios no podrán todavia iniciar sesión, pero Gitosis se encargará de ello. Así pues, cambia esta línea en tu archivo '/etc/passwd':

	git:x:1000:1000::/home/git:/usr/bin/git-shellgit:x:1000:1000::/home/git:/usr/bin/git-shell

de vuelta a:

	git:x:1000:1000::/home/git:/bin/shgit:x:1000:1000::/home/git:/bin/sh

Y, en este punto, ya podemos inicializar Gitosis. Lo puedes hacer lanzando el comando 'gitosis-init' con tu clave pública personal. Si tu clave pública personal no está en el servidor, la has de copiar a él:

	$ sudo -H -u git gitosis-init < /tmp/id_dsa.pub
	Initialized empty Git repository in /opt/git/gitosis-admin.git/
	Reinitialized existing Git repository in /opt/git/gitosis-admin.git/

Esto habilita al usuario con dicha clave pública para que pueda modificar el repositorio principal de Git, y, con ello, pueda controlar la instalación de Gitosis. A continuanción, has de ajustar manualmente el bit de ejecución en el script 'post-update' de tu nuevo repositorio de contrrol:

	$ sudo chmod 755 /opt/git/gitosis-admin.git/hooks/post-update

Y ya estás preparado para trabajar. Si lo has configurado todo correctamente, puedes intentar conectarte, vía SSH, a tu servidor como el usuario con cuya clave pública has inicializado Gitosis. Y deberás ver algo así como esto:

	$ ssh git@gitserver
	PTY allocation request failed on channel 0
	fatal: unrecognized command 'gitosis-serve schacon@quaternion'
	  Connection to gitserver closed.

Indicandote que Gitosis te ha reconocido, pero te está hechando debido a que no estás intentando lanzar ningún comando Git. Por tanto, intentalo con un comando Git real --por ejemplo, clonar el propio repositorio de control de Gitosis a tu ordenador personal-- 
	
	$ git clone git@gitserver:gitosis-admin.git

Con ello, tendrás una carpeta denominada 'gitosis-admin', con dos partes principales dentro de ella:

	$ cd gitosis-admin
	$ find .
	./gitosis.conf
	./keydir
	./keydir/scott.pub

El archivo 'gitosis.conf' es el archivo de control que usarás para especificar usuarios, repositorios y permisos. La carpeta 'keydir' es donde almacenarás las claves públicas para los usuarios con acceso a tus repositorios --un archivo por usuario--. El nombre del archivo en la carpeta 'keydir' ('scott.pub' en el ejemplo), puede ser diferente en tu instalación, (Gitosis lo obtiene a partir de la descripción existente al final de la clave pública que haya sido importada con el script 'gitosis-init').

Si miras dentro del archivo 'gitosis.conf', encontrarás únicamente información sobre el proyecto 'gitosis-admin' que acabas de clonar:

	$ cat gitosis.conf 
	[gitosis]

	[group gitosis-admin]
	writable = gitosis-admin
	members = scott

Indicando que el usuario 'scott' --el usuario con cuya clave pública se ha inicializado Gitosis-- es el único con acceso al proyecto 'gitosis-admin'.

A partir de ahora, puedes añadir nuevos proyectos. Por ejemplo, puedes añadir una nueva sección denominada 'mobile', donde poner la lista de los desarrolladores en tu equipo movil y los proyectos donde estos vayan a trabajar. Por ser 'scott' el único usuario que tienes definido por ahora, lo añadirás como el único miembro. Y puedes crear además un proyecto llamado 'iphone_project' para empezar:

	[group mobile]
	writable = iphone_project
	members = scott

Cada cambio en el proyecto 'gitosis-admin', lo has de confirmar (commit) y enviar (push) de vuelta al servidor, para que tenga efecto sobre él:

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

Puedes crear tu nuevo proyecto 'iphone_project' simplemente añadiendo tu servidor como un remoto a tu versión local del proyecto de control y enviando (push). Ya no necesitarás crear manualmente repositorios básicos vacios para los nuevos proyectos en el servidor. Gitosis se encargará de hacerlo por tí, en cuanto realices el primer envio (push) de un nuevo proyecto:

	$ git remote add origin git@gitserver:iphone_project.git
	$ git push origin master
	Initialized empty Git repository in /opt/git/iphone_project.git/
	Counting objects: 3, done.
	Writing objects: 100% (3/3), 230 bytes, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:iphone_project.git
	 * [new branch]      master -> master

Ten en cuenta que no es necesario indicar expresamente un camino (path), --de hecho, si lo haces, no funcionará--. Simplemente, has de poner un punto y el nombre del proyecto, --Gitosis se encargará de encontrarlo--.

Si deseas compartir el proyecto con tus compañeros, tienes que añadir de nuevo sus claves públicas. Pero en lugar de hacerlo manualmente sobre el archivo `~/.ssh/authorized_keys` de tu servidor, has de hacerlo --un archivo por clave-- en la carpeta 'keydir' del proyecto de control. Según pongas los nombres a estos archivos, así tendrás que referirte a los usuarios en el archivo 'gitosis.conf'. Por ejemplo, para añadir las claves públicas de John, Josie y Jessica:

	$ cp /tmp/id_rsa.john.pub keydir/john.pub
	$ cp /tmp/id_rsa.josie.pub keydir/josie.pub
	$ cp /tmp/id_rsa.jessica.pub keydir/jessica.pub

Y para añadirlos al equipo 'mobile', dándoles permisos de lectura y escritura sobre el proyecto 'phone_project':

	[group mobile]
	writable = iphone_project
	members = scott john josie jessica

Tras confirmar (commit) y enviar (push) estos cambios, los cuatro usuarios podrán acceder a leer y escribir sobre el proyecto.

Gitosis permite también sencillos controles de acceso. Por ejemplo, si quieres que John tenga únicamente acceso de lectura sobre el proyecto, puedes hacer:

	[group mobile]
	writable = iphone_project
	members = scott josie jessica

	[group mobile_ro]
	readonly = iphone_project
	members = john

Habilitandole así para clonar y recibir actualizaciónes desde el servidor; pero impidiendole enviar de vuelta cambios al proyecto. Puedes crear tantos grupos como desees, para diferentes usuarios y proyectos. También puedes indicar un grupo como miembro de otro (utilizado el prefijo '@'), para incluir todos sus miembros automáticamente:

	[group mobile_committers]
	members = scott josie jessica

	[group mobile]
	writable  = iphone_project
	members   = @mobile_committers

	[group mobile_2]
	writable  = another_iphone_project
	members   = @mobile_committers john

Si tienes problemas, puede ser util añadir `loglevel=DEBUG` en la sección `[gitosis]`. Si, por lo que sea, pierdes acceso de envio (push) de nuevos cambios, (por ejemplo, tras haber enviado una configuración problemática); siempre puedes arreglar manualmente ,en el propio servidor, el archivo '/home/git/.gitosis.conf', (el archivo del que Gitosis lee su configuración). Un envio (push) de cambios al proyecto, coge el archivo 'gitosis.conf' enviado y sobreescribe con él el del servidor. Si lo editas manualmente, permanecerá como lo dejes; hasta el próximo envio (push) al proyecto 'gitosis-admin'.

## El demonio Git ##

Para dar a tus proyectos un acceso público, sin autentificar, de solo lectura, querrás ir más allá del protocolo HTTP y comenzar a utilizar el protocolo Git. Principalmente, por razones de velocidad. El protocolo Git es mucho más eficiente y, por tanto, más rápido que el protocolo HTTP. Utilizándolo, ahorrarás mucho tiempo a tus usuarios.

Aunque, sigue siendo solo para acceso unicamente de lectura y sin autentificar. Si lo estás utilizando en un servidor fuera del perímetro de tu cortafuegos, se debe utilizar exclusivamente para proyectos que han de ser públicos, visibles para todo el mundo. Si lo estás utilizando en un servidor dentro del perímetro de tu cortafuegos, puedes utilizarlo para proyectos donde un gran número de personas o de ordenadores (integración contínua o servidores de desarrollo) necesiten acceso de solo lectura. Y donde quieras evitar la gestión de claves SSH para cada una de ellas.

En cualquier caso, el protocolo Git es relativamente sencillo de configurar. Tan solo necesitas lanzar este comando de forma demonizada:

	git daemon --reuseaddr --base-path=/opt/git/ /opt/git/

El parámetro '--reuseaddr' permite al servidor reiniciarse sin esperar a que se liberen viejas conexiones; el parámetro '--base-path' permite a los usuarios clonar proyectos sin necesidad de indicar su camino completo; y el camino indicado al final del comando mostrará al demonio Git dónde buscar los repositorios a exportar. Si tienes un cortafuegos activo, necesitarás abrir el puerto 9418 para la máquina donde estás configurando el demónio Git.

Este proceso se puede demonizar de diferentes maneras, dependiendo del sistema operativo con el que trabajas. En una máquina Ubuntu, puedes usar un script de arranque. Poniendo en el siguiente archivo: 

	/etc/event.d/local-git-daemon

un script tal como: 

	start on startup
	stop on shutdown
	exec /usr/bin/git daemon \
	    --user=git --group=git \
	    --reuseaddr \
	    --base-path=/opt/git/ \
	    /opt/git/
	respawn

Por razones de seguridad, es recomendable lanzar este demonio con un usuario que tenga unicamente permisos de lectura en los repositorios --lo puedes hacer creando un nuevo usuario 'git-ro' y lanzando el demonio con él--.  Para simplificar, en estos ejemplos vamos a lanzar el demonio Git bajo el mismo usuario 'git' con el que hemos lanzado Gitosis.

Tras reiniciar tu máquina, el demonio Git arrancará automáticamente y se reiniciará cuando se caiga. Para arrancarlo sin necesidad de reiniciar la máquina, puedes utilizar el comando:

	initctl start local-git-daemon

En otros sistemas operativos, puedes utilizar 'xinetd', un script en el sistema 'sysvinit', o alguna otra manera --siempre y cuando demonizes el comando y puedas monitorizarlo--.

A continuación, has de indicar en tu servidor Gitosis a cuales de tus repositorios ha de permitir acceso sin autentificar por parte del servidor Git. Añadiendo una sección por cada repositorio, puedes indicar a cuáles permitirá leer el demonio Git. Por ejemplo, si quieres permitir acceso a tu 'proyecto iphone', puedes añadir lo siguiente al archivo 'gitosis.conf':

	[repo iphone_project]
	daemon = yes

Cuando confirmes (commit) y envies (push) estos cambios, el demonio que está en marcha en el servidor comenzará a responder a peticiones de cualquiera que solicite dicho proyecto a través del puerto 9418 de tu servidor.

Si decides no utilizar Gitosis, pero sigues queriendo utilizar un demonio Git, has de lanzar este comando en cada proyecto que desees servír vía el demonio Git:

	$ cd /path/to/project.git
	$ touch git-daemon-export-ok

La presencia de este archivo, indica a Git que está permitido el servir este proyecto sin necesidad de autentificación.

También podemos controlar a través de Gitosis los proyectos a ser mostrados por GitWeb. Previamente, has de añadir algo como esto al archivo '/etc/gitweb.conf':

	$projects_list = "/home/git/gitosis/projects.list";
	$projectroot = "/home/git/repositories";
	$export_ok = "git-daemon-export-ok";
	@git_base_url_list = ('git://gitserver');

Los proyectos a ser mostrados por GitWeb se controlarán añadiendo o quitando parámetros 'gitweb' en el archivo de configuración de Gitosis. Por ejemplo, si quieres mostrar el proyecto iphone, has de poner algo así como:

	[repo iphone_project]
	daemon = yes
	gitweb = yes

A partir de ese momento, cuando confirmes cambios (commit) y envies (push) el proyecto, GitWeb comenzará a mostrar tu proyecto iphone.

## Git en un alojamiento externo ##

Si no quieres realizar todo el trabajo de preparar tu propio servidor Git, tienes varias opciones para alojar tus proyectos Git en una ubicación externa dedicada. Esta forma de trabajar tiene varias ventajas: un alberge externo suele ser rápido de configurar y sencillo de iniciar proyectos en él; además de no ser necesario preocuparte de su mantenimiento ni de su monitorización. Incluso en el caso de que tengas tu propio servidor interno, puede resultar interesante utilizar también un lugar público; para albergar tu código abierto --normalmente, ahí suele ser más sencillo de localizar por parte de la comunidad--

Actualmente tienes un gran número de opciones del alojamiento, cada una con sus ventajas y desventajas. Para obtener una lista actualizada, puedes mirar en la página GitHosting del wiki principal de Git:

	https://git.wiki.kernel.org/index.php/GitHosting

Por ser imposible el cubrir todos ellos, y porque da la casualidad de que trabajo en uno de ellos, concretamente, en esta sección veremos cómo crear una cuenta y nuevos proyectos albergados en 'GitHub'. Así podrás hacerte una idea de cómo suelen funcionar estos alberges externos. 

GitHub es, de lejos, el mayor sitio de alberge público de proyectos Git de código abierto. Y es también uno de los pocos que ofrece asimismo opciones de alberge privado; de tal forma que puedes tener tanto tus proyectos de código abierto y como los de código comercial cerrado en un mismo emplazamiento. De hecho, nosotros utilizamos también GitHub para colaborar privadamente en este libro.

### GitHub ###

GitHub es ligeramente distinto a otros sitios de alberge, en tanto en cuanto que contempla espacios de nombres para los proyectos. En lugar de estar focalizado en los proyectos, GitHub gira en torno a los usuarios. Esto significa que, cuando alojo mi proyecto 'grit' en GitHub, no lo encontraras bajo 'github.com/grit', sino bajo 'github.com/schacon/grit'. No existe una versión canónica de ningún proyecto, lo que permite a cualquiera de ellos ser movido facilmente de un usuario a otro en el caso de que el primer autor lo abandone.

GitHub es también una compañia comercial, que cobra por las cuentas que tienen repositorios privados. Pero, para albergar proyectos públicos de código abierto, cualquiera puede crear una cuenta gratuita. Vamos a ver cómo hacerlo.

### Configurando una cuenta de usuario ###

El primer paso es dar de alta una cuenta gratuita. Si visitas la página de Precios e Inicio de Sesión, en 'https://github.com/pricing', y clicas sobre el botón "Registro" ("Sign Up") de las cuentas gratuitas, verás una página de registro:

Insert 18333fig0402.png
Figura 4-2. La página de planes GitHub.

En ella, has de elegir un nombre de usuario que esté libre, indicar una cuenta de correo electrónico y poner una contraseña.

Insert 18333fig0403.png 
Figura 4-3. El formulario de registro en GitHub.

Si la tuvieras, es también un buen momento para añadir tu clave pública SSH. Veremos cómo generar una de estas claves, más adelante, en la sección "Ajustes Simples". Pero, si ya tienes un par de claves SSH, puedes coger el contenido correspondiente a la clave pública y pegarlo en la caja de texto preparada para tal fin. El enlace "explicar claves ssh" ("explain ssh keys") te llevará a unas detalladas instrucciones de cómo generarlas en la mayor parte de los principales sistemas operativos.
Clicando sobre el botón de "Estoy de acuerdo, registramé" ("I agree, sign me up"), irás al panel de control de tu recién creado usuario.

Insert 18333fig0404.png 
Figura 4-4. El panel de control del usuario GitHub.

A continuación, puedes crear nuevos repositorios. 

### Creando un nuevo repositório ###

Puedes empezar clicando sobre el enlace "crear uno nuevo" ("create a new one"), en la zona 'Tus repositorios' ('Your Repositories') del panel de control. Irás al formulario de Crear un Nuevo Repositório (ver Figura 4-5).

Insert 18333fig0405.png 
Figura 4-5. Creando un nuevo repositório en GitHub.

Es suficiente con dar un nombre al proyecto, pero también puedes añadirle una descripción. Cuando lo hayas escrito, clica sobre el botón "Crear Repositório" ("Create Repository"). Y ya tienes un nuevo repositório en GitHub (ver Figura 4-6)

Insert 18333fig0406.png 
Figura 4-6. Información de cabecera de un proyecto GitHub.

Como aún no tienes código, GitHub mostrará instrucciones sobre cómo iniciar un nuevo proyecto, cómo enviar (push) un proyecto Git preexistente, o cómo importar un proyecto desde un repositório público Subversion (ver Figura 4-7).

Insert 18333fig0407.png 
Figura 4-7. Instrucciones para un nuevo repositório.

Estas instrucciones son similares a las que ya hemos visto. Para inicializar un proyecto, no siendo aún un proyecto Git, sueles utilizar:

	$ git init
	$ git add .
	$ git commit -m 'initial commit'

Una vez tengas un repositorio local Git, añadele el sitio GitHub como un remoto y envia (push) allí tu rama principal:

	$ git remote add origin git@github.com:testinguser/iphone_project.git
	$ git push origin master

Así, tu proyecto estará alojado en GitHub; y podrás dar su URL a cualquiera con quien desees compartirlo. En este ejemplo, la URL es `http://github.com/testinguser/iphone_project`. En la página de cabecera de cada uno de tus proyectos, podrás ver dos URLs (ver Figura 4-8).

Insert 18333fig0408.png 
Figura 4-8. Cabecera de proyecto, con una URL pública y otra URL privada.

El enlace "Public Clone URL", es un enlace público, de solo lectura; a través del cual cualquiera puede clonar el proyecto. Puedes comunicar libremente ese URL o puedes publicarlo en tu sitio web o en cualquier otro médio que desees.

El enlace "Your Clone URL", es un enlace de lectura/escritura basado en SSH; a través del cual puedes leer y escribir, pero solo si te conectas con la clave SSH privada correspondiente a la clave pública que has cargado para tu usuario. Cuando otros usuarios visiten la página del proyecto, no verán esta segunda URL --solo verán la URL pública--.

### Importación desde Subversion ###

Si tienes un proyecto público Subversion que deseas pasar a Git, GitHub suele poder realizar la importación. All fondo de la página de instrucciones, tienes un enlace "Subversion import". Si clicas sobre dicho enlace, verás un formulario con información sobre el proceso de importación y un cuadro de texto donde puedes pegar la URL de tu proyecto Subversion (ver Figura 4-9).

Insert 18333fig0409.png 
Figura 4-9. El interface de importación desde Subversion.

Si tu proyecto es muy grande, no-estandar o privado, es muy posible que no se pueda importar. En el capítulo 7, aprenderás cómo realizar importaciones manuales de proyectos complejos.

### Añadiendo colaboradores ###

Vamos a añadir al resto del equipo. Si tanto John, como Josie, como Jessica, todos ellos registran sus respectivas cuentas en GitHub. Y deseas darles acceso de escritura a tu repositorio. Puedes incluirlos en tu proyecto como colaboradores. De esta forma, funcionarán los envios (push) desde sus respectivas claves públicas.

Has de hacer clic sobre el botón "edit" en la cabecera del proyecto o en la pestaña Admin de la parte superior del proyecto; yendo así a la página de administración del proyecto GitHub.

Insert 18333fig0410.png 
Figura 4-10. Página de administración GitHub.

Para dar acceso de escritura a otro usuario, clica sobre el enlace "Add another collaborator". Aparecerá un cuadro de texto, donde podrás teclear un nombre. Según  tecleas, aparecerá un cuadro de ayuda, mostrando posibles nombres de usuario que encajen con lo tecleado. Cuando localices al usuario deseado, clica sobre el botón "Add" para añadirlo como colaborador en tu proyecto (ver Figura 4-11).

Insert 18333fig0411.png 
Figura 4-11. Añadirendo un colaborador a tu proyecto.

Cuando termines de añadir colaboradores, podrás ver a todos ellos en la lista "Repository Collaborators" (ver Figura 4-12).

Insert 18333fig0412.png 
Figura 4-12. Lista de colaboradores en tu proyecto.

Si deseas revocar el acceso a alguno de ellos, puedes clicar sobre el enlace "revoke", y sus permisos de envio (push) serán revocados. En proyectos futuros, podras incluir también a tu grupo de colaboradores copiando los permisos desde otro proyecto ya existente.

### Tu proyecto ###

Una vez hayas enviado (push) tu proyecto, o lo hayas importado desde Subversion, tendrás una página principal de proyecto tal como:

Insert 18333fig0413.png 
Figura 4-13. Una página principal de proyecto GitHub.

Cuando la gente visite tu proyecto, verá esta página. Tiene pestañas que llevan a distintos aspectos del proyecto. La pestaña "Commits" muestra una lista de confirmaciones de cambio, en orden cronológico inverso, de forma similar a la salida del comando 'git log'. La pestaña "Network" muestra una lista de toda la gente que ha bifurcado (forked) tu proyecto y ha contribuido a él. La pestaña "Downloads" permite cargar binarios del proyecto y enlaza con tarballs o versiones comprimidas de cualquier punto marcado (tagged) en tu proyecto. La pestaña "Wiki" enlaza con un espacio wiki donde puedes escribir documentación o cualquier otra información relevante sobre tu proyecto. La pestaña "Graphs" muestra diversas visualizaciones sobre contribuciones y estadísticas de tu proyecto. La pestaña principal "Source" en la que aterrizas cuando llegas al proyecto, muestra un listado de la carpeta principal; y muestra también el contenido del archivo README, si tienes uno en ella. Esta pestaña muestra también un cuadro con información sobre la última confirmación de cambio (commit) realizada en el proyecto.

### Bifurcando proyectos ###

Si deseas contribuir a un proyecto ya existente, en el que no tengas permisos de envio (push). GitHub recomienda bifurcar el proyecto. Cuando aterrizas en la página de un proyecto que te parece interesante y con el que deseas trastear un poco, puedes clicar sobre el botón "fork" de la cabecera del proyecto; de tal forma que GitHub haga una copia del proyecto a tu cuenta de usuario y puedas así enviar (push) cambios sobre él.

De esta forma, los proyectos no han de preocuparse de añadir usuarios como colaboradores para darles acceso de envio (push). La gente puede bifurcar (fork) un proyecto y enviar (push) sobre su propia copia. El gestor del proyecto principal, puede recuperar (pull) esos cambios añadiendo las copias como remotos y fusionando (merge) el trabajo en ellas contenido.

Para bifurcar un proyecto, visita su página (en el ejemplo, mojombo/chronic) y clica sobre el botón "fork" de su cabecera (ver Figura 4-14) 

Insert 18333fig0414.png 
Figura 4-14. Obtener una copia sobre la que escribir, clicando sobre el botón "fork" de un repositorio.

Tras unos segundos, serás redirigido a la página del nuevo proyecto; y en ella se verá que este proyecto es una bifuración (fork) de otro existente (ver Figura 4-15).

Insert 18333fig0415.png 
Figura 4-15. Tu bifurcación (fork) de un proyecto.

### Resumen de GitHub ###

Esto es todo lo que vamos a ver aquí sobre GitHub, pero merece la pena destacar lo rápido que puedes hacer todo esto. Puedes crear una cuenta, añadir un nuevo proyecto y contribuir a él en cuestión de minutos. Si tu proyecto es de código abierto, puedes tener también una amplia comunidad de desarrolladores que podrán ver tu proyecto, bifurcarlo (fork) y ayudar contribuyendo a él. Y, por último, comentar que esta puede ser una buena manera de iniciarte y comenzar rápidamente a trabajar con Git.

## Recapitulación ##

Tienes varias maneras de preparar un repositório remoto Git, de colaborar con otras personas o de compartir tu trabajo.

Disponer de tu propio servidor te da pleno control sobre él y te permite trabajar dentro de tu propio cortafuegos. Pero un servidor así suele requerir bastante de tu tiempo para prepararlo y mantenerlo. Si ubicas tus datos en un servidor albergado, será sencillo configurarlo y mantenerlo. Pero tienes que estar dispuesto a mantener tu código en servidores de terceros, cosa que no suele estar permitido en algunas organizaciones.

No te será dificil el determinar cual de estas soluciones o combinación de soluciones es apropiada para tí y para tu organización.
