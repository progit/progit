# Customizando o Git #

Até agora, eu mostrei o básico de como o Git funciona, como usá-lo e apresentei algumas ferramentas que o Git provê para ajudar a usá-lo de forma fácil e eficiente. Neste capítulo, eu mostrarei algumas operações que você pode usar para fazer operações com o Git de uma maneira mais customizada, introduzindo várias configurações importantes e um sistemas de hooks. Com essas ferramentas, será fácil trabalhar com o Git da melhor forma para você, sua empresa ou qualquer grupo.

## Configuração do Git ##

Como você viu brevemente no Capítulo 1, você pode configurar o Git com o comando `git config`. Uma das primeiras coisas que você fez foi configurar seu nome e endereço de email:

    $ git config --global user.name "John Doe"
    $ git config --global user.email johndoe@example.com

Agora você vai aprender algumas opções mais interessantes que você pode definir dessa maneira para customizar o uso do Git.

Você viu alguns detalhes simples de configuração do Git no primeiro capítulo, mas vou passar por eles de novo rapidamente. Git usa uma série de arquivos de configuração para determinar comportamentos não-padrão que você pode querer utilizar. O primeiro lugar que o Git procura por estes valores é no arquivo `/etc/gitconfig`, que contém os valores para todos os usuários do sistema e todos os seus repositórios. Se você passar a opção `--system` para `git config`, ele lê e escreve a partir deste arquivo especificamente.

O próximo lugar que o Git olha é no arquivo `~/.gitconfig`, que é específico para cada usuário. Você pode fazer o Git ler e escrever neste arquivo, passando a opção `--global`.

Finalmente, Git procura por valores de configuração no arquivo de configuração no diretório Git (`.git/config`) de qualquer repositório que você esteja usando atualmente. Estes valores são específicos para esse repositório. Cada nível substitui valores no nível anterior, então, valores em `.git/config` sobrepõem valores em `/etc/gitconfig`. Você também pode definir esses valores manualmente, editando o arquivo e inserindo a sintaxe correta mas, é geralmente mais fácil executar o comando `git config`.

### Configuração Básica do Cliente ###

As opções de configuração reconhecidas pelo Git se dividem em duas categorias: lado cliente e lado servidor. A maioria das opções são do lado cliente e utilizadas para configurar suas preferências pessoais de trabalho. Apesar de haverem muitas opções disponíveis, só cobrirei as que são comumente usadas ​​ou podem afetar significativamente o fluxo de trabalho. Muitas opções são úteis apenas em casos extremos que não mostraremos aqui. Se você quiser ver uma lista de todas as opções que a sua versão do Git reconhece, você pode executar

    $ git config --help

A página do manual do `git config` lista todas as opções disponíveis com um pouco de detalhe.

#### core.editor ####

Por padrão, o Git usa o editor de texto que você definiu como padrão no Shell ou então reverte para o editor Vi para criar e editar suas mensagens de commit e tags. Para alterar esse padrão, você pode usar a opção `core.editor`:

    $ git config --global core.editor emacs

Agora, não importa o que esteja definido como seu editor padrão, o Git usará o editor Emacs.

#### commit.template ####

Se você ajustar esta opção como um caminho de um arquivo em seu sistema, o Git vai usar esse arquivo como o padrão de mensagem quando você fizer um commit. Por exemplo, suponha que você crie um arquivo de modelo em `$HOME/.gitmessage.txt` que se parece com este:

    subject line

    what happened

    [ticket: X]

Para dizer ao Git para usá-lo como a mensagem padrão que aparece em seu editor quando você executar o `git commit`, defina o valor de configuração `commit.template`:

    $ git config --global commit.template $HOME/.gitmessage.txt
    $ git commit

Então, o editor irá abrir com algo parecido com isto quando você fizer um commit:

    subject line

    what happened

    [ticket: X]
    # Please enter the commit message for your changes. Lines starting
    # with '#' will be ignored, and an empty message aborts the commit.
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    # modified:   lib/test.rb
    #
    ~
    ~
    ".git/COMMIT_EDITMSG" 14L, 297C

Se você tiver uma política de mensagens de commit, colocando um modelo para essa política em seu sistema e configurando o Git para usá-lo por padrão pode ajudar a aumentar a chance de que a política seja seguida regularmente.

#### core.pager ####

A configuração core.pager determina qual pager é usado quando a saída do Git possui várias páginas, como quando são usados os comandos `log` e `diff`. Você pode configurá-lo para `more` ou para o seu pager favorito (por padrão, é `less`), ou você pode desativá-lo, definindo uma string em branco:

    $ git config --global core.pager ''

Se você executar isso, Git irá paginar toda a saída de todos os comandos, não importando quão longo eles sejam.

#### user.signingkey ####

Se você estiver fazendo annotated tags assinadas (como discutido no Capítulo 2), definir a sua chave de assinatura GPG como uma configuração torna as coisas mais fáceis. Defina o ID da chave assim:

    $ git config --global user.signingkey <gpg-key-id>

Agora, você pode assinar tags sem ter de especificar a sua chave toda hora com o comando `git tag`:

    $ git tag -s <tag-name>

#### core.excludesfile ####

Você pode colocar padrões em seu arquivo de projeto `.gitignore` para que o Git veja-os como arquivos untracked ou tentar coloca-los como stagged quando executar o `git add` sobre eles, como discutido no Capítulo 2. No entanto, se você quiser que outro arquivo fora do seu projeto mantenha esses valores ou tenham valores extras, você pode dizer ao Git onde o arquivo com a opção `core.excludesfile` está. Basta configurá-lo para o caminho de um arquivo que tem conteúdo semelhante ao que um arquivo `.gitignore` teria.

#### help.autocorrect ####

Esta opção está disponível apenas no Git 1.6.1 e posteriores. Se você digitar um comando no Git 1.6, ele mostrará algo como isto:

    $ git com
    git: 'com' is not a git-command. See 'git --help'.

    Did you mean this?
         commit

Se você definir `help.autocorrect` para 1, Git automaticamente executará o comando se houver apenas uma possibilidade neste cenário.

### Cores no Git ###

Git pode colorir a sua saída para o terminal, o que pode ajudá-lo visualmente a analisar a saída mais rápido e facilmente. Um número de opções pode ajudar a definir a colorização de sua preferência.

#### color.ui ####

Git automaticamente coloriza a maioria de sua saída, se você pedir para ele. Você pode ser muito específico sobre o que você quer e como colorir; mas para ativar a coloração padrão do terminal, defina `color.ui` para true:

    $ git config --global color.ui true

Quando esse valor é definido, Git coloriza a saída do terminal. Outras configurações possíveis são false, que nunca coloriza a saída, e always, que coloriza sempre, mesmo que você esteja redirecionando comandos do Git para um arquivo ou através de um pipe para outro comando. Esta configuração foi adicionado na versão 1.5.5 do Git, se você tem uma versão mais antiga, você terá que especificar todas as configurações de cores individualmente.

Você dificilmente vai querer usar `color.ui = always`. Na maioria dos cenários, se você quiser códigos coloridos em sua saída redirecionada, você pode passar a opção `--color` para forçar o comando Git a usar códigos de cores. O `color.ui = true` é o que provavelmente você vai querer usar.

#### `color.*` ####

Se você quiser ser mais específico sobre quais e como os comandos são colorizados, ou se você tem uma versão mais antiga do Git, o Git oferece configurações específicas para colorir. Cada uma destas pode ser ajustada para `true`, `false`, ou `always`:

    color.branch
    color.diff
    color.interactive
    color.status

Além disso, cada uma delas tem sub-opções que você pode usar para definir cores específicas para partes da saída, se você quiser substituir cada cor. Por exemplo, para definir a informação meta na sua saída do diff para texto azul, fundo preto e texto em negrito, você pode executar

    $ git config --global color.diff.meta “blue black bold”

Você pode definir a cor para qualquer um dos seguintes valores: normal, black, red, green, yellow, blue, magenta, cyan, ou white. Se você quiser um atributo como negrito no exemplo anterior, você pode escolher entre bold, dim, ul, blink, e reverse.

Veja a página de manual (manpage) do `git config` para saber todas as sub-opções que você pode configurar.

### Ferramenta Externa de Merge e Diff ###

