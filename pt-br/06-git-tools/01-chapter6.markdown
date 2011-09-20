# Ferramentas do Git #

Até aqui, você aprendeu a maioria dos comandos e fluxos de trabalho do dia-a-dia que você precisa para gerenciar ou manter um repositório Git para o controle de seu código fonte. Você concluiu as tarefas básicas de rastreamento e commit de arquivos, e você aproveitou o poder da área de seleção e branches tópicos e merges leves.

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

Git pode descobrir uma abreviação curta, única para seus valores SHA-1. Se você informar `--abbrev-commit` para o comando `git log`, a saída irá usar valores curtos mas os mantém únicos; por padrão ele usa sete caracteres mas usa mais se necessário para manter o SHA-1 não ambíguo:

	$ git log --abbrev-commit --pretty=oneline
	ca82a6d changed the verison number
	085bb3b removed unnecessary test code
	a11bef0 first commit

Geralmente, entre oito e dez caracteres são mais que suficientes para ser único em um projeto. Um dos maiores projetos no Git, o kernel do Linux, está começando a ter a necessidade de 12 caracteres dos 40 possíveis para ser único.

### UMA NOTA SOBRE SHA-1 ###

Muitas pessoas ficam preocupadas que em algum momento elas terão, por coincidência aleatória, dois objetos em seus repósitorios com hash com o mesmo valor de SHA-1. O que fazer?

Se acontecer de você fazer um commit de um objeto que tem o hash com o mesmo valor de SHA-1 de um objeto existente no seu repositório, GIt notará o primeiro objeto existente no seu banco de dados e assumirá que ele já foi gravado. Se você tentar fazer o checkout desse objeto novamente em algum momento, sempre receberá os dados do primeiro objeto.

