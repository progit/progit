# Ferramentas do Git #

Até aqui, você aprendeu a maioria dos comandos e fluxos de trabalho do dia-a-dia que você precisa para gerenciar ou manter um repositório Git para o controle de seu código fonte. Você concluiu as tarefas básicas de rastreamento e commit de arquivos, e você aproveitou o poder da área de seleção e branches tópicos e merges.

Agora você vai explorar uma série de coisas muito poderosas que o Git pode fazer que você pode necessariamente não usar no dia-a-dia mas pode precisar em algum momento.

## Seleção de Revisão ##

Git permite que você escolha commits específicos ou uma série de commits de várias maneiras. Elas não são necessariamente óbvias mas é útil conhecê-las.

### Revisões Únicas ###

Obviamente você pode se referir a um commit pelo hash SHA-1 que é dado, mas também existem formas mais amigáveis para se referir a commits. Esta seção descreve as várias formas que você pode se referir a um único commit.

### SHA Curto ###

Git é inteligente o suficiente para descobrir qual commit você quis digitar se você fornecer os primeiros caracteres, desde que o SHA-1 parcial tenha pelo menos quatro caracteres e não seja ambíguo — ou seja, somente um objeto no repositório atual começe com esse código SHA-1 parcial.

Por exemplo, para ver um commit específico, digamos que você execute um comando `git log` e identifique o commit que adicionou uma certa funcionalidade:

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

Neste caso, escolho `1c002dd....` Se você executar `git show` nesse commit, os seguintes comandos são equivalentes (assumindo que as versões curtas não são ambíguas):

    $ git show 1c002dd4b536e7479fe34593e72e6c6c1819e53b
    $ git show 1c002dd4b536e7479f
    $ git show 1c002d

Git pode descobrir uma abreviação curta, única para seus valores SHA-1. Se você passasr a opção `--abbrev-commit` para o comando `git log`, a saída irá usar valores curtos mas os mantém únicos; por padrão ele usa sete caracteres mas, usa mais se necessário para manter o SHA-1 não ambíguo:

    $ git log --abbrev-commit --pretty=oneline
    ca82a6d changed the verison number
    085bb3b removed unnecessary test code
    a11bef0 first commit

Geralmente, entre oito e dez caracteres são mais que suficientes para ser único em um projeto. Um dos maiores projetos no Git, o kernel do Linux, está começando a ter a necessidade de 12 caracteres dos 40 possíveis para ser único.

### UMA NOTA SOBRE SHA-1 ###

Muitas pessoas ficam preocupadas que em algum momento elas terão, por coincidência aleatória, dois objetos em seus repósitorios com hash com o mesmo valor de SHA-1. O que fazer?

Se acontecer de você fazer um commit de um objeto que tem o hash com o mesmo valor de SHA-1 de um objeto existente no seu repositório, GIt notará o primeiro objeto existente no seu banco de dados e assumirá que ele já foi gravado. Se você tentar fazer o checkout desse objeto novamente em algum momento, sempre receberá os dados do primeiro objeto.

Porém, você deve estar ciente de quão ridiculamente improvável é esse cenário. O código SHA-1 tem 20 bytes ou 160 bits. O número de objetos com hashes aleatórios necessários para garantir a probabilidade de 50% de uma única colisão é cerca de 2^80 (a fórmula para determinar a probabilidade de colisão é `p = (n(n-1)/2) * (1/2^160)`). 2^80 é 1.2 x 10^24 ou 1 milhão de bilhões de bilhões. Isso é 1.200 vezes o número de grãos de areia na Terra.

Aqui está um exemplo para lhe dar uma idéia do que seria necessário para obter uma colisão de SHA-1. Se todos os 6,5 bilhões de humanos na Terra estivessem programando, e a cada segundo, cada um estivesse produzindo código que é equivalente ao histórico inteiro do kernel do Linux (1 milhão de objetos Git) e fazendo o push para um enorme repositório Git, levaria 5 anos até que esse repositório tenha objetos suficientes para ter uma probabilidade de 50% de uma única colisão de objetos SHA-1. Existe uma probabilidade maior de cada membro do seu time de programação ser atacado e morto por lobos na mesma noite em incidentes sem relação.

### Referências de Branch ###

A maneira mais simples de especificar um commit requer que ele tenha uma referência de um branch apontando para ele. Então, você pode usar um nome de branch em qualquer comando no Git que espera um objeto commit ou valor SHA-1. Por exemplo, se você quer mostrar o último objeto commit em um branch, os seguintes comandos são equivalentes, assumindo que o branch `topic1` aponta para `ca82a6d`:

    $ git show ca82a6dff817ec66f44342007202690a93763949
    $ git show topic1

Se você quer ver para qual SHA específico um branch aponta, ou se você quer ver o que qualquer desses exemplos se resumem em termos de SHAs, você pode usar uma ferramenta de Git plumbing chamada `rev-parse`. Você pode ver o *Capítulo 9* para mais informações sobre ferramentas de plumbing (canalização); basicamente, `rev-parse` existe para operações de baixo nível e não é projetada para ser usada em operações do dia-a-dia. Entretanto, ela as vezes pode ser útil quando você precisa ver o que realmente está acontecendo. Aqui você pode executar `rev-parse` no seu branch.

    $ git rev-parse topic1
    ca82a6dff817ec66f44342007202690a93763949

### Abreviações do RefLog ###

Uma das coisas que o Git faz em segundo plano enquanto você está fora é manter um reflog — um log de onde suas referências de HEAD e branches estiveram nos últimos meses.

Você poder ver o reflog usando `git reflog`:

    $ git reflog
    734713b... HEAD@{0}: commit: fixed refs handling, added gc auto, updated
    d921970... HEAD@{1}: merge phedders/rdocs: Merge made by recursive.
    1c002dd... HEAD@{2}: commit: added some blame and merge stuff
    1c36188... HEAD@{3}: rebase -i (squash): updating HEAD
    95df984... HEAD@{4}: commit: # This is a combination of two commits.
    1c36188... HEAD@{5}: rebase -i (squash): updating HEAD
    7e05da5... HEAD@{6}: rebase -i (pick): updating HEAD

Cada vez que a extremidade do seu branch é atualizada por qualquer motivo, Git guarda essa informação para você nesse histórico temporário. E você pode especificar commits mais antigos com esses dados, também. Se você quer ver o quinto valor anterior ao HEAD do seu repositório, você pode usar a referência `@{n}` que você vê na saída do reflog:

    $ git show HEAD@{5}

Você também pode usar essa sintaxe para ver onde um branch estava há um período de tempo anterior. Por exemplo, para ver onde seu branch `master` estava ontem, você pode digitar

    $ git show master@{yesterday}

Isso mostra onde a extremidade do branch estava ontem. Essa técnica funciona somente para dados que ainda estão no seu reflog, você não pode usá-la para procurar commits feitos há muitos meses atrás.

Para ver a informação do reflog formatada como a saída do `git log`, você pode executar `git log -g`:

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

É importante notar que a informação do reflog é estritamente local — é um log do que você fez no seu repositório. As referências não serão as mesmas na cópia do repositório de outra pessoa; e logo depois que você fez o clone inicial de um repositório, você terá um reflog vazio, pois nenhuma atividade aconteceu no seu repositório. Executar `git show HEAD@{2.months.ago}` funcionará somente se você fez o clone do projeto há pelo menos dois meses atrás — se você fez o clone dele há cinco minutos, você não terá resultados.

### Referências Ancestrais ###

A outra principal maneira de especificar um commit é através de seu ancestral. Se você colocar um `^` no final da referência, Git interpreta isso como sendo o pai do commit. Suponha que você veja o histórico do seu projeto:

    $ git log --pretty=format:'%h %s' --graph
    * 734713b fixed refs handling, added gc auto, updated tests
    *   d921970 Merge commit 'phedders/rdocs'
    |\
    | * 35cfb2b Some rdoc changes
    * | 1c002dd added some blame and merge stuff
    |/
    * 1c36188 ignore *.gem
    * 9b29157 add open3_detach to gemspec file list

