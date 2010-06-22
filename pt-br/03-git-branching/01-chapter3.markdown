# Ramificação (Branching) no Git #

Quase todos os VCS tem alguma forma de suporte a ramificação (branching). Criar um ramo significa dizer que você vai divergir da linha principal de desenvolvimento e continuar a trabalhar sem bagunçar essa linha principal. Em muitas ferramentas VCS, este é um processo um pouco caro, muitas vezes exigindo que você crie uma nova cópia do seu diretório de código-fonte, que pode levar um longo tempo para grandes projetos.

Algumas pessoas se referem ao modelo de ramificação em Git como sua característica "matadora", e que certamente o destaca na comunidade de VCS. Por que ele é tão especial? A forma como o Git cria ramos é inacreditavelmente leve, fazendo com que as operações de ramificação sejam praticamente instantâneas e a alternância entre os ramos seja tão rápida quanto. Ao contrário de muitos outros VCSs, o Git incentiva um fluxo de trabalho no qual se façam ramos e mesclagens com frequência, até mesmo várias vezes ao dia. Compreender e dominar esta característica lhe dará uma ferramenta poderosa e única e poderá literalmente mudar a maneira como você desenvolve.

## O que é um Ramo (Branch) ##

Para compreender realmente a forma como o Git cria ramos, precisamos dar um passo atrás e examinar como o Git armazena seus dados. Como você pode se lembrar do capítulo 1, o Git não armazena dados como uma série de mudanças ou deltas, mas sim como uma série de snapshots.

Quando você faz uma submissão (commit) no Git, o Git submete um objeto que contém um ponteiro para o snapshot do conteúdo que você elencou, o autor e os metadados da mensagen, zero ou mais ponteiros para os commits ou commits que são pais deste commit: nenhum pai para o commit inicial, um pai para um commit normal e múltiplos pais para commits que resultem de uma mescla (merge) de dois ou mais ramos.

Para visualizar isso, vamos supor que você tenha um diretório contendo três arquivos, e elencou e submeteu todos eles. Elencar os checksums de cada um (o hash SHA-1 que nos referimos no capítulo 1), vai armazenar esta versão do arquivo no repositório Git (o Git se refere a eles como blobs), e acrescenta este checksum à área de seleção (staging area):

	$ git add README test.rb LICENSE2
	$ git commit -m 'initial commit of my project'

Quando você cria um commit executando `git commit`, o Git calcula o checksum de cada subdiretório (neste caso, apenas o diretório raiz do projeto) e armazena os objetos de árvore no repositório Git. O Git em seguida, cria um objeto commit que tem os metadados e um ponteiro para a raiz projeto, então ele pode recriar este snapshot quando noecessário.

Seu repositório Git já contém cinco objetos: um blob para o conteúdo de cada um dos três arquivos, uma árvore que lista o conteúdo do diretório e especifica quais nomes de arquivos são armazenados em quais blobs, e um commit com o ponteiro para a raiz dessa árvore com todos os metadados do commit. Conceitualmente, os dados em seu repositório Git se parecem como na Figura 3-1.

Insert 18333fig0301.png 
Figure 3-1. Dados de um repositório com um único commit.

Se você fizer algumas mudanças e submeter novamente, o próximo commit armazenará um ponteiro para commit imediatamente anterior. Depois de mais dois commits, seu histórico poderia ser algo como a Figura 3-2.

Insert 18333fig0302.png 
Dados dos objetos Git para múltiplos commits.

Um ramo no Git é simplesmente um leve ponteiro móvel um desses commits. O nome do ramo padrão no Git é master. Como você inicialmente fez commits, você tem um ramo principal (master branch) que aponta para o último commit que você fez. Cada vez que você submete (faz um commit) ele avança automaticamente.

Insert 18333fig0303.png 
Figure 3-3. Branch apontando para o histórico de commits

O que acontece se você criar um novo ramo? Bem, isso cria um novo ponteiro para que você possa se mover. Vamos dizer que você crie um novo ramo chamado teste. Você faz isso com o comando `git branch`:

	$ git branch testing

Isso cria um novo ponteiro para o mesmo commit em que você está no momento (ver a Figura 3-4).

Insert 18333fig0304.png 
Figura 3-4. Múltiplos ramos apontando para o histórico de commits

Como o Git sabe o ramo em que você está atualmente? Ele mantém um ponteiro especial chamado HEAD. Observe que isso é muito diferente do conceito de cabeça em outros VCSs que você possa ter usado, como Subversion e CVS. No Git, este é um ponteiro para o ramo local em que está no momento. Neste caso, você ainda está no master. O comando git branch só criou um novo ramo — ele não mudou para esse ramo (veja Figura 3-5).

Insert 18333fig0305.png 
Figura 3-5. HEAD apontando para o ramo em que você está

Para mudar para um ramo existente, você executa o comando `git checkout`. Vamos mudar para o novo ramo de testes:

	$ git checkout testing

Isto move o HEAD para apontar para o ramo de testes (ver Figura 3-6).

Insert 18333fig0306.png
Figura 3-6. O HEAD aponta para outro ramo quando você troca de ramos.

Qual é o significado disso? Bem, vamos fazer um outro commit:

	$ vim test.rb
	$ git commit -a -m 'made a change'