Porém, você deve estar ciente de quão ridiculamente improvável é esse cenário. O código SHA-1 tem 20 bytes ou 160 bits. O número de objetos com hashes aleatórios necessários para garantir a probabilidade de 50% de uma única colisão é cerca de 2^80 (a fórmula para determinar a probabilidade de colisão é `p = (n(n-1)/2) * (1/2^160))`. 2^80 é 1.2 x 10^24 ou 1 milhão de bilhões de bilhões. Isso é 1.200 vezes o número de grãos de areia na Terra.

Aqui está um exemplo para lhe dar uma idéia do que seria necessário para obter uma colisão de SHA-1. Se todos os 6,5 bilhões de humanos na Terra estivessem programando, e a cada segundo, cada um estivesse produzindo código que é equivalente ao histórico inteiro do kernel do Linux (1 milhão de objetos Git) e fazendo o push para um enorme repositório Git, levaria 5 anos até que esse repositório tenha objetos suficientes para ter uma probabilidade de 50% de uma única colisão de objetos SHA-1. Existe uma probabilidade maior de cada membro do seu time de programação ser atacado e morto por lobos na mesma noite em incidentes sem relação.

### Referências de Branch ###

A maneira mais simples de especificar um commit requer que ele tenha uma referência de um branch apontando para ele. Então, você pode usar um nome de branch em qualquer comando no Git que espera um objeto commit ou valor SHA-1. Por exemplo, se você quer mostrar o último objeto commit em um branch, os seguintes comandos são equivalentes, assumindo que o branch `topic1` aponta para `ca82a6d`:

	$ git show ca82a6dff817ec66f44342007202690a93763949
	$ git show topic1

Se você quer ver para qual SHA específico um branch aponta, ou se você quer ver o que qualquer desses exemplos se resumem em termos de SHAs, você pode usar uma ferramenta de canalização do Git chamada `rev-parse`. Você pode ver o Capítulo 9 para mais informações sobre ferramentas de canalização (plumbing); basicamente, `rev-parse` existe para operações de baixo nível e não é projetada para ser usada em operações do dia-a-dia. Entretanto, ela as vezes pode ser útil quando você precisa ver o que realmente está acontecendo. Aqui você pode executar `rev-parse` no seu branch.

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

A outra principal maneira de especificar um commit é através de seu ancestral. Se você colocar um `^` no final da referência, Git interpreta isso como sendo o pai do commit.
Suponha que você veja o histórico do seu projeto:

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

Você também pode informar um número depois do `^` — por exemplo, `d921970^2` significa "o segundo pai de d921970." Essa sintaxe só é útil para commits com merge, que têm mais de um pai. O primeiro pai é o branch é onde você estava quando fez o merge, e o segundo é o commit no branch que você fez o merge:

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

Agora que você pode especificar commits individuais, vamos ver como especificar intervalos de commits. Isso é particularmente útil para gerenciar seus branches — se você tem muitos branches, você pode usar especificações de intervalos para responder perguntas como, "Que modificações existem nesse branch que eu ainda não fiz o merge no meu branch principal?".

#### Ponto Duplo ####

A especificação de intervalo mais comum é a sintaxe de ponto-duplo. Isso basicamente pede ao Git para encontrar um intervalo de commits que é acessível a partir de um commit, mas não são acessível a partir de outro. Por exemplo, digamos que você tem um histórico de commits como a Figure 6-1.

Insert 18333fig0601.png 
Figure 6-1. Exemplo de histórico de seleção de intervalo

Você quer ver o que tem no seu branch experiment que ainda não foi feito o merge no branch master. Você pede ao Git para mostrar um log de apenas esses commits com `master..experiment` — isso significa "todos os commits acessíveis por experiment que não são acessíveis por master." Para deixar os exemplos mais breves e claros, vou usar as letras dos objetos dos commits do diagrama no lugar da saída real do log na ordem que eles seriam mostrados:

	$ git log master..experiment
	D
	C

Se, por outro lado, você quer ver o oposto — todos os commits em `master` que não estão em `experiment` — você pode inverter os nomes dos branches. `experiment..master` exibe tudo em `master` que não é acessível em `experiment`:

	$ git log experiment..master
	F
	E

Isso é útil se você quer manter o branch `experiment` atualizado e visualizar que merge você está prestes a fazer. Outro uso muito freqüente desta sintaxe é para ver o que você está prestes a enviar para um remoto:

	$ git log origin/master..HEAD

Esse comando lhe mostra qualquer commit no seu branch atual que não está no branch `master` no seu remoto `origin`. Se você executar um `git push` e seu branch atual está rastreando `origin/master`, os commits listados por `git log origin/master..HEAD` são os commits que serão transferidos para o servidor.
Você também pode não informar um lado da sintaxe que o Git assumirá ser HEAD. Por exemplo, você pode obter os mesmos resultados que no exemplo anterior digitando `git log origin/master..` — Git substitui HEAD se um dos lados está faltando.

#### Múltiplos Pontos ####

A sintaxe ponto-duplo é útil como um atalho; mas talvez você queira especificar mais de dois branches para indicar suar revisão, como ver quais commits não estão nenhum dos branches que não estão no branch que você está atualmente. Git permite que você faça isso usando o caractere `^` ou `--not` antes de qualquer referência a partir do qual você não quer ver commits acessíveis. Assim, estes três comandos são equivalentes:

	$ git log refA..refB
	$ git log ^refA refB
	$ git log refB --not refA

Isso é bom porque com essa sintaxe você pode especificar mais de duas referências em sua consulta, o que você não pode fazer com a sintaxe ponto-duplo. Por exemplo, se você quer ver todos os commits que são acessíveis de `refA` ou `refB` mas não de `refC`, você pode digitar um desses:

	$ git log refA refB ^refC
	$ git log refA refB --not refC

Isso faz um sistema de consulta de revisão muito poderoso que deve ajudá-lo a descobrir o que existe nos seus branches.

#### Ponto Triplo ####

A última grande sintaxe de intervalo de seleção é a sintaxe ponto-triplo, que especifica todos os commits que são acessíveis por qualquer uma das duas referências mas não por ambas. Veja novamente o exemplo de histórico de commits na Figure 6-1.
Se você quer ver o que tem em `master` ou `experiment` mas sem referências comuns, você pode executar

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

Com essas ferramentas, você pode informar o Git mais facilmente qual ou quais commits você quer inspecionar. 

## Área de Seleção Interativa ##

Git vem com alguns scripts que facilitam algumas tarefas de linha de comando. Aqui, você verá alguns comandos interativos que podem ajudar você a facilmente escolher combinações ou partes de arquivos para incorporar em um commit. Essas ferramentas são muito úteis se você modificou vários arquivos e decidiu que quer essas modificações em commits separados em vez de um grande e bagunçado commit. Desta maneira, você pode ter certeza que seus commits estão logicamente separados e podem ser facilmente revisados pelos outros desenvolvedores trabalhando com você.
Se você executar `git add` com a opção `-i` ou `--interactive`, Git entra em um modo interativo de shell, exibindo algo desse tipo:

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

Para ver o diff do que você adicionou, você pode usar o comando `6` ou `d` (para diff). Ele exibe uma lista dos seus arquivos adicionados, e você pode selecionar aqueles que você gostaria de ver a diferença. Isso é muito parecido como informar o comando `git diff --cached`:

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

No Git também é possível adicionar certas partes de arquivos e deixar o resto fora. Por exemplo, se você faz duas mudanças no seu arquivo simplegit.rb e quer adicionar uma delas mas não a outra, fazer isso é muito fácil no Git. A partir do prompt interativo, digite `5` ou `p` (para patch). Git irá perguntar quais arquivos você gostaria de adicionar parcialmente; então, para cada seção dos arquivos selecionados, ele irá exibir partes do diff do arquivo e perguntar se você gostaria de adicioná-los, um por um:

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
	# Changed but not updated:
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
	nothing to commit (working directory clean)

Neste momento, você pode facilmente mudar de branch e trabalhar em outra coisa; suas alterações estão armazenadas na sua pilha. Para ver as stashes que você guardou, você pode usar `git stash list`:

	$ git stash list
	stash@{0}: WIP on master: 049d078 added the index file
	stash@{1}: WIP on master: c264051... Revert "added file_size"
	stash@{2}: WIP on master: 21d80a5... added number to log

Nesse caso, duas stashes tinham sido feitas anteriormente, então você tem acesso a três stashed de trabalhos diferentes. Você pode aplicar aquele que acabou de fazer o stash com o comando mostrado na saída de ajuda do comando stash original: `git stash apply`. Se você quer aplicar um dos stashes mais antigos, você pode especificá-lo, assim: `git stash apply stash@{2}`. Se você não especificar um stash, Git assume que é o stash mais recente e tenta aplicá-lo:

	$ git stash apply
	# On branch master
	# Changed but not updated:
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
	# Changed but not updated:
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
    $ git stash
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
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#      modified:   lib/simplegit.rb
	#
	Dropped refs/stash@{0} (f0dfc4d5dc332d1cee34a634182e168c4efc3359)

Este é um bom atalho para recuperar facilmente as modificações em um stash e trabalhar nele em um novo branch.

## Reescrevendo o Histórico ##

Muitas vezes, trabalhando com o Git, você pode querer revisar seu histórico de commits por alguma razão. Uma grande coisas do Git é que ele permite você tomar decisões no último momento possível. Você pode decidir quais arquivos vai em qual commit um pouco antes de fazer o commit da área de seleção, você pode decidir que não quer trabalhar em alguma coisa ainda com o comando stash, e você pode reescrever commits que já aconteceram para que eles pareçam ter acontecido de outra maneira. Isso pode envolver mudar a ordem dos commits, alterar mensagens ou arquivos em um commit, juntar ou separar commits, ou remover commits completamente — tudo isso antes de compartilhar seu trabalho com os outros.

Nesta seção, você verá como realizar essas tarefas muito úteis de modo que você pode fazer seu histórico de commits parecer da forma que você quer antes de compartilhá-lo com outros.

### Alterando o Último Commit ###

Modificar o último commit é provavelmente a alteração de histórico mais comum que você irá fazer. Muitas vezes você vai querer fazer duas coisas básicas com seu último commit: mudar a mensagem do commit, ou mudar o snapshot que você acabou de salvar, adicionando, alterando e removendo arquivos.

Se você quer somente modificar a mensagem do seu último commit, é muito simples:

	$ git commit --amend

Isso abre seu editor de texto, com sua última mensagem de commit nele, pronto para você modificar a mensagem. Quando você salva e fecha o editor, ele salva um novo commit contendo essa mensagem e fazendo esse seu novo commit mais recente.

Se você fez o commit e quer alterar o snapshot adicionando ou modificando arquivos, possivelmente porque você esqueceu de adicionar um arquivo novo quando fez o commit original, o processo funciona basicamente da mesma maneira. Você adiciona as alterações que deseja na área de seleção editando um arquivo e executando `git add` nele ou `git rm` em um arquivo rastreado, e depois `git commit --amend` pega sua área de seleção atual e faz o snapshot para o novo commit.

Você precisa ter cuidado com essa técnica porque isso muda o SHA-1 do commit. É como um rebase muito pequeno — não altere seu último commit se você já fez o push dele.

### Alterando Várias Mensagens de Commit ###

Para modificar um commit que está mais atrás em seu histórico, você deve usar ferramentas mais complexas. Git não tem uma ferramenta de modificação de histórico, mas você pode usar o rebase para alterar uma série de commits no HEAD onde eles estavam originalmente em vez de movê-los para um novo. Com a ferramenta de rebase interativo, você pode parar depois de cada commit que quer modificar e alterar a mensagem, adicionar arquivos, ou fazer o que quiser. Você pode executar o rebase de forma interativa adicionando a opção `-i` em `git rebase`. Você deve indicar quão longe você quer reescrever os commits informando ao comando qual commit quer fazer o rebase.

Por exemplo, se você quer alterar as mensagens dos últimos três commits, ou qualquer mensagem de commit nesse grupo, você informa como argumento para `git rebase -i` o pai do último commit que você quer editar, que é `HEAD~2^` ou `HEAD~3`. Pode ser mais fácil de lembrar o `~3` porque você está tentando editar os últimos três commits; mas lembre-se que você está indicando realmente quatro commits atrás, o pai do último que você deseja editar:

	$ git rebase -i HEAD~3

Lembre-se que isso é um comando rebase — todos os commits no intervalo `HEAD~3..HEAD` serão reescritos, quer você mude a mensagem ou não. Não inclua nenhum commit que você já enviou a um servidor central — fazer isso irá confudir outros desenvolvedores fornecendo uma versão alternativa da mesma alteração.

Executando esse comando dar a você uma lista de commits no seu editor de texto que se parece com isso:

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

É importante notar que esses commits são listados na ordem inversa do que você normalmente ver usando o comando `log`. Se você executar o `log`, você vê algo como isto:

	$ git log --pretty=format:"%h %s HEAD~3..HEAD"
	a5f4a0d added cat-file
	310154e updated README formatting and added blame
	f7f3f6d changed my name a bit

Observe a ordem inversa. O rebase interativo lhe da um script que ele irá executar. Ele começará no commit que você especifica na linha de comando (`HEAD~3`) e repete as modificações introduzidas em cada um desses commits de cima para baixo. Ele lista o mais antigo primeiro, em vez do mais recente, porque ele vai ser o primeiro a ser alterado.

Você precisa editar o script para que ele pare no commit que você deseja editar. Para fazer isso, mude a palavra "pick" para a palavra "edit" para cada um dos commits que você deseja que o script pare. Por exemplo, para alterar somente a terceira mensagem de commit, você alterar o arquivo para ficar assim:

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

Esse comando irá aplicar nos outros dois commits automaticamente, e pronto. Se você alterar "pick" para "edit" em mais linhas, você pode repetir esses passos para cada commit que mudar para "edit". Cada vez, Git irá parar, permitir que você altere o commit, e continuar quando você estiver terminado.

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

Se, em vez de "pick" ou "edit", você especificar "squash", Git modifica essa e a alteração imediatamente anterior a ela e faz com que você faça o merge das mensagens de commits. Então, se você quer fazer um único commit a partir desses três commits, você modifica o script para algo como isso:

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

Quando você salva isso, você tem um único commit com as alterações dos três commits anteriores.

### Dividindo um Commit ###

Dividir um commit significa desfazer um commit e parcialmente adicionar a área de seleção e fazer commit dependendo do número de commits que você quer. Por exemplo, digamos que você quer dividir o commit do meio daqueles seus três commits. Em vez de "updated README formatting and added blame", você quer dividí-lo em dois commits: "updated README formatting" no primeiro, e "added blame" no segundo. Você pode fazer isso no script `rebase -i` mudando a instrução para "edit" no commit que você quer dividir:

	pick f7f3f6d changed my name a bit
	edit 310154e updated README formatting and added blame
	pick a5f4a0d added cat-file

Depois, quando o script colocar você na linha de comando, você faz o reset desse commit, pega as alterações desse reset, e cria vários commits delas. Quando você salva e sai do editor, Git volta ao pai do primeiro commit da sua lista, altera o primeiro commit (`f7f3f6d`), altera o segundo (`310154e`), e tira você do console. Lá, você pode fazer um reset desse commit com `git reset HEAD^`, que efetivamente desfaz o commit e deixa os arquivos alterados fora da área de seleção. Agora você pode colocar na área de seleção e fazer vários commits, e executar `git rebase --continue` quando estiver pronto:

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

Mais uma vez, isso altera os SHAs de todos os commits na sua lista, então certifique-se que você não fez o push de nenhum commit dessa lista para uma repositório compartilhado.

### A Opção Nuclear: filter-branch ###

Existe uma outra opção de reescrita de histórico que você pode usar se precisa reescrever um grande número de commits em forma de script — por exemplo, mudar seu endereço de e-mail globalmente ou remover um arquivo de cada commit. O camando é `filter-branch`, e ele pode reescrever uma grande parte do seu histórico, então você não deve usá-lo a menos que seu projeto ainda não seja público e outras pessoas não se basearam nos commits que você está para reescrever. Porém, ele pode ser muito útil. Você irá aprender alguns usos comuns para ter uma idéia do que ele é capaz.

#### Removendo um Arquivo de Cada Commit ####

Isso é bastante comum de acontecer. Alguém acidentalmente faz um commit sem pensar de um arquivo binário gigante com `git add .`, e você quer removê-lo de todos os lugares. Talvez você tenha feito o commit de um arquivo que continha uma senha, e você quer liberar o código fonte do seu projeto. `filter-branch` é a ferramenta que você pode usar para limpar completamente seu histórico. Para remover um arquivo chamado passwords.txt completamente do seu histórico, você pode usar a opção `--tree-filter` em `filter-branch`:

	$ git filter-branch --tree-filter 'rm -f passwords.txt' HEAD
	Rewrite 6b9b3cf04e7c5686a9cb838c3f36a8cb6a0fc2bd (21/21)
	Ref 'refs/heads/master' was rewritten

A opção `--tree-filter` executa o comando especificado depois de cada checkout do projeto e faz o commit do resultado novamente. Neste caso, você está removendo um arquivo chamado passwords.txt de cada snapshot, quer ele exista ou não. Se você quer remover todos os arquivos de backup do editor que entraram em commits acidentalmente, você pode executar algo como `git filter-branch --tree-filter 'rm -f *~' HEAD`.

Você irá assistir o Git reescrever árvores e commits e, em seguida, no final, mover a referência do branch. Geralmente é uma boa idéia fazer isso em um branch de teste e depois fazer um hard-reset do seu branch master depois que você viu que isso era realmente o que queria fazer. Para executar `filter-branch` em todos os seus branches, você pode informar `--all` ao comando.

#### Fazendo um Subdiretório o Novo Raíz ####

Digamos que você importou arquivos de outro sistema de controle de versão e ele tem subdiretórios que não fazem sentido (trunk, tags, and so on). Se você quer fazer o subdiretório `trunk` ser a nova raíz do projeto para todos os commits, `filter-branch` pode ajudar a fazer isso, também:

	$ git filter-branch --subdirectory-filter trunk HEAD
	Rewrite 856f0bf61e41a27326cdae8f09fe708d679f596f (12/12)
	Ref 'refs/heads/master' was rewritten

Agora a sua nova raíz do projeto é o que estava no subdiretório `trunk`. Git também apagará automaticamente os commits que não afetaram o subdiretório. 

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

## Debugging with Git ##

Git also provides a couple of tools to help you debug issues in your projects. Because Git is designed to work with nearly any type of project, these tools are pretty generic, but they can often help you hunt for a bug or culprit when things go wrong.

### File Annotation ###

If you track down a bug in your code and want to know when it was introduced and why, file annotation is often your best tool. It shows you what commit was the last to modify each line of any file. So, if you see that a method in your code is buggy, you can annotate the file with `git blame` to see when each line of the method was last edited and by whom. This example uses the `-L` option to limit the output to lines 12 through 22:

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

Notice that the first field is the partial SHA-1 of the commit that last modified that line. The next two fields are values extracted from that commit—the author name and the authored date of that commit — so you can easily see who modified that line and when. After that come the line number and the content of the file. Also note the `^4832fe2` commit lines, which designate that those lines were in this file’s original commit. That commit is when this file was first added to this project, and those lines have been unchanged since. This is a tad confusing, because now you’ve seen at least three different ways that Git uses the `^` to modify a commit SHA, but that is what it means here.

Another cool thing about Git is that it doesn’t track file renames explicitly. It records the snapshots and then tries to figure out what was renamed implicitly, after the fact. One of the interesting features of this is that you can ask it to figure out all sorts of code movement as well. If you pass `-C` to `git blame`, Git analyzes the file you’re annotating and tries to figure out where snippets of code within it originally came from if they were copied from elsewhere. Recently, I was refactoring a file named `GITServerHandler.m` into multiple files, one of which was `GITPackUpload.m`. By blaming `GITPackUpload.m` with the `-C` option, I could see where sections of the code originally came from:

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

This is really useful. Normally, you get as the original commit the commit where you copied the code over, because that is the first time you touched those lines in this file. Git tells you the original commit where you wrote those lines, even if it was in another file.

### Binary Search ###

Annotating a file helps if you know where the issue is to begin with. If you don’t know what is breaking, and there have been dozens or hundreds of commits since the last state where you know the code worked, you’ll likely turn to `git bisect` for help. The `bisect` command does a binary search through your commit history to help you identify as quickly as possible which commit introduced an issue.

Let’s say you just pushed out a release of your code to a production environment, you’re getting bug reports about something that wasn’t happening in your development environment, and you can’t imagine why the code is doing that. You go back to your code, and it turns out you can reproduce the issue, but you can’t figure out what is going wrong. You can bisect the code to find out. First you run `git bisect start` to get things going, and then you use `git bisect bad` to tell the system that the current commit you’re on is broken. Then, you must tell bisect when the last known good state was, using `git bisect good [good_commit]`:

	$ git bisect start
	$ git bisect bad
	$ git bisect good v1.0
	Bisecting: 6 revisions left to test after this
	[ecb6e1bc347ccecc5f9350d878ce677feb13d3b2] error handling on repo

Git figured out that about 12 commits came between the commit you marked as the last good commit (v1.0) and the current bad version, and it checked out the middle one for you. At this point, you can run your test to see if the issue exists as of this commit. If it does, then it was introduced sometime before this middle commit; if it doesn’t, then the problem was introduced sometime after the middle commit. It turns out there is no issue here, and you tell Git that by typing `git bisect good` and continue your journey:

	$ git bisect good
	Bisecting: 3 revisions left to test after this
	[b047b02ea83310a70fd603dc8cd7a6cd13d15c04] secure this thing

Now you’re on another commit, halfway between the one you just tested and your bad commit. You run your test again and find that this commit is broken, so you tell Git that with `git bisect bad`:

	$ git bisect bad
	Bisecting: 1 revisions left to test after this
	[f71ce38690acf49c1f3c9bea38e09d82a5ce6014] drop exceptions table

This commit is fine, and now Git has all the information it needs to determine where the issue was introduced. It tells you the SHA-1 of the first bad commit and show some of the commit information and which files were modified in that commit so you can figure out what happened that may have introduced this bug:

	$ git bisect good
	b047b02ea83310a70fd603dc8cd7a6cd13d15c04 is first bad commit
	commit b047b02ea83310a70fd603dc8cd7a6cd13d15c04
	Author: PJ Hyett <pjhyett@example.com>
	Date:   Tue Jan 27 14:48:32 2009 -0800

	    secure this thing

	:040000 040000 40ee3e7821b895e52c1695092db9bdc4c61d1730
	f24d3c6ebcfc639b1a3814550e62d60b8e68a8e4 M  config

When you’re finished, you should run `git bisect reset` to reset your HEAD to where you were before you started, or you’ll end up in a weird state:

	$ git bisect reset

This is a powerful tool that can help you check hundreds of commits for an introduced bug in minutes. In fact, if you have a script that will exit 0 if the project is good or non-0 if the project is bad, you can fully automate `git bisect`. First, you again tell it the scope of the bisect by providing the known bad and good commits. You can do this by listing them with the `bisect start` command if you want, listing the known bad commit first and the known good commit second:

	$ git bisect start HEAD v1.0
	$ git bisect run test-error.sh

Doing so automatically runs `test-error.sh` on each checked-out commit until Git finds the first broken commit. You can also run something like `make` or `make tests` or whatever you have that runs automated tests for you.

## Submodules ##

It often happens that while working on one project, you need to use another project from within it. Perhaps it’s a library that a third party developed or that you’re developing separately and using in multiple parent projects. A common issue arises in these scenarios: you want to be able to treat the two projects as separate yet still be able to use one from within the other.

Here’s an example. Suppose you’re developing a web site and creating Atom feeds. Instead of writing your own Atom-generating code, you decide to use a library. You’re likely to have to either include this code from a shared library like a CPAN install or Ruby gem, or copy the source code into your own project tree. The issue with including the library is that it’s difficult to customize the library in any way and often more difficult to deploy it, because you need to make sure every client has that library available. The issue with vendoring the code into your own project is that any custom changes you make are difficult to merge when upstream changes become available.

Git addresses this issue using submodules. Submodules allow you to keep a Git repository as a subdirectory of another Git repository. This lets you clone another repository into your project and keep your commits separate.

### Starting with Submodules ###

Suppose you want to add the Rack library (a Ruby web server gateway interface) to your project, possibly maintain your own changes to it, but continue to merge in upstream changes. The first thing you should do is clone the external repository into your subdirectory. You add external projects as submodules with the `git submodule add` command:

	$ git submodule add git://github.com/chneukirchen/rack.git rack
	Initialized empty Git repository in /opt/subtest/rack/.git/
	remote: Counting objects: 3181, done.
	remote: Compressing objects: 100% (1534/1534), done.
	remote: Total 3181 (delta 1951), reused 2623 (delta 1603)
	Receiving objects: 100% (3181/3181), 675.42 KiB | 422 KiB/s, done.
	Resolving deltas: 100% (1951/1951), done.

Now you have the Rack project under a subdirectory named `rack` within your project. You can go into that subdirectory, make changes, add your own writable remote repository to push your changes into, fetch and merge from the original repository, and more. If you run `git status` right after you add the submodule, you see two things:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#      new file:   .gitmodules
	#      new file:   rack
	#

First you notice the `.gitmodules` file. This is a configuration file that stores the mapping between the project’s URL and the local subdirectory you’ve pulled it into:

	$ cat .gitmodules 
	[submodule "rack"]
	      path = rack
	      url = git://github.com/chneukirchen/rack.git

If you have multiple submodules, you’ll have multiple entries in this file. It’s important to note that this file is version-controlled with your other files, like your `.gitignore` file. It’s pushed and pulled with the rest of your project. This is how other people who clone this project know where to get the submodule projects from.

The other listing in the `git status` output is the rack entry. If you run `git diff` on that, you see something interesting:

	$ git diff --cached rack
	diff --git a/rack b/rack
	new file mode 160000
	index 0000000..08d709f
	--- /dev/null
	+++ b/rack
	@@ -0,0 +1 @@
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

Although `rack` is a subdirectory in your working directory, Git sees it as a submodule and doesn’t track its contents when you’re not in that directory. Instead, Git records it as a particular commit from that repository. When you make changes and commit in that subdirectory, the superproject notices that the HEAD there has changed and records the exact commit you’re currently working off of; that way, when others clone this project, they can re-create the environment exactly.

This is an important point with submodules: you record them as the exact commit they’re at. You can’t record a submodule at `master` or some other symbolic reference.

When you commit, you see something like this:

	$ git commit -m 'first commit with submodule rack'
	[master 0550271] first commit with submodule rack
	 2 files changed, 4 insertions(+), 0 deletions(-)
	 create mode 100644 .gitmodules
	 create mode 160000 rack

Notice the 160000 mode for the rack entry. That is a special mode in Git that basically means you’re recording a commit as a directory entry rather than a subdirectory or a file.

You can treat the `rack` directory as a separate project and then update your superproject from time to time with a pointer to the latest commit in that subproject. All the Git commands work independently in the two directories:

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

### Cloning a Project with Submodules ###

Here you’ll clone a project with a submodule in it. When you receive such a project, you get the directories that contain submodules, but none of the files yet:

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

The `rack` directory is there, but empty. You must run two commands: `git submodule init` to initialize your local configuration file, and `git submodule update` to fetch all the data from that project and check out the appropriate commit listed in your superproject:

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

Now your `rack` subdirectory is at the exact state it was in when you committed earlier. If another developer makes changes to the rack code and commits, and you pull that reference down and merge it in, you get something a bit odd:

	$ git merge origin/master
	Updating 0550271..85a3eee
	Fast forward
	 rack |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)
	[master*]$ git status
	# On branch master
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#      modified:   rack
	#

