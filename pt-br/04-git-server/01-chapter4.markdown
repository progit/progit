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

O lado ruim de servir seu repositório via HTTP é que ele é relativamente ineficiente para o usuário. Geralmente demora muito mais para clonar ou fetch do repositório, e você frequentemente tem mais sobrecarga de rede e volume de transferência via HTTP do que com outros protocolos de rede. Pelo fato de não ser inteligente sobre os dados que você precisa — não tem um trabalho dinâmico por parte do servidor nestas transações — o protocolo HTTP é frequentemente referido como o protocolo _burro_. Para mais informações sobre as diferenças em eficiência entre o protocolo HTTP e outros protocolos, veja o Capítulo 9.

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

Agora que você tem acesso de leitura/escrita e apenas leitura para o seu projeto, você pode querer configurar um visualizador simples baseado em web. Git vem com um script CGI chamado GitWeb que normalmente é usado para isso. Você pode ver o GitWeb em uso em sites como `http://git.kernel.org` (veja Figura 4-1).

Insert 18333fig0401.png 
Figure 4-1. A interface de usuário baseada em web GitWeb

Se você quiser verificar o que o GitWeb pareceria no seu projeto, Git vem com um comando para disparar uma instância temporária se você tem um servidor leve no seu sistema como `lighttpd` ou `webrick`. Em máquinas Linux, `lighttpd` normalmente está instalado, então você deve conseguir fazê-lo funcionar digitando `git instaweb` no diretório do seu projeto. Se você está usando um Mac, Leopard vem com Ruby pré-instalado, então `webrick` é sua melhor aposta. Para iniciar `instaweb` com um manipulador diferente de lighttpd, você pode rodá-lo com a opção `--httpd`.

	$ git instaweb --httpd=webrick
	[2009-02-21 10:02:21] INFO  WEBrick 1.3.1
	[2009-02-21 10:02:21] INFO  ruby 1.8.6 (2008-03-03) [universal-darwin9.0]

Isso inicia um servidor HTTPD na porta 1234 e então automaticamente inicia um navegador web que abre naquela página. É bem fácil da sua parte. Quando você tiver terminado e quiser desligar o servidor, você pode rodar o mesmo comando com a opção `--stop`:

	$ git instaweb --httpd=webrick --stop

Se você quer rodar a interface web num servidor o tempo inteiro para a sua equipe ou para um projeto open source que você esteja hospedando, você vai precisar configurar o script CGI para ser servido pelo seu servidor web normal. Algumas distribuições Linux têm um pacote `gitweb` que você deve ser capaz de instalar via `apt` ou `yum`, então você pode tentar isso primeiro. Nós procederemos na instalação do GitWeb manualmente bem rápido. Primeiro, você precisa pegar o código-fonte do Git, o qual vem acompanha GitWeb, e gerar o script CGI personalizado:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/
	$ make GITWEB_PROJECTROOT="/opt/git" \
	        prefix=/usr gitweb/gitweb.cgi
	$ sudo cp -Rf gitweb /var/www/

Note que você precisa avisar ao comando onde encontrar os seus repositórios Git com a variável `GITWEB_PROJECTROOT`. Agora, você precisa fazer o Apache usar CGI para aquele script, para o qual você pode adicionar um VirtualHost:

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

Novamente, GitWeb pode ser servido com qualquer servidor CGI; se você preferir usar alguma outra coisa, não deveria ser difícil configurar. Até então, você poderia visitar `http://gitserver/` para visualizar seus repositórios online, e você pode usar `http://git.gitserver` para efetuar clone e fetch nos seus repositórios via HTTP.

## Gitosis ##

Manter as chaves públicas de todos os usuários no arquivo `authorized_keys` para acesso funciona bem
somente por um tempo. Quando você tem centenas de usuários, gerenciar esse processo se torna bastante
doloroso. Você precisa acessar o servidor via shell toda vez, e não existe controle de acesso - todos no arquivo têm acesso de leitura e escrita para cada projeto.