A figura 3-7 ilustra o resultado.

Insert 18333fig0307.png 
Figura 3-7. O ramo para o qual HEAD aponta se move à frente em cada commit.

Isso é interessante, porque agora o seu ramo de testes, avançou, mas o seu ramo mestre ainda aponta para o commit em que estava quando você executou `git checkout` para trocar de ramo. Vamos voltar para o ramo mestre (master branch):

	$ git checkout master

A figura 3-8 nostra o resultado.

Insert 18333fig0308.png 
Figura 3-8. O HEAD se move para outro ramo com um checkout.

Esse comando fez duas coisas. Ele alterou o ponteiro HEAD para apontar novamente para o ramo principal, e reverteu os arquivos em seu diretório de trabalho para o estado em que estavam no snapshot para o qual o master apontava. Isto significa também que as mudanças feitas a partir deste ponto em diante, irão divergir de uma versão anterior do projeto. Ele essencialmente "volta" o trabalho que você fez no seu ramo de testes, temporariamente, de modo que você possa ir em uma direção diferente a partir do master.

Vamos fazer algumas mudanças e submeter novamente:

	$ vim test.rb
	$ git commit -a -m 'made other changes'

Agora o histórico do seu projeto diverge (ver Figura 3-9). Você criou e trocou para um ramo, fez alguns trabalhos nele, e então voltou para o seu ramo principal e fez outros trabalhos. Ambas as mudanças são isoladas em ramos distintos: você pode alternar entre os ramos e fundi-los quando estiver pronto. E você fez tudo isso simplesmente com os comandos `branch` e `checkout`.

Insert 18333fig0309.png 
Figura 3-9. O histórico dos ramos diverge.

Por causa de um ramo em Git ser na verdade um arquivo simples que contém os 40 caracteres do checksum SHA-1 do commit para o qual ele aponta, os ramos são baratos para criar e destruir. Criar um novo ramo é tão rápido e simples como escrever 41 bytes em um arquivo (40 caracteres e uma nova linha).

Isto está em nítido contraste com a forma coma a qual a maioria das ferramentas VCS ramificam, que envolve a cópia de todos os arquivos do projeto para um segundo diretório. Isso pode demorar vários segundos ou até minutos, dependendo do tamanho do projeto, enquanto que no Git o processo é sempre instantâneo. Também, porque nós estamos gravando os pais dos objetos quando fazemos commits, encontrar uma boa base para mesclar (merge) é uma tarefa feita automaticamente para nós e geralmente é muito fácil de fazer. Esses recursos ajudam a estimular os desenvolvedores a criar e utilizar ramos com freqüência.

Vamos ver por que você deve fazê-lo.

__BLABOS__PAUSED__HERE__

## Basic Branching and Merging ##

Let’s go through a simple example of branching and merging with a workflow that you might use in the real world. You’ll follow these steps:

1.	Do work on a web site.
2.	Create a branch for a new story you’re working on.
3.	Do some work in that branch.

At this stage, you’ll receive a call that another issue is critical and you need a hotfix. You’ll do the following:

1.	Revert back to your production branch.
2.	Create a branch to add the hotfix.
3.	After it’s tested, merge the hotfix branch, and push to production.
4.	Switch back to your original story and continue working.

### Basic Branching ###

First, let’s say you’re working on your project and have a couple of commits already (see Figure 3-10).

Insert 18333fig0310.png 
Figure 3-10. A short and simple commit history

You’ve decided that you’re going to work on issue #53 in whatever issue-tracking system your company uses. To be clear, Git isn’t tied into any particular issue-tracking system; but because issue #53 is a focused topic that you want to work on, you’ll create a new branch in which to work. To create a branch and switch to it at the same time, you can run the `git checkout` command with the `-b` switch:

	$ git checkout -b iss53
	Switched to a new branch "iss53"

This is shorthand for 

	$ git branch iss53
	$ git checkout iss53

Figure 3-11 illustrates the result.

Insert 18333fig0311.png 
Figure 3-11. Creating a new branch pointer

You work on your web site and do some commits. Doing so moves the `iss53` branch forward, because you have it checked out (that is, your HEAD is pointing to it; see Figure 3-12):

	$ vim index.html
	$ git commit -a -m 'added a new footer [issue 53]'

Insert 18333fig0312.png 
Figure 3-12. The iss53 branch has moved forward with your work.

Now you get the call that there is an issue with the web site, and you need to fix it immediately. With Git, you don’t have to deploy your fix along with the `iss53` changes you’ve made, and you don’t have to put a lot of effort into reverting those changes before you can work on applying your fix to what is in production. All you have to do is switch back to your master branch.

However, before you do that, note that if your working directory or staging area has uncommitted changes that conflict with the branch you’re checking out, Git won’t let you switch branches. It’s best to have a clean working state when you switch branches. There are ways to get around this (namely, stashing and commit amending) that we’ll cover later. For now, you’ve committed all your changes, so you can switch back to your master branch:

	$ git checkout master
	Switched to branch "master"