You merged in what is basically a change to the pointer for your submodule; but it doesn’t update the code in the submodule directory, so it looks like you have a dirty state in your working directory:

	$ git diff
	diff --git a/rack b/rack
	index 6c5e70b..08d709f 160000
	--- a/rack
	+++ b/rack
	@@ -1 +1 @@
	-Subproject commit 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	+Subproject commit 08d709f78b8c5b0fbeb7821e37fa53e69afcf433

This is the case because the pointer you have for the submodule isn’t what is actually in the submodule directory. To fix this, you must run `git submodule update` again:

	$ git submodule update
	remote: Counting objects: 5, done.
	remote: Compressing objects: 100% (3/3), done.
	remote: Total 3 (delta 1), reused 2 (delta 0)
	Unpacking objects: 100% (3/3), done.
	From git@github.com:schacon/rack
	   08d709f..6c5e70b  master     -> origin/master
	Submodule path 'rack': checked out '6c5e70b984a60b3cecd395edd5b48a7575bf58e0'

You have to do this every time you pull down a submodule change in the main project. It’s strange, but it works.

One common problem happens when a developer makes a change locally in a submodule but doesn’t push it to a public server. Then, they commit a pointer to that non-public state and push up the superproject. When other developers try to run `git submodule update`, the submodule system can’t find the commit that is referenced, because it exists only on the first developer’s system. If that happens, you see an error like this:

	$ git submodule update
	fatal: reference isn’t a tree: 6c5e70b984a60b3cecd395edd5b48a7575bf58e0
	Unable to checkout '6c5e70b984a60b3cecd395edd5ba7575bf58e0' in submodule path 'rack'

