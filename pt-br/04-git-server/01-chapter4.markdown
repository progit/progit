# Git no Servidor #

Neste ponto, você deve estar apto a fazer a maior parte das tarefas do dia a dia para as quais estará usando o Git. No entanto, para qualquer colaboração no Git, você precisará ter um repositório remoto de Git. Apesar de que você pode tecnicamente enviar (push) mudanças para e receber (pull) mudanças de repositorios de indivíduos, isto é desencorajado pois você pode facilmente confundir no que eles estão trabalhando se não for cuidadoso. Além disso, você quer que seus colaboradores possam acessar o repositório mesmo quando seu computador estiver offline — ter um repositório comum mais confiável é muitas vezes útil. Portanto, o método preferido para colaborar com alguém é configurar um repositório intermediário que vocês dois podem acessar, enviar para (push to) e receber de (pull from). Nos iremos nos referir a este repositório como um "Servidor Git"; mas você perceberá que geralmente são necessários uma quantidade ínfima de recursos para hospedar um repositório Git, logo você raramente precisará de um servidor inteiro para ele.

Rodar um servidor Git é simples. Primeiro, você escolhe quais protocolos seu servidor usará para se comunicar. A primeira seção deste capítulo cobrirá os protocolos disponíveis e os prós e contras de cada um. As próximas seções explicararão algumas configurações típicas usando estes protocolos e como fazer o seu servidor rodar com eles. Por último, passaremos por algumas opções de hospedagem, se você não se importar em hospedar seu código no servidor dos outros e não quiser passar pelo incômodo de configurar e manter seu próprio servidor.

Se você não tiver interesse em rodar seu próprio servidor, você pode pular para a ultima seção do capítulo para ver algumas opções para configurar uma conta hospedada e então ir para o próximo capítulo, onde discutiremos os vários altos e baixos de trabalhar em um ambiente distribuído de controle de fontes.

Um repositório remoto é geralmente um _repositório vazio_ — um repositório Git que não tem um diretório de trabalho. Uma vez que o repositório é usado apenas como um ponto de colaboração, não há razão para ter cópias anteriores em disco; são apenas dados Git. Em termos simples, um repositório vazio é o conteúdo do diretório `.git` e nada mais.

## Os Protocolos ##

O Git pode usar quatro protocolos principais para transferir dados: Local, Secure Shell (SSH), Git e HTTP. Aqui discutiremos o que eles são e em quais circunstâncias básicas você gostaria (ou não) de utilizá-los.

É importante perceber que com excessão dos protocolos HTTP, todos estes requerem que o Git esteja instalado e rodando no servidor.

### Protocolo Local ###

O protocolo mais básico é o _protocolo Local_, em que o repositório remoto está em outro diretório no disco. Isto é frequentemente utilizado se todos no seu time tem acesso a um sistema de arquivos compartilhados como um NFS montado, ou no caso menos provável de que todos acessem o mesmo computador. Este último caso não seria ideal, porque todas as instâncias do seu repositório de código estariam no mesmo computador, fazendo com que uma perda catastrófica seja muito mais provável.

Se você tem um sistema de arquivos compartilhado, então você pode clonar, enviar para e receber de um repositório local baseado em arquivos. Para clonar um repositório desses ou para adicionar um como remoto de um projeto existente, use o caminho para o repositório como a URL. Por exemplo, para clonar um diretório local, você pode rodar algo como:

	$ git clone /opt/git/project.git

Ou você pode fazer isso:

	$ git clone file:///opt/git/project.git

O Git opera de forma ligeiramente diferente se você explicitar `file://` no começo da URL. Se você apenas especificar o caminho, o Git tenta usar hardlinks ou copiar diretamente os arquivos que necessita. Se você especificar `file://`, o Git aciona os processos que normalmente utiliza para tranferir dados através de redes, o que é geralmente uma forma de tranferência bem menos eficiente. A principal razão para especificar o prefixo `file://` é se você quer uma cópia limpa do repositório com referências e objetos estranhos deixados de lado — geralmente depois de importar de outro sistema de controle de versões ou algo similar (ver Capítulo 9 para tarefas de manutenção). Usaremos o caminho normal aqui pois isto é quase sempre mais rápido.

Para adicionar um repositório local para um projeto Git existente, você pode rodar algo assim:

	$ git remote add local_proj /opt/git/project.git

Então você pode enviar para e receber deste remoto como se você estivesse fazendo isto através de uma rede.

#### Os Prós ####