At this point, your project working directory is exactly the way it was before you started working on issue #53, and you can concentrate on your hotfix. This is an important point to remember: Git resets your working directory to look like the snapshot of the commit that the branch you check out points to. It adds, removes, and modifies files automatically to make sure your working copy is what the branch looked like on your last commit to it.

Next, you have a hotfix to make. Let’s create a hotfix branch on which to work until it’s completed (see Figure 3-13):

	$ git checkout -b 'hotfix'
	Switched to a new branch "hotfix"
	$ vim index.html
	$ git commit -a -m 'fixed the broken email address'
	[hotfix]: created 3a0874c: "fixed the broken email address"
	 1 files changed, 0 insertions(+), 1 deletions(-)

Insert 18333fig0313.png 
Figure 3-13. hotfix branch based back at your master branch point

You can run your tests, make sure the hotfix is what you want, and merge it back into your master branch to deploy to production. You do this with the `git merge` command:

	$ git checkout master
	$ git merge hotfix
	Updating f42c576..3a0874c
	Fast forward
	 README |    1 -
	 1 files changed, 0 insertions(+), 1 deletions(-)

You’ll notice the phrase "Fast forward" in that merge. Because the commit pointed to by the branch you merged in was directly upstream of the commit you’re on, Git moves the pointer forward. To phrase that another way, when you try to merge one commit with a commit that can be reached by following the first commit’s history, Git simplifies things by moving the pointer forward because there is no divergent work to merge together — this is called a "fast forward".

Your change is now in the snapshot of the commit pointed to by the `master` branch, and you can deploy your change (see Figure 3-14).

Insert 18333fig0314.png 
Figure 3-14. Your master branch points to the same place as your hotfix branch after the merge.

After that your super-important fix is deployed, you’re ready to switch back to the work you were doing before you were interrupted. However, first you’ll delete the `hotfix` branch, because you no longer need it — the `master` branch points at the same place. You can delete it with the `-d` option to `git branch`:

	$ git branch -d hotfix
	Deleted branch hotfix (3a0874c).

Now you can switch back to your work-in-progress branch on issue #53 and continue working on it (see Figure 3-15):

	$ git checkout iss53
	Switched to branch "iss53"
	$ vim index.html
	$ git commit -a -m 'finished the new footer [issue 53]'
	[iss53]: created ad82d7a: "finished the new footer [issue 53]"
	 1 files changed, 1 insertions(+), 0 deletions(-)

Insert 18333fig0315.png 
Figure 3-15. Your iss53 branch can move forward independently.

It’s worth noting here that the work you did in your `hotfix` branch is not contained in the files in your `iss53` branch. If you need to pull it in, you can merge your `master` branch into your `iss53` branch by running `git merge master`, or you can wait to integrate those changes until you decide to pull the `iss53` branch back into `master` later.

### Basic Merging ###

Suppose you’ve decided that your issue #53 work is complete and ready to be merged into your `master` branch. In order to do that, you’ll merge in your `iss53` branch, much like you merged in your `hotfix` branch earlier. All you have to do is check out the branch you wish to merge into and then run the `git merge` command:

	$ git checkout master
	$ git merge iss53
	Merge made by recursive.
	 README |    1 +
	 1 files changed, 1 insertions(+), 0 deletions(-)

This looks a bit different than the `hotfix` merge you did earlier. In this case, your development history has diverged from some older point. Because the commit on the branch you’re on isn’t a direct ancestor of the branch you’re merging in, Git has to do some work. In this case, Git does a simple three-way merge, using the two snapshots pointed to by the branch tips and the common ancestor of the two. Figure 3-16 highlights the three snapshots that Git uses to do its merge in this case.

Insert 18333fig0316.png 
Figure 3-16. Git automatically identifies the best common-ancestor merge base for branch merging.

Instead of just moving the branch pointer forward, Git creates a new snapshot that results from this three-way merge and automatically creates a new commit that points to it (see Figure 3-17). This is referred to as a merge commit and is special in that it has more than one parent.

It’s worth pointing out that Git determines the best common ancestor to use for its merge base; this is different than CVS or Subversion (before version 1.5), where the developer doing the merge has to figure out the best merge base for themselves. This makes merging a heck of a lot easier in Git than in these other systems.

Insert 18333fig0317.png 
Figure 3-17. Git automatically creates a new commit object that contains the merged work.

Now that your work is merged in, you have no further need for the `iss53` branch. You can delete it and then manually close the ticket in your ticket-tracking system:

	$ git branch -d iss53

### Basic Merge Conflicts ###

Occasionally, this process doesn’t go smoothly. If you changed the same part of the same file differently in the two branches you’re merging together, Git won’t be able to merge them cleanly. If your fix for issue #53 modified the same part of a file as the `hotfix`, you’ll get a merge conflict that looks something like this:

	$ git merge iss53
	Auto-merging index.html
	CONFLICT (content): Merge conflict in index.html
	Automatic merge failed; fix conflicts and then commit the result.

Git hasn’t automatically created a new merge commit. It has paused the process while you resolve the conflict. If you want to see which files are unmerged at any point after a merge conflict, you can run `git status`:

	[master*]$ git status
	index.html: needs merge
	# On branch master
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#	unmerged:   index.html
	#

