# Git en entornos distribuidos #

Ahora que ya tienes un repositorio Git, configurado como punto de trabajo para compartir código entre desarrolladores. Y ahora que ya conoces los comandos básicos de Git para flujos de trabajo locales. Puedes echar un vistazo a algunos de los flujos de trabajo distribuidos que Git permite.

En este capítulo, verás cómo trabajar con Git en un entorno distribuido, bien como colaborador o bien como integrador. Es decir, aprenderás cómo contribuir adecuadamente a un proyecto; de la forma más efectiva posible, tanto para tí, como para quien gestione el proyecto. Y aprenderás también a gestionar proyectos en los que colaboren multiples desarrolladores.

## Flujos de trabajo distribuidos ##

Al contrario de otros Sistemas Centralizados de Control de Versiones, (CVCSs, Centralized Version Control Systems), la naturaleza distribuida de Git permite mucha más flexibilidad en la manera de colaborar en proyectos. En los sistemas centralizados, cada desarrollador es un nodo de trabajo; trabajando todos ellos, en pie de igualdad, sobre un mismo repositorio central. En Git, en cambio, cada desarrollador es potencialmente tanto un nodo como un repositorio --es decir, cada desarrollador puede tanto contribuir a otros repositorios, como servir de repositorio público sobre el que otros desarrolladores pueden basar su trabajo y contribuir a él--. Esto abre un enorme rango de posibles formas de trabajo en tu proyecto y/o en tu equipo. Aquí vamos a revisar algunos de los paradigmas más comunes diseñados para sacar ventaja a esta gran flexibilidad. Vamos a repasar las fortalezas y posibles debilidades de cada paradigma. En tu trabajo, podrás elegir solo uno concreto, o podrás mezclar escogiendo funcionalidades concretas de cada uno.

### Flujo de trabajo centralizado ###

En los sistemas centralizados, tenemos una única forma de trabajar. Un repositorio o punto central guarda el código fuente; y todo el mundo sincroniza su trabajo con él. Unos cuantos desarrolladores son nodos de trabajo --consumidores de dicho repositorio-- y se sincronizan con dicho punto central. (ver Figura 5-1).

Insert 18333fig0501.png
Figura 5-1. Flujo de trabajo centralizado.

Esto significa que, si dos desarrolladores clonan desde el punto central, y ambos hacen cambios; tan solo el primero de ellos en enviar sus cambios de vuelta lo podrá hacer limpiamente. El segundo desarrollador deberá fusionar previamente su trabajo con el del primero, antes de enviarlo, para evitar el sobreescribir los cambios del primero. Este concepto es también válido en Git, tanto como en Subversion (o cualquier otro CVCS), y puede ser perfectamente utilizado en Git.

Si tienes un equipo pequeño o te sientes confortable con un flujo de trabajo centralizado, puedes continuar usando esa forma de trabajo con Git. Solo necesitas disponer un repositorio único, y dar acceso en envio (push) a todo tu equipo. Git se encargará de evitar el que se sobreescriban unos a otros. Si uno de los desarrolladores clona, hace cambios y luego intenta enviarlos; y otro desarrollador ha enviado otros cambios durante ese tiempo; el servidor rechazará los cambios del segundo desarrollador. El sistema le avisará de que está intentando enviar (push) cambios no directos (non-fast-forward changes), y de que no podrá hacerlo hasta que recupere (fetch) y fusione (merge) los cambios preexistentes.
Esta forma de trabajar es atractiva para mucha gente, por ser el paradigma con el que están familiarizados y se sienten confortables.

### Flujo de trabajo del Gestor-de-Integraciones ###

Al permitir multiples repositorios remotos, en Git es posible tener un flujo de trabajo donde cada desarrollador tenga acceso de escritura a su propio repositorio público y acceso de lectura a los repositorios de todos los demás. Habitualmente, este escenario suele incluir un repositorio canónico, representante "oficial" del proyecto.  Para contribuir en este tipo de proyecto, crearás tu propio clón público del mismo y enviarás (push) tus cambios a este. Después, enviarás una petición a la persona gestora del proyecto principal, para que recupere y consolide (pull) en él tus cambios. Ella podrá añadir tu repositorio como un remoto, chequear tus cambios localmente, fusionarlos (merge) con su rama y enviarlos (push) de vuelta a su repositorio. El proceso funciona de la siguiente manera (ver Figura 5-2):

1. La persona gestora del proyecto envia (push) a su repositorio público (repositorio principal).
2. Una persona que desea contribuir, clona dicho repositorio y hace algunos cambios.
3. La persona colaboradora envia (push) a su propia copia pública.
4. Esta persona colaboradora envia a la gestora un correo electronico solicitándole recupere e integre los cambios.
5. La gestora añade como remoto el repositorio de la colaboradora y fusiona (merge) los cambios localmente.
6. La gestora envia (push) los cambios fusionados al repositorio principal.

Insert 18333fig0502.png
Figura 5-2. Flujo de trabajo Gestor-de-Integración.

Esta es una forma de trabajo muy común en sitios tales como GitHub, donde es sencillo bifurcar (fork) un proyecto y enviar tus cambios a tu copia, donde cualquiera puede verlos. La principal ventaja de esta forma de trabajar es que puedes continuar trabajando, y la persona gestora del repositorio principal podrá recuperar (pull) tus cambios en cualquier momento. Las personas colaboradoras no tienen por qué esperar a que sus cambios sean incorporados al proyecto, --cada cual puede trabajar a su propio ritmo--.

### Flujo de trabajo con Dictador y Tenientes ###

Es una variante del flujo de trabajo con multiples repositorios. Se utiliza generalmente en proyectos muy grandes, con cientos de colaboradores. Un ejemplo muy conocido es el del kernel de Linux. Unos gestores de integración se encargan de partes concretas del repositorio; y se denominan tenientes. Todos los tenientes rinden cuentas a un gestor de integración; conocido como el dictador benevolente. El repositorio del dictador benevolente es el repositorio de referencia, del que recuperan (pull) todos los colaboradores. El proceso funciona como sigue (ver Figura 5-3):

1. Los desarrolladores habituales trabajan cada uno en su rama puntual y reorganizan (rebase) su trabajo sobre la rama master. La rama master es la del dictador benevolente.
2. Los tenienentes fusionan (merge) las ramas puntuales de los desarrolladores sobre su propia rama master.
3. El dictador fusiona las ramas master de los tenientes en su propia rama master.
4. El dictador envia (push) su rama master al repositorio de referencia, para permitir que los desarrolladores reorganicen (rebase) desde ella.

Insert 18333fig0503.png
Figura 5-3. Fujo de trabajo del dictador benevolente.

Esta manera de trabajar no es muy habitual, pero es muy util en proyectos muy grandes o en organizaciónes fuertemente jerarquizadas. Permite al lider o a la lider del proyecto (el/la dictador/a) delegar gran parte del trabajo; recolectando el fruto de multiples puntos de trabajo antes de integrarlo en el proyecto.

Hemos visto algunos de los flujos de trabajo mas comunes permitidos por un sistema distribuido como Git. Pero seguro que habrás comenzado a vislumbrar multiples variaciones que puedan encajar con tu particular forma de trabajar. Espero que a estas alturas estés en condiciones de reconocer la combinación de flujos de trabajo que puede serte util. Vamos a ver algunos ejemplos más específicos, ilustrativos de los roles principales que se presentan en las distintas maneras de trabajar.

## Contribuyendo a un proyecto ##

En estos momentos conoces las diferentes formas de trabajar, y tienes ya un generoso conocimiento de los fundamentos de Git. En esta sección, aprenderás acerca de las formas más habituales de contribuir a un proyecto.

El mayor problema al intentar describir este proceso es el gran número de variaciones que se pueden presentar. Por la gran flexibilidad de Git, la gente lo suele utilizar de multiples maneras; siendo problemático intentar describir la forma en que deberías contribuir a un proyecto --cada proyecto tiene sus peculiaridades--. Algunas de las variables a considerar son: la cantidad de colaboradores activos, la forma de trabajo escogida, el nivel de acceso que tengas, y, posiblemente, el sistema de colaboración externa implantado.

La primera variable es el número de colaboradores activos. ¿Cuántos usuarios están enviando activamente código a este proyecto?, y ¿con qué frecuencia?. En muchas ocasiones, tendrás dos o tres desarrolladores, con tan solo unas pocas confirmaciones de cambios (commits) diarias; e incluso menos en algunos proyectos durmientes. En proyectos o empresas verdaderamente grandes puedes tener cientos de desarrolladores, con docenas o incluso cientos de parches llegando cada día. Esto es importante, ya que cuantos más desarrolladores haya, mayores serán los problemas para asegurarte de que tu código se integre limpiamente. Los cambios que envies pueden quedar obsoletos o severamente afectados por otros trabajos que han sido integrados previamente mientras tú estabas trabajando o mientras tus cambios aguardaban a ser aprobados para su integración. ¿Cómo puedes mantener consistentemente actualizado tu código, y asegurarte así de que tus parches son válidos?