Em seguinda, você pode ver o commit anterior especificando `HEAD^`, que significa "o pai do HEAD":

    $ git show HEAD^
    commit d921970aadf03b3cf0e71becdaab3147ba71cdef
    Merge: 1c002dd... 35cfb2b...
    Author: Scott Chacon <schacon@gmail.com>
    Date:   Thu Dec 11 15:08:43 2008 -0800

        Merge commit 'phedders/rdocs'

Você também pode informar um número depois do `^` — por exemplo, `d921970^2` significa "o segundo pai de d921970." Essa sintaxe só é útil para commits com merge, que têm mais de um pai. O primeiro pai é o branch que você estava quando fez o merge, e o segundo é o commit no branch que você fez o merge:

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

A outra forma de especificar ancestrais é o `~`. Isso também faz referência ao primeiro pai, assim `HEAD~` e `HEAD^` são equivalentes. A diferença se torna aparente quando você informa um número. `HEAD~2` significa "o primeiro pai do primeiro pai," ou "o avô" — passa pelos primeiros pais a quantidade de vezes que você informa. Por exemplo, no histórico listado antes, `HEAD~3` seria

    $ git show HEAD~3
    commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
    Author: Tom Preston-Werner <tom@mojombo.com>
    Date:   Fri Nov 7 13:47:59 2008 -0500

        ignore *.gem

Isso também pode ser escrito `HEAD^^^`, que novamente, é o primeiro pai do primeiro pai do primeiro pai:

    $ git show HEAD^^^
    commit 1c3618887afb5fbcbea25b7c013f4e2114448b8d
    Author: Tom Preston-Werner <tom@mojombo.com>
    Date:   Fri Nov 7 13:47:59 2008 -0500

        ignore *.gem

Você também pode combinar essas sintaxes — você pode obter o segundo pai da referência anterior (assumindo que ele era um commit com merge) usando `HEAD~3^2`, e assim por diante.

### Intervalos de Commits ###

Agora que você pode especificar commits individuais, vamos ver como especificar intervalos de commits. Isso é particularmente útil para gerenciar seus branches — se você tem muitos branches, você pode usar especificações de intervalos para responder perguntas como, "Que modificações existem nesse branch que ainda não foram mescladas (merge) no meu branch principal?".

#### Ponto Duplo ####

A especificação de intervalo mais comum é a sintaxe de ponto-duplo. Isso basicamente pede ao Git para encontrar um intervalo de commits que é acessível a partir de um commit, mas não são acessíveis a partir de outro. Por exemplo, digamos que você tem um histórico de commits como a Figure 6-1.

Insert 18333fig0601.png
Figura 6-1. Exemplo de histórico de seleção de intervalo.

Você quer ver o que existe no seu branch mas não existe no branch master. Você pede ao Git para mostrar um log apenas desses commits com `master..experiment` — isso significa "todos os commits acessíveis por experiment que não são acessíveis por master." Para deixar os exemplos mais breves e claros, vou usar as letras dos objetos dos commits do diagrama no lugar da saída real do log na ordem que eles seriam mostrados:

    $ git log master..experiment
    D
    C

Se, por outro lado, você quer ver o oposto — todos os commits em `master` que não estão em `experiment` — você pode inverter os nomes dos branches. `experiment..master` exibe tudo em `master` que não é acessível em `experiment`:

    $ git log experiment..master
    F
    E

Isso é útil se você quer manter o branch `experiment` atualizado e visualizar que merge você está prestes a fazer. Outro uso muito freqüente desta sintaxe é para ver o que você está prestes a enviar para um remoto:

    $ git log origin/master..HEAD

Esse comando lhe mostra qualquer commit no seu branch atual que não está no branch `master` no seu remoto `origin`. Se você executar um `git push` e seu branch atual está rastreando `origin/master`, os commits listados por `git log origin/master..HEAD` são os commits que serão transferidos para o servidor. Você também pode não informar um lado da sintaxe que o Git assumirá ser HEAD. Por exemplo, você pode obter os mesmos resultados que no exemplo anterior digitando `git log origin/master..` — Git substitui por HEAD o lado que está faltando.

#### Múltiplos Pontos ####

A sintaxe ponto-duplo é útil como um atalho; mas talvez você queira especificar mais de dois branches para indicar suar revisão, como ver quais commits estão em qualquer um dos branches mas não estão no branch que você está atualmente. Git permite que você faça isso usando o caractere `^` ou `--not` antes de qualquer referência a partir do qual você não quer ver commits acessíveis. Assim, estes três comandos são equivalentes:

    $ git log refA..refB
    $ git log ^refA refB
    $ git log refB --not refA

Isso é bom porque com essa sintaxe você pode especificar mais de duas referências em sua consulta, o que você não pode fazer com a sintaxe ponto-duplo. Por exemplo, se você quer ver todos os commits que são acessíveis de `refA` ou `refB` mas não de `refC`, você pode digitar um desses:

    $ git log refA refB ^refC
    $ git log refA refB --not refC

Este é um sistema de consulta de revisão muito poderoso que deve ajudá-lo a descobrir o que existe nos seus branches.

#### Ponto Triplo ####

A última grande sintaxe de intervalo de seleção é a sintaxe ponto-triplo, que especifica todos os commits que são acessíveis por qualquer uma das duas referências mas não por ambas. Veja novamente o exemplo de histórico de commits na Figure 6-1. Se você quer ver o que tem em `master` ou `experiment` mas sem referências comuns, você pode executar

    $ git log master...experiment
    F
    E
    D
    C

Novamente, isso lhe da uma saída de `log` normal mas mostra somente as informações desses quatro commits, aparecendo na ordem de data de commit tradicional.

Uma opção comum para usar com o comando `log` nesse caso é `--left-right`, que mostra qual lado do intervalo está cada commit. Isso ajuda a tornar os dados mais úteis:

    $ git log --left-right master...experiment
    < F
    < E
    > D
    > C

Com essas ferramentas, você pode informar ao Git mais facilmente qual ou quais commits você quer inspecionar.

## Área de Seleção Interativa ##

Git vem com alguns scripts que facilitam algumas tarefas de linha de comando. Aqui, você verá alguns comandos interativos que podem ajudar você a facilmente escolher combinações ou partes de arquivos para incorporar em um commit. Essas ferramentas são muito úteis se você modificou vários arquivos e decidiu que quer essas modificações em commits separados em vez de um grande e bagunçado commit. Desta maneira, você pode ter certeza que seus commits estão logicamente separados e podem ser facilmente revisados pelos outros desenvolvedores trabalhando com você. Se você executar `git add` com a opção `-i` ou `--interactive`, Git entra em um modo interativo de shell, exibindo algo desse tipo:

    $ git add -i
               staged     unstaged path
      1:    unchanged        +0/-1 TODO
      2:    unchanged        +1/-1 index.html
      3:    unchanged        +5/-1 lib/simplegit.rb

    *** Commands ***
      1: status     2: update      3: revert     4: add untracked
      5: patch      6: diff        7: quit       8: help
    What now>

Você pode ver que esse comando lhe mostra uma visão muito diferente da sua área de seleção — basicamente a mesma informação que você recebe com `git status` mas um pouco mais sucinto e informativo. Ele lista as modificações que você colocou na área de seleção à esquerda e as modificações que estão fora à direita.

Depois disso vem a seção Commands. Aqui você pode fazer uma série de coisas, incluindo adicionar arquivos na área de seleção, retirar arquivos, adicionar partes de arquivos, adicionar arquivos não rastreados, e ver diffs de o que já foi adicionado.

### Adicionando e Retirando Arquivos ###

