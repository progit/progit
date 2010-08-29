# Git en entornos distribuidos #

Ahora que ya tienes un repositorio Git, configurado como punto de trabajo para compartir código entre desarrolladores. Y ahora que ya conoces los comandos básicos de Git para flujos de trabajo locales. Puedes hechar un vistazo a algunos de los flujos de trabajo distribuidos que Git permite.

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

1.	La persona gestora del proyecto envia (push) a su repositorio público (repositorio principal).
2.	Una persona que desea contribuir, clona dicho repositorio y hace algunos cambios.
3.	La persona colaboradora envia (push) a su propia copia pública.
4.	Esta persona colaboradora envia a la gestora un correo-e solicitándole recupere e integre los cambios.
5.	La gestora añade como remoto el repositorio de la colaboradora y fusiona (merge) los cambios localmente.
6.	La gestora envia (push) los cambios fusionados al repositorio principal.

Insert 18333fig0502.png 
Figura 5-2. Flujo de trabajo Gestor-de-Integración.

Esta es una forma de trabajo muy común en sitios tales como GitHub, donde es sencillo bifurcar (fork) un proyecto y enviar tus cambios a tu copia, donde cualquiera puede verlos. La principal ventaja de esta forma de trabajar es que puedes continuar trabajando, y la persona gestora del repositorio principal podrá recuperar (pull) tus cambios en cualquier momento. Las personas colaboradoras no tienen por qué esperar a que sus cambios sean incorporados al proyecto, --cada cual puede trabajar a su propio ritmo--.

### Flujo de trabajo con Dictador y Tenientes ###

Es una variante del flujo de trabajo con multiples repositorios. Se utiliza generalmente en proyectos muy grandes, con cientos de colaboradores. Un ejemplo muy conocido es el del kernel de Linux. Unos gestores de integración se encargan de partes concretas del repositorio; y se denominan tenientes. Todos los tenientes rinden cuentas a un gestor de integración; conocido como el dictador benevolente. El repositorio del dictador benevolente es el repositorio de referencia, del que recuperan (pull) todos los colaboradores. El proceso funciona como sigue (ver Figura 5-3):

1.	Los desarrolladores habituales trabajan cada uno en su rama puntual y reorganizan (rebase) su trabajo sobre la rama master. La rama master es la del dictador benevolente.
2.	Los tenienentes fusionan (merge) las ramas puntuales de los desarrolladores sobre su propia rama master.
3.	El dictador fusiona las ramas master de los tenientes en su propia rama master.
4.	El dictador envia (push) su rama master al repositorio de referencia, para permitir que los desarrolladores reorganicen (rebase) desde ella.

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

Cuando está preparada para enviar (push) su trabajo, recibe un correo-e de Josie de que ha puesto en el servidor una rama denominada 'featureBee', con algo de trabajo. Jessica necesita fusionar (merge) dichos cambios con los suyos antes de poder enviarlos al servidor. Por tanto, recupera (fetch) los cambios de Josie: 

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

A continuación, John envia un correo-e a jessica comentandole que ha enviado algunos cambios a la rama 'featureA' y pidiendole que los verifique. Ella lanza un 'git fetch' para recuperar dichos cambios:

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

### Public Large Project ###

Many larger projects have established procedures for accepting patches — you’ll need to check the specific rules for each project, because they will differ. However, many larger public projects accept patches via a developer mailing list, so I’ll go over an example of that now.

The workflow is similar to the previous use case — you create topic branches for each patch series you work on. The difference is how you submit them to the project. Instead of forking the project and pushing to your own writable version, you generate e-mail versions of each commit series and e-mail them to the developer mailing list:

	$ git checkout -b topicA
	$ (work)
	$ git commit
	$ (work)
	$ git commit