Nesse ponto, talvez você queira passar a usar um software largamente utilizado chamado Gitosis.
Gitosis é basicamente um conjunto de scripts que te ajudam a gerenciar o arquivo `authorized_keys`, bem como implementar alguns controles de acesso simples. A parte realmente interessante é que a Interface
de Usuário dessa ferramenta utilizada para adicionar pessoas e determinar o controle de acessos não 
é uma interface web, e sim um repositório Git especial. Você configura a informação naquele projeto; 
e quando você executa um push nele, Gitosis reconfigura o servidor baseado nas configurações que você fez,
o que é bem legal.

Instalar Gitosis não é a tarefa mais simples do mundo, mas também não é tão difícil. É mais fácil utilizar
um servidor Linux para fazer isso - os exemplos a seguir utilizam um servidor com Ubuntu 8.10.

Gitosis requer algumas ferramentas Python, então antes de tudo você precisa instalar o pacote Python setuptools, o qual Ubuntu provê sob o nome de python-setuptools:

	$ apt-get install python-setuptools

Depois, você clona e instala Gitosis do site principal do projeto:

	$ git clone git://eagain.net/gitosis.git
	$ cd gitosis
	$ sudo python setup.py install

Ao fazer isso, você instala alguns executáveis que Gitosis vai utilizar. A seguir, Gitosis vai quere
colocar seus repositórios em `/home/git`, o que não tem nenhum problema. Mas você já configurou os seus repositórios em `/opt/git`, então, ao invés de reconfigurar tudo, você simplesmente cria um link simbólico:

	$ ln -s /opt/git /home/git/repositories

Gitosis vai gerenciar as suas chaves por você, então você precisa remover o arquivo atual, 
adicionar as chaves novamente, e deixar Gitosis controlar o arquivo `authorized_keys` automaticamente.
Por enquanto, tire o arquivo `authorized_keys` do caminho:

	$ mv /home/git/.ssh/authorized_keys /home/git/.ssh/ak.bak

Em seguida, você precisa ativar o seu shell novamente para o usuário 'git', caso você tenha o mudado para
o comando `git-shell`. As pessoas ainda não vão conseguir logar no servidor, porém Gitosis vai tomar
controlar isso para você. Então, vamos alterar essa linha no seu arquivo `/etc/passwd`

	git:x:1000:1000::/home/git:/usr/bin/git-shell

de volta para isso:

	git:x:1000:1000::/home/git:/bin/sh

Agora é a hora de inicializar Gitosis. Você faz isso executando o comando `gitosis-init` com a sua chave pública pessoal. Se a sua chave pública não está no servidor, você vai ter que copiá-la para lá:

	$ sudo -H -u git gitosis-init < /tmp/id_dsa.pub
	Initialized empty Git repository in /opt/git/gitosis-admin.git/
	Reinitialized existing Git repository in /opt/git/gitosis-admin.git/

Isso permite ao usuário com aquela chave modificar o repositório Git principal que controlar o setup Gitosis. Em seguida, você precisa configurar manualmente o bit de execução no script `post-update` para o seu novo repositório de controle.

	$ sudo chmod 755 /opt/git/gitosis-admin.git/hooks/post-update

Você já está pronto para mandar ver. Se as configurações estão todas corretas, você pode tentar acessar
o seu servidor via SSH com o usuário cuja chave pública você adicionou para inicializar o Gitosis. Você deve ver algo assim:

	$ ssh git@gitserver
	PTY allocation request failed on channel 0
	fatal: unrecognized command 'gitosis-serve schacon@quaternion'
	  Connection to gitserver closed.

Essa mensagem significa que Gitosis reconhecer você mas te expulsou porque você não está tentando fazer nenhum comando Git. Então, vamos fazer um comando do Git - você vai clonar o repositório central do Gitosis:

	# on your local computer
	$ git clone git@gitserver:gitosis-admin.git

Agora, você tem um diretório chamado `gitosis-admin`, o qual tem duas grandes partes:

	$ cd gitosis-admin
	$ find .
	./gitosis.conf
	./keydir
	./keydir/scott.pub