Se você digitar `2` ou `u` em `What now>`, o script perguntará quais arquivos você quer adicionar:

    What now> 2
               staged     unstaged path
      1:    unchanged        +0/-1 TODO
      2:    unchanged        +1/-1 index.html
      3:    unchanged        +5/-1 lib/simplegit.rb
    Update>>

Para adicionar os arquivos TODO e index.html, você pode digitar os números:

    Update>> 1,2
               staged     unstaged path
    * 1:    unchanged        +0/-1 TODO
    * 2:    unchanged        +1/-1 index.html
      3:    unchanged        +5/-1 lib/simplegit.rb
    Update>>

O `*` ao lado de cada arquivos significa que o arquivo está selecionado para ser adicionado. Se você pressionar Enter sem digitar nada em `Update>>`, Git pega tudo que esta selecionado e adiciona na área de seleção para você:

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

Agora você pode ver que os arquivos TODO e index.html estão na área de seleção e o arquivo simplegit.rb ainda está fora. Se você quer retirar o arquivo TODO nesse momento, você usa a opção `3` ou `r` (para reverter):

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

Olhando o seu Git status novamente, você pode ver que você retirou o arquivo TODO:

    *** Commands ***
      1: status     2: update      3: revert     4: add untracked
      5: patch      6: diff        7: quit       8: help
    What now> 1
               staged     unstaged path
      1:    unchanged        +0/-1 TODO
      2:        +1/-1      nothing index.html
      3:    unchanged        +5/-1 lib/simplegit.rb

Para ver o diff do que você adicionou, você pode usar o comando `6` ou `d` (para diff). Ele exibe uma lista dos seus arquivos adicionados, e você pode selecionar aqueles que você gostaria de ver a diferença. Isso é muito parecido com informar o comando `git diff --cached`:

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

Com esses comandos básicos, você pode usar o modo interativo para lidar com sua área de seleção um pouco mais facilmente.

### Adicionando Patches ###

No Git também é possível adicionar certas partes de arquivos e deixar o resto de fora. Por exemplo, se você faz duas mudanças no seu arquivo simplegit.rb e quer adicionar uma delas mas não a outra, fazer isso é muito fácil no Git. A partir do prompt interativo, digite `5` ou `p` (para patch). Git irá perguntar quais arquivos você gostaria de adicionar parcialmente; então, para cada seção dos arquivos selecionados, ele irá exibir partes do diff do arquivo e perguntar se você gostaria de adicioná-los, um por um:

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

Você tem várias opções neste momento. Digitando `?` exibe uma lista do que você pode fazer:

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

Geralmente, você informará `y` ou `n` se você quer adicionar cada parte, mas adicionar todos eles em determinados arquivos ou deixar a decisão de uma parte para depois pode ser útil também. Se você adiconar uma parte do arquivo e deixar outra parte de fora, a saída do status será parecido com isso:

    What now> 1
               staged     unstaged path
      1:    unchanged        +0/-1 TODO
      2:        +1/-1      nothing index.html
      3:        +1/-1        +4/-0 lib/simplegit.rb

O status do arquivo simplegit.rb é interessante. Ele lhe mostra que algumas linhas foram adicionadas e algumas estão fora. Você adicionou esse arquivo parcialmente. Neste momento, você pode sair do script de modo interativo e executar `git commit` para fazer o commit parcial dos arquivos adicionados.

Finalmente, você não precisa estar no modo interativo para adicionar um arquivo parcialmente — você pode executar o mesmo script usando `git add -p` ou `git add --patch` na linha de comando.

## Fazendo Stash ##

Muitas vezes, quando você está trabalhando em uma parte do seu projeto, as coisas estão em um estado confuso e você quer mudar de branch por um tempo para trabalhar em outra coisa. O problema é, você não quer fazer o commit de um trabalho incompleto somente para voltar a ele mais tarde. A resposta para esse problema é o comando `git stash`.

Fazer Stash é tirar o estado sujo do seu diretório de trabalho — isto é, seus arquivos modificados que estão sendo rastreados e mudanças na área de seleção — e o salva em uma pilha de modificações inacabadas que você pode voltar a qualquer momento.

### Fazendo Stash do Seu Trabalho ###

Para demonstrar, você entra no seu projeto e começa a trabalhar em alguns arquivos e adiciona alguma modificação na área de seleção. Se você executar `git status`, você pode ver seu estado sujo:

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

Agora você quer mudar de branch, mas não quer fazer o commit do que você ainda está trabalhando; você irá fazer o stash das modificações. Para fazer um novo stash na sua pilha, execute `git stash`:

    $ git stash
    Saved working directory and index state \
      "WIP on master: 049d078 added the index file"
    HEAD is now at 049d078 added the index file
    (To restore them type "git stash apply")

Seu diretório de trabalho está limpo:

    $ git status
    # On branch master
    nothing to commit, working directory clean

Neste momento, você pode facilmente mudar de branch e trabalhar em outra coisa; suas alterações estão armazenadas na sua pilha. Para ver as stashes que você guardou, você pode usar `git stash list`:

    $ git stash list
    stash@{0}: WIP on master: 049d078 added the index file
    stash@{1}: WIP on master: c264051... Revert "added file_size"
    stash@{2}: WIP on master: 21d80a5... added number to log

Nesse caso, duas stashes tinham sido feitas anteriormente, então você tem acesso a três trabalhos stashed diferentes. Você pode aplicar aquele que acabou de fazer o stash com o comando mostrado na saída de ajuda do comando stash original: `git stash apply`. Se você quer aplicar um dos stashes mais antigos, você pode especificá-lo, assim: `git stash apply stash@{2}`. Se você não especificar um stash, Git assume que é o stash mais recente e tenta aplicá-lo:

    $ git stash apply
    # On branch master
    # Changes not staged for commit:
    #   (use "git add <file>..." to update what will be committed)
    #
    #      modified:   index.html
    #      modified:   lib/simplegit.rb
    #

Você pode ver que o Git altera novamente os arquivos que você reverteu quando salvou o stash. Neste caso, você tinha um diretório de trabalho limpo quando tentou aplicar o stash, e você tentou aplicá-lo no mesmo branch de onde tinha guardado; mas ter um diretório de trabalho limpo e aplicá-lo no mesmo branch não é necessario para usar um stash com sucesso. Você pode salvar um stash em um branch, depois mudar para outro branch, e tentar reaplicar as alterações. Você também pode ter arquivos alterados e sem commits no seu diretório de trabalho quando aplicar um stash — Git informa conflitos de merge se alguma coisa não aplicar de forma limpa.

As alterações em seus arquivos foram reaplicadas, mas o arquivo que você colocou na área de seleção antes não foi adicionado novamente. Para fazer isso, você deve executar o comando `git stash apply` com a opção `--index` para informar ao comando para tentar reaplicar as modificações da área de seleção. Se você tivesse executado isso, você teria conseguido voltar à sua posição original:

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

A opção apply somente tenta aplicar o stash armazenado — ele continua na sua pilha. Para removê-lo, você pode executar `git stash drop` com o nome do stash que quer remover:

    $ git stash list
    stash@{0}: WIP on master: 049d078 added the index file
    stash@{1}: WIP on master: c264051... Revert "added file_size"
    stash@{2}: WIP on master: 21d80a5... added number to log
    $ git stash drop stash@{0}
    Dropped stash@{0} (364e91f3f268f0900bc3ee613f9f733e82aaed43)

Você também pode executar `git stash pop` para aplicar o stash e logo em seguida apagá-lo da sua pilha.

### Revertendo um Stash ###

Em alguns cenários você pode querer aplicar alterações de um stash, trabalhar, mas desfazer essas alterações que originalmente vieram do stash. Git não fornece um comando como `stash unapply`, mas é possível fazer o mesmo simplesmente recuperando o patch associado com um stash e aplicá-lo em sentido inverso:

    $ git stash show -p stash@{0} | git apply -R

Novamente, se você não especificar um stash, Git assume que é o stash mais recente:

    $ git stash show -p | git apply -R

