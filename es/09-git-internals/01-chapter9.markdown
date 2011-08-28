# Los entesijos internos de Git #

Puedes que hayas llegado a este capítulo saltando desde alguno previo o puede que hayas llegado tras leer todo el resto del libro. --En uno u otro caso, aquí es donde aprenderás acerca del funcionamiento interno y la implementación de Git--. Me parece que esta información es realmente importante para entender cúan util y potente es Git. Pero algunas personas opinan que puede ser confuso e innecesariamente complejo para novatos. Por ello, lo he puesto al final del libro; de tal forma que puedas leerlo antes o después, en cualquier momento, a lo largo de tu proceso de aprendizaje. Lo dejo en tus manos.

Y, ahora que estamos aquí, comencemos con el tema. Ante todo, por si no estuviera suficientemente claro ya, Git es fundamentalmente un sistema de archivo (filesystem) con un interface de usuario (VCS) escrito sobre él. En breve lo veremos con más detalle.

En los primeros tiempos de Git (principalmente antes de la versión 1.5), el interface de usuario era mucho más complejo, ya que se centraba en el sistema de archivos en lugar de en el VCS. En los últimos años, el IU se ha refinado hasta llegar a ser tan limpio y sencillo de usar como el de cualquier otro sistema; pero frecuentemente, el estereotipo sigue mostrando a Git como complejo y dificil de aprender. 

La capa del sistema de archivos que almacena el contenido es increiblemente interesante; por ello, es lo primero que voy a desarrollar en este capítulo. A continuación mostraré los mecanismos de transporte y las tareas de mantenimiento del repositorio que posiblemente necesites usar alguna vez.

## Fontaneria y porcelana ##

Este libro habla acerca de como utilizar Git con más o menos 30 verbos, tales como 'checkout', 'branch', 'remote', etc. Pero, debido al origen de Git como una caja de herramientas para un VCS en lugar de como un completo y amigable sistema VCS, existen unos cuantos verbos para realizar tareas de bajo nivel y que se diseñaron para poder ser utilizados de forma encadenada al estilo UNIX o para ser utilizados en scripts. Estos comandos son conocidos como los "comandos de fontanería", mientras que los comandos más amigables son conocidos como los "comandos de porcelana".

Los primeros ocho capítulos de este libro se encargan casi exclusivamente de los comandos de porcelana. Pero en este capítulo trataremos sobre todo con los comandos de fontaneria; comandos que te darán acceso a los entresijos internos de Git y que te ayudarán a comprender cómo y por qué hace Git lo que hace como lo hace. Estos comando no están pensados para ser utilizados manualmente desde la línea de comandos; sino más bien para ser utilizados como bloques de construcción para nuevas herramientas y scripts de usuario personalizados.

Cuando lanzas 'git init' sobre una carpeta nueva o sobre una ya existente, Git crea la carpeta auxiliar '.git'; la carpeta  donde se ubica prácticamente todo lo almacenado y manipulado por Git. Si deseas hacer una copia de seguridad de tu repositorio, con tan solo copiar esta carpeta a cualquier otro lugar ya tienes tu copia completa. Todo este capítulo se encarga de repasar el contenido en dicha carpeta. Tiene un aspecto como este:

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

Puede que veas algunos otros archivos en tu carpeta '.git', pero este es el contenido de un repositorio recién creado tras ejecutar 'git init', --es la estructura por defecto--. La carpeta 'branches' no se utiliza en las últimas versiones de Git, y el archivo 'description' se utiliza solo en el programa GitWeb; por lo que no necesitas preocuparte por ellos. El archivo 'config' contiene las opciones de configuración específicas de este proyecto concreto, y la carpeta 'info' guarda un archivo global de exclusión con los patrones a ignorar ademas de los presentes en el archivo .gitignore. La carpeta 'hooks' contiene tus scripts, tanto de la parte cliente como de la parte servidor, tal y como se ha visto a detalle en el capítulo 6.

Esto nos deja con cuatro entradas importantes: los archivos 'HEAD' e 'index' y las carpetas 'objects' y 'refs'. Estos elementos forman el núcleo de Git. La carpeta 'objects' guarda el contenido de tu base de datos, la carpeta 'refs' guarda los apuntadores a las confirmaciones de cambios (commits), el archivo 'HEAD' apunta a la rama que tengas activa (checked out) en este momento, y el archivo 'index' es donde Git almacena la información sobre tu area de preparación (staging area). Vamos a mirar en detalle cada una de esas secciones, para ver cómo trabaja Git.

## Los objetos Git ##

Git es un sistema de archivo orientado a contenidos. Estupendo. Y eso, ¿qué significa?
Pues significa que el núcleo Git es un simple almacén de claves y valores. Cuando insertas cualquier tipo de contenido, él te devuelve una clave que puedes utilizar para recuperar de nuevo dicho contenido en cualquier momento. Para verlo en acción, puedes utilizar el comando de fontanería 'hash-object'. Este comando coge ciertos datos, los guarda en la carpeta '.git.' y te devuelve la clave bajo la cual se han guardado. Para empezar, inicializa un nuevo repositorio Git y comprueba que la carpeta 'objects' está vacia.

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

Git ha inicializado la carpeta 'objects', creando en ella las subcarpetas 'pack' e 'info'; pero aún no hay archivos en ellas. Luego, guarda algo de texto en la base de datos de Git:

	$ echo 'test content' | git hash-object -w --stdin
	d670460b4b4aece5915caf5c68d12f560a9fe3e4

La opción '-w' indica a 'hash-object' que ha de guardar el objeto; de otro modo, el comando solo te respondería cual sería su clave. La opción '--stdin' indica al comando de leer desde la entrada estandar stdin; si no lo indicas, 'hash-object' espera encontrar la ubicación de un archivo. La salida del comando es una suma de comprobación (checksum hash) de 40 caracteres. Este checksum hash SHA-1  es una suma de comprobación del contenido que estás guardando más una cabecera; cabecera sobre la que trataremos en breve. En estos momentos, ya puedes comprobar la forma en que Git ha guardado tus datos:

	$ find .git/objects -type f 
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4

Como puedes ver, hay un archivo en la carpeta 'objects'. En principio, esta es la forma en que guarda Git los contenidos; como un archivo por cada pieza de contenido, nombrado con la suma de comprobación SHA-1 del contenido y su cabecera. La subcarpeta se nombra con los primeros 2 caracteres del SHA, y el archivo con los restantes 38 caracteres.

Puedes volver a recuperar los contenidos usando el comando 'cat-file'. Este comando es algo así como una "navaja suiza" para inspeccionar objetos Git. Pasandole la opción '-p', puedes indicar al comando 'cat-file' que deduzca el tipo de contenido y te lo muestre adecuadamente:

	$ git cat-file -p d670460b4b4aece5915caf5c68d12f560a9fe3e4
	test content

Ahora que sabes cómo añadir contenido a Git y cómo recuperarlo de vuelta. Lo puedes hacer también con el propio contenido de los archivos. Por ejemplo, puedes realizar un control simple de versiones sobre un archivo. Para ello, crea un archivo nuevo y guarda su contenido en tu base de datos:

	$ echo 'version 1' > test.txt
	$ git hash-object -w test.txt 
	83baae61804e65cc73a7201a7252750c76066a30

A continuación, escribe algo más de contenido en el archivo y vuelvelo a guardar:

	$ echo 'version 2' > test.txt
	$ git hash-object -w test.txt 
	1f7a7a472abf3dd9643fd615f6da379c4acb3e3a

Tu base de datos contendrá las dos nuevas versiones del archivo, así como el primer contenido que habias guardado en ella antes:

	$ find .git/objects -type f 
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4

Podrás revertir el archivo a su primera versión:

	$ git cat-file -p 83baae61804e65cc73a7201a7252750c76066a30 > test.txt 
	$ cat test.txt 
	version 1

o a su segunda versión

	$ git cat-file -p 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a > test.txt 
	$ cat test.txt 
	version 2

Pero no es práctico esto de andar recordando la clave SHA-1 para cada versión de tu archivo; es más, realmente no estás guardando el nombre de tu archivo en el sistema, --solo su contenido--. Este tipo de objeto se denomina un blob (binary large object). Con la orden 'cat-file -t' puedes comprobar el tipo de cualquier objeto almacenado en Git, sin mas que indicar su clave SHA-1':

	$ git cat-file -t 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a
	blob

### Objetos tipo arbol ###