Anything that has merge conflicts and hasn’t been resolved is listed as unmerged. Git adds standard conflict-resolution markers to the files that have conflicts, so you can open them manually and resolve those conflicts. Your file contains a section that looks something like this:

	<<<<<<< HEAD:index.html
	<div id="footer">contact : email.support@github.com</div>
	=======
	<div id="footer">
	  please contact us at support@github.com
	</div>
	>>>>>>> iss53:index.html

This means the version in HEAD (your master branch, because that was what you had checked out when you ran your merge command) is the top part of that block (everything above the `=======`), while the version in your `iss53` branch looks like everything in the bottom part. In order to resolve the conflict, you have to either choose one side or the other or merge the contents yourself. For instance, you might resolve this conflict by replacing the entire block with this:

	<div id="footer">
	please contact us at email.support@github.com
	</div>

This resolution has a little of each section, and I’ve fully removed the `<<<<<<<`, `=======`, and `>>>>>>>` lines. After you’ve resolved each of these sections in each conflicted file, run `git add` on each file to mark it as resolved. Staging the file marks it as resolved in Git.
If you want to use a graphical tool to resolve these issues, you can run `git mergetool`, which fires up an appropriate visual merge tool and walks you through the conflicts:

	$ git mergetool
	merge tool candidates: kdiff3 tkdiff xxdiff meld gvimdiff opendiff emerge vimdiff
	Merging the files: index.html

	Normal merge conflict for 'index.html':
	  {local}: modified
	  {remote}: modified
	Hit return to start merge resolution tool (opendiff):

If you want to use a merge tool other than the default (Git chose `opendiff` for me in this case because I ran the command on a Mac), you can see all the supported tools listed at the top after “merge tool candidates”. Type the name of the tool you’d rather use. In Chapter 7, we’ll discuss how you can change this default value for your environment.

After you exit the merge tool, Git asks you if the merge was successful. If you tell the script that it was, it stages the file to mark it as resolved for you.

You can run `git status` again to verify that all conflicts have been resolved:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	modified:   index.html
	#

If you’re happy with that, and you verify that everything that had conflicts has been staged, you can type `git commit` to finalize the merge commit. The commit message by default looks something like this:

	Merge branch 'iss53'

	Conflicts:
	  index.html
	#
	# It looks like you may be committing a MERGE.
	# If this is not correct, please remove the file
	# .git/MERGE_HEAD
	# and try again.
	#

You can modify that message with details about how you resolved the merge if you think it would be helpful to others looking at this merge in the future — why you did what you did, if it’s not obvious.

## Gerenciamento de ramos ##

Agora que você criou, mesclou (merge) e apagou alguns ramos, vamos ver algumas ferramentas de gerenciamento de ramos que serão úteis quando você começar a usar ramos o tempo todo.

O comando `git branch` faz mais do que criar e apagar ramos. Se você executá-lo sem argumentos, você verá uma lista simples dos seus ramos atuais:

	$ git branch
	  iss53
	* master
	  testing

Note o caractere `*` que vem antes do ramo principal (`master`): ele indica o ramo que você está atualmente (fez o checkout). Isso significa que se você fizer uma submissão (commit) nesse momento, o ramo principal (`master`) irá mover adiante com seu novo trabalho. Para ver a última submissão em cada ramo, você pode executar o comando `git branch –v`:

	$ git branch -v
	  iss53   93b412c fix javascript issue
	* master  7a98805 Merge branch 'iss53'
	  testing 782fd34 add scott to the author list in the readmes

Outra opção útil para saber em que estado estão seus ramos é filtrar na lista somente ramos que você já mesclou ou não no ramo que você está atualmente. As opções `--merged` e `--no-merged` estão disponíveis no Git desde a versão 1.5.6 para esse propósito. Para ver quais ramos já foram mesclados no ramo que você está, você pode executar `git branch –merged`:

	$ git branch --merged
	  iss53
	* master

Por você já ter mesclado o ramo `iss53` antes, você o verá na sua lista. Os ramos nesta lista sem o `*` na frente em geral podem ser apagados com `git branch -d`; você já incorporou o trabalho que existia neles em outro ramo, sendo assim você não perderá nada.

Para ver todos os ramos que contém trabalho que você ainda não mesclou, você pode executar `git branch --no-merged`:

	$ git branch --no-merged
	  testing

Isso mostra seu outro ramo. Por ele conter trabalho que ainda não foi mesclado, tentar apagá-lo com `git branch -d` irá falhar:

	$ git branch -d testing
	error: The branch 'testing' is not an ancestor of your current HEAD.
	If you are sure you want to delete it, run `git branch -D testing`.

Se você quer realmente apagar o ramo e perder o trabalho que existe nele, você pode forçar com `-D`, como é apontado na mensagem útil.

## Fluxos de trabalho com Ramos ##

Agora que você sabe o básico sobre criação e mesclagem (merge) de ramos, o que você pode ou deve fazer com eles? Nessa seção, nós vamos abordar alguns fluxos de trabalhos comuns que esse tipo de criação leve de ramos torna possível, então você pode decidir se você quer incorporá-lo no seu próprio ciclo de desenvolvimento.

### Ramos de longa duração ###

