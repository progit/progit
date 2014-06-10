# Las herramientas de Git #

A estas alturas, hemos aprendido la mayoria de los comandos y flujos de trabajo empleados habitualmente a la hora de utilizar, gestionar y mantener un repositorio Git para el control de versiones de código fuente. Se han visto las tareas básicas de seguimiento y confirmación de cambios en archivos. Aprovechando las capacidades del área de preparación (staging area), de las ramas (branches) y de los mecanismos de fusión (merging).

En este capítulo se van a explorar unas cuantas tareas avanzadas de Git. Tareas que, aunque no se utilizan en el trabajo del día a día, en algún momento pueden ser necesarias. 

## Selección de confirmaciones de cambios concretas ##

Git tiene varios modos de seleccionar confirmaciones de cambio o grupos de confirmaciones de cambio. Algunos de estos modos no son precisamente obvios, pero conviene conocerlos.

### Confirmaciones puntuales ###

La forma canónica de referirse a una confirmación de cambios es indicando su código-resumen criptográfico SHA-1. Pero también existen otras maneras más sencillas. En esta sección se verán las diversas formas existentes para referirse a una determinada confirmación de cambios (commit).

### SHA corto ###

Simplemente dándole los primeros caracteres del código SHA-1, Git es lo suficientemente inteligente como para figurarse cual es la confirmación de cambios (commit) deseada. Es necesario teclear por lo menos 4 caracteres y estos han de ser no ambiguos --es decir, debe existir un solo objeto en el repositorio cuyo código comience por dicho trozo inicial del SHA--.

Por ejemplo, a la hora de localizar una confirmación de cambios, supongamos que se lanza el comando 'git log' e intentamos localizar la confirmación de cambios concreta donde se añadió una cierta funcionalidad: 

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

En este caso, escogiendo '1c002dd....', para lanzar el comando 'git show' sobre esa confirmación de cambios concreta, serían equivalentes todos estos comandos (asumiendo la no ambiguedad de todas las versiones cortas indicadas):

	$ git show 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	$ git show 1c002dd4b536e7479f
	$ git show 1c002d

En todos estos casos, Git puede deducir el resto del valor SHA-1. Con la opción '--abbrev-commit' del comando 'git log', en su salida se mostrarán valores acortados, pero únicos de SHA. Habitualmente suelen resultar valores de siete caracteres, pero alguno puede ser más largo si es necesario para preservar la unicidad de todos los valores SHA-1 mostrados:

	$ git log --abbrev-commit --pretty=oneline
	ca82a6d changed the version number
	085bb3b removed unnecessary test code
	a11bef0 first commit

Normalmente, entre ocho y diez caracteres suelen ser más que suficientes para garantizar la unicidad de  todos los objetos dentro de cualquier proyecto. Aunque, en uno de los más grandes proyectos gestionados con Git, el kernel de Linux, están siendo necesarios unos 12 caracteres (de los 40 posibles) para garantizar la unicidad.

### Un breve comentario sobre los códigos SHA-1 ###

Mucha gente se suele preocupar por si, por casualidad, dos objetos en su repositorio reciben el mismo código SHA-1 para identificarlos. ¿Y qué sucederia si se diera ese caso?

Si se da la casualidad de confirmar cambios en un objeto y que a este se le asigne el mismo código SHA-1 que otro ya existente en el repositorio. Al ver  el objeto previamente almacenado en la base de datos, Git asumirá que este ya existía. Al intentar recuperar (check-out) el objeto más tarde, siempre se obtendrán los datos del primer objeto. 

No obstante, hemos de ser conscientes de lo altamente improbable de un suceso así. Los códigos SHA-1 son de 20 bytes, (160 bits). El número de objetos, codificados aleatóriamente, necesarios para asegurar un 50% de probabilidad de darse una sola colisión es cercano a 2^80 (la fórmula para determinar la probabilidad de colisión es `p = (n(n-1)/2) * (1/2^160)`)). 2^80 es 1'2 x 10^24, o lo que es lo mismo, 1 billón de billones. Es decir, unas 1.200 veces el número de granos de arena en la Tierra.

El siguiente ejemplo puede ser bastante ilustrativo, para hacernos una idea de lo que podría tardarse en darse una colisión en el código SHA-1: Si todos los 6'5 billones de humanos en el planeta Tierra estuvieran programando y, cada segundo, cada uno de ellos escribiera código equivalente a todo el histórico del kernel de Linux (cerca de 1 millón de objetos Git), enviandolo todo a un enorme repositorio Git. Serían necesarios unos 5 años antes de que dicho repositorio contuviera suficientes objetos como para tener una probabilidad del 50% de darse una sola colisión en el código SHA-1. Es mucho más probable que todos los miembros de nuestro equipo de programación fuesen atacados y matados por lobos, en incidentes no relacionados entre sí, acaecidos todos ellos en una misma noche.

### Referencias a ramas ###

La manera más directa de referirse a una confirmación de cambios es teniendo una rama apuntando a ella. De esta forma, se puede emplear el nombre de la rama en cualquier comando Git que espere un objeto de confirmación de cambios o un código SHA-1. Por ejemplo, si se desea mostrar la última confirmación de cambios en una rama, y suponiendo que la rama 'topic1' apunta a 'ca82a6d', los tres comandos siguientes son equivalentes: 

	$ git show ca82a6dff817ec66f44342007202690a93763949
	$ git show topic1

Para ver a qué código SHA apunta una determinada rama, o si se desea conocer cómo se comportarian cualquiera de los ejemplos anteriores en términos de SHAs, se puede emplear el comando de fontaneria 'rev-parse'. En el capítulo 9 se verá más información sobre las herramientas de fontaneria. Herramientas estas que son utilizadas para operaciones a muy bajo nivel, y que no estan pensadas para ser utilizadas en el trabajo habitual del día a día. Pero que, sin embargo, pueden ser muy útiles cuando se desea ver lo que realmente sucede "tras las bambalinas", en el interior de Git. Por ejemplo, lanzando el comando 'rev-parse' sobre una rama, esta muestra el código SHA-1 de la última confirmación de cambios en ella:

	$ git rev-parse topic1
	ca82a6dff817ec66f44342007202690a93763949

### Nombres cortos en RefLog ###

Una de las tareas realizadas por Git continuamente en segundo plano, mientras nosotros trabajamos, es el mantenimiento de un registro de referencia (reflog). En este registro queda traza de dónde han estado las referencias a HEAD y a las distintas ramas durante los últimos meses.

Este registro de referencia se puede consultar con el comando 'git reflog':

	$ git reflog
	734713b... HEAD@{0}: commit: fixed refs handling, added gc auto, updated
	d921970... HEAD@{1}: merge phedders/rdocs: Merge made by recursive.
	1c002dd... HEAD@{2}: commit: added some blame and merge stuff
	1c36188... HEAD@{3}: rebase -i (squash): updating HEAD
	95df984... HEAD@{4}: commit: # This is a combination of two commits.
	1c36188... HEAD@{5}: rebase -i (squash): updating HEAD
	7e05da5... HEAD@{6}: rebase -i (pick): updating HEAD

Cada vez que se actualiza una rama por cualquier razón, Git almacena esa información en este histórico temporal. Y esta información se puede utilizar para referirse a confirmaciones de cambio pasadas. Por ejemplo, si se desea ver el quinto anterior valor de HEAD en el repositorio, se puede emplear la referencia '@{n}' mostrada por la salida de reflog:

	$ git show HEAD@{5}

Esta misma sintaxis puede emplearse cuando se desea ver dónde estaba una rama en un momento específico en el tiempo. Por ejemplo, para ver dónde apuntaba la rama 'master' en el día de ayer, se puede teclear:

	$ git show master@{yesterday}

Este comando mostrará a dónde apuntaba ayer la rama. Esta técnica tan solo funciona para información presente en el registro de referencia. No se puede emplear para confirmaciones de cambio de antiguedad superior a unos pocos meses.

Si se desea ver la información del registro de referencia, formateada de forma similar a la salida del comando 'git log', se puede lanzar el comando 'git log -g':

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

Es importante destacar la estricta localidad de la información en el registro de referencia. Es un registro que se va componiendo en cada repositorio según se va trabajando en él. Las referencias de una cierta persona en su repositorio nunca seran las mismas que las de cualquier otra persona en su copia local del repositorio. Es más, justo tras terminar de clonar un repositorio lo que se tiene es un registro de referencia vacio, puesto que  aún no se ha realizado ningún trabajo sobre dicho repositorio recién clonado. Así, un comando tal como `git show HEAD@{2.months.ago}` solo será válido en caso de haber clonado el proyecto como mínimo dos meses antes. Si se acaba de clonar hace cinco minutos, ese comando dará un resultado vacio.

### Referencias a ancestros ###