El siguiente tipo de objeto a revisar serán los objetos tipo arbol. Estos se encargan de resolver el problema de guardar un nombre de archivo, a la par que guardamos conjuntamente un grupo de archivos. Git guarda contenido de manera similar a un sistema de archivos UNIX, pero de forma algo más simple. Todo el contenido se guarda como objetos arbol (tree) u objetos binarios (blob). Correspondiendo los árboles a las entradas de carpetas; y correspondiendo los binarios, mas o menos, a los contenidos de los archivos (inodes). Un objeto tipo árbol tiene una o más entradas de tipo arbol. Y cada una de ellas consta de un puntero SHA-1 a un objeto binario (blob) o a un subárbol, más sus correspondientes datos de modo, tipo y nombre de archivo. Por ejemplo, el árbol que hemos utilizado recientemente en el proyecto simplegit, puede resultar algo así como:

	$ git cat-file -p master^{tree}
	100644 blob a906cb2a4a904a152e80877d4088654daad0c859      README
	100644 blob 8f94139338f9404f26296befa88755fc2598c289      Rakefile
	040000 tree 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0      lib

La sentencia `master^{tree}` indica el objeto árbol apuntado por la última confirmación de cambios (commit) en tu rama principal (master). Fíjate en que la carpeta `lib` no es un objeto binario, sino un apuntador a otro objeto tipo árbol.  

	$ git cat-file -p 99f1a6d12cb4b6f19c8655fca46c3ecf317074e0
	100644 blob 47c6340d6459e05787f644c2447d2595f5d3a54b      simplegit.rb

Conceptualmente, la información almacenada por Git es algo similar a la Figura 9-1.

Insert 18333fig0901.png 
Figura 9-1. Versión simplificada del modelo de datos de Git.

Puedes crear tu propio árbol. Habitualmente Git suele crear un árbol a partir del estado de tu área de preparación (staging area) o índice, escribiendo un objeto árbol con él. Por tanto, para crear un objeto árbol, previamente has de crear un índice preparando algunos archivos para ser almacenados. Puedes utilizar el comando de "fontaneria" `update-index` para crear un índice con una sola entrada, --la primera version de tu archivo text.txt--. Este comando se utiliza para añadir artificialmente la versión anterior del archivo test.txt. a una nueva área de preparación  Has de utilizar la opción `--add`, porque el archivo no existe aún en tu área de preparación (es más, ni siquiera tienes un área de preparación). Y has de utilizar también la opción `--cacheinfo`, porque el archivo que estas añadiendo no está en tu carpeta, sino en tu base de datos.  Para terminar, has de indicar el modo, la clave SHA-1 y el nombre de archivo:

	$ git update-index --add --cacheinfo 100644 \
	  83baae61804e65cc73a7201a7252750c76066a30 test.txt

En este caso, indicas un modo `100644`, el modo que denota un archivo normal. Otras opciones son `100755`, para un achivo ejecutable; o `120000`, para un enlace simbólico.  Estos modos son como los modos de UNIX, pero mucho menos flexibles. Solo estos tres modos son válidos para archivos (blobs) en Git; (aunque  también se permiten otros modos para carpetas y submódulos).

Tras esto, puedes usar el comando `write-tree` para escribir el área de preparacón a un objeto tipo árbol. Sin necesidad de la opción `-w`, solo llamando al comando `write-tree`, y si dicho árbol no existiera ya, se crea automáticamente un objeto tipo árbol a partir del estado del índice.

	$ git write-tree
	d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	$ git cat-file -p d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	100644 blob 83baae61804e65cc73a7201a7252750c76066a30      test.txt

También puedes comprobar si realmente es un objeto tipo árbol:

	$ git cat-file -t d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	tree

Vamos a crear un nuevo árbol con la segunda versión del archivo test.txt y con un nuevo archivo.

	$ echo 'new file' > new.txt
	$ git update-index test.txt 
	$ git update-index --add new.txt 

El área de preparación contendrá ahora la nueva versión de test.txt, así como el nuevo archivo new.txt. Escribiendo este árbol, (guardando el estado del área de preparación o índice), podrás ver que aparece algo así como:

	$ git write-tree
	0155eb4229851634a0f03eb265b69f5a2d56f341
	$ git cat-file -p 0155eb4229851634a0f03eb265b69f5a2d56f341
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a      test.txt

Aquí se vén las entradas para los dos archivos y también el que la suma de comprobación SHA-1 de test.txt es la "segunda versión" de la anterior (`1f7a7a`). Simplemente por diversión, puedes añadir el primer árbol como una subcarpeta de este otro. Para leer árboles al área de preparación puedes utilizar el comando `read-tree`. Y, en este caso, puedes hacerlo como si fuera una subcarpeta utilizando la opción `--prefix`:

	$ git read-tree --prefix=bak d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	$ git write-tree
	3c4e9cd789d88d8d89c1073707c3585e41b0e614
	$ git cat-file -p 3c4e9cd789d88d8d89c1073707c3585e41b0e614
	040000 tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579      bak
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 1f7a7a472abf3dd9643fd615f6da379c4acb3e3a      test.txt

Si crearas una carpeta de trabajo a partir de este nuevo árbol que acabas de escribir, obtendrías los dos archivos en el nivel principal de la carpeta de trabajo y una subcarpeta llamada `bak` conteniendo la primera versión del archivo test.txt.  Puedes pensar en algo parecido a la Figura 9-2 para representar los datos guardados por Git para estas estructuras.

Insert 18333fig0902.png 
Figura 9-2. La estructura del contenido Git para tus datos actuales.

### Objetos de confirmación de cambios ###

Tienes tres árboldes que representan diferentes momentos interesantes de tu proyecto, pero el problema principal sigue siendo el estar obligado a recordar los tres valores SHA-1 para poder recuperar cualquiera de esos momentos. Asimismo, careces de información alguna sobre quién guardó las instantáneas de esos momentos, cuándo fueron guardados o por qué se guardaron. Este es el tipo de información que almacenan para tí los objetos de confirmación de cambios.

Para crearlos, tan solo has de llamar al comando `commit-tree`, indicando uno de los árboles SHA-1 y los objetos de confirmación de cambios que lo preceden (si es que lo precede alguno).  Empezando por el primer árbol que has escrito:

	$ echo 'first commit' | git commit-tree d8329f
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d

Con el comando `cat-file` puedes revisar el nuevo objeto de confirmación de cambios recién creado:

	$ git cat-file -p fdf4fc3
	tree d8329fc1cc938780ffdd9f94e0d364e0ea74f579
	author Scott Chacon <schacon@gmail.com> 1243040974 -0700
	committer Scott Chacon <schacon@gmail.com> 1243040974 -0700

	first commit

El formato para un objeto de confirmación de cambios (commit) es sencillo, contemplando: el objeto tipo árbol para la situación del proyecto en ese momento puntual; la información sobre el autor/confirmador, recogida desde las opciones de configuración`user.name` y `user.email`; la fecha y hora actuales; una línea en blanco; y el mensaje de la confirmación de cambios.  

Puedes seguir adelante, escribiendo los otros dos objetos de confirmación de cambios. Y relacionando cada uno de ellos con su inmediato anterior:

	$ echo 'second commit' | git commit-tree 0155eb -p fdf4fc3
	cac0cab538b970a37ea1e769cbbde608743bc96d
	$ echo 'third commit'  | git commit-tree 3c4e9c -p cac0cab
	1a410efbd13591db07496601ebc7a059dd55cfe9

Cada uno de estos tres objetos de confirmación de cambios apunta a uno de los tres objetos tipo árbol que habias creado previamente. Más aún, en estos momentos tienes ya un verdadero historial Git. Lo puedes comprobar con el comando `git log`. Lanzandolo mientras estás en la última de las confirmaciones de cambio.

	$ git log --stat 1a410e	commit 1a410efbd13591db07496601ebc7a059dd55cfe9
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

¡Sorprendente!. Acabas de confeccionar un historial Git utilizando solamente operaciones de bajo nivel, sin usar ninguno de los interfaces principales. Esto es básicamente lo que hace Git cada vez que utilizas los comandos `git add` y `git commit`: guardar objetos binarios (blobs) para los archivos modificados, actualizar el índice, escribir árboles (trees), escribir objetos de confirmación de cambios (commits) que los referencian y relacionar cada uno de ellos con su inmediato precedente. Estos tres objetos Git, -binario, árbol y confirmación de cambios--, se guardan como archivos separados en la carpeta `.git/objects`. Aquí se muestran todos los objetos presentes en este momento en la carpeta del ejemplo, con comentarios acerca de lo que almacena cada uno de ellos:

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

Siguiendo todos los enlaces internos, puedes llegar a un gráfico similar al de la figura 9-3.

Insert 18333fig0903.png 
Figura 9-3. Todos los objetos en tu carpeta Git.

### Almacenamiento de los objetos ###