You have to see who last changed the submodule:

	$ git log -1 rack
	commit 85a3eee996800fcfa91e2119372dd4172bf76678
	Author: Scott Chacon <schacon@gmail.com>
	Date:   Thu Apr 9 09:19:14 2009 -0700

	    added a submodule reference I will never make public. hahahahaha!

Then, you e-mail that guy and yell at him.

### Superprojects ###

Sometimes, developers want to get a combination of a large project’s subdirectories, depending on what team they’re on. This is common if you’re coming from CVS or Subversion, where you’ve defined a module or collection of subdirectories, and you want to keep this type of workflow.

A good way to do this in Git is to make each of the subfolders a separate Git repository and then create superproject Git repositories that contain multiple submodules. A benefit of this approach is that you can more specifically define the relationships between the projects with tags and branches in the superprojects.

### Issues with Submodules ###

Using submodules isn’t without hiccups, however. First, you must be relatively careful when working in the submodule directory. When you run `git submodule update`, it checks out the specific version of the project, but not within a branch. This is called having a detached head — it means the HEAD file points directly to a commit, not to a symbolic reference. The issue is that you generally don’t want to work in a detached head environment, because it’s easy to lose changes. If you do an initial `submodule update`, commit in that submodule directory without creating a branch to work in, and then run `git submodule update` again from the superproject without committing in the meantime, Git will overwrite your changes without telling you.  Technically you won’t lose the work, but you won’t have a branch pointing to it, so it will be somewhat difficult to retrieive.

