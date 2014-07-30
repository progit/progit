# Primeiros passos #

Esse capítulo trata dos primeiros passos usando o Git. Inicialmente explicaremos alguns fundamentos sobre ferramentas de controle de versão, passaremos ao tópico de como instalar o Git no seu sistema e finalmente como configurá-lo para começar a trabalhar. Ao final do capítulo você entenderá porque o Git é muito utilizado, porque usá-lo e como usá-lo.

## Sobre Controle de Versão ##

O que é controle de versão, e por que você deve se importar? O controle de versão é um sistema que registra as mudanças feitas em um arquivo ou um conjunto de arquivos ao longo do tempo de forma que você possa recuperar versões específicas. Mesmo que os exemplos desse livro mostrem arquivos de código fonte sob controle de versão, você pode usá-lo com praticamente qualquer tipo de arquivo em um computador.

Se você é um designer gráfico ou um web designer e quer manter todas as versões de uma imagem ou layout (o que você certamente gostaria), usar um Sistema de Controle de Versão (Version Control System ou VCS) é uma decisão sábia. Ele permite reverter arquivos para um estado anterior, reverter um projeto inteiro para um estado anterior, comparar mudanças feitas ao decorrer do tempo, ver quem foi o último a modificar algo que pode estar causando problemas, quem introduziu um bug e quando, e muito mais. Usar um VCS normalmente significa que se você estragou algo ou perdeu arquivos, poderá facilmente reavê-los. Além disso, você pode controlar tudo sem maiores esforços.

### Sistemas de Controle de Versão Locais ###

O método preferido de controle de versão por muitas pessoas é copiar arquivos em outro diretório (talvez um diretório com data e hora, se forem espertos). Esta abordagem é muito comum por ser tão simples, mas é também muito suscetível a erros. É fácil esquecer em qual diretório você está e gravar acidentalmente no arquivo errado ou sobrescrever arquivos sem querer.

Para lidar com esse problema, alguns programadores desenvolveram há muito tempo VCSs locais que armazenavam todas as alterações dos arquivos sob controle de revisão (ver Figura 1-1).

Insert 18333fig0101.png
Figura 1-1. Diagrama de controle de versão local.

Uma das ferramentas de VCS mais populares foi um sistema chamado rcs, que ainda é distribuído em muitos computadores até hoje. Até o popular Mac OS X inclui o comando rcs quando se instala o kit de ferramentas para desenvolvedores. Basicamente, essa ferramenta mantém conjuntos de patches (ou seja, as diferenças entre os arquivos) entre cada mudança em um formato especial; a partir daí qualquer arquivo em qualquer ponto na linha do tempo pode ser recriado ao juntar-se todos os patches.

### Sistemas de Controle de Versão Centralizados ###

Outro grande problema que as pessoas encontram estava na necessidade de trabalhar em conjunto com outros desenvolvedores, que usam outros sistemas. Para lidar com isso, foram desenvolvidos Sistemas de Controle de Versão Centralizados (Centralized Version Control System ou CVCS). Esses sistemas, como por exemplo o CVS, Subversion e Perforce, possuem um único servidor central que contém todos os arquivos versionados e vários clientes que podem resgatar (check out) os arquivos do servidor. Por muitos anos, esse foi o modelo padrão para controle de versão.

Insert 18333fig0102.png
Figura 1-2. Diagrama de Controle de Versão Centralizado.

Tal arranjo oferece muitas vantagens, especialmente sobre VCSs locais. Por exemplo, todo mundo pode ter conhecimento razoável sobre o que os outros desenvolvedores estão fazendo no projeto. Administradores têm controle específico sobre quem faz o quê; sem falar que é bem mais fácil administrar um CVCS do que lidar com bancos de dados locais em cada cliente.