Por o Git usar uma mesclagem de três vias, mesclar um ramo em outro várias vezes em um período longo é geralmente fácil de fazer. Isto significa que você pode ter vários ramos que ficam sempre abertos e que são usados em diferentes estágios do seu ciclo de desenvolvimento; você pode regularmente mesclar alguns deles em outros.

Muitos desenvolvedores Git tem um fluxo de trabalho que adotam essa abordagem, como ter somente código completamente estável em seus ramos principais
(`master`) — possivelmente somente código que já foi ou será liberado. Eles tem outro ramo paralelo chamado develop ou algo parecido em que eles trabalham ou usam para testar estabilidade — ele não é necessariamente sempre estável, mas quando ele chega a tal estágio, pode ser mesclado com o ramo principal (`master`). Ele é usado para puxar (pull) ramos tópicos (topic, ramos de curta duração, como o seu ramo `iss53` anteriormente) quando eles estão prontos, para ter certeza que eles passam em todos os testes e não acresentam erros.

Na realidade, nós estamos falando de ponteiros se movendo adiante na linha de submissões (commits) que você está fazendo. Os ramos estáveis estão muito atrás na linha histórica de submissões, e os ramos de ponta (que estão sendo trabalhados) estão a frente no histórico (veja Figura 3-18).

Insert 18333fig0318.png 
Figura 3-18. Ramos mais estáveis geralmente ficam atrás no histórico de submissões.

Normalmente é mais fácil pensar neles como um contêiner de trabalho, onde conjuntos de submissões são promovidos a um contêiner mais estável quando eles são completamente testados (veja figura 3-19).

Insert 18333fig0319.png 
Figura 3-19. Pode ser mais útil pensar em seus ramos como contêineres.

Você pode continuar fazendo isso em vários níveis de estabilidade. Alguns projetos grandes podem ter um ramo 'sugerido' (`proposed`) ou 'sugestões atualizadas' (`pu`, proposed updates) que contém outros ramos integrados que podem não estar prontos para ir para o próximo (`next`) ou ramo principal (`master`). A ideia é que seus ramos estejam em vários níveis de estabilidade; quando eles atigem um nível mais estável, eles são mesclados no ramo acima deles.
Repetindo, ter muitos ramos de longa duração não é necessário, mas geralmente é útil, especialmente quando você está lidando com projetos muito grandes ou complexos.

### Ramos tópicos (topic) ###

Ramos tópicos, entretanto, são úteis em projetos de qualquer tamanho. Um ramo tópico é um ramo de curta duração que você cria e usa para uma funcionalidade ou trabalho relacionado. Isso é algo que você provavelmente nunca fez com um controle de versão antes porque é geralmente muito custoso criar e mesclar ramos. Mas no Git é comum criar, trabalhar, mesclar e apagar ramos muitas vezes ao dia.

Você viu isso na seção anterior com os ramos `iss53` e o `hotfix` que você criou. Você fez submissões (commits) neles e os apagou depois que os mesclou (merge) com seu ramo principal (master). Tecnicamente isso lhe permite mudar completamente e rapidamente o contexto — por seu trabalho estar separado em contêineres onde todas as modificações naquele ramo estarem relacionadas ao tópico, é fácil ver o que aconteceu durante a revisão de código. Você pode manter as mudanças la por minutos, dias, ou meses, e mesclá-las quando estivem prontas, não importando a ordem que foram criadas ou trabalhadas.

Condisere um exemplo onde você está fazendo um trabalho no ramo principal (`master`), cria um ramo para um erro (`iss91`), trabalha nele um pouco, cria um segundo ramo para testar uma nova maneira de resolver o mesmo problema (`iss91v2`), volta ao seu ramo principal e trabalha nele por um tempo, e cria um novo ramo para trabalhar em algo que você não certeza se é uma boa ideia (`dumbidea`). Seu histórico de submissões (commits) irá se parecer com a Figura 3-20.

Insert 18333fig0320.png 
Figura 3-20. Seu histórico de submissões com multiplos ramos tópicos.

Agora, vamos dizer que você decidiu que sua segunda solução é a melhor para resolver o erro (`iss91v2`); e você mostrou seu ramo `dumbidea` para seus colegas de trabalho, e ele é genial. Agora você pode jogar fora o ramo original `iss91` (perdendo as submissões C5 e C6) e mesclar os dois restantes. Seu histórico irá se parecer com a Figura 3-21.

Insert 18333fig0321.png 
Figura 3-21. Seu histórico depois de mesclar dumbidea e iss91v2.

É importante lembrar que você esta fazendo tudo isso com seus ramos localmente. Quando você cria e mescla ramos, tudo está sendo feito somente no seu repositório Git - nenhuma comunicação com o servidor esta sendo feita.

## Ramos Remotos ##

Ramos remotos são referências ao estado de seus ramos no seu repositório remoto. São ramos locais que você não pode mover, eles se movem automaticamente sempre que você faz alguma comunicação via rede. Ramos remotos agem como marcadores para lembrá-lo onde estavam seus ramos no seu repositório remoto na última vez que você se conectou a eles.