To avoid this issue, create a branch when you work in a submodule directory with `git checkout -b work` or something equivalent. When you do the submodule update a second time, it will still revert your work, but at least you have a pointer to get back to.

Switching branches with submodules in them can also be tricky. If you create a new branch, add a submodule there, and then switch back to a branch without that submodule, you still have the submodule directory as an untracked directory:

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

You have to either move it out of the way or remove it, in which case you have to clone it again when you switch back—and you may lose local changes or branches that you didn’t push up.

The last main caveat that many people run into involves switching from subdirectories to submodules. If you’ve been tracking files in your project and you want to move them out into a submodule, you must be careful or Git will get angry at you. Assume that you have the rack files in a subdirectory of your project, and you want to switch it to a submodule. If you delete the subdirectory and then run `submodule add`, Git yells at you:

	$ rm -Rf rack/
	$ git submodule add git@github.com:schacon/rack.git rack
	'rack' already exists in the index

You have to unstage the `rack` directory first. Then you can add the submodule:

	$ git rm -r rack
	$ git submodule add git@github.com:schacon/rack.git rack
	Initialized empty Git repository in /opt/testsub/rack/.git/
	remote: Counting objects: 3184, done.
	remote: Compressing objects: 100% (1465/1465), done.
	remote: Total 3184 (delta 1952), reused 2770 (delta 1675)
	Receiving objects: 100% (3184/3184), 677.42 KiB | 88 KiB/s, done.
	Resolving deltas: 100% (1952/1952), done.