O arquivo `gitosis.conf` é o arquivo de controle a ser usado para especificar usuários, repositórios e permissões. O diretório `keydir` é onde você armazena as chaves públicas de todos os usuários que têm algum tipo de acesso aos seus repositórios - um arquivo por usiário. O nome do arquivo em `key_dir` (no exemplo anterir, `scott.pub`) será diferente para você - Gitosis pega o nome da descrição no final da chave pública que foi importada com o script `gitosis-init`.

Se você olhar no arquivo `gitosis.conf`, ele deveria apenas especificar informações sobre o projeto
`gitosis-admin` que você acabou de clonar:

	$ cat gitosis.conf 
	[gitosis]

	[group gitosis-admin]
	writable = gitosis-admin
	members = scott

Ele mostra que o usuário 'scott' - o usuário cuja chave pública foi usada para inicializar Gitosis - é o único que tem acesso ao projeto `gitosis-admin`.

Agora, vamos adicionar um novo projeto para você. Você vai adicionar uma nova seção chamada `mobile` onde você vai listar os desenvolvedores na sua equipe de desenvolvimento mobile e projetos que esses desenvolvedores precisam ter acesso. Porque 'scott' é o único usuário no sistema nesse momento, você vai adicioná-lo como o único membro, e você vai criar um novo projeto chamado `iphone_project` para começar:

	[group mobile]
	writable = iphone_project
	members = scott

A qualquer momento que você faça alterações no projeto `gitosis-admin`, você vai precisar commitar as mudanças e enviá-las (push) de volta para o servidor, para que elas tenham efeito:

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

Você pode fazer o seu primeiro push para o novo projeto `iphone_project` adicionando o seu servidor como um repositório remoto da sua versão local do projeto e fazendo um push. Você não precisa mais criar um repositório bare manualmente para novos projetos no servidor - Gitosis os cria automaticamente quando ele vê o seu primeiro push:

	$ git remote add origin git@gitserver:iphone_project.git
	$ git push origin master
	Initialized empty Git repository in /opt/git/iphone_project.git/
	Counting objects: 3, done.
	Writing objects: 100% (3/3), 230 bytes, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:iphone_project.git
	 * [new branch]      master -> master

Note que você não precisa especificar o caminho (na verdade, fazer isso não vai funcionar), apenas uma vírgula e o nome do projeto - Gitosis o encontra para você.

Você quer trabalhar nesse projeto com os seus amigos, então você vai ter que adicionar novamente as chaves públicas deles. Mas, ao invés de acrescentá-las manualmente ao arquivo `~/.ssh/authorized_keys` no seu servidor, você vai adicioná-las, uma chave por arquivo, no diretório `keydir`. A forma com que você nomeia as chaves determina como você se refere aos usuários no arquivo `gitosis.conf`. Vamos adicionar novamente as chaves públicas para John, Josie e Jessica:

	$ cp /tmp/id_rsa.john.pub keydir/john.pub
	$ cp /tmp/id_rsa.josie.pub keydir/josie.pub
	$ cp /tmp/id_rsa.jessica.pub keydir/jessica.pub

Agora você pode adicioná-los à sua equipe 'mobile' para que eles possam ter acesso de leitura e escrita no projeto `iphoen_project`:

	[group mobile]
	writable = iphone_project
	members = scott john josie jessica

Depois que você commitar e enviar essa mudança, todos os quatro usuários serão capazes de ler e escrever naquele projeto.

Gitosis também tem simples controles de acesso. Se você quer que John tenha apenas acesso de leitura para esse projeto, você pode fazer desta forma:

	[group mobile]
	writable = iphone_project
	members = scott josie jessica

	[group mobile_ro]
	readable = iphone_project
	members = john

Agora John pode clonar o projeto e receber atualizações, porém Gitosis não vai deixá-lo enviar as suas atualizações ao projeto. Você pode criar quantos desses grupos você queira, cada um contendo usuários e projetos diferentes. Você também pode especificar outro como membro, para herdar todos os seus membros automaticamente.