Eles seguem o padrão `(remoto)/(ramo)`. Por exemplo, se você quer ver como o ramo principal (`master`) no seu repositório remoto (`origin`) estava na última vez que você se comunicou com ele, você deveria ver o ramo `origin/master`. Se você estivesse trabalhando em um problema com um colega e eles colocassem o ramo `iss53` no repositório, você poderia ter seu próprio ramo `iss53`; mas o ramo no servidor iria fazer referência ao commit em `origin/iss53`.

Isso pode parecer um pouco confuso, então vamos ver um exemplo. Digamos que você tem um servidor Git na sua rede em `git.ourcompany.com`. Se você cloná-lo, Git automaticamente dá o nome `origin` para ele, baixa todo o seu conteúdo, cria uma referência para onde o ramo principal dele está (`master`), e dá o nome `origin/master` para ele localmente; e você não pode movê-lo. O Git também dá seu próprio ramo principal (`master`) com ponto de partida no mesmo local onde o ramo principal remoto está, a partir de onde você pode trabalhar (veja Figura 3-22).

Insert 18333fig0322.png 
Figura 3-22. Um comando clone do Git dá a você seu próprio ramo principal (master) e origin/master faz referência ao ramo principal original.

Se você estiver trabalhando no seu ramo local, e, ao mesmo tempo, alguem envia algo para `git.ourcompany.com` atualizando o ramo principal, seu histórico se moverá adiante de forma diferente. Além disso, enquanto você não fizer contado com seu servidor original, seu `origin/master` não se moverá (veja Figura 3-23).

Insert 18333fig0323.png 
Figura 3-23. Ao trabalhar local e alguém enviar coisas para seu servidor remoto faz cada histórico se mover adiante de forma diferente.

Para sincronizar suas coisas, você executa o comando `git fetch origin`. Esse comando verifica qual servidor origin representa (nesse caso, é `git.ourcompany.com`), obtém todos os dados que você ainda não tem, e atualiza o seu banco de dados local, movendo o seu `origin/master` para a posição mais recente e atualizada (veja Figura 3-24).

Insert 18333fig0324.png 
Figura 3-24. O comando git fetch atualiza suas referências remotas.

Para demostrar o uso de multiplos servidores remotos e como os ramos remotos desses projetos remotos parecem, vamos assumir que você tem outro servidor Git interno que é usado somente para desenvolvimento por um de seus times. Este servidor está em `git.team1.ourcompany.com`. Você pode adicioná-lo como uma nova referência remota ao projeto que você está atualmente trabalhando executando o comando `git remote add` como discutimos no capítulo 2. Dê o nome de `teamone`, que será o apelido para aquela URL (veja Figura 3-25).

Insert 18333fig0325.png 
Figura 3-25. Adicionando outro servidor remoto.

Agora, você pode executar o comando `git fetch teamone` para obter tudo que o servidor tem e você ainda não. Por esse servidor ter um subcojunto dos dados que seu servidor `origin` tem, Git não obtém nenhum dados, somente cria um ramo chamado `teamone/master` que faz referência ao commit que `teamone` tem no `master` dele (veja Figura 3-26).

Insert 18333fig0326.png 
Figura 3-26. Você consegue uma referência local para a posição do ramo principal do teamone.

### Enviando (Pushing) ###

Quando você quer compatilhar um branch com o mundo, você precisa enviá-lo a um servidor remoto que você tem acesso. Seus branches locais não são automaticamente sincronizados com os remotos - você tem que explicitamente enviar (push) os branches que quer compartilhar. Desta maneira, você pode usar branches privados para o trabalho que não quer compartilhar, e enviar somente os branches tópicos que quer colaboração.

Se você tem um branch chamado `serverfix` e quer trabalhar com outros, você pode enviá-lo da mesma forma que enviou seu primeiro branch. Execute o comando `git push (remote) (branch)`:

	$ git push origin serverfix
	Counting objects: 20, done.
	Compressing objects: 100% (14/14), done.
	Writing objects: 100% (15/15), 1.74 KiB, done.
	Total 15 (delta 5), reused 0 (delta 0)
	To git@github.com:schacon/simplegit.git
	 * [new branch]      serverfix -> serverfix

Isso é um atalho. O Git automaticamente expande o branch `serverfix` para `refs/heads/serverfix:refs/heads/serverfix`, que quer dizer, "pegue meu branch local serverfix e envie para atualizar o branch serverfix no servidor remoto". Nós vamos ver a parte de `refs/heads/` em detalhes no capítulo 9, mas em geral você pode deixar assim. Você pode executar também `git push origin serverfix:serverfix`, que faz a mesma coisa - é como, "pegue meu serverfix e o transforme no serverfix remoto". Você pode usar esse formato para enviar (push) um branch local para branch remoto que tem nome diferente. Se você não quer chamá-lo de serverfix no remoto, você pode executar `git push origin serverfix:awesomebranch` para enviar seu branch local `serverfix` para o branch `awesomebranch` no projeto remoto.

Na próxima vez que um dos seus colaboradores obter dados do servidor, eles irão ter uma referência para onde a versão do servidor de serverfix está no branch remoto `origin/serverfix`:

	$ git fetch origin
	remote: Counting objects: 20, done.
	remote: Compressing objects: 100% (14/14), done.
	remote: Total 15 (delta 5), reused 0 (delta 0)
	Unpacking objects: 100% (15/15), done.
	From git@github.com:schacon/simplegit
	 * [new branch]      serverfix    -> origin/serverfix