Now you have two commits that you want to send to the mailing list. You use `git format-patch` to generate the mbox-formatted files that you can e-mail to the list — it turns each commit into an e-mail message with the first line of the commit message as the subject and the rest of the message plus the patch that the commit introduces as the body. The nice thing about this is that applying a patch from an e-mail generated with `format-patch` preserves all the commit information properly, as you’ll see more of in the next section when you apply these commits:

	$ git format-patch -M origin/master
	0001-add-limit-to-log-function.patch
	0002-changed-log-output-to-30-from-25.patch

The `format-patch` command prints out the names of the patch files it creates. The `-M` switch tells Git to look for renames. The files end up looking like this:

	$ cat 0001-add-limit-to-log-function.patch 
	From 330090432754092d704da8e76ca5c05c198e71a8 Mon Sep 17 00:00:00 2001
	From: Jessica Smith <jessica@example.com>
	Date: Sun, 6 Apr 2008 10:17:23 -0700
	Subject: [PATCH 1/2] add limit to log function

	Limit log functionality to the first 20

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

You can also edit these patch files to add more information for the e-mail list that you don’t want to show up in the commit message. If you add text between the `--` line and the beginning of the patch (the `lib/simplegit.rb` line), then developers can read it; but applying the patch excludes it.

To e-mail this to a mailing list, you can either paste the file into your e-mail program or send it via a command-line program. Pasting the text often causes formatting issues, especially with "smarter" clients that don’t preserve newlines and other whitespace appropriately. Luckily, Git provides a tool to help you send properly formatted patches via IMAP, which may be easier for you. I’ll demonstrate how to send a patch via Gmail, which happens to be the e-mail agent I use; you can read detailed instructions for a number of mail programs at the end of the aforementioned `Documentation/SubmittingPatches` file in the Git source code.

First, you need to set up the imap section in your `~/.gitconfig` file. You can set each value separately with a series of `git config` commands, or you can add them manually; but in the end, your config file should look something like this:

	[imap]
	  folder = "[Gmail]/Drafts"
	  host = imaps://imap.gmail.com
	  user = user@gmail.com
	  pass = p4ssw0rd
	  port = 993
	  sslverify = false

If your IMAP server doesn’t use SSL, the last two lines probably aren’t necessary, and the host value will be `imap://` instead of `imaps://`.
When that is set up, you can use `git send-email` to place the patch series in the Drafts folder of the specified IMAP server:

	$ git send-email *.patch
	0001-added-limit-to-log-function.patch
	0002-changed-log-output-to-30-from-25.patch
	Who should the emails appear to be from? [Jessica Smith <jessica@example.com>] 
	Emails will be sent from: Jessica Smith <jessica@example.com>
	Who should the emails be sent to? jessica@example.com
	Message-ID to be used as In-Reply-To for the first email? y

Then, Git spits out a bunch of log information looking something like this for each patch you’re sending:

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

At this point, you should be able to go to your Drafts folder, change the To field to the mailing list you’re sending the patch to, possibly CC the maintainer or person responsible for that section, and send it off.

### Summary ###

This section has covered a number of common workflows for dealing with several very different types of Git projects you’re likely to encounter and introduced a couple of new tools to help you manage this process. Next, you’ll see how to work the other side of the coin: maintaining a Git project. You’ll learn how to be a benevolent dictator or integration manager.

## Maintaining a Project ##

In addition to knowing how to effectively contribute to a project, you’ll likely need to know how to maintain one. This can consist of accepting and applying patches generated via `format-patch` and e-mailed to you, or integrating changes in remote branches for repositories you’ve added as remotes to your project. Whether you maintain a canonical repository or want to help by verifying or approving patches, you need to know how to accept work in a way that is clearest for other contributors and sustainable by you over the long run.

### Working in Topic Branches ###

When you’re thinking of integrating new work, it’s generally a good idea to try it out in a topic branch — a temporary branch specifically made to try out that new work. This way, it’s easy to tweak a patch individually and leave it if it’s not working until you have time to come back to it. If you create a simple branch name based on the theme of the work you’re going to try, such as `ruby_client` or something similarly descriptive, you can easily remember it if you have to abandon it for a while and come back later. The maintainer of the Git project tends to namespace these branches as well — such as `sc/ruby_client`, where `sc` is short for the person who contributed the work. 
As you’ll remember, you can create the branch based off your master branch like this:

	$ git branch sc/ruby_client master

