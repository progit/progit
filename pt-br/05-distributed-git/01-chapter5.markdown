# Git Distribuído #

Agora que você tem um repositório Git remoto configurado como um ponto para todos os desenvolvedores compartilharem seu código, e você está familiarizado com os comandos básicos do Git em um fluxo de trabalho local, você vai ver como utilizar alguns dos fluxos de trabalho distribuídos que o Git lhe proporciona.

Neste capítulo, você verá como trabalhar com Git em um ambiente distribuído como colaborador e integrador. Ou seja, você vai aprender como contribuir código para um projeto da melhor forma possível para você e para os responsáveis do projeto, e também como manter um projeto de sucesso com uma grande quantidade de desenvolvedores.

## Fluxos de Trabalho Distribuídos ##

Ao contrário de Sistemas de Controle de Versão Centralizados (CVCSs), a natureza distribuída do Git lhe permite ser muito mais flexível na forma como os desenvolvedores podem colaborar em projetos. Nos sistemas centralizados, cada desenvolvedor é um nó trabalhando de forma mais ou menos igual em um hub (centralizador). No Git, no entanto, cada desenvolvedor é potencialmente nó e hub — ou seja, cada desenvolvedor pode contribuir com código para outros repositórios e ao mesmo tempo pode manter um repositório público em que outros podem basear seu trabalho e que eles podem contribuir. Isso abre uma vasta gama de possibilidades de fluxo de trabalho para o seu projeto e sua equipe, então eu vou cobrir alguns paradigmas mais comuns que se aproveitam dessa flexibilidade. Vou passar as vantagens e possíveis desvantagens de cada configuração, você pode escolher uma para usar ou combinar características de cada uma.

### Fluxo de Trabalho Centralizado ###

Com sistemas centralizados normalmente há apenas um modelo de colaboração, centralizado. Um hub central, ou repositório, pode aceitar o código, e todos sincronizam o seu trabalho com ele. Vários desenvolvedores são nós — consumidores do hub — e sincronizam em um lugar único (ver Figura 5-1).

Insert 18333fig0501.png
Figura 5-1. Fluxo de Trabalho Centralizado.

Isto significa que se dois desenvolvedores clonam o hub e ambos fazem alterações, o primeiro desenvolvedor a dar push de suas alterações pode fazê-lo sem problemas. O segundo desenvolvedor deve fazer merge do trabalho do primeiro antes de dar push, de modo a não substituir as alterações do primeiro desenvolvedor. Isso vale para o Git assim como o Subversion (ou qualquer CVCS), e este modelo funciona perfeitamente no Git.

Se você tem uma equipe pequena ou se já estão confortáveis com um fluxo de trabalho centralizado em sua empresa ou equipe, você pode facilmente continuar usando esse fluxo de trabalho com o Git. Basta criar um único repositório, e dar a todos em sua equipe acesso para dar push; o Git não deixará os usuários sobrescreverem uns aos outros. Se um desenvolvedor clona, faz alterações, e depois tenta dar push enquanto outro desenvolvedor já deu push com novas alterações nesse meio tempo, o servidor irá rejeitar as novas alterações. Ele será informado que está tentando dar push que não permite fast-forward (avanço rápido) e que não será capaz de fazê-lo até que baixe as últimas alterações e faça merge.
Esse fluxo de trabalho é atraente para muita gente porque é um paradigma que muitos estão familiarizados e confortáveis.

### Fluxo de Trabalho do Gerente de Integração ###

Como o Git permite que você tenha múltiplos repositórios remotos, é possível ter um fluxo de trabalho onde cada desenvolvedor tem acesso de escrita a seu próprio repositório público e acesso de leitura a todos os outros. Este cenário, muitas vezes inclui um repositório canônico que representa o projeto "oficial". Para contribuir com esse projeto, você cria o seu próprio clone público do projeto e guarda suas alterações nele. Depois, você pode enviar uma solicitação para o responsável do projeto principal para puxar as suas alterações. Eles podem adicionar o repositório como um repositório remoto, testar localmente as suas alterações, fazer merge em um branch e propagá-las para o repositório principal. O processa funciona da seguinte maneira (veja Figura 5-2):

1. O mantenedor do projeto propaga as alterações para seu repositório público.
2. O desenvolvedor clona o repositório e faz alterações.
3. O desenvolvedor dá push das alterações para sua própria cópia pública.
4. O desenvolvedor envia um e-mail pedindo para o mantenedor puxar as alterações (pull request).
5. O mantenedor adiciona o repositório do desenvolvedor como um repositório remoto e faz merge das alterações localmente.
6. O mantenedor dá push das alterações mescladas para o repositório principal.

Insert 18333fig0502.png
Figura 5-2. Fluxo de trabalho de Gerente de Integração.

Este é um fluxo de trabalho muito comum em sites como GitHub, onde é fácil de fazer uma fork (forquilha ou bifurcação, porque o histórico não-linear é uma árvore) de um projeto e dar push das suas alterações para que todos possam ver. Uma das principais vantagens desta abordagem é que você pode continuar a trabalhar, e o mantenedor do repositório principal pode puxar as alterações a qualquer momento. Desenvolvedores não tem que esperar o projeto incorporar as suas mudanças — cada um pode trabalhar em seu próprio ritmo.

### Fluxo de Trabalho de Ditador e Tenentes ###

Esta é uma variante de um fluxo de trabalho de múltiplos repositórios. É geralmente usado por grandes projetos com centenas de colaboradores. Um exemplo famoso é o kernel do Linux. Vários gerentes de integração são responsáveis ​​por certas partes do repositório, eles são chamados tenentes (liutenants). Todos os tenentes têm um gerente de integração conhecido como o ditador benevolente (benevolent dictator). O repositório do ditador benevolente serve como repositório de referência a partir do qual todos os colaboradores devem se basear. O processo funciona assim (veja Figura 5-3):

1. Desenvolvedores regulares trabalham em seu topic branch e baseiam seu trabalho sobre o `master`. O branch `master` é o do ditador.
2. Tenentes fazem merge dos topic branches dos desenvolvedores em seus `master`.
3. O ditador faz merge dos branches `master` dos tenentes em seu branch `master`.
4. O ditador dá push das alterações de seu `master` para o repositório de referência para que os desenvolvedores possam fazer rebase em cima dele.

Insert 18333fig0503.png
Figura 5-3. Fluxo de Trabalho do Ditador Benevolente.

Este tipo de fluxo de trabalho não é comum, mas pode ser útil em projetos muito grandes ou em ambientes altamente hierárquicos, porque ele permite ao líder do projeto (o ditador) delegar grande parte do trabalho e recolher grandes subconjuntos do código em vários pontos antes de integrar eles.

Estes são alguns fluxos de trabalho comumente utilizados que são possíveis com um sistema distribuído como Git, mas você pode ver que muitas variações são possíveis para se adequar ao seu fluxo de trabalho particular. Agora que você pode (espero eu) determinar qual a combinação de fluxo de trabalho pode funcionar para você, eu vou cobrir alguns exemplos mais específicos de como realizar os principais papéis que compõem os diferentes fluxos.

## Contribuindo Para Um Projeto ##

Você conhece os diferentes fluxos de trabalho que existem, e você deve ter um conhecimento muito bom do uso essencial do Git. Nesta seção, você aprenderá sobre alguns protocolos comuns para contribuir para um projeto.

A principal dificuldade em descrever este processo é o grande número de variações sobre a forma como ele é feito. Porque Git é muito flexível, as pessoas podem e trabalham juntos de muitas maneiras diferentes, é problemático descrever como você deve contribuir com um projeto — cada projeto é um pouco diferente. Algumas das variáveis ​​envolvidas são o tamanho da base de contribuintes ativos, fluxo de trabalho escolhido, permissões e possivelmente o método de contribuição externa.