Se você tiver quaisquer problemas, pode ser útil adicionar `loglevel=DEBUG` abaixo da seção `[gitosis]`. Se você perdeu o acesso de push por enviar uma configuração errada, você pode consertar o arquivo manualmente no servidor em`/home/git/.gitosis.conf` - o arquivo do qual Gitosis lê suas informações. Um push para o projeto pega o arquivo `gitosis.conf` que você acabou de enviar e o coloca lá. Se você editar esse arquivo manualmente, ele permanece dessa forma até o próximo push bem sucedido para o projeto `gitosis.conf`.

## Serviço Git ##

Para acesso público e não autenticado para leitura de seus projetos, você irá querer utilizar o protocolo Git ao invés do protocolo HTTP. A razão principal é a velocidade. O protocolo Git é muito mais eficiente e, portanto, mais rápido do que o protocolo HTTP, de modo que usá-lo irá poupar tempo de seus usuários.

Novamente, isso é para acesso não autenticado e somente leitura. Se seu servidor estiver fora da proteção de seu firewall, utilize o protocolo Git apenas para projetos que são publicamente visíveis na internet. Se o servidor estiver dentro de seu firewall, você pode usá-lo para projetos em que um grande número de pessoas ou computadores (integração contínua ou servidores de compilação) têm acesso somente leitura, e você não quer adicionar uma chave SSH para cada pessoa ou computador.

Em todo caso, o protocolo Git é relativamente fácil de configurar. Basicamente, você precisa executar este comando:

	git daemon --reuseaddr --base-path=/opt/git/ /opt/git/

`--reuseaddr` permite que o servidor reinicie sem esperar que conexões antigas atinjam um tempo limite, a opção `--base-path` permite que as pessoas clonem projetos sem especificar o caminho inteiro, e o caminho no final (`/opt/git/`) diz ao serviço Git onde procurar os repositórios para exportar. Se você estiver protegido por um firewall, você também vai precisar liberar a porta 9418 no computador em que estiver rodando o serviço Git.

Você pode iniciar este processo de diversas maneiras, dependendo do sistema operacional que você estiver usando. Em uma máquina Ubuntu, você pode usar um script Upstart. Por exemplo, neste arquivo

	/etc/event.d/local-git-daemon

você pode colocar este script:

	start on startup
	stop on shutdown
	exec /usr/bin/git daemon \
	    --user=git --group=git \
	    --reuseaddr \
	    --base-path=/opt/git/ \
	    /opt/git/
	respawn

Por razões de segurança, é altamente recomendável ter este serviço executado com um usuário com permissões de somente leitura para os repositórios – você pode fazer isso criando um novo usuário 'git-ro' e executar o serviço com ele. Por uma questão de simplicidade, vamos executá-lo com o usuário 'git', o mesmo que o Gitosis utiliza.

Quando você reiniciar sua máquina, seu serviço Git será iniciado automaticamente e reiniciará automaticamente se ele parar por algum motivo. Para executá-lo sem ter que reiniciar sua máquina, você pode usar este comando:

	initctl start local-git-daemon

Em outro Sistema Operacional, talvez você queira usar o `xinetd`, um script em seu sistema `sysvinit`, ou qualquer outra coisa — contanto que você tenha o serviço Git rodando e monitorado de alguma forma.

A seguir, você tem que configurar seu servidor Gitosis para permitir o acesso não autenticado aos repositórios Git. Se você adicionar uma seção para cada repositório, você pode especificar quais você quer que seu serviço Git tenha permissão de leitura. Se quiser permitir o acesso para o seu projeto para iphone usando o protocolo Git, acrescente no final do arquivo `gitosis.conf`:

	[repo iphone_project]
	daemon = yes

Quando você fizer um commit e um push neste projeto, seu serviço em execução deve começar a servir os pedidos para o projeto a qualquer um que tenha acesso à porta 9418 em seu servidor.

Se você decidir não usar Gitosis, mas quer configurar um servidor Git, você terá que executar isso em cada projeto que você deseje que o serviço Git disponibilize:

	$ cd /path/to/project.git
	$ touch git-daemon-export-ok

A presença desse arquivo diz ao Git que ele pode servir esse projeto sem autenticação.