Entretanto, esse arranjo também possui grandes desvantagens. O mais óbvio é que o servidor central é um ponto único de falha. Se o servidor ficar fora do ar por uma hora, ninguém pode trabalhar em conjunto ou salvar novas versões dos arquivos durante esse período. Se o disco do servidor do banco de dados for corrompido e não existir um backup adequado, perde-se tudo — todo o histórico de mudanças no projeto, exceto pelas únicas cópias que os desenvolvedores possuem em suas máquinas locais. VCSs locais também sofrem desse problema — sempre que se tem o histórico em um único local, corre-se o risco de perder tudo.

### Sistemas de Controle de Versão Distribuídos ###

É aí que surgem os Sistemas de Controle de Versão Distribuídos (Distributed Version Control System ou DVCS). Em um DVCS (tais como Git, Mercurial, Bazaar ou Darcs), os clientes não apenas fazem cópias das últimas versões dos arquivos: eles são cópias completas do repositório. Assim, se um servidor falha, qualquer um dos repositórios dos clientes pode ser copiado de volta para o servidor para restaurá-lo. Cada checkout (resgate) é na prática um backup completo de todos os dados (veja Figura 1-3).

Insert 18333fig0103.png
Figura 1-3. Diagrama de Controle de Versão Distribuído.

Além disso, muitos desses sistemas lidam muito bem com o aspecto de ter vários repositórios remotos com os quais eles podem colaborar, permitindo que você trabalhe em conjunto com diferentes grupos de pessoas, de diversas maneiras, simultaneamente no mesmo projeto. Isso permite que você estabeleça diferentes tipos de workflow (fluxo de trabalho) que não são possíveis em sistemas centralizados, como por exemplo o uso de modelos hierárquicos.

## Uma Breve História do Git ##

Assim como muitas coisas boas na vida, o Git começou com um tanto de destruição criativa e controvérsia acirrada. O kernel (núcleo) do Linux é um projeto de software de código aberto de escopo razoavelmente grande. Durante a maior parte do período de manutenção do kernel do Linux (1991-2002), as mudanças no software eram repassadas como patches e arquivos compactados. Em 2002, o projeto do kernel do Linux começou a usar um sistema DVCS proprietário chamado BitKeeper.

Em 2005, o relacionamento entre a comunidade que desenvolvia o kernel e a empresa que desenvolvia comercialmente o BitKeeper se desfez, e o status de isento-de-pagamento da ferramenta foi revogado. Isso levou a comunidade de desenvolvedores do Linux (em particular Linus Torvalds, o criador do Linux) a desenvolver sua própria ferramenta baseada nas lições que eles aprenderam ao usar o BitKeeper. Alguns dos objetivos do novo sistema eram:

* Velocidade
* Design simples
* Suporte robusto a desenvolvimento não linear (milhares de branches paralelos)
* Totalmente distribuído
* Capaz de lidar eficientemente com grandes projetos como o kernel do Linux (velocidade e volume de dados)

Desde sua concepção em 2005, o Git evoluiu e amadureceu a ponto de ser um sistema fácil de usar e ainda assim mantém essas qualidades iniciais. É incrivelmente rápido, bastante eficiente com grandes projetos e possui um sistema impressionante de branching para desenvolvimento não-linear (Veja no Capítulo 3).

## Noções Básicas de Git ##

Enfim, em poucas palavras, o que é Git? Essa é uma seção importante para assimilar, pois se você entender o que é Git e os fundamentos de como ele funciona, será muito mais fácil utilizá-lo de forma efetiva. À medida que você aprende a usar o Git, tente não pensar no que você já sabe sobre outros VCSs como Subversion e Perforce; assim você consegue escapar de pequenas confusões que podem surgir ao usar a ferramenta. Apesar de possuir uma interface parecida, o Git armazena e pensa sobre informação de uma forma totalmente diferente desses outros sistemas; entender essas diferenças lhe ajudará a não ficar confuso ao utilizá-lo.

### Snapshots, E Não Diferenças  ###