Otra forma de especificar una confirmación de cambios es utilizando sus ancestros. Colocando un '^' al final de una referencia, Git interpreta que se refiere al padre de dicha referencia.
Suponiendo que sea esta la historia de un proyecto:

	$ git log --pretty=format:'%h %s' --graph
	* 734713b fixed refs handling, added gc auto, updated tests
	*   d921970 Merge commit 'phedders/rdocs'
	|\  
	| * 35cfb2b Some rdoc changes
	* | 1c002dd added some blame and merge stuff
	|/  
	* 1c36188 ignore *.gem
	* 9b29157 add open3_detach to gemspec file list

Se puede visualizar la anteúltima confirmación de cambios indicando 'HEAD^', que significa "el padre de HEAD":

	$ git show HEAD^
	commit d921970aadf03b3cf0e71becdaab3147ba71cdef
	Merge: 1c002dd... 35cfb2b...
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 15:08:43 2008 -0800

	    Merge commit 'phedders/rdocs'

También es posible indicar un número detras de '^'. Por ejemplo `d921970^2`, para indicar "el segundo padre de d921970" . Aunque esta sentencia es útil tan solo en confirmaciones de fusiones (merge), los únicos tipos de confirmación de cambios que pueden tener más de un padre. El primer padre es el proveniente de la rama activa al realizar la fusión, y el segundo es la confirmación de cambios en la rama desde la que se fusiona.

	$ git show d921970^
	commit 1c002dd4b536e7479fe34593e72e6c6c1819e53b
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Dec 11 14:58:32 2008 -0800

	    added some blame and merge stuff

	$ git show d921970^2
	commit 35cfb2b795a55793d7cc56a6cc2060b4bb732548
	Author: Paul Hedderly <paul+git@mjr.org>
	Date:   Wed Dec 10 22:22:03 2008 +0000

	    Some rdoc changes

Otra forma de referirse a los ancestros es la marca `~`. Utilizada tal cual, también se refiere al padre. Por lo tanto, `HEAD~` y `HEAD^` son equivalentes. Pero la diferencia comienza al indicar un número tras ella. `HEAD~2` significa "el primer padre del primer padre", es decir, "el abuelo". Y así según el número de veces que se indique. Por ejemplo, en la historia de proyecto citada anteriormente, `HEAD~3` sería: 

	$ git show HEAD~3
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

Igualmente, se podría haber escrito `HEAD^^^`, que también se refiere al "primer padre del primer padre del primer padre":

	$ git show HEAD^^^
	commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
	Author: Tom Preston-Werner <tom@mojombo.com>
	Date:   Fri Nov 7 13:47:59 2008 -0500

	    ignore *.gem

E incluso también es posible combinar las dos sintaxis. Por ejemplo, para referirse al "segundo padre de la referencia previa" (asumiendo que es una confirmación de cambios de fusión -merge-), se pude escribir algo como `HEAD~3^2`.

### Referecias a un rango de confirmaciones de cambios ###

Una vez vistas las formas de referirse a confirmaciones concretas de cambios. Vamos a ver cómo referirse a un grupo de confirmaciones. Esto es especialmente útil en la gestión de ramas. Si se tienen multitud de ramas, se pueden emplear las espeficicaciones de rango para responder a cuestiones tales como "¿cual es el trabajo de esta rama que aún no se ha fusionado con la rama principal?".

#### Doble punto ####

La especificación de rango más común es la sintaxis doble-punto. Básicamente, se trata de pedir a Git que resuelva un rango de confirmaciones de cambio alcanzables desde una confirmación determinada, pero no desde otra. Por ejemplo, teniendo un historial de confirmaciones de cambio tal como el de la figura 6-1.

Insert 18333fig0601.png 
Figura 6-1. Ejemplo de historial para selección de rangos.

Si se desea ver qué partes de la rama experiment están sin fusionar aún con la rama master. Se puede pedir a Git que muestre un registro con las confirmaciones de cambio en `master..experiment`. Es decir, "todas las confirmaciones de cambio alcanzables desde experiment que no se pueden alcanzar desde master". Por razones de brevedad y claridad en los ejemplos, para representar los objetos confirmación de cambios (commit) se utilizarán las letras mostradas en el diagrama en lugar de todo el registro propiamente dicho: 

	$ git log master..experiment
	D
	C

Si, por el contrario, se desea ver lo opuesto (todas las confirmaciones en 'master' que no están en 'experiment'). Simplemente hay que invertir los nombres de las ramas. `experiment..master` muestra todo lo que haya en 'master' pero que no es alcanzable desde 'experiment':

	$ git log experiment..master
	F
	E

Esto es útil si se desea mantener actualizada la rama 'experiment' y previsualizar lo que se está a punto de fusionar en ella. Otra utilidad habitual de estas sentencias es la de ver lo que se está a punto de enviar a un repositorio remoto:

	$ git log origin/master..HEAD

Este comando muestra las confirmaciones de cambio de la rama activa que no están aún en la rama 'master' del repositorio remoto 'origin'. Si se lanza el comando 'git push' (y la rama activa actual esta relacionada con 'origin/master'), las confirmaciones de cambio mostradas por `git log origin/master..HEAD` serán las que serán transferidas al servidor. 
Es posible también omitir la parte final de la sentencia y dejar que Git asuma HEAD. Por ejemplo, se pueden obtener los mismos resultados tecleando `git log origin/master..`, ya que git sustituye HEAD en la parte faltante. 

#### Puntos multiples ####

La sintaxis del doble-punto es util como atajo. Pero en algunas ocasiones interesa indicar mas de dos ramas para precisar la revisión. Como cuando se desea ver las confirmaciones de cambio presentes en cualquiera de varias ramas y no en la rama activa. Git permite realizar esto utilizando o bien el caracter `^` o bien la opción `--not` por delante de aquellas referencias de las que se desea no ver las confirmaciones de cambio.  Así, estos tres comandos son equivalentes:

	$ git log refA..refB
	$ git log ^refA refB
	$ git log refB --not refA

Esto nos permite indicar más de dos referencias en una misma consulta. Algo imposible con la sintaxis dos-puntos. Por ejemplo, si se deseean ver todas las confirmaciones de cambio alcanzables desde la 'refA' o la 'refB', pero no desde la 'refC', se puede teclear algo como esto:

	$ git log refA refB ^refC
	$ git log refA refB --not refC

Esto da una enorme versatilidad al sistema de consultas y permite revisar el contenido de todas las ramas  en el repositorio.

#### Triple-punto ####

La última de las opciones principales para seleccionar rangos es la sintaxis triple-punto. Utilizada para especificar todas las confirmaciones de cambio alcanzables separadamente desde cualquiera de dos referencias, pero no desde ambas a la vez. Volviendo sobre la historia de proyecto mostrada en la figura 6-1.
Si se desea ver lo que está o bien en 'master' o bien en 'experiment', pero no en ambas simultáneamente, se puede emplear el comando:

	$ git log master...experiment
	F
	E
	D
	C

De nuevo, esto da una salida normal de 'log', pero mostrando tan solo información sobre las cuatro confirmaciones de cambio, dadas en la tradicional secuencia ordenada por fechas.

Una opción habitual a utilizar en estos casos con el comando 'log' suele ser 'left-right'. Haciendo así que en la salida se muestre cual es el lado al que pertenece cada una de las confirmaciones de cambio. Esto hace más util la información mostrada:

	$ git log --left-right master...experiment
	< F
	< E
	> D
	> C

Con estas herramientas, es mucho más sencillo indicar con precisión cual o cuales son las confirmaciones de cambios que se desean revisar. 

## Preparación interactiva ##

Git trae incluidos unos cuantos scripts para facilitar algunas de las tareas en la línea de comandos. Se van a mostrar unos pocos comandos interactivos que suelen ser de gran utilidad a la hora de recoger en una confirmación de cambios solo ciertas combinaciones y partes de archivos. Estas herramientas son útiles, por ejemplo, cuando se modifican unos cuantos archivos y luego se decide almacenar esos cambios en una serie de confirmaciones de cambio focalizadas en lugar de en una sola confirmación de cambio entremezclada.    Así, se consiguen unas confirmaciones de cambio con agrupaciones lógicas de modificaciones, facilitando su revisión por parte otros desarrolladores que trabajen con nosotros. 
Al lanzar el comando 'git add' con las opciones '-i' o '--interactive', Git entra en un modo interactivo y muestra algo así como:

	$ git add -i
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 

Según se ve, este comando muestra una vista bastante diferente del área de preparación (staging area). Básicamente se trata de la misma información dada por el comando 'git status', pero mas sucinta e informativa. Se ve una lista de cambios ya preparados, en la izquierda; y de los que están aún sin preparar, en la derecha. 

Tras esa lista, viene la sección de comandos. Aquí se pueden lanzar acciones tales como: añadir archivos en el area de preparación (staging), sacar archivos de ella (unstaging), poner solo parte de algún archivo, añadir archivos nuevos que estaban fuera del sistema de control o mostrar diferencias en aquello que se ha añadido.