Os prós de repositórios baseados em arquivos é que eles são simples e usam permissões de arquivo e acessos de rede existentes. Se você já tem um sistema de arquivos compartilhados ao qual todo o seu time tem acesso, configurar um repositório é muito fácil. Você coloca o repositório vazio em algum lugar onde todos tem acesso compartilhado e configura as permissões de leitura/escrita como você faria para qualquer outro diretórios compartilhado. Discutiremos como exportar uma cópia de repositório vazio com este objetivo na próxima seção, “Colocando Git em um Servidor.”

Esta é também uma boa opção para rapidamente pegar trabalhos do diretório em que outra pessoa estiver trabalhando. Se você e seu colega estiverem trabalhando no mesmo projeto e ele quiser que você olhe alguma coisa, rodar um comando como `git pull /home/john/project` é frequentemente mais fácil do que ele enviar para um servidor remoto e você pegar de lá.

#### Os Contras ####

Os contras deste método são que o acesso compartilhado é geralmente mais difícil de configurar e acessar de multiplos lugares do que via conexão básica de rede. Se você quiser enviar do seu laptop quando você está em casa, você tem que montar um disco remoto, o que pode ser difícil e lento comparado com acesso via rede.

É também importante mencionar que isto não é necessariamente a opção mais rápida se você está usando uma montagem compartilhada de algum tipo. Um repositório local é rápido apenas se você tem acesso rápido aos dados. Um repositório em NFS é frequentemente mais lento do que o repositório sobre SSH no mesmo servidor, premitindo ao Git rodar dos discos locais de cada sistema.

### O Protocolo SSH ###

Provavelmente o protocolo mais comum de transporte para o Git é o SSH. Isto é porque o acesso SSH aos servidores já está configurado na maior parte dos lugares — e se não está, é fácil fazê-lo. O SSH é também o único protocolo para redes em que você pode facilmente ler (do servidor) e escrever (no servidor). Os outros dois protocolos de rede (HTTP e Git) são geralmente somente leitura, então mesmo se você os tiver disponíveis para as massas, você ainda precisa do SSH para seus próprios comandos de escrita. O SSH é também um protocolo de rede autenticado; e porque ele é onipresente, é geralmente fácil de configurar e usar.

Para clonar um repositório Git por SSH, você pode especificar uma URL ssh:// deste jeito:

	$ git clone ssh://user@server:project.git

Ou você pode deixar de especificar o protocolo — O Git assume SSH se você não for explicito:
	
	$ git clone user@server:project.git

Você também pode deixar de especificar um usuário, e o Git assume o usuário que você está atualmente logado.

#### Os Prós ####

Os prós de usar SSH são muitos. Primeiro, você basicamente tem que usá-lo se você quer acesso de escrita autenticado através de uma rede. Segundo, o SSH é relativamente simples de configurar — Daemons SSH são lugar comum, muitos administradores de rede tem experiência com eles, e muitas distribuições de SO estão configuradas com eles ou tem ferramente para gerenciá-los. Em seguida, o acesso através de SSH é seguro — toda tranferência de dados é encriptada e autenticada. Por último, como os protocolos Git e Local, o SSH é eficiente, compactando os dados da melhor forma possível antes de transferi-los.

#### Os Contras ###

O aspecto negativo do SSH é que você não pode permitir acesso anônimo do seu repositório através dele. As pessoas tem que acessar o seu computador através de SSH para acessá-lo, mesmo que apenas para leitura, o que não faz com que o acesso por SSH seja encorajador para projetos de código aberto. Se você o está usando apenas dentro de sua rede corporativa, o SSH pode ser o único protocolo com o qual você terá que lidar. Se você quiser permitir acesso anônimo somente leitura para seus projetos, você terá que configurar o SSH para envio (push over) mas outra coisa para que as pessoas possam receber (pull over).

### O Protocolo Git ###

O próximo é o protocolo Git. Este é um daemon especial que vem no mesmo pacote que o Git; ele escuta em uma porta dedicada (9418) que provê um serviço similar ao do protocolo SSH, mas absolutamente sem nenhuma autenticação. Para que um repositório seja disponibilizado via protocolo Git, você tem que criar o arquivo `git-export-daemon-ok` — o daemon não disponibilizará um repositório sem este arquivo dentro — mas além disso não há nenhuma segurança. Ou o repositório Git está disponível para todos clonarem ou não. Isto significa que geralmente não existe envio (push) sobre este protocolo. Você pode habilitar o acesso a envio; mas dada a falta de autenticação, se você ligar o acesso de envio, qualquer um na internet que encontre a URL do seu projeto poderia enviar (push) para o seu projeto. É suficiente dizer que isto é raro.

#### Os Prós ####