Or, if you want to also switch to it immediately, you can use the `checkout -b` option:

	$ git checkout -b sc/ruby_client master

Now you’re ready to add your contributed work into this topic branch and determine if you want to merge it into your longer-term branches.

### Applying Patches from E-mail ###

If you receive a patch over e-mail that you need to integrate into your project, you need to apply the patch in your topic branch to evaluate it. There are two ways to apply an e-mailed patch: with `git apply` or with `git am`.

#### Applying a Patch with apply ####

If you received the patch from someone who generated it with the `git diff` or a Unix `diff` command, you can apply it with the `git apply` command. Assuming you saved the patch at `/tmp/patch-ruby-client.patch`, you can apply the patch like this:

	$ git apply /tmp/patch-ruby-client.patch

This modifies the files in your working directory. It’s almost identical to running a `patch -p1` command to apply the patch, although it’s more paranoid and accepts fewer fuzzy matches then patch. It also handles file adds, deletes, and renames if they’re described in the `git diff` format, which `patch` won’t do. Finally, `git apply` is an "apply all or abort all" model where either everything is applied or nothing is, whereas `patch` can partially apply patchfiles, leaving your working directory in a weird state. `git apply` is overall much more paranoid than `patch`. It won’t create a commit for you — after running it, you must stage and commit the changes introduced manually.

You can also use git apply to see if a patch applies cleanly before you try actually applying it — you can run `git apply --check` with the patch:

	$ git apply --check 0001-seeing-if-this-helps-the-gem.patch 
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply

If there is no output, then the patch should apply cleanly. This command also exits with a non-zero status if the check fails, so you can use it in scripts if you want.

#### Applying a Patch with am ####

If the contributor is a Git user and was good enough to use the `format-patch` command to generate their patch, then your job is easier because the patch contains author information and a commit message for you. If you can, encourage your contributors to use `format-patch` instead of `diff` to generate patches for you. You should only have to use `git apply` for legacy patches and things like that.

To apply a patch generated by `format-patch`, you use `git am`. Technically, `git am` is built to read an mbox file, which is a simple, plain-text format for storing one or more e-mail messages in one text file. It looks something like this:

	From 330090432754092d704da8e76ca5c05c198e71a8 Mon Sep 17 00:00:00 2001
	From: Jessica Smith <jessica@example.com>
	Date: Sun, 6 Apr 2008 10:17:23 -0700
	Subject: [PATCH 1/2] add limit to log function

	Limit log functionality to the first 20

This is the beginning of the output of the format-patch command that you saw in the previous section. This is also a valid mbox e-mail format. If someone has e-mailed you the patch properly using git send-email, and you download that into an mbox format, then you can point git am to that mbox file, and it will start applying all the patches it sees. If you run a mail client that can save several e-mails out in mbox format, you can save entire patch series into a file and then use git am to apply them one at a time. 

However, if someone uploaded a patch file generated via `format-patch` to a ticketing system or something similar, you can save the file locally and then pass that file saved on your disk to `git am` to apply it:

	$ git am 0001-limit-log-function.patch 
	Applying: add limit to log function

You can see that it applied cleanly and automatically created the new commit for you. The author information is taken from the e-mail’s `From` and `Date` headers, and the message of the commit is taken from the `Subject` and body (before the patch) of the e-mail. For example, if this patch was applied from the mbox example I just showed, the commit generated would look something like this:

	$ git log --pretty=fuller -1
	commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Author:     Jessica Smith <jessica@example.com>
	AuthorDate: Sun Apr 6 10:17:23 2008 -0700
	Commit:     Scott Chacon <schacon@gmail.com>
	CommitDate: Thu Apr 9 09:19:06 2009 -0700

	   add limit to log function

	   Limit log functionality to the first 20

