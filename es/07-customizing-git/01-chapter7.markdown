# Personalizando Git #

Hasta ahora, hemos visto los aspectos básicos del funcionamiento de Git y la manera de utilizarlo; además de haber presentado una serie de herramientas suministradas con Git para ayudarnos a usarlo de manera sencilla y eficiente. En este capítulo, avanzaremos sobre ciertas operaciones que puedes utilizar para personalizar el funcionamiento de Git ; presentando algunos de sus principales ajustes y el sistema de anclajes (hooks). Con estas operaciones, será facil conseguir que Git trabaje exactamente como tú, tu empresa o tu grupo necesiteis.

## Configuración de Git ##

Como se ha visto brevemente en el capítulo 1, podemos acceder a los ajustes de configuración de Git a través del comando 'git config'. Una de las primeras acciones que has realizado con Git ha sido el configurar tu nombre y tu dirección de correo-e.

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Ahora vas a aprender un puñado de nuevas e interesantes opciones que puedes utilizar para personalizar el uso de Git.

Primeramente, vamos a repasar brevemente los detalles de configuración de Git que ya has visto en el primer capítulo. Para determinar su comportamiento no estandar, Git emplea una serie de archivos de configuración. El primero de ellos es el archivo '/etc/gitconfig', que contiene valores para todos y cada uno de los usuarios en el sistema y para todos sus repositorios. Con la opción '--system' del comando 'git config', puedes leer y escribir de/a este archivo. 

El segundo es el archivo '~/.gitconfig', específico para cada usuario. Con la opción '--global', 'git config' lee y escribe en este archivo. 

Y por último, Git también puede considerar valores de configuración presentes en el archivo '.git/config' de cada repositorio que estés utilizando. Estos valores se aplicarán únicamente a dicho repositorio. Cada nivel sobreescribe los valores del nivel anterior; es decir lo configurado en '.git/config' tiene primacia con respecto a lo configurado en '/etc/gitconfig', por ejemplo. También puedes ajustar estas configuraciones manualmente, editando directamente los archivos correspondientes y escribiendo en ellos con la sintaxis correspondiente; pero suele ser más sencillo hacerlo siempre a través del comando 'git config'.

### Configuración básica del cliente Git ###

Las opciones de configuración reconocidas por Git pueden distribuirse en dos grandes categorias: las del lado cliente y las del lado servidor. La mayoria de las opciones están en el lado cliente, --configurando tus preferencias personales de trabajo--. Aunque hay multitud de ellas, aquí vamos a ver solamente unas pocas. Las mas comunmente utilizadas o las que afectan significativamente a tu forma de trabajar. No vamos a revisar aquellas opciones utilizadas solo en casos muy especiales. Si quieres consultar una lista completa, con todas las opciones contempladas en tu versión de Git, puedes lanzar el comando:

	$ git config --help

La página de manual sobre 'git config' contiene una lista bastante detallada de todas las opciones disponibles.

#### core.editor ####

Por defecto, Git utiliza cualquier editor que hayas configurado como editor de texto por defecto de tu sistema. O, si no lo has configurado, utilizará Vi como editor para crear y editar las etiquetas y mensajes de tus confirmaciones de cambio (commit). Para cambiar ese comportamiento, puedes utilizar el ajuste 'core.editor':

	$ git config --global core.editor emacs

A partir de ese comando, por ejemplo, git lanzará Emacs cada vez que vaya a editar mensajes; indistintamente del editor configurado en la línea de comandos (shell) del sistema.

#### commit.template ####

Si preparas este ajuste para apuntar a un archivo concreto de tu sistema, Git lo utilizará como mensaje por defecto cuando hagas confirmaciones de cambio. Por ejemplo, imagina que creas una plantilla en '$HOME/.gitmessage.txt'; con un contenido tal como:

	subject line

	what happened

	[ticket: X]

Para indicar a Git que lo utilice como mensaje por defecto y que aparezca en tu editor cuando lances el comando 'git commit', tan solo has de ajustar 'commit.template':

	$ git config --global commit.template $HOME/.gitmessage.txt
	$ git commit

A partir de entonces, cada vez que confirmes cambios (commit), tu editor se abrirá con algo como esto:

	subject line

	what happened

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

Si tienes una política concreta con respecto a los mensajes de confirmación de cambios, puedes aumentar las posibilidades de que sea respetada si creas una plantilla acorde a dicha política y la pones como plantilla por defecto de Git.

#### core.pager ####

El parámetro core.pager selecciona el paginador utilizado por Git cuando muestra resultados de comandos tales como 'log' o 'diff'. Puedes ajustarlo para que utilice 'more' o tu paginador favorito, (por defecto, se utiliza 'less'); o puedes anular la paginación si le asignas una cadena vacia.

	$ git config --global core.pager ''

Si lanzas esto, Git mostrará siempre el resultado completo de todos los comandos, independientemente de lo largo que sea este.

#### user.signingkey ####

Si tienes costumbre de firmar tus etiquetas (tal y como se ha visto en el capítulo 2), configurar tu clave de firma GPG puede facilitarte la labor. Configurando tu clave ID de esta forma: 

	$ git config --global user.signingkey <gpg-key-id>

Puedes firmar etiquetas sin necesidad de indicar tu clave cada vez en el comando 'git tag'.

	$ git tag -s <tag-name>

#### core.excludesfile ####

Se pueden indicar expresiones en el archivo '.gitignore' de tu proyecto para indicar a Git lo que debe considerar o no como archivos sin seguimiento, o lo que interará o no seleccionar cuando lances el comando 'git add', tal y como se indicó en el capítulo 2.  Sin embargo, si quieres disponer de otro archivo fuera de tus proyectos o tener expresiones extra, puedes indicarselo a Git con el parámetro 'core.excludesfile'. Simplemente, configuralo para que apunte a un archivo con contenido similar al que tendría cualquier archivo '.gitignore'.

#### help.autocorrect ####

Este parámetro solo está disponible a partir de la versión 1.6.1 de Git. Cada vez que tienes un error de tecleo en un comando, Git 1.6 te muestra algo como:

	$ git com
	git: 'com' is not a git-command. See 'git --help'.

	Did you mean this?
	     commit

Si ajustas 'help.autocorrect' a 1, Git lanzará automáticamente el comando corregido, (pero solo cuando haya únicamente uno que pueda encajar).

### Colores en Git ###

Git puede marcar con colores los resultados que muestra en tu terminal, ayudandote así a leerlos más facilmente. Hay unos cuantos parámetros que te pueden ayudar a configurar tus colores favoritos.

#### color.ui ####

Si se lo pides, Git coloreará automáticamente la mayor parte de los resultados que muestre. Puedes ajustar con precisión cada una de las partes a colorear; pero si deseas activar de un golpe todos los colores por defecto, no tienes más que poner a "true" el parámetro 'color.ui'.

	$ git config --global color.ui true

Ajustando así este parámetro, Git colorea sus resultados cuando estos se muestran en un terminal. Otros ajustes posibles son "false", para indicar a Git no colorear nunca ninguno de sus resultados; y "always", para indicar colorear siempre, incluso cuando se redirija la salida a un archivo o a otro comando. Este parámetro se añadió en la versión 1.5.5 de Git. Si tienes una versión más antigua, tendrás que indicar especificamente todos y cada uno de los colores individualmente.

Será muy raro ajustar 'color.ui = always'. En la mayor parte de las ocasiones, cuando necesites códigos de color en los resultados, es mejor indicar puntualmente la opción '--color' en el comando concreto, para obligarle a utilizar códigos de color. Habitualmente, se trabajará con el ajuste 'color.ui = true'.

#### `color.*` ####

Cuando quieras ajustar específicamente, comando a comando, donde colorear y cómo colorear, (o cuando tengas una versión antigua de Git), puedes emplear los ajustes particulares de color. Cada uno de ellos puede fijarse a 'true' (verdadero), 'false' (falso) o 'always' (siempre):

	color.branch
	color.diff
	color.interactive
	color.status

Además, cada uno de ellos tiene parámetros adiccionales para asignar colores a partes específicas, por si quieres precisar aún más. Por ejemplo, para mostrar la meta-información del comando 'diff' con letra azul sobre fondo negro y con caracteres en negrita, puedes indicar:

	$ git config --global color.diff.meta “blue black bold”