A maior diferença entre Git e qualquer outro VCS (Subversion e similares inclusos) está na forma que o Git trata os dados. Conceitualmente, a maior parte dos outros sistemas armazena informação como uma lista de mudanças por arquivo. Esses sistemas (CVS, Subversion, Perforce, Bazaar, etc.) tratam a informação que mantém como um conjunto de arquivos e as mudanças feitas a cada arquivo ao longo do tempo, conforme ilustrado na Figura 1.4.

Insert 18333fig0104.png
Figura 1-4. Outros sistemas costumam armazenar dados como mudanças em uma versão inicial de cada arquivo.

Git não pensa ou armazena sua informação dessa forma. Ao invés disso, o Git considera que os dados são como um conjunto de snapshots (captura de algo em um determinado instante, como em uma foto) de um mini-sistema de arquivos. Cada vez que você salva ou consolida (commit) o estado do seu projeto no Git, é como se ele tirasse uma foto de todos os seus arquivos naquele momento e armazenasse uma referência para essa captura. Para ser eficiente, se nenhum arquivo foi alterado, a informação não é armazenada novamente - apenas um link para o arquivo idêntico anterior que já foi armazenado. A figura 1-5 mostra melhor como o Git lida com seus dados.

Insert 18333fig0105.png
Figura 1-5. Git armazena dados como snapshots do projeto ao longo do tempo.

Essa é uma distinção importante entre Git e quase todos os outros VCSs. Isso leva o Git a reconsiderar quase todos os aspectos de controle de versão que os outros sistemas copiaram da geração anterior. Também faz com que o Git se comporte mais como um mini-sistema de arquivos com algumas poderosas ferramentas construídas em cima dele, ao invés de simplesmente um VCS. Nós vamos explorar alguns dos benefícios que você tem ao lidar com dados dessa forma, quando tratarmos do assunto de branching no Capítulo 3.

### Quase Todas Operações São Locais ###

A maior parte das operações no Git precisam apenas de recursos e arquivos locais para operar — geralmente nenhuma outra informação é necessária de outro computador na sua rede. Se você está acostumado a um CVCS onde a maior parte das operações possui latência por conta de comunicação com a rede, esse aspecto do Git fará com que você pense que os deuses da velocidade abençoaram o Git com poderes sobrenaturais. Uma vez que você tem todo o histórico do projeto no seu disco local, a maior parte das operações parece ser quase instantânea.

Por exemplo, para navegar no histórico do projeto, o Git não precisa requisitar ao servidor o histórico para que possa apresentar a você — ele simplesmente lê diretamente de seu banco de dados local. Isso significa que você vê o histórico do projeto quase instantaneamente. Se você quiser ver todas as mudanças introduzidas entre a versão atual de um arquivo e a versão de um mês atrás, o Git pode buscar o arquivo de um mês atrás e calcular as diferenças localmente, ao invés de ter que requisitar ao servidor que faça o cálculo, ou puxar uma versão antiga do arquivo no servidor remoto para que o cálculo possa ser feito localmente.

Isso também significa que há poucas coisas que você não possa fazer caso esteja offline ou sem acesso a uma VPN. Se você entrar em um avião ou trem e quiser trabalhar, você pode fazer commits livre de preocupações até ter acesso a rede novamente para fazer upload. Se você estiver indo para casa e seu cliente de VPN não estiver funcionando, você ainda pode trabalhar. Em outros sistemas, fazer isso é impossível ou muito trabalhoso. No Perforce, por exemplo, você não pode fazer muita coisa quando não está conectado ao servidor; e no Subversion e CVS, você pode até editar os arquivos, mas não pode fazer commits das mudanças já que sua base de dados está offline. Pode até parecer que não é grande coisa, mas você pode se surpreender com a grande diferença que pode fazer.

### Git Tem Integridade ###

Tudo no Git tem seu checksum (valor para verificação de integridade) calculado antes que seja armazenado e então passa a ser referenciado pelo checksum. Isso significa que é impossível mudar o conteúdo de qualquer arquivo ou diretório sem que o Git tenha conhecimento. Essa funcionalidade é parte fundamental do Git e é integral à sua filosofia. Você não pode perder informação em trânsito ou ter arquivos corrompidos sem que o Git seja capaz de detectar.