The `Commit` information indicates the person who applied the patch and the time it was applied. The `Author` information is the individual who originally created the patch and when it was originally created. 

But it’s possible that the patch won’t apply cleanly. Perhaps your main branch has diverged too far from the branch the patch was built from, or the patch depends on another patch you haven’t applied yet. In that case, the `git am` process will fail and ask you what you want to do:

	$ git am 0001-seeing-if-this-helps-the-gem.patch 
	Applying: seeing if this helps the gem
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply
	Patch failed at 0001.
	When you have resolved this problem run "git am --resolved".
	If you would prefer to skip this patch, instead run "git am --skip".
	To restore the original branch and stop patching run "git am --abort".

This command puts conflict markers in any files it has issues with, much like a conflicted merge or rebase operation. You solve this issue much the same way — edit the file to resolve the conflict, stage the new file, and then run `git am --resolved` to continue to the next patch:

	$ (fix the file)
	$ git add ticgit.gemspec 
	$ git am --resolved
	Applying: seeing if this helps the gem

If you want Git to try a bit more intelligently to resolve the conflict, you can pass a `-3` option to it, which makes Git attempt a three-way merge. This option isn’t on by default because it doesn’t work if the commit the patch says it was based on isn’t in your repository. If you do have that commit — if the patch was based on a public commit — then the `-3` option is generally much smarter about applying a conflicting patch:

	$ git am -3 0001-seeing-if-this-helps-the-gem.patch 
	Applying: seeing if this helps the gem
	error: patch failed: ticgit.gemspec:1
	error: ticgit.gemspec: patch does not apply
	Using index info to reconstruct a base tree...
	Falling back to patching base and 3-way merge...
	No changes -- Patch already applied.

In this case, I was trying to apply a patch I had already applied. Without the `-3` option, it looks like a conflict.

If you’re applying a number of patches from an mbox, you can also run the `am` command in interactive mode, which stops at each patch it finds and asks if you want to apply it:

	$ git am -3 -i mbox
	Commit Body is:
	--------------------------
	seeing if this helps the gem
	--------------------------
	Apply? [y]es/[n]o/[e]dit/[v]iew patch/[a]ccept all 

This is nice if you have a number of patches saved, because you can view the patch first if you don’t remember what it is, or not apply the patch if you’ve already done so.

When all the patches for your topic are applied and committed into your branch, you can choose whether and how to integrate them into a longer-running branch.

### Checking Out Remote Branches ###

If your contribution came from a Git user who set up their own repository, pushed a number of changes into it, and then sent you the URL to the repository and the name of the remote branch the changes are in, you can add them as a remote and do merges locally.

For instance, if Jessica sends you an e-mail saying that she has a great new feature in the `ruby-client` branch of her repository, you can test it by adding the remote and checking out that branch locally:

	$ git remote add jessica git://github.com/jessica/myproject.git
	$ git fetch jessica
	$ git checkout -b rubyclient jessica/ruby-client

If she e-mails you again later with another branch containing another great feature, you can fetch and check out because you already have the remote setup.

This is most useful if you’re working with a person consistently. If someone only has a single patch to contribute once in a while, then accepting it over e-mail may be less time consuming than requiring everyone to run their own server and having to continually add and remove remotes to get a few patches. You’re also unlikely to want to have hundreds of remotes, each for someone who contributes only a patch or two. However, scripts and hosted services may make this easier — it depends largely on how you develop and how your contributors develop.

The other advantage of this approach is that you get the history of the commits as well. Although you may have legitimate merge issues, you know where in your history their work is based; a proper three-way merge is the default rather than having to supply a `-3` and hope the patch was generated off a public commit to which you have access.

If you aren’t working with a person consistently but still want to pull from them in this way, you can provide the URL of the remote repository to the `git pull` command. This does a one-time pull and doesn’t save the URL as a remote reference:

	$ git pull git://github.com/onetimeguy/project.git
	From git://github.com/onetimeguy/project
	 * branch            HEAD       -> FETCH_HEAD
	Merge made by recursive.