La segunda variable es la forma de trabajo que se utilice para el proyecto. ¿Es centralizado, con iguales derechos de acceso en escritura para cada desarrollador?. ¿Tiene un gestor de integraciones que comprueba todos los parches?. ¿Se revisan y aprueban los parches entre los propios desarrolladores?.  ¿Participas en ese proceso de aprobación?. ¿Existe un sistema de tenientes, a los que has de enviar tu trabajo en primer lugar?.

La tercera variable es el nivel de acceso que tengas. La forma de trabajar y de contribuir a un proyecto es totalmente diferente dependiendo de si tienes o no acceso de escritura al proyecto. Si no tienes acceso de escritura, ¿cuál es el sistema preferido del proyecto para aceptar contribuciones?. Es más, ¿tiene un sistema para ello?. ¿Con cuánto trabajo contribuyes?. ¿Con qué frecuencia?.

Todas estas preguntas afectan a la forma efectiva de contribuir a un proyecto, y a la forma de trabajo que prefieras o esté disponible para tí. Vamos a cubrir ciertos aspectos de todo esto, en una serie de casos de uso; desde los más sencillos hasta los más complejos. A partir de dichos ejemplos, tendrías que ser capaz de construir la forma de trabajo específica que necesites para cada caso.

### Reglas para las confirmaciones de cambios (commits) ###

Antes de comenzar a revisar casos de uso específicos, vamos a dar una pincelada sobre los mensajes en las confirmaciones de cambios (commits). Disponer unas reglas claras para crear confirmaciones de cambios, y seguirlas fielmente, facilta enormemente tanto el trabajo con Git y como la colaboración con otras personas. El propio proyecto Git suministra un documento con un gran número de buenas sugerencias sobre la creación de confirmaciones de cambio destinadas a enviar parches --puedes leerlo en el código fuente de Git, en el archivo 'Documentation/SubmittingPatches'--.

En primer lugar, no querrás enviar ningún error de espaciado. Git nos permite buscarlos facilmente. Previamente a realizar una confirmación de cambios, lanzar el comando 'git diff --check' para identificar posibles errores de espaciado. Aquí van algunos ejemplos, en los que hemos sustituido las marcas rojas por 'X's:

	$ git diff --check
	lib/simplegit.rb:5: trailing whitespace.
	+    @git_dir = File.expand_path(git_dir)XX
	lib/simplegit.rb:7: trailing whitespace.
	+ XXXXXXXXXXX
	lib/simplegit.rb:26: trailing whitespace.
	+    def command(git_cmd)XXXX

Lanzando este comando antes de confirmar cambios, puedes estar seguro de si vas o no a incluir problemas de espaciado que puedan molestar a otros desarrolladores.

En segundo lugar, intentar hacer de cada confirmación (commit) un grupo lógico e independiente de cambios. Siempre que te sea posible, intenta hacer digeribles tus cambios --no estés trabajando todo el fin de semana, sobre cuatro o cinco asuntos diferentes, y luego confirmes todo junto el lunes--. Aunque no hagas ninguna confirmación durante el fin de semana, el lunes puedes utilizar el área de preparación (staging area) para ir dividiendo tu trabajo y hacer una confirmación de cambios (commit) separada para cada asunto; con un mensaje adecuado para cada una de ellas. Si algunos de los cambios modifican un mismo archivo, utiliza el comando 'git add --patch' para almacenar parcialmente los archivos (tal y como se verá detalladamente en el Capítulo 6). El estado del proyecto al final de cada rama será idéntico si haces una sola confirmación o si haces cinco, en tanto en cuanto todos los cambios estén confirmados en un determinado momento. Por consiguiente, intenta facilitar las cosas a tus compañeros y compañeras desarroladores cuando vayan a revisar tus cambios. Además, esta manera de trabajar facilitará la integración o el descarte individual de alguno de los cambios, en caso de ser necesario. El Capítulo 6 contiene un gran número de trucos para reescribir el historial e ir preparando archivos interactivamente --utilizalos para ayudarte a crear un claro y comprensible historial--.

Y, por último, prestar atención al mensaje de confirmación. Si nos acostumbramos a poner siempre mensajes de calidad en las confirmaciones de cambios, facilitaremos en gran medida el trabajo y la colaboración con Git. Como regla general, tus mensajes han de comenzar con una ĺínea, de no más de 50 caracteres, donde se resuma el grupo de cambios; seguida de una línea en blanco; y seguida de una detallada explicación en las líneas siguientes. El proyecto Git obliga a incluir una explicación detallada; incluyendo tus motivaciones para los cambios realizados; y comentarios sobre las diferencias, tras su implementación, respecto del comportamiento anterior del programa. Esta recomendación es una buena regla a seguir. Es también buena idea redactar los mensajes utilizando el imperativo, en tiempo presente. Es decir, dá órdenes. Por ejemplo, en vez de escribir "He añadido comprobaciones para" o "Añadiendo comprobaciones para", utilizar la frase "Añadir comprobaciones para". Como plantilla de referencia, podemos utilizar la que escribió Tim Pope en tpope.net:

	Un resumen de cambios, corto (50 caracteres o menos).

	Seguido de un texto más detallado, si es necesario.  Limitando las líneas a 72 caracteres mas o menos.  En algunos contextos, la primera línea se tratará como si fuera el asundo de un correo electrónico y el resto del texto como si fuera el cuerpo.  La línea en blanco separando el resumen del cuerpo es crítica (a no ser que se omita totalmente el cuerpo); algunas herramientas como 'rebase' pueden tener problemas si no los separas adecuadamente.

	Los siguientes párrafos van tras la línea en blanco.

	 - Los puntos con bolo también están permitidos.

	 - Habitualmente se emplea un guión o un asterisco como bolo, seguido de un espacio, con líneas en blanco intermedias; pero las convenciones pueden variar.

Si todas tus confirmaciones de cambio (commit) llevan mensajes de este estilo, facilitarás las cosas tanto para tí como para las personas que trabajen contigo. El proyecto Git tiene los mensajes adecuadamente formateados. Te animo a lanzar el comando 'git log --no-merges' en dicho proyecto, para que veas la pinta que tiene un historial de proyecto limpio y claro.

En los ejemplos siguientes, y a lo largo de todo este libro, por razones de brevedad no formatearé correctamente los mensajes; sino que emplearé la opción '-m' en los comandos 'git commit'. Observa mis palabras, no mis hechos.

### Pequeño Grupo Privado ###

Lo más simple que te puedes encontrar es un proyecto privado con uno o dos desarrolladores. Por privado, me refiero a código propietario --no disponible para ser leido por el mundo exterior--. Tanto tu como el resto del equipo teneis acceso de envio (push) al repositorio.

En un entorno como este, puedes seguir un flujo de trabajo similar al que adoptarías usando Subversion o algún otro sistema centralizado. Sigues disfrutando de ventajas tales como las confirmaciones offline y la mayor simplicidad en las ramificaciones/fusiones. Pero, en el fondo, la forma de trabajar será bastante similar; la mayor diferencia radica en que las fusiones (merge) se hacen en el lado cliente en lugar de en el servidor.
Vamos a ver como actuarian dos desarrolladores trabajando conjuntamente en un repositorio compartido. El primero de ellos, John, clona el repositorio, hace algunos cambios y los confirma localmente: (en estos ejemplos estoy sustituyendo los mensajes del protocolo con '...' , para acortarlos)

	# John's Machine
	$ git clone john@githost:simplegit.git
	Initialized empty Git repository in /home/john/simplegit/.git/
	...
	$ cd simplegit/
	$ vim lib/simplegit.rb
	$ git commit -am 'removed invalid default value'
	[master 738ee87] removed invalid default value
	 1 files changed, 1 insertions(+), 1 deletions(-)

La segunda desarrolladora, Jessica, hace lo mismo: clona el repositorio y confirma algunos cambios:

	# Jessica's Machine
	$ git clone jessica@githost:simplegit.git
	Initialized empty Git repository in /home/jessica/simplegit/.git/
	...
	$ cd simplegit/
	$ vim TODO
	$ git commit -am 'add reset task'
	[master fbff5bc] add reset task
	 1 files changed, 1 insertions(+), 0 deletions(-)

Tras esto, Jessica envia (push) su trabajo al servidor:

	# Jessica's Machine
	$ git push origin master
	...
	To jessica@githost:simplegit.git
	   1edee6b..fbff5bc  master -> master

John intenta enviar también sus cambios:

	# John's Machine
	$ git push origin master
	To john@githost:simplegit.git
	 ! [rejected]        master -> master (non-fast forward)
	error: failed to push some refs to 'john@githost:simplegit.git'

John no puede enviar porque Jessica ha enviado previamente. Entender bien esto es especialmente importante, sobre todo si estás acostumbrado a utilizar Subversion; porque habrás notado que ambos desarrolladores han editado archivos distintos. Mientras que Subversion fusiona automáticamente en el servidor cuando los cambios han sido aplicados sobre archivos distintos, en Git has de fusionar (merge) los cambios localmente. John se vé obligado a recuperar (fetch) los cambios de jessica y a fusionarlos (merge) con los suyos, antes de que se le permita enviar (push):

	$ git fetch origin
	...
	From john@githost:simplegit
	 + 049d078...fbff5bc master     -> origin/master

En este punto, el repositorio local de John será algo parecido a la Figura 5-4.

Insert 18333fig0504.png
Figura 5-4. El repositorio inicial de John.