A primeira variável é o tamanho da base de contribuintes ativos. Quantos usuários estão ativamente contribuindo código para este projeto, e com que frequência? Em muitos casos, você tem dois ou três desenvolvedores com alguns commits por dia ou menos ainda em projetos mais adormecidos. Para as empresas ou projetos realmente grandes, o número de desenvolvedores poderia ser na casa dos milhares, com dezenas ou mesmo centenas de patches chegando todo dia. Isto é importante porque, com mais e mais desenvolvedores, você encontra mais problemas para assegurar que seu código se aplica corretamente ou pode ser facilmente incorporado. As alterações que você faz poderão se tornar obsoletas ou severamente danificadas pelo trabalho que foi incorporado enquanto você estava trabalhando ou quando as alterações estavam esperando para ser aprovadas e aplicadas. Como você pode manter o seu código consistentemente atualizado e suas correções válidas?

A próxima variável é o fluxo de trabalho em uso para o projeto. É centralizado, com cada desenvolvedor tendo acesso igual de escrita ao repositório principal? O projeto tem um mantenedor ou gerente de integração que verifica todos os patches? Todos os patches são revisados e aprovados? Você está envolvido nesse processo? Há um sistema de tenentes, e você tem que enviar o seu trabalho a eles?

A questão seguinte é o seu acesso de commit. O fluxo de trabalho necessário para contribuir para um projeto é muito diferente se você tiver acesso de gravação para o projeto do que se você não tiver. Se você não tem acesso de gravação, como é que o projeto prefere aceitar contribuições? Há uma política sobre essa questão? Quanto trabalho você contribui de cada vez? Com que frequência você contribui?

Todas estas questões podem afetar a forma que você contribui para um projeto e quais fluxos de trabalho são melhores para você. Falarei sobre os aspectos de cada um deles em uma série de casos de uso, movendo-se do mais simples ao mais complexo, você deve ser capaz de construir os fluxos de trabalho específicos que você precisa na prática a partir desses exemplos.

### Diretrizes de Commit ###

Antes de você começar a olhar para os casos de uso específicos, aqui está uma breve nota sobre as mensagens de commit. Ter uma boa orientação para a criação de commits e aderir a ela torna o trabalho com Git e a colaboração com os demais muito mais fácil. O projeto Git fornece um documento que estabelece uma série de boas dicas para a criação de commits para submeter patches — você pode lê-lo no código-fonte do Git no arquivo `Documentation/SubmittingPatches`.

Primeiro, você não quer submeter nenhum problema de espaços em branco (whitespace errors). Git oferece uma maneira fácil de verificar isso — antes de fazer commit, execute `git diff --check` para listar possíveis problemas de espaços em branco. Aqui está um exemplo, onde a cor vermelha no terminal foi substituída por `X`s:

    $ git diff --check
    lib/simplegit.rb:5: trailing whitespace.
    +    @git_dir = File.expand_path(git_dir)XX
    lib/simplegit.rb:7: trailing whitespace.
    + XXXXXXXXXXX
    lib/simplegit.rb:26: trailing whitespace.
    +    def command(git_cmd)XXXX

Se você executar esse comando antes de fazer commit, você pode dizer se você está prestes a fazer commit com problemas de espaços em branco que pode incomodar outros desenvolvedores.

Em seguida, tente fazer de cada commit um conjunto de mudanças (changeset) logicamente separado. Se você puder, tente fazer suas alterações fáceis de lidar — não fique programando um fim de semana inteiro para resolver cinco problemas diferentes e então fazer um commit maciço com todas as alterações na segunda-feira. Mesmo se você não faça commits durante o fim de semana, use a "staging area" na segunda-feira para dividir o seu trabalho em pelo menos um commit por problema, com uma mensagem útil em cada commit. Se algumas das alterações modificarem o mesmo arquivo, tente usar `git add --patch` para preparar partes de arquivos (coberto em detalhes no *Capítulo 6*). O snapshot do projeto no final do branch é idêntico se você fizer um ou cinco commits, desde que todas as mudanças tenham sido adicionadas em algum momento. Então tente tornar as coisas mais fáceis para seus colegas desenvolvedores quando eles tiverem que revisar as suas alterações. Essa abordagem também torna mais fácil puxar ou reverter algum dos changesets se você precisar mais tarde. O *Capítulo 6* descreve uma série de truques úteis do Git para reescrever o histórico e adicionar as alterações de forma interativa — use essas ferramentas para ajudar a construir um histórico limpo e compreensível.

Uma última coisa que precisamos ter em mente é a mensagem de commit. Adquirir o hábito de criar mensagens de commit de qualidade torna o uso e colaboração com Git muito mais fácil. Como regra geral, as suas mensagens devem começar com uma única linha com não mais que cerca de 50 caracteres e que descreve o changeset de forma concisa, seguido por uma linha em branco e uma explicação mais detalhada. O projeto Git exige que a explicação mais detalhada inclua a sua motivação para a mudança e que contraste a sua implementação com o comportamento anterior — esta é uma boa orientação a seguir. Também é uma boa ideia usar o tempo verbal presente da segunda pessoa nestas mensagens. Em outras palavras, utilizar comandos. Ao invés de "Eu adicionei testes para" ou "Adicionando testes para", usar "Adiciona testes para". Esse é um modelo originalmente escrito por Tim Pope em `tpope.net`:

    Breve (50 caracteres ou menos) resumo das mudanças

    Texto explicativo mais detalhado, se necessário. Separe em linhas de
    72 caracteres ou menos. Em alguns contextos a primeira linha é
    tratada como assunto do e-mail e o resto como corpo. A linha em branco
    separando o resumo do corpo é crítica (a não ser que o corpo não seja
    incluído); ferramentas como rebase podem ficar confusas se você usar
    os dois colados.

    Parágrafos adicionais vem após linhas em branco.

     - Tópicos também podem ser usados

     - Tipicamente um hífen ou asterisco é utilizado para marcar tópicos,
       precedidos de um espaço único, com linhas em branco entre eles, mas
       convenções variam nesse item

Se todas as suas mensagens de commit parecerem com essa, as coisas serão bem mais fáceis para você e para os desenvolvedores que trabalham com você. O projeto Git tem mensagens de commit bem formatadas — eu encorajo você a executar `git log --no-merges` lá para ver como um histórico de commits bem formatados se parece.

Nos exemplos a seguir e durante a maior parte desse livro, para ser breve eu não formatarei mensagens dessa forma; em vez disso eu usarei a opção `-m` em `git commit`. Faça como eu digo, não faça como eu faço.

### Pequena Equipe Privada ###

A configuração mais simples que você encontrará é um projeto privado com um ou dois desenvolvedores. Por privado, eu quero dizer código fechado — não acessível para o mundo de fora. Você e os outros desenvolvedores todos têm acesso para dar push de alterações para o repositório.

Nesse ambiente, você pode seguir um fluxo de trabalho similar ao que você usaria com Subversion ou outro sistema centralizado. Você ainda tem as vantagens de coisas como commit offline e facilidade de lidar com branches e merges, mas o fluxo de trabalho pode ser bastante similar; a principal diferença é que merges acontecem no lado do cliente ao invés de no servidor durante o commit. Vamos ver como isso fica quando dois desenvolvedores começam a trabalhar juntos com um repositório compartilhado. O primeiro desenvolvedor, John, clona o repositório, faz alterações e realiza o commit localmente. (Eu estou substituindo as mensagens de protocolo com `...` nesses exemplos para diminuí-los um pouco)

    # Máquina do John
    $ git clone john@githost:simplegit.git
    Initialized empty Git repository in /home/john/simplegit/.git/
    ...
    $ cd simplegit/
    $ vim lib/simplegit.rb
    $ git commit -am 'removed invalid default value'
    [master 738ee87] removed invalid default value
     1 files changed, 1 insertions(+), 1 deletions(-)

O segundo desenvolvedor, Jessica, faz a mesma coisa — clona o repositório e faz um commit:

    # Máquina da Jessica
    $ git clone jessica@githost:simplegit.git
    Initialized empty Git repository in /home/jessica/simplegit/.git/
    ...
    $ cd simplegit/
    $ vim TODO
    $ git commit -am 'add reset task'
    [master fbff5bc] add reset task
     1 files changed, 1 insertions(+), 0 deletions(-)

Agora, Jessica dá push do trabalho dela para o servidor:

    # Máquina da Jessica
    $ git push origin master
    ...
    To jessica@githost:simplegit.git
       1edee6b..fbff5bc  master -> master