Você pode querer criar um alias e adicionar explicitamente um comando `stash-unapply` no seu git. Por exemplo:

    $ git config --global alias.stash-unapply '!git stash show -p | git apply -R'
    $ git stash apply
    $ #... work work work
    $ git stash-unapply

### Criando um Branch de um Stash ###

Se você criar um stash, deixá-lo lá por um tempo, e continuar no branch de onde criou o stash, você pode ter problemas em reaplicar o trabalho. Se o apply tentar modificar um arquivo que você alterou, você vai ter um conflito de merge e terá que tentar resolvê-lo. Se você quer uma forma mais fácil de testar as modificações do stash novamente, você pode executar `git stash branch`, que cria um novo branch para você, faz o checkout do commit que você estava quando criou o stash, reaplica seu trabalho nele, e então apaga o stash se ele é aplicado com sucesso:

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

Este é um bom atalho para recuperar facilmente as modificações em um stash e trabalhar nele em um novo branch.

## Reescrevendo o Histórico ##

Muitas vezes, trabalhando com o Git, você pode querer revisar seu histórico de commits por alguma razão. Uma das melhores funcionalidades do Git é que ele permite você tomar decisões no último momento possível. Você pode decidir quais arquivos vai em qual commit um pouco antes de fazer o commit da área de seleção, você pode decidir que não quer trabalhar em alguma coisa ainda com o comando stash, e você pode reescrever commits que já aconteceram para que eles pareçam ter acontecido de outra maneira. Isso pode envolver mudar a ordem dos commits, alterar mensagens ou arquivos em um commit, juntar ou separar commits, ou remover commits completamente — tudo isso antes de compartilhar seu trabalho com os outros.

Nesta seção, você verá como realizar essas tarefas muito úteis de modo que você pode fazer seu histórico de commits parecer da forma que você quiser antes de compartilhá-lo com outros.

### Alterando o Último Commit ###

Modificar o último commit é provavelmente a alteração de histórico mais comum que você irá fazer. Muitas vezes você vai querer fazer duas coisas básicas com seu último commit: mudar a mensagem do commit, ou mudar o snapshot que você acabou de salvar, adicionando, alterando e removendo arquivos.

Se você quer somente modificar a mensagem do seu último commit, é muito simples:

    $ git commit --amend

Isso abre seu editor de texto, com sua última mensagem de commit nele, pronto para você modificar a mensagem. Quando você salva e fecha o editor, ele salva um novo commit contendo essa mensagem e fazendo esse seu novo commit o mais recente.

Se você fez o commit e quer alterar o snapshot adicionando ou modificando arquivos, possivelmente porque você esqueceu de adicionar um arquivo novo quando fez o commit original, o processo funciona basicamente da mesma maneira. Você adiciona as alterações que deseja na área de seleção editando um arquivo e executando `git add` nele ou `git rm` em um arquivo rastreado, e depois `git commit --amend` pega sua área de seleção atual e faz o snapshot para o novo commit.

Você precisa ter cuidado com essa técnica porque isso muda o SHA-1 do commit. É como um rebase muito pequeno — não altere seu último commit se você já fez o push dele.

### Alterando Várias Mensagens de Commit ###

Para modificar um commit mais antigo em seu histórico, você deve usar ferramentas mais complexas. Git não tem uma ferramenta de modificação de histórico, mas você pode usar o rebase para alterar uma série de commits no HEAD onde eles estavam originalmente em vez de movê-los para um novo. Com a ferramenta de rebase interativo, você pode parar depois de cada commit que quer modificar e alterar a mensagem, adicionar arquivos, ou fazer o que quiser. Você pode executar o rebase de forma interativa adicionando a opção `-i` em `git rebase`. Você deve indicar quão longe você quer reescrever os commits informando ao comando qual commit quer fazer o rebase.

Por exemplo, se você quer alterar as mensagens dos últimos três commits, ou qualquer mensagem de commit nesse grupo, você informa como argumento para `git rebase -i` o pai do último commit que você quer editar, que é `HEAD~2^` ou `HEAD~3`. Pode ser mais fácil de lembrar o `~3` porque você está tentando editar os últimos três commits; mas lembre-se que você está indicando realmente quatro commits atrás, o pai do último que você deseja editar:

    $ git rebase -i HEAD~3

Lembre-se que isso é um comando rebase — todos os commits no intervalo `HEAD~3..HEAD` serão reescritos, quer você mude a mensagem ou não. Não inclua nenhum commit que você já enviou a um servidor central — fazer isso irá confudir outros desenvolvedores fornecendo uma versão alternativa da mesma alteração.

Executando esse comando dará a você uma lista de commits no seu editor de texto que se parece com isso:

    pick f7f3f6d changed my name a bit
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
    #

É importante notar que esses commits são listados na ordem inversa do que você normalmente vê usando o comando `log`. Se você executar um `log`, você vê algo como isto:

    $ git log --pretty=format:"%h %s" HEAD~3..HEAD
    a5f4a0d added cat-file
    310154e updated README formatting and added blame
    f7f3f6d changed my name a bit

Observe a ordem inversa. O rebase interativo lhe da um script que ele irá executar. Ele começará no commit que você especifica na linha de comando (`HEAD~3`) e repete as modificações introduzidas em cada um desses commits de cima para baixo. Ele lista o mais antigo primeiro, em vez do mais recente, porque ele vai ser o primeiro a ser alterado.

Você precisa editar o script para que ele pare no commit que você deseja editar. Para fazer isso, mude a palavra "pick" para a palavra "edit" para cada um dos commits que você deseja que o script pare. Por exemplo, para alterar somente a terceira mensagem de commit, você altera o arquivo para ficar assim:

    edit f7f3f6d changed my name a bit
    pick 310154e updated README formatting and added blame
    pick a5f4a0d added cat-file

Quando você salva e fecha o editor, Git retorna para o último commit na lista e deixa você na linha de comando com a seguinte mensagem:

    $ git rebase -i HEAD~3
    Stopped at 7482e0d... updated the gemspec to hopefully work better
    You can amend the commit now, with

           git commit --amend

    Once you’re satisfied with your changes, run

           git rebase --continue

Estas instruções lhe dizem exatamente o que fazer. Digite

    $ git commit --amend

Altere a mensagem do commit, e saia do editor. Depois execute

    $ git rebase --continue

Esse comando irá aplicar os outros dois commits automaticamente, e pronto. Se você alterar "pick" para "edit" em mais linhas, você pode repetir esses passos para cada commit que mudar para "edit". Cada vez, Git irá parar, permitir que você altere o commit, e continuar quando você tiver terminado.

### Reordenando Commits ###

Você também pode usar rebase interativo para reordenar ou remover commits completamente. Se você quer remover o commit "added cat-file" e mudar a ordem em que os outros dois commits foram feitos, você pode alterar o script do rebase disso

    pick f7f3f6d changed my name a bit
    pick 310154e updated README formatting and added blame
    pick a5f4a0d added cat-file

para isso:

    pick 310154e updated README formatting and added blame
    pick f7f3f6d changed my name a bit

Quando você salva e sai do editor, Git volta seu branch para o pai desses commits, altera o `310154e` e depois o `f7f3f6d`, e para. Você efetivamente alterou a ordem desses commits e removeu o commit "added cat-file" completamente.

### Achatando um Commit ###

Também é possível pegar uma série de commits e achatá-los em um único commit com a ferramenta de rebase interativo. O script coloca informações importantes na mensagem de rebase:

    #
    # Commands:
    #  p, pick = use commit
    #  e, edit = use commit, but stop for amending
    #  s, squash = use commit, but meld into previous commit
    #
    # If you remove a line here THAT COMMIT WILL BE LOST.
    # However, if you remove everything, the rebase will be aborted.
    #