### Determining What Is Introduced ###

Now you have a topic branch that contains contributed work. At this point, you can determine what you’d like to do with it. This section revisits a couple of commands so you can see how you can use them to review exactly what you’ll be introducing if you merge this into your main branch.

It’s often helpful to get a review of all the commits that are in this branch but that aren’t in your master branch. You can exclude commits in the master branch by adding the `--not` option before the branch name. For example, if your contributor sends you two patches and you create a branch called `contrib` and applied those patches there, you can run this:

	$ git log contrib --not master
	commit 5b6235bd297351589efc4d73316f0a68d484f118
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Fri Oct 24 09:53:59 2008 -0700

	    seeing if this helps the gem

	commit 7482e0d16d04bea79d0dba8988cc78df655f16a0
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Mon Oct 22 19:38:36 2008 -0700

	    updated the gemspec to hopefully work better

To see what changes each commit introduces, remember that you can pass the `-p` option to `git log` and it will append the diff introduced to each commit.

To see a full diff of what would happen if you were to merge this topic branch with another branch, you may have to use a weird trick to get the correct results. You may think to run this:

	$ git diff master

This command gives you a diff, but it may be misleading. If your `master` branch has moved forward since you created the topic branch from it, then you’ll get seemingly strange results. This happens because Git directly compares the snapshots of the last commit of the topic branch you’re on and the snapshot of the last commit on the `master` branch. For example, if you’ve added a line in a file on the `master` branch, a direct comparison of the snapshots will look like the topic branch is going to remove that line.

If `master` is a direct ancestor of your topic branch, this isn’t a problem; but if the two histories have diverged, the diff will look like you’re adding all the new stuff in your topic branch and removing everything unique to the `master` branch.

What you really want to see are the changes added to the topic branch — the work you’ll introduce if you merge this branch with master. You do that by having Git compare the last commit on your topic branch with the first common ancestor it has with the master branch.

Technically, you can do that by explicitly figuring out the common ancestor and then running your diff on it:

	$ git merge-base contrib master
	36c7dba2c95e6bbb78dfa822519ecfec6e1ca649
	$ git diff 36c7db 

However, that isn’t convenient, so Git provides another shorthand for doing the same thing: the triple-dot syntax. In the context of the `diff` command, you can put three periods after another branch to do a `diff` between the last commit of the branch you’re on and its common ancestor with another branch:

	$ git diff master...contrib

This command shows you only the work your current topic branch has introduced since its common ancestor with master. That is a very useful syntax to remember.

### Integrating Contributed Work ###

When all the work in your topic branch is ready to be integrated into a more mainline branch, the question is how to do it. Furthermore, what overall workflow do you want to use to maintain your project? You have a number of choices, so I’ll cover a few of them.

#### Merging Workflows ####

One simple workflow merges your work into your `master` branch. In this scenario, you have a `master` branch that contains basically stable code. When you have work in a topic branch that you’ve done or that someone has contributed and you’ve verified, you merge it into your master branch, delete the topic branch, and then continue the process.  If we have a repository with work in two branches named `ruby_client` and `php_client` that looks like Figure 5-19 and merge `ruby_client` first and then `php_client` next, then your history will end up looking like Figure 5-20.

Insert 18333fig0519.png 
Figure 5-19. History with several topic branches.

Insert 18333fig0520.png
Figure 5-20. After a topic branch merge.

That is probably the simplest workflow, but it’s problematic if you’re dealing with larger repositories or projects.

If you have more developers or a larger project, you’ll probably want to use at least a two-phase merge cycle. In this scenario, you have two long-running branches, `master` and `develop`, in which you determine that `master` is updated only when a very stable release is cut and all new code is integrated into the `develop` branch. You regularly push both of these branches to the public repository. Each time you have a new topic branch to merge in (Figure 5-21), you merge it into `develop` (Figure 5-22); then, when you tag a release, you fast-forward `master` to wherever the now-stable `develop` branch is (Figure 5-23).