John tenta dar push de suas alterações também:

    # Máquina do John
    $ git push origin master
    To john@githost:simplegit.git
     ! [rejected]        master -> master (non-fast forward)
    error: failed to push some refs to 'john@githost:simplegit.git'

John não consegue dar push porque Jessica deu push de outras alterações nesse meio tempo. Isso é especialmente importante de entender se você está acostumado com Subversion porque você irá perceber que dois desenvolvedores não editaram o mesmo arquivo. Enquanto o Subversion faz merge automaticamente no servidor se duas pessoas não editarem o mesmo arquivo, no Git você deve sempre fazer merge dos commits localmente. John tem que baixar as alterações de Jessica e fazer merge antes de poder dar push das alterações:

    $ git fetch origin
    ...
    From john@githost:simplegit
     + 049d078...fbff5bc master     -> origin/master

Nesse ponto, o repositório local de John se parece com a Figura 5-4.

Insert 18333fig0504.png
Figura 5-4. Repositório inicial de John.

John tem uma referência para as alterações que Jessica fez, mas ele tem que fazer merge com seu próprio trabalho para poder dar push das suas próprias alterações:

    $ git merge origin/master
    Merge made by recursive.
     TODO |    1 +
     1 files changed, 1 insertions(+), 0 deletions(-)

O merge funciona — o histórico de commits do John agora se parece com a Figura 5-5.

Insert 18333fig0505.png
Figura 5-5. Repositório do John depois de fazer merge em `origin/master`.

Agora John pode testar seu código para ter certeza que ele ainda funciona, e então ele pode dar push de seu novo trabalho mesclado para o servidor:

    $ git push origin master
    ...
    To john@githost:simplegit.git
       fbff5bc..72bbc59  master -> master

Finalmente, o histórico de commits de John se parece com a Figura 5-6.

Insert 18333fig0506.png
Figura 5-6. O histórico de John depois de ter dado push para o servidor de origem (remote `origin`).

Nesse meio tempo, Jessica tem trabalhado em um "topic branch". Ela criou um "topic branch" chamado `issue54` e fez três commits naquele branch. Ela não baixou as alterações de John ainda, então o histórico de commits dela se parece com a Figura 5-7.

Insert 18333fig0507.png
Figura 5-7. Histórico inicial de commits de Jessica.

Jessica quer sincronizar com John, então ela faz fetch:

    # Máquina da Jessica
    $ git fetch origin
    ...
    From jessica@githost:simplegit
       fbff5bc..72bbc59  master     -> origin/master

Isso baixa o trabalho que John tinha empurrado (push). o histórico de Jessica agora se parece com a Figura 5-8.

Insert 18333fig0508.png
Figura 5-8. O histórico de Jessica depois de baixar as alterações de John.

Jessica pensa que seu "topic branch" está pronto, mas ela quer saber com o que ela precisa fazer merge para poder dar push de seu trabalho. Ela executa `git log` para descobrir:

    $ git log --no-merges origin/master ^issue54
    commit 738ee872852dfaa9d6634e0dea7a324040193016
    Author: John Smith <jsmith@example.com>
    Date:   Fri May 29 16:01:27 2009 -0700

        removed invalid default value

Agora, Jessica pode fazer merge de seu topic branch no branch `master`, fazer merge do trabalho de John (`origin/master`) em seu branch `master` e finalmente dar push para o servidor. Primeiro, ela troca para o seu branch `master` para integrar todo esse trabalho:

    $ git checkout master
    Switched to branch "master"
    Your branch is behind 'origin/master' by 2 commits, and can be fast-forwarded.

Ela pode fazer merge de `origin/master` ou `issue54` primeiro — ambos são upstream (atualizados), então a ordem não importa. O snapshot final deve ser idêntico, não importa a ordem que ela escolher; apenas o histórico será levemente diferente. Ela escolhe fazer merge de `issue54` primeiro:

    $ git merge issue54
    Updating fbff5bc..4af4298
    Fast forward
     README           |    1 +
     lib/simplegit.rb |    6 +++++-
     2 files changed, 6 insertions(+), 1 deletions(-)

Não acontece nenhum problema; como você pode ver, foi um simples fast-forward. Agora Jessica faz merge do trabalho de John (`origin/master`):

    $ git merge origin/master
    Auto-merging lib/simplegit.rb
    Merge made by recursive.
     lib/simplegit.rb |    2 +-
     1 files changed, 1 insertions(+), 1 deletions(-)

Tudo mesclou perfeitamente, e o histórico de Jessica agora se parece com a Figura 5-9.

Insert 18333fig0509.png
Figura 5-9. O histórico de Jessica depois de mesclar as alterações de John.

Agora `origin/master` é acessível através do branch `master` de Jessica, então ela pode perfeitamente dar push (assumindo que John não deu push com novas alterações nesse meio tempo):

    $ git push origin master
    ...
    To jessica@githost:simplegit.git
       72bbc59..8059c15  master -> master

Cada desenvolvedor fez alguns commits e integrou o trabalho do outro com sucesso; veja Figura 5-10.

Insert 18333fig0510.png
Figura 5-10. O histórico de Jessica depois de dar push para o servidor.

Esse é um dos fluxos de trabalho mais simples. Você trabalha um pouco, geralmente em um topic branch, e faz merge em seu branch `master` quando ele estiver pronto para ser integrado. Quando você quiser compartilhar seu trabalho, você faz merge em seu próprio branch `master`, baixa as últimas alterações do servidor com fetch e faz merge de `origin/master` se tiver sido alterado, e então dá push para o branch `master` no servidor. A ordem é semelhante ao mostrado na Figura 5-11.

Insert 18333fig0511.png
Figura 5-11. Sequencia geral dos eventos para um fluxo de trabalho simples para Git com múltiplos desenvolvedores.

### Equipe Privada Gerenciada ###

Nesse cenário, você verá os papéis de contribuinte em grupo privado maior. Você aprenderá como trabalhar em um ambiente onde pequenos grupos colaboram em funcionalidades e então essas contribuições por equipe são integradas por outro grupo.

Vamos dizer que John e Jessica estão trabalhando juntos em uma funcionalidade, enquanto Jessica e Josie estão trabalhando em outra. Nesse caso a empresa está usando um fluxo de trabalho com um gerente de integração onde o trabalho de cada grupo é integrado por apenas alguns engenheiros e o branch `master` do repositório principal pode ser atualizado apenas por esses engenheiros. Nesse cenário, todo o trabalho é feito em equipe e atualizado junto pelos integradores.

Vamos seguir o fluxo de trabalho de Jessica enquanto ela trabalha em suas duas funcionalidades, colaborando em paralelo com dois desenvolvedores diferentes nesse ambiente. Assumindo que ela já clonou seu repositório, ela decide trabalhar no `featureA` primeiro. Ela cria o novo branch para a funcionalidade e faz algum trabalho lá:

    # Máquina da Jessica
    $ git checkout -b featureA
    Switched to a new branch "featureA"
    $ vim lib/simplegit.rb
    $ git commit -am 'add limit to log function'
    [featureA 3300904] add limit to log function
     1 files changed, 1 insertions(+), 1 deletions(-)

Nesse ponto, ela precisa compartilhar seu trabalho com John, então ela dá push dos commits de seu branch `featureA` para o servidor. Jessica não tem acesso para dar push no branch `master` — apenas os integradores tem — então ela dá push das alterações para outro branch para poder colaborar com John:

    $ git push origin featureA
    ...
    To jessica@githost:simplegit.git
     * [new branch]      featureA -> featureA

Jessica avisa John por e-mail que ela deu push de algum trabalho em um branch chamado `featureA` e ele pode olhar ele agora. Enquanto ela espera pelo retorno de John, Jessica decide começar a trabalhar no `featureB` com Josie. Para começar, ela inicia um novo feature branch (branch de funcionalidade), baseando-se no branch `master` do servidor:

    # Máquina da Jessica
    $ git fetch origin
    $ git checkout -b featureB origin/master
    Switched to a new branch "featureB"

Agora, Jessica faz dois commits para o branch `featureB`:

    $ vim lib/simplegit.rb
    $ git commit -am 'made the ls-tree function recursive'
    [featureB e5b0fdc] made the ls-tree function recursive
     1 files changed, 1 insertions(+), 1 deletions(-)
    $ vim lib/simplegit.rb
    $ git commit -am 'add ls-files'
    [featureB 8512791] add ls-files
     1 files changed, 5 insertions(+), 0 deletions(-)