Se, em vez de "pick" ou "edit", você especifica "squash", Git modifica essa e a alteração imediatamente anterior a ela e faz com que você faça o merge das mensagens de commits. Então, se você quer fazer um único commit a partir desses três commits, você modifica o script para algo como isso:

    pick f7f3f6d changed my name a bit
    squash 310154e updated README formatting and added blame
    squash a5f4a0d added cat-file

Quando você salva e sai do editor, Git aplica as três modificações e coloca você de volta no editor para fazer o merge das três mensagens de commit:

    # This is a combination of 3 commits.
    # The first commit's message is:
    changed my name a bit

    # This is the 2nd commit message:

    updated README formatting and added blame

    # This is the 3rd commit message:

    added cat-file

Quando você salvar isso, você terá um único commit com as alterações dos três commits anteriores.

### Dividindo um Commit ###

Dividir um commit significa desfazer um commit e parcialmente adicionar a área de seleção e commits dependendo do número de commits que você quer. Por exemplo, digamos que você quer dividir o commit do meio daqueles seus três commits. Em vez de "updated README formatting and added blame", você quer dividí-lo em dois commits: "updated README formatting" no primeiro, e "added blame" no segundo. Você pode fazer isso no script `rebase -i` mudando a instrução para "edit" no commit que você quer dividir:

    pick f7f3f6d changed my name a bit
    edit 310154e updated README formatting and added blame
    pick a5f4a0d added cat-file

Depois, quando o script colocar retornar para a linha de comando, você faz o reset desse commit, pega as alterações desse reset, e cria vários commits delas. Quando você salvar e sai do editor, Git volta ao pai do primeiro commit da sua lista, altera o primeiro commit (`f7f3f6d`), altera o segundo (`310154e`), e retorna você ao console. Lá, você pode fazer um reset desse commit com `git reset HEAD^`, que efetivamente desfaz o commit e deixa os arquivos alterados fora da área de seleção. Agora você pode colocar na área de seleção e fazer vários commits, e executar `git rebase --continue` quando estiver pronto:

    $ git reset HEAD^
    $ git add README
    $ git commit -m 'updated README formatting'
    $ git add lib/simplegit.rb
    $ git commit -m 'added blame'
    $ git rebase --continue

Git altera o último commit (`a5f4a0d`) no script, e seu histórico fica assim:

    $ git log -4 --pretty=format:"%h %s"
    1c002dd added cat-file
    9b29157 added blame
    35cfb2b updated README formatting
    f3cc40e changed my name a bit

Mais uma vez, isso altera os SHAs de todos os commits na sua lista, então certifique-se que você não fez o push de nenhum commit dessa lista para um repositório compartilhado.

### A Opção Nuclear: filter-branch ###

Existe uma outra opção de reescrita de histórico que você pode usar se precisa reescrever um grande número de commits em forma de script — por exemplo, mudar seu endereço de e-mail globalmente ou remover um arquivo de cada commit. O camando é `filter-branch`, e ele pode reescrever uma grande parte do seu histórico, então você não deve usá-lo a menos que seu projeto ainda não seja público e outras pessoas não se basearam nos commits que você está para reescrever. Porém, ele pode ser muito útil. Você irá aprender alguns usos comuns para ter uma idéia do que ele é capaz.

#### Removendo um Arquivo de Cada Commit ####

Isso é bastante comum de acontecer. Alguém acidentalmente faz um commit sem pensar de um arquivo binário gigante com `git add .`, e você quer removê-lo de todos os lugares. Talvez você tenha feito o commit de um arquivo que continha uma senha, e você quer liberar o código fonte do seu projeto. `filter-branch` é a ferramenta que você pode usar para limpar completamente seu histórico. Para remover um arquivo chamado passwords.txt completamente do seu histórico, você pode usar a opção `--tree-filter` em `filter-branch`:

    $ git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
    Rewrite 6b9b3cf04e7c5686a9cb838c3f36a8cb6a0fc2bd (21/21)
    Ref 'refs/heads/master' was rewritten

A opção `--tree-filter` executa o comando especificado depois de cada checkout do projeto e faz o commit do resultado novamente. Neste caso, você está removendo um arquivo chamado passwords.txt de cada snapshot, quer ele exista ou não. Se você quer remover todos os arquivos de backup do editor que entraram em commits acidentalmente, você pode executar algo como `git filter-branch --tree-filter "find * -type f -name '*~' -delete" HEAD`.

Você irá assistir o Git reescrever árvores e commits e, em seguida, no final, mover a referência do branch. Geralmente é uma boa idéia fazer isso em um branch de teste e depois fazer um hard-reset do seu branch master depois que você viu que isso era realmente o que queria fazer. Para executar `filter-branch` em todos os seus branches, você pode informar `--all` ao comando.

#### Fazendo um Subdiretório o Novo Raiz ####

Digamos que você importou arquivos de outro sistema de controle de versão e ele tem subdiretórios que não fazem sentido (trunk, tags, e outros). Se você quer fazer o subdiretório `trunk` ser a nova raiz do projeto para todos os commits, `filter-branch` pode ajudar a fazer isso, também:

    $ git filter-branch --subdirectory-filter trunk HEAD
    Rewrite 856f0bf61e41a27326cdae8f09fe708d679f596f (12/12)
    Ref 'refs/heads/master' was rewritten

Agora a sua nova raiz do projeto é o que estava no subdiretório `trunk`. Git também apagará automaticamente os commits que não afetaram o subdiretório.

#### Alterando o Endereço de E-Mail Globalmente ####

Outro caso comum é quando você esqueceu de executar `git config` para configurar seu nome e endereço de e-mail antes de começar a trabalhar, ou talvez você queira liberar o código fonte de um projeto do trabalho e quer mudar o endereço de e-mail profissional para seu endereço pessoal. Em todo caso, você também pode alterar o endereço de e-mail em vários commits com um script `filter-branch`. Você precisa ter cuidado para alterar somente o seu endereço de e-mail, use `--commit-filter`:

    $ git filter-branch --commit-filter '
            if [ "$GIT_AUTHOR_EMAIL" = "schacon@localhost" ];
            then
                    GIT_AUTHOR_NAME="Scott Chacon";
                    GIT_AUTHOR_EMAIL="schacon@example.com";
                    git commit-tree "$@";
            else
                    git commit-tree "$@";
            fi' HEAD

Isso reescreve cada commit com seu novo endereço. Pelo fato dos commits terem os valores SHA-1 dos pais deles, esse comando altera todos os SHAs dos commits no seu histórico, não apenas aqueles que têm o endereço de e-mail correspondente.

## Depurando com Git ##

Git também fornece algumas ferramentas para lhe ajudar a depurar problemas em seus projetos. Pelo fato do Git ser projetado para funcionar com quase qualquer tipo de projeto, essas ferramentas são bastante genéricas, mas elas muitas vezes podem ajudá-lo a caçar um bug ou encontrar um culpado quando as coisas dão errado.

### Anotação de Arquivo ###

Se você encontrar um erro no seu código e deseja saber quando e por quê ele foi inserido, anotação de arquivo é muitas vezes a melhor ferramenta. Ele mostra qual commit foi o último a modificar cada linha de qualquer arquivo. Portanto, se você ver que um método no seu código está com problemas, você pode anotar o arquivo com `git blame` para ver quando cada linha do método foi editada por último e por quem. Esse exemplo usa a opção `-L` para limitar a saída entre as linhas 12 e 22:

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

Observe que o primeiro campo é o SHA-1 parcial do commit que alterou a linha pela última vez. Os dois campos seguintes são valores extraídos do commit—o nome do autor e a data de autoria do commit — assim você pode ver facilmente quem alterou a linha e quando. Depois disso vem o número da linha e o conteúdo do arquivo. Observe também as linhas de commit com `^4832fe2`, elas dizem que essas linhas estavam no commit original do arquivo. Esse commit foi quando esse arquivo foi adicionado pela primeira vez nesse projeto, e essas linhas não foram alteradas desde então. Isso é um pouco confuso, porque agora você já viu pelo menos três maneiras diferentes de como Git usa o `^` para modificar um SHA de um commit, mas isso é o que ele significa neste caso.