Embora o Git tenha uma implementação interna do diff, que é o que você estava usando, você pode configurar uma ferramenta externa. Você pode configurar uma ferramenta gráfica de merge para resolução de conflitos, em vez de ter de resolver conflitos manualmente. Vou demonstrar a configuração do Perforce Visual Merge Tool (P4Merge) para fazer suas diffs e fazer merge de resoluções, porque é uma boa ferramenta gráfica e é gratuita.

Se você quiser experimentar, P4Merge funciona em todas as principais plataformas, então você deve ser capaz de usá-lo. Vou usar nomes de caminho nos exemplos que funcionam em sistemas Mac e Linux; para Windows, você vai ter que mudar `/usr/local/bin` para um caminho executável em seu ambiente.

Você pode baixar P4Merge aqui:

    http://www.perforce.com/product/components/perforce-visual-merge-and-diff-tools

Para começar, você vai configurar um script para executar seus comandos. Vou usar o caminho para o executável Mac; em outros sistemas, este será onde o seu binário do `p4merge` está instalado. Configure um script chamado `extMerge` que chama seu binário com todos os argumentos necessários:

    $ cat /usr/local/bin/extMerge
    #!/bin/sh/Applications/p4merge.app/Contents/MacOS/p4merge $*

Um wrapper diff verifica se sete argumentos são fornecidos e passa dois deles para o seu script de merge. Por padrão, o Git passa os seguintes argumentos para o programa diff:

    path old-file old-hex old-mode new-file new-hex new-mode