John tiene una referencia a los cambios enviados por Jessica, pero ha de fusionarlos en su propio trabajo antes de que se le permita enviar:

	$ git merge origin/master
	Merge made by recursive.
	 TODO |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

Si la fusión se realiza sin problemas, el historial de John será algo parecido a la Figura 5-5.

Insert 18333fig0505.png
Figura 5-5. El repositorio de John tras fusionar origin/master.

En este momento, John puede comprobar su código para verificar que sigue funcionando correctamente, y luego puede enviar su trabajo al servidor:

	$ git push origin master
	...
	To john@githost:simplegit.git
	   fbff5bc..72bbc59  master -> master

Finalmente, el historial de John es algo parecido a la Figura 5-6.

Insert 18333fig0506.png
Figura 5-6. El historial de John tras enviar al servidor origen.

Mientras tanto, jessica ha seguido trabajando en una rama puntual (topic branch). Ha creado una rama puntual denominada 'issue54' y ha realizado tres confirmaciones de cambios (commit) en dicha rama. Como todavia no ha recuperado los cambios de John, su historial es como se muestra en la Figura 5-7.

Insert 18333fig0507.png
Figura 5-7. Historial inicial de Jessica.

Jessica desea sincronizarse con John, para lo cual:

	# Jessica's Machine
	$ git fetch origin
	...
	From jessica@githost:simplegit
	   fbff5bc..72bbc59  master     -> origin/master

Esto recupera el trabajo enviado por John durante el tiempo en que Jessica estaba trabajando. El historial de Jessica es en estos momentos como se muestra en la figura 5-8.

Insert 18333fig0508.png
Figura 5-8. El historial de Jessica tras recuperar los cambios de John.

Jessica considera su rama puntual terminada, pero quiere saber lo que debe integrar con su trabajo antes de poder enviarla. Lo comprueba con el comando 'git log':

	$ git log --no-merges origin/master ^issue54
	commit 738ee872852dfaa9d6634e0dea7a324040193016
	Author: John Smith <jsmith@example.com>
	Date:   Fri May 29 16:01:27 2009 -0700

	    removed invalid default value

Ahora, jessica puede fusionar (merge) su trabajo de la rama puntual 'issue54' en su rama 'master'l, fusionar (merge) el trabajo de John ('origin/master') en su rama 'master', y enviarla de vuelta al servidor. Primero, se posiciona de nuevo en su rama principal para integrar todo su trabajo:

	$ git checkout master
	Switched to branch "master"
	Your branch is behind 'origin/master' by 2 commits, and can be fast-forwarded.

Puede fusionar primero tanto 'origin/master' o como 'issue54', ya que ambos están aguas arriba. La situación final (snapshot) será la misma, indistintamente del orden elegido; tan solo el historial variará ligeramente. Elige fusionar primero 'issue54':

	$ git merge issue54
	Updating fbff5bc..4af4298
	Fast forward
	 README           |    1 +
	 lib/simplegit.rb |    6 +++++-
	 2 files changed, 6 insertions(+), 1 deletions(-)

No hay ningún problema; como puedes observar, es un simple avance rápido (fast-forward). Tras esto, jessica fusiona el trabajo de John ('origin/master'):

	$ git merge origin/master
	Auto-merging lib/simplegit.rb
	Merge made by recursive.
	 lib/simplegit.rb |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)

Todo se integra limpiamente, y el historial de Jessica queda como en la Figura 5-9.

Insert 18333fig0509.png
Figura 5-9. El historial de Jessica tras fusionar los cambios de John.

En este punto, la rama 'origin/master' es alcanzable desde la rama 'master' de Jessica, permitiendole enviar (push) --asumiendo que John no haya enviado nada más durante ese tiempo--:

	$ git push origin master
	...
	To jessica@githost:simplegit.git
	   72bbc59..8059c15  master -> master

Cada desarrollador ha confirmado algunos cambios y ambos han fusionado sus trabajos correctamente; ver Figura 5-10.

Insert 18333fig0510.png
Figura 5-10. El historial de Jessica tras enviar de vuelta todos los cambios al servidor.

Este es uno de los flujos de trabajo más simples. Trabajas un rato, normalmente en una rama puntual de un asunto concreto, y la fusionas con tu rama principal cuando la tienes lista para integrar. Cuando deseas compartir ese trabajo, lo fusionas (merge) en tu propia rama 'master'; luego recuperas (fetch) y fusionas (merge) la rama 'origin/master', por si hubiera cambiado; y finalmente envias (push) la rama 'master' de vuelta al servidor. La secuencia general es algo así como la mostrada en la Figura 5-11.

Insert 18333fig0511.png
Figura 5-11. Secuencia general de eventos en un flujo de trabajo multidesarrollador simple.

### Grupo Privado Gestionado ###

En este próximo escenario, vamos a hechar un vistazo al rol de colaborador en un gran grupo privado. Aprenderás cómo trabajar en un entorno donde pequeños grupos colaboran en algunas funcionalidades, y luego todas las aportaciones de esos equipos son integradas por otro grupo.

Supongamos que John y Jessica trabajan conjuntamente en una funcionalidad, mientras que jessica y Josie trabajan en una segunda funcionalidad. En este caso, la compañia está utilizando un flujo de trabajo del tipo gestor-de-integración, donde el trabajo de algunos grupos individuales es integrado por unos ingenieros concretos; siendo solamente estos últimos quienes pueden actualizar la rama 'master' del repositorio principal. En este escenario, todo el trabajo se realiza en ramas propias de cada grupo y es consolidado por los integradores más tarde.

Vamos a seguir el trabajo de Jessica, a medida que trabaja en sus dos funcionalidade; colaborando en paralelo con dos desarrolladores distintos. Suponiendo que tiene su repositorio ya clonado, ella decide trabajar primero en la funcionalidad A (featureA). Crea una nueva rama para dicha funcionalidad y trabaja en ella:

	# Jessica's Machine
	$ git checkout -b featureA
	Switched to a new branch "featureA"
	$ vim lib/simplegit.rb
	$ git commit -am 'add limit to log function'
	[featureA 3300904] add limit to log function
	 1 files changed, 1 insertions(+), 1 deletions(-)

En ese punto, necesita compartir su trabajo con John, por lo que envia (push) al servidor las confirmaciones (commits) en su rama 'featureA'. Como Jessica no tiene acceso de envio a la rama 'master' --solo los integradores lo tienen--, ha de enviar a alguna otra rama para poder colaborar con John:

	$ git push origin featureA
	...
	To jessica@githost:simplegit.git
	 * [new branch]      featureA -> featureA

Jessica notifica a John por correo electrónico que ha enviado trabajo a una rama denominada 'featureA' y que puede hecharle un vistazo allí. Mientras espera noticias de John, Jessica decide comenzar a trabajar en la funcionalidad B (featureB) con Josie. Para empezar, arranca una nueva rama puntual, basada en la rama 'master' del servidor:

	# Jessica's Machine
	$ git fetch origin
	$ git checkout -b featureB origin/master
	Switched to a new branch "featureB"

Y realiza un par de confirmaciones de cambios (commits) en la rama 'featureB':

	$ vim lib/simplegit.rb
	$ git commit -am 'made the ls-tree function recursive'
	[featureB e5b0fdc] made the ls-tree function recursive
	 1 files changed, 1 insertions(+), 1 deletions(-)
	$ vim lib/simplegit.rb
	$ git commit -am 'add ls-files'
	[featureB 8512791] add ls-files
	 1 files changed, 5 insertions(+), 0 deletions(-)

Quedando su repositorio como se muestra en la Figura 5-12

Insert 18333fig0512.png
Figura 5-12. Historial inicial de Jessica.

Cuando está preparada para enviar (push) su trabajo, recibe un correo electronico de Josie de que ha puesto en el servidor una rama denominada 'featureBee', con algo de trabajo. Jessica necesita fusionar (merge) dichos cambios con los suyos antes de poder enviarlos al servidor. Por tanto, recupera (fetch) los cambios de Josie:

	$ git fetch origin
	...
	From jessica@githost:simplegit
	 * [new branch]      featureBee -> origin/featureBee

Y los fusiona con su propio trabajo:

	$ git merge origin/featureBee
	Auto-merging lib/simplegit.rb
	Merge made by recursive.
	 lib/simplegit.rb |    4 ++++
	 1 files changed, 4 insertions(+), 0 deletions(-)

Pero hay un pequeño problema, necesita enviar el trabajo fusionado en su rama 'featureB' a la rama 'featureBee' del servidor. Puede hacerlo usando el comando 'git push' e indicando específicamente el nombre de la rama local seguida de dos puntos (:) y seguida del nombre de la rama remota:

	$ git push origin featureB:featureBee
	...
	To jessica@githost:simplegit.git
	   fba9af8..cd685d1  featureB -> featureBee

Esto es lo que se denomina un _refspec_. Puedes ver el Capítulo 9 para una discusión más detallada acerca de los _refspecs_ de Git y los distintos usos que puedes darles.

A continuación, John envia un correo electronico a jessica comentandole que ha enviado algunos cambios a la rama 'featureA' y pidiendole que los verifique. Ella lanza un 'git fetch' para recuperar dichos cambios:

	$ git fetch origin
	...
	From jessica@githost:simplegit
	   3300904..aad881d  featureA   -> origin/featureA