Outra coisa legal sobre Git é que ele não rastreia mudança de nome explicitamente. Ele grava os snapshots e então tenta descobrir o que foi renomeado implicitamente, após o fato. Uma das características interessantes disso é que você também pode pedir que ele descubra qualquer tipo de mudança de código. Se você informar `-C` para `git blame`, Git analisa o arquivo que você está anotando e tenta descobrir de onde vieram originalmente os trechos de código, se eles foram copiados de outro lugar. Recentemente, eu estava refatorando um arquivo chamado `GITServerHandler.m` em vários arquivos, um deles era `GITPackUpload.m`. Ao usar "blame" `GITPackUpload.m` com a opção `-C`, eu podia ver de onde vinham os trechos de código originalmente:

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

Isto é realmente útil. Normalmente, você recebe como commit original, o commit de onde o código foi copiado, porque essa foi a primeira vez que você mecheu nessas linhas do arquivo. Git lhe informa o commit original onde você escreveu aquelas linhas, mesmo que seja em outro arquivo.

### Pesquisa Binária ###

Anotar um arquivo ajuda se você sabe onde está o problema. Se você não sabe o que está o problema, e houveram dezenas ou centenas de commits desde a última vez que você sabe que o código estava funcionando, você provavelmente vai usar `git bisect` para ajudá-lo. O comando `bisect` faz uma pesquisa binária em seu histórico de commits para ajudar você a indentificar o mais rápido possível qual commit inseriu o erro.

Digamos que você acabou de enviar seu código para um ambiente de produção, você recebe relatos de erros sobre algo que não estava acontecendo no seu ambiente de desenvolvimento, e você não tem ideia do motivo do código estar fazendo isso. Você volta para seu código e consegue reproduzir o problema, mas não consegue descobrir o que está errado. Você pode usar o "bisect" para descobrir. Primeiro você executa `git bisect start` para começar, e depois você usa `git bisect bad` para informar ao sistema que o commit atual está quebrado. Em seguida, você deve informar ao "bisect" quando foi a última vez que estava correto, usando `git bisect good [good_commit]`:

    $ git bisect start
    $ git bisect bad
    $ git bisect good v1.0
    Bisecting: 6 revisions left to test after this
    [ecb6e1bc347ccecc5f9350d878ce677feb13d3b2] error handling on repo

Git descobre que cerca de 12 commits estão entre o commit que você informou como o commit correto (v1.0) e a versão atual incorreta, e ele faz o um check out do commit do meio para você. Neste momento, você pode executar seus testes para ver se o problema existe neste commit. Se existir, então ele foi inserido em algum momento antes desse commit do meio; se não existir, então o problema foi inserido algum momento após o commit do meio. Acontece que não há nenhum problema aqui, e você informa isso ao Git digitando `git bisect good` e continua sua jornada:

    $ git bisect good
    Bisecting: 3 revisions left to test after this
    [b047b02ea83310a70fd603dc8cd7a6cd13d15c04] secure this thing

Agora você está em outro commit, na metade do caminho entre aquele que você acabou de testar e o commit incorreto. Você executa os testes novamente e descobre que esse commit está quebrado, você informa isso ao Git com `git bisect bad`:

    $ git bisect bad
    Bisecting: 1 revisions left to test after this
    [f71ce38690acf49c1f3c9bea38e09d82a5ce6014] drop exceptions table

Este commit está correto, e agora Git tem todas as informações que precisa para determinar quando o problema foi inserido. Ele lhe informa o SHA-1 do primeiro commit incorreto e mostra algumas informações do commit e quais arquivos foram alterados nesse commit para que você possa descobrir o que aconteceu que pode ter inserido esse erro:

    $ git bisect good
    b047b02ea83310a70fd603dc8cd7a6cd13d15c04 is first bad commit
    commit b047b02ea83310a70fd603dc8cd7a6cd13d15c04
    Author: PJ Hyett <pjhyett@example.com>
    Date:   Tue Jan 27 14:48:32 2009 -0800

        secure this thing

    :040000 040000 40ee3e7821b895e52c1695092db9bdc4c61d1730
    f24d3c6ebcfc639b1a3814550e62d60b8e68a8e4 M  config

Quando você terminar, você deve executar `git bisect reset` para fazer o "reset" do seu HEAD para onde você estava antes de começar, ou você vai acabar em uma situação estranha:

    $ git bisect reset

Essa é uma ferramenta poderosa que pode ajudar você a verificar centenas de commits em minutos para encontrar um erro. Na verdade, se você tiver um script que retorna 0 se o projeto está correto ou algo diferente de 0 se o projeto está incorreto, você pode automatizar totalmente `git bisect`. Primeiro, novamente você informa o escopo fornecendo o commit incorreto e o correto. Você pode fazer isso listando eles com o comando `bisect start` se você quiser, primeiro o commit incorreto e o correto em seguida:

    $ git bisect start HEAD v1.0
    $ git bisect run test-error.sh

Ao fazer isso, é executado automaticamente `test-error.sh` em cada commit até o Git encontrar o primeiro commit quebrado. Você também pode executar algo como `make` ou `make tests` ou qualquer coisa que executa testes automatizados para você.

## Submódulos ##

Freqüentemente enquanto você está trabalhando em um projeto, você precisa usar um outro projeto dentro dele. Talvez seja uma biblioteca desenvolvida por terceiros ou que você está desenvolvendo separadamente e usando em vários projetos pai. Um problema comum surge nestes cenários: você quer tratar os dois projetos em separado mas ainda ser capaz de usar um dentro do outro.

Aqui vai um exemplo. Digamos que você está desenvolvendo um site e criando Atom feeds. Em vez de criar seu próprio gerador de Atom, você decide usar uma biblioteca. Provavelmente você terá que incluir esse código de uma biblioteca compartilhada, como um instalação CPAN ou Ruby gem, ou copiar o código fonte na árvore do seu projeto. O problema com a inclusão da biblioteca é que é difícil de personalizar livremente e muitas vezes difícil de fazer o deploy dela, porque você precisa ter certeza de que cada cliente tem essa biblioteca disponível. O problema com a inclusão do código no seu projeto é que é difícil de fazer o merge de qualquer alteração que você faz quando existem modificações do desenvolvedor da biblioteca.

Git resolve esses problemas usando submódulos. Submódulos permitem que você mantenha um repositório Git como um subdiretório de outro repositório Git. Isso permite que você faça o clone de outro repositório dentro do seu projeto e mantenha seus commits separados.

### Começando com Submódulos ###

Digamos que você quer adicionar a biblioteca Rack (um servidor de aplicação web em Ruby) ao seu projeto, manter suas próprias alterações nela, mas continuar fazendo o merge do branch principal. A primeira coisa que você deve fazer é fazer o clone do repositório externo dentro do seu subdiretório. Você adiciona projetos externos como submódulos com o comando `git submodule add`:

    $ git submodule add git://github.com/chneukirchen/rack.git rack
    Initialized empty Git repository in /opt/subtest/rack/.git/
    remote: Counting objects: 3181, done.
    remote: Compressing objects: 100% (1534/1534), done.
    remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
    Receiving objects: 100% (3181/3181), 675.42 KiB | 422 KiB/s, done.
    Resolving deltas: 100% (1951/1951), done.

Agora você tem um projeto do Rack no subdiretório `rack` dentro do seu projeto. Você pode ir nesse subdiretório, fazer alterações, adicionar seus próprios repositórios remotos para fazer o push de suas modificações, fazer o fetch e o merge do repositório original, e outras coisas. Se você execurar `git status` logo depois de adicionar o submódulo, você verá duas coisas:

    $ git status
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #      new file:   .gitmodules
    #      new file:   rack
    #