He citado anteriormente que siempre se almacena una cabecera  junto al contenido. Vamos a hechar un vistazo a cómo Git almacena sus objetos. Te mostraré el proceso de guardar un objeto binario grande (blob), --en este caso la cadena de texto "what is up, doc?" (¿qué hay de nuevo, viejo?)--, interactivamente, en el lenguaje de script Ruby. Puedes arrancar el modo interactivo de Ruby con el comando `irb`:

	$ irb
	>> content = "what is up, doc?"
	=> "what is up, doc?"

Git construye la cabecera comenzando por el tipo de objeto, en este caso un objeto binario grande (blob). Después añade un espacio, seguido del tamaño del contenido y termina con un byte nulo:

	>> header = "blob #{content.length}\0"
	=> "blob 16\000"

Git concatena la cabecera y el contenido original, para calcular la suma de control SHA-1 conjunta. En Ruby, para calcular el valor SHA-1 de una cadena de texto: has de incluir la libreria de generación SHA1 con el comando `require` y llamar luego a la orden `Digest::SHA1.hexdigest()`:

	>> store = header + content
	=> "blob 16\000what is up, doc?"
	>> require 'digest/sha1'
	=> true
	>> sha1 = Digest::SHA1.hexdigest(store)
	=> "bd9dbf5aae1a3862dd1526723246b20206e5fc37"

Git  comprime todo el contenido con zlib. Y tu puedes hacer lo mismo en Ruby con la libreria zlib. Primero has de incluir la libreria y luego lanzar la orden `Zlib::Deflate.deflate()` sobre el contenido: 

	>> require 'zlib'
	=> true
	>> zlib_content = Zlib::Deflate.deflate(store)
	=> "x\234K\312\311OR04c(\317H,Q\310,V(-\320QH\311O\266\a\000_\034\a\235"

Para terminar, has de escribir el contenido comprimido en un objeto en disco. Para fijar el lugar donde almacenarlo, utilizaremos como nombre de carpeta los dos primeros caracteres del valor SHA-1 y como nombre de archivo los restantes 38 caracteres de dicho valor SHA-1. En Ruby, puedes utilizar la función `FileUtils.mkdir_p()` para crear una carpeta. Después, puedes abrir un archivo con la orden `File.open()` y escribir contenido en él con la orden `write()`:  

	>> path = '.git/objects/' + sha1[0,2] + '/' + sha1[2,38]
	=> ".git/objects/bd/9dbf5aae1a3862dd1526723246b20206e5fc37"
	>> require 'fileutils'
	=> true
	>> FileUtils.mkdir_p(File.dirname(path))
	=> ".git/objects/bd"
	>> File.open(path, 'w') { |f| f.write zlib_content }
	=> 32

Y ¡esto es todo!. --acabas de crear un auténtico objeto Git binario grande (blob)--. Todos los demas objetos Git se almacenan de forma similar, pero con la diferencia de que sus cabeceras comienzan con un tipo diferente. En lugar de 'blob' (objeto binario grande), comenzarán por 'commit' (confirmación de cambios), o por 'tree' (árbol). Además, el contenido de un binario (blob) puede ser prácticamente cualquier cosa. Mientras que el contenido de una confirmación de cambios (commit) o de un árbol (tree) han de seguir unos formatos internos muy concretos.

## Referencias Git ##

Puedes utilizar algo así como `git log 1a410e` para hechar un vistazo a lo largo de toda tu historia, recorriendola y encontrando todos tus objetos. Pero para ello has necesitado recordar que la última confirmación de cambios es `1a410e`. Necesitarias un archivo donde almacenar los valores de las sumas de comprobación SHA-1, junto con sus respectivos nombres simples que puedas utilizar como enlaces en lugar de la propia suma de comprobación.

En Git, estp es lo que se conoce como "referencias" o "refs". En la carpeta `.git/refs` puedes encontrar esos archivos con valores SHA-1 y nombres . En el proyecto actual, la carpeta aún no contiene archivos, pero sí contiene una estructura simple:

	$ find .git/refs
	.git/refs
	.git/refs/heads
	.git/refs/tags
	$ find .git/refs -type f
	$

Para crear una nueva referencia que te sirva de ayuda para recordar cual es tu última confirmación de cambios,  puedes realizar técnicamente algo tan simple como:

	$ echo "1a410efbd13591db07496601ebc7a059dd55cfe9" > .git/refs/heads/master

A partir de ese momento, puedes utilizar esa referencia principal que acabas de crear, en lugar del valor SHA-1, en todos tus comandos:

	$ git log --pretty=oneline  master
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

No es conveniente editar directamente los archivos de referencia. Git suministra un comando mucho más seguro para hacer esto. Si necesitas actualizar una referencia, puedes utilizar el comando `update-ref`:

	$ git update-ref refs/heads/master 1a410efbd13591db07496601ebc7a059dd55cfe9

Esto es lo que es básicamente una rama en Git: un simple apuntador o referencia a la cabeza de una línea de trabajo. Para crear una rama hacia la segunda confirmación de cambios, puedes hacer:

	$ git update-ref refs/heads/test cac0ca

Y la rama contendrá únicamente trabajo desde esa confirmación de cambios hacia atrás.

	$ git log --pretty=oneline test
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

En estos momentos, tu base de datos Git se parecerá conceptualmente a la figura 9-4.

Insert 18333fig0904.png 
Figura 9-4. Objetos en la carpeta Git, con referencias a las cabeceras de las ramas.

Cuando lanzas comandos como `git branch (nombrederama)`. Lo que hace Git es añadir, a cualquier nueva referencia que vayas a crear, el valor SHA-1 de la última confirmación de cambios en esa rama.

### La CABEZA (HEAD) ###

Y ahora nos preguntamos, al lanzar el comando `git branch (nombrederama)`, ¿cómo sabe Git cuál es el valor SHA-1 de la última confirmación de cambios?. La respuesta a esta pregunta es el archivo HEAD (CABEZA). El archivo HEAD es una referencia simbólica a la rama donde te encuentras en cada momento. Por referencia simbólica me refiero a que, a diferencia de una referencia normal, esta contiene un enlace a otra referencia en lugar de un valor SHA-1. Si miras dentro del archivo, podrás observar algo como:

	$ cat .git/HEAD 
	ref: refs/heads/master

Si lanzas el comando `git checkout test`, Git actualiza el contenido del archivo:

	$ cat .git/HEAD 
	ref: refs/heads/test

Cuando lanzas una orden `git commit`, se crea un nuevo objeto de confirmación de cambios teniendo como padre la confirmación con valor SHA-1 a la que en ese momento esté apuntando la referencia en HEAD.

Puedes editar manualmente este archivo. Pero, también para esta tarea existe un comando más seguro: `symbolic-ref`. Puedes leer el valor de HEAD a través de él:

	$ git symbolic-ref HEAD
	refs/heads/master

Y también puedes cambiar el valor de HEAD a través de él:

	$ git symbolic-ref HEAD refs/heads/test
	$ cat .git/HEAD 
	ref: refs/heads/test

Pero no puedes fijar una referencia simbólica fuera de "refs":

	$ git symbolic-ref HEAD test
	fatal: Refusing to point HEAD outside of refs/

### Etiquetas ###

Acabas de conocer los tres principales tipos de objetos Git, pero hay un cuarto. El objeto tipo etiqueta es muy parecido al tipo confirmación de cambios, --contiene un marcador, una fecha, un mensaje y un enlace--. Su principal diferencia reside en que apunta a una confirmación de cambios (commit) en lugar de a un árbol (tree). Es como una referencia a una rama, pero permaneciendo siempre inmovil, --apuntando siempre a la misma confirmación de cambios--, dándo un nombre mas amigable a esta.

Tal y como se ha comentado en el capítulo 2, hay dos tipos de etiquetas: las anotativas y las ligeras. Puedes crear una etiqueta ligera lanzando un comando tal como:

	$ git update-ref refs/tags/v1.0 cac0cab538b970a37ea1e769cbbde608743bc96d

Una etiqueta ligera es simplemente eso: una rama que nunca se mueve. Sin embargo, una etiqueta anotativa es más compleja. Al crear una etiqueta anotativa, Git crea un objeto tipo etiqueta y luego escribe una referencia apuntando a él en lugar de apuntar directamente a una confirmación de cambios. Puedes comprobarlo creando una: (la opción `-a` indica que la etiqueta es anotativa)

	$ git tag -a v1.1 1a410efbd13591db07496601ebc7a059dd55cfe9 –m 'test tag'

Este es el objeto SHA-1 creado:

	$ cat .git/refs/tags/v1.1 
	9585191f37f7b0fb9444f35a9bf50de191beadc2