O protocolo Git é o mais rápido entre os disponíveis. Se você está servindo muito tráfego para um projeto público ou servido um projeto muito grande que não requer autenticação para acesso de leitura, é provável que você vai querer configurar um daemon Git para servir o seu projeto. Ele usa o mesmo mecanismo de transmissão de dados que o protocolo SSH mas sem o tempo gasto na encriptação e autenticação. 

#### Os Contras ###

O lado ruim do protocolo Git é a falta de autenticação. É geralmente indesejável que o protocolo Git seja o único acesso ao seu projeto. Geralmente, você o usará em par com um acesso SSH para os poucos desenvolvedores com acesso de envio (push) e todos os outros usariam `git://` para acesso somente leitura.
É também provavelmente o protocolo mais difícil de configurar. Ele precisa rodar seu próprio daemon, que é específico — iremos olhar como configurar um na seção “Gitosis” deste capítulo — ele requer a configuração `xinetd` ou algo similar, o que não é sempre um passeio. Ele requer também acesso a porta 9418 via firewall, o que não é uma porta padrão que firewalls corporativas sempre permitem. Por trás de grandes firewalls corporativas, esta porta obscura está comumente bloqueada.

### O Protocolo HTTP/S Protocol ###

Por último temos o protocolo HTTP. A beleza do protocolo HTTP ou HTTPS é a simplicidade em configurar. Basicamente, tudo o que você precisa fazer é colocar o repósitor Git do jeito que ele é no Servidor HTTP document root e configurar um específico gancho (hook) `post-update`, e você está pronto (veja Capítulo 7 para detalhes on Git Ganchos (Hooks)). Neste ponto, qualquer um com acesso ao servidor web no qual você colocou o repositório também pode clonar o repositório. Para permitir acesso de leitura ao seu repositório usando HTTP, execute o seguinte:

	$ cd /var/www/htdocs/
	$ git clone --bare /path/to/git_project gitproject.git
	$ cd gitproject.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

E pronto. O gancho `post-update` que vem com Git executa o comando apropriado (`git update-server-info`) para que fetch e clone via HTTP funcione corretamente. Este comando é executado quando você envia para o repositório usando `push` via SSH; então, outros podem clonar via algo como

	$ git clone http://example.com/gitproject.git

Neste caso particular, estamos usando o caminho `/var/www/htdocs` que é comum para configurações Apache, mas você pode usar qualquer servidor web estático — apenas coloque o caminho do repositório. Os dados no Git são servidos como arquivos estáticos basicos (veja Capítulo 9 para mais detalhes sobre como exatamente eles são servidos).

É possível fazer Git enviar via HTTP também, embora esta técnica não é muito usada e requer que você configure WebDav com parâmetros complexos. Pelo fato de ser usado raramente, não iremos cobrir neste livro. Se você está interessado em usar os protocolos HTTP-push, você pode ler sobre preparação de um repositório para este propósito na `http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt`. Uma coisa legal sobre fazer Git enviar via HTTP é que você pode usar qualquer servidor WebDAV, sem quaisquer características Git; então, você pode usar esta funcionalidade se o seu provedor web suporta WebDAV com permissão de escrita para o seu web site.

#### Os Prós ####

O lado bom de usar protoclo HTTP é que ele é fácil de configurar. Executar o punhado de comandos obrigatórios lhe provém um jeito simples de fornecer ao mundo acesso ao seu repositório Git. Você só precisa de alguns minutos. O protoclo HTTP também não é consume muitos recursos no servidor. Pelo fato de usar apenas um servidor HTTP estático para todo o dado, um servidor Apache normal pode servir em média milhares de arquivos por segundo — é difícil sobrecarregar até mesmo um servidor pequeno.

Você também pode servir seus repositórios com apenas acesso de leitura via HTTPS, o que significa que você pode encriptar o conteúdo transferido; ou pode ir até o ponto de fazer seus usuários usarem certificados SSL assinados. Geralmente, se você está indo até este ponto, é mais fácil usar as chaves públicas SSH; mas pode ser uma solução melhor em casos específicos usar certificados SSL assinados ou outro método de autenticação HTTP para acesso de leitura via HTTPS.

Outra coisa legal é que HTTP é um protocolo tão comumente usado que firewalls corporativos são normalmente configurados para permitir tráfego por esta porta.

#### Os Contras ####