Now suppose you did that in a branch. If you try to switch back to a branch where those files are still in the actual tree rather than a submodule — you get this error:

	$ git checkout master
	error: Untracked working tree file 'rack/AUTHORS' would be overwritten by merge.

You have to move the `rack` submodule directory out of the way before you can switch to a branch that doesn’t have it:

	$ mv rack /tmp/
	$ git checkout master
	Switched to branch "master"
	$ ls
	README	rack

Then, when you switch back, you get an empty `rack` directory. You can either run `git submodule update` to reclone, or you can move your `/tmp/rack` directory back into the empty directory.

## Subtree Merging ##

Now that you’ve seen the difficulties of the submodule system, let’s look at an alternate way to solve the same problem. When Git merges, it looks at what it has to merge together and then chooses an appropriate merging strategy to use. If you’re merging two branches, Git uses a _recursive_ strategy. If you’re merging more than two branches, Git picks the _octopus_ strategy. These strategies are automatically chosen for you because the recursive strategy can handle complex three-way merge situations — for example, more than one common ancestor — but it can only handle merging two branches. The octopus merge can handle multiple branches but is more cautious to avoid difficult conflicts, so it’s chosen as the default strategy if you’re trying to merge more than two branches.

However, there are other strategies you can choose as well. One of them is the _subtree_ merge, and you can use it to deal with the subproject issue. Here you’ll see how to do the same rack embedding as in the last section, but using subtree merges instead.