Insert 18333fig0521.png 
Figure 5-21. Before a topic branch merge.

Insert 18333fig0522.png 
Figure 5-22. After a topic branch merge.

Insert 18333fig0523.png 
Figure 5-23. After a topic branch release.

This way, when people clone your project’s repository, they can either check out master to build the latest stable version and keep up to date on that easily, or they can check out develop, which is the more cutting-edge stuff.
You can also continue this concept, having an integrate branch where all the work is merged together. Then, when the codebase on that branch is stable and passes tests, you merge it into a develop branch; and when that has proven itself stable for a while, you fast-forward your master branch.

#### Large-Merging Workflows ####

The Git project has four long-running branches: `master`, `next`, and `pu` (proposed updates) for new work, and `maint` for maintenance backports. When new work is introduced by contributors, it’s collected into topic branches in the maintainer’s repository in a manner similar to what I’ve described (see Figure 5-24). At this point, the topics are evaluated to determine whether they’re safe and ready for consumption or whether they need more work. If they’re safe, they’re merged into `next`, and that branch is pushed up so everyone can try the topics integrated together.

Insert 18333fig0524.png 
Figure 5-24. Managing a complex series of parallel contributed topic branches.

If the topics still need work, they’re merged into `pu` instead. When it’s determined that they’re totally stable, the topics are re-merged into `master` and are then rebuilt from the topics that were in `next` but didn’t yet graduate to `master`. This means `master` almost always moves forward, `next` is rebased occasionally, and `pu` is rebased even more often (see Figure 5-25).

Insert 18333fig0525.png 
Figure 5-25. Merging contributed topic branches into long-term integration branches.

When a topic branch has finally been merged into `master`, it’s removed from the repository. The Git project also has a `maint` branch that is forked off from the last release to provide backported patches in case a maintenance release is required. Thus, when you clone the Git repository, you have four branches that you can check out to evaluate the project in different stages of development, depending on how cutting edge you want to be or how you want to contribute; and the maintainer has a structured workflow to help them vet new contributions.

#### Rebasing and Cherry Picking Workflows ####

Other maintainers prefer to rebase or cherry-pick contributed work on top of their master branch, rather than merging it in, to keep a mostly linear history. When you have work in a topic branch and have determined that you want to integrate it, you move to that branch and run the rebase command to rebuild the changes on top of your current master (or `develop`, and so on) branch. If that works well, you can fast-forward your `master` branch, and you’ll end up with a linear project history.

The other way to move introduced work from one branch to another is to cherry-pick it. A cherry-pick in Git is like a rebase for a single commit. It takes the patch that was introduced in a commit and tries to reapply it on the branch you’re currently on. This is useful if you have a number of commits on a topic branch and you want to integrate only one of them, or if you only have one commit on a topic branch and you’d prefer to cherry-pick it rather than run rebase. For example, suppose you have a project that looks like Figure 5-26.

Insert 18333fig0526.png 
Figure 5-26. Example history before a cherry pick.

If you want to pull commit `e43a6` into your master branch, you can run

	$ git cherry-pick e43a6fd3e94888d76779ad79fb568ed180e5fcdf
	Finished one cherry-pick.
	[master]: created a0a41a9: "More friendly message when locking the index fails."
	 3 files changed, 17 insertions(+), 3 deletions(-)

This pulls the same change introduced in `e43a6`, but you get a new commit SHA-1 value, because the date applied is different. Now your history looks like Figure 5-27.

Insert 18333fig0527.png 
Figure 5-27. History after cherry-picking a commit on a topic branch.

Now you can remove your topic branch and drop the commits you didn’t want to pull in.

### Tagging Your Releases ###

When you’ve decided to cut a release, you’ll probably want to drop a tag so you can re-create that release at any point going forward. You can create a new tag as I discussed in Chapter 2. If you decide to sign the tag as the maintainer, the tagging may look something like this:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gmail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