O lado ruim de servidr seu repositório via HTTP é que ele é relativamente ineficiente para o usuário. Geralmente demora muito mais para clonar ou fetch do repositório, e você frequentemente tem mais sobrecarga de rede e volume de transferência via HTTP do que com outros protocolos de rede. Pelo fato de não ser inteligente sobre os dados que você precisa — não tem um trabalho dinâmico por parte do servidor nestas transações — o protocolo HTTP é frequentemente referido como o protocolo _burro_. Para mais informações sobre as diferenças em eficiência entre o protocolo HTTP e outros protocolos, veja o Capítulo 9.

## Configurando Git no Servidor ##

Antes de configurar qualquer Git server, você tem que exportar um repositório existente em um novo repositório limpo — um repositório que não contém um diretório sendo trabalhado. Isto é geralmente fácil de fazer.
Para clonar seu repositório para criar um novo repositório limpo, você pode executar o comando clone com a opção `--bare`. Por convenção, diretórios de repositórios limpos terminam em `.git`, assim:

	$ git clone --bare my_project my_project.git
	Initialized empty Git repository in /opt/projects/my_project.git/

O resultado deste comando é um pouco confuso. Já que `clone` é basicamente um `git init` seguido de um `git fetch`, nós vemos um pouco do resultado de `git init`, que cria um diretório vazio. A transferência real de objetos não dá nenhum resultado, mas ocorre. Você deve ter agora uma cópia dos dados do diretório Git no seu diretório `my_project.git`.

Isto é mais ou menos equivalente a algo assim

	$ cp -Rf my_project/.git my_project.git

Existem algumas diferenças menores no arquivo de configuração caso você siga este caminho; mas para o propósito, isto é perto da mesma coisa.  Ele copia o repositório Git, sem um diretório de trabalho, e cria um diretório especificamente para ele sozinho.

### Colocando o Repositório Limpo no Servidor ###

Agora que você tem uma cópia limpar do seu repositório, tudo o que você precisa fazer é colocar ele num servidor e configurar os protocolos. Vamos dizer que você configurou um servidor chamado `git.example.com` que você tem acesso via SSH, e você quer armazenar todos os seus repositórios Git no diretório `/opt/git`. Você pode configurar o seu novo repositório apenas copiando o seu repositório limpo:

	$ scp -r my_project.git user@git.example.com:/opt/git

Neste ponto, outros usuários com acesso SSH para o mesmo servidor e que possuam acesso de leitura para o diretório `/opt/git` podem clonar o seu repositório executando

	$ git clone user@git.example.com:/opt/git/my_project.git

Se um usuário SSH em um servidor e tem acesso de escrita para o diretório `/opt/git/my_project.git`, ele também terá acesso para envio (push) automaticamente. Git irá automaticamente adicionar permissões de escrita apropriadas para o grupo se o comando `git init` com a opçao `--shared` for executada em um repositório.

	$ ssh user@git.example.com
	$ cd /opt/git/my_project.git
	$ git init --shared

Você pode ver como é fácil pegar um repositório Git, criar uma versão limpa, e colocar num servidor onde você e seus colaboradores têm acesso SSH. Agora vocês estão prontos para colaborar no mesmo projeto.

Ẽ importante notar que isso é literalmente tudo que você precisa fazer para rodar um servidor Git útil no qual várias pessoas possam acessar — apenas adicione as contas com acesso SSH ao servidor, coloque um repositório Git em algum lugar do servidor no qual todos os usuários tenham acesso de leitura e escrita. Você está pronto — nada mais é necessário.

Nas próximas seções, você verá como expandir para configurações mais sofisticas. Essa discussão irá incluir a característica de não precisar criar contas para cada usuário, adicionar acesso de leitura público para os seus repositórios, configurar Web UIs, usando a ferramenta Gitosis, e mais. Entretanto, mantenha em mente que colaborar com algumas pessoas em um projeto privado, tudo o que você _precisa_ é um servidor SSH e um repositório limpo.

### Setups Pequenos ###

Se você for uma pequena empresa or apenas testando Git na sua organização e tem alguns desenvolvedores, as coisas podem ser simples para você. Um dos aspectos mais complicados de configurar um servidor Git é gerenciamento de usuários. Se você quer que alguns repositórios sejam apenas de leitura para alguns usuários e leitura/escrita para outros, acesso e permissões podem ser um pouco difícil de arranjar.

#### Acesso SSH ####

Se você já tem um servidor ao qual todos os seus desenvolvedores tem acesso SSH, é geralmente mais fácil configurar o seu primeiro repositório lá, pelo fato de vc não precisar fazer praticamente nenhum trabalho extra (como cobrimos na última seção). Se você quiser um controle de acesso mais complexo nos seus repositórios, você pode gerenciá-los com o sistema de permissão de arquivos do sistema operacional que o seu servidor roda.