The idea of the subtree merge is that you have two projects, and one of the projects maps to a subdirectory of the other one and vice versa. When you specify a subtree merge, Git is smart enough to figure out that one is a subtree of the other and merge appropriately — it’s pretty amazing.

You first add the Rack application to your project. You add the Rack project as a remote reference in your own project and then check it out into its own branch:

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

Now you have the root of the Rack project in your `rack_branch` branch and your own project in the `master` branch. If you check out one and then the other, you can see that they have different project roots:

	$ ls
	AUTHORS	       KNOWN-ISSUES   Rakefile      contrib	       lib
	COPYING	       README         bin           example	       test
	$ git checkout master
	Switched to branch "master"
	$ ls
	README

You want to pull the Rack project into your `master` project as a subdirectory. You can do that in Git with `git read-tree`. You’ll learn more about `read-tree` and its friends in Chapter 9, but for now know that it reads the root tree of one branch into your current staging area and working directory. You just switched back to your `master` branch, and you pull the `rack` branch into the `rack` subdirectory of your `master` branch of your main project:

	$ git read-tree --prefix=rack/ -u rack_branch

When you commit, it looks like you have all the Rack files under that subdirectory — as though you copied them in from a tarball. What gets interesting is that you can fairly easily merge changes from one of the branches to the other. So, if the Rack project updates, you can pull in upstream changes by switching to that branch and pulling:

	$ git checkout rack_branch
	$ git pull