Gitosis também pode controlar que projetos o GitWeb irá mostrar. Primeiro, você precisa adicionar algo como o seguinte no arquivo `/etc/gitweb.conf`:

	$projects_list = "/home/git/gitosis/projects.list";
	$projectroot = "/home/git/repositories";
	$export_ok = "git-daemon-export-ok";
	@git_base_url_list = ('git://gitserver');

Você pode controlar quais projetos GitWeb permite aos usuários navegar, adicionando ou removendo uma configuração `gitweb` no arquivo de configuração Gitosis. Por exemplo, se você deseja que o projeto do iPhone apareça no GitWeb, você pode definir a opção `repo` como abaixo:

	[repo iphone_project]
	daemon = yes
	gitweb = yes

Agora, se você fizer um commit e um push neste projeto, GitWeb automaticamente começará a mostrar seu projeto iphone.

## Git Hospedado ##

Se você não quer passar por todo o trabalho envolvido na configuração de seu próprio servidor Git, você tem várias opções para hospedar seus projetos Git em um site externo de hospedagem dedicado. Estes sites oferecem uma série de vantagens: um site de hospedagem geralmente é rápido de configurar e facilita a criação de projetos e não envolve a manutenção do servidor ou monitoramento. Mesmo que você configure e execute seu próprio servidor internamente, você ainda pode querer usar um site público de hospedagem para o seu código fonte aberto — é geralmente mais fácil para a comunidade de código aberto encontrá-lo e ajudá-lo.

Nos dias de hoje, você tem um grande número de opções de hospedagem para escolher, cada um com diferentes vantagens e desvantagens. Para ver uma lista atualizada, veja a página GitHosting na wiki principal do Git:

	http://git.or.cz/gitwiki/GitHosting

Como não podemos cobrir todos eles, e porque eu trabalho em um deles, vamos usar esta seção para ensiná-lo a criar uma conta e um novo projeto no GitHub. Isso lhe dará uma ideia do que está envolvido no processo.

GitHub é de longe o maior site open source de hospedagem Git e também é um dos poucos que oferecem hospedagens públicas e privadas para que você possa manter o seu código aberto ou privado no mesmo lugar. Na verdade, nós usamos a GitHub privado para colaborar com esse livro.

### GitHub ###

GitHub é um pouco diferente do que a maioria dos sites de hospedagem de código na maneira que gerencia projetos. Em vez de ser baseada principalmente no projeto, GitHub é centrado no usuário. Isso significa que quando eu hospedar meu projeto `grit` no GitHub, você não vai encontrá-lo em `github.com/grit` mas em `github.com/schacon/grit`. Não há versão canônica de qualquer projeto, o que permite que um projeto possa se deslocar de um usuário para outro se o primeiro autor abandonar o projeto.

GitHub também é uma empresa comercial que cobra para contas que mantêm repositórios privados, mas qualquer um pode rapidamente obter uma conta gratuita para hospedar tantos projetos de código aberto quanto quiser. Nós vamos passar rapidamente sobre como isso é feito.

### Criando uma Conta de Usuário ###

A primeira coisa que você precisa fazer é criar uma conta de usuário gratuita. Se você visitar a página de Preços e Inscrição em `http://github.com/plans` e clivar no botão "Sign Up" na conta gratuita (ver figura 4-2), você é levado à página de inscrição.

Insert 18333fig0402.png
Figure 4-2. A página de planos do GitHub

Aqui você deve escolher um nome de usuário que ainda não foi utilizada no sistema e digitar um endereço de e-mail que será associado com a conta e uma senha (veja a Figura 4-3).

Insert 18333fig0403.png 
Figure 4-3. O formulário de inscrição do GitHub

Se você já possuir, este é um bom momento para adicionar sua chave pública SSH também. Mostramos como gerar uma nova chave antes, na seção "Gerando Sua Chave Pública SSH". Copie o conteúdo da chave pública, e cole-o na caixa de texto "SSH Public Key". Clicando no link "explain ssh keys" irá mostrar instruções detalhadas sobre como fazê-lo em todos os principais sistemas operacionais.
Clicando no botão "I agree, sign me up" levará você ao painel principal de seu novo usuário (ver Figura 4-4).

Insert 18333fig0404.png 
Figure 4-4. O painel principal do usuário do GitHub