A continuación, puede ver las modificaciones realizadas, lanzando el comando 'git log':

	$ git log origin/featureA ^featureA
	commit aad881d154acdaeb2b6b18ea0e827ed8a6d671e6
	Author: John Smith <jsmith@example.com>
	Date:   Fri May 29 19:57:33 2009 -0700

	    changed log output to 30 from 25

Para terminar, fusiona el trabajo de John en su propia rama 'featureA':

	$ git checkout featureA
	Switched to branch "featureA"
	$ git merge origin/featureA
	Updating 3300904..aad881d
	Fast forward
	 lib/simplegit.rb |   10 +++++++++-
	1 files changed, 9 insertions(+), 1 deletions(-)

Jessica realiza algunos ajustes, los confirma (commit) y los envia (push) de vuelta al servidor:

	$ git commit -am 'small tweak'
	[featureA ed774b3] small tweak
	 1 files changed, 1 insertions(+), 1 deletions(-)
	$ git push origin featureA
	...
	To jessica@githost:simplegit.git
	   3300904..ed774b3  featureA -> featureA

Quedando su historial como se muestra en la Figura 5-13.

Insert 18333fig0513.png
Figura 5-13. El historial de Jessica después de confirmar cambios en una rama puntual.

Jessica, Josie y John informan a los integradores de que las ramas 'featureA' y 'featureBee' del servidor están preparadas para su integración con la línea principal del programa. Despues de que dichas ramas sean integradas en la línea principal, una recuperación (fetch) traerá de vuelta las confirmaciones de cambios de las integraciones (merge commits), dejando un historial como el mostrado en la Figura 5-14.

Insert 18333fig0514.png
Figura 5-14. El historial de Jessica tras fusionar sus dos ramas puntuales.

Muchos grupos se están pasando a trabajar con Git, debido a su habilidad para mantener multiples equipos trabajando en paralelo, fusionando posteriormente las diferentes líneas de trabajo. La habilidad para que pequeños subgrupos de un equipo colaboren a través de ramas remotas, sin necesidad de tener en cuenta o de perturbar el equipo completo, es un gran beneficio de trabajar con Git. La secuencia del flujo de trabajo que hemos visto es algo así como lo mostrado en la Figura 5-15.

Insert 18333fig0515.png
Figura 5-15. Secuencia básica de este flujo de trabajo en equipo gestionado.

### Pequeño Proyecto Público ###

Contribuir a proyectos públicos es ligeramente diferente. Ya que no tendrás permisos para actualizar ramas directamente sobre el proyecto, has de enviar el trabajo a los gestores de otra manera. En este primer ejemplo, veremos cómo contribuir a través de bifurcaciones (forks) en servidores Git que soporten dichas bifurcaciones. Los sitios como repo.or.cz  ó GitHub permiten realizar esto, y muchos gestores de proyectos esperan este estilo de contribución. En la siguiente sección, veremos el caso de los proyectos que prefieren aceptar contribuciones a través del correo electrónico.

Para empezar, problemente desees clonar el repositorio principal, crear una rama puntual para el parche con el que piensas contribuir, y ponerte a trabajar sobre ella. La secuencia será algo parecido a esto:

	$ git clone (url)
	$ cd project
	$ git checkout -b featureA
	$ (work)
	$ git commit
	$ (work)
	$ git commit

Puedes querer utilizar 'rebase -i' para reducir tu trabajo a una sola confirmación de cambios (commit), o reorganizar el trabajo en las diversas confirmaciones para facilitar la revisión de parche por parte del gestor del proyecto --ver el Capítulo 6 para más detalles sobre reorganizaciones interactivas--.

Cuando el trabajo en tu rama puntual está terminado y estás listo para enviarlo al gestor del proyecto, vete a la página del proyecto original y clica sobre el botón "Fork" (bifurcar), para crear así tu propia copia editable del proyecto. Tendrás que añadir la URL a este nuevo repositorio como un segundo remoto, y en este caso lo denominaremos 'myfork':

	$ git remote add myfork (url)

Tu trabajo lo enviarás (push) a este segundo remoto. Es más sencillo enviar (push) directamente la rama puntual sobre la que estás trabajando, en lugar de fusionarla (merge) previamente con tu rama principal y enviar esta última. Y la razón para ello es que, si el trabajo no es aceptado o se integra solo parcialmente, no tendrás que rebobinar tu rama principal. Si el gestor del proyecto fusiona (merge), reorganiza (rebase) o integra solo parcialmente tu trabajo, aún podrás recuperarlo de vuelta a través de su repositorio:

	$ git push myfork featureA

Tras enviar (push) tu trabajo a tu copia bifurcada (fork), has de notificarselo al gestor del proyecto.  Normalmente se suele hacer a través de una solicitud de recuperación/integración (pull request). La puedes generar directamente desde el sitio web, --GitHub tiene un botón "pull request" que notifica automáticamente al gestor--, o puedes lanzar el comando 'git request-pull' y enviar manualmente su salida por correo electrónico al gestor del proyecto.

Este comando 'request-pull' compara la rama base donde deseas que se integre tu rama puntual y el repositorio desde cuya URL deseas que se haga, para darte un resumen de todos los cambios que deseas integrar. Por ejemplo, si Jessica quiere enviar a John una solicitud de recuperación, y ha realizado dos confirmaciones de cambios sobre la rama puntual que desea enviar, lanzará los siguientes comandos:

	$ git request-pull origin/master myfork
	The following changes since commit 1edee6b1d61823a2de3b09c160d7080b8d1b3a40:
	  John Smith (1):
	        added a new function

	are available in the git repository at:

	  git://githost/simplegit.git featureA

	Jessica Smith (2):
	      add limit to log function
	      change log output to 30 from 25

	 lib/simplegit.rb |   10 +++++++++-
	 1 files changed, 9 insertions(+), 1 deletions(-)

Esta salida puede ser enviada al gestor del proyecto, --le indica el punto donde  se ramificó, resume las confirmaciones de cambio, y le dice desde dónde recuperar estos cambios--.

En un proyecto del que no seas gestor, suele ser más sencillo tener una rama tal como 'master' siguiendo siempre a la rama 'origin/master'; mientras realizas todo tu trabajo en otras ramas puntuales, que podrás descartar facilmente en caso de que alguna de ellas sea rechazada.  Manteniendo el trabajo de distintos temas aislados en sus respectivas ramas puntuales, te facilitas también el poder reorganizar tu trabajo si la cabeza del repositorio principal se mueve mientras tanto y tus confirmaciones de cambio (commits) ya no se pueden integrar limpiamente. Por ejemplo, si deseas contribuir al proyecto en un segundo tema, no continues trabajando sobre la rama puntual que acabas de enviar; comienza una nueva rama puntual desde la rama 'master' del repositorio principal:

	$ git checkout -b featureB origin/master
	$ (work)
	$ git commit
	$ git push myfork featureB
	$ (email maintainer)
	$ git fetch origin

De esta forma, cada uno de los temas está aislado dentro de un silo, --similar a una cola de parches--; permitiendote reescribir, reorganizar y modificar cada uno de ellos sin interferir ni crear interdependencias entre ellos.

Insert 18333fig0516.png
Figura 5-16. Historial inicial con el trabajo de la funcionalidad B.

Supongamos que el gestor del proyecto ha recuperado e integrado un grupo de otros parches y después lo intenta con tu primer parche, viendo que no se integra limpiamente.  En este caso, puedes intentar reorganizar (rebase) tu parche sobre 'origin/master', arreglar los conflictos y volver a enviar tus cambios:

	$ git checkout featureA
	$ git rebase origin/master
	$ git push –f myfork featureA

Esto reescribe tu historial, quedando como se vé en la Figura 5-17.

Insert 18333fig0517.png
Figura 5-17. Historial tras el trabajo en la funcionalidad A.

Debido a que has reorganizado (rebase) tu rama de trabajo, tienes que indicar la opción '-f' en tu comando de envio (push), para permitir que la rama 'featureA' del servidor sea reemplazada por una confirmación de cambios (commit) que no es hija suya. Una alternativa podría ser el enviar (push) este nuevo trabajo a una rama diferente del servidor (por ejemplo a 'featureAv2').

Vamos a ver otro posible escenario: el gestor del proyecto ha revisado tu trabajo en la segunda rama y le ha gustado el concepto, pero desea que cambies algunos detalles de la implementación.  Puedes aprovechar también esta oportunidad para mover el trabajo y actualizarlo sobre la actual rama 'master' del proyecto. Para ello, inicias una nueva rama basada en la actual 'origin/master', aplicas (squash) sobre ella los cambios de 'featureB', resuelves los posibles conflictos que se pudieran presentar, realizas los cambios en los detalles, y la envias de vuelta como una nueva rama:

	$ git checkout -b featureBv2 origin/master
	$ git merge --no-commit --squash featureB
	$ (change implementation)
	$ git commit
	$ git push myfork featureBv2