Then, you can merge those changes back into your master branch. You can use `git merge -s subtree` and it will work fine; but Git will also merge the histories together, which you probably don’t want. To pull in the changes and prepopulate the commit message, use the `--squash` and `--no-commit` options as well as the `-s subtree` strategy option:

	$ git checkout master
	$ git merge --squash -s subtree --no-commit rack_branch
	Squash commit -- not updating HEAD
	Automatic merge went well; stopped before committing as requested

All the changes from your Rack project are merged in and ready to be committed locally. You can also do the opposite — make changes in the `rack` subdirectory of your master branch and then merge them into your `rack_branch` branch later to submit them to the maintainers or push them upstream.

To get a diff between what you have in your `rack` subdirectory and the code in your `rack_branch` branch — to see if you need to merge them — you can’t use the normal `diff` command. Instead, you must run `git diff-tree` with the branch you want to compare to:

	$ git diff-tree -p rack_branch

Or, to compare what is in your `rack` subdirectory with what the `master` branch on the server was the last time you fetched, you can run

	$ git diff-tree -p rack_remote/master

## Summary ##

You’ve seen a number of advanced tools that allow you to manipulate your commits and staging area more precisely. When you notice issues, you should be able to easily figure out what commit introduced them, when, and by whom. If you want to use subprojects in your project, you’ve learned a few ways to accommodate those needs. At this point, you should be able to do most of the things in Git that you’ll need on the command line day to day and feel comfortable doing so.