Em seguida, você pode criar um novo repositório.

### Criando um Novo Repositório ###

Comece clicando no link "create a new one" ao lado de seus repositórios no painel do usuário. Você é levado para um formulário para criação de um novo repositório (ver Figura 4-5).

Insert 18333fig0405.png 
Figure 4-5. Criando um novo repositório no GitHub

All you really have to do is provide a project name, but you can also add a description. When that is done, click the "Create Repository" button. Now you have a new repository on GitHub (see Figure 4-6).

Tudo o que você realmente tem que fazer é fornecer um nome de projeto, mas você também pode adicionar uma descrição. Quando terminar, clique no botão "Create Repository". Agora você tem um novo repositório no GitHub (ver Figura 4-6).

Insert 18333fig0406.png 
Figure 4-6. Informações de um projeto do GitHub

Já que você não tem nenhum código ainda, GitHub irá mostrar-lhe instruções de como criar um novo projeto, fazer um push de um projeto Git existente, ou importar um projeto de um repositório Subversion público (ver Figura 4-7).

Insert 18333fig0407.png 
Figure 4-7. Instrução para novos repositórios

Estas instruções são semelhantes ao que nós já vimos. Para inicializar um projeto se já não é um projeto Git, você usa

	$ git init
	$ git add .
	$ git commit -m 'initial commit'

Quando você tem um repositório Git local, adicione GitHub como um remoto e faça um push do branch master:

	$ git remote add origin git@github.com:testinguser/iphone_project.git
	$ git push origin master

Agora seu projeto está hospedado no GitHub, e você pode dar o URL para quem você quiser compartilhar seu projeto. Neste caso, é `http://github.com/testinguser/iphone_project`. Você também pode ver a partir do cabeçalho em cada uma das páginas do seu projeto que você tem duas URLs Git (ver Figura 4-8).

Insert 18333fig0408.png 
Figure 4-8. Cabeçalho do projeto com uma URL pública e outra privada

A URL pública é uma URL Git somente leitura sobre a qual qualquer um pode clonar o projeto. Sinta-se a vontade para dar essa URL e postá-la em seu site ou qualquer outro lugar.

A URL privada é uma URL para leitura/gravação baseada em SSH que você pode usar para ler ou escrever apenas se tiver a chave SSH privada associada a chave pública que você carregou para o seu usuário. Quando outros usuários visitarem esta página do projeto, eles não vão ver a URL privada.

### Importando do Subversion ###

Se você tem um projeto Subversion público existente que você deseja importar para o Git, GitHub muitas vezes pode fazer isso por você. Na parte inferior da página de instruções há um link para importação do Subversion. Se você clicar nele, você verá um formulário com informações sobre o processo de importação e uma caixa de texto onde você pode colar a URL do seu projeto Subversion público (ver Figura 4-9).

Insert 18333fig0409.png 
Figure 4-9. Interface de importação do Subversion

Se o seu projeto é muito grande, fora do padrão, ou privada, esse processo provavelmente não vai funcionar para você. No Capítulo 7, você vai aprender como fazer a importação de projetos mais complicados manualmente.

### Adicionando Colaboradores ###

Vamos adicionar o resto da equipe. Se John, Josie, e Jessica se inscreverem no GitHub, e você quer dar a eles permissão de escrita em seu repositório, você pode adicioná-los ao seu projeto como colaboradores. Isso permitirá que eles façam pushes a partir de suas chaves públicas.

Clique no botão "editar" no cabeçalho do projeto ou na guia Admin no topo do projeto para chegar à página de administração do seu projeto GitHub (ver Figura 4-10).

Insert 18333fig0410.png 
Figure 4-10. Página de administração do GitHub

Para dar a outro usuário acesso de escrita ao seu projeto, clique no link “Add another collaborator”. Uma nova caixa de texto aparece, no qual você pode digitar um nome de usuário. Conforme você digita, um ajudante aparece, mostrando a você nomes de usuários possíveis. Quando você encontrar o usuário correto, clique no botão Adicionar para adicionar o usuário como colaborador em seu projeto (ver Figura 4-11).