O mecanismo que o Git usa para fazer o checksum é chamado de hash SHA-1, uma string de 40 caracteres composta de caracteres hexadecimais (0-9 e a-f) que é calculado a partir do conteúdo de um arquivo ou estrutura de um diretório no Git. Um hash SHA-1 parece com algo mais ou menos assim:

    24b9da6552252987aa493b52f8696cd6d3b00373

Você vai encontrar esses hashes em todo canto, uma vez que Git os utiliza tanto. Na verdade, tudo que o Git armazena é identificado não por nome do arquivo mas pelo valor do hash do seu conteúdo.

### Git Geralmente Só Adiciona Dados ###

Dentre as ações que você pode realizar no Git, quase todas apenas acrescentam dados à base do Git. É muito difícil fazer qualquer coisa no sistema que não seja reversível ou remover dados de qualquer forma. Assim como em qualquer VCS, você pode perder ou bagunçar mudanças que ainda não commitou; mas depois de fazer um commit de um snapshot no Git, é muito difícil que você o perca, especialmente se você frequentemente joga suas mudanças para outro repositório.

Isso faz com que o uso do Git seja uma alegria no sentido de permitir que façamos experiências sem o perigo de causar danos sérios. Para uma análise mais detalhada de como o Git armazena seus dados e de como você pode recuperar dados que parecem ter sido perdidos, veja o Capítulo 9.

### Os Três Estados ###

Agora preste atenção. Essa é a coisa mais importante pra se lembrar sobre Git se você quiser que o resto do seu aprendizado seja tranquilo. Git faz com que seus arquivos sempre estejam em um dos três estados fundamentais: consolidado (committed), modificado (modified) e preparado (staged). Dados são ditos consolidados quando estão seguramente armazenados em sua base de dados local. Modificado trata de um arquivo que sofreu mudanças mas que ainda não foi consolidado na base de dados. Um arquivo é tido como preparado quando você marca um arquivo modificado em sua versão corrente para que ele faça parte do snapshot do próximo commit (consolidação).

Isso nos traz para as três seções principais de um projeto do Git: o diretório do Git (git directory, repository), o diretório de trabalho (working directory), e a área de preparação (staging area).

Insert 18333fig0106.png
Figura 1-6. Diretório de trabalho, área de preparação, e o diretório do Git.

O diretório do Git é o local onde o Git armazena os metadados e o banco de objetos de seu projeto. Esta é a parte mais importante do Git, e é a parte copiada quando você clona um repositório de outro computador.

O diretório de trabalho é um único checkout de uma versão do projeto. Estes arquivos são obtidos a partir da base de dados comprimida no diretório do Git e colocados em disco para que você possa utilizar ou modificar.

A área de preparação é um simples arquivo, geralmente contido no seu diretório Git, que armazena informações sobre o que irá em seu próximo commit. É bastante conhecido como índice (index), mas está se tornando padrão chamá-lo de área de preparação.

O workflow básico do Git pode ser descrito assim:

1. Você modifica arquivos no seu diretório de trabalho.
2. Você seleciona os arquivos, adicionando snapshots deles para sua área de preparação.
3. Você faz um commit, que leva os arquivos como eles estão na sua área de preparação e os armazena permanentemente no seu diretório Git.

Se uma versão particular de um arquivo está no diretório Git, é considerada consolidada. Caso seja modificada mas foi adicionada à área de preparação, está preparada. E se foi alterada desde que foi obtida mas não foi preparada, está modificada. No Capítulo 2, você aprenderá mais sobre estes estados e como se aproveitar deles ou pular toda a parte de preparação.

## Instalando Git ##

Vamos entender como utilizar o Git. Primeiramente você deve instalá-lo. Você pode obtê-lo de diversas formas; as duas mais comuns são instalá-lo a partir do fonte ou instalar um package (pacote) existente para sua plataforma.

### Instalando a Partir do Fonte ###