É importante notar que quando você obtém dados que traz novos branches remotos, você não tem automaticamente copias locais e editáveis. Em outras palavras, nesse caso, você não tem um novo branch `serverfix` — você tem somente uma referência a `origin/serverfix` que você não pode modificar.

Para mesclar (merge) esses dados no branch que você está trabalhando, você pode executar o comando `git merge origin/serverfix`. Se você quer seu próprio branch `serverfix` para trabalhar, você pode se basear no seu branch remoto:

	$ git checkout -b serverfix origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

Isso da a você um branch local para trabalhar que começa onde `origin/serverfix` está.

### Branches seguidores (Tracking branches) ###

Baixar um branch local a partir de um branch remoto cria automaticamente o chamado _tracking branch_ (branches seguidores). Tracking branches são branches locais que tem uma relação direta com um branch remoto. Se você está em um tracking branch e digita git push, Git automaticamente sabe que servidor e branch para fazer o envio (push). Além disso, ao executar o comando `git pull` em um desses branches, é obtido todos os dados remotos e automaticamente feito o merge do branch remoto correspondente.

Quando você faz o clone de um repositório, é automaticamente criado um branch `master` que segue `origin/master`. Esse é o motivo pelo qual `git push` e `git pull` funcionam sem argumentos. Entretanto, você pode criar outros tracking brancher se quiser - outros que não seguem branches em `origin` e não seguem o branch `master`. Um caso simples é o exemplo que você acabou de ver, executando o comando `git checkout -b [branch] [nomeremoto]/[branch]`. Se você tem a versão do Git 1.6.2 ou mais recente, você pode usar também o atalho `--track`:

	$ git checkout --track origin/serverfix
	Branch serverfix set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "serverfix"

Para criar um branch local com um nome diferente do branch remoto, você pode facilmente usar a primeira versão com um nome diferente para o branch local:

	$ git checkout -b sf origin/serverfix
	Branch sf set up to track remote branch refs/remotes/origin/serverfix.
	Switched to a new branch "sf"

Agora, seu branch local sf irá automaticamente enviar e obter dados de origin/serverfix.

### Deleting Remote Branches ###

Suppose you’re done with a remote branch — say, you and your collaborators are finished with a feature and have merged it into your remote’s `master` branch (or whatever branch your stable codeline is in). You can delete a remote branch using the rather obtuse syntax `git push [remotename] :[branch]`. If you want to delete your `serverfix` branch from the server, you run the following:

	$ git push origin :serverfix
	To git@github.com:schacon/simplegit.git
	 - [deleted]         serverfix

Boom. No more branch on your server. You may want to dog-ear this page, because you’ll need that command, and you’ll likely forget the syntax. A way to remember this command is by recalling the `git push [remotename] [localbranch]:[remotebranch]` syntax that we went over a bit earlier. If you leave off the `[localbranch]` portion, then you’re basically saying, “Take nothing on my side and make it be `[remotebranch]`.”

## Rebasing ##

In Git, there are two main ways to integrate changes from one branch into another: the `merge` and the `rebase`. In this section you’ll learn what rebasing is, how to do it, why it’s a pretty amazing tool, and in what cases you won’t want to use it.

### The Basic Rebase ###

If you go back to an earlier example from the Merge section (see Figure 3-27), you can see that you diverged your work and made commits on two different branches.

Insert 18333fig0327.png 
Figure 3-27. Your initial diverged commit history

The easiest way to integrate the branches, as we’ve already covered, is the `merge` command. It performs a three-way merge between the two latest branch snapshots (C3 and C4) and the most recent common ancestor of the two (C2), creating a new snapshot (and commit), as shown in Figure 3-28.

Insert 18333fig0328.png 
Figure 3-28. Merging a branch to integrate the diverged work history

However, there is another way: you can take the patch of the change that was introduced in C3 and reapply it on top of C4. In Git, this is called _rebasing_. With the `rebase` command, you can take all the changes that were committed on one branch and replay them on another one.

In this example, you’d run the following:

	$ git checkout experiment
	$ git rebase master
	First, rewinding head to replay your work on top of it...
	Applying: added staged command

It works by going to the common ancestor of the two branches (the one you’re on and the one you’re rebasing onto), getting the diff introduced by each commit of the branch you’re on, saving those diffs to temporary files, resetting the current branch to the same commit as the branch you are rebasing onto, and finally applying each change in turn. Figure 3-29 illustrates this process.

Insert 18333fig0329.png 
Figure 3-29. Rebasing the change introduced in C3 onto C4

At this point, you can go back to the master branch and do a fast-forward merge (see Figure 3-30).

Insert 18333fig0330.png 
Figure 3-30. Fast-forwarding the master branch

Now, the snapshot pointed to by C3 is exactly the same as the one that was pointed to by C5 in the merge example. There is no difference in the end product of the integration, but rebasing makes for a cleaner history. If you examine the log of a rebased branch, it looks like a linear history: it appears that all the work happened in series, even when it originally happened in parallel.