### Introduciendo archivos en el area de preparación y sacandolos de ella ###

Tecleando '2' o 'u' (update) tras el indicador 'What now>', el script interactivo preguntará cuales son los archivos que se quieren añadir al área de preparación:

	What now> 2
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

Para añadir los archivos TODO e index.html, se teclearian los números:

	Update>> 1,2
	           staged     unstaged path
	* 1:    unchanged        +0/-1 TODO
	* 2:    unchanged        +1/-1 index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb
	Update>>

El asterisco `*` al lado de cada archivo indica que dicho archivo ha sido seleccionado para ser preparado. Pulsando la tecla [Enter] tras el indicador 'Update>>', Git toma lo seleccionado y lo añade al área de preparación: 

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

En estos momentos se ve que los archivos TODO e index.html están en el área de preparación y que el archivo simplegit.rb no está aún. Si se desea sacar el archivo TODO del área, se puede utilizar la opción '3' o 'r' (revert):

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

Volviendo a mirar el estado de Git, se comprueba que se ha sacado el archivo TODO del área de preparación:

	*** Commands ***
	  1: status     2: update      3: revert     4: add untracked
	  5: patch      6: diff        7: quit       8: help
	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:    unchanged        +5/-1 lib/simplegit.rb

Para ver las diferencis entre lo que está preparado, se puede utilizar la opción '6' o 'd' (diff). Esta muestra una lista de los archivos preparados en el área de preparación, permitiendo la seleccion de aquellos sobre los que  se desean ver diferencias. Es muy parecido a lanzar el comando 'git diff --cached' directamente en la línea de comandos:

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

Con estos comandos básicos, se ha visto cómo se puede emplear el modo interactivo para interactuar de forma más sencilla con el área de preparación.

### Parches en la preparación ###

También es posible añadir solo ciertas partes de algunos archivos y no otras. Por ejemplo, si se han realizado dos cambios en el archivo simplegit.rb y se desea pasar solo uno de ellos al área de preparación, pero no el otro. En el indicador interactivo se ha de teclear '5' o 'p' (patch). Git preguntará cual es el archivo a pasar parcialmente al área de preparación. Y después irá mostrando trozos de las distintas secciones modificadas en el archivo, preguntando por cada una si se desea pasar o no al área de preparación:

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

En estas preguntas, hay varias opciones de respuesta. Tecleando '?' se muestra una lista de las mismas:

	Stage this hunk [y,n,a,d,/,j,J,g,e,?]? ?
	y - stage this hunk
	n - do not stage this hunk
	a - stage this and all the remaining hunks in the file
	d - do not stage this hunk nor any of the remaining hunks in the file
	g - select a hunk to go to
	/ - search for a hunk matching the given regex
	j - leave this hunk undecided, see next undecided hunk
	J - leave this hunk undecided, see next hunk
	k - leave this hunk undecided, see previous undecided hunk
	K - leave this hunk undecided, see previous hunk
	s - split the current hunk into smaller hunks
	e - manually edit the current hunk
	? - print help

Habitualmente se tecleará 'y' o 'n' según se desee pasar o no cada trozo. Pero habrá ocasiones donde pueda ser útil pasar todos ellos conjuntamente, o el dejar para más tarde la decisión sobre un trozo concreto. Si se decide pasar solo una parte de un archivo y dejar sin pasar otra parte, la salida de estado mostrará algo así como:

	What now> 1
	           staged     unstaged path
	  1:    unchanged        +0/-1 TODO
	  2:        +1/-1      nothing index.html
	  3:        +1/-1        +4/-0 lib/simplegit.rb

La línea correspondiente al estado del archivo simplegit.rb es bastante interesante. Muestra que un par de líneas han sido preparadas (staged) en el área de preparación y otro par han sido dejadas fuera de dicho área (unstaged). Es decir, se ha pasado parcialmente ese archivo al área de preparación. En este punto, es posible salir del script interactivo y lanzar el comando 'git commit' para almacenar esa confirmación de cambios parciales en los archivos.

Por último, cabe comentar que no es necesario entrar expresamente en el modo interactivo para preparar archivos parcialmente. También se puede acceder a ese script con los comandos 'git add -p' o con 'git add --patch', directamente desde la línea de comandos. 

## Guardado rápido provisional ##

Según se está trabajando en un apartado de un proyecto, normalmente el espacio de trabajo suele estar en un estado inconsistente. Pero puede que se necesite cambiar de rama durante un breve tiempo para ponerse a trabajar en algún otro tema urgente. Esto plantea el problema de confirmar cambios en un trabajo medio hecho, simplemente para poder volver a ese punto más tarde. Y su solución es el comando 'git stash'.

Este comando de guardado rápido (stashing) toma el estado del espacio de trabajo, con todas las modificaciones en los archivos bajo control de cambios, y lo guarda en una pila provisional. Desde allí, se podrán recuperar posteriormente y volverlas a aplicar de nuevo sobre el espacio de trabajo.

### Guardando el trabajo temporalmente ###

Por ejemplo, si se está trabajando sobre un par de archivos e incluso uno de ellos está ya añadido al área de preparación para un futuro almacenamiento de sus cambios en el repositorio. Al lanzar el comando 'git status', se podría observar un estado inconsistente tal como:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#

Si justo en este momento se desea cambiar de rama, pero sin confirmar los cambios realizados hasta entonces; la solución es un guardado rápido provisional de los cambios. Utilizando el comando 'git stash' y enviando un nuevo grupo de cambios a la pila de guardado rápido:

	$ git stash
	Saved working directory and index state \
	  "WIP on master: 049d078 added the index file"
	HEAD is now at 049d078 added the index file
	(To restore them type "git stash apply")

Con ello, se limpia el área de trabajo:

	$ git status
	# On branch master
	nothing to commit, working directory clean

Y se permite cambiar de rama para ponerse a trabajar en cualquier otra parte. Con la tranquilidad de que los cambios a medio completar están guardados a buen recaudo en la pila de guardado rápido. Para ver el contenido de dicha pila, se emplea el comando 'git stash list':

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051... Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5... added number to log

En este ejemplo, se habian realizado dos guardados rápidos anteriores, por lo que se ven tres grupos de cambios guardados en la pila. Con el comando 'git stash apply', tal y como se indica en la salida del comando stash original, se pueden volver a aplicar los últimos cambios recien guardados. Si lo que se desea es reaplicar alguno de los grupos más antiguos de cambios, se ha de indicar expresamente: `git stash apply stash@{2}` Si no se indica ningún grupo concreto, Git asume que se desea reaplicar el grupo de cambios más reciente de entre los guardados en la pila.

	$ git stash apply
	# On branch master
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   index.html
	#      modified:   lib/simplegit.rb
	#

Como se ve en la salida del comando, Git vueve a aplicar los correspondientes cambios en los archivos que estaban modificados. Pero no conserva la información de lo que estaba o no estaba añadido al área de preparación.  En este ejemplo se han aplicado los cambios de vuelta sobre un espacio de trabajo limpio, en la misma rama. Pero no es esta la única situación en la que se pueden reaplicar cambios. Es perfectamente posible guardar rápidamente (stash) el estado de una rama. Cambiar posteriormente a otra rama. Y proceder a aplicar sobre esta otra rama los cambios guardados, en lugar de sobre la rama original. Es posible incluso aplicar de vuelta cambios sobre un espacio de trabajo inconsistente, donde haya otros cambios o algunos archivos añadidos al área de preparación. (Git notificará de los correspondientes conflictos de fusión si todo ello no se puede aplicar limpiamente.)

Las modificaciones sobre los archivos serán aplicadas; pero no así el estado de preparación. Para conseguir esto último, es necesario emplear la opción `--index` del comando `git stash apply`. Con ella se le indica que debe intentar reaplicar también el estado de preparación de los archivos.  Y asi se puede conseguir volver exactamente al punto original:

	$ git stash apply --index
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#

Los comandos `git stash apply` tan solo recuperan cambios almacenados en la pila de guardado rápido, sin afectar al estado de la pila. Es decir, los cambios siguen estando guardados en la pila. Para quitarlos de ahí, es necesario lanzar expresamente el comando `git stash drop` e indicar el número de guardado a borrar de la pila:

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051... Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5... added number to log
	$ git stash drop stash@{0}
	Dropped stash@{0} (364e91f3f268f0900bc3ee613f9f733e82aaed43)

También es posible utilizar el comando `git stash pop`,  que aplica cambios de un guardado y lo retira inmediatamente de la pila.

### Creando una rama desde un guardado rápido temporal ###