Caso você possa, é geralmente útil instalar o Git a partir do fonte, porque será obtida a versão mais recente. Cada versão do Git tende a incluir melhoras na UI, sendo assim, obter a última versão é geralmente o melhor caminho caso você sinta-se confortável em compilar o software a partir do fonte. Também acontece que diversas distribuições Linux contêm pacotes muito antigos; sendo assim, a não ser que você tenha uma distro (distribuição) muito atualizada ou está utilizando backports, instalar a partir do fonte pode ser a melhor aposta.

Para instalar o Git, você precisa ter as seguintes bibliotecas que o Git depende: curl, zlib, openssl, expat e libiconv. Por exemplo, se você usa um sistema que tem yum (tal como o Fedora) ou apt-get (tais como os sistemas baseados no Debian), você pode utilizar um desses comandos para instalar todas as dependências:

    $ yum install curl-devel expat-devel gettext-devel \
      openssl-devel zlib-devel

    $ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
      libz-dev libssl-dev
    
Quando você tiver todas as dependências necessárias, você pode continuar e baixar o snapshot mais recente a partir do web site do Git:

    http://git-scm.com/download
    
Então, compilá-lo e instalá-lo:

    $ tar -zxf git-1.7.2.2.tar.gz
    $ cd git-1.7.2.2
    $ make prefix=/usr/local all
    $ sudo make prefix=/usr/local install

Após a conclusão, você também pode obter o Git via o próprio Git para atualizações:

    $ git clone git://git.kernel.org/pub/scm/git/git.git
    
### Instalando no Linux ###

Se você quiser instalar o Git no Linux via um instalador binário, você pode fazê-lo com a ferramenta de gerenciamento de pacotes (packages) disponível na sua distribuição. Caso você esteja no Fedora, você pode usar o yum:

    $ yum install git-core

Ou se você estiver em uma distribuição baseada no Debian, como o Ubuntu, use o apt-get:

    $ apt-get install git

### Instalando no Mac ###

Existem duas formas fáceis de se instalar Git em um Mac. A mais fácil delas é usar o instalador gráfico do Git, que você pode baixar da página do SourceForge (veja Figura 1-7):

    http://sourceforge.net/projects/git-osx-installer/

Insert 18333fig0107.png
Figura 1-7. Instalador Git OS X.

A outra forma comum é instalar o Git via MacPorts (`http://www.macports.org`). Se você tem o MacPOrts instalado, instale o Git via

    $ sudo port install git-core +svn +doc +bash_completion +gitweb

Você não precisa adicionar todos os extras, mas você provavelmente irá querer incluir o +svn caso você tenha que usar o Git com repositórios Subversion (veja Capítulo 8).

### Instalando no Windows ###

Instalar o Git no Windows é muito fácil. O projeto msysgit tem um dos procedimentos mais simples de instalação. Simplesmente baixe o arquivo exe do instalador a partir da página do GitHub e execute-o:

    http://msysgit.github.com

Após concluir a instalação, você terá tanto uma versão command line (linha de comando, incluindo um cliente SSH que será útil depois) e uma GUI padrão.

## Configuração Inicial do Git ##

Agora que você tem o Git em seu sistema, você pode querer fazer algumas coisas para customizar seu ambiente Git. Você só precisa fazer uma vez; as configurações serão mantidas entre atualizações. Você também poderá alterá-las a qualquer momento executando os comandos novamente.

Git vem com uma ferramenta chamada git config que permite a você ler e definir variáveis de configuração que controlam todos os aspectos de como o Git parece e opera. Essas variáveis podem ser armazenadas em três lugares diferentes:

* arquivo `/etc/gitconfig`: Contém valores para todos usuários do sistema e todos os seus repositórios. Se você passar a opção `--system` para `git config`, ele lerá e escreverá a partir deste arquivo especificamente.
* arquivo `~/.gitconfig`: É específico para seu usuário. Você pode fazer o Git ler e escrever a partir deste arquivo especificamente passando a opção `--global`.
* arquivo de configuração no diretório git (ou seja, `.git/config`) de qualquer repositório que você está utilizando no momento: Específico para aquele único repositório. Cada nível sobrepõem o valor do nível anterior, sendo assim valores em `.git/config` sobrepõem aqueles em `/etc/gitconfig`.