Primeiro você percebe o arquivo `.gitmodules`. Esse é um arquivo de configuração que guarda o mapeamento entre a URL do projeto e o subdiretório local que você usou:

    $ cat .gitmodules
    [submodule "rack"]
          path = rack
          url = git://github.com/chneukirchen/rack.git

Se você tem vários submódulos, você terá várias entradas nesse arquivo. É importante notar que esse arquivo está no controle de versão como os outros, como o seu arquivo `.gitignore`. É feito o push e pull com o resto do seu projeto. É como as outras pessoas que fazem o clone do projeto sabem onde pegar os projetos dos submódulos.

O outro ítem na saída do `git status` é sobre o rack. Se você executar `git diff` nele, você vê uma coisa interessante:

    $ git diff --cached rack
    diff --git a/rack b/rack
    new file mode 160000
    index 0000000..08d709f
    --- /dev/null
    +++ b/rack
    @@ -0,0 +1 @@
    +Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

Apesar de `rack` ser um subdiretório no seu diretório de trabalho, Git vê ele como um submódulo e não rastreia seu conteúdo quando você não está no diretório. Em vez disso, Git o grava como um commit especial desse repositório. Quando você altera e faz commit nesse subdiretório, o projeto-pai nota que o HEAD mudou e grava o commit que você está atualmente; dessa forma, quando outros fizerem o clone desse projeto, eles podem recriar o mesmo ambiente.

Esse é um ponto importante sobre submódulos: você os salva como o commit exato onde eles estão. Você não pode salvar um submódulo no `master` ou em outra referência simbólica.

Quando você faz o commit, você vê algo assim:

    $ git commit -m 'first commit with submodule rack'
    [master 0550271] first commit with submodule rack
     2 files changed, 4 insertions(+), 0 deletions(-)
     create mode 100644 .gitmodules
     create mode 160000 rack

Note o modo 160000 para a entrada do rack. Esse é um modo especial no Git que basicamente significa que você está salvando um commit como um diretório em vez de um subdiretório ou um arquivo.

Você pode tratar o diretório `rack` como um projeto separado e atualizar seu projeto-pai de vez em quando com uma referência para o último commit nesse subprojeto. Todos os comandos do Git funcionam independente nos dois diretórios:

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

### Fazendo Clone de um Projeto com Submódulos ###

Aqui você vai fazer o clone de um projeto com um submódulo dentro. Quando você recebe um projeto como este, você tem os diretórios que contêm os submódulos, mas nenhum dos arquivos ainda:

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