If you do sign your tags, you may have the problem of distributing the public PGP key used to sign your tags. The maintainer of the Git project has solved this issue by including their public key as a blob in the repository and then adding a tag that points directly to that content. To do this, you can figure out which key you want by running `gpg --list-keys`:

	$ gpg --list-keys
	/Users/schacon/.gnupg/pubring.gpg
	---------------------------------
	pub   1024D/F721C45A 2009-02-09 [expires: 2010-02-09]
	uid                  Scott Chacon <schacon@gmail.com>
	sub   2048g/45D02282 2009-02-09 [expires: 2010-02-09]

Then, you can directly import the key into the Git database by exporting it and piping that through `git hash-object`, which writes a new blob with those contents into Git and gives you back the SHA-1 of the blob:

	$ gpg -a --export F721C45A | git hash-object -w --stdin
	659ef797d181633c87ec71ac3f9ba29fe5775b92

Now that you have the contents of your key in Git, you can create a tag that points directly to it by specifying the new SHA-1 value that the `hash-object` command gave you:

	$ git tag -a maintainer-pgp-pub 659ef797d181633c87ec71ac3f9ba29fe5775b92

If you run `git push --tags`, the `maintainer-pgp-pub` tag will be shared with everyone. If anyone wants to verify a tag, they can directly import your PGP key by pulling the blob directly out of the database and importing it into GPG:

	$ git show maintainer-pgp-pub | gpg --import

They can use that key to verify all your signed tags. Also, if you include instructions in the tag message, running `git show <tag>` will let you give the end user more specific instructions about tag verification.

### Generating a Build Number ###

Because Git doesn’t have monotonically increasing numbers like 'v123' or the equivalent to go with each commit, if you want to have a human-readable name to go with a commit, you can run `git describe` on that commit. Git gives you the name of the nearest tag with the number of commits on top of that tag and a partial SHA-1 value of the commit you’re describing:

	$ git describe master
	v1.6.2-rc1-20-g8c5b85c

This way, you can export a snapshot or build and name it something understandable to people. In fact, if you build Git from source code cloned from the Git repository, `git --version` gives you something that looks like this. If you’re describing a commit that you have directly tagged, it gives you the tag name.

The `git describe` command favors annotated tags (tags created with the `-a` or `-s` flag), so release tags should be created this way if you’re using `git describe`, to ensure the commit is named properly when described. You can also use this string as the target of a checkout or show command, although it relies on the abbreviated SHA-1 value at the end, so it may not be valid forever. For instance, the Linux kernel recently jumped from 8 to 10 characters to ensure SHA-1 object uniqueness, so older `git describe` output names were invalidated.

### Preparing a Release ###

Now you want to release a build. One of the things you’ll want to do is create an archive of the latest snapshot of your code for those poor souls who don’t use Git. The command to do this is `git archive`:

	$ git archive master --prefix='project/' | gzip > `git describe master`.tar.gz
	$ ls *.tar.gz
	v1.6.2-rc1-20-g8c5b85c.tar.gz

If someone opens that tarball, they get the latest snapshot of your project under a project directory. You can also create a zip archive in much the same way, but by passing the `--format=zip` option to `git archive`:

	$ git archive master --prefix='project/' --format=zip > `git describe master`.zip

You now have a nice tarball and a zip archive of your project release that you can upload to your website or e-mail to people.

### The Shortlog ###

It’s time to e-mail your mailing list of people who want to know what’s happening in your project. A nice way of quickly getting a sort of changelog of what has been added to your project since your last release or e-mail is to use the `git shortlog` command. It summarizes all the commits in the range you give it; for example, the following gives you a summary of all the commits since your last release, if your last release was named v1.0.1:

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

You get a clean summary of all the commits since v1.0.1, grouped by author, that you can e-mail to your list.

## Recapitulación ##

You should feel fairly comfortable contributing to a project in Git as well as maintaining your own project or integrating other users’ contributions. Congratulations on being an effective Git developer! In the next chapter, you’ll learn more powerful tools and tips for dealing with complex situations, which will truly make you a Git master.