Si se almacena rápidamente (stash) un cierto trabajo, se deja en la pila durante bastante tiempo, y se continua mientras tanto con otros trabajos sobre la misma rama. Es muy posible que se presenten problemas al tratar de reaplicar los cambios guardados tiempo atrás. Si  para recuperar esos cambios se ha de modificar un archivo que también haya sido modificado en los trabajos posteriores, se dará un conflicto de fusión (merge conflict) y será preciso resolverlo manualmente. Una forma más sencilla de reaplicar cambios es utilizando el comando `git stash branch`. Este comando crea una nueva rama, extrayendo (checkout) la confirmación de cambios original en la que se estaba cuando los cambios fueron guardados en la pila, reaplica estos sobre dicha rama y los borra de la pila si se consigue completar el proceso con éxito.

	$ git stash branch testchanges
	Switched to a new branch "testchanges"
	# On branch testchanges
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      modified:   index.html
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#
	Dropped refs/stash@{0} (f0dfc4d5dc332d1cee34a634182e168c4efc3359)

Este es un buen atajo para recuperar con facilidad un cierto trabajo desde la pila y continuar con él en una nueva rama.

## Reescribiendo la historia ##

Por razones varias, hay ocasiones en que se desea revisar el historial de confirmaciones de cambio. Una de las grandes caracteristicas de Git es su capacidad de postponer las decisiones hasta el último momento. Las decisiones sobre qué archivos van en qué confirmaciones de cambio se toman justo inmediatamente antes de confirmar, utilizando para ello el área de preparación (staging area). En cualquier momento se puede decidir dejar de trabajar en una cierta vía y arrancar en otra, utilizando el comando de guardado rápido (stash). Y también es posible reescribir confirmaciones de cambio ya realizadas, para que se muestren como si hubieran sido realizadas de otra forma. Así, es posible cambiar el orden de las confirmaciones, cambiar sus mensajes, modificar los archivos comprendidos en ellas, juntar varias confirmaciones en una sola, partir una en varias,o incluso borrar alguna completamente. --Aunque todo ello es siempre recomendable hacerlo solo antes de compartir nuestro trabajo con otros.--

En esta sección, se verá cómo realizar todas esas útiles tareas. De tal forma que se pueda dejar el historial de cambios exactamente tal y como se desee. Eso sí, siempre antes de compartirlo con otros desarrolladores.

### Modificar la última confirmación de cambios ###

Modificar la última confirmación de cambios (commit) es probablemente el arreglo realizado con más frecuencia. Dos suelen ser los cambios básicos a realizar: cambiar el mensaje o cambiar los archivos añadidos, modificados o borrados.

Cambiar el mensaje de la última confirmación de cambios, es muy sencillo:

	$ git commit --amend

Mediante este comando, el editor de textos arranca con el mensaje escrito en la última confirmación de cambios; listo para ser modificado. Al guardar y cerrar en el editor, este escribe una nueva confirmación de cambios y reemplaza con ella la última confirmación existente.

Si se desea cambiar la instantánea (snapshot) de archivos en la última confirmación de cambios, habitualmente por haber tenido algún descuido al añadir algún archivo de reciente creación. El proceso a seguir es básicamente el mismo. Se preparan en el área de preparación los archivos deseados; con los comandos `git add` o `git rm`, según corresponda. Y, a continuación, se lanza el comando `git commit --amend`. Este tendrá en cuenta dicha preparación para rehacer la instantánea de archivos en la nueva confirmación de cambios. 

Es importante ser cuidadoso con esta técnica. Porque al modifcar cualquier confirmación de cambios, cambia también su código SHA-1. Es como si se realizara una pequeña reorganización (rebase). Y, por tanto, aquí también se aplica la regla de no modificar nunca una confirmación de cambios que ya haya sido enviada (push) a otros.

### Modificar múltiples confirmaciones de cambios ###

Para modificar una confirmación de cambios situada bastante atrás en el historial, es necesario emplear herramientas más complejas. Git no dispone de herramientas directas para modifica el historial de confirmaciones de cambio. Pero es posible emplear la herramienta de reorganización (rebase) para modificar series de confirmaciones; en la propia cabeza (HEAD) donde estaban basadas originalmente, en lugar de moverlas a otra distinta. Dentro de la herramienta de reorganización interactiva, es posible detenerse justo tras cada confirmación de cambios a modificar. Para cambiar su mensaje, añadir archivos, o cualquier otra modificación. Este modo interactivo se activa utilizando la opción `-i` en el comando `git rebase`.  La profundidad en la historia a modificar vendrá dada por la confirmación de cambios (commit) que se indique al comando.

Por ejemplo, para modificar las tres últimas confirmaciones de cambios, se  indicara el padre de la última conformación a modificar, es decir habrá que escribir `HEAD~2^` or `HEAD~3` tras el comando `git rebase -i`. La nomenclatura  `~3` es la mas sencilla de recordar, porque lo que se desea es modificar las tres últimas confirmaciones. Pero sin perder de vista que realmente se está señalando a cuatro confirmaciones de cambio más atras, al padre de la última de las confirmaciones de cambio a modificar. 

	$ git rebase -i HEAD~3

Es importante avisar de nuevo que se trata de un comando de reorganización: todas y cada una de las confirmaciones de cambios en el rango `HEAD~3..HEAD` van a ser reescritas, (cambia su código SHA-1), tanto si se modifica algo en ellas como si no. Por tanto, es importante no afectar a ninguna confirmación de cambios que haya sido ya enviada (push) a un servidor central. So pena de confundir a otros desarrolladores, a los cuales se estaria dando una versión alternativa de un mismo cambio.

Al lanzar este comando, se verán una lista de confirmaciones de cambio en la pantalla del editor de textos:

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-filepick f7f3f6d changed my name a bit
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
	###

Es importante destacar que esas confirmaciones de cambios se han listado en el orden opuesto al que normalmente son mostradas en el comando `log`.  En este último, se suele ver algo así como:

	$ git log --pretty=format:"%h %s" HEAD~3..HEAD
	a5f4a0d added cat-file
	310154e updated README formatting and added blame
	f7f3f6d changed my name a bit

Prestar atención al orden inverso. La reorganización interactiva lanza un script. Un script que, comenzando por la confirmación de cambios indicada en la línea del comando (`HEAD~3`), va a reaplicar los cambios introducidos en cada una de las confirmaciones, desde arriba hasta abajo. En la lista se ven las mas antiguas encima, en lugar de las más recientes, precisamente porque esas van a ser las primeras en reaplicarse.

Para que el script se detenga en cada confirmación de cambios a modificar, hay que editarlo. Y se ha de cambiar la palabra 'pick' por la palabra 'edit' en cada una de las confirmaciones de cambio donde se desee detener el script. Por ejemplo, para modificar solo el mensaje de la tercera confirmación de cambios, el script quedaria:

	edit f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

Cuando se guarde y cierre en el editor, Git hará un rebobinado hacia atras hasta la última de las confirmaciones de cambios en la lista, y mostrará algo así como:

	$ git rebase -i HEAD~3
	Stopped at 7482e0d... updated the gemspec to hopefully work better
	You can amend the commit now, with

	       git commit --amend

	Once you’re satisfied with your changes, run

	       git rebase --continue

Estas instrucciones indican exactamente lo que se ha de realizar. Teclear

	$ git commit --amend

Cambiar el mensaje de la confirmación de cambios y salir del editor. Para luego lanzar

	$ git rebase --continue

Las otras dos confirmaciones de cambio serán reaplicadas automáticamene. Y ya estará completa la reorganización. Si se ha cambiado 'pick' por 'edit' en más de una línea, estos pasos se habrán de repetir por cada una de las confirmaciones de cambios a modificar. En cada una de ellas, Git se detendrá, permitiendo enmendar la confirmación de cambios y continuar tras la modificación.

### Reordenar confirmaciones de cambios ###

Las reorganizaciones interactivas también se pueden emplear para reordenar o para eliminar completamente ciertas confirmaciones de cambios (commits). Por ejemplo, si se desea eliminar la confirmación de "added cat-file" y cambiar el orden en que se han introducido las otras dos confirmaciones de cambios, el script de reorganización pasaría de ser:

	pick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-filepick f7f3f6d changed my name a bit
	pick 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

a quedar en algo como:

	pick 310154e updated README formatting and added blame
	pick f7f3f6d changed my name a bit

Cuando se guarde y salga en el editor, Git rebobinará la rama hasta el padre de las confirmaciones de cambio indicadas, reaplicará `310154e` y luego `f7f3f6d`, para finalmente detenerse. De esta forma se habrá cambiado el orden de las dos confirmaciones de cambio, y se habrá eliminado completamente la de "added cat-file".

### Combinar varias confirmaciones en una sola ###

Con la herramienta de reorganización interactiva, es posible recombinar una serie de confirmaciones de cambio y agruparlas todas en una sola. El propio script indica las instrucciones a seguir:

	#
	# Commands:
	#  p, pick = use commit
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	# However, if you remove everything, the rebase will be aborted.
	###

Si, en lugar de 'pick' o de 'edit', se indica 'squash' delante de alguna de las confirmaciones de cambio, Git aplicará simultáneamente dicha confirmación y la que esté inmediatamente delante de ella.  Permitiendo también combinar los mensajes de ambas. Por ejemplo, si se desea hacer una única confirmación de cambios fusionando las tres, el script quedaría en algo como:

	pick f7f3f6d changed my name a bit
	squash 310154e updated README formatting and added blame
	squash a5f4a0d added cat-file