Often, you’ll do this to make sure your commits apply cleanly on a remote branch — perhaps in a project to which you’re trying to contribute but that you don’t maintain. In this case, you’d do your work in a branch and then rebase your work onto `origin/master` when you were ready to submit your patches to the main project. That way, the maintainer doesn’t have to do any integration work — just a fast-forward or a clean apply.

Note that the snapshot pointed to by the final commit you end up with, whether it’s the last of the rebased commits for a rebase or the final merge commit after a merge, is the same snapshot — it’s only the history that is different. Rebasing replays changes from one line of work onto another in the order they were introduced, whereas merging takes the endpoints and merges them together.

### More Interesting Rebases ###

You can also have your rebase replay on something other than the rebase branch. Take a history like Figure 3-31, for example. You branched a topic branch (`server`) to add some server-side functionality to your project, and made a commit. Then, you branched off that to make the client-side changes (`client`) and committed a few times. Finally, you went back to your server branch and did a few more commits.

Insert 18333fig0331.png 
Figure 3-31. A history with a topic branch off another topic branch

Suppose you decide that you want to merge your client-side changes into your mainline for a release, but you want to hold off on the server-side changes until it’s tested further. You can take the changes on client that aren’t on server (C8 and C9) and replay them on your master branch by using the `--onto` option of `git rebase`:

	$ git rebase --onto master server client

This basically says, “Check out the client branch, figure out the patches from the common ancestor of the `client` and `server` branches, and then replay them onto `master`.” It’s a bit complex; but the result, shown in Figure 3-32, is pretty cool.

Insert 18333fig0332.png 
Figure 3-32. Rebasing a topic branch off another topic branch

Now you can fast-forward your master branch (see Figure 3-33):

	$ git checkout master
	$ git merge client

Insert 18333fig0333.png 
Figure 3-33. Fast-forwarding your master branch to include the client branch changes

Let’s say you decide to pull in your server branch as well. You can rebase the server branch onto the master branch without having to check it out first by running `git rebase [basebranch] [topicbranch]` — which checks out the topic branch (in this case, `server`) for you and replays it onto the base branch (`master`):

	$ git rebase master server

This replays your `server` work on top of your `master` work, as shown in Figure 3-34.

Insert 18333fig0334.png 
Figure 3-34. Rebasing your server branch on top of your master branch

Then, you can fast-forward the base branch (`master`):

	$ git checkout master
	$ git merge server

You can remove the `client` and `server` branches because all the work is integrated and you don’t need them anymore, leaving your history for this entire process looking like Figure 3-35:

	$ git branch -d client
	$ git branch -d server

Insert 18333fig0335.png 
Figure 3-35. Final commit history

### The Perils of Rebasing ###

Ahh, but the bliss of rebasing isn’t without its drawbacks, which can be summed up in a single line:

**Do not rebase commits that you have pushed to a public repository.**

If you follow that guideline, you’ll be fine. If you don’t, people will hate you, and you’ll be scorned by friends and family.

When you rebase stuff, you’re abandoning existing commits and creating new ones that are similar but different. If you push commits somewhere and others pull them down and base work on them, and then you rewrite those commits with `git rebase` and push them up again, your collaborators will have to re-merge their work and things will get messy when you try to pull their work back into yours.

Let’s look at an example of how rebasing work that you’ve made public can cause problems. Suppose you clone from a central server and then do some work off that. Your commit history looks like Figure 3-36.

Insert 18333fig0336.png 
Figure 3-36. Clone a repository, and base some work on it.

Now, someone else does more work that includes a merge, and pushes that work to the central server. You fetch them and merge the new remote branch into your work, making your history look something like Figure 3-37.

Insert 18333fig0337.png 
Figure 3-37. Fetch more commits, and merge them into your work.

Next, the person who pushed the merged work decides to go back and rebase their work instead; they do a `git push --force` to overwrite the history on the server. You then fetch from that server, bringing down the new commits.

Insert 18333fig0338.png 
Figure 3-38. Someone pushes rebased commits, abandoning commits you’ve based your work on.

At this point, you have to merge this work in again, even though you’ve already done so. Rebasing changes the SHA-1 hashes of these commits so to Git they look like new commits, when in fact you already have the C4 work in your history (see Figure 3-39).

Insert 18333fig0339.png 
Figure 3-39. You merge in the same work again into a new merge commit.

You have to merge that work in at some point so you can keep up with the other developer in the future. After you do that, your commit history will contain both the C4 and C4' commits, which have different SHA-1 hashes but introduce the same work and have the same commit message. If you run a `git log` when your history looks like this, you’ll see two commits that have the same author date and message, which will be confusing. Furthermore, if you push this history back up to the server, you’ll reintroduce all those rebased commits to the central server, which can further confuse people.

If you treat rebasing as a way to clean up and work with commits before you push them, and if you only rebase commits that have never been available publicly, then you’ll be fine. If you rebase commits that have already been pushed publicly, and people may have based work on those commits, then you may be in for some frustrating trouble.

## Summary ##

We’ve covered basic branching and merging in Git. You should feel comfortable creating and switching to new branches, switching between branches and merging local branches together.  You should also be able to share your branches by pushing them to a shared server, working with others on shared branches and rebasing your branches before they are shared.