Se você quiser colocar seus repositórios num servidor que não possui contas para todos no seu time que você quer dar permissão de acesso, então você deve configurar acesso SSH para eles. Assumimos que se você tem um servidor com o qual fazer isso, você já tem um servidor SSH instalado, e é assim que você está acessando o servidor.

Existem algumas alternativas para dar acesso a todos no seu time. A primeira é configurar contas para todos, o que é simples mas pode se tornar complicado. Você provavelmente n"ao quer executar `adduser` e definir e senhas temporárias para cada usuário.

Um segundo método é criar um único usuário 'git' na máquina, pedir a cada usuário que é para possuir acesso de escrita para enviar chave pública SSH, e adicionar estas chaves para o arquivo `~/.ssh/authorized_keys` do seu novo usuário 'git'. Neste ponto, todos poderão acessar aquela máquina usando o usuário 'git'. Isto não afeta os dados em commit de maneira alguma — o usuário SSH que você se conecta não afeta os commits que você gravou previamente.

Outro método é ter o seu servidor SSH autenticando de um servidor LDAP ou outro autenticador central que você talvez já tenha previamente configurado. Contato que cada usuário tenha acesso shell à máquina, qualquer mecanismo de autenticação SSH que você pense deve funcionar.

## Gerando Sua Chave Pública SSH ##

Sendo o que foi dito, vários servidores Git autenticam usando chaves públicas SSH. Para fornecer uma chave pública, cada usuário no seu sistema devem gerar uma se eles ainda não a possuem. Este processo é similar dentre os vários sistemas operacionais.
Primeiro, você deve checar para ter certeza que você ainda não possui um chave. Por padrão, as chaves SSH de um usuário são armazenadas no diretório `~/.ssh`. Você pode facilmente verificar se você tem uma chave indo para aquele diretório e listando o seu conteúdo:

	$ cd ~/.ssh
	$ ls
	authorized_keys2  id_dsa       known_hosts
	config            id_dsa.pub

Você está procurando por um par de arquivos chamados _algo_ e _algo.pub_, onde _algo_ é normalmente `id_dsa` ou `id_rsa`. O arquivo `.pub` é a sua chave pública, e o outro arquivo é a sua chave privada. Se você não tem estes arquivos (ou não tem nem mesmo o diretório `.ssh`), você pode criá-los executando um programa chamado `ssh-keygen`, que é fornecido com o pacote SSH em sistemas Linux/Mac e vem com o pacote MSysGit no Windows:

	$ ssh-keygen 
	Generating public/private rsa key pair.
	Enter file in which to save the key (/Users/schacon/.ssh/id_rsa): 
	Enter passphrase (empty for no passphrase): 
	Enter same passphrase again: 
	Your identification has been saved in /Users/schacon/.ssh/id_rsa.
	Your public key has been saved in /Users/schacon/.ssh/id_rsa.pub.
	The key fingerprint is:
	43:c5:5b:5f:b1:f1:50:43:ad:20:a6:92:6a:1f:9a:3a schacon@agadorlaptop.local

Primeiro ele confirma onde você quer salvar a chave (`.ssh/id_rsa`), e então pergunta duas vezes por uma frase de acesso, que você pode deixar em branco se você não quiser digitar uma senha quando usar a chave.

Agora, cada usuário que executar o comando acima precisa enviar a chave pública para você ou para o administrador do seu servidor Git (assumindo que você está usando um servidor SSH cuja configuração necessita de chaves públicas). Tudo o que eles precisam fazer é copiar o conteúdo do arquivo `.pub` e enviar para você via e-mail. As chaves públicas são parecidas com isso.

	$ cat ~/.ssh/id_rsa.pub 
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU
	GPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3
	Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XA
	t3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/En
	mZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbx
	NrRFi9wrf+M7Q== schacon@agadorlaptop.local

Para um tutorial mais detalhado em criar chaves SSH on vários sistemas operacionais, veja o guia do GitHub em chaves SSH no endereço `http://github.com/guides/providing-your-ssh-key`.

## Configurando o Servidor ##

Vamos agora configurar acesso SSH no lado do servidor. Neste exemplo, você irá autenticar seus usuários pelo método das `authorized_keys`. Também assumimos que você esteja rodando uma distribuição padrão do Linux como o Ubuntu. Primeiramente, crie um usuário 'git' e um diretório `.ssh` para ele.

	$ sudo adduser git
	$ su git
	$ cd
	$ mkdir .ssh