Puedes ajustar un color a cualquiera de los siguientes valores: 'normal' (normal), 'black' (negro), 'green' (verde), 'yellow' (amarillo), 'blue' (azul oscuro), 'magenta' (rojo oscuro), 'cyan' (azul claro) o 'white' (blanco). También puedes aplicar atributos tales como 'bold' (negrita), 'dim' (tenue), 'ul' ( ), 'blink' (parpadeante) y 'reverse (video inverso).

Mira en la página man de 'git config' si deseas tener explicaciones más detalladas.

### Herramientas externas para fusionar y para comparar ###

Aunque Git lleva una implementación interna de diff, la que se utiliza habitualmente, se puede sustituir por una herramienta externa. Puedes incluso configurar una herramienta gráfica para la resolución de conflictos, en lugar de resolverlos manualmente. Lo voy a demostrar configurando Perforce Visual Merge como herramienta para realizar las comparaciones y resolver conflictos; ya que es una buena herramienta gráfica y es libre.

Si lo quieres probar, P4Merge funciona en todas las principales plataformas. Los nombres de carpetas que utilizaré en los ejemplos funcionan en sistemas Mac y Linux; para Windows, tendrás que sustituir '/usr/local/bin' por el correspondiente camino al ejecutable en tu sistema.

P4Merge se puede descargar desde:

	http://www.perforce.com/product/components/perforce-visual-merge-and-diff-tools

Para empezar, tienes que preparar los correspondientes scripts para lanzar tus comandos. En estos ejemplos, voy a utilizar caminos y nombres Mac para los ejecutables; en otros sistemas, tendrás que sustituirlos por los correspondientes donde tengas instalado 'p4merge'. El primer script a preparar es uno al que denominaremos 'extMerge', para llamar al ejecutable con los correspodientes argumentos:

	$ cat /usr/local/bin/extMerge
	#!/bin/sh
	/Applications/p4merge.app/Contents/MacOS/p4merge $*

El script para el comparador, ha de asegurarse de recibir siete argumentos y de pasar dos de ellos al script de fusion (merge). Por defecto, Git pasa los siguientes argumentos al programa diff (comparador):

	path old-file old-hex old-mode new-file new-hex new-mode