O repositório de Jessica se parece com a Figura 5-12.

Insert 18333fig0512.png
Figura 5-12. O histórico de commits inicial de Jessica.

Ela está pronta para fazer push de seu trabalho, mas recebe um e-mail de Josie avisando que ela já fez um trabalho inicial e que está no servidor no branch `featureBee`. Primeiro Jessica precisa mesclar essas alterações com suas próprias para que ela possa dar push de suas alterações para o servidor. Ela pode então baixar as alterações de Josie com `git fetch`:

    $ git fetch origin
    ...
    From jessica@githost:simplegit
     * [new branch]      featureBee -> origin/featureBee

Jessica pode agora fazer merge em seu trabalho com `git merge`:

    $ git merge origin/featureBee
    Auto-merging lib/simplegit.rb
    Merge made by recursive.
     lib/simplegit.rb |    4 ++++
     1 files changed, 4 insertions(+), 0 deletions(-)

Há um pequeno problema — ela precisa dar push do trabalho mesclado em seu branch `featureB` para o branch `featureBee` no servidor. Ela pode fazer isso especificando o branch local seguido de dois pontos (:) seguido pelo branch remoto para o comando `git push`:

    $ git push origin featureB:featureBee
    ...
    To jessica@githost:simplegit.git
       fba9af8..cd685d1  featureB -> featureBee

Isso é chamado _refspec_. Veja o *Capítulo 9* para uma discussão mais detalhada dos refspecs do Git e coisas diferentes que você pode fazer com eles.

Depois, John diz para Jessica que ele deu push de algumas alterações para o branch `featureA` e pede para ela verificá-las. Ela executa um `git fetch` para puxar essas alterações:

    $ git fetch origin
    ...
    From jessica@githost:simplegit
       3300904..aad881d  featureA   -> origin/featureA

Então, ela pode ver que essas alterações foram modificadas com `git log`:

    $ git log origin/featureA ^featureA
    commit aad881d154acdaeb2b6b18ea0e827ed8a6d671e6
    Author: John Smith <jsmith@example.com>
    Date:   Fri May 29 19:57:33 2009 -0700

        changed log output to 30 from 25

Finalmente, ela faz merge do trabalho de John em seu próprio branch `featureA`:

    $ git checkout featureA
    Switched to branch "featureA"
    $ git merge origin/featureA
    Updating 3300904..aad881d
    Fast forward
     lib/simplegit.rb |   10 +++++++++-
    1 files changed, 9 insertions(+), 1 deletions(-)

Jessica quer melhorar uma coisa, então ela faz um novo commit e dá push de volta para o servidor:

    $ git commit -am 'small tweak'
    [featureA ed774b3] small tweak
     1 files changed, 1 insertions(+), 1 deletions(-)
    $ git push origin featureA
    ...
    To jessica@githost:simplegit.git
       3300904..ed774b3  featureA -> featureA

O histórico de commit de Jessica agora parece com a Figura 5-13.

Insert 18333fig0513.png
Figura 5-13. O histórico de Jessica depois do commit no feature branch.

Jessica, Josie e John informam os integradores que os branches `featureA` e `featureBee` no servidor estão prontos para integração na linha principal. Depois que eles integrarem esses branches na linha principal, baixar (fetch) irá trazer os novos commits mesclados, fazendo o histórico de commit ficar como na Figura 5-14.

Insert 18333fig0514.png
Figura 5-14. O histórico de Jessica depois de mesclar ambos topic branches.

Muitos grupos mudam para Git por causa da habilidade de ter múltiplas equipes trabalhando em paralelo, mesclando diferentes linhas de trabalho mais tarde. A habilidade de partes menores de uma equipe colaborar via branches remotos sem necessariamente ter que envolver ou impedir a equipe inteira é um grande benefício do Git. A sequencia para o fluxo de trabalho que você viu aqui é como mostrado na Figura 5-15.

Insert 18333fig0515.png
Figure 5-15. Sequencia básica desse fluxo de trabalho de equipe gerenciada.

### Pequeno Projeto Público ###

Contribuindo para projetos públicos é um pouco diferente. Você tem que ter permissões para atualizar diretamente branches no projeto, você tem que passar o trabalho para os mantenedores de uma outra forma. O primeiro exemplo descreve como contribuir via forks em hosts Git que suportam criação simples de forks. Os sites de hospedagem repo.or.cz e Github ambos suportam isso, e muitos mantenedores de projetos esperam esse tipo de contribuição. A próxima seção lida com projetos que preferem aceitar patches contribuídos por e-mail.

Primeiro, você provavelmente irá querer clonar o repositório principal, criar um topic branch para o patch ou séries de patch que você planeja contribuir e você fará seu trabalho lá. A sequencia se parece com isso:

    $ git clone (url)
    $ cd project
    $ git checkout -b featureA
    $ (trabalho)
    $ git commit
    $ (trabalho)
    $ git commit

Você pode querer usar `rebase -i` para espremer seu trabalho em um único commit, ou reorganizar o trabalho nos commits para fazer o patch mais fácil de revisar para os mantenedores — veja o *Capítulo 6* para mais informações sobre rebase interativo.

Quando seu trabalho no branch for finalizado e você está pronto para contribuir para os mantenedores, vá até a página do projeto original e clique no botão "Fork", criando seu próprio fork gravável do projeto. Você então precisa adicionar a URL desse novo repositório como um segundo remoto (remote), nesse caso chamado `myfork`:

    $ git remote add myfork (url)

Você precisa dar push de seu trabalho para ele. É mais fácil dar push do branch remoto que você está trabalhando para seu repositório, ao invés de fazer merge em seu branch `master` e dar push dele. A razão é que se o trabalho não for aceito ou é selecionado em parte, você não tem que rebobinar seu branch `master`. Se os mantenedores mesclam, fazem rebase ou "cherry-pick" (escolhem pequenos pedaços) do seu trabalho, você terá que eventualmente puxar de novo de qualquer forma:

    $ git push myfork featureA

Quando seu trabalho tiver na sua fork, você precisa notificar o mantenedor. Isso é geralmente chamado pull request (requisição para ele puxar), e você pode gerar isso pelo website — GitHub tem um "pull request" que notifica automaticamente o mantenedor — ou executar `git request-pull` e enviar por e-mail a saída desse comando para o mantenedor do projeto manualmente.

O comando `request-pull` recebe como argumento um branch base no qual você quer que suas alterações sejam puxadas e a URL do repositório Git que você quer que eles puxem. Por exemplo, se Jessica quer enviar John um pull request e ela fez dois commits no topic branch que ela deu push, ela pode executar isso:

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

O resultado pode ser enviado para o mantenedor - ele fala para eles de onde o trabalho foi baseado, resume os commits e mostra de onde puxar esse trabalho.

Em um projeto que você não é o mantenedor, é geralmente mais fácil ter um branch como `master` sempre sincronizar com `origin/master` e fazer seu trabalho em topic branches que você pode facilmente descartar se rejeitados. Tendo temas de trabalho isolados em topic branches também torna mais fácil fazer rebase de seu trabalho se o seu repositório principal tiver sido atualizado nesse meio tempo e seus commits não puderem ser aplicados de forma limpa. Por exemplo, se você quiser submeter um segundo tópico de trabalho para o projeto, não continue trabalhando no topic branch que você deu push por último — inicie de novo a partir do branch `master` do repositório principal:

    $ git checkout -b featureB origin/master
    $ (work)
    $ git commit
    $ git push myfork featureB
    $ (email maintainer)
    $ git fetch origin

Agora, cada um de seus tópicos é contido em um silo — similar a uma fila de patchs — que você pode reescrever, fazer rebase e modificar sem os tópicos interferirem ou interdepender um do outro como na Figura 5-16.

Insert 18333fig0516.png
Figura 5-16. Histórico de commits inicial com trabalho do featureB.

Vamos dizer que o mantenedor do projeto tenha puxado um punhado de outros patches e testou seu primeiro branch, mas ele não mescla mais. Nesse caso, você pode tentar fazer rebase daquele branch em cima de `origin/master`, resolver os conflitos para o mantenedor e então submeter novamente suas alterações:

    $ git checkout featureA
    $ git rebase origin/master
    $ git push -f myfork featureA