A seguir, você precisará adicionar uma chave pública de algum desenvolvedor para o arquivo `authorized_keys` do usuário 'git'. Vamos assumir que você recebeu algumas chaves por e-mail e as salvou em arquivos temporários. Novamente, as chaves públicas são algo parecido com isso aqui:

	$ cat /tmp/id_rsa.john.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCB007n/ww+ouN4gSLKssMxXnBOvf9LGt4L
	ojG6rs6hPB09j9R/T17/x4lhJA0F3FR1rP6kYBRsWj2aThGw6HXLm9/5zytK6Ztg3RPKK+4k
	Yjh6541NYsnEAZuXz0jTTyAUfrtU3Z5E003C4oxOj6H0rfIF1kKI9MAQLMdpGW1GYEIgS9Ez
	Sdfd8AcCIicTDWbqLAcU4UpkaX8KyGlLwsNuuGztobF8m72ALC/nLF6JLtPofwFBlgc+myiv
	O7TCUSBdLQlgMVOFq1I2uPWQOkOWQAHukEOmfjy2jctxSDBQ220ymjaNsHT4kgtZg2AYYgPq
	dAv8JggJICUvax2T9va5 gsg-keypair

Você tem apenas que concatenar as chaves públicas salves ao arquivo `authorized_keys`:

	$ cat /tmp/id_rsa.john.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.josie.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.jessica.pub >> ~/.ssh/authorized_keys

Agora, você pode configurar um repositório vazio para eles executando o comando `git init` com a opção `--bare`, que inicializa o repositório sem um diretório de trabalho:

	$ cd /opt/git
	$ mkdir project.git
	$ cd project.git
	$ git --bare init

Assim, John, Josie ou Jessica podem enviar a primeira versão dos seus projetos para o repositório simplesmente adicionado-o como um remoto e enviando (push) uma branch. Atente que alguém deve acessar o servidor e criar um repositório limpo toda vez que eles queiram adicionar um projeto. Vamos usar `gitserver` como o nome do servidor no qual você configurou o usuário 'git' e o repositório. Se você estiver rodando ele internamente, e você configurou uma entrada DNS para `gitserver` apontando para esta máquina, então você pode simplesmente seguir os comandos abaixo:

	# on Johns computer
	$ cd myproject
	$ git init
	$ git add .
	$ git commit -m 'initial commit'
	$ git remote add origin git@gitserver:/opt/git/project.git
	$ git push origin master

Neste ponto, os outros podem clonar e enviar as mudanças facinho:

	$ git clone git@gitserver:/opt/git/project.git
	$ vim README
	$ git commit -am 'fix for the README file'
	$ git push origin master

Com este método, você pode rapidamente ter um servidor com acesso de leitura e escrita rodando para os desenvolvedores.

Como uma precaução extra, você pode facilmente restringir o usuário 'git' para executar apenas atividades Git com uma shell limitada chamada `git-shell` que vem com o Git. Se você configurar ela como a shell do seu usuário 'git', logo o usuário não poderá ter acesso shell normal ao seu servidor. Para usar esta característica, especifique `git-shell` ao invés de bash ou csh para o o login shell do usuário. Para fazê-lo, você provavelmente vai ter que editar o arquivo `/etc/passwd`:
likely have to edit your `/etc/passwd` file:

	$ sudo vim /etc/passwd

No final, você deve encontrar uma linha parecida com essa:

	git:x:1000:1000::/home/git:/bin/sh

Modifique `/bin/sh` para `/usr/bin/git-shell` (ou execute `which git-shell` para ver onde está instalado). A linha modificada deve se parecer com a abaixo:

	git:x:1000:1000::/home/git:/usr/bin/git-shell

Agora, o usuário 'git' pode apenas usar a conexão SSH para enviar e puxar repositórios Git e não pode se conectar via SSH na máquina. Se você tentar, você verá uma mensagem de rejeição parecida com a seguinte:

	$ ssh git@gitserver
	fatal: What do you think I am? A shell?
	Connection to gitserver closed.

## Acesso Público ##

E se você quiser acesso anônimo de leitura ao seu projeto? Talvez ao invés de armazenar um projeto privado interno, você queira armazenar um projeto de código aberto. Ou talvez você tenha alguns servidores de criação automatizados ou servidores de  integração contínua que estão sempre sendo modificados, e você não queira gerar chaves SSH o tempo todo — você simplesmente quer permitir acesso de leitura anônimo.

Provavelmente o jeito mais fácil para pequenas configurações é rodar um servidor web estático com o documento raiz onde os seus repositórios Git estão, e então ativar o gancho `post-update` que mencionamos na primeira seção deste capítulo. Vamos trabalhar a partir do exemplo anterior. Vamos dizer que você tenha seus repositórios no diretório `/opt/git`, e um servidor Apache rodando na máquina. Novamente, você pode usar qualquer servidor web para fazer isso; mas para esse exemplo, vamos demonstrar algumas configurações básicas do Apache para te dar uma idéia do que você vai precisar:

Primeiro você tem que habilitar o gancho:

	$ cd project.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

Se você estiver usando uma versão do Git anterior à 1.6, o comando `mv` não é necessário — o Git começou a nomear os examples de gancho com o sufixo .sample apenas recentemente.

O que este gancho `post-update` faz? Ele se parece basicamente com isso aqui:

	$ cat .git/hooks/post-update 
	#!/bin/sh
	exec git-update-server-info

Isto significa que quando você enviar para o servidor via SSH, o Git irá executar este comando para atualizar os arquivos necessários para fetch via HTTP.

Em seguida, você precisa adicionar uma entrada VirtualHost para a sua configuração no Apache com a opção DocumentRoot apontando para o diretório raiz dos seus projetos Git. Aqui, assumimos que você tem uma entrada DNS geral com asterisco para enviar `*.gitserver` para a máquina que você está usando para rodar tudo isso:

	<VirtualHost *:80>
	    ServerName git.gitserver
	    DocumentRoot /opt/git
	    <Directory /opt/git/>
	        Order allow, deny
	        allow from all
	    </Directory>
	</VirtualHost>

Você também precisará configurar o grupo de usuários dos diretórios em `/opt/git` para `www-data` para que o seu servidor web possa ler os repositórios, pelo fato do script CGI do Apache rodar (padrão) como este usuário:

	$ chgrp -R www-data /opt/git

Quando você reiniciar o Apache, você deve poder clonar o repositórios dentro daquele diretório especificando a URL para o projeto:

	$ git clone http://git.gitserver/project.git

Deste jeito, você pode configurar um servidor HTTP com acesso de leitura para os seus projetos para um sem número de usuários em minutos. Outra opção simples para acesso público sem autenticação é iniciar um daemon Git, embora isso necessite que você daemonize o processo - iremos cobrir esta opção na próxima seção, se você preferir esta rota.

## GitWeb ##

Now that you have basic read/write and read-only access to your project, you may want to set up a simple web-based visualizer. Git comes with a CGI script called GitWeb that is commonly used for this. You can see GitWeb in use at sites like `http:/git.kernel.org` (see Figure 4-1).

Insert 18333fig0401.png 
Figure 4-1. The GitWeb web-based user interface

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
	readable = iphone_project
	members = john

Now John can clone the project and get updates, but Gitosis won’t allow him to push back up to the project. You can create as many of these groups as you want, each containing different users and projects. You can also specify another group as one of the members, to inherit all of its members automatically.

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
Figure 4-2. The GitHub plan page

Here you must choose a username that isn’t yet taken in the system and enter an e-mail address that will be associated with the account and a password (see Figure 4-3).

Insert 18333fig0403.png 
Figure 4-3. The GitHub user signup form

If you have it available, this is a good time to add your public SSH key as well. We covered how to generate a new key earlier, in the "Simple Setups" section. Take the contents of the public key of that pair, and paste it into the SSH Public Key text box. Clicking the "explain ssh keys" link takes you to detailed instructions on how to do so on all major operating systems.
Clicking the "I agree, sign me up" button takes you to your new user dashboard (see Figure 4-4).

Insert 18333fig0404.png 
Figure 4-4. The GitHub user dashboard

Next you can create a new repository. 

### Creating a New Repository ###

Start by clicking the "create a new one" link next to Your Repositories on the user dashboard. You’re taken to the Create a New Repository form (see Figure 4-5).

Insert 18333fig0405.png 
Figure 4-5. Creating a new repository on GitHub

All you really have to do is provide a project name, but you can also add a description. When that is done, click the "Create Repository" button. Now you have a new repository on GitHub (see Figure 4-6).

Insert 18333fig0406.png 
Figure 4-6. GitHub project header information

Since you have no code there yet, GitHub will show you instructions for how create a brand-new project, push an existing Git project up, or import a project from a public Subversion repository (see Figure 4-7).

Insert 18333fig0407.png 
Figure 4-7. Instructions for a new repository

These instructions are similar to what we’ve already gone over. To initialize a project if it isn’t already a Git project, you use

	$ git init
	$ git add .
	$ git commit -m 'initial commit'

When you have a Git repository locally, add GitHub as a remote and push up your master branch:

	$ git remote add origin git@github.com:testinguser/iphone_project.git
	$ git push origin master