Ahora, lanzando el comando `cat-file` para ese valor SHA-1: 

	$ git cat-file -p 9585191f37f7b0fb9444f35a9bf50de191beadc2
	object 1a410efbd13591db07496601ebc7a059dd55cfe9
	type commit
	tag v1.1
	tagger Scott Chacon <schacon@gmail.com> Sat May 23 16:48:58 2009 -0700

	test tag

Merece destacar que el inicio del objeto apunta al SHA-1 de la confirmación de cambios recién etiquetada. Y también el que no ha sido necesario apuntar directamente a una confirmación de cambios. Realmente puedes etiquetar cualquier tipo de objeto Git. Por ejemplo, en el código fuente de Git los gestores han añadido su clave GPG pública como un objeto binario (blob) y lo han etiquetado. Puedes ver esta clave pública con el comando

	$ git cat-file blob junio-gpg-pub

lanzado sobre el código fuente de Git. El kernel de Linux tiene también un objeto tipo etiqueta apuntando a un objeto que no es una confirmación de cambios (commit). La primera etiqueta que se creó es la que apunta al árbol (tree) inicial donde se importó el código fuente.

### Remotos ###

El tercer tipo de referencia que puedes observar es la referencia remota. Si añades un remoto y envias algo a él, Git almacenará en dicho remoto el último valor para cada rama presente en la carpeta `refs/remotes`.  Por ejemplo, puedes añadir un remoto denominado `origin` y enviar a él tu rama  `master`:

	$ git remote add origin git@github.com:schacon/simplegit-progit.git
	$ git push origin master
	Counting objects: 11, done.
	Compressing objects: 100% (5/5), done.
	Writing objects: 100% (7/7), 716 bytes, done.
	Total 7 (delta 2), reused 4 (delta 1)
	To git@github.com:schacon/simplegit-progit.git
	   a11bef0..ca82a6d  master -> master

Tras lo cual puedes confirmar cual era la rama `master` en el remoto `origin` la última vez que comunicase con el servidor. Comprobando el archivo `refs/remotes/origin/master`: 

	$ cat .git/refs/remotes/origin/master 
	ca82a6dff817ec66f44342007202690a93763949

Las referencias remotas son distintas de las ramas normales, (referencias en `refs/heads`); y no se pueden recuperar (checkout) al espacio de trabajo.  Git las utiliza solamente como marcadores al último estado conocido de cada rama en cada servidor remoto declarado.

## Archivos empaquetadores ##

Volviendo a los objetos en la base de datos de tu repositorio Git de pruebas. En este momento, tienes 11 objetos --4 binarios, 3 árboles, 3 confirmaciones de cambios y 1 etiqueta--. 

	$ find .git/objects -type f
	.git/objects/01/55eb4229851634a0f03eb265b69f5a2d56f341 # tree 2
	.git/objects/1a/410efbd13591db07496601ebc7a059dd55cfe9 # commit 3
	.git/objects/1f/7a7a472abf3dd9643fd615f6da379c4acb3e3a # test.txt v2
	.git/objects/3c/4e9cd789d88d8d89c1073707c3585e41b0e614 # tree 3
	.git/objects/83/baae61804e65cc73a7201a7252750c76066a30 # test.txt v1
	.git/objects/95/85191f37f7b0fb9444f35a9bf50de191beadc2 # tag
	.git/objects/ca/c0cab538b970a37ea1e769cbbde608743bc96d # commit 2
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4 # 'test content'
	.git/objects/d8/329fc1cc938780ffdd9f94e0d364e0ea74f579 # tree 1
	.git/objects/fa/49b077972391ad58037050f2a75f74e3671e92 # new.txt
	.git/objects/fd/f4fc3344e67ab068f836878b6c4951e3b15f3d # commit 1

Git comprime todos esos archivos con zlib, por lo que ocupan más bien poco. Entre todos suponen solamente 925 bytes. Puedes añadir algún otro archivo de gran contenido al repositorio. Y verás una interesante funcionalidad de Git. Añadiendo el archivo repo.rb de la libreria Grit con la que has estado trabajando anteriormente, supondrá añadir un achivo con unos 12 Kbytes de código fuente.

	$ curl http://github.com/mojombo/grit/raw/master/lib/grit/repo.rb > repo.rb
	$ git add repo.rb 
	$ git commit -m 'added repo.rb'
	[master 484a592] added repo.rb
	 3 files changed, 459 insertions(+), 2 deletions(-)
	 delete mode 100644 bak/test.txt
	 create mode 100644 repo.rb
	 rewrite test.txt (100%)

Si hechas un vistazo al árbol resultante, podrás observar el valor SHA-1 del objeto binario correspondiente a dicho archivo repo.rb:

	$ git cat-file -p master^{tree}
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e      repo.rb
	100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

Y ver su tamaño con el comando `git cat-file`:

	$ git cat-file -s 9bc1dc421dcd51b4ac296e3e5b6e2a99cf44391e
	12898

Ahora, modifica un poco dicho archivo y comprueba lo que sucede:

	$ echo '# testing' >> repo.rb 
	$ git commit -am 'modified repo a bit'
	[master ab1afef] modified repo a bit
	 1 files changed, 1 insertions(+), 0 deletions(-)

Revisando el árbol creado por esta última confirmación de cambios, verás algo interesante:

	$ git cat-file -p master^{tree}
	100644 blob fa49b077972391ad58037050f2a75f74e3671e92      new.txt
	100644 blob 05408d195263d853f09dca71d55116663690c27c      repo.rb
	100644 blob e3f094f522629ae358806b17daf78246c27c007b      test.txt

El objeto binario es ahora un binario completamente diferente. Aunque solo has añadido una única línea al final de un archivo que ya contenia 400 líneas, Git ha almacenado el resultado como un objeto completamente nuevo.

	$ git cat-file -s 05408d195263d853f09dca71d55116663690c27c
	12908

Y, así, tienes en tu disco dos objetos de 12 Kbytes prácticamente idénticos. ¿No seria práctico si Git pudiera almacenar uno de ellos completo y luego solo las diferencias del segundo con respecto al primero?

Pues bien, Git lo puede hacer. El formato inicial como Git guarda sus objetos en disco es el formato conocido como "relajado" (loose). Pero, sin embargo, de vez en cuando, Git suele agrupar varios de esos objetos en un único binario denominado archivo "empaquetador". Para ahorrar espacio y hacer así más eficiente su almacenamiento. Esto sucede cada vez que tiene demasiados objetos en formato "relajado"; o cuando tu invocas manualmente al comando `git gc`; o justo antes de enviar cualquier cosa a un servidor remoto.  Puedes comprobar el proceso pidiendole expresamente a Git que empaquete objetos, utilizando el comando `git gc`: 

	$ git gc
	Counting objects: 17, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (13/13), done.
	Writing objects: 100% (17/17), done.
	Total 17 (delta 1), reused 10 (delta 0)

Tras esto, si miras los objetos presentes en la carpeta, veras que han desaparecido la mayoria de los que habia anteriormente. Apareciendo un par de objetos nuevos:

	$ find .git/objects -type f
	.git/objects/71/08f7ecb345ee9d0084193f147cdad4d2998293
	.git/objects/d6/70460b4b4aece5915caf5c68d12f560a9fe3e4
	.git/objects/info/packs
	.git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.idx
	.git/objects/pack/pack-7a16e4488ae40c7d2bc56ea2bd43e25212a66c45.pack

Solo han quedado aquellos objetos binarios no referenciados por ninguna confirmación de cambios --en este caso, el ejemplo de "¿que hay de nuevo, viejo?" y el ejemplo de "contenido de pruebas"-- Porque nunca los has llegado a incluir en ninguna confirmación de cambios, no se han considerado como objetos definitivos y, por tanto, no han sido empaquetados.

Los otros archivos presentes son el nuevo archivo empaquetador y un índice. El archivo empaquetador es un único archivo conteniendo dentro de él todos los objetos sueltos eliminados del sistema de archivo. El índice es un archivo que contiene las posiciones de cada uno de esos objetos dentro del archivo empaquetador. Permitiendonos así buscarlos y extraer rápidamente cualquiera de ellos. Lo que es interesante es el hecho de que, aunque los objetos originales presentes en el disco antes del `gc` ocupaban unos 12 Kbytes, el nuevo archivo empaquetador apenas ocupa 6 Kbytes.  Empaquetando los objetos, has conseguido reducir a la mitad el uso de disco.

¿Cómo consigue Git esto? Cuando Git empaqueta objetos, va buscando archivos de igual nombre y tamaño similar. Almacenando únicamente las diferencias entre una versión de cada archivo y la siguiente. Puedes comprobarlo mirando en el interior del archivo empaquetador. Y, para eso, has de utilizar el comando "de fontaneria" `git verify-pack`:

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