Cuando se guarde y salga en el editor, Git rebobinará la historia, reaplicará las tres confirmaciones de cambio, y volverá al editor para fusionar también los mensajes de esas tres confirmaciones. 

	# This is a combination of 3 commits.
	# The first commit's message is:
	changed my name a bit

	# This is the 2nd commit message:

	updated README formatting and added blame

	# This is the 3rd commit message:

	added cat-file

Al guardar esto, se tendrá una sola confirmación de cambios que introducirá todos los cambios que estaban en las tres confirmaciones de cambios previamente existentes.

### Dividir una confirmación de cambios en varias ###

Dividir una confirmación de cambios (commit), implica deshacerla y luego volver a preparar y confirmar trozos de la misma tantas veces como nuevas confirmaciones se desean tener al final.  Por ejemplo, si se desea dividir la confirmación de cambios de enmedio de entre las tres citadas en ejemplos anteriores. Es decir, si en lugar de "updated README formatting and added blame", se desea separar esa confirmación en dos: "updated README formatting" y "added blame".  Se puede realizar cambiando la instrucción en el script de `rebase -i`, desde 'split' a 'edit': 

	pick f7f3f6d changed my name a bit
	edit 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

Después, cuando el script devuelva la línea de comandos, se ha de deshacer (reset) esa confirmación de cambios, coger los cambios recién deshechos y crear multiples nuevas confirmaciones de cambios con ellos. Al guardar y salir en el editor, Git rebobinará la historia hasta el padre de la primera confirmación de cambios en la lista, reaplicará esa primera confirmación  (`f7f3f6d`), luego reaplicará la segunda (`310154e`) y luego devolverá la línea de comandos. En esta línea de comando, es donde se desharan los cambios tecleando el comando `git reset HEAD^` para dejar sin preparar (unstaged) los archivos cambiados. Para, seguidamente, elaborar tantas confirmaciones de cambios como se desee, a base de pasar archivos al área de preparación y confirmarlos. Y, finalmente, teclear el comando `git rebase --continue` para completar la tarea. 

	$ git reset HEAD^
	$ git add README
	$ git commit -m 'updated README formatting'
	$ git add lib/simplegit.rb
	$ git commit -m 'added blame'
	$ git rebase --continue

Tras esto, Git reaplicará la última de las confirmaciones de cambios  (`a5f4a0d`) en el script. Quedando la historia: 

	$ git log -4 --pretty=format:"%h %s"
	1c002dd added cat-file
	9b29157 added blame
	35cfb2b updated README formatting
	f3cc40e changed my name a bit

De nuevo, merece recalcar el hecho de que estas operaciones cambian los códigos SHA-1 de todas las confirmaciones de cambio afectadas. Y que, por tanto, no se deben hacer sobre confirmaciones de cambio enviadas(push) a algún repositorio compartido.

### La opción nuclear: filter-branch ###

Existe una opción de reescritura del historial que se puede utilizar si se necesita reescribir un gran número de confirmaciones de cambio de forma mas o menos automatizada. Por ejemplo, para cambiar una dirección de correo electrónico globalmente, o para quitar un archivo de todas y cada una de las confirmaciones de cambios en una determinada rama. El comando en cuestión es `filter-branch`, y permite reescribir automáticamente grandes porciones del historial. Precisamente por ello, no debería utilizarse a no ser que el proyecto aún no se haya hecho público (es decir, otras personas no han basado su trabajo en alguna de las confirmaciones de cambio que se van a modificar). De todas formas, allá donde sea aplicable, puede ser de gran utilidad. Se van a ilustrar unas cuantas de las ocasiones donde se podría utilizar,  para dar así una idea de sus capacidades.

#### Quitar un archivo de cada confirmación de cambios ####

Es algo que frecuentemente suele ser necesario. Alguien confirma cambios y almacena accidentalmente un enorme archivo binario cuando lanza un `git add .` sin pensarlo demasiado. Y es necesario quitarlo del repositorio. O podria suceder que se haya confirmado y almacenado accidentalmente un archivo que contiene una contraseña importante, Y el proyecto se va a hacer de código abierto. En estos casos, la mejor opción es utilizar la herramienta `filter-branch` para limpiar todo el historial.  Por ejemplo, para quitar un archivo llamado passwords.txt del repositorio, se puede emplear la opción `--tree-filter` del comando `filter-branch`:

	$ git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
	Rewrite 6b9b3cf04e7c5686a9cb838c3f36a8cb6a0fc2bd (21/21)
	Ref 'refs/heads/master' was rewritten

Esta opción `--tree-filter`, tras cada extracción (checkout) del proyecto, lanzará el comando especificado y reconfirmará los cambios resultantes(recommit). En esta ocasión, se eliminará un archivo llamado passwords.txt de todas y cada una de las instantáneas (snapshot) almacenadas, tanto si este existe como si no. Otro ejemplo: si se desean eliminar todos los archivos de respaldo del editor que han sido almacenados por error, se podría lanzar algo así como  `git filter-branch --tree-filter "find * -type f -name '*~' -delete" HEAD`.

Y se iria viendo como Git reescribe árboles y confirmaciones de cambio, hasta que el apuntador de la rama llegue al final. Una recomendación: en general, suele ser buena idea lanzar cualquiera de estas operaciones primero sobre una rama de pruebas y luego reinicializar (hard-reset) la rama maestra (master), una vez se haya comprobado que el resultado de las operaciones es el esperado. Si se desea lanzar `filter-branch` sobre todas las ramas del repositorio, se ha de pasar la opción `--all` al comando. 

#### Haciendo que una subcarpeta sea la nueva carpeta raiz ####

Por ejemplo, en el caso de que se haya importado trabajo desde otro sistema de control de versiones, y se tengan algunas subcarpetas sin sentido (trunk, tags,...). `filter-branch` puede ser de utilidad para que, por ejemplo, la subcarpeta `trunk` sea la nueva carpeta raiz del proyecto en todas y cada una de las confirmaciones de cambios:

	$ git filter-branch --subdirectory-filter trunk HEAD
	Rewrite 856f0bf61e41a27326cdae8f09fe708d679f596f (12/12)
	Ref 'refs/heads/master' was rewritten

Tras este comando, la nueva raiz del proyecto pasa a ser el contenido de la carpeta `trunk`. Y, además, Git elimina automáticamente todas las confirmaciones de cambio (commits) que no afectaban a  dicha subcarpeta. 

#### Cambiando direcciones de correo-e de forma global ####

Otra utilidad típica para utilizar `filter-branch` es cuando alguien ha olvidado ejecutar `git config` para configurar su nombre y dirección de correo electrónico antes de comenzar a trabajar. O cuando se va a pasar a código abierto un proyecto, pero previamente se desea cambiar todas las direcciones de correo empresariales por direcciones personales. En cualquier caso, se pueden cambiar de un golpe las direcciones de correo en multiples confirmaciones de cambio. Aunque es necesario ser cuidadoso para actuar solo sobre aquellas direcciones que se deseen cambiar, utilizando para ello la opción `--commit-filter`: 

	$ git filter-branch --commit-filter '
	        if [ "$GIT_AUTHOR_EMAIL" = "schacon@localhost" ];
	        then
	                GIT_AUTHOR_NAME="Scott Chacon";
	                GIT_AUTHOR_EMAIL="schacon@example.com";
	                git commit-tree "$@";
	        else
	                git commit-tree "$@";
	        fi' HEAD

Este comando pasa por todo el repositorio y reescribe cada confirmación de cambios donde detecte la dirección de correo indicada, para reemplazarla por la nueva. Y, debido a que cada confirmación de cambios contiene el código SHA-1 de sus ancestros, este comando cambia también todos los códigos SHA del historial; no solamente los de las confirmaciones de cambio que contenian la dirección indicada.

## Depuración con Git ##

Git dispone también de un par de herramientas muy útiles para tareas de depuración en los proyectos. Precisamente por estar Git diseñado para trabajar con casi cualquier tipo de proyecto, sus herramientas son bastante genéricas. Pero suelen ser de inestimable ayuda para cazar errores o las causas de los mismos cuando se detecta que algo va mal. 

### Anotaciones en los archivos ###

Cuando se está rastreando un error dentro del código buscando localizar cuándo se introdujo y por qué, el mejor auxiliar para hacerlo es la anotación de archivos. Esta suele mostrar la confirmación de cambios (commit) que modificó por última vez cada una de las líneas en cualquiera de los archivos. Así, cuando se está frente a una porción de código con problemas, se puede emplear el comando `git blame` para anotar ese archivo y ver así cuándo y por quién fue editada por última vez cada una de sus líneas. En este ejemplo, se ha utilizado la opción `-L` para limitar la salida a las líneas desde la 12 hasta la 22: 

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