Now your project is hosted on GitHub, and you can give the URL to anyone you want to share your project with. In this case, it’s `http://github.com/testinguser/iphone_project`. You can also see from the header on each of your project’s pages that you have two Git URLs (see Figure 4-8).

Insert 18333fig0408.png 
Figure 4-8. Project header with a public URL and a private URL

The Public Clone URL is a public, read-only Git URL over which anyone can clone the project. Feel free to give out that URL and post it on your web site or what have you.

The Your Clone URL is a read/write SSH-based URL that you can read or write over only if you connect with the SSH private key associated with the public key you uploaded for your user. When other users visit this project page, they won’t see that URL—only the public one.

### Importing from Subversion ###

If you have an existing public Subversion project that you want to import into Git, GitHub can often do that for you. At the bottom of the instructions page is a link to a Subversion import. If you click it, you see a form with information about the import process and a text box where you can paste in the URL of your public Subversion project (see Figure 4-9).

Insert 18333fig0409.png 
Figure 4-9. Subversion importing interface

If your project is very large, nonstandard, or private, this process probably won’t work for you. In Chapter 7, you’ll learn how to do more complicated manual project imports.

### Adding Collaborators ###

Let’s add the rest of the team. If John, Josie, and Jessica all sign up for accounts on GitHub, and you want to give them push access to your repository, you can add them to your project as collaborators. Doing so will allow pushes from their public keys to work.

Click the "edit" button in the project header or the Admin tab at the top of the project to reach the Admin page of your GitHub project (see Figure 4-10).

Insert 18333fig0410.png 
Figure 4-10. GitHub administration page

To give another user write access to your project, click the “Add another collaborator” link. A new text box appears, into which you can type a username. As you type, a helper pops up, showing you possible username matches. When you find the correct user, click the Add button to add that user as a collaborator on your project (see Figure 4-11).

Insert 18333fig0411.png 
Figure 4-11. Adding a collaborator to your project

When you’re finished adding collaborators, you should see a list of them in the Repository Collaborators box (see Figure 4-12).

Insert 18333fig0412.png 
Figure 4-12. A list of collaborators on your project

If you need to revoke access to individuals, you can click the "revoke" link, and their push access will be removed. For future projects, you can also copy collaborator groups by copying the permissions of an existing project.

### Your Project ###

After you push your project up or have it imported from Subversion, you have a main project page that looks something like Figure 4-13.

Insert 18333fig0413.png 
Figure 4-13. A GitHub main project page

When people visit your project, they see this page. It contains tabs to different aspects of your projects. The Commits tab shows a list of commits in reverse chronological order, similar to the output of the `git log` command. The Network tab shows all the people who have forked your project and contributed back. The Downloads tab allows you to upload project binaries and link to tarballs and zipped versions of any tagged points in your project. The Wiki tab provides a wiki where you can write documentation or other information about your project. The Graphs tab has some contribution visualizations and statistics about your project. The main Source tab that you land on shows your project’s main directory listing and automatically renders the README file below it if you have one. This tab also shows a box with the latest commit information.

### Forking Projects ###

If you want to contribute to an existing project to which you don’t have push access, GitHub encourages forking the project. When you land on a project page that looks interesting and you want to hack on it a bit, you can click the "fork" button in the project header to have GitHub copy that project to your user so you can push to it.

This way, projects don’t have to worry about adding users as collaborators to give them push access. People can fork a project and push to it, and the main project maintainer can pull in those changes by adding them as remotes and merging in their work.

To fork a project, visit the project page (in this case, mojombo/chronic) and click the "fork" button in the header (see Figure 4-14).

Insert 18333fig0414.png 
Figure 4-14. Get a writable copy of any repository by clicking the "fork" button.

After a few seconds, you’re taken to your new project page, which indicates that this project is a fork of another one (see Figure 4-15).

Insert 18333fig0415.png 
Figure 4-15. Your fork of a project 

### GitHub Summary ###

That’s all we’ll cover about GitHub, but it’s important to note how quickly you can do all this. You can create an account, add a new project, and push to it in a matter of minutes. If your project is open source, you also get a huge community of developers who now have visibility into your project and may well fork it and help contribute to it. At the very least, this may be a way to get up and running with Git and try it out quickly.

## Summary ##

You have several options to get a remote Git repository up and running so that you can collaborate with others or share your work.

Running your own server gives you a lot of control and allows you to run the server within your own firewall, but such a server generally requires a fair amount of your time to set up and maintain. If you place your data on a hosted server, it’s easy to set up and maintain; however, you have to be able to keep your code on someone else’s servers, and some organizations don’t allow that.

It should be fairly straightforward to determine which solution or combination of solutions is appropriate for you and your organization.
