# Customizando Git #

Até agora, eu cobri o básico de como o Git funciona, como usá-lo e apresentei algumas de ferramentas que o Git provê para ajudá-lo a usá-lo facilmente e eficientemente. Neste capítulo, eu passarei por algumas operações que você pode usar para fazer operações com Git de uma maneira mais customizadas introduzindo vários configurações importantes e um sistemas de hooks. Com essa ferramentas, é fácil trabalhar com Git do seu jeito, do jeito da sua empresa ou do jeito de qualquer grupo que precise. 

## Configuração do Git ##

Como você viu brevemente no Capítulo 1, você pode configurações do Git com o comando `git config`. Umas das primeiras coisas que vocẽ fez foi configurar seu nome e endereço de email:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Agora você vai aprender algumas opções mais interessantes que você pode definir dessa maneira para customizar o seu uso do Git.

Você viu alguns detalhes de configuração de Git no primeiro capítulo, mas Eu vou passar por cime rapidamente aqui. Git usa uma série de arquivos de configuração para determinar um comportamento não padrão que você queira. O primeiro lugar onde o Git procura poe esses valores é no arquivo `/etc/gitconfig`, que contém valores para todos os usuários do sistemas e todos os seus repositórios. Se você passar a opção `--system` para o `git config`, ele lê e escreve a partir desse arquivo especificamente.

O próximo lugar que o Git procura é o arquivo `~/.gitconfig`, que é específico para cada usuário. Você pode fazer o Git ler e escrever apartir deste arquivo, passando a opção `--global`.

Finalmente, O Git procura por valores de configuração no arquivo de configuração no diretório Git (`.git/config`) de qualquer repositório que você está usando atualmente. Estes valores são específicos para esse repositório único. Cada nível sobrescreve valores no nível anterior, para valores em `.git/config` se sobrepõem aqueles em `/ etc/sysconfig`, por exemplo. Você também pode definir esses valores manualmente, editando o arquivo e inserir a sintaxe correta, mas é geralmente mais fácil de executar o comando `git config`.

### Configuração Básica do Cliente ###

As opções de configuração reconhecidos pela queda Git em duas categorias: do lado do cliente e servidor. A maioria das opções estão lado-cliente configurar suas preferências pessoais de trabalho. Apesar de toneladas de opções disponíveis, eu só vou cobrir os poucos que ou são comumente usados ​​ou podem afetar significativamente o fluxo de trabalho. Muitas opções são úteis apenas em casos extremos que eu não vou passar por cima aqui. Se você quiser ver uma lista de todas as opções a sua versão do Git reconhece, você pode executar

$ Git config - help

A página do manual para `git config` lista todas as opções disponíveis em um pouco de detalhe.

#### Core.editor ####

Por padrão, o Git usa o que quer que você definiu como seu editor de texto padrão ou então cai de volta para o editor vi para criar e editar a sua confirmação e mensagens de marca. Para alterar esse padrão para outra coisa, você pode usar o `core.editor configuração`:

$ Git config - global core.editor emacs

Agora, não importa o que está definido como o shell editor Git padrão variável, dispara-se o Emacs para editar mensagens.

# # # # Commit.template # # # #

Se você ajustar para o caminho de um arquivo em seu sistema, Git vai usar esse arquivo como o padrão de mensagem quando você cometer. Por exemplo, suponha que você crie um arquivo de modelo em `$ HOME / .gitmessage.txt` que se parece com esta:

linha de assunto

o que aconteceu

[Bilhete: X]

Para dizer Git para usá-lo como a mensagem padrão que aparece em seu editor para executar o `git commit ', defina o valor de configuração` commit.template `:

$ Git config - commit.template global $ HOME / .gitmessage.txt
$ Git commit

Em seguida, o editor irá abrir para algo como isto para sua mensagem de espaço reservado quando você cometer:

linha de assunto

o que aconteceu

[Bilhete: X]
# Por favor insira a mensagem de confirmação de suas alterações. Linhas de partida
# Com '#' serão ignorados, e uma mensagem de vazio aborta a cometer.
# No mestre ramo
# Altera a ser cometidos:
# (Use "git reset HEAD <file> ..." para unstage)
#
# Modificado: lib / test.rb
#
~
~
".git / COMMIT_EDITMSG" 14L, 297C

Se você tem uma política de transmissão de mensagens no local, em seguida, colocar um modelo para que a política de seu sistema e configurar o Git para usá-lo por padrão pode ajudar a aumentar a chance de que a política a ser seguida regularmente.

# # # # Core.pager # # # #

A configuração core.pager determina o pager é usado quando Git saída páginas como `log` e `diff`. Você pode configurá-lo para `mais` ou para o seu pager favorito (por padrão, é `menos`), ou você pode desligá-lo, definindo-a uma cadeia em branco:

$ Git config - core.pager mundial''

Se você executar isso, Git página toda a produção de todos os comandos, não importa quanto tempo eles são.

# # # # User.signingkey # # # #

Se você está fazendo assinados marcas anotadas (como discutido no Capítulo 2), definir a sua chave de assinatura GPG como uma configuração que torna as coisas mais fáceis. Definir o ID da chave assim:

$ Git config - <gpg-key-id> user.signingkey mundial

Agora, você pode assinar tags sem ter de especificar a sua chave de cada vez com o comando git tag `:

$ Git tag-s <tag-name>

# # # # Core.excludesfile # # # #

Você pode colocar padrões em seu projeto. Gitignore arquivo `ter Git não vê-los como arquivos untracked ou tentar conduzi-los para executar o` git add `sobre eles, como discutido no Capítulo 2. No entanto, se você quiser um outro arquivo fora do seu projeto de manter esses valores ou tenham valores extras, você pode dizer Git onde esse arquivo é com a configuração `` core.excludesfile. Basta configurá-lo para o caminho de um arquivo que tem conteúdo semelhante ao que um arquivo `. Gitignore` teria.

# # # # Help.autocorrect # # # #

Esta opção está disponível apenas no Git 1.6.1 e posterior. Se você digitar um comando em Git 1.6, mostra-lhe algo como isto:

$ Git com
git: 'com' não é um comando git. Veja 'git - help'.

Você quis dizer isso?
cometer

Se você definir `help.autocorrect` a 1, Git automaticamente executar o comando, se tiver apenas uma partida neste cenário.

Cores # # # no Git # # #

Git pode colorir a sua saída para o terminal, que pode ajudá-lo visualmente analisar a saída rápida e facilmente. Um número de opções pode ajudar a definir a cor de sua preferência.

# # # # Color.ui # # # #

Git automaticamente a maioria de cores de sua saída, se você pedir para ele. Você pode obter muito específico sobre o que você quer e como cor, mas de ligar todos coloração terminal do padrão, definido `color.ui` a verdade:

$ Git config - global color.ui verdade

Quando esse valor é definido, Git cores a saída se a saída vai para um terminal. Outras configurações possíveis são falsas, que nunca as cores da saída, e sempre, que define as cores o tempo todo, mesmo se você está redirecionando comandos do Git para um arquivo ou tubulação-los para outro comando. Esta configuração foi adicionado na versão 1.5.5 Git, se você tem uma versão mais antiga, você terá que especificar todas as configurações de cores individualmente.

Você raramente vai querer `color.ui = sempre`. Na maioria dos cenários, se você quer códigos de cores em sua saída redirecionada, você pode passar uma vez `- cor da bandeira` para o comando Git para forçá-lo a usar códigos de cores. O `color.ui = ajuste` verdade é quase sempre o que você vai querer usar.

# # # # `Cor. *` # # # #

Se você quiser ser mais específico sobre quais comandos são coloridas e como, ou você tem uma versão mais antiga, Git oferece configurações específicas verbo colorir. Cada um destes pode ser ajustado para `verdade`, `` falsos, ou `sempre`:

color.branch
color.diff
color.interactive
color.status

Além disso, cada uma delas tem subsettings você pode usar para definir cores específicas para partes da saída, se você quiser substituir cada cor. Por exemplo, para definir a meta informação na sua saída do diff para primeiro plano azul, fundo preto e texto em negrito, você pode executar

$ Git config - global color.diff.meta "azul negrito"

Você pode definir a cor a qualquer um dos seguintes valores: normal, preto, vermelho, verde, amarelo, magenta, azul, ciano, ou branco. Se você quer um atributo como negrito no exemplo anterior, você pode escolher de negrito, dim, ul, blink, e reverter.

Veja o `git config manpage` para todos os subsettings você pode configurar, se você quiser fazer isso.

# # # Mesclar externa e Ferramentas Diff # # #

Embora Git tem uma implementação interna do diff, que é o que você está usando, você pode configurar uma ferramenta externa vez. Você também pode configurar uma ferramenta gráfica fusão de resolução de conflitos, em vez de ter de resolver conflitos manualmente. Vou demonstrar a configuração do Perforce Visual ferramenta Merge (P4Merge) para fazer suas diffs e mesclar resoluções, porque é uma boa ferramenta gráfica e é grátis.

Se você quiser experimentar, P4Merge funciona em todas as principais plataformas, então você deve ser capaz de fazê-lo. Vou usar nomes de caminho nos exemplos que funcionam em sistemas Mac e Linux, para Windows, você vai ter que mudar `/ usr / local / bin` a um caminho executável em seu ambiente.

Você pode baixar P4Merge aqui:

http://www.perforce.com/perforce/downloads/component.html

Para começar, você vai configurar os scripts de invólucro externo para executar seus comandos. Vou usar o caminho para o executável Mac, em outros sistemas, que será onde o seu binário p4merge `está instalado. Configure um script fusão chamado `` extMerge que chama seu binário com todos os argumentos, desde que:

$ Cat / usr / local / bin / extMerge
#! / Bin / sh
/ Applications/p4merge.app/Contents/MacOS/p4merge $ *

O invólucro dif verifica se sete argumentos são fornecidos e passa dois deles para o seu script de mesclagem. Por padrão, o Git passa os seguintes argumentos para o programa diff:

caminho do arquivo velho-velho-velho-hex novo modo de arquivo nova-hex modo novo

Porque você só quer que o arquivo `velho` e `novo arquivo` argumentos, você pode usar o script wrapper para passar o que você precisa.

$ Cat / usr / local / bin / extdiff
#! / Bin / sh
[$ #-Eq 7] && / usr / local / bin / extMerge "$ 2" "$ 5"

Você também precisa ter certeza de que essas ferramentas são executável:

$ Sudo chmod + x / usr / local / bin / extMerge
$ Sudo chmod + x / usr / local / bin / extdiff

Agora você pode configurar o arquivo de configuração para usar o seu costume mesclar resolução e ferramentas de comparação. Isso leva um número de configurações personalizadas:. `. Merge.tool` para dizer Git qual a estratégia a utilizar, `mergetool * cmd` para especificar como executar o comando, `` mergetool.trustExitCode dizer Git se o código de saída do programa indica uma resolução de fusão de sucesso ou não, e `` diff.external dizer Git o comando a ser executado para diffs. Assim, você pode executar quatro comandos de configuração

$ Git config - global merge.tool extMerge
$ Git config - mergetool.extMerge.cmd global \
'ExtMerge "BASE $" "$ LOCAL" "$" "remoto $ INCORPORADO"'
$ Git config - mergetool.trustExitCode mundial falsa
$ Git config - extdiff diff.external mundial

ou você pode editar o seu `~ gitconfig / arquivo` para adicionar estas linhas.:

[Fusão]
ferramenta = extMerge
[Mergetool "extMerge"]
cmd = "BASE $" extMerge "$ LOCAL" "$" "remoto $ Incorporada"
trustExitCode = false
[Diff]
externa = extdiff

Depois de tudo isso é definido, se você executar comandos diff como este:

$ Git diff 32d1776b1 ^ 32d1776b1

Em vez de começar a saída do diff na linha de comando, Git incêndios se P4Merge, que é algo como a Figura 7-1.

Insira 18333fig0701.png
Figura 7-1. P4Merge

Se você tentar mesclar os dois ramos e, posteriormente, ter conflitos de mesclagem, você pode executar o comando git `mergetool`, que começa P4Merge para deixá-lo resolver os conflitos através de que ferramenta GUI.

A coisa agradável sobre esta configuração invólucro é que você pode mudar o seu diff e ferramentas de mesclagem facilmente. Por exemplo, para mudar o seu `extdiff` e `` extMerge ferramentas para executar a ferramenta KDiff3 em vez disso, tudo que você tem a fazer é editar seu arquivo `extMerge:

$ Cat / usr / local / bin / extMerge
#! / Bin / sh
/ Applications/kdiff3.app/Contents/MacOS/kdiff3 $ *

Agora, Git irá utilizar a ferramenta para diff KDiff3 visualização e mesclar resolução de conflitos.

Git vem pré-configurado para usar uma série de outras ferramentas de resolução de fusão sem ter que definir a configuração do cmd. Você pode definir a sua ferramenta de mesclagem para kdiff3, opendiff, tkdiff, fundir, xxdiff, emergem, vimdiff, ou gvimdiff. Se você não estiver interessado em usar o KDiff3 para dif mas quer usá-lo apenas para a resolução de fusão, eo comando kdiff3 está no seu caminho, então você pode executar

$ Git config - global merge.tool kdiff3

Se você executar este ao invés de configurar o extMerge `e` `extdiff arquivos, Git irá usar o KDiff3 para mesclar resolução ea normal Git ferramenta de comparação de diffs.

Formatação # # # e # # # Whitespace

Formatação e problemas de espaço em branco são alguns dos problemas mais frustrantes e sutil que muitos desenvolvedores encontrar ao colaborar, especialmente multi-plataforma. É muito fácil para correções ou trabalho colaborou para introduzir outras mudanças sutis espaços em branco porque os editores de apresentá-los silenciosamente ou programadores do Windows adicionar retornos de carro no final de linhas que toque em multi-plataforma projetos. Git tem algumas opções de configuração para ajudar com estas questões.

# # # # Core.autocrlf # # # #

Se você está programando no Windows ou outro sistema, mas trabalhar com as pessoas que estão de programação em Windows, você provavelmente vai correr em fim de linha problemas em algum ponto. Isso porque o Windows usa tanto o caráter de um retorno de carro e um carácter de mudança de linha para novas linhas em seus arquivos, enquanto os sistemas Mac e Linux usar apenas o caráter de avanço de linha. Este é um fato sutil, mas extremamente irritante de multi-plataforma de trabalho.

Git pode lidar com isso por auto-converter finais de linha CRLF para LF quando você comete, e vice-versa, quando se verifica código em seu sistema de arquivos. Você pode ativar esta funcionalidade com o `core.autocrlf configuração`. Se você estiver em uma máquina Windows, defina-o `verdadeiro` - este converte terminações LF em CRLF quando você verificar código:

$ Git config - global core.autocrlf verdade

Se você estiver em um sistema Linux ou Mac que usa os finais de linha LF, então você não quer Git automaticamente convertê-los quando você check-out dos arquivos, no entanto, se um arquivo com terminações CRLF acidentalmente fica introduzida, então você pode querer Git corrigi-lo. Você pode dizer Git para converter CRLF para LF no commit, mas não o contrário definindo `core.autocrlf` para entrada:

$ Git config - entrada core.autocrlf mundial

Esta configuração deve deixá-lo com terminações CRLF em Windows, mas checkouts terminações LF em sistemas Mac e Linux e no repositório.

Se você é um programador Windows fazendo um projeto somente para Windows, então você pode desativar essa funcionalidade, registrando os retornos de carro no repositório, definindo o valor de configuração para `falsos:

$ Git config - global core.autocrlf falsa

# # # # Core.whitespace # # # #

Git vem pré-configurado para detectar e corrigir alguns problemas de espaço em branco. Ele pode olhar para quatro questões principais espaços em branco - duas são ativadas por padrão e pode ser desligado, e dois não são ativadas por padrão, mas pode ser ativado.

Os dois que são ativadas por padrão são `espaços extras`, que olha para os espaços no final de uma linha, e `espaço-antes-aba`, que olha para os espaços antes de guias no início de uma linha.

Os dois que estão desativados por padrão, mas pode ser ligado são `travessão-com-guia não`, que olha para as linhas que começam com oito ou mais espaços em vez de tabulações, e `cr-at-eol`, que diz Git retornos que de carro no final das linhas estão OK.

Você pode dizer Git qual destes você quer habilitado pela definição de `core.whitespace` para os valores que deseja on ou off, separados por vírgulas. Você pode desabilitar as configurações, quer deixando-os para fora da corda definir ou prepending um `-` na frente do valor. Por exemplo, se você quer tudo, mas `cr-at-eol` a ser definida, você pode fazer isso:

$ Git config - core.whitespace global \
de espaços extras, espaço antes de guia, travessão-com-não-guia

Git irá detectar esses problemas ao executar um `comando git diff` e tentar colori-los de modo que você pode, eventualmente, corrigi-los antes de se comprometer. Ele também irá usar esses valores para ajudar quando você aplicar patches com `git aplicar`. Quando você estiver aplicando patches, você pode pedir Git para avisá-lo se está a aplicar os patches com as questões específicas de espaço em branco:

$ Git aplicar - espaço em branco = warn <patch>

Ou você pode ter Git tenta corrigir automaticamente o problema antes de aplicar o patch:

$ Git aplicar - espaço em branco correção = <patch>

Essas opções se aplicam à opção rebase git também. Se você cometeu questões de espaço em branco, mas ainda não empurrou a montante, você pode executar um rebase `com a` - espaço em branco = corrigir opção `ter Git automaticamente corrigir problemas de espaço em branco, como é reescrever os patches.

# # Server Configuration # # # #

Não é tão muitas opções de configuração estão disponíveis para o lado do servidor Git, mas há alguns poucos interessantes que você pode querer tomar nota.

# # # # Receive.fsckObjects # # # #

Por padrão, o Git não verificar a consistência de todos os objetos que ela recebe durante um empurrão. Embora Git pode certifique-se de cada objeto ainda corresponde a SHA-1 e soma pontos para objetos válidos, ele não faz isso por padrão em cada empurrão. Esta é uma operação relativamente cara e pode adicionar uma grande quantidade de tempo para cada impulso, de acordo com o tamanho do depósito ou da pressão. Se você quiser Git para verificar a consistência objeto em cada envio, você pode forçá-lo a fazê-lo definindo `receive.fsckObjects` a verdade:

$ Git config - receive.fsckObjects verdadeiro sistema

Agora, Git irá verificar a integridade do seu repositório antes de cada impulso é aceito para garantir que os clientes não são defeituosos introduzir dados corrompidos.

# # # # Receive.denyNonFastForwards # # # #

Se você comete rebase que você já empurrou e então tentar empurrar de novo, ou tentar empurrar um commit para uma filial remota que não contenha a confirmação de que a filial remota atualmente aponta, você vai ser negado. Isso geralmente é uma boa política, mas, no caso do rebase, você pode determinar que você saiba o que está fazendo e pode forçar-atualizar a filial remota com um `-f` para o seu comando impulso.

Para desativar a capacidade de forçar-update filiais remotas de não-fast-forward referências, definir `receive.denyNonFastForwards`:

$ Git config - receive.denyNonFastForwards verdadeiro sistema

A outra maneira que você pode fazer isso é através do lado do servidor receber ganchos, que eu vou cobrir um pouco. Essa abordagem permite que você faça as coisas mais complexas como negar não-rápido para a frente para um determinado subconjunto de usuários.

Receive.denyDeletes # # # # # # # #

Uma das soluções para o `` denyNonFastForwards política é para o usuário excluir o ramo e depois empurrá-lo de volta com a nova referência. Nas versões mais recentes do Git (a partir da versão 1.6.1), você pode definir `` receive.denyDeletes para true:

$ Git config - receive.denyDeletes verdadeiro sistema

Isto nega ramo e exclusão tag em um impulso em toda a linha - nenhum usuário pode fazê-lo. Para remover filiais remotas, você deve remover os arquivos ref do servidor manualmente. Existem também as formas mais interessantes para fazer isso em uma base por usuário através de ACLs, como você vai aprender no final deste capítulo.

# # # # Git Atributos

Algumas dessas configurações também pode ser especificado para um caminho, de modo que Git aplica essas configurações só para um subdiretório ou subconjunto de arquivos. Essas configurações caminho específicas são chamados atributos Git e são definidas tanto em um `. Gitattribute arquivo` em um de seus diretórios (normalmente a raiz de seu projeto) ou no .git `/ info / atributos arquivo` se você não deseja que o arquivo atributos comprometido com o seu projeto.

Usando atributos, você pode fazer coisas como especificar separado unir estratégias para arquivos individuais ou pastas no seu projeto, dizer Git como diff arquivos não-textos, ou tem o git filtro de conteúdo antes de verificá-lo para dentro ou fora do Git. Nesta seção, você vai aprender sobre alguns dos atributos que podem ser configuradas em seus caminhos em seu projeto Git e ver alguns exemplos de usar esse recurso em prática.

Arquivos # # # # # # binários

Um truque legal para o qual você pode usar atributos Git Git está dizendo que os arquivos são binários (em casos que de outra forma não pode ser capaz de descobrir) e dando Git instruções especiais sobre como lidar com esses arquivos. Por exemplo, alguns arquivos de texto pode ser gerada máquina e não diffable, enquanto alguns arquivos binários podem ser diffed - você verá como dizer Git qual é qual.

# # # # Identificação de arquivos binários # # # #

Alguns arquivos olhar como arquivos de texto, mas para todos os efeitos estão a ser tratados como dados binários. Por exemplo, os projetos Xcode no Mac contém um arquivo que termina em `. Pbxproj`, que é basicamente um conjunto de dados de JSON (JavaScript texto simples formato de dados), escrito para o disco do IDE que registra as configurações de construção e assim por diante. Embora seja tecnicamente um arquivo de texto, porque é tudo ASCII, você não quer tratá-lo como tal, porque é realmente um banco de dados leve - você não pode mesclar o conteúdo, se duas pessoas mudou, e diffs geralmente não são úteis. O ficheiro é para ser consumida por uma máquina. Em essência, você quer tratá-lo como um arquivo binário.

Para dizer Git para tratar todos pbxproj `arquivos como dados binários, adicione a seguinte linha ao seu arquivo` gitattributes `.:

*. Pbxproj-crlf-dif

Agora, Git não vai tentar converter ou corrigir problemas CRLF; nem vai tentar calcular ou imprimir um diff para mudanças nesse arquivo quando você executar git mostrar ou git diff em seu projeto. Na série 1.6 do Git, você também pode usar uma macro que está desde que significa `-crlf-dif`:

* Binário. Pbxproj

# # # # Diffing arquivos binários # # # #

Na série 1.6 do Git, você pode usar o Git funcionalidade atributos para efetivamente arquivos binários diff. Você faz isso dizendo Git como converter os dados binários em um formato de texto que pode ser comparado através do diff normal.

Porque este é um recurso muito legal e não muito conhecida, eu vou passar por cima de alguns exemplos. Primeiro, você vai usar esta técnica para resolver um dos problemas mais irritantes conhecidos pela humanidade: a versão controladores documentos do Word. Todo mundo sabe que o Word é o editor mais horrível em torno, mas, estranhamente, todo mundo usa-lo. Se você quer documentos de controle de versão do Word, você pode colocá-los em um repositório Git e comprometer de vez em quando, mas que bom que isso faz? Se você executar `git diff` normalmente, você só vê algo como isto:

$ Git diff
diff - git a/chapter1.doc b/chapter1.doc
índice 88839c4 .. 4afcb7c 100644
Arquivos binários a/chapter1.doc e b/chapter1.doc diferem

Você não pode comparar diretamente duas versões, a menos que você vê-los e verificá-los manualmente, certo? Acontece que você pode fazer isso muito bem usando atributos Git. Coloque a seguinte linha no arquivo de seu `gitattributes`.:

*. Doc diff = palavra

Isto diz Git que qualquer arquivo que corresponde a esse padrão (. Doc) deve usar a "palavra" filtro quando você tenta ver um diff que contém alterações. O que é a "palavra" filtro? Você tem que configurá-lo. Aqui você vai configurar o Git para usar o programa `as cordas para converter documentos do Word em arquivos de texto legível, o que será então dif corretamente:

$ Git cordas configuração diff.word.textconv

Agora Git sabe que se tenta fazer uma comparação entre os dois instantâneos, e qualquer um dos arquivos terminam em `. Doc`, ele deve executar esses arquivos através da "palavra" do filtro, que é definido como programa as cordas `. Isso efetivamente torna agradáveis ​​texto-base versões de arquivos do Word antes de tentar dif-los.

Aqui está um exemplo. Eu coloquei um capítulo deste livro em Git, acrescentou algum texto a um parágrafo, e salvou o documento. Então, eu corri `git diff` para ver o que mudou:

$ Git diff
diff - git a/chapter1.doc b/chapter1.doc
índice c1c8a0a .. b93c9e4 100644
--- A/chapter1.doc
+ + + B/chapter1.doc
@ @ -8,7 +8,8 @ @ Re vai cobrir Sistemas de controle de versão (VCS) e os princípios do Git
está indo para cobrir a forma de obtê-lo e configurá-lo pela primeira vez, se você não
t já tê-lo em seu sistema.
No capítulo dois, vamos repassar o uso Git básica - como usar Git para os 80%
-S acontecendo, modificar coisas e contribuir alterações. Se o livro espontaneamente
+ Está acontecendo, modificar as coisas e contribuir alterações. Se o livro espontaneamente
+ Vamos ver se isso funciona.

Git com sucesso e de forma sucinta me diz que eu adicionei a string "Vamos ver se isso funciona", o que é correto. Não é perfeito - ele acrescenta um monte de coisas aleatórias no final - mas certamente funciona. Se você pode encontrar ou escrever um conversor de Word em texto simples que funciona bem o suficiente, que a solução provavelmente será incrivelmente eficaz. No entanto, 'cordas' está disponível na maioria dos sistemas Mac e Linux, por isso pode ser um bom primeiro tente fazer isso com muitos formatos binários.

Outro problema interessante que você pode resolver este caminho envolve os arquivos de imagem diffing. Uma maneira de fazer isso é executar ficheiros JPEG através de um filtro que extrai suas informações EXIF ​​- metadados que é gravado com a maioria dos formatos de imagem. Se você baixar e instalar o programa `exiftool`, você pode usá-lo para converter suas imagens em texto sobre os metadados, assim pelo menos o diff vai mostrar uma representação textual de todas as mudanças que aconteceram:

$ Echo '*. Png diff = exif' >>. Gitattributes
$ Git config diff.exif.textconv exiftool

Se você substituir uma imagem em seu projeto e executar o `git diff`, você ver algo como isto:

diff - git a / image.png b / image.png
índice 88839c4 .. 4afcb7c 100644
--- Um image.png /
+ + + B / image.png
@ @ -1,12 +1,12 @ @
ExifTool Número da versão: 7,74
-Tamanho do Arquivo: 70 kB
-Data de Modificação do arquivo / Hora: 2009:04:21 07:02:45 - 07:00
+ Tamanho: 94 kB
+ Data de modificação do arquivo / Hora: 2009:04:21 07:02:43 - 7:00
Tipo de arquivo: PNG
Tipo MIME: image / png
-Imagem Largura: 1058
-Imagem Altura: 889
+ Largura de imagem: 1056
+ Altura da Imagem: 827
Profundidade de bits: 8
Tipo de cor: RGB com Alpha

Você pode facilmente ver que o tamanho do arquivo e as dimensões da imagem sofreram alterações.

# # Expansão palavra-chave # # # #

SVN ou CVS-estilo expansão palavra-chave é frequentemente solicitado pelos desenvolvedores utilizadas para esses sistemas. O principal problema com este no Git é que você não pode modificar um arquivo com informações sobre o commit depois que você cometeu, porque Git checksums o primeiro arquivo. No entanto, você pode injetar em um arquivo de texto quando é verificado e removê-lo novamente antes de ser adicionado a um commit. Atributos Git oferece duas maneiras de fazer isso.

Primeiro, você pode injetar o SHA-1 checksum de uma bolha em um campo `$ Id $` no arquivo automaticamente. Se você definir esse atributo em um arquivo ou conjunto de arquivos, então da próxima vez que você verificar que o Git ramo, irá substituir o campo com o SHA-1 do blob. É importante notar que não é o SHA do commit, mas do blob em si:

>> $ Echo '*. Txt ident ". Gitattributes
$ Echo '$ Id $'> teste.txt

A próxima vez que você verifique esse arquivo, Git injeta o SHA do blob:

Text.txt $ rm
$ Git checkout - text.txt
$ Test.txt gato
$ Id: 42812b7653c7b88933f8a9d6cad0ca16714b9bb3 $

No entanto, este resultado é de uso limitado. Se você já usou a substituição da palavra em CVS ou Subversion, você pode incluir uma datestamp - o SHA não é tudo o que útil, porque é bastante aleatória e você não pode dizer se uma SHA é mais velho ou mais novo que o outro.

Acontece que você pode escrever seus próprios filtros para fazer substituições em arquivos no commit / checkout. Estes são os "limpos" e "manchas" filtros. No arquivo `. Gitattributes`, você pode definir um filtro para determinados caminhos e configurar os scripts que irá processar os arquivos antes que eles estão comprometidos ("limpo", ver Figura 7-2) e pouco antes de eles check-out ("mancha", veja a Figura 7-3). Estes filtros podem ser configurados para fazer todo tipo de coisas divertidas.

Insira 18333fig0702.png
Figura 7-2. A "mancha" filtro é executado no checkout.

Insira 18333fig0703.png
Figura 7-3. O filtro "limpa" é executado quando os arquivos são encenados.

A mensagem original commit para esta funcionalidade dá um exemplo simples de executar todo o seu código fonte C através do programa `` travessão antes de cometer. Você pode configurá-lo, definindo o atributo de filtro no arquivo `seu` gitattributes para filtrar `* C` arquivos com o "travessão". Filtro.:

*. C filter = travessão

Então, diga o que o Git "travessão" "filtro faz em manchas e limpa:

$ Git config - filter.indent.clean mundial travessão
$ Git config - gato filter.indent.smudge mundial

Neste caso, quando você comete os arquivos que correspondem `*. C`, Git irá executá-los através do programa travessão antes comete-los e depois executá-los através do programa `` cat antes de verificar-los de volta para o disco. O `gato` programa é basicamente um não-op: ele cospe os mesmos dados que ele recebe dentro Esta combinação efetivamente filtra todos os arquivos de código fonte C através do `` travessão antes de cometer.

Outro exemplo interessante fica `$ $ Date` expansão palavra-chave, estilo RCS. Para fazer isso corretamente, você precisa de um pequeno script que leva um nome de arquivo, descobre a última data de confirmação para este projeto, e insere a data para o arquivo. Aqui é um pequeno script Ruby que faz isso:

#! / Usr / bin / env ruby
dados = STDIN.read
last_date = git log `- = formato bastante:" ad% "-1`
coloca data.gsub ('$ $ Data', '$ Data:' + last_date.to_s + '$')

Tudo o script faz é obter a última data de confirmação do comando git log `, pau que em qualquer` Data `$ $ cordas que vê no stdin, e imprimir os resultados - que deve ser simples para fazer em qualquer linguagem que você está mais confortável dentro Você pode nomear este arquivo `expand_date` e colocá-lo em seu caminho. Agora, você precisa configurar um filtro no Git (chamemos-lhe `dater`) e dizer-lhe para usar o seu `` expand_date filtro para sujar os arquivos no checkout. Você vai usar uma expressão Perl para limpar isso no commit:

$ Git config filter.dater.smudge expand_date
$ Git config filter.dater.clean 'perl-pe "s / \ \ Data \ $ [^ \ \ \ $] * \ \ \ $ / \ \ \ Data $ \ \ \ $ /"'

Este tiras trecho Perl fora qualquer coisa que vê em um `Data` $ $ string, para voltar para onde você começou. Agora que o seu filtro está pronto, você pode testá-lo através da criação de um arquivo com o seu `Data $ keyword $` e então a criação de um atributo de Git para esse arquivo que envolve o novo filtro:

$ Echo '# $ $ Date'> date_test.txt
$ Echo 'data *. Txt filter = dater' >>. Gitattributes

Se você confirmar as alterações e confira o arquivo novamente, você vê a palavra-chave corretamente substituído:

$ Git add date_test.txt. Gitattributes
$ Git commit-m "expansão Teste data em Git"
Date_test.txt $ rm
$ Git checkout date_test.txt
$ Date_test.txt gato
# $ Date: ter 21 abr 2009 07:26:52 -0700 $

Você pode ver o quão poderoso pode ser uma técnica para aplicações customizadas. Você tem que ter cuidado, porém, porque o arquivo `` gitattributes está comprometida e passou ao redor com o projeto, mas o condutor (neste caso, `dater`) não é;. Assim, ele não vai funcionar em todos os lugares. Ao projetar esses filtros, eles devem ser capazes de falhar normalmente e tem o projeto ainda funcionam corretamente.

# # # Exportando seu Repositório # # #

Git dados de atributo também permite que você faça algumas coisas interessantes ao exportar um arquivo do seu projeto.

# # # # Export-ignore # # # #

Você pode dizer Git não exportar determinados arquivos ou diretórios ao gerar um arquivo. Se existe uma subpasta ou arquivo que você não deseja incluir em seu arquivo, mas que você quer verificado em seu projeto, você pode determinar os arquivos através do `exportação ignorar atributo`.

Por exemplo, digamos que você tem alguns arquivos de teste em um teste `/` subdiretório, e isso não faz sentido incluí-los na exportação tarball do seu projeto. Você pode adicionar a seguinte linha ao seu arquivo atributos Git:

testar / exportar-ignore

Agora, quando você executar arquivo git para criar um arquivo tar do seu projeto, o diretório não serão incluídos no arquivo.

# # # # Exportação subst-# # # #

Outra coisa que você pode fazer para seus arquivos é uma substituição da palavra simples. Git permite colocar a corda Formato `$: $` em qualquer arquivo com qualquer um dos `- pretty = formato shortcodes` formatação, muitos dos quais você viu no Capítulo 2. Por exemplo, se você quiser incluir um arquivo chamado `LAST_COMMIT` em seu projeto, ea última data commit foi injetado automaticamente quando arquivo `git 'correu, você pode configurar o arquivo como este:

$ Echo 'data Última commit: $ Formato: CD% $'> LAST_COMMIT
$ Echo "LAST_COMMIT exportação subst". >> Gitattributes
$ Git add LAST_COMMIT. Gitattributes
$ Git 'arquivo LAST_COMMIT adição de arquivos' commit-am

Quando você executar `git arquivo`, o conteúdo do arquivo que quando as pessoas abrem o arquivo será parecido com este:

$ Cat LAST_COMMIT
Data de última confirmação: Formato $: ter 21 abr 2009 08:38:48 -0700 $

# # # Mesclar Estratégias # # #

Você também pode usar atributos Git para dizer Git para utilizar estratégias diferentes para mesclar arquivos específicos em seu projeto. Uma opção muito útil é para dizer Git para não tentar mesclar arquivos específicos quando eles têm conflitos, mas sim para usar o seu lado da fusão sobre outra pessoa.

Isso é útil se um ramo em seu projeto divergiu ou é especializada, mas você quer ser capaz de mesclar alterações de volta a partir dele, e você deseja ignorar determinados arquivos. Digamos que você tenha um banco de dados arquivo de configurações chamado database.xml que é diferente em dois ramos, e você deseja mesclar em seu outro ramo sem bagunçar o arquivo de banco de dados. Você pode configurar um atributo como esta:

database.xml merge = nossa

Se você mesclar em outro ramo, em vez de ter conflitos de mesclagem com o arquivo database.xml, você vê algo como isto:

$ Git merge tópico
Auto-fusão database.xml
Mesclar feita por recursiva.

Neste caso, database.xml fica em qualquer versão que você tinha originalmente.

# # # # Git Ganchos

Como muitos outros sistemas de controle de versão, Git tem uma maneira para disparar scripts personalizados quando certas ações importantes ocorrer. Existem dois grupos de esses ganchos laterais: cliente e servidor. Os ganchos do lado do cliente são para operações do cliente, tais como cometer e fusão. Os ganchos do lado do servidor são para operações de servidor, como Git receber empurrado comete. Você pode usar estes ganchos para todos os tipos de razões, e você vai aprender sobre alguns deles aqui.

# # # A instalação de um gancho # # #

Os ganchos são todos armazenados no `` ganchos subdiretório do diretório Git. Na maioria dos projetos, que é o `.git / ganchos`. Por padrão, o Git preenche este diretório com um monte de scripts de exemplo, muitas das quais são úteis por si só, mas eles também documentar os valores de entrada de cada script. Todos os exemplos são escritos como shell scripts, com um pouco de Perl jogadas, mas todos os scripts executáveis ​​devidamente nomeados irá funcionar bem - você pode escrevê-los em Ruby ou Python ou o que você quiser. Para a pós-1,6 versões do Git, esses arquivos gancho exemplo acabar com a amostra;. Você precisa renomeá-los. Para pré-1,6 versões do Git, os arquivos de exemplo são nomeados corretamente, mas não são executáveis.

Para ativar um script de gancho, coloque um arquivo no ganchos `subdiretório do seu diretório Git que é nomeado de forma adequada e é executável. A partir desse ponto, ele deve ser chamado. Eu vou cobrir a maior parte dos nomes dos arquivos de gancho importantes aqui.

# # # Do lado do cliente Ganchos # # #

Há um monte de ganchos do lado do cliente. Esta seção divide em cometer fluxo de trabalho-ganchos, e-mail de fluxo de trabalho, scripts, e do resto dos scripts do lado do cliente.

# # # # Comprometendo-Fluxo de Trabalho Ganchos # # # #

Os primeiros quatro ganchos têm a ver com o processo de cometer. O `pré-commit gancho` é executado primeiro, antes mesmo de digitar uma mensagem de confirmação. É usado para inspecionar o instantâneo que está prestes a ser cometido, para ver se você se esqueceu de alguma coisa, para fazer testes certeza correr, ou para analisar o que você precisa para inspecionar o código. Saindo de zero a partir deste gancho aborta o commit, mas você pode ignorá-lo com `git commit - sem verificar`. Você pode fazer coisas como cheque de estilo de código (executar lint ou algo equivalente), para verificar o espaço em branco (o gancho padrão faz exatamente isso), ou verificar a documentação apropriada sobre novos métodos.

O `prepare-commit-msg gancho` é executado antes do editor de mensagem de confirmação é despediu-se, mas depois que a mensagem padrão é criado. Ele permite que você editar a mensagem padrão antes de cometer o autor vê. Este gancho tem algumas opções: o caminho para o arquivo que contém a mensagem de confirmação, até agora, o tipo de submissão, ea confirmação SHA-1 se este é um commit alterada. Este gancho geralmente não é útil para o normal comete, mas sim, é bom para cometer onde a mensagem padrão é auto-gerado, tal como templated mensagens de commit, merge comete, esmagado comete, e alterado comete. Você pode usá-lo em conjunto com um modelo de consolidação para programaticamente inserir informações.

O `commit-msg gancho` tem um parâmetro, que novamente é o caminho para um arquivo temporário que contém a mensagem atual de submissão. Se este script sai de zero Git, aborta o processo de consolidação, de modo que você pode usá-lo para validar o seu estado de projeto ou cometer mensagem antes de permitir que um compromisso de passar. Na última seção deste capítulo, vou demonstrar usando este gancho para verificar se a sua mensagem de confirmação está em conformidade com um padrão desejado.

Depois de todo o processo de confirmação é concluída, o `post-commit gancho` executado. Não é preciso ser nenhum parâmetro, mas você pode facilmente obter o último commit executando `git log -1 CABEÇA`. Geralmente, esse script é usado para notificação ou algo similar.

Os comprometendo-fluxo de trabalho do lado do cliente scripts podem ser usados ​​em praticamente qualquer fluxo de trabalho. Eles são muitas vezes utilizados para reforçar as políticas certas, embora seja importante notar que estes scripts não são transferidos durante um clone. Você pode aplicar a política do lado do servidor para rejeitar empurra de submissões que não correspondam a alguma política, mas é inteiramente até o desenvolvedor usar esses scripts no lado do cliente. Portanto, estes são os scripts para ajudar os desenvolvedores, e eles devem ser criados e mantidos por eles, embora eles podem ser substituídos ou modificados por eles a qualquer momento.

# # # # E-mail de fluxo de trabalho Ganchos # # # #

Você pode configurar três do lado do cliente ganchos para um fluxo de trabalho de e-mail baseado. Eles estão todos invocado pelo git `am` comando, por isso, se você não está usando o comando em seu fluxo de trabalho, você pode pular para a próxima seção. Se você está tomando os patches por e-mail preparado por `git formato-patch`, em seguida, alguns deles podem ser úteis para você.

O primeiro gancho que é executado é `applypatch msg`. É preciso um único argumento: o nome do arquivo temporário que contém a mensagem de proposta de consolidação. Git aborta o patch se este script sai diferente de zero. Você pode usar isso para se certificar de uma mensagem de confirmação está formatado corretamente ou para normalizar a mensagem por ter o script editá-lo no lugar.

O gancho próximo a ser executado quando aplicação de patches via `git sou 'é' pré-applypatch`. Ele não tem argumentos e é executado após o patch for aplicado, para que você possa usá-lo para inspecionar o instantâneo antes de fazer a confirmação. Você pode executar testes ou inspecionar a árvore de trabalho com esse script. Se algo está faltando ou os testes não passam, saindo de zero também aborta o git `am` script sem cometer o patch.

O último gancho para ser executado durante um git `am` operação é `pós-applypatch`. Você pode usá-lo para notificar um grupo ou o autor do patch que você tirou em que você já fez. Você não pode parar o processo de correção com esse script.

# # # # Cliente Outros Ganchos # # # #

O `pré-rebase gancho` é executado antes de rebase nada e pode interromper o processo por sair diferente de zero. Você pode usar esse gancho para não permitir rebasing nenhum commit que já foi pressionado. O exemplo `pré-rebase gancho 'que instala Git faz isso, embora ele assume que o próximo é o nome do ramo que publicar. É provável que você precisa mudar para que o que quer que seu estábulo, ramo é publicado.

Depois de executar um git `sucesso` check-out, o gancho `pós-check-out` é executado, você pode usá-lo para configurar o diretório de trabalho adequadamente para o seu ambiente de projeto. Isso pode significar mover em arquivos binários grandes que você não quer fonte controlada, documentação auto-gerador, ou algo nesse sentido.

Finalmente, o `pós-fusão gancho` corre atrás de uma fusão de sucesso `comando`. Você pode usá-lo para restaurar dados na árvore de trabalho que o GIT não pode controlar, como dados de permissões. Este gancho pode igualmente validar a presença de arquivos externos para Git controle que você pode querer copiado de quando as mudanças de árvore de trabalho.

# # # Server-Side Ganchos # # #

Além dos ganchos do lado do cliente, você pode usar um par de importantes do lado do servidor ganchos como administrador do sistema para aplicar quase qualquer tipo de política para o seu projeto. Esses scripts são executados antes e depois empurra para o servidor. Os ganchos pré pode sair diferente de zero em qualquer momento para rejeitar a pressão, assim como imprimir uma mensagem de erro para o cliente, você pode configurar uma política de pressão que é tão complexo como você deseja.

# # # # Receber pré-e pós-receber # # # #

O primeiro script para ser executado ao manusear um empurrão de um cliente é `pré-recebem`. É preciso uma lista de referências que estão sendo expulsos de stdin, se ele sai de zero, nenhum deles são aceitos. Você pode usar esse gancho para fazer coisas como verificar se nenhuma das referências atualizadas são não-fast-forwards, ou para verificar se o usuário está fazendo o empurrando tem criar, apagar, ou empurrar o acesso ou o acesso ao envio de atualizações para todos os arquivos que 're modificando com o empurrão.

O `pós-receber gancho` corre atrás de todo o processo é concluído e pode ser usado para atualizar outros serviços ou notificar os usuários. Leva os mesmos dados stdin como o `pré-receber gancho`. Exemplos incluem e-mails lista, a notificação de um servidor de integração contínua, ou atualização de um sistema de ticket-tracking - você pode até analisar as mensagens de confirmação para ver se todos os bilhetes precisam ser abertos, modificados ou fechado. Este script não pode parar o processo de envio, mas o cliente não desliga até que tenha concluído, por isso, ter cuidado quando você tentar fazer tudo o que pode levar um longo tempo.

# # # # Atualizar # # # #

O script de atualização é muito semelhante ao `pré-receber script`, exceto que ele é executado uma vez para cada ramo o traficante está tentando atualizar. Se o traficante está tentando empurrar para vários ramos, 'pré-receber `é executado apenas uma vez, enquanto atualização é executado uma vez por ramo que está empurrando a. Em vez de ler de stdin, este script tem três argumentos: o nome da referência (filial), o SHA-1, que apontou para referência antes do impulso, eo SHA-1 usuário está tentando empurrar. Se as saídas de script de atualização não-zero, apenas a referência que é rejeitado; outras referências ainda pode ser atualizado.

# # Um exemplo Git-Forçados Política # #

Nesta seção, você vai usar o que aprendeu para estabelecer um fluxo de trabalho Git que verifica um formato de mensagem personalizado commit, reforça fast-forward-only empurra, e permite que apenas alguns usuários para modificar determinados subdiretórios em um projeto. Você vai construir scripts de cliente que ajudam o desenvolvedor saber se seu impulso será rejeitado e servidor de scripts que, na verdade, fazer valer as políticas.

Eu usei Ruby para escrever estas, tanto porque é a minha linguagem de script preferida e porque eu sinto que é o mais pseudocódigo aparência das linguagens de script, assim você deve ser capaz de cerca de seguir o código, mesmo se você não usar Ruby. No entanto, qualquer linguagem vai funcionar bem. Todos os exemplos de scripts de gancho são distribuídos com Git em qualquer Perl ou script Bash, então você também pode ver a abundância de exemplos de ganchos nesses idiomas, olhando para as amostras.

# # # Gancho do lado do servidor # # #

Todo o trabalho do lado do servidor irá para o arquivo de atualização no seu diretório de ganchos. O arquivo de atualização é executado uma vez por ramo sendo empurrado e leva a referência a ser empurrada para a revisão antiga em que a sucursal foi, ea nova revisão sendo empurrado. Você também terá acesso para o usuário fazer o empurrando, se o impulso está sendo executado através de SSH. Se você permitiu que todos a se conectarem com um único usuário (como "git"), através de autenticação de chave pública, você pode ter que dar ao usuário um invólucro shell que determina qual o usuário está se conectando com base na chave pública, e definir um ambiente variável especificando o usuário. Aqui eu assumir o usuário de conexão está no `$ USER` variável de ambiente, para que o seu script de atualização começa por reunir todas as informações que você precisa:

#! / Usr / bin / env ruby

$ Refname = ARGV [0]
$ OLDREV = ARGV [1]
$ Newrev = argv [2]
$ User = ENV ['user']

coloca "Políticas Cumprimento ... \ n (# {$ refname}) (# {$ OLDREV [0,6]}) (# {$ newrev [0,6]})"

Sim, eu estou usando variáveis ​​globais. Não me julgue - é mais fácil para demonstrar desta maneira.

# # # # Impondo um formato Commit Message-específico # # # #

Seu primeiro desafio é reforçar que cada mensagem de confirmação deve aderir a um formato específico. Só para se ter uma meta, vamos supor que cada mensagem tem de incluir uma string que parece com "ref: 1234" porque você quer cada comprometer com um link para um item de trabalho no seu sistema de bilhética. Você deve olhar para cada commit sendo empurrada para cima, para ver se essa seqüência está na mensagem de confirmação, e, se a cadeia está ausente de qualquer um dos compromete, sair de zero para que o impulso é rejeitada.

Você pode obter uma lista dos valores SHA-1 de todos os commits que estão sendo expulsos, tendo o `$ newrev` e `$ OLDREV` valores e passá-los para um comando encanamento Git chamado `git rev-list`. Este é basicamente o `git log comando`, mas por padrão ela mostra apenas o SHA-1 valores e nenhuma outra informação. Assim, para obter uma lista de todos os SHAs commit introduzido entre um commit SHA e outra, você pode executar algo como isto:

$ Git rev-lista 538c33 .. d14fc7
d14fc7c847ab946ec39590d87783c69b031bdfb7
9f585da4401b0a3999e84113824d15245c13f0be
234071a1be950e2a8d078e6141f5cd20c1e61ad3
dfa04c9ef3d5197182f13fb5b9b1fb7717d2222a
17716ec0f1ff5c77eff40b7fe912f9f6cfd0e475

Você pode tomar essa saída, percorrer cada um dos SHAs commit, pegue a mensagem para ele, e testar a mensagem contra uma expressão regular que procura um padrão.

Você tem que descobrir como chegar a mensagem de confirmação de cada uma delas se compromete a testar. Para obter os dados brutos de commit, você pode usar um outro comando encanamento chamado `git cat arquivo`. Eu vou passar por cima de todos estes comandos de encanamento em detalhes no Capítulo 9, mas, por agora, aqui está o que lhe dá o comando:

$ Git cat arquivo-commit ca82a6
árvore cfda3bf379e4f8dba8717dee55aab78aef7f4daf
pai 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
autor Scott Chacon <schacon@gmail.com> 1205815931 -0700
committer Scott Chacon <schacon@gmail.com> 1240030591 -0700

alterou o número verison

Uma maneira simples de obter a mensagem de confirmação de um commit quando você tem o SHA-1 valor é para ir para a primeira linha em branco e tirar tudo depois. Você pode fazer isso com o `sed comando` em sistemas Unix:

$ Git cat arquivo-commit ca82a6 | sed '1, / ^ $ / d '
alterou o número verison

Você pode usar esse encantamento para pegar a mensagem de confirmação de cada commit que está tentando ser empurrado e sair se você vê algo que não corresponde. Para sair do script e rejeitar o empurrão, saia diferente de zero. Todo o método parecido com este:

$ Regex = / \ [ref: (\ d +) \] /

# Imposta formato de mensagem personalizado commit
def check_message_format
missed_revs = `git rev-list # {} $ OLDREV .. # {$ newrev}` divisão. ("\ n")
missed_revs.each fazer | rev |
mensagem = `cat arquivo git-commit # {rev} | sed '1, / ^ $ / d '`
se! $ Regex.Match (mensagem)
puts "[política] A sua mensagem não está formatado corretamente"
exit 1
final
final
final
check_message_format

Colocar isso no seu `update script` rejeitará atualizações que contêm compromete que tem mensagens que não aderem à sua regra.

# # # # Impondo um Usuário Sistema Baseado ACL # # # #

Suponha que você queira adicionar um mecanismo que utiliza uma lista de controle de acesso (ACL) que especifica quais usuários têm permissão para propagar as mudanças para que partes de seus projetos. Algumas pessoas têm acesso total, e outros só têm acesso a empurrar alterações para determinados subdiretórios ou arquivos específicos. Para reforçar isso, você vai escrever essas regras em um arquivo chamado `` acl que vive em seu repositório Git nua no servidor. Você vai ter o `update gancho` olhar para essas regras, ver quais arquivos estão sendo introduzidas para todos os commits sendo empurrado, e determinar se o usuário está fazendo o impulso tem acesso para atualizar todos os arquivos.

A primeira coisa que vou fazer é escrever o seu ACL. Aqui você vai usar um formato muito parecido com o mecanismo de ACL CVS: ele usa uma série de linhas, onde o primeiro campo é aproveitar `` ou `` indisponível, o próximo campo é uma lista delimitada por vírgula dos usuários para que o regra se aplica, e no último campo é o caminho para o qual a regra se aplica (acesso significado em branco aberto). Todos esses campos são delimitados por um tubo (`|`) personagem.

Neste caso, você tem um par de administradores, alguns escritores de documentação com acesso ao diretório `` doc, e um desenvolvedor que só tem acesso ao `lib` e `diretórios testes`, e seu arquivo ACL fica assim:

aproveitar | nickh, pjhyett, defunkt, TPW
vão | usinclair, cdickens, ebronte | doc
aproveitar | schacon | lib
| | aproveitar schacon testes

Você começa a ler esses dados em uma estrutura que você pode usar. Neste caso, para manter o exemplo simples, você só vai cumprir as diretrizes do avail `. Aqui está um método que lhe dá um array associativo onde a chave é o nome do usuário eo valor é um conjunto de caminhos para que o usuário tem acesso de escrita:

def get_acl_access_data (acl_file)
# Ler no ACL dados
. acl_file = File.read (acl_file) split ("\ n") rejeitar. {| linha | Linha ==''}
acesso = {}
acl_file.each do | linha |
vão, usuários, path = line.split ('|')
seguinte a menos que vão == 'sucesso'
. users.split (',') cada um fazer | user |
acesso [usuário] | | = []
acesso [usuário] caminho <<
final
final
acesso
final

Sobre o arquivo ACL você olhou anteriormente, este método get_acl_access_data `` retorna uma estrutura de dados que se parece com esta:

{"Defunkt" => [nil],
"JP" => [nil],
"Nickh" => [nil],
"Pjhyett" => [nil],
"Schacon" => ["lib", "testes"],
"Cdickens" => ["doc"],
"Usinclair" => ["doc"],
"Ebronte" => ["doc"]}

Agora que você tem as permissões resolvido, é preciso determinar quais os caminhos a comete sendo empurrado tenha modificado, de modo que você pode ter certeza que o usuário que está empurrando tem acesso a todos eles.

Você pode muito facilmente ver quais arquivos foram modificados em uma única confirmação com a opção `- nome somente` para o comando git log `(mencionado brevemente no Capítulo 2):

$ Git log -1 - nome-only - muito = formato:'' 9f585d

README
lib / test.rb

Se você usar a estrutura ACL voltou do `get_acl_access_data método` e verificar se contra os arquivos listados em cada uma das submissões, você pode determinar se o usuário tem acesso a empurrar toda a sua comete:

# Apenas permite que certos usuários para modificar determinados subdiretórios em um projeto
check_directory_perms def
= acesso get_acl_access_data ('acl')

# Ver se alguém está tentando empurrar algo que não pode
new_commits = `git rev-list # {} $ OLDREV .. # {$ newrev}` divisão. ("\ n")
new_commits.each fazer | rev |
files_modified = git log `-1 - nome-only - pretty = format:.'' # {}` rev split ("\ n")
files_modified.each fazer | caminho |
seguinte se path.size == 0
has_file_access = false
. [usuário $] acesso cada um fazer | access_path |
se! access_path usuário # tem acesso a tudo
| | (Path.index (access_path) == 0) # acesso a este caminho
has_file_access = true
final
final
se! has_file_access
puts "[política] Você não tem acesso a empurrar a # {path}"
exit 1
final
final
final
final

check_directory_perms

A maioria dos que devem ser fáceis de acompanhar. Você receberá uma lista de novos commits sendo empurrado para o seu servidor com `git rev-list`. Então, para cada um desses, você acha que os arquivos são modificados e verifique se o usuário que está empurrando tem acesso a todos os caminhos sendo modificados. Um Rubyism que pode não ser claro é `path.index (access_path) == 0`, que é verdadeiro se o caminho começa com `access_path` - isso garante que `access_path` não é apenas em um dos caminhos permitidos, mas uma permissão path começa com cada caminho acedido.

Agora os usuários não podem empurrar qualquer compromete com mensagens mal formadas ou com arquivos modificados fora de seus caminhos designados.

# # # # Impondo Fast-Forward-Only Empurra # # # #

A única coisa que resta é fazer valer fast-forward-only empurra. Em versões Git 1.6 ou mais recente, você pode definir o `receive.denyDeletes` e `` receive.denyNonFastForwards configurações. Mas a aplicação deste com um gancho irá funcionar em versões mais antigas do Git, e você pode modificá-lo para fazê-lo apenas para determinados usuários ou qualquer outra coisa que você venha com mais tarde.

A lógica para verificar isso é para ver se algum comete são acessíveis a partir da revisão mais antiga que não são acessíveis a partir da versão mais recente. Se não houver nenhum, então foi um impulso de avanço rápido, caso contrário, você negar:

# Reforça fast-forward só empurra
def check_fast_forward
missed_refs = `git rev-list # {} $ newrev .. # {$ OLDREV}`
missed_ref_count = tamanho missed_refs.split ("\ n").
se missed_ref_count> 0
puts "[política] não pode empurrar uma referência fast-forward não"
exit 1
final
final

check_fast_forward

Tudo está configurado. Se você executar o `chmod u + x .git / ganchos / atualização`, que é o arquivo que você no qual você deveria ter colocado todo este código, e então tentar empurrar uma referência não-avançado rapidamente, você começa algo como isto:

$ Git push origin mestre-f
Contagem de objetos: 5, feito.
A compactação de objetos: 100% (3/3), feito.
Objetos de escrita: 100% (3/3), 323 bytes, feito.
Total 3 (delta 1), 0 reutilizados (delta 0)
Objetos desembalagem: 100% (3/3), feito.
Políticas Cumprimento ...
(Refs / heads / master) (8338c5) (c5b616)
[Política] não pode empurrar uma referência não-fast-forward
erro: ganchos / atualização saiu com o código de erro 1
erro: gancho recusou-se a atualizar refs / heads / master
Para git @ gitserver: project.git
! [Remoto rejeitou] mestre -> mestre (gancho recusado)
erro: não empurrar alguns refs para 'git @ gitserver: project.git'

Há um par de coisas interessantes aqui. Primeiro, você vê esta onde o gancho começa a funcionar.

Políticas Cumprimento ...
(Refs / heads / master) (fb8c72) (c56860)

Observe que você impressa para stdout no início do seu script de atualização. É importante notar que qualquer coisa que seu script imprime em stdout serão transferidos para o cliente.

A próxima coisa que você vai notar é a mensagem de erro.

[Política] não pode empurrar uma referência fast-forward não
erro: ganchos / atualização saiu com o código de erro 1
erro: gancho recusou-se a atualizar refs / heads / master

A primeira linha foi impressa por você, os outros dois foram Git dizendo que o script de atualização saiu de zero e é isso que está em declínio seu empurrão. Por último, você tem isso:

Para git @ gitserver: project.git
! [Remoto rejeitou] mestre -> mestre (gancho recusado)
erro: não empurrar alguns refs para 'git @ gitserver: project.git'

Você verá uma mensagem remoto rejeitou para cada referência que o seu gancho diminuiu, e diz-lhe que ele foi recusado especificamente por causa de uma falha de gancho.

Além disso, se o marcador ref não existe em nenhum dos seus commits, você verá a mensagem de erro que você está imprimindo para isso.

[Política] A sua mensagem não está formatado corretamente

Ou se alguém tentar editar um arquivo que não têm acesso a e empurre um compromisso que o contém, eles vão ver algo semelhante. Por exemplo, se um autor de documentação tenta empurrar algo commit modificação no `lib`, eles vêem

[Política] Você não tem acesso a empurrar para lib / test.rb

Isto é tudo. A partir de agora, desde que `update script` está lá e executável, seu repositório nunca vai ser rebobinada e nunca terá uma mensagem de confirmação, sem o seu padrão na mesma, e os usuários serão sandboxed.

# # # Do lado do cliente Ganchos # # #

A desvantagem desta abordagem é a choramingar que resultará inevitavelmente quando commit de seus usuários empurra são rejeitados. Tendo seu trabalho cuidadosamente elaborada rejeitado no último minuto pode ser extremamente frustrante e confuso, e, além disso, eles vão ter que editar a sua história para corrigi-lo, o que nem sempre é para os fracos de coração.

A resposta para este dilema é fornecer alguns ganchos do lado do cliente que os usuários podem usar para notificá-los quando eles estão fazendo algo que o servidor é provável que rejeitar. Dessa forma, eles podem corrigir quaisquer problemas antes de cometer essas questões e antes de tornar-se mais difícil de corrigir. Porque ganchos não são transferidos com um clone de um projeto, você deve distribuir esses scripts de alguma outra forma e, então, seus usuários copiá-los para a sua `.git / ganchos` e torná-los executável. Você pode distribuir esses ganchos dentro do projeto ou em um projeto separado, mas não há maneira de configurá-los automaticamente.

Para começar, você deve verificar a sua mensagem de confirmação antes de cada commit é gravado, então você sabe que o servidor não irá rejeitar as alterações devido ao mal formatadas mensagens de commit. Para fazer isso, você pode adicionar o `commit-msg gancho`. Se você tem que ler a mensagem do arquivo passado como o primeiro argumento e que ao comparar o padrão, você pode forçar o Git para abortar a cometer, se não houver correspondência:

#! / Usr / bin / env ruby
message_file = ARGV [0]
mensagem = File.read (message_file)

$ Regex = / \ [ref: (\ d +) \] /

se! $ Regex.Match (mensagem)
puts "[política] A sua mensagem não está formatado corretamente"
exit 1
final

Se esse script está no lugar (em `.git / ganchos / commit-msg`) e executável, e de se comprometer com uma mensagem que não está formatado corretamente, você vê isso:

$ Git commit-am 'teste'
[Política] A sua mensagem não está formatado corretamente

Nenhum comprometimento foi concluída nessa instância. No entanto, se a mensagem contém o padrão adequado, Git permite cometer:

$ Git commit-am 'teste [ref: 132] "
[Master e05c914] teste [ref: 132]
1 arquivos alterados, 1 inserções (+), 0 deleções (-)

Em seguida, você quer ter certeza de que você não está modificando os arquivos que estão fora do seu alcance ACL. ., Se o seu projeto `git diretório` contém uma cópia do arquivo de ACL você usou anteriormente, então o seguinte `pré-commit` script irá impor essas restrições para você:

#! / Usr / bin / env ruby

$ User = ENV ['user']

# [Inserir método acl_access_data de cima]

# Apenas permite que certos usuários para modificar determinados subdiretórios em um projeto
check_directory_perms def
= acesso get_acl_access_data ('.git / acl')

files_modified = git `diff-índice - cached -. só de nome CABEÇA` split ("\ n")
files_modified.each fazer | caminho |
seguinte se path.size == 0
has_file_access = false
. [usuário $] acesso cada um fazer | access_path |
se access_path | | (path.index (access_path) == 0)
has_file_access = true
final
se! has_file_access
puts "[política] Você não tem acesso a empurrar a # {path}"
exit 1
final
final
final

check_directory_perms

Este é aproximadamente o mesmo script da peça do lado do servidor, mas com duas diferenças importantes. Primeiro, o arquivo ACL é em um lugar diferente, porque este script é executado a partir do seu diretório de trabalho, e não de seu diretório Git. Você tem que mudar o caminho para o arquivo ACL deste

= acesso get_acl_access_data ('acl')

para isso:

= acesso get_acl_access_data ('.git / acl')

A outra diferença importante é a forma como você obter uma lista dos arquivos que foram alterados. Como o método do lado do servidor olha para o log de commits, e, neste momento, a confirmação não foi gravada ainda, você deve começar sua lista de arquivos da área de teste em seu lugar. Em vez de

files_modified = git log `-1 - nome-only - muito = formato:'' # {ref}`

você tem que usar

files_modified = git `diff-índice - cached - nome somente CABEÇA`

Mas essas são as duas únicas diferenças - caso contrário, o script funciona da mesma maneira. Uma ressalva é que ele espera que você seja executado localmente como o mesmo usuário como você empurrar para a máquina remota. Se isso é diferente, você deve definir o `user` $ variável manualmente.

A última coisa que você tem a fazer é verificar se você não está tentando empurrar referências não-avançado rapidamente, mas que é um pouco menos comum. Para obter uma referência que não é um fast-forward, você tem que cometer um rebase passado você já empurrado para cima ou tentar empurrar um ramo diferente local até o mesmo ramo remoto.

Como o servidor vai dizer que você não pode empurrar um não-avançar de qualquer maneira, e impede o gancho forçado empurra, a única coisa acidental você pode tentar pegar é rebasing compromete que já foi pressionado.

Aqui está um exemplo de script pré-rebase que verifica isso. Ela recebe uma lista de todos os commits que você está prestes a reescrever e verifica se elas existem em qualquer uma das suas referências remotas. Se ele vê que é acessível a partir de uma de suas referências remotas, aborta o rebase:

#! / Usr / bin / env ruby

base_branch = ARGV [0]
se ARGV [1]
topic_branch = ARGV [1]
outro
topic_branch = "HEAD"
final

target_shas = `git rev-list # {} base_branch .. # {}` topic_branch divisão. ("\ n")
.. remote_refs = divisão `git branch-r` ("\ n") map {| r | r.strip}

target_shas.each fazer | sha |
remote_refs.each fazer | remote_ref |
shas_pushed = `git rev-lista ^ # {} sha ^ @ refs / controles remotos / # {}` remote_ref
se shas_pushed.split ("\ n"). incluir? (sha)
puts "[política] Commit # {} sha já foi empurrado para # {} remote_ref"
exit 1
final
final
final

Este script utiliza uma sintaxe que não foi coberto na seção Seleção de Revisão do Capítulo 6. Você obterá uma lista de confirmações que já foram empurrados para cima executando este:

git rev-lista ^ # {} ^ @ sha refs / controles remotos / # {} remote_ref

O SHA `^` @ sintaxe resolve todos os pais da confirmação. Você está à procura de qualquer confirmação que é acessível a partir da última confirmação no controle remoto e que não é acessível a partir de qualquer pai ou mãe de qualquer um dos SHAs você está tentando empurrar para cima - o que significa que é um fast-forward.

A principal desvantagem desta abordagem é que ela pode ser muito lenta e muitas vezes é desnecessário - se você não tentar forçar o empurrão com `-f`, o servidor irá avisá-lo e não aceitar a pressão. No entanto, é um exercício interessante e pode, em teoria, ajudar a evitar um rebase que você possa mais tarde ter que voltar atrás e corrigir.

Resumo # # # #

Você cobriu a maior parte das principais formas que você pode personalizar o seu cliente e servidor Git para melhor atender seu fluxo de trabalho e projetos. Você aprendeu sobre todos os tipos de configurações, com base em arquivo atributos, e ganchos de eventos, e que você construiu um exemplo de aplicação de políticas servidor. Agora você deve ser capaz de fazer Git caber quase qualquer fluxo de trabalho que você pode sonhar.