Merece destacar que el primer campo mostrado en cada línea es el código SHA-1 parcial de la confirmación de cambios en que se modificó dicha línea por última vez. Los dos siguientes campos son sendos valores extraidos de dicha confirmación de cambios --el nombre del autor y la fecha--, mostrando quien y cuándo modifico esa línea. Detras, vienen el número de línea y el contendido de la línea propiamente dicha. En el caso de las líneas con la confirmación de cambios  `^4832fe2`, merece comentar que son aquellas presentes en el archivo cuando se hizo la confirmación de cambios original;  (la confirmación en la que este archivo se incluyó en el proyecto por primera vez). No habiendo sufrido esas líneas ninguna modificación desde entonces. Puede ser un poco confuso, debido a que la marca `^` se utiliza también con otros significados diferentes dentro de Git. Pero este es el sentido en que se utiliza aquí: para señalar la confirmación de cambios original. 

Otro aspecto interesante de Git es la ausencia de un seguimiento explícito de archivos renombrados. Git simplemente se limita a almacenar instantáneas (snapshots) de los archivos, para después intentar deducir cuáles han podido ser renombrados. Esto permite preguntar a Git acerca de todo tipo de movimientos en el código. Indicando la opción `-C` en el comando `git blame`, Git analizará el archivo que se está anotando para intentar averiguar si alguno de sus fragmentos pudiera provenir de, o haber sido copiado de, algún otro archivo. Por ejemplo, si se estaba refactorizando un archivo llamado `GITServerHandler.m`, para trocearlo en múltiples archivos, siendo uno de estos `GITPackUpload.m`. Aplicando la opción `-C` de `git blame` sobre `GITPackUpload.m`, es posible ver de donde proviene cada sección del código: 

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

Lo cual es realmente útil. Habitualmente suele mostrarse como confirmación de cambios original aquella confirmación de cambios desde la que se copió el código. Por ser esa la primera ocasión en que se han modificado las líneas en ese archivo. Git suele indicar la confirmación de cambios original donde se escribieron las líneas, incluso si estas fueron escritas originalmente en otro archivo.

### Búsqueda binaria ###

La anotación de archivos es útil si se conoce aproximadamente el punto dónde se localizan los problemas. Pero no siendo ese el caso, y habiendose realizado docenas o cientos de confirmaciones de cambio desde el último estado estable conocido, puede ser de utilidad el comando `git bisect`. Este comando `bisect` realiza una búsqueda binaria por todo el historial de confirmaciones de cambio, para intentar localizar lo más rápido posible aquella confirmación de cambios en la que se pudieron introducir los problemas.

Por ejemplo, en caso de aparecer problemas justo tras enviar a producción un cierto código que parecia funcionar bien en el entorno de desarrollo. Si, volviendo atras, resulta que se consigue reproducir el problema, pero cuesta identificar su causa. Se puede ir biseccionando el código para intentar localizar el punto del historial desde donde se presenta el problema. Primero se lanza el comando `git bisect start` para iniciar el proceso de búsqueda. Luego, con el comando `git bisect bad`, se le indica al sistema cual es la confirmación de cambios a partir de donde se han detectado los problemas. Y después, con el comando `git bisect good [good_commit]`, se le indica cual es la última confirmación de cambios conocida donde el código funcionaba bien:

	$ git bisect start
	$ git bisect bad
	$ git bisect good v1.0
	Bisecting: 6 revisions left to test after this
	[ecb6e1bc347ccecc5f9350d878ce677feb13d3b2] error handling on repo

Git averigua que se han dado 12 confirmaciones de cambio entre la confirmación marcada como buena y la marcada como mala.  Y extrae la confirmación central de la serie, para comenzar las comprobaciones a partir de ahí. En este punto, se pueden lanzar las pruebas pertinentes para ver si el problema existe en esa confirmación de cambios extraida. Si este es el caso, el problema se introdujo en algún punto anterior a esta confirmación de cambios intermedia. Si no, el problema se introdujo en un punto posterior. Por ejemplo, si resultara que no se detecta el problema aquí, se indicaria esta circunstancia a Git tecleando `git bisect good`; para continuar la búsqueda:

	$ git bisect good
	Bisecting: 3 revisions left to test after this
	[b047b02ea83310a70fd603dc8cd7a6cd13d15c04] secure this thing

Git extraeria otra confirmación de cambios, aquella a medio camino entre la que se acaba de chequear y la que se habia indicado como erronea al principio. De nuevo, se pueden lanzar las pruebas para ver si el problema existe o no en ese punto. Si, por ejemplo, si existiera se indicaría ese hecho a Git tecleando `git bisect bad`:

	$ git bisect bad
	Bisecting: 1 revisions left to test after this
	[f71ce38690acf49c1f3c9bea38e09d82a5ce6014] drop exceptions table

Con esto el proceso de búsqueda se completa y Git tiene la información necesaria para determinar dónde comenzaron los problemas. Git reporta el código SHA-1 de la primera confirmación de cambios problemática y muestra una parte de la información relativa a esta y a los archivos modificados en ella. Así podemos irnos haciendo una idea de lo que ha podido suceder para que se haya introducido un error en el código:

	$ git bisect good
	b047b02ea83310a70fd603dc8cd7a6cd13d15c04 is first bad commit
	commit b047b02ea83310a70fd603dc8cd7a6cd13d15c04
	Author: PJ Hyett <pjhyett@example.com>
	Date:   Tue Jan 27 14:48:32 2009 -0800

	    secure this thing

	:040000 040000 40ee3e7821b895e52c1695092db9bdc4c61d1730
	f24d3c6ebcfc639b1a3814550e62d60b8e68a8e4 M  config

Al terminar la revisión, es obligatorio teclear el comando `git bisect reset` para devolver HEAD al punto donde estaba antes de comenzar todo el proceso de búsqueda. So pena de dejar el sistema en un estado inconsistente.

	$ git bisect reset

Esta es una poderosa herramienta que permite chequear en minutos cientos de confirmaciones de cambio, para determinar rápidamente en que punto se pudo introducir el error. De hecho, si se dispone de un script que dé una salida 0 si el proyecto funciona correctamente y distinto de 0 si el proyecto tiene errores, todo este proceso de búsqueda con `git bisect` se puede automatizar completamente.  Primero, como siempre, se indica el alcance de la búsqueda indicando las aquellas confirmaciones de cambio conocidas donde el proyecto estaba mal y donde estaba bien. Se puede hacer en un solo paso. Indicando ambas confirmaciones de cambios al comando `bisect start`, primero la mala y luego la buena:

	$ git bisect start HEAD v1.0
	$ git bisect run test-error.sh

De esta forma, se irá ejecutando automáticamente `test-error.sh` en cada confirmación de cambios que se vaya extrayendo. Hasta que Git encuentre la primera donde se presenten problemas.  También se puede emplear algo como `make` o como `make tests` o cualquier otro método que se tenga para lanzar pruebas automatizadas sobre el sistema.

## Submódulos ##

Suele ser frecuente encontrarse con la necesidad de utilizar otro proyecto desde dentro del que se está trabajando. En ocasiones como, por ejemplo, cuando se utiliza una biblioteca de terceros, o cuando se está desarrollando una biblioteca independiente para ser utilizada en múltiples proyectos. La preocupación típica en estos escenarios suele ser la de cómo conseguir tratar ambos proyectos separadamente. Pero conservando la habilidad de utilizar uno dentro del otro.

Un ejemplo concreto. Supongamos que se está desarrollando un site web y creando feeds Atom. En lugar de escribir código propio para generar los feeds Atom, se decide emplear una biblioteca ya existente. Y dicha biblioteca se incluye desde una biblioteca compartida tal como CPAN install o Ruby gem; o copiando directamente su código fuente en el árbol del propio proyecto. La problemática en el primer caso radica en la dificultad de personalizar la biblioteca compartida. Y en la dificultal para su despliegue; ya que es necesario que todos y cada uno de los clientes dispongan de ella.  La problemática en el segundo caso radica en las complicaciones para fusionar las personalizaciones realizadas por nosotros con futuras copias de la biblioteca original. 

Git resuelve estas problemáticas utilizando submódulos. Los submódulos permiten mantener un repositorio Git como una subcarpeta de otro repositorio Git. Esto permite clonar un segundo repositorio dentro del repositorio del proyecto en que se está trabajando, manteniendo separadamente las confirmaciones de cambios en ambos repositorios.

### Trabajando con submódulos ###

Suponiendo, por ejemplo, que se desea añadir la biblioteca Rack (un interface Ruby de pasarela de servidor web) al proyecto en que se está trabajando. Posiblemente con algunas personalizaciones, pero sin perder la capacidad de fusionar nuestros cambios con la evolución de la biblioteca original. La primera tarea a realizar es clonar el repositorio externo dento de una subcarpeta dentro del proyecto. Los proyectos externos se pueden incluir como submódulos mediante el comando `git submodule add`:

	$ git submodule add git://github.com/chneukirchen/rack.git rack
	Initialized empty Git repository in /opt/subtest/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 422 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.Resolving deltas: 100% (1951/1951), done.