Isso sobrescreve seu histórico para parecer com a Figura 5-17.

Insert 18333fig0517.png
Figura 5-17. Histórico de commits depois do trabalho em featureA.

Já que você fez rebase de seu trabalho, você tem que especificar a opção `-f` para seu comando `push` poder substituir o branch `featureA` no servidor com um commit que não é descendente dele. Uma alternativa seria dar push desse novo trabalho para um branch diferente no servidor (talvez chamado `featureAv2`).

Vamos ver mais um cenário possível: o mantenedor olhou o trabalho em seu segundo branch e gostou do conceito, mas gostaria que você alterasse um detalhe de implementação. Você irá também tomar essa oportunidade para mover seu trabalhar para ser baseado no branch `master` atual do projeto. Você inicia um novo branch baseado no branch `origin/master` atual, coloca as mudanças de `featureB` lá, resolve qualquer conflito, faz a alteração na implementação e então dá push para o servidor como um novo branch:

    $ git checkout -b featureBv2 origin/master
    $ git merge --no-commit --squash featureB
    $ (change implementation)
    $ git commit
    $ git push myfork featureBv2

A opção `--squash` pega todo o trabalho feito no branch mesclado e espreme ele em um non-merge commit em cima do branch que você está. A opção `--no-commit` fala para o Git não registrar um commit automaticamente. Isso permite a você introduzir as alterações de outro branch e então fazer mais alterações antes de registrar um novo commit.

Agora você pode enviar ao mantenedor uma mensagem informando que você fez as alterações requisitadas e eles podem encontrar essas mudanças em seu branch `featureBv2` (veja Figura 5-18).

Insert 18333fig0518.png
Figura 5-18. Histórico de commit depois do trabalho em featureBv2.

### Grande Projeto Público ###

Muitos projetos maiores tem procedimentos estabelecidos para aceitar patches — você irá precisar verificar as regras específicas para cada projeto, porque eles irão diferir. Contudo, muitos projetos maiores aceitam patches via lista de discussão para desenvolvedores, então eu irei falar sobre esse exemplo agora.

O fluxo de trabalho é similar ao caso de uso anterior — você cria topic branches para cada série de patches que você trabalhar. A diferença é como você irá submeter eles para o projeto. Ao invés de fazer um fork do projeto e dar push das alterações para sua própria versão gravável, você gera versões em e-mail de cada série de commits e envia para a lista de discussão para desenvolvedores:

    $ git checkout -b topicA
    $ (work)
    $ git commit
    $ (work)
    $ git commit

Agora você tem dois commits que você quer enviar para a lista de discussão. Você usa `git format-patch` para gerar os arquivos em formato mbox que você pode enviar por e-mail para a lista — transforma cada commit em uma mensagem de e-mail com a primeira linha da mensagem do commit como o assunto e o resto da mensagem mais o patch que o commit introduz como corpo. A coisa legal sobre isso é que aplicando um patch de um e-mail gerado com `format-patch` preserva todas as informações do commit, como você irá ver mais nas próximas seções quando você aplica esses commits:

    $ git format-patch -M origin/master
    0001-add-limit-to-log-function.patch
    0002-changed-log-output-to-30-from-25.patch

O comando `format-patch` imprime o nome dos arquivos patch que ele cria. A opção `-M` fala para o Git verificar se há mudanças de nome. Os arquivos vão acabar parecendo assim:

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

Você pode também editar esses arquivos de patch para adicionar mais informação para a lista de e-mail que você não quer que apareça na mensagem do commit. Se você adicionar o texto entre a linha com `---` e o início do patch (a linha `lib/simplegit.rb`), então desenvolvedores podem lê-la; mas aplicar o patch a exclui.

Para enviar por e-mail a uma lista de discussão, você pode ou colar o arquivo em seu programa de e-mails ou enviar por um programa em linha de comando. Colando o texto geralmente causa problemas de formatação, especialmente com clientes "expertos" que não preservam linhas em branco e espaços em branco de forma apropriada. Por sorte, Git fornece uma ferramenta que lhe ajuda a enviar um patch via Gmail, que por acaso é o agente de e-mail que eu uso; você pode ler instruções detalhadas para vários programas de e-mail no final do arquivo previamente mencionado `Documentation/SubmittingPatched` no código fonte do Git.

Primeiramente, você precisa configurar a seção imap em seu arquivo `~/.gitconfig`. Você pode definir cada valor separadamente com uma série de comandos `git config` ou você pode adicioná-los manualmente; mas no final, seu arquivo de configuração deve parecer mais ou menos assim:

    [imap]
      folder = "[Gmail]/Drafts"
      host = imaps://imap.gmail.com
      user = user@gmail.com
      pass = p4ssw0rd
      port = 993
      sslverify = false

Se seu servidor IMAP não usa SSL, as últimas duas linhas provavelmente não serão necessárias e o valor do host será `imap://` ao invés de `imaps://`.
Quando isso estiver configurado, você pode usar `git send-email` para colocar a série de patches em sua pasta Drafts (Rascunhos) no seu servidor IMAP:

    $ git send-email *.patch
    0001-added-limit-to-log-function.patch
    0002-changed-log-output-to-30-from-25.patch
    Who should the emails appear to be from? [Jessica Smith <jessica@example.com>]
    Emails will be sent from: Jessica Smith <jessica@example.com>
    Who should the emails be sent to? jessica@example.com
    Message-ID to be used as In-Reply-To for the first email? y

Então, Git imprime um bocado de informação de log parecendo com isso para cada patch que você estiver enviando:

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

Nesse ponto, você deve poder ir a sua pasta de rascunhos, modificar o campo "Para" (To) para a lista de discussões que você está enviando o patch, possivelmente o campo CC para o mantenedor ou pessoa responsável por aquela seção, e enviar.

### Resumo ###

Essa seção cobriu uma grande quantidade de fluxos de trabalho comuns para lidar com vários tipos bem diferentes de projetos Git que você provavelmente encontrará e introduziu algumas novas ferramentas para lhe ajudar a gerenciar esse processo. Nas seções seguintes, você irá ver como trabalhar no outro lado da moeda: mantendo um projeto Git. Você irá aprender como ser um ditador benevolente ou gerente de integração.

## Mantendo Um Projeto ##

Além de saber como contribuir efetivamente para um projeto, você pode precisar saber como manter um. Isso pode consistir em aceitar e aplicar patches gerados via `format-patch` e enviados por e-mail para você, ou integrar alterações em branches remotos para repositórios que você adicionou como remotes do seu projeto. Se você mantém um repositório canônico ou quer ajudar verificando ou aprovando patches, você precisa saber como aceitar trabalho de uma forma que é a mais clara para os outros contribuintes e aceitável para você a longo prazo.

### Trabalhando em Topic Branches ###

Quando você estiver pensando em integrar um novo trabalho, é geralmente uma boa ideia testá-lo em um topic branch — um branch temporário criado especificamente para testar o novo trabalho. Dessa forma, é fácil modificar um patch individualmente e deixá-lo se não tiver funcionando até que você tenha tempo de voltar para ele. Se você criar um nome de branch simples baseado no tema do trabalho que você irá testar, como `ruby_client` ou algo similarmente descritivo, você pode facilmente lembrar se você tem que abandoná-la por um tempo e voltar depois. O mantenedor do projeto Git tende a usar namespace nos branches — como `sc/ruby_client`, onde `sc` é uma forma reduzida para o nome da pessoa que contribui com o trabalho. Você deve lembrar que você pode criar um branch baseado no branch `master` assim:

    $ git branch sc/ruby_client master

Ou, se você quer também mudar para o branch imediatamente, você pode usar a opção `checkout -b`:

    $ git checkout -b sc/ruby_client master

Agora você está pronto para adicionar seu trabalho nesse topic branch e determinar se você quer mesclá-lo em seus branches de longa duração.

### Aplicando Patches por E-mail ###

Se você receber um patch por e-mail que você precisa integrar em seu projeto, você precisa aplicar o patch em seu topic branch para avaliá-lo. Há duas formas de aplicar um patch enviado por e-mail: com `git apply` ou com `git am`.