La opción '--squash' coge todo el trabajo en la rama fusionada y lo aplica, en una sola confirmación de cambios sin fusión (no-merge commit), sobre la rama en la que estés situado. La opción '--no-commit' indica a Git que no debe registrar automáticamente una confirmación de cambios. Esto te permitirá el aplicar todos los cambios de la otra rama y después hacer más cambios, antes de guardarlos todos ellos en una nueva confirmación (commit).

En estos momentos, puedes notificar al gestor del proyecto que has realizado todos los cambios solicitados y que los puede encontrar en tu rama 'featureBv2' (ver Figura 5-18).

Insert 18333fig0518.png
Figura 5-18. Historial tras el trabajo en la versión 2 de la funcionalidad B.

### Proyecto Público Grande ###

Muchos grandes proyectos suelen tener establecidos los procedimientos para aceptar parches; --es necesario que compruebes las normas específicas para cada proyecto, ya que pueden variar de uno a otro--. De todas formas, muchos de los proyectos públicos más grandes aceptar parches a través de una lista de correo electrónico, por lo que veremos un ejemplo de dicho procedimiento.

El flujo de trabajo es similar a los casos de uso vistos anteriormente; --creando ramas puntuales para cada serie de parches en los que vayas a trabajar--. La diferencia está en la forma de enviarlos al proyecto. En lugar de bifurcar (fork) el proyecto y enviar a tu propia copia editable, generarás correos electrónicos para cada serie de parches y os enviarás a la lista de correo.

	$ git checkout -b topicA
	$ (work)
	$ git commit
	$ (work)
	$ git commit

Tienes dos confirmaciones de cambios (commits) a enviar a la lista de correo. Utilizarás el comando `git format-patch` para generar archivos formateados para poder ser enviados por correo electrónico. Este comando convierte cada confirmación de cambios (commit) en un mensaje de correo; con la primera línea del mensaje de confirmación puesto como asunto, y el resto del mensaje mas el parche como cuerpo.  Lo bonito de este procedimiento es que, al aplicar un parche desde un correo electrónico generado por `format-patch`, se preserva íntegramente la información de la confirmación de cambios (commit). Lo veremos más adelante, en la próxima sección, cuando veamos como aplicarlos:

	$ git format-patch -M origin/master
	0001-add-limit-to-log-function.patch
	0002-changed-log-output-to-30-from-25.patch

El comando `format-patch` lista los nombres de los archivos de parche que crea. La opción `-M` indica a Git que ha de mirar por si hay algo renombrado. Los archivos serán algo como:

	$ cat 0001-add-limit-to-log-function.patch
	From 330090432754092d704da8e76ca5c05c198e71a8 Mon Sep 17 00:00:00 2001
	From: Jessica Smith <jessica@example.com>
	Date: Sun, 6 Apr 2008 10:17:23 -0700
	Subject: [PATCH 1/2] add limit to log function

	Limit log functionality to the first 20Limit log functionality to the first 20Limit log functionality to the first 20

	---
	 lib/simplegit.rb |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)

	diff --git a/lib/simplegit.rb b/lib/simplegit.rb
	index 76f47bc..f9815f1 100644
	--- a/lib/simplegit.rb
	+++ b/lib/simplegit.rb
	@@ -14,7 +14,7 @@ class SimpleGit
	   end

	   def log(treeish = 'master')
	-    command("git log #{treeish}")
	+    command("git log -n 20 #{treeish}")
	   end

	   def ls_tree(treeish = 'master')
	--
	1.6.2.rc1.20.g8c5b.dirty

Puedes incluso editar esos archivos de parche, para añadirles más información , específica para la lista de correo, y que no desees mostrar en el propio mensaje de la confirmación de cambios.  Si añades texto entre la línea que comienza por `---` y el comienzo del parche (la línea `lib/simplegit.rb`). Los desarrolladores de la lista de correo podrán leerlo. Pero será ignorado al aplicar el parche al proyecto.

Para enviar estos archivos a la lista de correo,puedes tanto pegar directamente el archivo en tu programa de correo electrónico, como enviarlo a través de algún programa basado en línea de comandos. Pegar el texto directamente suele causar problemas de formato. Especialmente con los clientes de correo más "inteligentes", que no preservan adecuadamente los saltos de línea y otros espaciados. Afortunadamente, Git suministra una herramienta que nos puede ser de gran ayuda para enviar parches correctamente formateados a través de protocolo IMAP, facilitandonos así las cosas. Voy a indicar cómo enviar un parche usando Gmail, que da la casualidad de que es el agente de correo utilizado por mí. En el final del anteriormente citado documento, `Documentation/SubmittingPatches`, puedes leer instrucciones detalladas para otros agentes de correo.

Lo primero es configurar correctamente el apartado imap de tu archivo `~/.gitconfig`. Puedes ir ajustando cada valor individualmente, a través de comandos `git config`; o puedes añadirlos todos manualmente. Pero, al final, tu archivo de configuración ha de quedar más o menos como esto:

	[imap]
	  folder = "[Gmail]/Drafts"
	  host = imaps://imap.gmail.com
	  user = user@gmail.com
	  pass = p4ssw0rd
	  port = 993
	  sslverify = false

Las dos últimas líneas probablente no sean necesarias si tu servidor IMAP no utiliza SSL; y, en ese caso, el valor para `host` deberá de ser `imap://` en lugar de `imaps://`.
Cuando tengas esto ajustado, podrás utilizar el comando `git send-email` para poner series de parches en la carpeta de borradores (Drafts) de tu servidor IMAP:

	$ git send-email *.patch
	0001-added-limit-to-log-function.patch
	0002-changed-log-output-to-30-from-25.patch
	Who should the emails appear to be from? [Jessica Smith <jessica@example.com>]
	Emails will be sent from: Jessica Smith <jessica@example.com>
	Who should the emails be sent to? jessica@example.com
	Message-ID to be used as In-Reply-To for the first email? y

Tras esto, Git escupirá una serie de información de registro, con pinta más o menos como esta:

	(mbox) Adding cc: Jessica Smith <jessica@example.com> from
	  \line 'From: Jessica Smith <jessica@example.com>'
	OK. Log says:
	Sendmail: /usr/sbin/sendmail -i jessica@example.com
	From: Jessica Smith <jessica@example.com>
	To: jessica@example.com
	Subject: [PATCH 1/2] added limit to log function
	Date: Sat, 30 May 2009 13:29:15 -0700
	Message-Id: <1243715356-61726-1-git-send-email-jessica@example.com>
	X-Mailer: git-send-email 1.6.2.rc1.20.g8c5b.dirty
	In-Reply-To: <y>
	References: <y>

	Result: OK

En estos momentos, deberías poder ir a tu carpeta de borradores (Drafts), cambiar el destinatario (To) para apuntar a la lista de correo donde estés enviando el parche, puede que poner en copia (CC) al gestor o persona responsable, y enviar el mensaje.

### Recapitulación ###

En esta sección hemos visto unos cuantos de los flujos de trabajo más habituales para lidiar con distintos tipos de proyectos Git. Y hemos introducido un par de nuevas herramientas para ayudarte a gestionar estos procesos. A continuación veremos cómo trabajar en el otro lado de la moneda: manteniendo y gestionando un proyecto Git. Vas a aprender cómo ser un dictador benevolente o un gestor de integración.

## Gestionando un proyecto ##

Además de conocer cómo contribuir de forma efectiva a un proyecto, es posible que desees saber tambien cómo mantener uno. Lo cual implicará saber aceptar y aplicar parches generados vía `format-patch`, enviados a tí a través de correo electronico; o saber integrar cambios realizados en ramas de repositorios que añadirás como remotos a tu proyecto. Tanto si gestionas un repositorio canónico, como si deseas colaborar verificando o aprobando parches, necesitas saber cómo aceptar trabajo de otros de la forma más clara para tus contribuyentes y más sostenible para tí a largo plazo.

### Trabajando con Ramas Puntuales ###

Cuando estás pensando en integrar nuevo trabajo, suele ser buena idea utilizar una rama puntual para cada tema concreto --una rama temporal creada específicamente para trabajar dicho tema-- De esta forma, es sencillo tratar cada parche de forma individualizada y poder "aparcar" uno concreto cuando no trabajamos en él, hasta cuando volvamos a tener tiempo para retomarlo. Si creas los nombres de ramas basandolos en el tema sobre el que vas a trabajar, por ejemplo 'ruby client' o algo así de descriptivo, podrás recordar de qué iba cada rama en caso de que la abandones por un tiempo y la retomes más tarde. La persona gestora del proyecto Git suele tender a nombrar cada rama de foma parecida --por ejemplo 'sc/ruby client', donde sc es la abreviatura para la persona que ha contribuido con ese trabajo--.
Como recordarás, la forma de crear una rama basandola en tu rama master es:

	$ git branch sc/ruby_client master

O, si deseas crearla y saltar inmediatamente a ella, puedes también utilizar la opción '-b' del comando 'checkout':

	$ git checkout -b sc/ruby_client master

Tras esto, estarás listo para añadir tu trabajo a esa rama puntual y ver si deseas o no fusionarla luego con alguna otra de tus ramas de más largo recorrido.

### Aplicar parches recibidos por correo electronico ###

Si vas a integrar en tu proyecto un parche recibido a través de un correo electrónico. Antes de poder evaluarlo, tendrás que incorporarlo a una de tus ramas puntuales. Tienes dos caminos para incorporar un parche recibido por correo electronico: usando el comando 'git apply' o usando el comando 'git am'.