A partir de este momento, el proyecto Rack está dentro de nuestro proyecto; bajo una subcarpeta denominada `rack`. En dicha subcarpeta es posible realizar cambios, añadir un repositorio propio a donde enviar (push) los cambios, recuperar (fetch) y fusionar (merge) desde el repositorio original, y mucho mas... Si se lanza `git status` nada mas añadir el submódulo, se aprecian dos cosas:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      new file:   .gitmodules
	#      new file:   rack
	#

Una: el archivo `.gitmodules`. un archivo de configuración para almacenar las relaciones entre la URL del proyecto y la subcarpeta local donde se ha colocado este.

	$ cat .gitmodules 
	[submodule "rack"]
	      path = rack
	      url = git://github.com/chneukirchen/rack.git

En caso de haber múltipes submódulos, habrá multiples entradas en este archivo. Merece destacar que este archivo está también bajo el control de versiones, como lo están otros archivos tal como `.gitignore`, por ejemplo. Y será enviado (push) y recibido (pull) junto con el resto del proyecto. Así es como otras personas que clonen el proyecto pueden saber dónde encontrar los submódulos del mismo.

Dos: la entrada `rack`. Si se lanza un `git diff` sobre ella, se puede apreciar algo muy interesante:

	$ git diff --cached rack
	diff --git a/rack b/rack
	new file mode 160000
	index 0000000..08d709f
	--- /dev/null
	+++ b/rack
	@@ -0,0 +1 @@
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

Aunque `rack` es una subcarpeta de la carpeta de trabajo, git la contempla como un submódulo y no realiza seguimiento de sus contenidos si no se está situado directamente sobre ella.  En su lugar, Git realiza confirmaciones de cambio particulares en ese repositorio. Cuando se realizan y confirman cambios en esa subcarpeta, el proyecto padre detecta el cambio en HEAD y almacena la confirmación de cambios concreta en la que se esté trabajando en ese momento. De esta forma, cuando otras personas clonen este proyecto, sabrán cómo recrear exactamente el entorno.

Esto es importante al trabajar con submódulos: siempre son almacenados como la confirmación de cambios concreta en la que están. No es posible almacenar un submódulo en `master` o en cualquier otra referencia simbólica.

Cuando se realiza una confirmación de cambios, se suele ver algo así como:

	$ git commit -m 'first commit with submodule rack'
	[master 0550271] first commit with submodule rack
	 2 files changed, 4 insertions(+), 0 deletions(-)
	 create mode 100644 .gitmodules
	 create mode 160000 rack

Notese el modo 160000 para la entrada `rack`. Este es un modo especial de Git, un modo en el que la confirmación de cambio se almacena como una carpeta en lugar de como una subcarpeta o un archivo.

Se puede considerar la carpeta `rack` como si fuera un proyecto separado. Y, como tal, de vez en cuando se puede actualizar el proyecto padre con un puntero a la última confirmación de cambios en dicho subproyecto. Todos los comandos Git actuan independientemente en ambas carpetas:

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

### Clonando un proyecto con submódulos ###

Si se tiene un proyecto con submódulos dentro de él. Cuando se recibe, se reciben también las carpetas que contienen los submódulos; pero no se reciben ninguno de los archivos de dichos submódulos:

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

La carpeta `rack` está presente, pero vacia. Son necesarios otros dos comandos: `git submodule init` para inicializar el archivo de configuración local, y `git submodule update` para recuperar (fetch) todos los datos del proyecto y extraer (checkout) la confirmación de cambios adecuada desde el proyecto padre:

	$ git submodule init
	Submodule 'rack' (git://github.com/chneukirchen/rack.git) registered for path 'rack'
	$ git submodule update
	Initialized empty Git repository in /opt/myproject/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 173 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.Resolving deltas: 100% (1951/1951), done.
	Submodule path 'rack': checked out '08d709f78b8c5b0fbeb7821e37fa53e69afcf433'

Tras esto, la carpeta `rack` sí que está exactamente en el estado que le corresponde estar tras la última confirmación de cambios que se realizó sobre ella. Si otra persona realiza cambios en el código de `rack`, los confirma y nosotros recuperamos (pull) dicha referencia y la fusionamos (merge), se obtendrá un resultado un tanto extraño:

	$ git merge origin/master
	Updating 0550271..85a3eee
	Fast forward
	 rack |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)
	[master*]$ git status
	# On branch master
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#      modified:   rack
	#

Se ha fusionado en algo que es básicamente un cambio en el puntero al submódulo. Pero no se ha actualizado el código en la carpeta del submódulo propiamente dicha. Por lo que se muestra un estado inconsistente en la misma:

	$ git diff
	diff --git a/rack b/rack
	index 6c5e70b..08d709f 160000
	--- a/rack
	+++ b/rack
	@@ -1 +1 @@
	-Subproject commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

Siendo esto debido a que el puntero al submódulo que se tiene en este momento  no corresponde a lo que realmente hay en carpeta del submódulo. Para arreglarlo, es necesario lanzar de nuevo el comando `git submodule update`: 

	$ git submodule update
	remote: Counting objects: 5, done.
	remote: Compressing objects: 100% (3/3), done.
	remote: Total 3 (delta 1), reused 2 (delta 0)
	Unpacking objects: 100% (3/3), done.
	From git@github.com:schacon/rack
	   08d709f..6c5e70b  master     -> origin/master
	Submodule path 'rack': checked out '6c5e70b984a60b3cecd395edd5b48a7575bf58e0'

Se necesita realizar este paso cada vez que se recupere (pull) un cambio del submódulo en el proyecto padre. Es algo extraño, pero ¡funciona!.

Un problema típico se suele dar cuando un desarrollador realiza y confirma (commit) un cambio local en el submódulo, pero no lo envia (push) a un servidor público. Pero, sin embargo, sí que confirma (commit) y envia (push) un puntero a dicho estado dentro del proyecto padre. Cuando otros desarrolladores intenten lanzar un `git submodule update`, será imposible encontrar la confirmación de cambios a la que se refiere el submódulo, ya que esta tan solo existe en el sistema del desarrollador original. En estos casos, se suele ver un error tal como:

	$ git submodule update
	fatal: reference isn’t a tree: 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Unable to checkout '6c5e70b984a60b3cecd395edd5ba7575bf58e0' in submodule path 'rack'

Forzandonos a mirar quién ha sido la persona que ha realizado los últimos cambios en el submódulo:

	$ git log -1 rack
	commit 85a3eee996800fcfa91e2119372dd4172bf76678
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Apr 9 09:19:14 2009 -0700

	    added a submodule reference I will never make public. hahahahaha!

Para enviarle un correo-e y avisarle de su despiste.

### Proyectos padre ###

Algunas veces, dependiendo del equipo de trabajo en que se encuentren, los desarrolladores suelen necesitar mantener una combinación de grandes carpetas de proyecto. Se da frecuentemente en equipos procedentes de CVS o de Subversion (donde se define una colección de módulos o carpetas), cuando desean mantener ese mismo tipo de flujo de trabajo.

La manera más apropiada de hacer esto en Git, es la de crear diferentes repositorios, cada uno en su carpeta; para luego crear un repositorio padre que englobe múltiples submódulos, uno por cada carpeta. Un beneficio que se obtiene de esta manera de trabajar es la mayor especificidad en las relaciones entre proyectos, definidas mediante etiquetas (tag) y ramas (branch) en el proyecto padre.

### Posibles problemáticas al usar submódulos ###

El uso de submódulos tiene también sus contratiempos. El primero de los cuales es la necesidad de ser bastante cuidadoso cuando se trabaja en la carpeta de un submódulo. Al lanzar `git submodule update`, este comando comprueba la versión específica del proyecto, pero sin tener en cuenta la rama. Es lo que se conoce como "trabajar con cabecera desconectada" --es decir, el archivo HEAD apunta directamente a una confirmación de cambios (commit), y no a una referencia simbólica--. Este método de trabajo suele tenderse a evitar, ya que trabajando en un entorno de cabecera desconectada es bastante facil despistarse y perder cambios ya realizados. Si se realiza un `submodule update` inicial, se hacen cambios y se confirman en esa carpeta de submódulo sin haber creado antes una rama en la que trabajar. Y si, tras esto, se realiza de nuevo un `git submodule update` desde el proyecto padre, sin haber confirmado cambios en este, Git sobreescribirá cambios sin aviso previo.  Técnicamente, no se pierde nada del trabajo. Simplemente, nos quedamos sin ninguna rama apuntando a él. Con lo que resulta problemático recuperar el acceso a los cambios.