#### Aplicando Um Patch Com apply ####

Se você recebeu o patch de alguém que o gerou com `git diff` ou o comando `diff` do Unix, você pode aplicá-lo com o comando `git apply`. Assumindo que você salvou o patch em `/tmp/patch-ruby-client.patch`, você pode aplicar o patch assim:

    $ git apply /tmp/patch-ruby-client.patch

Isso modifica os arquivos em seu diretório de trabalho. É quase igual a executar o comando `patch -p1` para aplicar o patch, mas ele aceita menos correspondências nebulosas do que patch. Ele também cuida de adições, remoções e mudanças de nome de arquivos se tiverem sido descritos no formato do `git diff`, o que `patch` não faz. Finalmente, `git apply` segue um modelo "aplica tudo ou aborta tudo", enquanto `patch` pode aplicar arquivos patch parcialmente, deixando seu diretório de trabalho em um estado estranho. `git apply` é no geral muito mais cauteloso que `patch`. Ele não cria um commit para você — depois de executá-lo, você deve adicionar e fazer commit das mudanças introduzidas manualmente.

Você pode também usar `git apply` para ver se um patch aplica corretamente antes de tentar aplicar ele de verdade — você pode executar `git apply --check` com o patch:

    $ git apply --check 0001-seeing-if-this-helps-the-gem.patch
    error: patch failed: ticgit.gemspec:1
    error: ticgit.gemspec: patch does not apply

Se não tiver nenhuma saída, então o patch deverá ser aplicado corretamente. O comando também sai com um status diferente de zero se a verificação falhar, então você pode usá-lo em scripts se você quiser.

#### Aplicando um Patch com am ####

Se o contribuinte é um usuário Git e foi bondoso o suficiente para usar o comando `format-patch` para gerar seu patch, então seu trabalho é mais fácil porque o patch contém informação do autor e uma mensagem de commit para você. Se você puder, encoraje seus contribuintes a usar `format-patch` ao invés de `diff` para gerar patches para você. Você só deve ter que usar `git apply` para patches legados e coisas desse tipo.

Para aplicar o patch gerado por `format-patch`, você usa `git am`. Tecnicamente, `git am` foi feito para ler um arquivo mbox, que é um formato simples de texto puro para armazenar uma ou mais mensagens de e-mail em um único arquivo. Ele se parece com isso:

    From 330090432754092d704da8e76ca5c05c198e71a8 Mon Sep 17 00:00:00 2001
    From: Jessica Smith <jessica@example.com>
    Date: Sun, 6 Apr 2008 10:17:23 -0700
    Subject: [PATCH 1/2] add limit to log function

    Limit log functionality to the first 20

Isso é o início da saída do comando `format-patch` que você viu na seção anterior. Isso é também um formato de e-mail mbox válido. Se alguém lhe enviou um patch por e-mail corretamente usando `git send-email` e você baixou no formato mbox, então você pode apontar aquele arquivo para o `git am` e ele irá começar a aplicar todos os patches que ele ver. Se você executar um cliente de e-mail que pode salvar vários e-mails em um formato mbox, você pode salvar uma série inteira de patches em um arquivo e então usar o `git am` para aplicar todos de uma vez.

Entretanto, se alguém fez upload de um arquivo patch gerado via `format-patch` para um sistema de chamados ou algo similar, você pode salvar o arquivo localmente e então passar o arquivo salvo no seu disco para `git am` aplicar:

    $ git am 0001-limit-log-function.patch
    Applying: add limit to log function

Você pode ver que ele foi aplicado corretamente e automaticamente criou um novo commit para você. O autor é retirado dos cabeçalhos `From`(`De`) e `Date`(`Data`) do e-mail e a mensagem do commit é retirada dos campos `Subject` (`Assunto`) e `Corpo` (`body`) (antes do path) do e-mail. Por exemplo, se esse patch foi aplicado do exemplo de mbox que eu acabei de mostrar, o commit gerado irá parecer com isso:

    $ git log --pretty=fuller -1
    commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
    Author:     Jessica Smith <jessica@example.com>
    AuthorDate: Sun Apr 6 10:17:23 2008 -0700
    Commit:     Scott Chacon <schacon@gmail.com>
    CommitDate: Thu Apr 9 09:19:06 2009 -0700

       add limit to log function

       Limit log functionality to the first 20

A informação `Commit` indica a pessoa que aplicou o patch e a hora que foi aplicado. A informação `Author`(autor) é o indivíduo que originalmente criou o patch e quanto ela foi originalmente criada.

Mas é possível que o patch não aplique corretamente. Talvez seu branch principal tenha divergido muito do branch a partir do qual o patch foi feito, ou o patch depende de outro patch que você ainda não aplicou. Nesse caso, o `git am` irá falhar e perguntar o que você quer fazer:

    $ git am 0001-seeing-if-this-helps-the-gem.patch
    Applying: seeing if this helps the gem
    error: patch failed: ticgit.gemspec:1
    error: ticgit.gemspec: patch does not apply
    Patch failed at 0001.
    When you have resolved this problem run "git am --resolved".
    If you would prefer to skip this patch, instead run "git am --skip".
    To restore the original branch and stop patching run "git am --abort".

Esse comando coloca marcadores de conflito em qualquer arquivo que tenha problemas, muito parecido com um conflito das operações de merge ou rebase. Você resolve esse problema, da mesma forma — edita o arquivo e resolve o conflito, adiciona para a "staging area" e então executa `git am --resolved` para continuar com o próximo patch:

    $ (fix the file)
    $ git add ticgit.gemspec
    $ git am --resolved
    Applying: seeing if this helps the gem

Se você quer que o Git tente ser um pouco mais inteligente para resolver o conflito, você pode passar a opção `-3` para ele, que faz o Git tentar um three-way merge. Essa opção não é padrão porque ela não funciona se o commit que o patch diz que foi baseado não estiver em seu repositório. Se você tiver o commit — se o patch foi baseado em commit público — então a opção `-3` é geralmente muito melhor para aplicar um patch conflituoso:

    $ git am -3 0001-seeing-if-this-helps-the-gem.patch
    Applying: seeing if this helps the gem
    error: patch failed: ticgit.gemspec:1
    error: ticgit.gemspec: patch does not apply
    Using index info to reconstruct a base tree...
    Falling back to patching base and 3-way merge...
    No changes -- Patch already applied.

Nesse caso, eu estava tentando aplicar um patch que eu já tinha aplicado. Sem a opção `-3`, ela parece como um conflito.

Se você estiver aplicando vários patches de uma mbox, você pode também executar o comando `am` com modo interativo, que para a cada patch que ele encontra ele pergunta se você quer aplicá-lo:

    $ git am -3 -i mbox
    Commit Body is:
    --------------------------
    seeing if this helps the gem
    --------------------------
    Apply? [y]es/[n]o/[e]dit/[v]iew patch/[a]ccept all

Isso é legal se você tem vário patches salvos, porque você pode ver o patch primeiro se você não lembra o que ele é, ou não aplicar o patch se você já tinha feito isso antes.

Quando todos os patches para seu tópico são aplicados e feitos commits em seu branch, você pode escolher se e como integrá-los em um branch de longa duração.

### Fazendo Checkout Em Branches Remotos ###

Se sua contribuição veio de um usuário Git que configurou seu próprio repositório, deu push de várias alterações nele e então enviou uma URL para o repositório e o nome do branch remoto que as alterações estão, você pode adicioná-las como um remote e fazer merges localmente.

Por exemplo, se Jessica envia um e-mail dizendo que ela tem um nova funcionalidade no branch `ruby-client` do repositório dela, você pode testá-la adicionando o remote e fazendo checkout do branch localmente:

    $ git remote add jessica git://github.com/jessica/myproject.git
    $ git fetch jessica
    $ git checkout -b rubyclient jessica/ruby-client

Se ela manda outro e-mail mais tarde com outro branch contendo outra nova funcionalidade, você pode fazer fetch e checkout porque você já tem o remote configurado.