#### Incorporando un parche con apply ####

Si recibes un parche de alguien que lo ha generado con el comando 'git diff' o con un comando 'diff' de Unix, puedes incorporalo con el comando 'git apply'. Suponiendo que has guardado el parche en '/tmp/patch-ruby-client.patch', puedes incorporarlo con una orden tal como:

	$ git apply /tmp/patch-ruby-client.patch

Esto modificará los archivos en tu carpeta de trabajo. Es prácticamente idéntico a lanzar el comando 'patch -p1', aunque es más paranoico y acepta menos coincidencias aproximadas. Además, es capaz de manejar adicciones, borrados o renombrados de archivos, si vienen en formato 'git diff'. Mientras que 'patch' no puede hacerlo. Por ultimo, citar que 'git apply' sigue un modelo de "aplicar todo o abortar todo", incorporando todos los cambios o no incorporando ninguno. Mientras que 'patch' puede incorporar cambios parcialmente, dejando tu carpeta de trabajo en un estado inconsistente. 'git apply' es, de lejos, mucho más paranoico que 'patch'. Nunca creará una confirmación de cambios (commit) por tí, --tras ejecutar el comando, tendrás que preparar (stage) y confirmar (commit) manualmente todos los cambios introducidos--.

Tambien puedes utilizar 'git apply' para comprobar si un parche se puede incorporar limpiamente; antes de intentar incorporarlo. Puedes lanzar el comando 'git apply --check':

	$ git apply --check 0001-seeing-if-this-helps-the-gem.patch
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply

Si obtienes una salida vacia, el parche se podrá incorporar limpiamente. Además, este comando retorna con un status no-cero en caso de fallar la comprobación, por lo que puedes utilizarlo en scripts si lo deseas.

#### Incorporando un parche con am ####

Si la persona que contribuye es usuaria de Git y conoce lo suficiente como para utilizar el comando 'format-patch' al generar su parche, tendrás mucho camino recorrido al incorporarlo; ya que el parche traerá consigo información sobre el o la autora, además de un mensaje de confirmación de cambios. Si puedes, anima a tus colaboradoras a utilizar 'format-patch' en lugar de 'diff' cuando vayan a generar parches. Solo deberías utilizar 'git apply' en caso de parches antiguos y similares.

Para incorporar un parche generado con 'format-patch', utilizarás el comando 'git am'. Técnicamente, 'git am' se construyó para leer un archivo de buzón de correo (mbox file), que no es más que un simple formato de texto plano para almacenar uno o varios mensajes de correo electrónico en un solo archivo de texto. Es algo parecido a esto:

	From 330090432754092d704da8e76ca5c05c198e71a8 Mon Sep 17 00:00:00 2001
	From: Jessica Smith <jessica@example.com>
	Date: Sun, 6 Apr 2008 10:17:23 -0700
	Subject: [PATCH 1/2] add limit to log function

	Limit log functionality to the first 20Limit log functionality to the first 20Limit log functionality to the first 20

Esto es el comienzo de la salida del comando format-patch visto en la sección anterior. Es también un formato válido para un mbox. Si alguien te ha enviado correctamente un parche utilizando 'git send-email', y te lo has descargado a un formato mbox; podrás indicar dicho archivo mbox al comando 'git am', y este comenzará a incorporar todos los parches que encuentre dentro. Si tienes un cliente de correo electrónico capaz de guardar varios mensajes en formato mbox, podrás guardar series completas de parches en un mismo archivo; y luego usar 'git am' para irlos incorporando secuencialmente.

Sin embargo, si alguien sube su archivo de parche a un sistema de gestión de peticiones de servicio o similar; tendrás que descargartelo a un archivo local en tu disco y luego indicar ese archivo local al comando 'git am':

	$ git am 0001-limit-log-function.patch
	Applying: add limit to log function

Observarás que, tras incorporarlo limpiamente, crea automáticamente una nueva confirmación de cambios (commit). La información sobre el autor o autora la recoge de las cabeceras 'From' (Remitente) y 'Date' (Fecha). Y el mensaje para la confirmación (commit) lo recoge de 'Subject' (Asunto) y del cuerpo del correo electrónico. Por ejemplo, si consideramos el parche incorporado desde el mbox del ejemplo que acabamos de mostrar; la confirmación de camios (commit) generada será algo como:

	$ git log --pretty=fuller -1
	commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Author:     Jessica Smith <jessica@example.com>
	AuthorDate: Sun Apr 6 10:17:23 2008 -0700
	Commit:     Scott Chacon <schacon@gmail.com>
	CommitDate: Thu Apr 9 09:19:06 2009 -0700

	   add limit to log function

	   Limit log functionality to the first 20Limit log functionality to the first 20Limit log functionality to the first 20

El campo 'Commit' muestra la persona que ha incorporado el parche y cuándo lo ha incorporado. El campo 'Author' muestra la persona que ha creado originalmente el parche y cuándo fue creado este.

Pero también podría suceder que el parche no se pudiera incorporar limpiamente. Es posible que tu rama principal diverja demasiado respecto de la rama sobre la que se construyó el parche; o que el parche tenga dependencias respecto de algún otro parche anterior que aún no hayas incorporado. En ese caso, el proceso 'git am' fallará y te preguntará qué deseas hacer:

	$ git am 0001-seeing-if-this-helps-the-gem.patch
	Applying: seeing if this helps the gem
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply
	Patch failed at 0001.
	When you have resolved this problem run "git am --resolved".
	If you would prefer to skip this patch, instead run "git am --skip".
	To restore the original branch and stop patching run "git am --abort".

Este comando pondrá marcadores de conflicto en cualquier archivo con problemas, de forma similar a como lo haría una operación de fusión (merge) o de reorganización (rebase). Y resolverás los problemas de la misma manera: editar el archivo para resolver los conflictos, prepararlo (stage), y lanzar 'git am --resolved' para continuar con el siguiente parche:

	$ (fix the file)
	$ git add ticgit.gemspec
	$ git am --resolved
	Applying: seeing if this helps the gem

Si deseas más inteligencia por parte de Git al resolver conflictos, puedes pasarle la opción '-3', para que intente una fusión a tres bandas (three-way merge). Esta opción no se usa por defecto, porque no funcionará en caso de que la confirmación de cambios en que el parche dice estar basado no esté presente en tu repositorio.  Sin embargo, si tienes dicha confirmación de cambios (commit), --si el parche está basado en una confirmación pública--, entonces la opción '-3' suele ser mucho más avispada cuando incorporas un parche conflictivo:

	$ git am -3 0001-seeing-if-this-helps-the-gem.patch
	Applying: seeing if this helps the gem
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply
	Using index info to reconstruct a base tree...
	Falling back to patching base and 3-way merge...
	No changes -- Patch already applied.

En este caso, estamos intentando incorporar un parche que ya tenemos incorporado. Sin la opción '-3', tendríamos problemas.

Al aplicar varios parches desde un mbox, puedes lanzar el comando 'am' en modo interactivo; haciendo que se detenga en cada parche y preguntandote si aplicarlo o no:

	$ git am -3 -i mbox
	Commit Body is:
	--------------------------
	seeing if this helps the gem
	--------------------------
	Apply? [y]es/[n]o/[e]dit/[v]iew patch/[a]ccept all

Es una utilidad interesante si tienes tienes almacenados unos cuantos parches, porque puedes ir revisando previamente cada parche y aplicarlos selectivamente.

Cuando tengas integrados y confirmados todos los parches relativos al tema puntual en que estas trabajando, puedes plantearte cómo y cuándo lo vas a integar en alguna otra rama de más largo recorrido.

### Recuperando ramas remotas ###

Si recibes una contribución de un usuario que ha preparado su propio repositorio, ha guardado unos cuantos cambios en este, y luego te ha enviado la URL del repositorio y el nombre de la rama remota donde se encuentran los cambios. Puedes añadir dicho repositorio como un remoto y fusionar los cambios localmente.

Por ejemplo, si Jessica te envia un correo electrónico comentandote que tiene una nueva e interesante funcionalidad en la rama 'ruby-client' de su repositorio. Puedes probarla añadiendo el remoto correspondiente y recuperando localmente dicha rama.

	$ git remote add jessica git://github.com/jessica/myproject.git
	$ git fetch jessica
	$ git checkout -b rubyclient jessica/ruby-client

Si más tarde vuelva a enviarte otro correo electronico avisandote de otra gran funcionalidad que ha incorporado, puedes recuperarla (fetch y checkout) directamente, porque tienes el remoto ya definido.

Es muy util cuando trabajas regularmente con una persona. En cambio, si alguien tiene un solo parche para enviarte, una sola vez, puede ser más efectivo aceptarlo directamente por correo electronico; en lugar de pedir a todo el mundo que tenga cada uno su propio servidor y tener nosotros que estar continuamente añadiendo y quitando remotos para cada parche. También es muy posible que no quieras tener cientos de remotos, cada uno contribuyendo tan solo con un parche o dos. De todas formas, los scripts y los servicios albergados pueden hacerte la vida más facil en esto, --todo depende de cómo desarrolles tú y de como desarrollan las personas que colaboran contigo--.