Para evitarlo, siempre se ha de crear una rama cuando se trabaje en la carpeta de un submódulo; usando  `git checkout -b trabajo` o algo similar. Cuando se realice una actualización (update) del submódulo por segunda vez, se seguirá sobreescribiendo el trabajo; pero al menos se tendrá un apuntador para volver hasta los cambios realizados.

Intercambiar ramas con submódulos tiene también sus peculiaridades. Si se crea una rama, se añade un submódulo en ella y luego se retorna a una rama donde dicho submódulo no exista. La carpeta del submódulo sigue existiendo, solo que ahora queda como una carpeta sin seguimiento.

	$ git checkout -b rack
	Switched to a new branch "rack"
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/myproj/rack/.git/
	...
	Receiving objects: 100% (3184/3184), 677.42 KiB | 34 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.Resolving deltas: 100% (1952/1952), done.Resolving deltas: 100% (1952/1952), done.
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

Forzandonos a removerla del camino. Lo cual obliga a volver a clonarla cuando se retome la rama inicial --con la consiguiente pérdida de los cambios locales si estos no habian sido enviados previamente al servidor--.

Y una última problemática en que se suelen encontrar quienes intercambian de carpetas a submódulos. Si se ha estado trabajando en archivos de un proyecto al que luego se desea convertir en un submódulo, hay que ser muy cuidadoso o Git se resentirá. Asumiendo que se tenian archivos en una carpeta 'rack' del proyecto, y que se desea intercambiarla por un submódulo. Si se borra la carpeta y luego se lanza un comando `submodule add`, Git avisará de "carpeta ya existente en el índice":

	$ rm -Rf rack/
	$ git submodule add git@github.com:schacon/rack.git rack
	'rack' already exists in the index

Para evitarlo, se debe sacar la carpeta 'rack' del área de preparación. Después, Git permitirá la adicción del submódulo sin problemas:

	$ git rm -r rack
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/testsub/rack/.git/
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 88 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.Resolving deltas: 100% (1952/1952), done.Resolving deltas: 100% (1952/1952), done.

Tras esto, y suponiendo que ese paso ha sido realizado en una rama. Si se intenta retornar a dicha rama, cuyos archivos están aún en el árbol actual en lugar de en el submódulo, se obtendrá el siguiente error:

	$ git checkout master
	error: Untracked working tree file 'rack/AUTHORS' would be overwritten by merge.

Antes de cambiar a cualquier rama que no lo contenga, es necesario quitar de enmedio la carpeta del submódulo 'rack'.

	$ mv rack /tmp/
	$ git checkout master
	Switched to branch "master"
	$ ls
	README	rack

Y, cuando se retorne a la rama anterior, se tendrá una carpeta 'rack' vacia. Ante lo cual, será necesario lanzar`git submodule update` para volver a clonarla; o, si no,  volver a restaurar la carpeta  `/tmp/rack` de vuelta sobre la carpeta vacia.

## Fusión de subárboles ##

Ahora que se han visto las dificultades que se pueden presentar utilizando el sistema de submódulos, es momento de hechar un vistazo a una vía alternativa de atacar esa misma problemática. Cuando Git realiza una fusión, suele revisar lo que ha de fusiónar entre sí y, tras ese análisis, elige la estratégia mas adecuada para hacerlo. Si se están fusionando dos ramas, Git suele utilizar la _estategia_recursiva_ (_recursive_ strategy). Si se están fusionando más de dos ramas, Git suele escoger la _estrategia_del_pulpo_ (_octopus_ strategy). Estas son las estrategias escogidas por defecto, ya que la estrategia recursiva puede manejar complejas fusiones-de-tres-vias --por ejemplo, con más de un antecesor común-- pero tan solo puede fusionar dos ramas. La fusión-tipo-pulpo puede manejar multiples ramas, pero es mucho mas cuidadosa para evitar incurrir en complejos conflictos; y es por eso que se utiliza en los intentos de fusionar más de dos ramas.

Pero existen también otras estratégias que se pueden escoger según se necesiten. Una de ellas, la _fusión_subárbol_ (_subtree_ merge), es precisamente la más adecuada para tratar con subproyectos. En este caso se va a mostrar cómo se haria el mismo empotramiento del módulo rack tomado como ejemplo anteriormente, pero utilizando fusiones de subarbol en lugar de submódulos.

La idea subyacente tras toda fusión subarborea es la de que se tienen dos proyectos; y uno de ellos está relacionado con una subcarpeta en el otro, y viceversa. Cuando se solicita una fusión subarborea, Git es lo suficientemente inteligente como para imaginarse por si solo que uno de los proyectos es un subárbol del otro y obrar en consecuencia. Es realmente sorprendente.

Se comienza añadiendo la aplicación Rack al proyecto. Se añade como una referencia remota en el propio proyecto, y luego se extrae (checkout) en su propia rama:

	$ git remote add rack_remote git@github.com:schacon/rack.git
	$ git fetch rack_remote
	warning: no common commits
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 4 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.Resolving deltas: 100% (1952/1952), done.Resolving deltas: 100% (1952/1952), done.
	From git@github.com:schacon/rack
	 * [new branch]      build      -> rack_remote/build
	 * [new branch]      master     -> rack_remote/master
	 * [new branch]      rack-0.4   -> rack_remote/rack-0.4
	 * [new branch]      rack-0.9   -> rack_remote/rack-0.9
	$ git checkout -b rack_branch rack_remote/master
	Branch rack_branch set up to track remote branch refs/remotes/rack_remote/master.
	Switched to a new branch "rack_branch"

En este punto, se tiene la raiz del proyecto Rack en la rama `rack_branch` y la del propio proyecto padre en la rama `master`. Si se comprueban una o la otra, se puede observar que ambos proyectos tienen distintas raices:

	$ ls
	AUTHORS	       KNOWN-ISSUES   Rakefile      contrib	       lib
	COPYING	       README         bin           example	       test
	$ git checkout master
	Switched to branch "master"
	$ ls
	README

Si se desea situar el proyecto Rack como una subcarpeta del proyecto `master`. Se ha de lanzar el comando `git read-tree`. Se verá más en detalle el comando `read-tree` y sus acompañantes en el capítulo 9. Pero por ahora, basta con saber que este comando se encarga de leer el árbol raiz de una rama en el área de preparación (staging area) y carpeta de trabajo (working directory) actuales. Con ello, se retorna sobre la rama `master` y se recupera (pull) la rama `rack_branch` en la subcarpeta `rack` de la rama `master` del proyecto principal: 

	$ git read-tree --prefix=rack/ -u rack_branch

Cuando se confirman estos cambios, es como si se tuvieran todos los archivos Rack bajo esa carpeta --como si se hubieran copiado desde un archivo comprimido tarball-- Lo que hace interesante este método es la posibilidad que brinda de fusionar cambios de una rama sobre la otra de forma sencilla. De tal forma que, si se actualiza el proyecto Rack, se pueden integrar los cambios aguas arriba simplemente cambiando a esa rama y recuperando:

	$ git checkout rack_branch
	$ git pull

Tras lo cual, es posible fusionar esos cambios de vuelta a la rama 'master'. Utilizando el comando `git merge -s subtree`, que funciona correctamente; pero fusionando también los historiales entre sí. Un efecto secundario que posiblemente no interese. Para recuperar los cambios y rellenar el mensaje de la confirmación, se pueden emplear las opciones `--squash` y `--no-commit`, junto con la opción de estrategia `-s subtree`: 

	$ git checkout master
	$ git merge --squash -s subtree --no-commit rack_branch
	Squash commit -- not updating HEAD
	Automatic merge went well; stopped before committing as requested

Con esto, todos los cambios en el proyecto Rack se encontrarán fusionados y listos para ser confirmados localmente. También es posible hacer el camino contrario: realizar los cambios en la subcarpeta `rack` de la rama 'master', para posteriormente fusionarlos en la rama `rack_branch` y remitirlos a los encargados del mantenimiento o enviarlos aguas arriba.

Para ver las diferencias entre el contenido de la subcarpeta `rack` y el código en la rama `rack_branch` --para comprobar si es necesario fusionarlas--, no se puede emplear el comando `diff` habitual.  En su lugar, se ha de emplear el comando `git diff-tree` con la rama que se desea comparar: 

	$ git diff-tree -p rack_branch

O, otro ejemplo: para comparar el contenido de la subcarpeta `rack` con la rama `master` en el servidor: 

	$ git diff-tree -p rack_remote/master

## Recapitulación ##

Se han visto una serie de herramientas avanzadas que permiten manipular de forma precisa las confirmaciones de cambio y el área de preparación. Cuando se detectan problemas, se necesita tener la capacidad de localizar facilmente la confirmación de cambios en que fueron introducidos. En caso de requerir tener subproyectos dentro de un proyecto principal, se han visto unos cuantos caminos para resolver este requerimiento. En este punto, deberiamos ser capaces de realizar la mayoria de las acciones necesarias en el día a día con Git; realizandolas de manera confortable y segura.