Insert 18333fig0411.png 
Figure 4-11. Adicionando um colaborador a seu projeto

Quando você terminar de adicionar colaboradores, você deve ver uma lista deles na caixa de colaboradores do repositório (ver Figura 4-12).

Insert 18333fig0412.png 
Figure 4-12. Uma lista de colaboradores em seu projeto

Se você precisar revogar acesso às pessoas, você pode clicar no link "revoke", e seus acessos de escrita serão removidos. Para projetos futuros, você também pode copiar grupos de colaboradores ao copiar as permissões de um projeto existente.

### Seu Projeto ###

Depois de fazer um push no seu projeto ou tê-lo importado do Subversion, você tem uma página principal do projeto que é algo como Figura 4-13.

Insert 18333fig0413.png 
Figure 4-13. A página principal do projeto no GitHub

Quando as pessoas visitam o seu projeto, elas veem esta página. Ela contém guias para diferentes aspectos de seus projetos. A guia Commits mostra uma lista de commits em ordem cronológica inversa, semelhante à saída do comando `git log`. A guia Network mostra todas as pessoas que criaram um fork do seu projeto e contribuíram para nele. A guia Downloads permite que você faça upload de arquivos binários e crie links para tarballs e versões compactadas de todas as versões de seu projeto. A guia Wiki fornece uma wiki onde você pode escrever documentação ou outras informações sobre o projeto. A guia Graphs tem algumas visualizações e estatísticas de contribuições sobre o seu projeto. A guia Source mostra uma listagem de diretório principal de seu projeto e processa automaticamente o arquivo README abaixo se você tiver um. Essa guia também mostra uma caixa com a informação do commit mais recente.

### Criando Forks de Projetos ###

Se você quiser contribuir para um projeto existente para o qual você não tem permissão de push, GitHub incentiva s utilização de forks do projeto. Quando você acessar uma página de um projeto que parece interessante e você quiser fazer alguma mudança nele, você pode clicar no botão "fork" no cabeçalho do projeto para que o GitHub copie o projeto para o seu usuário para que você possa editá-lo.

Dessa forma, os projetos não têm que se preocupar com a adição de usuários como colaboradores para dar-lhes acesso de escrita. As pessoas podem criar um fork de um projeto e fazer um push nele, e o mantenedor do projeto principal pode fazer um pull dessas mudanças, adicionando-as como remotos e fazendo um merge no seu projeto.

Para fazer um fork de um projeto, visite a página do projeto (neste caso, mojombo/chronic) e clique no botão "fork" no cabeçalho (ver Figura 4-14).

Insert 18333fig0414.png 
Figure 4-14. Obtenha uma cópia de um projeto, que pode ser modificada, clicando no botão "fork".

Depois de alguns segundos, você é levado à página do seu novo projeto, o que indica que este projeto é um fork de outro (ver Figura 4-15).

Insert 18333fig0415.png 
Figure 4-15. Seu fork de um projeto

### Sumário do GitHub ###

Isso é tudo o que nós vamos cobrir acerca do GitHub, mas é importante notar o quão rápido você pode fazer tudo isso. Você pode criar uma conta, adicionar um novo projeto, e fazer um push nele em questão de minutos. Se o seu projeto é de código aberto, você também terá uma grande comunidade de desenvolvedores, que agora têm visibilidade de seu projeto e podem fazer forks e ajudar contribuindo. No mínimo, isso pode ser uma maneira de usar o Git e experimentá-lo rapidamente.

## Sumário ##

Você tem várias opções para obter um repositório Git remoto instalado e funcionando para que você possa colaborar com outras pessoas ou compartilhar seu trabalho.

Executando o seu próprio servidor lhe dá um grande controle e permite que você execute o servidor dentro do seu próprio firewall, mas tal servidor geralmente requer uma boa quantidade de seu tempo para configurar e manter. Se você colocar seus dados em um servidor hospedado, é fácil de configurar e manter, no entanto, você tem que ser capaz de manter o seu código em servidores de outra pessoa, e algumas organizações não permitem isso.

Deve ser bastante simples determinar qual a solução ou a combinação de soluções é adequado para você e sua organização.