Em sistemas Windows, Git procura pelo arquivo `.gitconfig` no diretório `$HOME` (`C:\Documents and Settins\$USER` para a maioria das pessoas). Também procura por /etc/gitconfig, apesar de que é relativo à raiz de MSys, que é o local onde você escolheu instalar o Git no seu sistema Windows quando executou o instalador.

### Sua Identidade ###

A primeira coisa que você deve fazer quando instalar o Git é definir o seu nome de usuário e endereço de e-mail. Isso é importante porque todos os commits no Git utilizam essas informações, e está imutavelmente anexado nos commits que você realiza:

    $ git config --global user.name "John Doe"
    $ git config --global user.email johndoe@example.com

Relembrando, você só precisará fazer isso uma vez caso passe a opção `--global`, pois o Git sempre usará essa informação para qualquer coisa que você faça nesse sistema. Caso você queira sobrepor estas com um nome ou endereço de e-mail diferentes para projetos específicos, você pode executar o comando sem a opção `--global` quando estiver no próprio projeto.

### Seu Editor ###

Agora que sua identidade está configurada, você pode configurar o editor de texto padrão que será utilizado quando o Git precisar que você digite uma mensagem. Por padrão, Git usa o editor padrão do sistema, que é geralmente Vi ou Vim. Caso você queira utilizar um editor diferente, tal como o Emacs, você pode executar o seguinte:

    $ git config --global core.editor emacs
    
### Sua Ferramenta de Diff ###

Outra opção útil que você pode querer configurar é a ferramente padrão de diff utilizada para resolver conflitos de merge (fusão). Digamos que você queira utilizar o vimdiff:

    $ git config --global merge.tool vimdiff

Git aceita kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge e opendiff como ferramentas válidas para merge. Você também pode configurar uma ferramenta personalizada; veja o Capítulo 7 para maiores informações em como fazê-lo.

### Verificando Suas Configurações ###

Caso você queira verificar suas configurações, você pode utilizar o comando `git config --list` para listar todas as configurações que o Git encontrar naquele momento:

    $ git config --list
    user.name=Scott Chacon
    user.email=schacon@gmail.com
    color.status=auto
    color.branch=auto
    color.interactive=auto
    color.diff=auto
    ...

Você pode ver algumas chaves mais de uma vez, porque o Git lê as mesmas chaves em diferentes arquivos (`/etc/gitconfig` e `~/.gitconfig`, por exemplo). Neste caso, Git usa o último valor para cada chave única que é obtida.

Você também pode verificar qual o valor que uma determinada chave tem para o Git digitando `git config {key}`:

    $ git config user.name
    Scott Chacon

## Obtendo Ajuda ##

Caso você precise de ajuda usando o Git, exitem três formas de se obter ajuda das páginas de manual (manpage) para quaisquer comandos do Git:

    $ git help <verb>
    $ git <verb> --help
    $ man git-<verb>

Por exemplo, você pode obter a manpage para o comando config executando

    $ git help config

Estes comandos são bons porque você pode acessá-los em qualquer lugar, mesmo offline. Caso as manpages e este livro não sejam suficientes e você precise de ajuda pessoalmente, tente os canais `#git` ou `#github` no servidor IRC do Freenode (irc.freenode.net). Esses canais estão regularmente repletos com centenas de pessoas que possuem grande conhecimento sobre Git e geralmente dispostos a ajudar.

## Resumo ##

Você deve ter um entendimento básico do que é Git e suas diferenças em relação ao CVCS que você tem utilizado. Além disso, você deve ter uma versão do Git funcionando em seu sistema que está configurada com sua identidade pessoal. Agora é hora de aprender algumas noções básicas do Git.