Isso é mais importante se você estiver trabalhando com uma pessoa regularmente. Se alguém só tem um patch para contribuir de vez em quando, então aceitá-lo por e-mail gastaria menos tempo do que exigir que todo mundo rode seu próprio servidor e tenha que continuamente adicionar e remover remotes para pegar poucos patches. Você também provavelmente não vai querer ter centenas de remotes, cada um para alguém que contribuiu um ou dois patches. Entretanto, scripts e serviços de hospedagem podem tornar isso mais fácil — depende bastante de como você desenvolve e como os contribuintes desenvolvem.

A outra vantagem dessa abordagem é que você terá o histórico dos commits também. Embora você possa ter problemas de merge legítimos, você sabe onde eles são baseados em seu histórico; um three-way merge é padrão ao invés de ter que fornecer opção `-3` e esperar que o patch tenha sido gerado de um commit público que você tenha acesso.

Se você estiver trabalhando com a pessoa regularmente, mas ainda quer puxar deles dessa forma, você pode fornecer a URL do repositório remoto para o comando `git pull`. Isso faz um pull uma vez e não salva a URL como um remote:

    $ git pull git://github.com/onetimeguy/project.git
    From git://github.com/onetimeguy/project
     * branch            HEAD       -> FETCH_HEAD
    Merge made by recursive.

### Determinando O Que É Introduzido ###

Agora você tem um topic branch que contém trabalho contribuído. Nesse ponto, você pode determinar o que você gostaria de fazer com isso. Essa seção revê alguns comandos para que você possa usá-los para revisar exatamente o que você estará introduzindo se você fizer merge em seu branch principal.

Geralmente ajuda conseguir uma revisão de todos os commits que estão nesse branch, mas que não estão em seu branch principal. Você pode excluir commits em seu branch `master` adicionando a opção `--not` antes do nome do branch. Por exemplo, se o contribuinte lhe envia dois patches, você cria um branch chamado `contrib` e aplica esses patches lá, você pode executar isso:

    $ git log contrib --not master
    commit 5b6235bd297351589efc4d73316f0a68d484f118
    Author: Scott Chacon <schacon@gmail.com>
    Date:   Fri Oct 24 09:53:59 2008 -0700

        seeing if this helps the gem

    commit 7482e0d16d04bea79d0dba8988cc78df655f16a0
    Author: Scott Chacon <schacon@gmail.com>
    Date:   Mon Oct 22 19:38:36 2008 -0700

        updated the gemspec to hopefully work better

Para ver quais mudanças cada commit introduz lembre que você pode passar a opção `-p` no `git log` e ele irá adicionar o diff introduzido em cada commit.

Para ver um diff completo do que irá acontecer se você fizer merge desse topic branch com outro branch, você pode ter que usar um truque estranho que consegue os resultados corretos. Você pode pensar em executar isso:

    $ git diff master

Esse comando lhe dá um diff, mas é enganoso. Se seu branch `master` avançou desde que foi criado o topic branch a partir dele, então você terá resultados aparentemente estranhos. Isso acontece porque o Git compara diretamente o snapshot do último commit do topic branch que você está e o snapshot do último commit do branch `master`. Por exemplo, se você tiver adicionado uma linha em um arquivo no branch `master`, uma comparação direta dos snapshots irá parecer que o topic branch irá remover aquela linha.

Se `master` é ancestral direto de seu topic branch, isso não é um problema; mas se os dois históricos estiverem divergido, o diff irá parecer que está adicionando todas as coisas novas em seu topic branch e removendo tudo único do branch `master`.

O que você realmente quer ver são as mudanças adicionadas no topic branch — o trabalho que você irá introduzir se fizer merge com `master`. Você faz isso mandando o Git comparar o último commit do seu topic branch com o primeiro ancestral comum que ele tem como o branch `master`.

Tecnicamente, você pode fazer isso descobrindo explicitamente qual é o ancestral comum e então executando seu diff nele:

    $ git merge-base contrib master
    36c7dba2c95e6bbb78dfa822519ecfec6e1ca649
    $ git diff 36c7db

Entretanto, isso não é conveniente, então o Git fornece outro atalho para fazer a mesma coisa: a sintaxe dos três pontos. No contexto do comando `diff`, você pode usar três pontos depois de outro branch para fazer um `diff` entre o último commit do branch que você está e seu ancestral comum com outro branch:

    $ git diff master...contrib

Esse comando lhe mostra apenas o trabalho que o topic branch introduziu desde seu ancestral em comum com `master`. Essa é uma sintaxe muito útil de se lembrar.

### Integrando Trabalho Contribuído ###

Quando todo o trabalho em seu topic branch estiver pronto para ser integrado em um branch mais importante, a questão é como fazê-lo. Além disso, que fluxo de trabalho você quer usar para manter seu projeto? Você tem várias opções, então eu cobrirei algumas delas.

#### Fluxos de Trabalho para Merge ####

Um fluxo de trabalho simples faz merge de seu trabalho em seu branch `master`. Nesse cenário, você tem um branch `master` que contém código estável. Quando você tiver trabalho em um topic branch que você fez ou que alguém contribuiu e você verificou, você faz merge no branch `master`, remove o topic branch e continua o processo. Se você tem um repositório com trabalho em dois branches chamados `ruby_client` e `php_client` que se parecem com a Figura 5-19 e faz primeiro merge de `ruby_client` e então de `php_client`, então seu histórico se parecerá como na Figura 5-20.

Insert 18333fig0519.png
Figura 5-19. histórico com vários topic branches.

Insert 18333fig0520.png
Figura 5-20. Depois de um merge de topic branches.

Isso é provavelmente o fluxo de trabalho mais simples, mas é problemático se você estiver lidando com repositórios ou projetos maiores.

Se você tiver mais desenvolvedores ou um projeto maior, você irá provavelmente querer usar pelo menos um ciclo de merge de duas fases. Nesse cenário você tem dois branches de longa duração, `master` e `develop`, dos quais você determina que `master` é atualizado só quando uma liberação bem estável é atingida e todo novo trabalho é integrado no branch `develop`. Você dá push regularmente de ambos os branches para o repositório público. Cada vez que você tiver um novo topic branch para fazer merge (Figura 5-21), você faz merge em `develop` (Figura 5-22); então, quando você criar uma tag o release, você avança (fast-forward) `master` para onde o agora estável branch `develop` estiver (Figura 5-23).


Insert 18333fig0521.png
Figura 5-21. Antes do merge do topic branch.

Insert 18333fig0522.png
Figura 5-22. Depois do merge do topic branch.

Insert 18333fig0523.png
Figura 5-23. Depois da liberação do topic branch.

Dessa forma, quando as pessoas clonarem seu repositório do projeto, eles podem fazer checkout ou do `master` para fazer build da última versão estável e se manter atualizado facilmente, ou eles pode fazer checkout do develop para conseguir coisas mais de ponta.
Você pode também continuar esse conceito, tendo um branch de integração onde é feito merge de todo o trabalho de uma vez. Então, quando a base de código daquele branch for estável e passar nos testes, você faz merge no branch develop; e quando este tiver comprovadamente estável por um tempo, você avança seu branch `master`.

#### Fluxo de Trabalho de Merges Grandes ####

O projeto Git tem quatro branches de longa duração: `master`, `next` e `pu` (proposed updates, atualizações propostas) para trabalho novo e `maint` para manutenção de versões legadas. Quando trabalho novo é introduzido por contribuintes, ele é coletado em topic branches no repositório do mantenedor em uma maneira similar ao que já foi descrito (veja Figura 5-24). Nesse ponto, os tópicos são avaliados para determinar se eles são seguros e prontos para consumo ou se eles precisam de mais trabalho. Se eles são seguros, é feito merge em `next` e é dado push do branch para que todo mundo possa testar os tópicos integrados juntos.

Insert 18333fig0524.png
Figura 5-24. Gerenciando uma série complexa de topic branches contribuídos em paralelo.

Se os tópicos ainda precisam de trabalho, é feito merge em `pu`. Quando é determinado que eles estão totalmente estáveis, é feito novamente merge dos tópicos em `master` e os branches refeitos com os tópicos que estavam em `next`, mas não graduaram para `master` ainda. Isso significa que `master` quase sempre avança, `next` passa por rebase de vez em quando e `pu` ainda mais frequentemente (veja Figura 5-25).