Otra ventaja de esta forma de trabajar es que recibes también el histórico de confirmaciones de cambio (commits). A pesar de poder seguir teniendo los habituales problemas con la fusión, por lo menos conoces en qué punto de tu historial han basado su trabajo. Por defecto, se aplicará una genuina fusión a tres bandas, en lugar de tener que poner un '-3' y esperar que el parche haya sido generado a partir de una confirmación de cambios (commit) pública a la que tengas tú también acceso.

Si no trabajas habitualmente con una persona, pero deseas recuperar de ella por esta vía, puedes indicar directamente el URL del repositorio remoto en el comando 'git pull'. Esto efectua una recuperación (pull) puntual y no conserva la URL como una referencia remota:

	$ git pull git://github.com/onetimeguy/project.git
	From git://github.com/onetimeguy/project
	 * branch            HEAD       -> FETCH_HEAD
	Merge made by recursive.

### Revisando lo introducido ###

Ahora que tienes una rama puntual con trabajo aportado por otras personas. Tienes que decidir lo que deseas hacer con él. En esta sección revisaremos un par de comandos, que te ayudarán a ver exactamente los cambios que introducirás si fusionas dicha rama puntual con tu rama principal.

Suele ser util revisar todas las confirmaciones de cambios (commits) que esten es esta rama, pero no en tu rama principal. Puedes excluir de la lista las confirmaciones de tu rama principal añadiendo la opción '--not' delante del nombre de la rama. Por ejemplo, si la persona colaboradora te envia dos parches y tu creas una rama 'contrib' donde aplicar dichos parches; puedes lanzar algo como esto:

	$ git log contrib --not master
	commit 5b6235bd297351589efc4d73316f0a68d484f118
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Oct 24 09:53:59 2008 -0700

	    seeing if this helps the gem

	commit 7482e0d16d04bea79d0dba8988cc78df655f16a0
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Mon Oct 22 19:38:36 2008 -0700

	    updated the gemspec to hopefully work better

Para ver en detalle los cambios introducidos por cada confirmación (commit), recuerda que pasando la opción '-p' al comando 'git log', obtendrás un listado extendido con las diferencias introducidas por cada confirmación.

Para ver plenamente todas las diferencias y lo que sucederá realmente si fusionas esta rama puntual con otra rama, tendrás que utilizar un pequeño truco para obtener los resultados correctos. Puedes pensar en lanzar esto:

	$ git diff master

Este comando te dará las diferencias, pero puede ser engañoso. Si tu rama 'master' ha avanzado con respecto al momento en que se creó la rama puntual a partir de ella, puedes obtener resultados realmente extraños. Debido a que Git compara directamente las instantáneas de la última confirmación de cambios en la rama puntual donde te encuentras y en la rama 'master'. Por ejemplo, si en la rama 'master' habias añadido una línea a un archivo, la comparación directa de instantáneas te llevará a pensar que la rama puntual va a borrar dicha línea.

Si 'master' es un ancestro directo de tu rama puntual, no tendrás problemas. Pero si los historiales de las dos ramas son divergentes, la comparación directa de diferencias dará la apariencia de estar añadiendo todo el material nuevo en la rama puntual y de estar borrando todo el material nuevo en la rama 'master'.

Y lo que realmente querías ver eran los cambios introducidos por la rama puntual, --el trabajo que vas a introducir si la fusionas con la rama 'master'--. Lo puedes hacer indicando a Git que compare la última confirmación  de cambios en la rama puntual, con el más reciente ancestro común que tenga esta respecto de la rama 'master'.

Técnicamente, lo puedes hacer descubriendo tu mismo dicho ancestro común y lanzando la comprobación de diferencias respecto de él:

	$ git merge-base contrib master
	36c7dba2c95e6bbb78dfa822519ecfec6e1ca649
	$ git diff 36c7db

Pero esto no es lo más conveniente. De ahí que Git suministre otro atajo para hacerlo: la sintaxis del triple-punto. Estando en el contexto del comando 'diff', puedes indicar tres puntos entre los nombres de las dos ramas; para comparar entre la última confirmación de cambios de la rama donde estás y la respectiva confirmación común con la otra rama:

	$ git diff master...contrib

Este comando mostrará únicamente el trabajo en tu actual rama puntual que haya sido introducido a partir de su ancestro común con la rama 'master'. Es una sintaxis muy util, que merece recordar.

### Integrando el trabajo aportado por otros ###

Cuando todo el trabajo presente en tu rama puntual esté listo para ser integrado en una rama de mayor rango, la cuestión es cómo hacerlo. Yendo aún más lejos, ?cual es el sistema de trabajo que deseas utilizar para el mantenimiento de tu proyecto? Tienes bastantes opciones, y vamos a ver algunas de ellas.

#### Fusionando flujos de trabajo ####

Una forma simple de trabajar es fusionandolo todo en tu rama 'master'. En este escenario, tienes una rama 'master' que contiene, principalmente, código estable. Cuando en una rama puntual tienes trabajo ya terminado o contribuciones ya verificadas de terceros, los fusionas en tu rama 'master', borras la rama puntual, y continuas trabajando en otra/s rama/s.  Si, tal y como se muestra en la Figura 5-19,  tenemos un repositorio con trabajos en dos ramas, denominadas 'ruby client' y 'php client'; y fusionamos primero la rama 'ruby client' y luego la 'php client', obtendremos un historial similar al de la Figura 5-20.

Insert 18333fig0519.png
Figura 5-19. Historial con varias ramas puntuales.

Insert 18333fig0520.png
Figura 5-20. Tras fusionar una rama puntual.

Este es probablemente el flujo de trabajo más sencillo. Pero puede dar problemas cuando estás tratando con grandes repositorios o grandes proyectos.

Teniendo muchos desarrolladores o proyectos muy grandes, muy posiblemente desees utilizar un ciclo con por lo menos dos fases. En este escenario, se dispone de dos ramas de largo recorrido: 'master' y 'develop'. La primera de ellas, 'master', será actualizada únicamente por los lanzamientos de código muy estable. La segunda rama, 'develop', es donde iremos integrando todo el código nuevo.  Ambas ramas se enviarán periodicamente al repositorio público. Cada vez que tengas una nueva rama puntual lista para integrar (Figura 5-21), la fusionarás en la rama 'develop'. Y  cuando marques el lanzamiento de una versión estable, avanzarás la rama 'master' hasta el punto donde la rama 'develop' se encuentre en ese momento (Figura 5-23).

Insert 18333fig0521.png
Figura 5-21. Antes de fusionar una rama puntual.

Insert 18333fig0522.png
Figura 5-22. Tras fusionar una rama puntual.

Insert 18333fig0523.png
Figura 5-23. Tras un lanzamiento puntual.

De esta forma, cuando alguien clone el repositorio de tu proyecto, podrá recuperar (checkout) y mantener actualizadas tanto la última version estable como la versión con el material más avanzado; en las ramas 'master' y 'develop', respectivamente.
Puedes continuar ampliando este concepto, disponiendo de una rama 'integrate' donde ir fusionando todo el trabajo entre sí. A continuación, cuando el código en dicha rama sea estable y pase todas las pruebas, la fusionarás con la rama 'develop'; y, cuando se demuestre que permanece estable durante un cierto tiempo, avanzarás la rama 'master' hasta ahí.

#### Flujos de trabajo con grandes fusiones ####

El proyecto Git tiene cuatro ramas de largo recorrido: 'master', 'next', 'pu' (proposed updates) para el trabajo nuevo, y 'maint' (maintenance) para trabajos de mantenimiento de versiones previas. A medida que vamos introduciendo nuevos trabajos de las personas colaboradoras, estos se van recolectando en ramas puntuales en el repositorio de una persona gestora; de forma similar a como se ha ido describiendo (ver Figura 5-24). En un momento dado, las funcionalidades introducidas se evaluan; comprobando si son seguras y si están preparadas para los consumidores; o si, por el contrario, necesitan dedicarles más trabajo. Las funcionalidades que resultan ser seguras y estar preparadas se fusionan (merge) en la rama 'next'; y esta es enviada (push) al repositorio público, para que cualquiera pueda probarlas.

Insert 18333fig0524.png
Figura 5-24. Gestionando complejas series de ramas puntuales paralelas con funcionalidades varias.

Si las funcionalidades necesitan ser más trabajadas, se fusionan (merge) en la rama 'pu'. Y cuando las funcionalidades permanecen totalmente estables, se refusionan en la rama 'master'; componiendolas desde las funcionalidades en la rama 'next' aún sin   promocionar a 'master'.  Esto significa que 'master' prácticamente siempre avanza; 'next' se reorganiza (rebase) de vez en cuando; y 'pu' es reorganizada con más frecuencia (ver Figura 5-25).

Insert 18333fig0525.png
Figura 5-25. Fusionando aportaciones de ramas puntuales en ramas de más largo recorrido.