O diretório `rack` está lá, mas vazio. Você precisa executar dois comandos: `git submodule init` para inicializar seu arquivo local de configuração, e `git submodule update` para buscar todos os dados do projeto e recuperar o commit apropriado conforme descrito em seu projeto-pai:

    $ git submodule init
    Submodule 'rack' (git://github.com/chneukirchen/rack.git) registered for path 'rack'
    $ git submodule update
    Initialized empty Git repository in /opt/myproject/rack/.git/
    remote: Counting objects: 3181, done.
    remote: Compressing objects: 100% (1534/1534), done.
    remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
    Receiving objects: 100% (3181/3181), 675.42 KiB | 173 KiB/s, done.
    Resolving deltas: 100% (1951/1951), done.
    Submodule path 'rack': checked out '08d709f78b8c5b0fbeb7821e37fa53e69afcf433'

Agora seu subdiretório `rack` está na mesma situação que estava quando você fez o commit antes. Se outro desenvolvedor alterar o código de "rack" e fizer o commit, e você faz o pull e o merge, você vê algo um pouco estranho:

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

Você fez o merge do que é basicamente um mudança para a referência do seu submódulo; mas isso não atualiza o código no diretório do submódulo, parece que você tem um estado sujo no seu diretório de trabalho:

    $ git diff
    diff --git a/rack b/rack
    index 6c5e70b..08d709f 160000
    --- a/rack
    +++ b/rack
    @@ -1 +1 @@
    -Subproject commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
    +Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

A causa disso é que a referência que você tem para o submódulo não é exatamente o que está no diretório do submódulo. Para corrigir isso, você precisa executar `git submodule update` novamente:

    $ git submodule update
    remote: Counting objects: 5, done.
    remote: Compressing objects: 100% (3/3), done.
    remote: Total 3 (delta 1), reused 2 (delta 0)
    Unpacking objects: 100% (3/3), done.
    From git@github.com:schacon/rack
       08d709f..6c5e70b  master     -> origin/master
    Submodule path 'rack': checked out '6c5e70b984a60b3cecd395edd5b48a7575bf58e0'

Você tem que fazer isso toda as vezes que pegar uma alteração de um submódulo no projeto principal. É estranho, mas funciona.

Um problema comum acontece quando um desenvolvedor faz uma alteração local em submódulo mas não a envia para um servidor público. Em seguida, ele faz o commit de uma referência para esse estado que não é publico e faz o push do projeto-pai. Quando outros desenvolvedores tentam executar `git submodule update`, o sistema do submódulo não consegue achar o commit para essa referência, porque ela só existe no sistema daquele primeiro desenvolvedor. Se isso acontecer, você verá um erro como este:

    $ git submodule update
    fatal: reference isn’t a tree: 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
    Unable to checkout '6c5e70b984a60b3cecd395edd5ba7575bf58e0' in submodule path 'rack'

Você tem que ver quem alterou o submódulo pela última vez:

    $ git log -1 rack
    commit 85a3eee996800fcfa91e2119372dd4172bf76678
    Author: Scott Chacon <schacon@gmail.com>
    Date:   Thu Apr 9 09:19:14 2009 -0700

        added a submodule reference I will never make public. hahahahaha!

Em seguida, você envia um e-mail para esse cara e grita com ele.

### Superprojetos ###

Às vezes, desenvolvedores querem obter uma combinação de subdiretórios de um grande projeto, dependendo de qual equipe eles estão. Isso é comum se você está vindo do CVS ou Subversion, onde você define um módulo ou uma coleção de subdiretórios, e você quer manter esse tipo de fluxo de trabalho.

Uma boa maneira de fazer isso no Git é fazer cada subpasta um repositório Git separado e em seguida criar um repositório para um projeto-pai que contêm vários submódulos. A vantagem desse modo é que você pode definir mais especificamente os relacionamentos entre os projetos com tags e branches no projeto-pai.

### Problemas com Submódulos ###

Usar submódulos tem seus problemas. Primeiro, você tem que ser relativamente cuidadoso quando estiver trabalhando no diretório do submódulo. Quando você executa `git submodule update`, ele faz o checkout de uma versão específica do projeto, mas fora de um branch. Isso é chamado ter uma cabeça separada (detached HEAD) — isso significa que o HEAD aponta diretamente para um commit, não para uma referência simbólica. O problema é que geralmente você não quer trabalhar em um ambiente com o HEAD separado, porque é fácil perder alterações. Se você executar `submodule update`, fizer o commit no diretório do submódulo sem criar um branch para trabalhar, e em seguida executar `git submodule update` novamente no projeto-pai sem fazer commit nesse meio tempo, Git irá sobrescrever as alterações sem lhe informar. Tecnicamente você não irá perder o trabalho, mas você não terá um branch apontando para ele, por isso vai ser um pouco difícil de recuperá-lo.

Para evitar esse problema, crie um branch quando for trabalhar em um diretório de um submódulo com `git checkout -b work` ou algo equivalente. Quando você atualizar o submódulo pela segunda vez, ele ainda irá reverter seu trabalho, mas pelo menos você terá uma referência para retornar.

Mudar de branches que contêm submódulos também pode ser complicado. Se você criar um novo branch, adicionar um submódulo nele, e mudar para um branch que não tem o submódulo, você ainda terá o diretório do submódulo como um diretório que não está sendo rastreado:

    $ git checkout -b rack
    Switched to a new branch "rack"
    $ git submodule add git@github.com:schacon/rack.git rack
    Initialized empty Git repository in /opt/myproj/rack/.git/
    ...
    Receiving objects: 100% (3184/3184), 677.42 KiB | 34 KiB/s, done.
    Resolving deltas: 100% (1952/1952), done.
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

Você tem que tirá-lo de lá ou removê-lo, em todo caso você tem que fazer o clone novamente quando você voltar — e você pode perder alterações ou branches locais que não foram enviados com um push.

O último problema que muitas pessoas encontram envolve mudar de subdiretórios para submódulos. Se você está rastreando arquivos no seu projeto e quer movê-los para um submódulo, você deve ser cuidadoso ou "o Git vai ficar com raiva de você". Digamos que você tem os arquivos do "rack" em um subdiretório do seu projeto, e você quer transformá-los em um submódulo. Se você apagar o subdiretório e em seguida executar `submodule add`, Git exibe isto:

    $ rm -Rf rack/
    $ git submodule add git@github.com:schacon/rack.git rack
    'rack' already exists in the index

Você tem que retirar o diretório `rack` da área de seleção primeiro. Depois, você pode adicionar o submódulo:

    $ git rm -r rack
    $ git submodule add git@github.com:schacon/rack.git rack
    Initialized empty Git repository in /opt/testsub/rack/.git/
    remote: Counting objects: 3184, done.
    remote: Compressing objects: 100% (1465/1465), done.
    remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
    Receiving objects: 100% (3184/3184), 677.42 KiB | 88 KiB/s, done.
    Resolving deltas: 100% (1952/1952), done.

Agora digamos que você fez isso em um branch. Se você tentar mudar para um branch onde esses arquivos ainda estão na árvore em vez de um submódulo — você recebe esse erro:

    $ git checkout master
    error: Untracked working tree file 'rack/AUTHORS' would be overwritten by merge.

Você tem que mover o diretório do submódulo do `rack` de lá antes de mudar para um branch que não tem ele:

    $ mv rack /tmp/
    $ git checkout master
    Switched to branch "master"
    $ ls
    README    rack

Em seguida, quando você voltar, você terá um diretório `rack` vazio. Você pode executar `git submodule update` para fazer o clone novamente, ou mover seu diretório `/tmp/rack` de volta para o diretório vazio.

## Merge de Sub-árvore (Subtree Merging) ##

Agora que você viu as dificuldades do sistema de submódulos, vamos ver uma maneira alternativa de resolver o mesmo problema. Quando o Git faz o merge, ele olha para as partes que vão sofrer o merge e escolhe a estratégia adequada de merge para usar. Se você está fazendo o merge de dois branches, Git usa uma estratégia _recursiva_ (_recursive_ strategy). Se você está fazendo o merge de mais de dois branches, Git usa a estratégia do _polvo_ (_octopus_ strategy). Essas estratégias são automaticamente escolhidas para você, porque a estratégia recursiva pode lidar com situações complexas de merge de três vias — por exemplo, mais de um ancestral comum — mas ele só pode lidar com o merge de dois branches. O merge octopus pode lidar com vários branches mas é cauteloso para evitar conflitos difíceis, por isso ele é escolhido como estratégia padrão se você está tentando fazer o merge de mais de dois branches.

Porém, existem também outras estratégias que você pode escolher. Uma delas é o merge de _sub-árvore_, e você pode usá-lo para lidar com o problema do subprojeto. Aqui você vai ver como resolver o problema do "rack" da seção anterior, mas usando merge de sub-árvore.

A ideia do merge de sub-árvore é que você tem dois projetos, e um deles está mapeado para um subdiretório do outro e vice-versa. Quando você escolhe um merge de sub-árvore, Git é inteligente o bastante para descobrir que um é uma sub-árvore do outro e faz o merge adequado — é incrível.

Primeiro você adiciona a aplicação Rack em seu projeto. Você adiciona o projeto Rack como uma referência remota no seu projeto e então faz o checkout dele em um branch:

    $ git remote add rack_remote git@github.com:schacon/rack.git
    $ git fetch rack_remote
    warning: no common commits
    remote: Counting objects: 3184, done.
    remote: Compressing objects: 100% (1465/1465), done.
    remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
    Receiving objects: 100% (3184/3184), 677.42 KiB | 4 KiB/s, done.
    Resolving deltas: 100% (1952/1952), done.
    From git@github.com:schacon/rack
     * [new branch]      build      -> rack_remote/build
     * [new branch]      master     -> rack_remote/master
     * [new branch]      rack-0.4   -> rack_remote/rack-0.4
     * [new branch]      rack-0.9   -> rack_remote/rack-0.9
    $ git checkout -b rack_branch rack_remote/master
    Branch rack_branch set up to track remote branch refs/remotes/rack_remote/master.
    Switched to a new branch "rack_branch"

Agora você tem a raiz do projeto Rack no seu branch `rack_branch` e o seu projeto no branch `master`. Se você fizer o checkout de um e depois do outro, você pode ver que eles têm raízes de projeto diferentes:

    $ ls
    AUTHORS           KNOWN-ISSUES   Rakefile      contrib           lib
    COPYING           README         bin           example           test
    $ git checkout master
    Switched to branch "master"
    $ ls
    README

Você quer colocar o projeto Rack no seu projeto `master` como um subdiretório. Você pode fazer isso no Git com `git read-tree`. Você irá aprender mais sobre `read-tree` e seus companheiros no Capítulo 9, mas por enquanto saiba que ele escreve a raiz da árvore de um branch na sua área de seleção e diretório de trabalho. Você volta para o branch `master`, você coloca o branch `rack_branch` no subdiretório `rack` no branch `master` do seu projeto principal:

    $ git read-tree --prefix=rack/ -u rack_branch

Quando você faz o commit, parece que você tem todos os arquivos do Rack nesse subdiretório — como se você tivesse copiado de um arquivo. O que é interessante é que você pode facilmente fazer merge de alterações de um branch para o outro. Assim, se o projeto Rack for atualizado, você pode fazer um pull das modificações mudando para o branch e fazendo o pull:

    $ git checkout rack_branch
    $ git pull

Em seguida, você pode fazer o merge dessas alterações no seu branch master. Você pode usar `git merge -s subtree` e ele irá funcionar normalmente; mas o Git também irá fazer o merge do histórico, coisa que você provavelmente não quer. Para trazer as alterações e preencher a mensagem de commit, use as opções `--squash` e `--no-commit` com a opção de estratégia `-s subtree`:

    $ git checkout master
    $ git merge --squash -s subtree --no-commit rack_branch
    Squash commit -- not updating HEAD
    Automatic merge went well; stopped before committing as requested

Foi feito o merge de todas suas alterações do projeto Rack e elas estão prontas para o commit local. Você também pode fazer o oposto — alterar o subdiretório `rack` do seu branch master e depois fazer o merge delas no seu branch `rack_branch` para enviá-las para os mantenedores do projeto ou para o projeto original.

Para ver o diff entre o que você tem no seu subdiretório `rack` e o código no seu branch `rack_branch` — para ver se você precisa fazer o merge deles — você não pode usar o comando `diff`. Em vez disso, você precisa executar `git diff-tree` com o branch que você quer comparar:

    $ git diff-tree -p rack_branch

Ou, para comparar o que tem no seu subdiretório `rack` com o que estava no branch `master` no servidor na última vez que você se conectou a ele, você pode executar

    $ git diff-tree -p rack_remote/master

## Sumário ##

Você viu algumas ferramentas avançadas que permitem que você manipule seus commits e área de seleção mais precisamente. Quando você notar problemas, você deve ser capaz de descobrir facilmente qual commit os introduziram, quando, e quem. Se você quer usar subprojetos em seu projeto, você aprendeu algumas maneiras de resolver essas necessidades. Neste momento, você deve ser capaz de fazer a maioria das coisas que você precisa diariamente com o Git na linha de comando e se sentir confortável fazendo isso.