Puedes observar que el objeto binario `9bc1d`, (correspondiente a la primera versión de tu archivo repo.rb), tiene una referencia al binario `05408` (la segunda versión de ese archivo). La tercera columna refleja el tamaño de cada objeto dentro del paquete. Observandose que `05408` ocupa unos 12 Kbytes; pero `9bc1d` solo ocupa 7 bytes.  Resulta curioso que se almacene completa la segunda versión del archivo, mientras que la versión original es donde se almacena solo la diferencia. Esto se debe a la mayor probabilidad de que vayamos a recuperar rápidamente la versión mas reciente del archivo.

Lo verdaderamente interesante de todo este proceso es que podemos reempaquetar en cualquier momento De vez en cuando, Git, en su empeño por optimizar la ocupación de espacio, reempaqueta automaticamente toda la base de datos Pero, también tu mismo puedes reempaquetar en cualquier momento, lanzando manualmente el comando `git gc`.

## Las especificaciones para hacer referencia a...  (refspec) ##

A lo largo del libro has utilizado sencillos mapeados entre ramas remotas y referencias locales; pero las cosas pueden ser bastante más complejas.
Supón que añades un remoto tal que:

	$ git remote add origin git@github.com:schacon/simplegit-progit.git

Esto añade una nueva sección a tu archivo `.git/config`, indicando el nombre del remoto (`origin`), la ubicación (URL) del repositorio remoto y la referencia para recuperar (fench) desde él: 

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/*:refs/remotes/origin/*

El formato para esta referencia es un signo `+` opcional, seguido de una sentencia `<orig>:<dest>`; donde  `<orig>` es la plantilla para referencias en el lado remoto y `<dest>` el lugar donde esas referencias se escribirán en el lado local. El  `+`, si está presente, indica a Git que debe actualizar la referencia incluso en los casos en que no se dé un avance rápido (fast-forward). 

En el caso por defecto en que es escrito por un comando `git remote add`, Git recupera del servidor todas las referencias bajo `refs/heads/`, y las escribe localmente en `refs/remotes/origin/`. De tal forma que, si existe una rama `master` en el servidor, puedes acceder a ella localmente a través de  

	$ git log origin/master
	$ git log remotes/origin/master
	$ git log refs/remotes/origin/master

Todas estas sentencias son equivalentes, ya que Git expande cada una de ellas a `refs/remotes/origin/master`. 

Si, en cambio, quisieras hacer que Git recupere únicamente la rama `master` y no cualquier otra rama en el servidor remoto. Puedes cambiar la linea de recuperación a 

	fetch = +refs/heads/master:refs/remotes/origin/master

Quedando así esta referencia como la referencia por defecto para el comando `git fetch` para ese remoto.  Para hacerlo puntualmente en un momento concreto, puedes especificar la referencia directamente en la linea de comando. Para recuperar la rama `master` del servidor remoto a tu rama `origin/mymaster` local, puedes lanzar el comando  

	$ git fetch origin master:refs/remotes/origin/mymaster

Puedes incluso indicar multiples referencias en un solo comando. Escribiendo algo asi como:

	$ git fetch origin master:refs/remotes/origin/mymaster \
	   topic:refs/remotes/origin/topic
	From git@github.com:schacon/simplegit
	 ! [rejected]        master     -> origin/mymaster  (non fast forward)
	 * [new branch]      topic      -> origin/topic

En este ejemplo, se ha rechazado la recuperación de la rama master porque no era una referencia de avance rápido (fast-forward). Puedes forzarlo indicando el signo `+` delante de la referencia. 

Es posible asimismo indicar referencias multiples en el archivo de configuración. Si, por ejemplo, siempre recuperas las ramas 'master' y 'experiment', puedes poner dos lineas:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/master:refs/remotes/origin/master
	       fetch = +refs/heads/experiment:refs/remotes/origin/experiment

Pero, en ningún caso puedes poner referencias genéricas parciales; por ejemplo, algo como esto sería erroneo:

	fetch = +refs/heads/qa*:refs/remotes/origin/qa*

Aunque, para conseguir algo similar, puedes utilizar los espacios de nombres . Si tienes un equipo QA que envia al servidor una serie de ramas. Y deseas recuperar la rama master y cualquiera otra de las ramas del equipo; pero no recuperar ninguna rama de otro equipo. Puedes utilizar una sección de configuración como esta:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/master:refs/remotes/origin/master
	       fetch = +refs/heads/qa/*:refs/remotes/origin/qa/*

De esta forma, puedes asignar facilmente espacios de nombres. Y resolver así complejos flujos de trabajo donde tengas simultáneamente , por ejemplo, un equipo QA enviando ramas, varios desarrolladores enviando ramas también y equipos integradores enviando y colaborando en ramas remotas.

### Enviando (push) referencias ###

Es util poder recuperar (fetch) referencias relativas en espacios de nombres, tal y como hemos visto. Pero, ¿cómo pueden enviar (push) sus ramas al espacio de nombres `qa/` los miembros de equipo QA ?.  Pues utilizando las referencias (refspecs) para enviar.

Si alguien del equipo QA quiere enviar su rama  `master` a la ubicación `qa/master` en el servidor remoto, puede lanzar algo asi como: 

	$ git push origin master:refs/heads/qa/master

Y, para que se haga de forma automática cada vez que ejecute `git push origin`, puede añadir una entrada `push` a su archivo de configuración:

	[remote "origin"]
	       url = git@github.com:schacon/simplegit-progit.git
	       fetch = +refs/heads/*:refs/remotes/origin/*
	       push = refs/heads/master:refs/heads/qa/master

Esto hará que un simple comando `git push origin` envie por defecto la rama local  `master` a la rama remota `qa/master`,

### Borrando referencias ###

Se pueden utilizar las referencias (refspec) para borrar en el servidor remoto. Por ejemplo, lanzando algo como:

	$ git push origin :topic

Se elimina la rama 'topic' del servidor remoto, ya que la sustituimos or nada. (Al ser la referencia `<origen>:<destino>`, si no indicamos la parte  `<origen>`, realmente estamos diciendo que enviamos 'nada' a `<destino>`.) 

## Protocolos de transferencia ##

Git puede transferir datos entre dos repositorios utilizando uno de sus dos principales mecanismos de transporte: sobre HTTP (protocolo tonto), o sobre los denominados protocolos inteligentes (utilizados en  `file://`, `ssh://` o `git://`).  En esta parte, se verán sucintamente cómo trabajan esos dos tipos de protocolo.

### El protocolo tonto (dumb) ###

El transporte de Git sobre protocolo HTTP es conocido también como protocolo tonto. Porque no requiere ningún tipo de codigo Git en la parte servidor. El proceso de recuperación (fetch) de datos se limita a una serie de peticiones GET, siendo el cliente quien ha de conocer la estructura del repositorio Git en el servidor. Vamos a revisar el proceso `http-fetch` para una libreria simple de Git: 

	$ git clone http://github.com/schacon/simplegit-progit.git

Lo primero que hace este comando es recuperar el archivo `info/refs`.  Este es un archivo escrito por el comando `update-server-info`, el que has de habilitar como enganche (hook)  `post-receive` para permitir funcionar correctamente al transporte HTTP: 

	=> GET info/refs
	ca82a6dff817ec66f44342007202690a93763949     refs/heads/master

A partir de ahi, ya tienes una lista de las referencias remotas y sus SHAs. Lo siguiente es mirar cual es la referencia a HEAD, de tal forma que puedas saber el punto a activar (checkout) cuando termines:

	=> GET HEAD
	ref: refs/heads/master

Ves que es la rama`master` la que has de activar cuando el proceso esté completado.  
sus ramas al espacio de nombres `qa/`En este punto, ya estás preparado para seguir procesando el resto de los objetos. En el archivo `info/refs` se ve que el punto de partida es la confirmación de cambios (commit) `ca82a6`, y, por tanto, comenzaremos recuperandola: 

	=> GET objects/ca/82a6dff817ec66f44342007202690a93763949
	(179 bytes of binary data)

Cuando recuperas un objeto, dicho objeto se encuentra suelto (loose) en el servidor y lo traes mediante una petición estática HTTP GET. Puedes descomprimirlo, quitarle la cabecera y mirar el contenido:

	$ git cat-file -p ca82a6dff817ec66f44342007202690a93763949
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

Tras esto, ya tienes más objetos a recuperar --el árbol de contenido `cfda3b` al que apunta la confirmación de cambios; y la confirmación de cambios padre `085bb3`--. 

	=> GET objects/08/5bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	(179 bytes of data)

El siguiente objeto confirmación de cambio (commit). Y el árbol de contenido: 

	=> GET objects/cf/da3bf379e4f8dba8717dee55aab78aef7f4daf
	(404 - Not Found)

Pero... ¡Ay!... parece que el objeto árbol no está suelto en el servidor. Por lo que obtienes una respuesta 404 (objeto no encontrado). Puede haber un par de razones para que suceda esto: el objeto está en otro repositorio alternativo; o el objeto está en este repositorio, pero dentro de un objeto empaquetador (packfile). Git comprueba primero a ver si en el listado hay alguna alternativa:

	=> GET objects/info/http-alternates
	(empty file)

En el caso de que esto devolviera una lista de ubicaciones (URL) alternativas, Git busca en ellas. (Es un mecanismo muy adecuado en aquellos proyectos donde hay segmentos derivados uno de otro compartiendo objetos en disco.) Pero, en este caso, no hay altenativas. Por lo que el objeto debe encontrarse dentro de un empaquetado. Para ver que empaquetados hay disponibles en el servidor, has de recuperar el archivo `objects/info/packs`. Este contiene una lista de todos ellos: (que ha sido generada por `update-server-info`)

	=> GET objects/info/packs
	P pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack

Vemos que hay un archivo empaquetado, y el objeto buscado ha de encontrarse dentro de él; pero merece comprobarlo revisando el archivo de índice, para asegurarse. Hacer la comprobacion es sobre todo util en aquellos casos donde existan multiples archivos empaquetados en el servidor, para determinar así en cual de ellos se encuentra el objeto que necesitas:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.idx
	(4k of binary data)

Una vez tengas el índice del empaquetado, puedes mirar si el objeto buscado está en él, (Dicho índice contiene la lista de SHAs de los objetos dentro del empaquetado y las ubicaciones -offsets- de cada uno de llos dentro de él.) Una vez comprobada la presencia del objeto, adelante con la recuperación de todo el archivo empaquetado:

	=> GET objects/pack/pack-816a9b2334da9953e530f27bcac22082a9f5b835.pack
	(13k of binary data)

Cuando tengas el objeto árbol, puedes continuar avanzando por las confirmaciones de cambio. Y, como estás también están dentro del archivo empaquetado que acabas de descargar, ya no necesitas hacer mas peticiones al servidor. Git activa una copia de trabajo de la rama  `master` señalada por la referencia HEAD que has descargado al principio.

La salida completa de todo el proceso es algo como esto:

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

### El protocolo inteligente (smart) ###

HTTP es un protocolo simple, pero ineficiente. Es mucho más común utilizar protocolos inteligentes para transferir datos. Estos protocolos suelen tener procesos en el lado remoto y conocen acerca de la estructura de datos Git en ese lado, --pueden leer datos localmente y determinar lo que el cliente tiene ya o necesita a continuación, para generar automáticamente datos expresamente preparados para él--. Existen dos conjuntos de procesos para transferir datos: uno para para enviar y otro par para recibir.

#### Enviando datos, (Uploading) ####

Para enviar datos a un proceso remoto, Git utliza  `send-pack` (enviar paquete) y `receive-pack` (recibir paquete).  El proceso `send-pack`  corre en el cliente y conecta con el proceso `receive-pack` corriendo en el lado remoto. 

Por ejemplo, si lanzas el comando `git push origin master` en tu proyecto y `origin` está definida como una ubicación que utiliza el protocolo SSH.  Git lanzará el proceso `send-pack` , con el que establece conexión SSH con tu servidor.  En el servidor remoto, a través de una llamada SSH, intentará lanzar un comando tal como:

	$ ssh -x git@github.com "git-receive-pack 'schacon/simplegit-progit.git'"
	005bca82a6dff817ec66f4437202690a93763949 refs/heads/master report-status delete-refs
	003e085bb3bcb608e1e84b2432f8ecbe6306e7e7 refs/heads/topic
	0000

El comando `git-receive-pack` responde con una linea por cada una de las referencias que tenga, --en este caso, la rama  `master` y su SHA--.  La primera linea suele indicar también una lista con las capacidades del servidor, (en este caso `report-status` --dar situación-- y `delete-refs` --borrar referencias--). 

Cada linea comienza con un valor de 4 bytes, en hexadecimal, indicando la longitud del resto de la linea. La primera de las lineas comienza con 005b, 91 en decimal, indicandonos que hay 91 bytes más en esa línea. La siguiente línea comienza con 003e, 62 en decimal, por lo que has de leer otros 62 bytes hasta el final de la linea. Y la última linea comienza con 0000, indicando así que la lista de referencias ha terminado.

Con esta información, el proceso `send-pack` ya puede determnar las confirmaciones de cambios (commits) presentes en el servidor.  Para cada una de las referencias que se van a actualizar, el proceso `send-pack` llama al proceso `receive-pack` con la información pertinente.   Por ejemplo, si estás actualizando la rama `master` y añadiendo otra rama `experiment`, la respuesta del proceso `send-pack` será algo así como: 

	0085ca82a6dff817ec66f44342007202690a93763949  15027957951b64cf874c3557a0f3547bd83b3ff6 refs/heads/master report-status
	00670000000000000000000000000000000000000000 cdfdb42577e2506715f8cfeacdbabc092bf63e8d refs/heads/experiment
	0000

Una clave SHA-1 con todo '0's, nos indica que no habia nada anteriormente, y que, por tanto, estamos añadiendo una nueva referencia. Si estuvieras borrando una referencia existente, verias lo contrario: una clave todo '0's en el lado derecho.

Git envia una linea por cada referencia a actualizar, indicando el viejo SHA, el nuevo SHA y la referencia a actualizar. La primera linea indica también las capacidades disponibles en el cliente. A continuación, el cliente envia un archivo empaquetado con todos los objetos que faltan en el servidor. Y, por ultimo, el servidor responde con un indicador de éxito (o fracaso) de la operación:

	000Aunpack ok

#### Descargando datos, (Downloading) ####

Cuando descargas datos, los procesos que se ven envueltos son `fetch-pack` (recuperar paquete) y `upload-pack` (enviar paquete).  El cliente arranca un proceso `fetch-pack`, para conectar con un proceso `upload-pack` en el lado servidor y negociar con él los datos a transferir. 

Hay varias maneras de iniciar un proceso `upload-pack` en el repositorio remoto.  Se puede lanzar a través de SSH, de la misma forma que se arrancaba el proceso `receive-pack`.  O se puede arrancar a traves del demonio Git, que suele estar escuchando por el puerto 9418. Tras la conexión, el proceso `fetch-pack` envia datos de una forma parecida a esta: 

	003fgit-upload-pack schacon/simplegit-progit.git\0host=myserver.com\0

Como siempre, comienza con 4 bytes indicadores de cuantos datos siguen a continuación, siguiendo con el comando a lanzar, y terminando con un byte nulo, el nombre del servidor y otro byte nulo más. El demonio Git realizará las comprobaciones de si el comando se puede lanzar, si el repositorio existe y si tenemos permisos. Siendo todo correcto, el demonio lanzará el proceso `upload-pack` y procesara nuestra petición. 

Si en lugar de utilizar el demonio Git, estás utilizando el protocolo SSH. `fetch-pack` lanzará algo como esto: 

	$ ssh -x git@github.com "git-upload-pack 'schacon/simplegit-progit.git'"

En cualquier caso, después de establecer conexión, `upload-pack` responderá: 

	0088ca82a6dff817ec66f44342007202690a93763949 HEAD\0multi_ack thin-pack \
	  side-band side-band-64k ofs-delta shallow no-progress include-tag
	003fca82a6dff817ec66f44342007202690a93763949 refs/heads/master
	003e085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 refs/heads/topic
	0000

La respuesta es muy similar a la dada por `receive-pack`, pero las capacidades que se indican son diferentes.  Además, nos indica la referencia HEAD, para que el cliente pueda saber qué ha de activar (check out) en el caso de estar requiriendo un clon.

En este punto, el proceso `fetch-pack` revisa los objetos que tiene y responde indicando los objetos que necesita. Enviando "want" (quiero) y la clave SHA que necesita. Los objetos que ya tiene, los envia con "have" (tengo) y la correspondiente clave SHA. Llegando al final de la lista, escribe "done" (hecho). Para indicar al proceso `upload-pack` que ya puede comenzar a enviar el archivo empaquetado con los datos requeridos: 

	0054want ca82a6dff817ec66f44342007202690a93763949 ofs-delta
	0032have 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	0000
	0009done

Este es un caso muy sencillo para ilustrar los protocolos de trasferencia. En casos más complejos, el cliente explota las capacidades de `multi_ack` (multiples confirmaciones) o `side-band` (banda lateral). Pero este ejemplo muestra los intercambios básicos empleados en los protocolos inteligentes.

## Mantenimiento y recuperación de datos ##

De vez en cuando, es posible que necesites hacer algo de limpieza, (compactar un repositorio, adecuar un repositorio importado, recuperar trabajo perdido,...). En ese apartado vamos a ver algunos de esos escenarios.

### Mantenimiento ###

De cuando en cuando, Git lanza automáticamente un comando llamado "auto gc". La mayor parte de las veces, este comando no hace nada. Pero, cuando hay demasiados objetos sueltos, (objetos fuera de un archivo empaquetador), o demasiados archivos empaquetadores, Git lanza un comando `git gc` completo. `gc` corresponde a "recogida de basura" (garbage collect), y este comando realiza toda una serie de acciones: recoge los objetos sueltos y los agrupa en archivos empaquetadores; consolida los archivos empaquetadores pequeños en un solo gran archivo empaquetador; retira los objetos antiguos no incorporados a ninguna confirmación de cambios.

También puedes lanzar "auto gc" manualmente:

	$ git gc --auto

Y, habitualmente, no hará nada. Ya que es necesaria la presencia de unos 7.000 objetos sueltos o más de 50 archivos empaquetadores para que Git termine lanzando realmente un comando "gc". Estos límites pueden configurarse con las opciones de configuración  `gc.auto` y `gc.autopacklimit`, respectivamente. 

Otra tarea realizada por `gc` es el empaquetar referencias en un solo archivo. Por ejemplo, suponiendo que tienes las siguientes ramas y etiquetas en tu repositorio:

	$ find .git/refs -type f
	.git/refs/heads/experiment
	.git/refs/heads/master
	.git/refs/tags/v1.0
	.git/refs/tags/v1.1

Lanzando el comando `git gc`, dejarás de tener esos archivos en la carpeta `refs`. En aras de la eficiencia, Git los moverá a un archivo denominado `.git/packed-refs`: 

	$ cat .git/packed-refs 
	# pack-refs with: peeled 
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/heads/experiment
	ab1afef80fac8e34258ff41fc1b867c702daa24b refs/heads/master
	cac0cab538b970a37ea1e769cbbde608743bc96d refs/tags/v1.0
	9585191f37f7b0fb9444f35a9bf50de191beadc2 refs/tags/v1.1
	^1a410efbd13591db07496601ebc7a059dd55cfe9

Si actualizas alguna de las referencias, Git no modificará este archivo. Sino que, en cambio, escribirá uno nuevo en `refs/heads`. Para obtener la clave SHA correspondiente a una determinada referencia, Git comprobará primero en la carpeta `refs` y luego en el archivo `packed-refs`.  Cualquier referencia que no puedas encontrar en la carpeta `refs`, es muy posible que la encuentres en el archivo `packed-refs`.

Merece destacar que la última línea de este archivo comenzaba con  `^`-  Esto nos indica que la etiqueta inmediatamente anterior es una etiqueta anotada y que esa línea es la confirmación de cambios a la que apunta dicha etiqueta anotada.

### Recuperación de datos ###

En algún momento de tu trabajo con Git, perderás por error una confirmación de cambios. Normalmente, esto suele suceder porque has forzado el borrado de una rama con trabajos no confirmados en ella, y luego te has dado cuenta de que realmente necesitabas dicha rama; o porque has reculado (hard-reset) una rama, abandonando todas sus confirmaciones de cambio, y luego te has dado cuenta que necesitabas alguna de ellas. Asumiendo que estas cosas pasan, ¿cómo podrías recuperar tus confirmaciones de cambio perdidas?

Vamos a ver un ejemplo de un retroceso a una confirmación (commit) antigua en la rama principal de tu repositorio de pruebas, y cómo podriamos recuperar las confirmaciones perdidas en este caso. Lo primero es revisar el estado de tu repositorio en ese momento:

	$ git log --pretty=oneline
	ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
	484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Después, al mover la rama  `master` de vuelta a la confirmación de cambios intermedia:

	$ git reset --hard 1a410efbd13591db07496601ebc7a059dd55cfe9
	HEAD is now at 1a410ef third commit
	$ git log --pretty=oneline
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

Vemos que se han perdido las dos últimas confirmaciones de cambios, --no tienes ninguna rama que te permita acceder a ellas--. Necesitas localizar el SHA de la última confirmación de cambios y luego añadir una rama que apunte hacia ella. El problema es cómo localizarla, --porque, ¿no te la sabrás de memoria, no?--.

El método más rápido para conseguirlo suele ser utilizar una herramienta denominada `git reflog`. Según trabajas, Git suele guardar un silencioso registro de donde está HEAD en cada momento. Cada vez que confirmas cambios o cambias de rama, el registro (reflog) es actualizado. El registro reflog se actualiza incluso cuando utilizas el comando `git update-ref`. Siendo esta otra de las razones por las que es recomendable utilizar ese comando en lugar de escribir manualmente los valores SHA en los archivos de referencia, tal y como hemos visto anteriormente en la sección "Referencias Git".  Con el comando `git reflog` puedes revisar donde has estado en cualquier momento pasado:

	$ git reflog
	1a410ef HEAD@{0}: 1a410efbd13591db07496601ebc7a059dd55cfe9: updating HEAD
	ab1afef HEAD@{1}: ab1afef80fac8e34258ff41fc1b867c702daa24b: updating HEAD

Se pueden ver las dos confirmaciones de cambios que hemos activado, pero no hay mucha más información al respecto.  Para ver la misma información de manera mucho más amigable, podemos utilizar el comando `git log -g`. Este nos muestra una salida normal de registro:

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

Parece que la confirmación de cambios perdida es esta última. Puedes recuperarla creando una nueva rama apuntando a ella. Por ejemplo, puedes iniciar una rama llamada `recover-branch` con dicha confirmación de cambios (ab1afef):

	$ git branch recover-branch ab1afef
	$ git log --pretty=oneline recover-branch
	ab1afef80fac8e34258ff41fc1b867c702daa24b modified repo a bit
	484a59275031909e19aadb7c92262719cfcdf19a added repo.rb
	1a410efbd13591db07496601ebc7a059dd55cfe9 third commit
	cac0cab538b970a37ea1e769cbbde608743bc96d second commit
	fdf4fc3344e67ab068f836878b6c4951e3b15f3d first commit

¡Bravo!, acabas de añadir una rama denominada `recover-branch` al punto donde estaba originalmente tu rama `master`; permitiendo así recuperar el acceso a las dos primeras confirmaciones de cambios.  
A continuación, supongamos que la pérdida se ha producido por alguna razón que no se refleja en el registro (reflog). Puedes simularlo borrando la rama `recover-branch` y borrando asimismo el registro. Con eso, perdemos completamente el acceso a las dos primeras confirmaciones de cambio:

	$ git branch –D recover-branch
	$ rm -Rf .git/logs/

La información de registro (reflog) se guarda en la carpeta `.git/logs/`; por lo que, borrandola, nos quedamos efectivamente sin registro.  ¿Cómo podriamos ahora recuperar esas confirmaciones de cambio? Un camino es utilizando el comando de chequeo de integridad de la base de datos: `git fsck`. Si lo lanzas con la opción `--full`, te mostrará todos los objetos sin referencias a ningún otro objeto:

	$ git fsck --full
	dangling blob d670460b4b4aece5915caf5c68d12f560a9fe3e4
	dangling commit ab1afef80fac8e34258ff41fc1b867c702daa24b
	dangling tree aea790b9a58f6cf6f2804eeac9f0abbe9631e4c9
	dangling blob 7108f7ecb345ee9d0084193f147cdad4d2998293

En este caso, puedes ver la confirmación de cambios perdida en la línea 'dangling commit.....'. Y la puedes recuperar del mismo modo, añadiendo una rama que apunte a esa clave SHA.

### Borrando objetos ###

Git tiene grandes cosas. Pero el hecho de que un  `git clone` siempre descarge la historia completa del proyecto (incluyendo todas y cada una de las versiones de todos y cada uno de los archivos). Puede casusar problemas.  Todo suele ir bien si el contenido es únicamente código fuente. Ya que Git está tremendamente optimizado para comprimir eficientemente ese tipo de datos. Pero, si alguien, en cualquier momento de tu proyecto, ha añadido un solo archivo enorme. A partir de ese momento, todos los clones, siempre, se verán obligados a copiar ese enorme archivo. Incluso si ya ha sido borrado del proyecto en la siguiente confirmación de cambios realizada inmediatamente tras la que lo añadió. Porque en algún momento formó parte del proyecto, siempre permanecerá ahí.

Esto suele dar bastantes problemas cuando estás convirtiendo repositorios de Subversion o de Perforce a Git. En esos sistemas, uno no se suele descargar la historia completa. Y, por tanto, los archivos enormes no tienen mayores consecuencias. Si, tras una importación de otro sistema, o por otras razones, descubres que tu repositorio es mucho mayor de lo que deberia ser. Es momento de buscar y borrar objetos enormes en él.

Una advertencia importante: estas técnicas son destructivas y alteran el historia de confirmaciones de cambio. Se basan en reescribir todos los objetos confirmados aguas abajo desde el árbol más reciente modificado para borrar la referencia a un archivo enorme. No tendrás problemas si lo haces inmediatamente despues de una importación; o justo antes de que alguien haya comenzado a trabajar con la confirmación de cambios modificada. Pero si no es el caso, tendrás que avisar a todas las personas que hayan contribuido. Porque se verán obligadas a reorganizar su trabajo en base a tus nuevas confirmaciones de cambio.

Para probarlo por tí mismo, puedes añadir un archivo enorme a tu repositorio de pruebas y retirarlo en la siguiente confirmación de cambios. Así podrás practicar la busqueda y borrado permanente del repositorio. Para emprezar, añade un objeto enorme a tu historial:

	$ curl http://kernel.org/pub/software/scm/git/git-1.6.3.1.tar.bz2 > git.tbz2
	$ git add git.tbz2
	$ git commit -am 'added git tarball'
	[master 6df7640] added git tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 create mode 100644 git.tbz2

!Ouch!, --no querias añadir un archivo tan grande a tu proyecto--. Mejor si lo quitas:

	$ git rm git.tbz2 
	rm 'git.tbz2'
	$ git commit -m 'oops - removed large tarball'
	[master da3f30d] oops - removed large tarball
	 1 files changed, 0 insertions(+), 0 deletions(-)
	 delete mode 100644 git.tbz2

Ahora, puedes limpiar `gc` tu base de datos y comprobar cuánto espacio estás ocupando:

	$ git gc
	Counting objects: 21, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (16/16), done.
	Writing objects: 100% (21/21), done.
	Total 21 (delta 3), reused 15 (delta 1)

Puedes utilizar el comando `count-objects` para revisar rápidamente el espacio utilizado:

	$ git count-objects -v
	count: 4
	size: 16
	in-pack: 21
	packs: 1
	size-pack: 2016
	prune-packable: 0
	garbage: 0

El valor de  `size-pack` nos da el tamaño de tus archivos empaquetadores, en kilobytes, y, por lo que se ve, estás usando 2 MB.  Antes de la última confirmación de cambios, estabas usando algo así como 2 KB. Resulta claro que esa última confirmación de cambios no ha borrado el archivo enorme del historial. A partir de este momento, cada vez que alguien haga un clón de este repositorio, se verá obligado a copiar 2 MB para un proyecto tan simple. Y todo porque tu añadiste accidentalmente un archivo enorme en algún momento. Para arreglar la situación.

Lo primero es localizar el archivo enorme. En este caso, ya sabes de antemano cual es. Pero suponiendo que no lo supieras, ¿cómo podrías identificar el archivo o archivos que están ocupando tanto espacio?. Tras lanzar el comando `git gc`, todos los objetos estarán guardados en un archivo empaquetador. Puedes identifcar los objetos enormes en su interior, utilizando otro comando de fontanería denominado `git verify-pack` y ordenando su salida por su tercera columna, la que nos informa de los tamaños de cada objeto.  Puedes también redirigir su salida a través del comando `tail`. Porque realmente solo nos interesan las últimas líneas, las correspondientes a los archivos más grandes. 

	$ git verify-pack -v .git/objects/pack/pack-3f8c0...bb.idx | sort -k 3 -n | tail -3
	e3f094f522629ae358806b17daf78246c27c007b blob   1486 734 4667
	05408d195263d853f09dca71d55116663690c27c blob   12908 3478 1189
	7a9eb2fba2b1811321254ac360970fc169ba2330 blob   2056716 2056872 5401

El archivo enorme es el último: 2 MB  (2056716 Bytes para ser exactos). Para concretar cual es el archivo, puedes utilizar el comando `rev-list` que ya vimos brevemente en el capítulo 7.  Con la opción `--objects`, obtendrás la lista de todas las SHA de todas las confirmaciones de cambio, junto a las SHA de los objetos binarios y las ubicaciones (paths) de cada uno de ellos. Puedes usar esta información para localizar el nombre del objeto binario:

	$ git rev-list --objects --all | grep 7a9eb2fb
	7a9eb2fba2b1811321254ac360970fc169ba2330 git.tbz2

Una vez tengas ese dato, lo puedes utilizar para borrar ese archivo en todos los árboles pasados. Es sencillo revisar cuales son las confirmaciones de cambios donde interviene ese archivo:

	$ git log --pretty=oneline -- git.tbz2
	da3f30d019005479c99eb4c3406225613985a1db oops - removed large tarball
	6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 added git tarball

Para borrar realmente ese archivo de tu historial Git, has de reescribir todas las confirmaciones de cambio aguas abajo de `6df76`.  Y, para ello, puedes emplear el comando  `filter-branch` que se vió en el capítulo 6.

	$ git filter-branch --index-filter \
	   'git rm --cached --ignore-unmatch git.tbz2' -- 6df7640^..
	Rewrite 6df764092f3e7c8f5f94cbe08ee5cf42e92a0289 (1/2)rm 'git.tbz2'
	Rewrite da3f30d019005479c99eb4c3406225613985a1db (2/2)
	Ref 'refs/heads/master' was rewritten

La opción `--index-filter` es similar a la `--tree-filter` vista en el capítulo 6. Se diferencia porque, en lugar de modificar archivos activados (checked out) en el disco, se modifica el área de preparación (staging area) o índice. En lugar de borrar un archivo concreto con una orden tal como `rm archivo`, has de borrarlo con `git rm --cached` (es decir, tienes que borrarlo del índice, en lugar de del disco). Con eso conseguimos aumentar la velocidad. El proceso es mucho más rápido, porque Git no ha de activar cada revisión a disco antes de procesar tu filtro. Aunque también puedes hacer lo mismo con la opción`--tree-filter`, si así lo prefieres.  La opción `--ignore-unmatch` indica a `git rm` que evite lanzar errores en caso de no encontrar el patrón que le has ordenado buscar. Y por último, se indica a `filter-branch` que reescriba la historia a partir de la confirmación de cambios `6df7640`, porque ya conocemos que es a partir de ahí donde comenzaba el problema.  De otro modo, el comando comenzaria desde el principio, asumiendo un proceso inecesariamente más largo.

Tras esto, el historial ya no contiene ninguna referencia a ese archivo. Pero, sin embargo, quedan referencias en el registro (reflog) y en el nuevo conjunto de referencias en `.git/refs/original` que Git ha añadido al procesar  `filter-branch`. Por lo que has de borrar también estás y reempaquetar la base de datos. Antes de reempaquetar, asegurate de acabar completamente con cualquier elemento que apunte a las viejas confirmaciones de cambios:

	$ rm -Rf .git/refs/original
	$ rm -Rf .git/logs/
	$ git gc
	Counting objects: 19, done.
	Delta compression using 2 threads.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (19/19), done.
	Total 19 (delta 3), reused 16 (delta 1)

Y ahora, vamos a ver cuanto espacio hemos ahorrado.

	$ git count-objects -v
	count: 8
	size: 2040
	in-pack: 19
	packs: 1
	size-pack: 7
	prune-packable: 0
	garbage: 0

El tamaño del repositorio ahora es de 7 KB, mucho mejor que los 2 MB anteriores. Por el valor de "size", puedes ver que el objeto enorme sigue estando entre tus objetos sueltos; es decir, no hemos acabado completamente con él. Pero lo importante es que ya no será considerado al transferir o clonar el proyecto. Si realmente quieres acabar del todo, puedes lanzar la orden  `git prune --expire` para retirar incluso ese archivo suelto. 

## Recapitulación ##

A estas alturas deberias tener una idea bastante clara de como trabaja Git entre bastidores. Y, hasta cierto punto, sobre cómo está implementado. En este capítulo se han visto unos cuantos comandos "de fontanería". Comandos de menor nivel y más simples que los "de porcelana" que hemos estado viendo en el resto del libro. Entendiendo cómo trabaja Git a bajo nivel, es más sencillo comprenderestán  por qué hace lo que hace. A la par que facilita la escritura de tus propias herramientas y scripts auxiliares para implementar flujos de trabajo tal y como necesites.

Git, en su calidad de sistema de archivos indexador-de-contenidos, es una herramienta muy poderosa  que puedes usar facilmente para otras tareas ademas de la de gestión de versiones. Espero que uses este nuevo conocimiento profundo de las entrañas de Git para implementar tus propias aplicaciones y para que te encuentres más confortable trabajando con Git de forma avanzada.