Una rama puntual se borra del repositorio cuando, finalmente, es fusionada en la rama 'master'. El proyecto Git dispone también de una rama 'maint' que se bifurca (fork) a partir de la última versión ya lanzada; para trabajar en parches, en caso de necesitarse alguna versión intermedia de mantenimiento. Así, cuando clonas el repositorio de Git, obtienes cuatro ramas que puedes recuperar (checkout); pudiendo evaluar el proyecto en distintos estadios de desarrollo, dependiendo de cuán avanzado desees estar o cómo desees contribuir. Y así, los gestores de mantenimiento disponen de un flujo de trabajo estructurado, para ayudarles en el procesado e incorporación de nuevas contribuciones.

#### Flujos de trabajo reorganizando o entresacando ####

Otros gestores de mantenimiento,  al procesar el trabajo recibido de las personas colaboradoras, en lugar de fusiones (merge), suelen preferir reorganizar (rebase) o entresacar (cherry-pick) sobre su propia rama principal; obteniendo así un historial prácticamente lineal. Cuando desees integrar el trabajo que tienes en una rama puntual, te puedes situar sobre ella y lanzar el comando 'rebase'; de esta forma recompondrás los cambios encima de tu actual rama 'master' (o 'develop' o lo que corresponda). Si funciona, se realizará un avance rápido (fast-forward) en tu rama 'master', y acabarás teniendo un historial lineal en tu proyecto.

El otro camino para introducir trabajo de una rama en otra, es entresacarlo. Entresacar (cherry-pick) en Git es como reorganizar (rebase) una sola confirmación de cambios (commit). Se trata de coger el parche introducido por una determinada confirmación de cambios e intentar reaplicarlo sobre la rama donde te encuentres en ese momento. Puede ser util si tienes varias confirmaciones de cambios en una rama puntual, y tan solo deseas integar una de ellas; o si tienes una única confirmación de cambios en una rama puntual, y prefieres entresacarla en lugar de reorganizar. Por ejemplo, suponiendo que tienes un proyecto parecido al ilustrado en la Figura 5-26.

Insert 18333fig0526.png
Figura 5-26. Historial de ejemplo, antes de entresacar.

Si deseas integar únicamente la confirmación 'e43a6' en tu rama 'master', puedes lanzar:

	$ git cherry-pick e43a6fd3e94888d76779ad79fb568ed180e5fcdf
	Finished one cherry-pick.
	[master]: created a0a41a9: "More friendly message when locking the index fails."
	 3 files changed, 17 insertions(+), 3 deletions(-)

Esto introduce exactamente el mismo cambio introducido por 'e43a6', pero con un nuevo valor SHA-1 de confirmación; ya que es diferente la fecha en que ha sido aplicado. Tu historial quedará tal como ilustra la Figura 5-27.

Insert 18333fig0527.png
Figura 5-27. Historial tras entresacar una confirmación de cambios de una rama puntual.

Ahora, ya puedes borrar la rama puntual y descartar las confirmaciones de cambios que no deseas integrar.

### Marcando tus lanzamientos de versiones ###

Cuando decides dar por preparada una versión, probablemente querrás etiquetar dicho punto de algún modo; de tal forma que, más adelante, puedas volver a generar esa versión en cualquier momento. Puedes crear una nueva etiqueta tal y como se ha comentado en el capítulo 2. Si decides firmar la etiqueta como gestor de mantenimientos que eres, el proceso será algo como:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gmail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

Si firmas tus etiquetas, puedes tener un problema a la hora de distribuir la clave PGP pública utilizada en la firma. Los gestores del proyeto Git ha resuelto este problema incluyendo sus claves públicas como un objeto en el repositorio, añadiendo luego una etiqueta apuntando directamente a dicho contenido. Para ello, has de seleccionar cada clave que deseas incluir, lanzando el comando 'gpg ---list-keys':

	$ gpg --list-keys
	/Users/schacon/.gnupg/pubring.gpg
	---------------------------------
	pub   1024D/F721C45A 2009-02-09 [expires: 2010-02-09]
	uid                  Scott Chacon <schacon@gmail.com>
	sub   2048g/45D02282 2009-02-09 [expires: 2010-02-09]

Tras esto, puedes importar directamente la clave en la base de datos Git, exportandola y redirigiendola a través del comando 'git hash-object'. Para, de esta forma, escribir un nuevo objeto dentro de Git y obtener de vuelta la firma SHA-1 de dicho objeto.

	$ gpg -a --export F721C45A | git hash-object -w --stdin
	659ef797d181633c87ec71ac3f9ba29fe5775b92

Una vez tengas el contenido de tu clave guardado en Git, puedes crear una etiquta que apunte directamente al mismo; indicando para ello el nuevo valor SHA-1 que te ha devuelto el objeto 'hash-object':

	$ git tag -a maintainer-pgp-pub 659ef797d181633c87ec71ac3f9ba29fe5775b92

Si lanzas el comando 'git push --tags', la etiqueta 'maintainer-pgp-pub' será compartida por todos. Cualquiera que desee verificar la autenticidad de una etiqueta, no tiene más que importar tu clave PGP, sacando el objecto directamente de la base de datos e importandolo en GPG:,

	$ git show maintainer-pgp-pub | gpg --import

De esta forma, pueden utilizar esa clave para verificar todas las etiquetas que firmes. Además, si incluyes instrucciones en el mensaje de etiquetado, con el comando `git show <tag>`, los usuarios podrán tener directrices específicas acerca de la verificación de etiquetas.

### Generando un número de ensamblado ###

Debido a que Git no dispone de una serie monótona ascendente de números para cada confirmación de cambios (commit), si deseas tener un nombre humanamente comprensible por cada confirmación, has de utilizar el comando 'git describe'. Git te dará el nombre de la etiqueta más cercana, mas el número de confirmaciones de cambios entre dicha etiqueta y la confirmación que estas describiendo, más una parte de la firma SHA-1 de la confirmación:

	$ git describe master
	v1.6.2-rc1-20-g8c5b85c

De esta forma, puedes exportar una instantánea u obtener un nombre comprensible por cualquier persona. Es más, si compilas Git desde código fuente clonado desde el repositorio Git, el comando 'git --version' te dará algo parecido. Si solicitas descripción de una confirmación de cambios (commit) etiquetada directamente con su propia etiqueta particular, obtendrás dicha etiqueta como descripción.

El comando 'git describe' da preferencia a las etiquetas anotativas (etiquetas creadas  con las opciones '-a' o '-s'). De esta forma las etiquetas para las versiones pueden ser creadas  usando 'git describe', asegurandose el que las confirmaciones de cambios (commit) son adecuadamente nombradas cuando se describen. Tambien puedes utilizar esta descripción para indicar lo que deseas activar (checkout) o mostrar (show); pero realmente estarás usando solamente la parte final de la firma SHA-1 abreviada, por lo que no siempre será válida. Por ejemplo, el kernel de Linux ha saltado recientemente de 8 a 10 caracteres, para asegurar la unicidad de los objetos SHA-1; dando como resultado que los nombres antiguos de 'git describe' han dejado de ser válidos.

### Preparando un lanzamiento de versión ###

Si quieres lanzar una nueva versión. Una de las cosas que desearas crear es un archivo con la más reciente imagen de tu código, para aquellas pobres almas que no utilizan Git. El comando para hacerlo es 'git archive':

	$ git archive master --prefix='project/' | gzip > `git describe master`.tar.gz
	$ ls *.tar.gz
	v1.6.2-rc1-20-g8c5b85c.tar.gz

Quien abra ese archivo tarball, obtendrá la más reciente imagen de tu proyecto; puesta bajo una carpeta de proyecto. También puedes crear un archivo zip de la misma manera, tan solo indicando la opción '--format=zip' al comando 'git archive':

	$ git archive master --prefix='project/' --format=zip > `git describe master`.zip

Así, tendrás sendos archivos tarball y zip con tu nueva versión, listos para subirlos a tu sitio web o para ser enviados por correo electrónico a tus usuarios.

### El registro rápido ###

Ya va siendo hora de enviar un mensaje a tu lista de correo, informando a las personas que desean conocer la marcha de tu proyecto. Una manera elegante de generar rápidamente una lista con los principales cambios añadidos a tu proyecto desde la anterior versión, es utilizando el comando 'git shortlog'. Este comando resume todas las confirmaciones de cambios (commits) en el rango que le indiques. Por ejemplo, si tu último lanzamiento de versión lo fué de la v1.0.1:

	$ git shortlog --no-merges master --not v1.0.1
	Chris Wanstrath (8):
	      Add support for annotated tags to Grit::Tag
	      Add packed-refs annotated tag support.
	      Add Grit::Commit#to_patch
	      Update version and History.txt
	      Remove stray `puts`
	      Make ls_tree ignore nils

	Tom Preston-Werner (4):
	      fix dates in history
	      dynamic version method
	      Version bump to 1.0.2
	      Regenerated gemspec for version 1.0.2

Obtendrás un claro resumen de todas las confirmaciones de cambios (commit) desde la versión v1.0.1, agrupadas por autor, y listas para ser incorporadas en un mensaje a tu lista de correo.

## Recapitulación ##

A estas alturas, deberías sentirte confortable tanto contribuyendo a un proyecto, como manteniendo tu propio proyecto o integrando contribuciones de otras personas. Felicidades por haber llegado a ser un desarrollador Git efectivo!. En el capítulo siguiente, aprenderás el uso de más herramientas avanzadas y algunos trucos para tratar con situaciones complejas; haciendo de tí un verdadero maestro Git.