Já que você só quer os argumentos `old-file` e `new-file`, você pode usar o script para passar o que você precisa.

    $ cat /usr/local/bin/extDiff
    #!/bin/sh
    [ $# -eq 7 ] && /usr/local/bin/extMerge "$2" "$5"

Você também precisa ter certeza de que essas ferramentas são executáveis:

    $ sudo chmod +x /usr/local/bin/extMerge
    $ sudo chmod +x /usr/local/bin/extDiff

Agora você pode configurar o arquivo de configuração para usar a sua ferramenta de diff customizada. Existem algumas configurações personalizadas: `merge.tool` para dizer ao Git qual a estratégia a utilizar, `mergetool.*.cmd` para especificar como executar o comando, `mergetool.trustExitCode` para dizer ao Git se o código de saída do programa indica uma resolução de merge com sucesso ou não, e `diff.external` para dizer ao Git o comando a ser executado para diffs. Assim, você pode executar quatro comandos de configuração

    $ git config --global merge.tool extMerge
    $ git config --global mergetool.extMerge.cmd \
        'extMerge "$BASE" "$LOCAL" "$REMOTE" "$MERGED"'
    $ git config --global mergetool.trustExitCode false
    $ git config --global diff.external extDiff

ou você pode editar o seu arquivo `~/.gitconfig` para adicionar estas linhas.:

    [merge]
      tool = extMerge
    [mergetool "extMerge"]
      cmd = extMerge \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\"
      trustExitCode = false
    [diff]
      external = extDiff

Depois que tudo isso seja definido, se você executar comandos diff como este:

    $ git diff 32d1776b1^ 32d1776b1

Em vez de ter a saída do diff na linha de comando, Git inicia o P4Merge, como mostra a Figura 7-1.

Insert 18333fig0701.png
Figura 7-1. P4Merge

Se você tentar mesclar dois branches e, posteriormente, ter conflitos de mesclagem, você pode executar o comando `git mergetool`, que iniciará o P4Merge para deixá-lo resolver os conflitos através dessa ferramenta gráfica.

A coisa boa sobre esta configuração é que você pode mudar o seu diff e ferramentas de merge facilmente. Por exemplo, para mudar suas ferramentas `extdiff` e `extMerge` para executar a ferramenta KDiff3 no lugar delas, tudo que você tem a fazer é editar seu arquivo `extMerge`:

    $ cat /usr/local/bin/extMerge
    #!/bin/sh/Applications/kdiff3.app/Contents/MacOS/kdiff3 $*

Agora, o Git irá utilizar a ferramenta KDiff3 para visualizar diffs e resolução de conflitos de merge.

O Git vem pré-configurado para usar uma série de outras ferramentas de resolução de merge sem ter que definir a configuração cmd. Você pode definir a sua ferramenta de mesclagem para kdiff3, opendiff, tkdiff, meld, xxdiff, emerge, vimdiff, ou gvimdiff. Se você não estiver interessado em usar o KDiff3 para diff mas quer usá-lo apenas para a resolução de merges, e o comando kdiff3 está no seu path, então você pode executar

    $ git config --global merge.tool kdiff3

Se você executar isto ao invés de configurar os arquivos `extMerge` e `extDiff`, Git irá usar o KDiff3 para resolução de merges e a ferramenta diff padrão do Git.

### Formatação e Espaços em Branco ###

Formatação e problemas de espaço em branco são alguns dos problemas mais frustrantes e sutis que muitos desenvolvedores encontram ao colaborar, especialmente em ambientes multi-plataforma. É muito fácil que patches ou outros trabalhos de colabores introduzam mudanças sutis como espaços em branco porque os editores os inserem silenciosamente ou programadores Windows adicionam quebras de linha em projetos multi-plataforma. Git tem algumas opções de configuração para ajudar com estas questões.

#### core.autocrlf ####

Se você está programando no Windows ou outro sistema, mas trabalha com pessoas que estão programando em Windows, você provavelmente vai encontrar problemas de quebra de linha em algum momento. Isso porque o Windows usa tanto o caráter carriage-return e um carácter linefeed para novas linhas em seus arquivos, enquanto os sistemas Mac e Linux usam apenas o carácter linefeed. Este é um fato sutil, mas extremamente irritante em trabalhos multi-plataforma.

O Git pode lidar com isso auto-convertendo finais de linha CRLF para LF quando você faz um commit, e vice-versa, quando se faz um checkout de código em seu sistema de arquivos. Você pode ativar esta funcionalidade com a configuração `core.autocrlf`. Se você estiver em uma máquina Windows, defina-o `true` — este converte terminações LF em CRLF quando você faz um checkout do código:

    $ git config --global core.autocrlf true

Se você estiver em um sistema Linux ou Mac que usam os finais de linha LF, então você não irá querer que o Git automaticamente converta-os quando você fizer o check-out dos arquivos, no entanto, se um arquivo com terminações CRLF acidentalmente for introduzido, então você pode querer que o Git corrija-o. Você pode dizer ao Git para converter CRLF para LF no commit, mas não o contrário definindo `core.autocrlf` para entrada:

    $ git config --global core.autocrlf input

Esta configuração deve deixá-lo com terminações CRLF em checkouts Windows, mas terminações LF em sistemas Mac e Linux e no repositório.

Se você é um programador Windows fazendo um projeto somente para Windows, então você pode desativar essa funcionalidade, registrando os CRLF no repositório, definindo o valor de configuração para `false`:

    $ git config --global core.autocrlf false

#### core.whitespace ####

Git vem pré-configurado para detectar e corrigir alguns problemas de espaço em branco. Ele pode olhar por quatro problemas principais relacionados a espaços em branco — duas são ativadas por padrão e podem ser desativadas, e duas não são ativadas por padrão, mas podem ser ativadas.

As duas que são ativadas por padrão são `trailing-space`, que procura por espaços no final de uma linha, e `space-before-tab`, que procura por espaços antes de tabulações no início de uma linha.

As duas que estão desativadas por padrão, mas podem ser ativadas são `indent-with-non-tab`, que procura por linhas que começam com oito ou mais espaços em vez de tabulações, e `cr-at-eol`, que diz ao Git que carriage returns no final das linhas estão OK.

Você pode dizer ao Git quais destes você quer habilitado alterando a opção `core.whitespace` para os valores que deseja on ou off, separados por vírgulas. Você pode desabilitar as configurações, quer deixando-as fora da string de definição ou adicionando um `-` na frente do valor. Por exemplo, se você quiser tudo, menos `cr-at-eol`, você pode fazer isso:

    $ git config --global core.whitespace \
        trailing-space,space-before-tab,indent-with-non-tab

Git irá detectar esses problemas quando você executar um comando `git diff` e tentar colori-los de modo que você pode, eventualmente, corrigi-los antes de fazer o commit. Ele também irá usar esses valores para ajudar quando você aplicar patches com `git apply`. Quando você estiver aplicando patches, você pode pedir ao Git para avisá-lo se estiver aplicando patches com problemas de espaço em branco:

    $ git apply --whitespace=warn <patch>

Ou você pode deixar o Git tentar corrigir automaticamente o problema antes de aplicar o patch:

    $ git apply --whitespace=fix <patch>

Essas opções se aplicam ao comando git rebase também. Se você commitou problemas de espaço em branco, mas ainda não fez um push, você pode executar um `rebase` com a opção `--whitespace=fix` para que o Git automaticamente corrija problemas de espaço em branco, como faz com os patches.

### Configuração do Servidor ###

Não existem muitas opções de configuração disponíveis para o lado servidor do Git, mas há algumas interessantes que você pode querer aprender.

#### receive.fsckObjects ####

Por padrão, o Git não verifica a consistência de todos os objetos que ele recebe durante um push. Embora o Git possa certificar-se de que cada objeto ainda corresponde ao seu SHA-1 checksum e aponta para objetos válidos, ele não faz isso por padrão em cada push. Esta é uma operação relativamente custosa e pode adicionar uma grande quantidade de tempo para cada push, de acordo com o tamanho do repositório ou do push. Se você quiser que o Git verifique a consistência dos objetos em cada push, você pode forçá-lo a fazê-lo definindo `receive.fsckObjects` como true:

    $ git config --system receive.fsckObjects true

Agora, o Git irá verificar a integridade do seu repositório antes que cada push seja aceito para garantir que clientes defeituosos não estejam introduzindo dados corrompidos.

#### receive.denyNonFastForwards ####

Se você fizer o rebase de commits já enviados com push e então tentar fazer outro push, ou tentar fazer um push de um commit para um branch remoto que não contenha o commit que o branch remoto atualmente aponta, sua ação será negada. Isso geralmente é uma boa política; mas, no caso do rebase, você pode determinar que você saiba o que está fazendo e pode forçar a atualização do branch remoto com um `-f` no seu comando push.

Para desativar a capacidade de forçar updates em branches remotos para referências não fast-forward, defina `receive.denyNonFastForwards`:

    $ git config --system receive.denyNonFastForwards true

A outra forma de fazer isso é através dos hooks em lado servidor, que eu vou falar daqui a pouco. Essa abordagem permite que você faça coisas mais complexas como negar não fast-forwards para um determinado conjunto de usuários.

#### receive.denyDeletes ####

Uma das soluções para a política `denyNonFastForwards` é o usuário excluir o branch e depois fazer um push de volta com a nova referência. Nas versões mais recentes do Git (a partir da versão 1.6.1), você pode definir `receive.denyDeletes` como true:

    $ git config --system receive.denyDeletes true

Isto nega exclusão de branchs e tags em um push — nenhum usuário pode fazê-lo. Para remover branches remotas, você deve remover os arquivos ref do servidor manualmente. Existem também formas mais interessantes de fazer isso de acordo com o usuário através de ACLs, como você vai aprender no final deste capítulo.

## Atributos Git ##

Algumas dessas configurações também podem ser especificadas para um path, de modo que o Git aplique essas configurações só para um subdiretório ou conjunto de arquivos. Essas configurações de path específicas são chamadas atributos Git e são definidas em um arquivo `.gitattributes` ou em um de seus diretórios (normalmente a raiz de seu projeto) ou no arquivo `.git/info/attributes` se você não desejar que o arquivo de atributos seja commitado com o seu projeto.

Usando atributos, você pode fazer coisas como especificar estratégias de merge separadas para arquivos individuais ou pastas no seu projeto, dizer ao Git como fazer diff de arquivos não textuais, ou mandar o Git filtrar conteúdos antes de fazer o checkout para dentro ou fora do Git. Nesta seção, você vai aprender sobre alguns dos atributos que podem ser configurados em seus paths de seu projeto Git e ver alguns exemplos de como usar esse recurso na prática.

### Arquivos Binários ###

Um truque legal para o qual você pode usar atributos Git é dizendo ao Git quais arquivos são binários (em casos que de outra forma ele não pode ser capaz de descobrir) e dando ao Git instruções especiais sobre como lidar com esses arquivos. Por exemplo, alguns arquivos de texto podem ser gerados por máquina e não é possível usar diff neles, enquanto que em alguns arquivos binários pode ser usado o diff — você verá como dizer ao Git qual é qual.

#### Identificando Arquivos Binários ####

Alguns arquivos parecem com arquivos de texto, mas para todos os efeitos devem ser tratados como dados binários. Por exemplo, projetos Xcode no Mac contém um arquivo que termina em `.pbxproj`, que é basicamente um conjunto de dados de JSON (formato de dados em texto simples JavaScript), escrito no disco pela IDE que registra as configurações de buils e assim por diante. Embora seja tecnicamente um arquivo de texto, porque é tudo ASCII, você não quer tratá-lo como tal, porque ele é na verdade um banco de dados leve — você não pode fazer um merge do conteúdo, se duas pessoas o mudaram, e diffs geralmente não são úteis. O arquivo é para ser lido pelo computador. Em essência, você quer tratá-lo como um arquivo binário.

Para dizer ao Git para tratar todos os arquivos `pbxproj` como dados binários, adicione a seguinte linha ao seu arquivo `.gitattributes`:

    *.pbxproj -crlf -diff

Agora, o Git não vai tentar converter ou corrigir problemas CRLF; nem vai tentar calcular ou imprimir um diff para mudanças nesse arquivo quando você executar show ou git diff em seu projeto. Na série 1.6 do Git, você também pode usar uma macro que significa `-crlf -diff`:

    *.pbxproj binary

#### Diff de Arquivos Binários ####

Na série 1.6 do Git, você pode usar a funcionalidade de atributos do Git para fazer diff de arquivos binários. Você faz isso dizendo ao Git como converter os dados binários em um formato de texto que pode ser comparado através do diff normal.

##### Arquivos do MS Word #####

Como este é um recurso muito legal e não muito conhecido, eu vou mostrar alguns exemplos. Primeiro, você vai usar esta técnica para resolver um dos problemas mais irritantes conhecidos pela humanidade: controlar a versão de documentos Word. Todo mundo sabe que o Word é o editor mais horrível que existe, mas, estranhamente, todo mundo o usa. Se você quiser controlar a versão de documentos do Word, você pode colocá-los em um repositório Git e fazer um commit de vez em quando; mas o que de bom tem isso? Se você executar `git diff` normalmente, você só verá algo como isto:

    $ git diff
    diff --git a/chapter1.doc b/chapter1.doc
    index 88839c4..4afcb7c 100644
    Binary files a/chapter1.doc and b/chapter1.doc differ

Você não pode comparar diretamente duas versões, a menos que você verifique-as manualmente, certo? Acontece que você pode fazer isso muito bem usando atributos Git. Coloque a seguinte linha no seu arquivo `.gitattributes`:

    *.doc diff=word

Isto diz ao Git que qualquer arquivo que corresponde a esse padrão (.doc) deve usar o filtro "word" quando você tentar ver um diff que contém alterações. O que é o filtro "word"? Você tem que configurá-lo. Aqui você vai configurar o Git para usar o programa `strings` para converter documentos do Word em arquivos de texto legível, o que poderá ser visto corretamente no diff:

    $ git config diff.word.textconv strings

Este comando adiciona uma seção no seu `.git/config` que se parece com isto:
    [diff "word"]
      textconv = strings

Nota: Há diferentes tipos de arquivos `.doc`, alguns usam uma codificação UTF-16 ou outras "páginas de código" e `strings` não vão encontrar nada de útil lá. Seu resultado pode variar.

Agora o Git sabe que se tentar fazer uma comparação entre os dois snapshots, e qualquer um dos arquivos terminam em `.doc`, ele deve executar esses arquivos através do filtro "word", que é definido como o programa `strings`. Isso cria versões em texto de arquivos do Word antes de tentar o diff.

Aqui está um exemplo. Eu coloquei um capítulo deste livro em Git, acrescentei algum texto a um parágrafo, e salvei o documento. Então, eu executei `git diff` para ver o que mudou:

    $ git diff
    diff --git a/chapter1.doc b/chapter1.doc
    index c1c8a0a..b93c9e4 100644
    --- a/chapter1.doc
    +++ b/chapter1.doc
    @@ -8,7 +8,8 @@ re going to cover Version Control Systems (VCS) and Git basics
     re going to cover how to get it and set it up for the first time if you don
     t already have it on your system.
     In Chapter Two we will go over basic Git usage - how to use Git for the 80%
    -s going on, modify stuff and contribute changes. If the book spontaneously
    +s going on, modify stuff and contribute changes. If the book spontaneously
    +Let's see if this works.

Git com sucesso e de forma sucinta me diz que eu adicionei a string "Let’s see if this works", o que é correto. Não é perfeito — ele acrescenta um monte de coisas aleatórias no final — mas certamente funciona. Se você pode encontrar ou escrever um conversor de Word em texto simples que funciona bem o suficiente, esta solução provavelmente será incrivelmente eficaz. No entanto, `strings` está disponível na maioria dos sistemas Mac e Linux, por isso pode ser uma primeira boa tentativa para fazer isso com muitos formatos binários.

##### Documentos de Texto OpenDocument #####

A mesma abordagem que usamos para arquivos do MS Word (`*.doc`) pode ser usada para arquivos de texto OpenDocument (`*.odt`) criados pelo OpenOffice.org.

Adicione a seguinte linha ao seu arquivo `.gitattributes`:

    *.odt diff=odt

Agora configure o filtro diff `odt` em `.git/config`:

    [diff "odt"]
        binary = true
        textconv = /usr/local/bin/odt-to-txt

Arquivos OpenDocument são na verdade diretórios zipados contendo vários arquivos (o conteúdo em um formato XML, folhas de estilo, imagens, etc.) Vamos precisar escrever um script para extrair o conteúdo e devolvê-lo como texto simples. Crie o arquivo `/usr/local/bin/odt-to-txt` (você é pode colocá-lo em um diretório diferente) com o seguinte conteúdo:

    #! /usr/bin/env perl
    # Simplistic OpenDocument Text (.odt) to plain text converter.
    # Author: Philipp Kempgen
    
    if (! defined($ARGV[0])) {
        print STDERR "No filename given!\n";
        print STDERR "Usage: $0 filename\n";
        exit 1;
    }
    
    my $content = '';
    open my $fh, '-|', 'unzip', '-qq', '-p', $ARGV[0], 'content.xml' or die $!;
    {
        local $/ = undef;  # slurp mode
        $content = <$fh>;
    }
    close $fh;
    $_ = $content;
    s/<text:span\b[^>]*>//g;           # remove spans
    s/<text:h\b[^>]*>/\n\n*****  /g;   # headers
    s/<text:list-item\b[^>]*>\s*<text:p\b[^>]*>/\n    --  /g;  # list items
    s/<text:list\b[^>]*>/\n\n/g;       # lists
    s/<text:p\b[^>]*>/\n  /g;          # paragraphs
    s/<[^>]+>//g;                      # remove all XML tags
    s/\n{2,}/\n\n/g;                   # remove multiple blank lines
    s/\A\n+//;                         # remove leading blank lines
    print "\n", $_, "\n\n";

E torne-o executável

    chmod +x /usr/local/bin/odt-to-txt

Agora `git diff` será capaz de dizer o que mudou em arquivos `.odt`.

Outro problema interessante que você pode resolver desta forma envolve o diff de arquivos de imagem. Uma maneira de fazer isso é passar arquivos PNG através de um filtro que extrai suas informações EXIF — metadados que são gravados com a maioria dos formatos de imagem. Se você baixar e instalar o programa `exiftool`, você pode usá-lo para converter suas imagens em texto sobre os metadados, assim pelo menos o diff vai mostrar uma representação textual de todas as mudanças que aconteceram:

    $ echo '*.png diff=exif' >> .gitattributes
    $ git config diff.exif.textconv exiftool

Se você substituir uma imagem em seu projeto e executar o `git diff`, você verá algo como isto:

    diff --git a/image.png b/image.png
    index 88839c4..4afcb7c 100644
    --- a/image.png
    +++ b/image.png
    @@ -1,12 +1,12 @@
     ExifTool Version Number         : 7.74
    -File Size                       : 70 kB
    -File Modification Date/Time     : 2009:04:21 07:02:45-07:00
    +File Size                       : 94 kB
    +File Modification Date/Time     : 2009:04:21 07:02:43-07:00
     File Type                       : PNG
     MIME Type                       : image/png
    -Image Width                     : 1058
    -Image Height                    : 889
    +Image Width                     : 1056
    +Image Height                    : 827
     Bit Depth                       : 8
     Color Type                      : RGB with Alpha

Você pode facilmente ver que o tamanho do arquivo e as dimensões da imagem sofreram alterações.

### Expansão de Palavra-chave ###

Expansão de Palavra-chave no estilo SVN ou CVS são frequentemente solicitados pelos desenvolvedores acostumados com estes sistemas. O principal problema disso no Git é que você não pode modificar um arquivo com informações sobre o commit depois que você já fez o commit, porque o Git cria os checksums dos arquivos primeiro. No entanto, você pode injetar texto em um arquivo quando é feito o checkout dele e removê-lo novamente antes de ser adicionado a um commit. Atributos Git oferecem duas maneiras de fazer isso.

Primeiro, você pode injetar o SHA-1 checksum de um blob em um campo `$Id$` no arquivo automaticamente. Se você definir esse atributo em um arquivo ou conjunto de arquivos, então da próxima vez que você fizer o checkout do branch, o Git irá substituir o campo com o SHA-1 do blob. É importante notar que não é o SHA do commit, mas do blob em si:

    $ echo '*.txt ident' >> .gitattributes
    $ echo '$Id$' > test.txt

Da próxima vez que você fizer o checkout desse arquivo, o Git injetará o SHA do blob:

    $ rm test.txt
    $ git checkout -- test.txt
    $ cat test.txt
    $Id: 42812b7653c7b88933f8a9d6cad0ca16714b9bb3 $

No entanto, este resultado é de uso limitado. Se você já usou a substituição de palavras em CVS ou Subversion, você pode incluir uma datestamp — o SHA não é lá muito útil, porque é bastante aleatório e você não pode dizer se um SHA é mais velho ou mais novo que o outro.

Acontece que você pode escrever seus próprios filtros para fazer substituições em arquivos no commit/checkout. Estes são os filtros "clean" e "smudge". No arquivo `.gitattributes`, você pode definir um filtro para determinados paths e configurar os scripts que irão processar os arquivos antes que seja feito um checkout ("smudge", ver Figura 7-2) e pouco antes do commit ("clean", veja a Figura 7-3). Estes filtros podem ser configurados para fazer todo tipo de coisas divertidas.

Insert 18333fig0702.png
Figura 7-2. O filtro “smudge” é rodado no checkout.

Insert 18333fig0703.png
Figura 7-3. O filtro “clean” é rodado quando arquivos passam para o estado staged.

A mensagem original do commit para esta funcionalidade dá um exemplo simples de como passar todo o seu código fonte C através do programa `indent` antes de fazer o commit. Você pode configurá-lo, definindo o atributo de filtro no arquivo `.gitattributes` para filtrar arquivos `*.c` com o filtro "indent":

    *.c     filter=indent

Então, diga ao Git o que o filtro "indent" faz em smudge e clean:

    $ git config --global filter.indent.clean indent
    $ git config --global filter.indent.smudge cat

Neste caso, quando você commitar os arquivos que correspondem a `*.c`, Git irá passá-los através do programa indent antes de commmitá-los e depois passá-los através do programa `cat` antes de fazer o checkout de volta para o disco. O programa `cat` é basicamente um no-op: ele mostra os mesmos dados que ele recebe. Esta combinação efetivamente filtra todos os arquivos de código fonte C através do `indent` antes de fazer o commit.

Outro exemplo interessante é a expansão da palavra-chave `$Date$`, estilo RCS. Para fazer isso corretamente, você precisa de um pequeno script que recebe um nome de arquivo, descobre a última data de commit deste projeto, e insere a data no arquivo. Aqui há um pequeno script Ruby que faz isso:

    #! /usr/bin/env ruby
    data = STDIN.read
    last_date = `git log --pretty=format:"%ad" -1`
    puts data.gsub('$Date$', '$Date: ' + last_date.to_s + '$')

Tudo o que o script faz é obter a última data de commit do comando `git log`, coloca ele em qualquer string `$Date$` que vê no stdin, e imprime os resultados — deve ser simples de fazer em qualquer linguagem que você esteja confortável. Você pode nomear este arquivo `expand_date` e colocá-lo em seu path. Agora, você precisa configurar um filtro no Git (chamaremos de `dater`) e diremos para usar o seu filtro `expand_date` para o smudge dos arquivos no checkout. Você vai usar uma expressão Perl para o clean no commit:

    $ git config filter.dater.smudge expand_date
    $ git config filter.dater.clean 'perl -pe "s/\\\$Date[^\\\$]*\\\$/\\\$Date\\\$/"'

Este trecho Perl retira qualquer coisa que vê em uma string `$Date$`, para voltar para onde você começou. Agora que o seu filtro está pronto, você pode testá-lo através da criação de um arquivo com a sua palavra-chave `$Date$` e então criar um atributo Git para esse arquivo que envolve o novo filtro:

    $ echo '# $Date$' > date_test.txt
    $ echo 'date*.txt filter=dater' >> .gitattributes

Se você fizer o commit dessas alterações e fizer o checkout do arquivo novamente, você verá a palavra-chave corretamente substituída:

    $ git add date_test.txt .gitattributes
    $ git commit -m "Testing date expansion in Git"
    $ rm date_test.txt
    $ git checkout date_test.txt
    $ cat date_test.txt
    # $Date: Tue Apr 21 07:26:52 2009 -0700$

Você pode ver o quão poderosa esta técnica pode ser para aplicações customizadas. Você tem que ter cuidado, porém, porque o arquivo `.gitattributes` está sendo commitado e mantido no projeto, mas o `dater` não é; assim, ele não vai funcionar em todos os lugares. Ao projetar esses filtros, eles devem ser capazes de falhar e ainda assim manter o projeto funcionando corretamente.

### Exportando Seu Repositório ###

Dados de atributo Git também permitem que você faça algumas coisas interessantes ao exportar um arquivo do seu projeto.

#### export-ignore ####

Você pode dizer para o Git não exportar determinados arquivos ou diretórios ao gerar um arquivo. Se existe uma subpasta ou arquivo que você não deseja incluir em seu arquivo, mas que você quer dentro de seu projeto, você pode determinar estes arquivos através do atributo `export-ignore`.

Por exemplo, digamos que você tenha alguns arquivos de teste em um subdiretório `test/`, e não faz sentido incluí-los na exportação do tarball do seu projeto. Você pode adicionar a seguinte linha ao seu arquivo de atributos Git:

    test/ export-ignore

Agora, quando você executar git archive para criar um arquivo tar do seu projeto, aquele diretório não será incluído no arquivo.

#### export-subst ####

Outra coisa que você pode fazer para seus arquivos é uma simples substituição de palavra. Git permite colocar a string `$Format:$` em qualquer arquivo com qualquer um dos códigos de formatação`--pretty=format`, muitos dos quais você viu no Capítulo 2. Por exemplo, se você quiser incluir um arquivo chamado `LAST_COMMIT` em seu projeto, e a última data de commit foi injetada automaticamente quando `git archive` foi executado, você pode configurar o arquivo como este:

    $ echo 'Last commit date: $Format:%cd$' > LAST_COMMIT
    $ echo "LAST_COMMIT export-subst" >> .gitattributes
    $ git add LAST_COMMIT .gitattributes
    $ git commit -am 'adding LAST_COMMIT file for archives'

Quando você executar `git archive`, o conteúdo do arquivo quando aberto será parecido com este:

    $ cat LAST_COMMIT
    Last commit date: $Format:Tue Apr 21 08:38:48 2009 -0700$

### Estratégias de Merge ###

Você também pode usar atributos Git para dizer ao Git para utilizar estratégias diferentes para mesclar arquivos específicos em seu projeto. Uma opção muito útil é dizer ao Git para não tentar mesclar arquivos específicos quando eles têm conflitos, mas sim para usar o seu lado do merge ao invés do da outra pessoa.

Isso é útil se um branch em seu projeto divergiu ou é especializado, mas você quer ser capaz de fazer o merge de alterações de volta a partir dele, e você deseja ignorar determinados arquivos. Digamos que você tenha um arquivo de configurações de banco de dados chamado database.xml que é diferente em dois branches, e você deseja mesclar em seu outro branch sem bagunçar o arquivo de banco de dados. Você pode configurar um atributo como este:

    database.xml merge=ours

Se você fizer o merge em outro branch, em vez de ter conflitos de merge com o arquivo database.xml, você verá algo como isto:

    $ git merge topic
    Auto-merging database.xml
    Merge made by recursive.

Neste caso, database.xml fica em qualquer versão que você tinha originalmente.

## Hooks do Git ##

Como muitos outros sistemas de controle de versão, Git tem uma maneira para disparar scripts personalizados quando certas ações importantes ocorrerem. Existem dois grupos desses hooks: lado cliente e lado servidor. Os hooks do lado cliente são para operações do cliente, tais como commit e merge. Os hooks do lado servidor são para operações de servidor, como recebimento de um push. Você pode usar estes hooks para todo tipo de coisa, e você vai aprender sobre alguns deles aqui.

### Instalando um Hook ###

Os hooks são todos armazenados no subdiretório `hooks` do diretório Git. Na maioria dos projetos, é em `.git/hooks`. Por padrão, o Git preenche este diretório com um monte de scripts de exemplo, muitos dos quais são úteis por si só, mas eles também documentam os valores de entrada de cada script. Todos os exemplos são escritos como shell scripts, com um pouco de Perl, mas todos os scripts executáveis ​​devidamente nomeados irão funcionar bem — você pode escrevê-los em Ruby ou Python ou em que você quiser. Para as versões do Git superiores a 1.6, esses hooks de exemplo terminam com .sample; você precisa renomeá-los. Para versões anteriores a 1.6 do Git, os arquivos de exemplo são nomeados corretamente, mas não são executáveis.

Para ativar um script de hook, coloque um arquivo no subdiretório `hooks` do seu diretório Git que é nomeado de forma adequada e é executável. A partir desse ponto, ele deve ser chamado. Eu vou cobrir a maior parte dos nomes dos arquivos de hook importantes aqui.

### Hooks do Lado Cliente ###

Há um monte de hooks do lado do cliente. Esta seção divide eles em committing-workflow hooks, e-mail-workflow scripts, e o resto dos scripts do lado cliente.

#### Committing-Workflow Hooks ####

Os primeiros quatro hooks têm a ver com o processo de commit. O hook `pre-commit` é executado primeiro, antes mesmo de digitar uma mensagem de confirmação. É usado para inspecionar o snapshot que está prestes a ser commitado, para ver se você se esqueceu de alguma coisa, para ter certeza que os testes rodem, ou para analisar o que você precisa inspecionar no código. Retornando um valor diferente de zero a partir deste hook aborta o commit, mas você pode ignorá-lo com `git commit --no-verify`. Você pode fazer coisas como checar o estilo do código (executar lint ou algo equivalente), verificar o espaço em branco (o hook padrão faz exatamente isso), ou verificar a documentação apropriada sobre novos métodos.

O hook `prepare-commit-msg` é executado antes que o editor de mensagem de commit seja iniciado, mas depois que a mensagem padrão seja criada. Ele permite que você edite a mensagem padrão antes que autor do commit a veja. Este hook tem algumas opções: o caminho para o arquivo que contém a mensagem de confirmação até agora, o tipo de commit, e o SHA-1 do commit se este é um commit amended. Este hook geralmente não é útil para o commit normal, mas sim, para commits onde a mensagem padrão é gerada automaticamente, tal como um template de mensagem de commit, commits de merge, squashed commits, e amended commits. Você pode usá-lo em conjunto com um modelo de commit para inserir informações programaticamente.

O hook `commit-msg` tem um parâmetro, que novamente, é o caminho para um arquivo temporário que contém a mensagem atual de commit. Se este script não retornar zero, Git aborta o processo de commit, de modo que você pode usá-lo para validar o seu estado de projeto ou mensagem de commit antes de permitir que um commit prossiga. Na última seção deste capítulo, vou demonstrar usando este hook como verificar se a sua mensagem de commit está em conformidade com um padrão desejado.

Depois que todo o processo de commit esteja concluído, o hook `post-commit` é executado. Ele não recebe nenhum parâmetro, mas você pode facilmente obter o último commit executando `git log -1 HEAD`. Geralmente, esse script é usado para notificação ou algo similar.

Os scripts committing-workflow do lado cliente podem ser usados ​​em praticamente qualquer fluxo de trabalho. Eles são muitas vezes utilizados para reforçar certas políticas, embora seja importante notar que estes scripts não são transferidos durante um clone. Você pode aplicar a política do lado servidor para rejeitar um push de um commit que não corresponda a alguma política, mas é inteiramente de responsabilidade do desenvolvedor usar esses scripts no lado cliente. Portanto, estes são scripts para ajudar os desenvolvedores, e eles devem ser criados e mantidos por eles, embora eles possam ser substituídos ou modificados por eles a qualquer momento.

#### E-mail Workflow Hooks ####

Você pode configurar três hooks do lado cliente para um fluxo de trabalho baseado em e-mail. Eles são todos invocados pelo comando `git am`, por isso, se você não está usando este comando em seu fluxo de trabalho, você pode pular para a próxima seção. Se você estiver recebendo patches por e-mail preparados por `git format-patch`, então alguns deles podem ser úteis para você.

O primeiro hook que é executado é `applypatch msg`. Ele recebe um único argumento: o nome do arquivo temporário que contém a mensagem de commit. Git aborta o patch se este script retornar valor diferente de zero. Você pode usar isso para se certificar de que uma mensagem de commit está formatada corretamente ou para normalizar a mensagem através do script.

O próximo hook a ser executado durante a aplicação de patches via `git am` é `pre-applypatch`. Ele não tem argumentos e é executado após a aplicação do patch, então, você pode usá-lo para inspecionar o snapshot antes de fazer o commit. Você pode executar testes ou inspecionar a árvore de trabalho com esse script. Se algo estiver faltando ou os testes não passarem, retornando um valor diferente de zero também aborta o script `git am` sem commmitar o patch.

O último hook a ser executado durante um `git am` é `post-applypatch`. Você pode usá-lo para notificar um grupo ou o autor do patch que você aplicou em relação ao que você fez. Você não pode parar o processo de patch com esse script.

#### Outros Hooks de Cliente ####

O hook `pre-rebase` é executado antes de um rebase e pode interromper o processo terminando com valor diferente de zero. Você pode usar esse hook para não permitir rebasing de commits que já foram atualizados com um push. O hook `pre-rebase` de exemplo que o Git instala faz isso, embora ele assuma que o próximo é o nome do branch que você publicar. É provável que você precise mudar isso para seu branch estável ou publicado.

Depois de executar um `git checkout` com sucesso, o hook `post-checkout` é executado, você pode usá-lo para configurar o diretório de trabalho adequadamente para o seu ambiente de projeto. Isso pode significar mover arquivos binários grandes que você não quer controlar a versão, documentação auto-gerada, ou algo parecido.

Finalmente, o hook `post-merge` roda depois de um `merge` executado com sucesso. Você pode usá-lo para restaurar dados na árvore de trabalho que o GIT não pode rastrear, como dados de permissões. Este hook pode igualmente validar a presença de arquivos externos ao controle do Git que você pode querer copiado quando a árvore de trabalho mudar.

### Hooks do Lado Servidor ###

Além dos Hooks do lado do cliente, você pode usar alguns hooks importantes do lado servidor como administrador do sistema para aplicar quase qualquer tipo de política para o seu projeto. Esses scripts são executados antes e depois um push para o servidor. Os "pre hooks" podem retornar valor diferente de zero em qualquer momento para rejeitar um push, assim como imprimir uma mensagem de erro para o cliente, você pode configurar uma política de push tão complexa quanto você queira.

#### pre-receive e post-receive ####

O primeiro script a ser executado ao tratar um push de um cliente é o `pre-receive`. É preciso uma lista de referências que estão no push a partir do stdin; se ele não retornar zero, nenhum deles são aceitos. Você pode usar esse hook para fazer coisas como verificar se nenhuma das referências atualizadas não são fast-forwards; ou para verificar se o usuário que está fazendo o push tem acesso para criar, apagar, ou fazer push de atualizações para todos os arquivos que ele está modificando com o push.

O hook `post-receive` roda depois que todo o processo esteja concluído e pode ser usado para atualizar outros serviços ou notificar os usuários. Ele recebe os mesmos dados do stdin que o hook `pre-receive`. Exemplos incluem envio de e-mails, notificar um servidor de integração contínua, ou atualização de um sistema de ticket-tracking — você pode até analisar as mensagens de confirmação para ver se algum ticket precisa ser aberto, modificado ou fechado. Este script não pode parar o processo de push, mas o cliente não se disconecta até que tenha concluído; por isso, tenha cuidado quando você tentar fazer algo que possa levar muito tempo.

#### update ####

O script update é muito semelhante ao script `pre-receive`, exceto que ele é executado uma vez para cada branch que o usuário está tentando atualizar. Se o usuário está tentando fazer um push para vários branchs, `pre-receive` é executado apenas uma vez, enquanto que update é executado uma vez por branch do push. Em vez de ler do stdin, este script recebe três argumentos: o nome da referência (branch), o SHA-1, que apontava para a referência antes do push, e o SHA-1 do push que o usuário está tentando fazer. Se o script update retornar um valor diferente de zero, apenas a referência é rejeitada; outras referências ainda podem ser atualizadas.

## Um exemplo de Política Git Forçada ##

Nesta seção, você vai usar o que aprendeu para estabelecer um fluxo de trabalho Git que verifica um formato de mensagem personalizado para commit, e força o uso apenas de push fast-forward, e permite que apenas alguns usuários possam modificar determinados subdiretórios em um projeto. Você vai construir scripts cliente que ajudam ao desenvolvedor saber se seu push será rejeitado e scripts de servidor que fazem valer as políticas.

Eu usei Ruby para escrever estes, isso porque é a minha linguagem de script preferida e porque eu sinto que é a linguagem de script que mais parece com pseudocódigo; assim você deve ser capaz de seguir o código, mesmo que você não use Ruby. No entanto, qualquer linguagem funcionará bem. Todos os exemplos de scripts de hooks distribuídos com o Git são feitos em Perl ou Bash, então você também pode ver vários exemplos de hooks nessas linguagens olhando os exemplos.

### Hook do Lado Servidor ###

Todo o trabalho do lado servidor irá para o arquivo update no seu diretório de hooks. O arquivo update é executado uma vez por branch de cada push e leva a referência do push para a revisão antiga onde o branch estava, e a nova revisão do push. Você também terá acesso ao usuário que está realizando o push, se o push está sendo executado através de SSH. Se você permitiu que todos se conectem com um único usuário (como "git"), através de autenticação de chave pública, você pode ter que dar ao usuário um "shell wrapper" que determina qual usuário está se conectando com base na chave pública, e definir uma variável de ambiente especificando o usuário. Aqui eu assumo que o usuário de conexão está na variável de ambiente `$USER`, então, seu script de atualização começa reunindo todas as informações que você precisa:

    #!/usr/bin/env ruby

    $refname = ARGV[0]
    $oldrev  = ARGV[1]
    $newrev  = ARGV[2]
    $user    = ENV['USER']

    puts "Enforcing Policies... \n(#{$refname}) (#{$oldrev[0,6]}) (#{$newrev[0,6]})"

Sim, eu estou usando variáveis ​​globais. Não me julgue — é mais fácil para demonstrar desta maneira.

#### Impondo um Formato Específico de Mensagens de Commit ####

Seu primeiro desafio é impor que cada mensagem de commit deve aderir a um formato específico. Só para se ter uma meta, vamos supor que cada mensagem tem de incluir uma string que parece com "ref: 1234" porque você quer que cada commit tenha um link para um item de trabalho no seu sistema de chamados. Você deve olhar para cada commit do push, ver se essa sequência está na mensagem de commit, e, se a string estiver ausente de qualquer um dos commits, retornar zero para que o push seja rejeitado.

Você pode obter uma lista dos valores SHA-1 de todos os commits de um push, através dos valores `$newrev` e `$oldrev` e passando-os para um comando Git plumbing chamado `git rev-list`. Este é basicamente o comando `git log`, mas por padrão ele mostra apenas os valores SHA-1 e nenhuma outra informação. Assim, para obter uma lista de todos os SHAs de commits introduzidos entre um commit SHA e outro, você pode executar algo como abaixo:

    $ git rev-list 538c33..d14fc7
    d14fc7c847ab946ec39590d87783c69b031bdfb7
    9f585da4401b0a3999e84113824d15245c13f0be
    234071a1be950e2a8d078e6141f5cd20c1e61ad3
    dfa04c9ef3d5197182f13fb5b9b1fb7717d2222a
    17716ec0f1ff5c77eff40b7fe912f9f6cfd0e475

Você pode pegar essa saída, percorrer cada um dos SHAs dos commits, pegar a mensagem para ele, e testar a mensagem contra uma expressão regular que procura um padrão.

Você tem que descobrir como pegar a mensagem de confirmação de cada um dos commits para testar. Para obter os dados brutos do commit, você pode usar um outro comando plumbing chamado `git cat-file`. Eu vou falar de todos estes comandos plumbing em detalhes no Capítulo 9; mas, por agora, aqui está o resultado do comando:

    $ git cat-file commit ca82a6
    tree cfda3bf379e4f8dba8717dee55aab78aef7f4daf
    parent 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
    author Scott Chacon <schacon@gmail.com> 1205815931 -0700
    committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

    changed the verison number

Uma maneira simples de obter a mensagem de confirmação de um commit quando você tem o valor SHA-1 é ir para a primeira linha em branco e retirar tudo depois dela. Você pode fazer isso com o comando `sed` em sistemas Unix:

    $ git cat-file commit ca82a6 | sed '1,/^$/d'
    changed the verison number

Você pode usar isso para pegar a mensagem de cada commit do push e sair se você ver algo que não corresponde. Para sair do script e rejeitar o push, retorne um valor diferente de zero. Todo o método se parece com este:

    $regex = /\[ref: (\d+)\]/

    # enforced custom commit message format
    def check_message_format
      missed_revs = `git rev-list #{$oldrev}..#{$newrev}`.split("\n")
      missed_revs.each do |rev|
        message = `git cat-file commit #{rev} | sed '1,/^$/d'`
        if !$regex.match(message)
          puts "[POLICY] Your message is not formatted correctly"
          exit 1
        end
      end
    end
    check_message_format

Colocar isso no seu script `update` rejeitará atualizações que contenham commits que tem mensagens que não aderem à sua regra.

#### Impondo um Sistema ACL Baseado em Usuário ####

Suponha que você queira adicionar um mecanismo que utiliza uma lista de controle de acesso (ACL) que especifica quais usuários têm permissão para fazer push com mudanças para partes de seus projetos. Algumas pessoas têm acesso total, e outras só têm acesso a alterar determinados subdiretórios ou arquivos específicos. Para impor isso, você vai escrever essas regras em um arquivo chamado `acl` que ficará em seu repositório Git no servidor. O hook `update` verificará essas regras, verá quais arquivos estão sendo introduzidos nos commits do push, e determinará se o usuário que está fazendo o push tem acesso para atualizar todos os arquivos.

A primeira coisa que você deve fazer é escrever o seu ACL. Aqui você vai usar um formato muito parecido com o mecanismo de ACL CVS: ele usa uma série de linhas, onde o primeiro campo é `avail` ou `unavail`, o próximo campo é uma lista delimitada por vírgula dos usuários para que a regra se aplica, e o último campo é o caminho para o qual a regra se aplica (branco significando acesso em  aberto). Todos esses campos são delimitados por um caractere pipe (`|`).

Neste caso, você tem alguns administradores, alguns escritores de documentação com acesso ao diretório `doc`, e um desenvolvedor que só tem acesso aos diretórios `lib` e `tests`, seu arquivo ACL fica assim:

    avail|nickh,pjhyett,defunkt,tpw
    avail|usinclair,cdickens,ebronte|doc
    avail|schacon|lib
    avail|schacon|tests

Você começa lendo esses dados em uma estrutura que você pode usar. Neste caso, para manter o exemplo simples, você só vai cumprir as diretrizes do `avail`. Aqui está um método que lhe dá um array associativo onde a chave é o nome do usuário e o valor é um conjunto de paths que o usuário tem acesso de escrita:

    def get_acl_access_data(acl_file)
      # read in ACL data
      acl_file = File.read(acl_file).split("\n").reject { |line| line == '' }
      access = {}
      acl_file.each do |line|
        avail, users, path = line.split('|')
        next unless avail == 'avail'
        users.split(',').each do |user|
          access[user] ||= []
          access[user] << path
        end
      end
      access
    end

No arquivo ACL que você viu anteriormente, o método `get_acl_access_data` retorna uma estrutura de dados que se parece com esta:

    {"defunkt"=>[nil],
     "tpw"=>[nil],
     "nickh"=>[nil],
     "pjhyett"=>[nil],
     "schacon"=>["lib", "tests"],
     "cdickens"=>["doc"],
     "usinclair"=>["doc"],
     "ebronte"=>["doc"]}

Agora que você tem as permissões organizadas, é preciso determinar quais os paths que os commits do push modificam, de modo que você pode ter certeza que o usuário que está fazendo o push tem acesso a todos eles.

Você pode muito facilmente ver quais arquivos foram modificados em um único commit com a opção `--name-only` do comando `git log` (mencionado brevemente no Capítulo 2):

    $ git log -1 --name-only --pretty=format:'' 9f585d

    README
    lib/test.rb

Se você usar a estrutura ACL retornada pelo método `get_acl_access_data` e verificar a relação dos arquivos listados em cada um dos commits, você pode determinar se o usuário tem acesso ao push de todos os seus commits:

    # only allows certain users to modify certain subdirectories in a project
    def check_directory_perms
      access = get_acl_access_data('acl')


      # see if anyone is trying to push something they can't
      new_commits = `git rev-list #{$oldrev}..#{$newrev}`.split("\n")
      new_commits.each do |rev|
        files_modified = `git log -1 --name-only --pretty=format:'' #{rev}`.split("\n")
        files_modified.each do |path|
          next if path.size == 0
          has_file_access = false
          access[$user].each do |access_path|
            if !access_path || # user has access to everything
              (path.index(access_path) == 0) # access to this path
              has_file_access = true
            end
          end
          if !has_file_access
            puts "[POLICY] You do not have access to push to #{path}"
            exit 1
          end
        end
      end
    end

    check_directory_perms

A maior parte do código deve ser fácil de acompanhar. Você receberá uma lista de novos commits do push com `git rev-list`. Então, para cada um desses, você acha quais arquivos são modificados e verifica se o usuário que está fazendo o push tem acesso a todos os paths sendo modificados. Um Rubyism que pode não ser claro é `path.index(access_path) == 0`, que é verdadeiro se o caminho começa com `access_path` — isso garante que `access_path` não esta apenas em um dos caminhos permitidos, mas um path permitido começa com cada path acessado.

Agora seus usuários não podem fazer o push de qualquer commit com mensagens mal formadas ou com arquivos modificados fora de seus paths designados.

#### Impondo Apenas Fast-Forward Pushes ####

A única coisa que resta é impor apenas fast-forward pushes. Nas versões Git 1.6 ou mais recentes, você pode definir as configurações `receive.denyDeletes` e `receive.denyNonFastForwards`. Mas utilizar um hook irá funcionar em versões mais antigas do Git, e você pode modificá-lo para impor a diretiva apenas para determinados usuários ou fazer qualquer outra coisa que você queira.

A lógica para verificar isso é ver se algum commit é acessível a partir da revisão mais antiga que não é acessível a partir da versão mais recente. Se não houver nenhum, então foi um push Fast-Forward; caso contrário, você nega ele:

    # enforces fast-forward only pushes
    def check_fast_forward
      missed_refs = `git rev-list #{$newrev}..#{$oldrev}`
      missed_ref_count = missed_refs.split("\n").size
      if missed_ref_count > 0
        puts "[POLICY] Cannot push a non fast-forward reference"
        exit 1
      end
    end

    check_fast_forward

Tudo está configurado. Se você executar `chmod u+x .git/hooks/update`, que é o arquivo no qual você deve ter colocado todo este código, e então tentar fazer um push de uma referência não fast-forwarded, você verá algo como isto:

    $ git push -f origin master
    Counting objects: 5, done.
    Compressing objects: 100% (3/3), done.
    Writing objects: 100% (3/3), 323 bytes, done.
    Total 3 (delta 1), reused 0 (delta 0)
    Unpacking objects: 100% (3/3), done.
    Enforcing Policies...
    (refs/heads/master) (8338c5) (c5b616)
    [POLICY] Cannot push a non fast-forward reference
    error: hooks/update exited with error code 1
    error: hook declined to update refs/heads/master
    To git@gitserver:project.git
     ! [remote rejected] master -> master (hook declined)
    error: failed to push some refs to 'git@gitserver:project.git'

Há algumas coisas interessantes aqui. Primeiro, você vê quando o hook começa a funcionar.

    Enforcing Policies...
    (refs/heads/master) (8338c5) (c5b616)

Observe que você imprimiu aquilo no stdout no início do seu script de atualização. É importante notar que qualquer coisa que seu script imprima no stdout será transferido para o cliente.

A próxima coisa que você vai notar é a mensagem de erro.

    [POLICY] Cannot push a non fast-forward reference
    error: hooks/update exited with error code 1
    error: hook declined to update refs/heads/master

A primeira linha foi impressa por você, as outras duas foram pelo Git dizendo que o script de atualização não retornou zero e é isso que está impedindo seu push. Por último, você verá isso:

    To git@gitserver:project.git
     ! [remote rejected] master -> master (hook declined)
    error: failed to push some refs to 'git@gitserver:project.git'

Você verá uma mensagem de rejeição remota para cada referência que o seu hook impediu, e ele diz que ele foi recusado especificamente por causa de uma falha de hook.

Além disso, se o marcador ref não existir em nenhum dos seus commits, você verá a mensagem de erro que você está imprimindo para ele.

    [POLICY] Your message is not formatted correctly

Ou se alguém tentar editar um arquivo que não têm acesso e fazer um push de um commit que o contém, ele verá algo semelhante. Por exemplo, se um autor de documentação tenta fazer um push de um commit modificando algo no diretório `lib`, ele verá

    [POLICY] You do not have access to push to lib/test.rb

Isto é tudo. A partir de agora, desde que o script `update` esteja lá e seja executável, seu repositório nunca será rebobinado e nunca terá uma mensagem de commit sem o seu padrão nela, e os usuários terão restrições.

### Hooks do Lado Cliente  ###

A desvantagem desta abordagem é a choraminga que resultará inevitavelmente quando os pushes de commits de seus usuários forem rejeitados. Tendo seu trabalho cuidadosamente elaborada rejeitado no último minuto pode ser extremamente frustrante e confuso; e, além disso, eles vão ter que editar seu histórico para corrigi-lo, o que nem sempre é para os fracos de coração.

A resposta para este dilema é fornecer alguns hooks do lado cliente que os usuários possam usar para notificá-los quando eles estão fazendo algo que o servidor provavelmente rejeitará. Dessa forma, eles podem corrigir quaisquer problemas antes de fazer o commit e antes desses problemas se tornarem mais difíceis de corrigir. Já que hooks não são transferidos com um clone de um projeto, você deve distribuir esses scripts de alguma outra forma e, então, usuários devem copiá-los para seu diretório `.git/hooks` e torná-los executáveis. Você pode distribuir esses hooks dentro do projeto ou em um projeto separado, mas não há maneiras de configurá-los automaticamente.

Para começar, você deve verificar a sua mensagem de confirmação antes que cada commit seja gravado, então você saberá que o servidor não irá rejeitar as alterações devido a mensagens de commit mal formatadas. Para fazer isso, você pode adicionar o hook `commit-msg`. Se fizer ele ler as mensagens do arquivo passado como o primeiro argumento e comparar ele com o padrão, você pode forçar o Git a abortar o commit se eles não corresponderem:

    #!/usr/bin/env ruby
    message_file = ARGV[0]
    message = File.read(message_file)

    $regex = /\[ref: (\d+)\]/

    if !$regex.match(message)
      puts "[POLICY] Your message is not formatted correctly"
      exit 1
    end

Se esse script está no lugar correto (em `.git/hooks/commit-msg`) e é executável, e você fizer um commit com uma mensagem que não está formatada corretamente, você verá isso:

    $ git commit -am 'test'
    [POLICY] Your message is not formatted correctly

Nenhum commit foi concluído nessa instância. No entanto, se a mensagem conter o padrão adequado, o Git permite o commit:

    $ git commit -am 'test [ref: 132]'
    [master e05c914] test [ref: 132]
     1 files changed, 1 insertions(+), 0 deletions(-)

Em seguida, você quer ter certeza de que você não está modificando os arquivos que estão fora do seu escopo ACL. Se o seu diretório de projeto `.git` contém uma cópia do arquivo ACL que você usou anteriormente, então o seguinte script `pre-commit` irá impor essas restrições para você:

    #!/usr/bin/env ruby

    $user = ENV['USER']

    # [ insert acl_access_data method from above ]

    # only allows certain users to modify certain subdirectories in a project
    def check_directory_perms
      access = get_acl_access_data('.git/acl')

      files_modified = `git diff-index --cached --name-only HEAD`.split("\n")
      files_modified.each do |path|
        next if path.size == 0
        has_file_access = false
        access[$user].each do |access_path|
        if !access_path || (path.index(access_path) == 0)
          has_file_access = true
        end
        if !has_file_access
          puts "[POLICY] You do not have access to push to #{path}"
          exit 1
        end
      end
    end

    check_directory_perms

Este é aproximadamente o mesmo script da parte do lado servidor, mas com duas diferenças importantes. Primeiro, o arquivo ACL está em um lugar diferente, porque este script é executado a partir do seu diretório de trabalho, e não de seu diretório Git. Você tem que mudar o path para o arquivo ACL, disso

    access = get_acl_access_data('acl')

para isso:

    access = get_acl_access_data('.git/acl')

A outra diferença importante é a forma como você obtem uma lista dos arquivos que foram alterados. Como o método do lado servidor olha no log de ​​commits e, neste momento, o commit não foi gravado ainda, você deve pegar sua lista de arquivos da área staging. Em vez de

    files_modified = `git log -1 --name-only --pretty=format:'' #{ref}`

você deve usar

    files_modified = `git diff-index --cached --name-only HEAD`

Mas essas são as duas únicas diferenças — caso contrário, o script funciona da mesma maneira. Uma ressalva é que ele espera que você esteja executando localmente como o mesmo usuário que você fez o push para a máquina remota. Se ele for diferente, você deve definir a variável `$user` manualmente.

A última coisa que você tem que fazer é verificar se você não está tentando fazer o push de referências não fast-forwarded, mas isso é um pouco menos comum. Para obter uma referência que não é um fast-forward, você tem que fazer um rebase depois de um commit que já foi enviado por um push ou tentar fazer o push de um branch local diferente até o mesmo branch remoto.

Como o servidor vai dizer que você não pode fazer um push não fast-forward de qualquer maneira, e o hook impede pushes forçados, a única coisa acidental que você pode tentar deter são commits de rebase que já foram enviados por um push.

Aqui está um exemplo de script pré-rebase que verifica isso. Ele recebe uma lista de todos os commits que você está prestes a reescrever e verifica se eles existem em qualquer uma das suas referências remotas. Se ele vê um que é acessível a partir de uma de suas referências remotas, ele aborta o rebase:

    #!/usr/bin/env ruby

    base_branch = ARGV[0]
    if ARGV[1]
      topic_branch = ARGV[1]
    else
      topic_branch = "HEAD"
    end

    target_shas = `git rev-list #{base_branch}..#{topic_branch}`.split("\n")
    remote_refs = `git branch -r`.split("\n").map { |r| r.strip }

    target_shas.each do |sha|
      remote_refs.each do |remote_ref|
        shas_pushed = `git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}`
        if shas_pushed.split(“\n”).include?(sha)
          puts "[POLICY] Commit #{sha} has already been pushed to #{remote_ref}"
          exit 1
        end
      end
    end

Este script utiliza uma sintaxe que não foi coberta na seção Seleção de Revisão do Capítulo 6. Você obterá uma lista de commits que já foram foram enviados em um push executando isto:

    git rev-list ^#{sha}^@ refs/remotes/#{remote_ref}

A sintaxe `SHA^@` resolve para todos os pais daquele commit. Você está à procura de qualquer commit que é acessível a partir do último commit no remoto e que não é acessível a partir de qualquer pai de qualquer um dos SHAs que você está tentando fazer o push — o que significa que é um fast-forward.

A principal desvantagem desta abordagem é que ela pode ser muito lenta e muitas vezes é desnecessária — se você não tentar forçar o push com `-f`, o servidor irá avisá-lo e não aceitará o push. No entanto, é um exercício interessante e pode, em teoria, ajudar a evitar um rebase que você possa mais tarde ter que voltar atrás e corrigir.

## Sumário ##

Você viu a maior parte das principais formas que você pode usar para personalizar o seu cliente e servidor Git para melhor atender a seu fluxo de trabalho e projetos. Você aprendeu sobre todos os tipos de configurações, atributos baseados em arquivos, e hooks de eventos, e você construiu um exemplo de política aplicada ao servidor. Agora você deve ser capaz de usar o Git em quase qualquer fluxo de trabalho que você possa sonhar.