Insert 18333fig0525.png
Figura 5-25. Fazendo merge de topic branches contribuídos em branches de integração de longa duração.

Quando finalmente tiver sido feito merge do topic branch em `master`, ele é removido do repositório. O projeto Git também tem um branch `maint` que é copiado (fork) da última versãp a fornecer patches legados no caso de uma versão de manutenção ser requerida. Assim, quando você clona o repositório do Git, você tem quatro branches que você pode fazer checkout para avaliar o projeto em diferentes estágios de desenvolvimento, dependendo em quão atualizado você quer estar ou como você quer contribuir; e o mantenedor tem um fluxo de trabalho estruturado para ajudá-lo a vetar novas contribuições.

#### Fluxos de Trabalho para Rebase e Cherry Pick ####

Outros mantenedores preferem fazer rebase ou cherry-pick do trabalho contribuído em cima do branch `master` deles ao invés de fazer merge, para manter um histórico mais linear. Quando você tem trabalho em um topic branch e você determinou que você quer integrá-lo, você muda para aquele branch e executa o comando rebase para reconstruir as alterações em cima do branch `master` atual (ou `develop`, e por ai vai). Se isso funcionar bem, você pode avançar seu branch `master` e você irá terminar com um histórico de projeto linear.

A outra forma de mover trabalho introduzido de um branch para outro é cherry-pick. Um cherry-pick no Git é como um rebase para um único commit. Ele pega o patch que foi introduzido em um commit e tenta reaplicar no branch que você está. Isso é útil se você tem vários commits em um topic branch e quer integrar só um deles, ou se você tem um commit em um topic branch que você prefere usar cherry-pick ao invés de rebase. Por exemplo, vamos supor que você tem um projeto que se parece com a Figura 5-26.

Insert 18333fig0526.png
Figura 5-26. Histórico do exemplo antes de um cherry pick.

Se você quer puxar o commit `e43a6` no branch `master`, você pode executar

    $ git cherry-pick e43a6fd3e94888d76779ad79fb568ed180e5fcdf
    Finished one cherry-pick.
    [master]: created a0a41a9: "More friendly message when locking the index fails."
     3 files changed, 17 insertions(+), 3 deletions(-)

Isso puxa as mesmas alterações introduzidas em `e43a6`, mas o commit tem um novo valor SHA-1, porque a data de aplicação é diferente. Agora seu histórico se parece com a Figura 5-27.

Insert 18333fig0527.png
Figura 5-27. Histórico depois de fazer cherry-pick de um commit no topic branch.

Agora você pode remover seu topic branch e se livrar dos commits que você não quer puxar.

### Gerando Tag de Suas Liberações (Releases) ###

Quando você decidir fazer uma release, você provavelmente irá querer fazer uma tag para que você possa recriar aquela liberação em qualquer ponto no futuro. Você pode criar uma nova tag como discutimos no capítulo 2. Se você decidir assinar a tag como mantenedor, o processo parecerá com isso:

    $ git tag -s v1.5 -m 'my signed 1.5 tag'
    You need a passphrase to unlock the secret key for
    user: "Scott Chacon <schacon@gmail.com>"
    1024-bit DSA key, ID F721C45A, created 2009-02-09

Se você assinar suas tags, você pode ter o problema de distribuir as chaves PGP públicas usadas para assinar suas tags. O mantenedor do projeto Git tem resolvido esse problema incluindo a chave pública como um blob no repositório e então adicionando a tag que aponta diretamente para o conteúdo. Para fazer isso, você pode descobrir qual a chave que você quer executando `gpg --list-keys`:

    $ gpg --list-keys
    /Users/schacon/.gnupg/pubring.gpg
    ---------------------------------
    pub   1024D/F721C45A 2009-02-09 [expires: 2010-02-09]
    uid                  Scott Chacon <schacon@gmail.com>
    sub   2048g/45D02282 2009-02-09 [expires: 2010-02-09]

Então, você pode importar diretamente a chave no banco de dados Git exportando ela passando por pipe com `git hash-object`, que escreve um novo blob com esse conteúdo no Git e lhe devolve o SHA-1 do blob:

    $ gpg -a --export F721C45A | git hash-object -w --stdin
    659ef797d181633c87ec71ac3f9ba29fe5775b92

Agora que você tem os conteúdos da sua chave no Git, você pode criar uma tag que aponta diretamente para ela especificando o novo valor SHA-1 que o comando `hash-object` lhe deu:

    $ git tag -a maintainer-pgp-pub 659ef797d181633c87ec71ac3f9ba29fe5775b92

Se você executar `git push --tags`, a tag `maintainer-pgp-pub` será compartilhada com todo mundo. Se alguém quiser verificar a tag, ele pode importar diretamente sua chave PGP puxando o blob diretamente do banco de dados e importando no GPG:

    $ git show maintainer-pgp-pub | gpg --import

Eles podem usar essa chave para verificar todas as tags assinadas. E se você incluir instruções na mensagem da tag, executar `git show <tag>` irá dar ao usuário final instruções mais detalhadas sobre a verificação da tag.

### Gerando um Número de Build ###

Como o Git não tem um número que incrementa monotonicamente como 'v123' ou equivalente associado com cada commit, se você quer ter um nome legível que vá com cada commit você pode executar `git describe` naquele commit. Git lhe dá o nome da tag mais próxima com o número de commits em cima da tag e um SHA-1 parcial do commit que você está descrevendo:

    $ git describe master
    v1.6.2-rc1-20-g8c5b85c

Dessa forma, você pode exportar um snapshot ou build e nomeá-lo com algo compreensível para pessoas. De fato, se você compilar Git do código fonte clonado do repositório do Git, `git --version` lhe dará algo que se parece com isso. Se você estiver descrevendo um commit em que você adicionou uma tag, isso lhe dará o nome da tag.

O comando `git describe` favorece annotated tags (tags criadas com as opções `-a` ou `-s`), então tags de liberação devem ser criadas dessa forma se você estiver usando `git describe`, para assegurar que o commit seja nomeado corretamente quando feito o describe. Você pode também usar essa string como alvo do checkout, embora ele dependa do SHA-1 abreviado no final, então ele pode não ser válido para sempre. Por exemplo, o kernel do Linux recentemente mudou de 8 para 10 caracteres para assegurar que os SHA-1 sejam únicos, então saídas antigas do `git describe` foram invalidadas.

### Preparando Uma Liberação ###

Agora você quer liberar uma build. Uma das coisas que você irá querer fazer é criar um arquivo do último snapshot de seu código para aquelas almas perdidas que não usam Git. O comando para fazer isso é `git archive`:

    $ git archive master --prefix='project/' | gzip > `git describe master`.tar.gz
    $ ls *.tar.gz
    v1.6.2-rc1-20-g8c5b85c.tar.gz

Se alguém abre o tarball, eles obtêm o último snapshot do projeto dentro de um diretório 'project'. Você pode também criar um arquivo zip quase da mesma forma, mas passando `--format=zip` para `git archive`:

    $ git archive master --prefix='project/' --format=zip > `git describe master`.zip

Você agora tem uma tarball e um arquivo zip da sua liberação que você pode disponibilizar em seu website ou enviar por e-mail para outras pessoas.

### O Shortlog ###

É hora de enviar e-mail para a lista de e-mails das pessoas que querem saber o que está acontecendo no seu projeto. Uma forma legal de conseguir rapidamente um tipo de changelog do que foi adicionado ao seu projeto desde sua última liberação ou e-mail é usar o comando `git shortlog`. Ele resume todos os commits no intervalo que você passar; por exemplo, o seguinte lhe dá um resumo de todos os commits desde a sua última liberação, se sua última liberação foi chamada v1.0.1:

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

Você obtém um resumo sucinto de todos os commits desde v1.0.1 agrupados por autor que você pode enviar por e-mail para a sua lista.

## Resumo ##

Você deve se sentir bastante confortável contribuindo para um projeto com Git assim como mantendo seu próprio projeto ou integrando contribuições de outros usuários. Parabéns por ser um desenvolvedor eficaz em Git! No próximo capítulo, você irá aprender mais ferramentas poderosas e dicas para lidar com situações complexas, que fará de você verdadeiramente um mestre Git.