Ya que solo necesitarás 'old-file' y 'new-file', puedes utilizar el siguiente script para extraerlos:

	$ cat /usr/local/bin/extDiff 
	#!/bin/sh
	[ $# -eq 7 ] && /usr/local/bin/extMerge "$2" "$5"

Además has de asegurarte de que estas herramientas son ejecutables:

	$ sudo chmod +x /usr/local/bin/extMerge 
	$ sudo chmod +x /usr/local/bin/extDiff

Una vez preparado todo esto, puedes ajustar el archivo de configuración para utilizar tus herramientas personalizadas de comparación y resolución de conflictos. Tenemos varios parámetros a ajustar: 'merge.tool' para indicar a Git la estrategia que ha de usar, `mergetool.*.cmd` para especificar como lanzar el comando, 'mergetool.trustExitCode' para decir a Git si el código de salida del programa indica una fusión con éxito o no, y 'diff.external' para decir a Git qué comando lanzar para realizar comparaciones.  Es decir, has de ejecutar cuatro comandos de configuración:

	$ git config --global merge.tool extMerge
	$ git config --global mergetool.extMerge.cmd \
	    'extMerge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
	$ git config --global mergetool.trustExitCode false
	$ git config --global diff.external extDiff

o puedes editar tu archivo '~/.gitconfig' para añadirle las siguientes lineas:

	[merge]
	  tool = extMerge
	[mergetool "extMerge"]
	  cmd = extMerge \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\"
	  trustExitCode = false
	[diff]
	  external = extDiff

Tras ajustar todo esto, si lanzas comandos tales como:  $ git diff 32d1776b1 ^ 32d1776b1

En lugar de mostrar las diferencias por línea de comandos, Git lanzará P4Merge, que tiene una pinta como la de la Figura 7-1.

Insert 18333fig0701.png 
Figura 7-1. P4Merge.

Si intentas fusionar (merge) dos ramas y tienes los consabidos conflictos de integración, puedes lanzar el comando 'git mergetool'; lanzará P4Merge para ayudarte a resolver los conflictos por medio de su interfaz gráfica.

Lo bonito de estos ajustes con scripts, es que puedes cambiar facilmente tus herramientas de comparación (diff) y de fusión (merge). Por ejemplo, para cambiar tus scripts 'extDiff' y 'extMerge' para utilizar KDiff3, tan solo has de editar el archivo 'extMerge:

	$ cat /usr/local/bin/extMerge
	#!/bin/sh	
	/Applications/kdiff3.app/Contents/MacOS/kdiff3 $*

A partir de ahora, Git utilizará la herramienta KDiff3 para mostrar y resolver conflictos de integración.

Git viene preparado para utilizar bastantes otras herramientas de resolución de conflictos, sin necesidad de andar ajustando la configuración de cdm. Puedes utilizar kdiff3, opendiff, tkdiff, meld, xxdiff, emerge, vimdiff, o gvimdiff como herramientas de fusionado. Por ejemplo, si no te interesa utilizar KDiff3 para comparaciones, sino que tan solo te interesa utilizarlo para resolver conflictos de integración; teniendo kdiff3 en el path de ejecución, solo has de lanzar el comando:

	$ git config --global merge.tool kdiff3

Si utilizas este comando en lugar de preparar los archivos 'extMerge' y 'extDiff' antes comentados, Git utilizará KDiff3 para resolución de conflictos de integración y la herramienta estandar diff para las comparaciones.

### Formato y espacios en blanco ###

El formato y los espacios en blanco son la fuente de los problemas más sutiles y frustrantes que muchos desarrolladores se pueden encontrar en entornos colaborativos, especialmente si son multi-plataforma. Es muy facil que algunos parches u otro trabajo recibido introduzcan sutiles cambios de espaciado, porque los editores suelen hacerlo inadvertidamente o, trabajando en entornos multi-plataforma, porque programadores Windows suelen añadir retornos de carro al final de las lineas que tocan. Git dispone de algunas opciones de configuración para ayudarnos con estos problemas.

#### core.autocrlf ####

Si estás programando en Windows o utilizando algún otro sistema, pero colaborando con gente que programa en Windows. Es muy posible que alguna vez te topes con problemas de finales de línea. Esto se debe a que Windows utiliza retorno-de-carro y salto-de-linea para marcar los finales de línea de sus archivos. Mientras que Mac y Linux utilizan solamente el caracter de salto-de-linea. Esta es una sutil, pero molesta, diferencia cuando se trabaja en entornos multi-plataforma. 

Git la maneja autoconvirtiendo los finales CRLF en LF al hacer confirmaciones de cambios (commit); y, viceversa, al extraer código (checkout) a la carpeta de trabajo. Puedes activar esta funcionalidad con el parámetro 'core.autocrlf'. Si estás trabajando en una máquina Windows, ajustalo a 'true', --para convertir finales LF en CRLF cuando extraigas código (checkout)--.

	$ git config --global core.autocrlf true

Si estás trabajando en una máquina Linux o Mac, entonces no te interesa convertir automáticamente los finales de línea al extraer código. Sino que te interesa arreglar los posibles CRLF que pudieran aparecer accidentalmente. Puedes indicar a Git que convierta CRLF en LF al confirmar cambios (commit), pero no en el otro sentido; utilizando también el parámetro 'core.autocrlf':

	$ git config --global core.autocrlf input

Este ajuste dejará los finales de línea CRLF en las extraciones de código (checkout), pero los finales LF en sistemas Mac o Linux y en el repositorio.

Si eres un programador Windows, trabajando en un entorno donde solo haya máquinas Windows, puedes desconectar esta funcionalidad. Para almacenar CRLFs en el repositorio. Ajustando el parámero a 'false':

	$ git config --global core.autocrlf false

#### core.whitespace ####

Git viene preajustado para detectar y resolver algunos de los problemas más tipicos relacionados con los espacios en blanco. Puede vigilar acerca de cuatro tipos de problemas de espaciado --dos los tiene activados por defecto, pero se pueden desactivar; y dos vienen desactivados por defecto, pero se pueden activar--.

Los dos activos por defecto son 'trailing-space' (espaciado de relleno), que vigila por si hay espacios al final de las líneas, y 'space-before-tab' (espaciado delante de un tabulador), que mira por si hay espacios al principio de las lineas o por delante de los tabuladores.

Los dos inactivos por defecto son 'indent-with-non-tab' (indentado sin tabuladores), que vigila por si alguna línea empieza con ocho o mas espacios en lugar de con tabuladores; y 'cr-at-eol' (retorno de carro al final de línea), que vigila para que haya retornos de carro en todas las líneas.

Puedes decir a Git cuales de ellos deseas activar o desactivar, ajustando el parámetro 'core.whitespace' con los valores on/off separados por comas. Puedes desactivarlos tanto dejandolos fuera de la cadena de ajustes, como añadiendo el prefijo '-' delante del valor. Por ejemplo, si deseas activar todos menos 'cr-at-eol' puedes lanzar:

	$ git config --global core.whitespace \
	    trailing-space,space-before-tab,indent-with-non-tab

Git detectará posibles problemas cuando lance un comando 'git diff', e intentará destacarlos en otro color para que puedas corregirlos antes de confirmar cambios (commit). También pueden ser útiles estos ajustes cuando estás incorporando parches con 'git apply'. Al incorporar parches, puedes pedirle a Git que te avise específicamente sobre determinados problemas de espaciado:

	$ git apply --whitespace=warn <patch>

O puedes pedirle que intente corregir automáticamente los problemas antes de aplicar el parche:

	$ git apply --whitespace=fix <patch>

Estas opciones se pueden aplicar también al comando 'git rebase'. Si has confirmado cambios con problemas de espaciado, pero no los has enviado (push) aún "aguas arriba". Puedes realizar una reorganización (rebase) con la opción '--whitespace=fix' para que Git corrija automáticamente los problemas según va reescribiendo los parches.

### Configuración de Servidor ###

No hay tantas opciones de configuración en el lado servidor de Git. Pero hay unas pocas interesantes que merecen ser tenidas en cuenta.

#### receive.fsckObjects ####

Por defecto, Git no suele comprobar la consistencia de todos los objetos que recibe durante un envio (push). Aunque Git tiene la capacidad para asegurarse de que cada objeto sigue casando con su suma de control SHA-1 y sigue apuntando a objetos válidos. No lo suele hacer en todos y cada uno de los envios (push). Es una operación costosa, que, dependiendo del tamaño del repositorio, puede llegar a añadir mucho tiempo a cada operación de envio (push). De todas formas, si deseas que Git compruebe la consistencia de todos los objetos en todos los envios, puedes forzarle a hacerlo ajustando a 'true' el parámetro 'receive.fsckObjects':

	$ git config --system receive.fsckObjects true

A partir de ese momento, Git comprobará la integridad del repositorio antes de aceptar ningún envio (push), para asegurarse de que no está introduciendo datos corruptos.

#### receive.denyNonFastForwards ####

Si reorganizas (rebase) confirmaciones de cambio (commit) que ya habias enviado y tratas de enviarlas (push) de nuevo. O si intentas enviar una confirmación a una rama remota que no contiene la confirmación actualmente apuntada por la rama. Normalmente, la operación te será denegada por la rama remota sobre la que pretendias realizarla. Habitualmente, este es el comportamiento más adecuado. Pero, en el caso de las reorganizaciones, cuando estás totalmente seguro de lo que haces, puedes forzar el envio, utilizando la opción '-f' en el comando 'git push' a la rama remota.

Para impedir estos envios forzados de referencias de avance no directo (no fast-forward) a ramas remotas, es para lo que se emplea el parámetro 'receive.denyNonFastForwards':

	$ git config --system receive.denyNonFastForwards true

Otra manera de obtener el mismo resultado, es a través de los enganches (hooks) en el lado servidor. Enganches de los que hablaremos en breve. Esta otra vía te permite realizar ajustes más finos, tales como denegar refencias de avance no directo, (non-fast-forwards), unicamente a un grupo de usuarios.

#### receive.denyDeletes ####

Uno de los cortocircuitos que suelen utilizar los usuarios para saltarse la politica de 'denyNonFastForwards', suele ser el borrar la rama y luego volver a enviarla de vuelta con la nueva referencia. En las últimas versiones de Git (a partir de la 1.6.1), se puede evitar poniendo a 'true' el parámetro 'receive.denyDeletes':

	$ git config --system receive.denyDeletes true

Esto impide el borrado de ramas o de etiquetas por medio de un envio a través de la mesa (push across the board), --ningún usuario lo podrá hacer--. Para borrar ramas remotas, tendrás que borrar los archivos de referencia manualmente sobre el propio servidor. Existen también algunas otras maneras más interesantes de hacer esto mismo, pero para usuarios concretos, a través de permisos (ACLs); tal y como veremos al final de este capítulo.

## Atributos de Git ##

Algunos de los ajustes que hemos vistos, pueden ser especificados para un camino (path) concreto, de tal forma que Git los aplicará unicamente para una carpeta o para un grupo de archivos determinado. Estos ajustes específicos relacionados con un camino, se denominan atributos en Git. Y se pueden fijar, bien mediante un archivo '.gitattribute' en uno de los directorios de tu proyecto (normalmente en la raiz del proyecto), o bien mediante el archivo 'git/info/attributes en el caso de no querer guardar el archivo de atributos dentro de tu proyecto.

Por medio de los atributos, puedes hacer cosas tales como indicar diferentes estrategias de fusión para archivos o carpetas concretas de tu proyecto, decirle a Git cómo comparar archivos no textuales, o indicar a Git que filtre ciertos contenidos antes de guardarlos o de extraerlos del repositorio Git. En esta sección, aprenderas acerca de algunos atributos que puedes asignar a ciertos caminos (paths) dentro de tu proyecto Git, viendo algunos ejemplos de cómo utilizar sus funcionalidades de manera práctica.

### Archivos binarios ###

Un buen truco donde utilizar los atributos Git es para indicarle cuales de los archivos son binarios, (en los casos en que Git no podría llegar a determinarlo por sí mismo), dandole a Git instruciones especiales sobre cómo tratar estos archivos. Por ejemplo, algunos archivos de texto se generan automáticamente y no tiene sentido compararlos; mientras que algunos archivos binarios sí que pueden ser comparados --vamos a ver cómo indicar a Git cual es cual--.

#### Identificando archivos binarios ####

Algunos archivos aparentan ser textuales, pero a efectos prácticos merece más la pena tratarlos como binarios. Por ejemplo, los proyectos Xcode en un Mac contienen un archivo terminado en '.pbxproj'. Este archivo es básicamente una base de datos JSON (datos javascript en formato de texto plano), escrita directamente por el IDE para almacenar aspectos tales como tus ajustes de compilación. Aunque técnicamente es un archivo de texto, porque su contenido son caracteres ASCII. Realmente nunca lo tratarás como tal, porque en realidad es una base de datos ligera --y no puedes fusionar sus contenidos si dos personas lo cambian, porque las comparaciones no son de utilidad--. Estos son archivos destinados a ser tratados de forma automatizada. Y es preferible tratarlos como si fueran archivos binarios.

Para indicar a Git que trate todos los archivos 'pbxproj' como binarios, puedes añadir esta línea a tu archivo '.gitattriutes':

	*.pbxproj -crlf -diff

A partir de ahora, Git no intentará convertir ni corregir problemas CRLF en los finales de línea; ni intentará hacer comparaciones ni mostar diferencias de este archivo cuando lances comandos 'git show' o 'git diff' en tu proyecto. A partir de la versión 1.6 de Git, puedes utilizar una macro en lugar de las dos opciones '-crlf -diff':

	*.pbxproj binary

#### Comparando archivos binarios ####

A partir de la versión 1.6, puedes utilizar los atributos Git para comparar archivos binarios. Se consigue diciendole a Git la forma de convertir los datos binarios en texto, consiguiendo así que puedan ser comparado con la herramienta habitual de comparación textual.

Esta es una funcionalidad muy util, pero bastante desconocida. Por lo que la ilustraré con unos ejemplos. En el primero de ellos, utilizarás esta técnica para resolver uno de los problemas más engorrosos conocidos por la humanidad: el control de versiones en documentos Word. Todo el mundo conoce el hecho de que Word es el editor más horroroso de cuantos hay; pero, desgraciadamente, todo el mundo lo usa. Si deseas controlar versiones en documentos Word, puedes añadirlos a un repositorio Git e ir realizando confirmaciones de cambio (commit) cada vez. Pero, ¿qué ganas con ello?. Si lanzas un comando 'git diff', lo único que verás será algo tal como:

	$ git diff 
	diff --git a/chapter1.doc b/chapter1.doc
	index 88839c4..4afcb7c 100644
	Binary files a/chapter1.doc and b/chapter1.doc differ

No puedes comparar directamente dos versiones, a no ser que extraigas ambas y las compares manualmente, ¿no?. Pero resulta que puedes hacerlo bastante mejor utilizando los atributos Git. Poniendo lo siguiente en tu archivo '.gitattributes':

	*.doc diff=word

Así decimos a Git que sobre cualquier archivo coincidente con el patrón indicado, (.doc), ha de utilizar el filtro "word" cuando intentente hacer una comparación con él. ¿Qué es el filtro "word"? Tienes que configurarlo tú mismo. Por ejemplo, puedes configurar Git para que utilice el programa 'strings' para convertir los documentos Word en archivos de texto planos, archivos sobre los que poder realizar comparaciones sin problemas:

	$ git config diff.word.textconv strings

A partir de ahora, Git sabe que si intenta realizar una comparación entre dos momentos determinados (snapshots), y si cualquiera de los archivos a comparar termina en '.doc', tiene que pasar antes esos archivos por el filtro "word", es decir, por el programa 'strings'. Esto prepara versiones texto de los archivos Word, antes de intentar compararlos.

Un ejemplo. He puesto el capítulo 1 de este libro en Git, le he añadido algo de texto a un párrafo y he guardado el documento. Tras lo cual he lanzando el comando 'git diff' para ver lo que ha cambiado:

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

Git me indica correctamente que he añadido la frase "Let's see if this works". No es perfecto, --añade bastante basura aleatoria al final--, pero realmente funciona. Si pudieras encontrar o escribir un conversor suficientemente bueno de-Word-a-texto-plano, esta solución sería terriblemente efectiva. Sin embargo, ya que 'strings' está disponible para la mayor parte de los sistemas Mac y Linux, es buena idea probar primero con él para trabajar con formatos binarios.

Otro problema donde puede ser util esta técnica, es en la comparación de imágenes. Un camino puede ser pasar los archivos JPEG a través de un filtro para extraer su información EXIF --los metadatos que se graban dentro de la mayoria de formatos gráficos--. Si te descargas e instalas el programa 'exiftool', puedes utilizarlo para convertir tus imagenes a textos (metadatos), de tal forma que diff podrá al menos mostrarte algo útil de cualquier cambio que se produzca:

	$ echo '*.png diff=exif' >> .gitattributes
	$ git config diff.exif.textconv exiftool

Si sustituyes alguna de las imagenes en tu proyecto, y lanzas el comando 'git diff' obtendrás algo como:

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

Aquí se vé claramente que ha cambiado el tamaño del archivo y las dimensiones de la imagen.

### Expansión de palabras clave ###

Algunos usuarios de sistemas SVN o CVS, hechan de menos el disponer de expansiones de palabras clave al estilo de las que dichos sistemas tienen. El principal problema para hacerlo en Git reside en la imposibilidad de modificar los ficheros con información relativa a la confirmación de cambios (commit). Debido a que Git calcula sus sumas de comprobación antes de las confirmaciones. De todas formas, es posible inyectar textos en un archivo cuando lo extraemos del repositorio (checkout) y quitarlos de nuevo antes de devolverlo al repositorio (commit). Los atributos Git admiten dos maneras de realizarlo.

La primera, es inyectando automáticamente la suma de comprobación SHA-1 de un gran objeto binario (blob) en un campo '$Id$' dentro del archivo. Si colocas este attributo en un archivo o conjunto de archivos, Git lo sustituirá por la suma de comprobación SHA-1 la próxima vez que lo/s extraiga/s. Es importante destacar que no se trata de la suma SHA de la confirmación de cambios (commit), sino del propio objeto binario (blob):

	$ echo '*.txt ident' >> .gitattributes
	$ echo '$Id$' > test.txt

La próxima vez que extraigas el archivo, Git le habrá inyectado el SHA del objeto binario (blob):

	$ rm text.txt
	$ git checkout -- text.txt
	$ cat test.txt 
	$Id: 42812b7653c7b88933f8a9d6cad0ca16714b9bb3 $

Pero esto tiene un uso bastante limitado. Si has utilizado alguna vez las sustituciones de CVS o de Subversion, sabrás que pueden incluir una marca de fecha, --la suma de comprobación SHA no es igual de util, ya que, por ser bastante aleatoria, es imposible deducir si una suma SHA es anterior o posterior a otra--.

Auque resulta que también puedes escribir tus propios filtros para realizar sustituciones en los archivos al guardar o recuperar (commit/checkout). Esos son los filtros "clean" y "smudge". En el archivo '.gitattibutes', puedes indicar filtros para carpetas o archivos determinados y luego preparar tus propios scripts para procesarlos justo antes de confirmar cambios en ellos ("clean", ver Figura 7-2), o justo antes de recuperarlos ("smudge", ver Figura 7-3). Estos filtros pueden utilizarse para realizar todo tipo de acciones útiles.

Insert 18333fig0702.png 
Figura 7-2. El filtro "smudge" se usa al extraer (checkout).

Insert 18333fig0703.png 
Figura 7-3. El filtro "clean" se usa al almacenar (staged).

El mensaje de confirmación para esta funcionalidad nos da un ejemplo simple: el de pasar todo tu código fuente C por el programa'indent' antes de almacenarlo. Puedes hacerlo poniendo los atributos adecuados en tu archivo '.gitattributes', para filtrar los archivos `*.c` a través de "indent":

	*.c     filter=indent

E indicando después que el filtro "indent" actuará al manchar (smudge) y al limpiar (clean):

	$ git config --global filter.indent.clean indent
	$ git config --global filter.indent.smudge cat

En este ejemplo, cuando confirmes cambios (commit) en archivos con extensión `*.c`, Git los pasará previamente a través del programa 'indent' antes de confirmarlos, y los pasará a través del programa 'cat' antes de extraerlos de vuelta al disco. El programa 'cat' es básicamente transparente: de él salen los mismos datos que entran. El efecto final de esta combinación es el de filtrar todo el código fuente C a través de 'indent' antes de confirmar cambios en él.

Otro ejemplo interesante es el de poder conseguir una expansión de la clave '$Date$' del estilo de RCS. Para hacerlo, necesitas un pequeño script que coja el nombre de un archivo, localice la fecha de la última confirmación de cambios en el proyecto, e inserte dicha información en el archivo. Este podria ser un pequeño script Ruby para hacerlo:

	#! /usr/bin/env ruby
	data = STDIN.read
	last_date = `git log --pretty=format:"%ad" -1`
	puts data.gsub('$Date$', '$Date: ' + last_date.to_s + '$')

Simplemente, utiliza el comando 'git log' para obtener la fecha de la última confirmación de cambios, y  sustituye con ella todas las cadenas '$Date$' que encuentre en el flujo de entrada stdin; imprimiendo luego los resultados. --Debería de ser sencillo de implementarlo en cualquier otro lenguaje que domines.-- Puedes llamar 'expand_date' a este archivo y ponerlo en el path de ejecución. Tras ello, has de poner un filtro en Git (podemos llamarle 'dater'), e indicarle que use el filtro 'expand_date' para manchar (smudge) los archivos al extraerlos (checkout). Puedes utilizar una expresión Perl para limpiarlos (clean) al almacenarlos (commit):

	$ git config filter.dater.smudge expand_date
	$ git config filter.dater.clean 'perl -pe "s/\\\$Date[^\\\$]*\\\$/\\\$Date\\\$/"'

Esta expresión Perl extrae cualquier cosa que vea dentro de una cadena '$Date$', para devolverla a como era en un principio. Una vez preparado el filtro, puedes comprobar su funcionamiento preparando un archivo que contenga la clave '$Date$' e indicando a Git cual es el atributo para reconocer ese tipo de archivo:

	$ echo '# $Date$' > date_test.txt
	$ echo 'date*.txt filter=dater' >> .gitattributes

Al confirmar cambios (commit) y luego extraer (checkout) el archivo de vuelta, verás la clave sutituida:

	$ git add date_test.txt .gitattributes
	$ git commit -m "Testing date expansion in Git"
	$ rm date_test.txt
	$ git checkout date_test.txt
	$ cat date_test.txt
	# $Date: Tue Apr 21 07:26:52 2009 -0700$

Esta es una muestra de lo poderosa que puede resultar esta técnica para aplicaciones personalizadas. No obstante, debes de ser cuidadoso, ya que el archivo '.gitattibutes' se almacena y se transmite junto con el proyecto; pero no así el propio filtro, (en este caso, 'dater'), sin el cual no puede funcionar. Cuando diseñes este tipo de filtros, han de estar pensados para que el proyecto continue funcionando correctamente incluso cuando fallen.

### Exportación del repositorio ###

Los atributos de Git permiten realizar algunas cosas interesantes cuando exportas un archivo de tu proyecto.

#### export-ignore ####

Puedes indicar a Git que ignore y no exporte ciertos archivos o carpetas cuando genera un archivo de almacenamiento. Cuando tienes alguna carpeta o archivo que no deseas incluir en tus registros, pero quieras tener controlado en tu proyecto, puedes marcarlos a través del atributo 'export-ignore'.

Por ejemplo, digamos que tienes algunos archivos de pruebas en la carpeta 'test/', y que no tiene sentido incluirlos en los archivos comprimidos (tarball) al exportar tu proyecto. Puedes añadir la siguiente línea al archivo de atributos de Git:

	test/ export-ignore

A partir de ese momento, cada vez que lances el comando 'git archive' para crear un archivo comprimido de tu proyecto, esa carpeta no se incluirá en él.

#### export-subst ####

Otra cosa que puedes realizar sobre tus archivos es algún tipo de sustitución simple de claves. Git te permite poner la cadena '$Format:$' en cualquier archivo, con cualquiera de las claves de formateo de '--pretty=format' que vimos en el capítulo 2. Por ejemplo, si deseas incluir un archivo llamado 'LAST COMMIT' en tu proyecto, y poner en él automáticamente la fecha de la última confirmación de cambios cada vez que lances el comando 'git archive':

	$ echo 'Last commit date: $Format:%cd$' > LAST_COMMIT
	$ echo "LAST_COMMIT export-subst" >> .gitattributes
	$ git add LAST_COMMIT .gitattributes
	$ git commit -am 'adding LAST_COMMIT file for archives'

Cuando lances la orden 'git archive', lo que la gente verá en ese archivo cuando lo abra será:

	$ cat LAST_COMMIT
	Last commit date: $Format:Tue Apr 21 08:38:48 2009 -0700$

### Estrategias de fusión ###

También puedes utilizar los atributos Git para indicar distintas estrategias de fusión para archivos específicos de tu proyecto. Una opción muy util es la que nos permite indicar a Git que no intente fusionar ciertos archivos concretos cuando tengan conflictos, manteniendo en su lugar tus archivos sobre los de cualquier otro.

Puede ser interesante si una rama de tu proyecto es divergente o esta especializada, pero deseas seguir siendo capaz de fusionar cambios de vuelta desde ella, e ignorar ciertos archivos. Digamos que tienes un archivo de datos denominado database.xml, distinto en las dos ramas, y que deseas fusionar en la otra rama sin perturbarlo. Puedes ajustar un atributo tal como:

	database.xml merge=ours

Al fusionar con otra rama, en lugar de tener conflictos de fusión con el archivo database.xml, obtendrás algo como:

	$ git merge topic
	Auto-merging database.xml
	Merge made by recursive.

Y el archivo database.xml permanecerá inalterado en cualquier que fuera la versión que tú tenias originalmente.

## Puntos de enganche Git ##

Al igual que en otros sistemas de control de versiones, Git también cuenta con mecanismos para lanzar scrips de usuario cuando suceden ciertas acciones importantes. Hay dos grupos de esos puntos de lanzamiento: los del lado cliente y los del lado servidor. Los puntos del lado cliente están relacionados con operaciones tales como la confirmación de cambios (commit) o la fusión (merge). Los del lado servidor están relacionados con operaciones tales como la recepción de contenidos enviados (push) a un servidor. Estos puntos de enganche pueden utilizarse para multitud de aplicaciones. Vamos a ver unas pocas de ellas.

### Instalando un punto de enganche ###

Los puntos de enganche se guardan en la subcarpeta 'hooks' de la carpeta Git. En la mayoría de proyectos, estará en '.git/hooks'. Por defecto, esta carpeta contiene unos cuantos scripts de ejemplo. Algunos de ellos son útiles por sí mismos; pero su misión principal es la de documentar las variables de entrada para cada script. Todos los ejemplos se han escrito como scripts de shell, con algo de código Perl embebido en ellos. Pero cualquier tipo de script ejecutable que tenga el nombre adecuado puede servir igual de bien --los puedes escribir en Ruby o en Python o en cualquier lenguaje de scripting con el que trabajes--. En las versiones de Git posteriores a la 1.6, esos ejemplos tendrán un nombre acabado en .sample; y tendras que renombrarlos. Para las versiones anteriores a la 1.6, los ejemplos tienen el nombre correcto, pero les falta la marca de ejecutables.

Para activar un punto de enganche para un script, pon el archivo correspondiente en la carpeta 'hooks'; con el nombre adecuado y con la marca de ejecutable. A partir de ese momento, será automáticamente lanzado cuando se dé la acción correspondiente. Vamos a ver la mayoría de nombres de puntos de enganche disponibles.

### Puntos de enganche del lado cliente ###

Hay muchos de ellos. En esta sección los dividiremos en puntos de enganche en el flujo de trabajo de confirmación de cambios, puntos en el flujo de trabajo de correo electrónico y resto de puntos de enganche del lado servidor. 

#### Puntos en el flujo de trabajo de confirmación de cambios ####

Los primeros cuatro puntos de enganche están relacionados con el proceso de confirmación de cambios. Primero se activa el punto de enganche 'pre-commit', incluso antes de que teclees el mensaje de confirmación. Se suele utilizar para inspeccionar la instantánea (snapshot) que vas a confirmar, para ver si has olvidado algo, para asegurar que las pruebas se ejecutan, o para revisar cualquier aspecto que necesites inspeccionar en el codigo. Saliendo con un valor de retorno distinto de cero, se aborta la confirmación de cambios. Aunque siempre puedes saltartelo con la orden 'git commit --no-verify'. Puede ser util para realizar tareas tales como revisar el estilo del código (lanzando 'lint' o algo equivalente), revisar los espacios en blanco de relleno (el script de ejemplo hace exactamente eso), o revisar si todos los nuevos métodos llevan la adecuada documentación.

El punto de enganche 'prepare-commit-msg' se activa antes de arrancar el editor del mensaje de confirmación de cambios, pero después de crearse el mensaje por defecto. Te permite editar el mensaje por defecto, antes de que lo vea el autor de la confirmación de cambios. Este punto de enganche recibe varias entradas: la ubicación (path) del archivo temporal donde se almacena el mensaje de confirmación, el tipo de confirmación y la clave SHA-1 si estamos enmendando un commit existente. Este punto de enganche no tiene mucha utilidad para las confirmaciones de cambios normales; pero sí para las confirmaciones donde el mensaje por defecto es autogenerado, como en las confirmaciones de fusiones (merge), los mensajes con plantilla, las confirmaciones aplastadas (squash), o las confirmaciones de correccion (amend). Se puede utilizar combinandolo con una plantilla de confirmación, para poder insertar información automáticamente.

El punto de enganche 'commit-msg' recibe un parámetro: la ubicación (path) del archivo temporal que contiene el mensaje de confirmación actual. Si este script termina con un código de salida distinto de cero, Git aborta el proceso de confirmación de cambios; permitiendo así validar el estado del proyecto o el mensaje de confirmación antes de permitir continuar. En la última parte de este capítulo, veremos cómo podemos utilizar este punto de enganche  para revisar si el mensaje de confirmación es conforme a un determinado patrón obligatorio.

Despues de completar todo el proceso de confirmación de cambios, es cuando se lanza el punto de enganche 'post-commit'. Este no recibe ningún parámetro, pero podemos obtener facilmente la última confirmación de cambios con el comando 'git log -1 HEAD'. Habitualmente, este script final se suele utilizar para realizar notificaciones o tareas similares.

Los scripts del lado cliente relacionados con la confirmación de cambios pueden ser utilizados en prácticamente cualquier flujo de trabajo. A menudo, se suelen utilizar para obligar a seguir ciertas reglas; aunque es importante indicar que estos script no se transfieren durante el clonado. Puedes implantar reglas en el lado servidor para rechazar envios (push) que no cumplan ciertos estandares, pero es completamente voluntario para los desarroladores el utilizar scripts en el lado cliente. Por tanto, estos scripts son para ayudar a los desarrolladores, y, como tales, han de ser configurados y mantenidos por ellos, pudiendo ser sobreescritos o modificados por ellos en cualquier momento.

#### Puntos en el flujo de trabajo del correo electrónico ####

Tienes disponibles tres puntos de enganche en el lado cliente para interactuar con el flujo de trabajo de correo electrónico. Todos ellos se invocan al utilizar el comando 'git am', por lo que si no utilizas dicho comando, puedes saltar directamente a la siguiente sección. Si recibes parches a través de corrreo-e preparados con 'git format-patch', es posible que parte de lo descrito en esta sección te pueda ser util.

El primer punto de enganche que se activa es 'applypatch-msg'. Recibe un solo argumento: el nombre del archivo temporal que contiene el mensaje de confirmación propuesto. Git abortará la aplicación del parche si este script termina con un código de salida distinto de cero. Puedes utilizarlo para asegurarte de que el mensaje de confirmación esté correctamente formateado o para normalizar el mensaje permitiendo al script que lo edite sobre la marcha.

El siguiente punto de enganche que se activa al aplicar parches con 'git am' es el punto 'pre-applypatch'. No recibe ningún argumento de entrada y se lanza después de que el parche haya sido aplicado, por lo que puedes utilizarlo para revisar la situación (snapshot) antes de confirmarla. Con este script, puedes lanzar pruebas o similares para chequear el arbol de trabajo. Si falta algo o si alguna de las pruebas falla, saliendo con un código de salida distinto de cero abortará el comando 'git am' sin confirmar el parche.

El último punto de enganche que se activa durante una operación 'git am' es el punto 'post-applypatch'. Puedes utilizarlo para notificar de su aplicación al grupo o al autor del parche. No puedes detener el proceso de parcheo con este script.

#### Otros puntos de enganche del lado cliente ####

El punto 'pre-rebase' se activa antes de cualquier reorganización y puede abortarla si retorna con un codigo de salida distinto de cero. Puedes usarlo para impedir reorganizaciones de cualquier confirmación de cambios ya enviada (push) a algún servidor.  El script de ejemplo para 'pre-rebase' hace precisamente eso, aunque asumiendo que 'next' es el nombre de la rama publicada. Si lo vas a utilizar, tendrás que modificarlo para que se ajuste al nombre que tenga tu rama publicada.

Tras completarse la ejecución de un comando 'git checkout', es cuando se activa el punto de enganche 'post-checkout. Lo puedes utilizar para ajustar tu carpeta de trabajo al entorno de tu proyecto. Entre otras cosas, puedes mover grandes archivos binarios de los que no quieras llevar control, puedes autogenerar documentación,.... 

Y, por último, el punto de enganche 'post-merge' se activa tras completarse la ejecución de un comando 'git merge'. Puedes utilizarlo para recuperar datos de tu carpeta de trabajo que Git no puede controlar, como por ejemplo datos relativos a permisos. Este punto de enganche puede utilizarse también para comprobar la presencia de ciertos archivos, externos al control de Git, que desees copiar cada vez que cambie la carpeta de trabajo.

### Puntos de enganche del lado servidor ###

Aparte de los puntos del lado cliente, como administrador de sistemas, puedes utilizar un par de puntos de enganche importantes en el lado servidor; para implementar prácticamente cualquier tipo de política que quieras mantener en tu proyecto. Estos scripts se lanzan antes y después de cada envio (push) al servidor. El script previo, puede terminar con un código de salida distinto de cero y abortar el envio, devolviendo el correspondiente mensaje de error al cliente. Este script puede implementar políticas de recepción tan complejas como desees.

#### 'pre-receive' y 'post-receive' ####

El primer script que se activa al manejar un envio de un cliente es el correspondiente al punto de enganche 'pre-receive'. Recibe una lista de referencias que se están enviando (push) desde la entrada estandar (stdin); y, si termina con un codigo de salida distinto de cero, ninguna de ellas será aceptada. Puedes utilizar este punto de enganche para realizar tareas tales como la de comprobar que ninguna de las referencias actualizadas no son de avance directo (non-fast-forward); o para comprobar que el usuario que realiza el envio tiene realmente permisos para para crear, borrar o modificar cualquiera de los archivos que está tratando de cambiar.

El punto de enganche 'post-receive' se activa cuando termina todo el proceso, y se puede utilizar para actualizar otros servicios o para enviar notificaciones a otros usuarios. Recibe los mismos datos que 'pre-receive' desde la entrada estandar. Algunos ejemplos de posibles aplicaciones pueden ser la de alimentar una lista de correo-e, avisar a un servidor de integración continua, o actualizar un sistema de seguimiento de tickets de servicio --pudiendo incluso procesar el mensaje de confirmación para ver si hemos de abrir, modificar o dar por cerrado algún ticket--. Este script no puede detener el proceso de envio, pero el cliente no se desconecta hasta que no se completa su ejecución; por tanto, has de ser cuidadoso cuando intentes realizar con él tareas que puedan requerir mucho tiempo.

#### update ####

El punto de enganche 'update' es muy similar a 'pre-receive', pero con la diferencia de que se activa una vez por cada rama que se está intentando actualizar con el envio. Si la persona que realiza el envio intenta actualizar varias ramas, 'pre-receive' se ejecuta una sola vez, mientras que 'update' se ejecuta tantas veces como ramas se estén actualizando. El lugar de recibir datos desde la entrada estandar (stdin), este script recibe tres argumentos: el nombre de la rama, la clave SHA-1 a la que esta apuntada antes del envio, y la clave SHA-1 que el usuario está intentando enviar. Si el script 'update' termina con un código de salida distinto de cero, únicamente los cambios de esa rama son rechazados; el resto de ramas continuarán con sus actualizaciones.

## Un ejemplo de implantación de una determinada política en Git ##

En esta sección, utilizarás lo aprendido para establecer un flujo de trabajo en Git que: compruebe si los mensajes de confirmación de cambios encajan en un determinado formato, obligue a realizar solo envios de avance directo, y permita solo a ciertos usuarios modificar ciertas carpetas del proyecto. Para ello, has de preparar los correspondientes scripts de cliente (para ayudar a los desarrolladores a saber de antemano si sus envios van a ser rechazados o no), y los correspondientes scripts de servidor (para obligar a cumplir esas políticas).

He usado Ruby para escribir los ejemplos, tanto porque es mi lenguaje preferido de scripting y porque creo que es el más parecido a pseudocódigo; de tal forma que puedas ser capaz de seguir el código, incluso si no conoces Ruby. Pero, puede ser igualmente válido cualquier otro lenguaje. Todos los script de ejemplo que vienen de serie con Git están escritos en Perl o en Bash shell, por lo que tienes bastantes ejemplos en esos lenguajes de scripting.

### Punto de enganche en el lado servidor ###

Todo el trabajo del lado servidor va en el script 'update' de la carpeta 'hooks'. El script 'update' se lanza una vez por cada rama que se envia (push) al servidor; y recibe la referencia de la rama a la que se envia, la antigua revisión en que estaba la rama y la nueva revisión que se está enviando. También puedes tener acceso al usuario que está enviando, si este los envia a través de SSH. Si has permitido a cualquiera conectarse con un mismo usuario (como "git", por ejemplo), has tenido que dar a dicho usuario una envoltura (shell wraper) que te permite determinar cual es el usuario que se conecta según sea su clave pública, permitiendote fijar una variable de entorno especificando dicho usuario. Aqui, asumiremos que el usuario conectado queda reflejado en la variable de entorno '$USER', de tal forma que el script 'update' comienza recogiendo toda la información que necesitas:

	#!/usr/bin/env ruby#!/usr/bin/env ruby#!/usr/bin/env ruby

	$refname = ARGV[0]
	$oldrev  = ARGV[1]
	$newrev  = ARGV[2]
	$user    = ENV['USER']

	puts "Enforcing Policies... \n(#{$refname}) (#{$oldrev[0,6]}) (#{$newrev[0,6]})"

Sí, estoy usando variables globales. No me juzgues por ello, --es más sencillo mostrarlo de esta manera--.

#### Obligando a utilizar un formato específico en el mensaje de confirmación de cambios ####

Tu primer reto es asegurarte que todos y cada uno de los mensajes de confirmación de cambios se ajustan a un determinado formato. Simplemente por fijar algo concreto, supongamos que cada mensaje ha de incluir un texto tal como "ref: 1234", porque quieres enlazar cada confirmación de cambios con una determinada entrada de trabajo en un sistema de control. Has de mirar en cada confirmación de cambios (commit) recibida, para ver si contiene ese texto; y, si no lo trae, salir con un código distinto de cero, de tal forma que el envio (push) sea rechazado.

Puedes obtener la lista de las claves SHA-1 de todos las confirmaciones de cambios enviadas cogiendo los valores de '$newrev' y de '$oldrev', y pasandolos a comando de mantenimiento de Git llamado 'git rev-list'. Este comando es básicamente el mismo que 'git log', pero por defecto, imprime solo los valores SHA-1 y nada más. Con él, puedes obtener la lista de todas las claves SHA que se han introducido entre una clave SHA y otra clave SHA dadas; obtendrás algo así como esto:

	$ git rev-list 538c33..d14fc7
	d14fc7c847ab946ec39590d87783c69b031bdfb7
	9f585da4401b0a3999e84113824d15245c13f0be
	234071a1be950e2a8d078e6141f5cd20c1e61ad3
	dfa04c9ef3d5197182f13fb5b9b1fb7717d2222a
	17716ec0f1ff5c77eff40b7fe912f9f6cfd0e475

Puedes coger esta salida, establecer un bucle para recorrer cada una de esas confirmaciones de cambios, coger el mensaje de cada una y comprobarlo contra una expresión regular de búsqueda del patrón deseado.

Tienes que imaginarte cómo puedes obtener el mensaj ede cada una de esas confirmaciones de cambios a comprobar. Para obtener los datos "en crudo"  de una confirmación de cambios, puedes utilizar otro comando de mantenimiento de Git denominado 'git cat-file'. En el capítulo 9 volveremos en detalle sobre estos comandos de mantenimiento; pero, por ahora, esto es lo que obtienes con dicho comando:

	$ git cat-file commit ca82a6
	tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
	parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	author Scott Chacon <schacon@gmail.com> 1205815931 -0700
	committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

	changed the version number

Una vía sencilla para obtener el mensaje, es la de ir hasta la primera línea en blanco y luego coger todo lo que siga a esta. En los sistemas Unix, lo puedes realizar con el comando 'sed':

	$ git cat-file commit ca82a6 | sed '1,/^$/d'
	changed the version number

Puedes usar este "hechizo mágico" para coger el mensaje de cada confirmación de cambios que se está enviando y salir si localizas algo que no cuadra en alguno de ellos. Para salir del script y rechazar el envio, recuerda que debes salir con un código distinto de cero. El método completo será algo así como:

	$regex = /\[ref: (\d+)\]/$regex = /\[ref: (\d+)\]/

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

Poniendo esto en tu script 'update', serán rechazadas todas las actualizaciones que contengan cambios con mensajes que no se ajusten a tus reglas.

#### Implementando un sistema de control de accesos basado en usuario ####

Imaginemos que deseas implementar un sistema de control de accesos (Access Control List, ACL). Para vigilar qué usuarios pueden enviar (push) cambios a qué partes de tus proyectos. Algunas personas tendrán acceso completo, y otras tan solo acceso a ciertas carpetas o a ciertos archivos. Para implementar esto, has de escribir esas reglas de acceso en un archivo denominado 'acl' ubicado en tu repositorio git básico en el servidor. Y tienes que preparar el enganche 'update' para hacerle consultar esas reglas, mirar los archivos que están siendo subidos en las confirmaciones de cambio (commit) enviadas (push), y determinar así si el usuario emisor del  envio tiene o no permiso para actualizar esos archivos.

Como hemos dicho, el primer paso es escribir tu lista de control de accesos (ACL). Su formato es muy parecido al del mecanismo CVS ACL: utiliza una serie de líneas donde el primer campo es 'avail' o 'unavail' (permitido o no permitido), el segundo campo es una lista de usuarios separados por comas, y el último campo es la ubicación (path) sobre el que aplicar la regla (dejarlo en blanco equivale a un acceso abierto). Cada uno de esos campos se separan entre sí con el caracter barra vertical ('|').

Por ejemplo, si tienes un par de administradores, algunos redactores técnicos con acceso a la carpeta 'doc', y un desarrollador que únicamente accede a las carpetas 'lib' y 'test', el archivo ACL resultante seria:

	avail|nickh,pjhyett,defunkt,tpw
	avail|usinclair,cdickens,ebronte|doc
	avail|schacon|lib
	avail|schacon|tests

Para implementarlo, hemos de leer previamente estos datos en una estructura que podamos emplear. En este caso, por razones de simplicidad, vamos a mostrar únicamente la forma de implementar las directivas 'avail' (permitir). Este es un método que te devuelve un array asociativo cuya clave es el nombre del usuario y su valor es un array de ubicaciones (paths) donde ese usuario tiene acceso de escritura:

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

Si lo aplicamos sobre la lista ACL descrita anteriormente, este método 'get acl access_data' devolverá una estructura de datos similar a esta:

	{"defunkt"=>[nil],
	 "tpw"=>[nil],
	 "nickh"=>[nil],
	 "pjhyett"=>[nil],
	 "schacon"=>["lib", "tests"],
	 "cdickens"=>["doc"],
	 "usinclair"=>["doc"],
	 "ebronte"=>["doc"]}

Una vez tienes los permisos en orden, necesitas averiguar las ubicaciones modificadas por las confirmaciones de cambios enviadas; de tal forma que puedas asegurarte de que el usuario que las está enviando tiene realmente permiso para modificarlas.

Puedes comprobar facilmente qué archivos han sido modificados en cada confirmación de cambios, utilizando la opción '--name-only' del comando 'git log' (citado brevemente en el capítulo 2):

	$ git log -1 --name-only --pretty=format:'' 9f585d

	README
	lib/test.rb

Utilizando la estructura ACL devuelta por el método 'get_acl_access_data' y comprobandola sobre la lista de archivos de cada confirmación de cambios, puedes determinar si el usuario tiene o no permiso para enviar dichos cambios:

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
	        if !access_path || # user has access to everything
	          (path.index(access_path) == 0) # access to this path
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

	check_directory_permscheck_directory_perms

La mayor parte de este código debería de ser sencillo de leer. Con 'git rev-list', obtienes una lista de las nuevas confirmaciones de cambio enviadas a tu servidor. Luego, para cada una de ellas, localizas los archivos modificados y te aseguras de que el usuario que las envia tiene realmente acceso a todas las ubicaciones que pretende modificar. Un "rubysmo" que posiblemente sea un tanto oscuro puede ser 'path.index(access_path) == 0' . Simplemente devuelve verdadero en el caso de que la ubicacion comience por 'access_path' ; de esta forma, nos aseguramos de que 'access_path' no esté solo contenido en una de las ubicaciones permitidas, sino sea una ubicación permitida la que comience con la ubicación accedida. 

Una vez implementado todo esto, tus usuarios no podrán enviar confirmaciones de cambios con mensajes mal formados o con modificaciones sobre archivos fuera de las ubicaciones que les hayas designado.

#### Obligando a realizar envios solo-de-avance-rapido (Fast-Forward-Only pushes) ####

Lo único que nos queda por implementar es un mecanismo para limitar los envios a envios de avance rápido (Fast-Forward-Only pushes). En las versiones a partir de la 1.6, puedes ajustar las opciones 'receive.denyDeletes' (prohibir borrados) y 'receive.denyNonFastForwards' (prohibir envios que no sean avances-rápidos). Pero haciendolo a través de un enganche (hook), podrá funcionar también en versiones anteriores de Git, podrás modificarlo para que actue únicamente sobre ciertos usuarios, o podrás realizar cualquier otra acción que estimes oportuna.

La lógica para hacer así la comprobación es la de mirar por si alguna confirmación de cambios se puede alcanzar desde la versión más antigua pero no desde la más reciente. Si hay alguna, entonces es un envio de avance-rápido (fast-forward push); sino hay ninguna, es un envio a prohibir:

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

Una vez esté todo listo. Si lanzas el comando 'chmod u+x .git/hooks/update', siendo este el archivo donde has puesto todo este código; y luego intentas enviar una referencia que no sea de avance-rápido, obtendrás algo como esto:

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
	error: failed to push some refs to 'git@gitserver:project.git'[remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'

Tenemos un para de aspectos interesantes aquí. Lo primero observado cuando el enganche (hook) arranca es:

	Enforcing Policies... 
	(refs/heads/master) (fb8c72) (c56860)

Precisamente, lo enviado a la salida estandar stdout justo al principio del script de actualización. Cabe destacar que todo lo que se envie a la salida estandar stdout, será transferido al cliente.

Lo segundo que se puede apreciar es el mensaje de error:

	[POLICY] Cannot push a non fast-forward reference
	error: hooks/update exited with error code 1
	error: hook declined to update refs/heads/master

La primera línea la has enviado tú, pero las otras dos son de Git. Indicando que el script de actualización ha terminado con código no-cero y, por tanto, ha rechazado la modificación. Y, por último, se ve:

	To git@gitserver:project.git
	 ! [remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'[remote rejected] master -> master (hook declined)
	error: failed to push some refs to 'git@gitserver:project.git'

Un mensaje por cada referencia rechazada por el enganche (hook) de actualización, especificando que ha sido rechazada precisamente por un fallo en el enganche.

Es más, si la referencia (ref marker) no se encuentra presente para alguna de las confirmaciones de cambio, verás el mensaje de error previsto para ello:

	[POLICY] Your message is not formatted correctly

O si alguien intenta editar un archivo sobre el que no tiene acceso y luego envia una confirmación de cambios con ello, verá también algo similar. Por ejemplo, si un editor técnico intenta enviar una confirmación de cambios donde se haya modificado algo de la carpeta 'lib', verá:

	[POLICY] You do not have access to push to lib/test.rb

Y eso es todo. De ahora en adelante, en tanto en cuando el script 'update' este presente y sea ejecutable, tu repositorio nunca se verá perjudicado, nunca tendrá un mensaje de confirmación de cambios sin tu plantilla y tus usuarios estarán controlados.

### Puntos de enganche del lado cliente ###

Lo malo del sistema descrito en la sección anterior pueden ser los lamentos que inevitablemente se van a producir cuando los envios de tus usuarios sean rechazados. Ver rechazado en el último minuto su tan cuidadosamente preparado trabajo, puede ser realmente frustrante. Y, aún peor, tener que reescribir su histórico para corregirlo puede ser un auténtico calvario.

La solución a este dilema es el proporcionarles algunos enganches (hook) del lado cliente, para que les avisen cuando están trabajando en algo que el servidor va a rechazarles. De esta forma, pueden corregir los problemas antes de confirmar cambios y antes de que se conviertan en algo realmente complicado de arreglar. Debido a que estos enganches no se transfieren junto con el clonado de un proyecto, tendrás que distribuirlos de alguna otra manera. Y luego pedir a tus usuarios que se los copien a sus carpetas '.git/hooks' y los hagan ejecutables. Puedes distribuir esos enganches dentro del mismo proyecto o en un proyecto separado. Pero no hay modo de implementarlos automáticamente.

Para empezar, se necesita chequear el mensaje de confirmación inmediatamente antes de cada confirmación de cambios, para segurarse de que el servidor no los rechazará debido a un mensaje mal formateado. Para ello, se añade el enganche 'commit-msg'. Comparando el mensaje del archivo pasado como primer argumento con el mensaje patrón, puedes obligar a Git a abortar la confirmación de cambios (commit) en caso de no coincidir ambos:

	#!/usr/bin/env ruby
	message_file = ARGV[0]
	message = File.read(message_file)

	$regex = /\[ref: (\d+)\]/$regex = /\[ref: (\d+)\]/

	if !$regex.match(message)
	  puts "[POLICY] Your message is not formatted correctly"
	  exit 1
	end

Si este script está en su sitio (el archivo '.git/hooks/commit-msg') y es ejecutable, al confirmar cambios con un mensaje inapropiado, verás algo asi como:

	$ git commit -am 'test'
	[POLICY] Your message is not formatted correctly

Y la confirmación no se llevará a cabo. Sin embargo, si el mensaje está formateado adecuadamente, Git te permitirá confirmar cambios:

	$ git commit -am 'test [ref: 132]'
	[master e05c914] test [ref: 132]
	 1 files changed, 1 insertions(+), 0 deletions(-)

A continuación, se necesita también asegurarse de no estar modificando archivos fuera del alcance de tus permisos. Si la carpeta '.git' de tu proyecto contiene una copia del archivo de control de accesos (ACL) utilizada previamente, este script 'pre-commit' podrá comprobar los límites:

	#!/usr/bin/env ruby#!/usr/bin/env ruby#!/usr/bin/env ruby

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

	check_directory_permscheck_directory_perms

Este es un script prácticamente igual al del lado servidor. Pero con dos importantes diferencias. La primera es que el archivo ACL está en otra ubicación, debido a que el script corre desde tu carpeta de trabajo y no desde la carpeta de Git. Esto obliga a cambiar la ubicación del archivo ACL de

	access = get_acl_access_data('acl')

a 

	access = get_acl_access_data('.git/acl')

La segunda diferencia es la forma de listar los archivos modificados. Debido a que el metodo del lado servidor utiliza el registro de confirmaciones de cambio, pero, sin embargo, aquí la confirmación no se ha registrado aún, la lista de archivos se ha de obtener desde el área de preparación (staging area). En lugar de 

	files_modified = `git log -1 --name-only --pretty=format:'' #{ref}`

tenemos que utilizar 

	files_modified = `git diff-index --cached --name-only HEAD`

Estas dos son las únicas diferencias; en todo lo demás, el script funciona de la misma manera. Es necesario advertir de que se espera que trabajes localmente con el mismo usuario con el que enviarás (push) a la máquina remota. Si no fuera así, tendrás que ajustar manualmente la variable '$user'.

El último aspecto a comprobar es el de no intentar enviar referencias que no sean de avance-rápido. Pero esto es algo más raro que suceda. Para tener una referencia que no sea de avance-rápido, tienes que haber reorganizado (rebase) una confirmación de cambios (commit) ya enviada anteriormente, o tienes que estar tratando de enviar una rama local distinta sobre la misma rama remota.

De todas formas, el único aspecto accidental que puede interesante capturar son los intentos de reorganizar confirmaciones de cambios ya enviadas. El servidor te avisará de que no puedes enviar ningún no-avance-rapido, y el enganche te impedirá cualquier envio forzado

Este es un ejemplo de script previo a reorganización que lo puede comprobar. Con la lista de confirmaciones de cambio que estás a punto de reescribir, las comprueba por si alguna de ellas existe en alguna de tus referencias remotas. Si encuentra alguna, aborta la reorganización:

	#!/usr/bin/env ruby#!/usr/bin/env ruby#!/usr/bin/env ruby

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

Este script utiliza una sintaxis no contemplada en la sección de Selección de Revisiones del capítulo 6. La lista de confirmaciones de cambio previamente enviadas, se comprueba con:

	git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}

La sintaxis 'SHA^@' recupera todos los padres de esa confirmación de cambios (commit). Estas mirando por cualquier confirmación que se pueda alcanzar desde la última en la parte remota, pero que no se pueda alcanzar desde ninguno de los padres de cualquiera de las claves SHA que estás intentando enviar. Es decir, confirmaciones de avance-rápido.

La mayor pega de este sistema es el que puede llegar a ser muy lento; y muchas veces es innecesario, ya que el propio servidor te va a avisar y te impedirá el envio, siempre y cuando no intentes forzar dicho envio con la opción '-f'. De todas formas, es un ejercicio interesante. Y, en teoria al menos, pude ayudarte a evitar reorganizaciones que luego tengas de hechar para atras y arreglarlas.

## Recapitulación ##

Se han visto las principales vías por donde puedes personalizar tanto tu cliente como tu servidor Git para que se ajusten a tu forma de trabajar y a tus proyectos. Has aprendido todo tipo de ajustes de configuración, atributos basados en archivos e incluso enganches (hooks). Y has preparado un ejemplo de servidor con mecanismos para asegurar políticas determinadas. A partir de ahora estás listo para encajar Git en prácticamente cualquier flujo de trabajo que puedas imaginar.
