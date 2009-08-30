# Git サーバ #

ここまで読んだみなさんは、ふだん Git を使う上で必要になるタスクのほとんどを身につけたことでしょう。しかし、Git で何らかの共同作業をしようと思えばリモートの Git リポジトリを持つ必要があります。個人リポジトリとの間でのプッシュやプルも技術的には可能ですが、お勧めしません。よっぽど気をつけておかないと、ほかの人がどんな作業をしているのかをすぐに見失ってしまうからです。さらに、自分のコンピュータがオフラインのときにもほかの人が自分のリポジトリにアクセスできるようにしたいとなると、共有リポジトリを持つほうがずっと便利です。というわけで、他のメンバーとの共同作業をするときには、中間リポジトリをどこかに用意してみんながそこにアクセスできるようにし、プッシュやプルを行うようにすることをお勧めします。本書ではこの手のリポジトリのことを "Git サーバ" と呼ぶことにします。しかし、一般的に Git リポジトリをホストするのに必要なリソースはほんの少しだけです。それ専用のサーバをわざわざ用意する必要はまずありません。

Git サーバを立ち上げるのは簡単です。まず、サーバとの通信にどのプロトコルを使うのかを選択します。この章の最初のセクションで、どんなプロトコルが使えるのかとそれぞれのプロトコルの利点・欠点を説明します。その次のセクションでは、それぞれのプロトコルを使用したサーバの設定方法とその動かし方を説明します。最後に、ホスティングサービスについて紹介します。他人のサーバ上にコードを置くのが気にならない、そしてサーバの設定だの保守だのといった面倒なことはやりたくないという人のためのものです。

自前でサーバを立てることには興味がないという人は、この章は最後のセクションまで読み飛ばし、ホスティングサービスに関する情報だけを読めばよいでしょう。そして次の章に進み、分散ソース管理環境での作業について学びます。

リモートリポジトリは、一般的に _ベアリポジトリ_ となります。これは、作業ディレクトリをもたない Git リポジトリのことです。このリポジトリは共同作業の中継地点としてのみ用いられるので、ディスク上にスナップショットをチェックアウトする必要はありません。単に Git のデータがあればそれでよいのです。端的に言うと、ベアリポジトリとはそのプロジェクトの `.git` ディレクトリだけで構成されるもののことです。

## プロトコル ##

Git では、データ転送用のネットワークプロトコルとして Local、Secure Shell (SSH)、Git そして HTTP の四つを使用できます。ここでは、それぞれがどんなものなのかとどんな場面で使うべきか (使うべきでないか) を説明します。

注意すべき点として、HTTP 以外のすべてのプロトコルは、サーバ上に Git がインストールされている必要があります。

### Local プロトコル ###

一番基本的なプロトコルが _Local プロトコル_, です。これは、リモートリポジトリをディスク上の別のディレクトリに置くものです。これがよく使われるのは、たとえばチーム全員がアクセスできる共有ファイルシステム (NFS など) がある場合です。あるいは、あまりないでしょうが全員が同じコンピュータにログインしている場合にも使えます。後者のパターンはあまりお勧めできません。すべてのコードリポジトリが同じコンピュータ上に存在することになるので、何か事故が起こったときに何もかも失ってしまう可能性があります。

共有ファイルシステムをマウントしているのなら、それをローカルのファイルベースのリポジトリにクローンしたりお互いの間でプッシュやプルをしたりすることができます。この手のリポジトリをクローンしたり既存のプロジェクトのリモートとして追加したりするには、リポジトリへのパスを URL に指定します。たとえば、ローカルリポジトリにクローンするにはこのようなコマンドを実行します。

	$ git clone /opt/git/project.git

あるいは次のようにすることもできます。

	$ git clone file:///opt/git/project.git

URL の先頭に `file://` を明示するかどうかで、Git の動きは微妙に異なります。単にパスを指定した場合は、Git はハードリンクを行うか、必要に応じて直接ファイルをコピーします。`file://` を指定した場合は、Git がプロセスを立ち上げ、そのプロセスが (通常は) ネットワーク越しにデータを転送します。一般的に、直接のコピーに比べてこれは非常に非効率的です。`file://` プレフィックスをつける最も大きな理由は、(他のバージョン管理システムからインポートしたときなどにあらわれる) 関係のない参照やオブジェクトを除いたクリーンなコピーがほしいということです。本書では通常のパス表記を使用します。そのほうがたいていの場合に高速となるからです。

ローカルのリポジトリを既存の Git プロジェクトに追加するには、このようなコマンドを実行します。

	$ git remote add local_proj /opt/git/project.git

そうすれば、このリモートとの間のプッシュやプルを、まるでネットワーク越しにあるのと同じようにすることができます。

#### 利点 ####

ファイルベースのリポジトリの利点は、シンプルであることと既存のファイルアクセス権やネットワークアクセスを流用できることです。チーム全員がアクセスできる共有ファイルシステムがすでに存在するのなら、リポジトリを用意するのは非常に簡単です。ベアリポジトリのコピーをみんながアクセスできるどこかの場所に置き、読み書き可能な権限を与えるという、ごく普通の共有ディレクトリ上での作業です。この作業のために必要なベアリポジトリをエクスポートする方法については次のセクション「Git サーバの取得」で説明します。

もうひとつ、ほかの誰かの作業ディレクトリの内容をすばやく取り込めるのも便利なところです。同僚と作業しているプロジェクトで相手があなたに作業内容を確認してほしい言ってきたときなど、わざわざリモートのサーバにプッシュしてもらってそれをプルするよりは単に `git pull /home/john/project` のようなコマンドを実行するほうがずっと簡単です。

#### 欠点 ####

この方式の欠点は、メンバーが別の場所にいるときに共有アクセスを設定するのは一般的に難しいということです。自宅にいるときに自分のラップトップからプッシュしようとしたら、リモートディスクをマウントする必要があります。これはネットワーク越しのアクセスに比べて困難で遅くなるでしょう。

また、何らかの共有マウントを使用している場合は、必ずしもこの方式が最高速となるわけではありません。ローカルリポジトリが高速だというのは、単にデータに高速にアクセスできるからというだけの理由です。NFS 上に置いたリポジトリは、同じサーバで稼動しているリポジトリに SSH でアクセスしたときよりも遅くなりがちです。SSH でアクセスしたときは、各システムのローカルディスクにアクセスすることになるからです。

### SSH プロトコル ###

Git の転送プロトコルのうちもっとも一般的なのが SSH でしょう。SSH によるサーバへのアクセスは、ほとんどの場面で既に用意されているからです。仮にまだ用意されていなかったとしても、導入するのは容易なことです。また SSH は、ネットワークベースの Git 転送プロトコルの中で、容易に読み書き可能な唯一のものです。その他のネットワークプロトコル (HTTP および Git) は一般的に読み込み専用で用いるものです。不特定多数向けにこれらのプロトコルを開放したとしても、書き込みコマンドを実行するためには SSH が必要となります。SSH は認証付きのネットワークプロトコルでもあります。あらゆるところで用いられているので、環境を準備するのも容易です。

Git リポジトリを SSH 越しにクローンするには、次のように ssh:// URL を指定します。

	$ git clone ssh://user@server:project.git

あるいは、プロトコルを省略することもできます。プロトコルを明示しなくても、Git はそれが SSH であると見なします。
	
	$ git clone user@server:project.git

ユーザ名も省略することもできます。その場合、Git は現在ログインしているユーザでの接続を試みます。

#### 利点 ####

SSH を使う利点は多数あります。まず、ネットワーク越しでのリポジトリへの書き込みアクセスで認証が必要となる場面では、基本的にこのプロトコルを使わなければなりません。次に、一般的に SSH 環境の準備は容易です。SSH デーモンはごくありふれたツールなので、ネットワーク管理者の多くはその使用経験があります。また、多くの OS に標準で組み込まれており、管理用ツールが付属しているものもあります。さらに、SSH 越しのアクセスは安全です。すべての転送データは暗号化され、信頼できるものとなります。最後に、Git プロトコルや Local プロトコルと同程度に効率的です。転送するデータを可能な限りコンパクトにすることができます。

#### 欠点 ####

SSH の欠点は、リポジトリへの匿名アクセスを許可できないということです。たとえ読み込み専用であっても、リポジトリにアクセスするには SSH 越しでのマシンへのアクセス権限が必要となります。つまり、オープンソースのプロジェクトにとっては SSH はあまりうれしくありません。特定の企業内でのみ使用するのなら、SSH はおそらく唯一の選択肢となるでしょう。あなたのプロジェクトに読み込み専用の匿名アクセスを許可したい場合は、リポジトリへのプッシュ用に SSH を用意するのとは別にプル用の環境として別のプロトコルを提供する必要があります。

### Git プロトコル ###

次は Git プロトコルです。これは Git に標準で付属する特別なデーモンです。専用のポート (9418) をリスンし、SSH プロトコルと同様のサービスを提供しますが、認証は行いません。Git プロトコルを提供するリポジトリを準備するには、`git-export-daemon-ok` というファイルを作らなければなりません (このファイルがなければデーモンはサービスを提供しません)。ただ、このままでは一切セキュリティはありません。Git リポジトリをすべての人に開放し、クローンさせることができます。しかし、一般に、このプロトコルでプッシュさせることはありません。プッシュアクセスを認めることは可能です。しかし認証がないということは、その URL を知ってさえいればインターネット上の誰もがプロジェクトにプッシュできるということになります。これはありえない話だと言っても差し支えないでしょう。

#### 利点 ####

Git プロトコルは、もっとも高速な転送プロトコルです。公開プロジェクトで大量のトラフィックをさばいている場合、あるいは巨大なプロジェクトで読み込みアクセス時のユーザ認証が不要な場合は、Git デーモンを用いてリポジトリを公開するとよいでしょう。このプロトコルは SSH プロトコルと同様のデータ転送メカニズムを使いますが、暗号化と認証のオーバーヘッドがないのでより高速です。

#### 欠点 ####

Git プロトコルの弱点は、認証の仕組みがないことです。Git プロトコルだけでしかプロジェクトにアクセスできないという状況は、一般的に望ましくありません。SSH と組み合わせ、プッシュ (書き込み) 権限を持つ一部の開発者には SSH を使わせてそれ以外の人には `git://` での読み込み専用アクセスを用意することになるでしょう。また、Git プロトコルは準備するのがもっとも難しいプロトコルでもあります。まず、独自のデーモンを起動しなければなりません (この章の“Gitosis”のところで詳しく説明します)。そのためには `xinetd` やそれに類するものの設定も必要になりますが、これはそんなにお手軽にできるものではありません。また、ファイアウォールでポート 9418 のアクセスを許可する必要もあります。これは標準のポートではないので、企業のファイアウォールでは許可されなていないかもしれません。大企業のファイアウォールでは、こういったよくわからないポートは普通ブロックされています。

### HTTP/S プロトコル ###

最後は HTTP プロトコルです。HTTP あるいは HTTPS のうれしいところは、準備するのが簡単だという点です。基本的に、必要な作業といえば Git リポジトリを HTTP のドキュメントルート以下に置いて `post-update` フックを用意することだけです (Git のフックについては第 7 章で詳しく説明します)。これで、ウェブサーバ上のその場所にアクセスできる人ならだれでもリポジトリをクローンできるようになります。リポジトリへの HTTP での読み込みアクセスを許可するには、こんなふうにします。

	$ cd /var/www/htdocs/
	$ git clone --bare /path/to/git_project gitproject.git
	$ cd gitproject.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

これだけです。Git に標準でついてくる `post-update` フックは、適切なコマンド (`git update-server-info`) を実行して HTTP でのフェッチとクローンをうまく動くようにします。このコマンドが実行されるのは、このリポジトリに対して SSH 越しでのプッシュがあったときです。その他の人たちがクローンする際には次のようにします。

	$ git clone http://example.com/gitproject.git

今回の例ではたまたま `/var/www/htdocs` (一般的な Apache の標準設定) を使用しましたが、別にそれに限らず任意のウェブサーバを使うことができます。単にベアリポジトリをそのパスに置けばよいだけです。Git のデータは、普通の静的ファイルとして扱われます (実際のところどのようになっているかの詳細は第 9 章を参照ください)。

HTTP 越しの Git のプッシュを行うことも可能ですが、あまり使われていません。また、これには複雑な WebDAV の設定が必要です。めったに使われることがないので、本書では取り扱いません。HTTP でのプッシュに興味があるかたのために、それ用のリポジトリを準備する方法が `http://www.kernel.org/pub/software/scm/git/docs/howto/setup-git-server-over-http.txt` で公開されています。HTTP 越しでの Git のプッシュに関して、よいお知らせがひとつあります。どんな WebDAV サーバでも使うことが可能で、特に Git ならではの機能は必要ありません。つまり、もしプロバイダが WebDAV によるウェブサイトの更新に対応しているのなら、それを使用することができます。

#### 利点 ####

HTTP を使用する利点は、簡単にセットアップできるということです。便利なコマンドで、Git リポジトリへの読み取りアクセスを全世界に公開できます。ものの数分で用意できることでしょう。また、HTTP はサーバ上のリソースを激しく使用することはありません。すべてのデータは HTTP サーバ上の静的なファイルとして扱われます。普通の Apache サーバは毎秒数千ファイルぐらいは余裕でさばくので、小規模サーバであったとしても (Git リポジトリへのへのアクセスで) サーバが過負荷になることはないでしょう。

HTTPS で読み込み専用のリポジトリを公開することもできます。これで、転送されるコンテンツを暗号化したりクライアント側で特定の署名つき SSL 証明書を使わせたりすることができるようになります。そこまでやるぐらいなら SSH の公開鍵を使うほうが簡単ではありますが、場合によっては署名入り SSL 証明書やその他の HTTP ベースの認証方式を使った HTTPS での読み込み専用アクセスを使うこともあるでしょう。

もうひとつの利点としてあげられるのは、HTTP が非常に一般的なプロトコルであるということです。たいていの企業のファイアウォールはこのポートを通すように設定されています。

#### 欠点 ####

HTTP によるリポジトリの提供の問題点は、クライアント側から見て非効率的だということです。リポジトリのフェッチやクローンには非常に時間がかかります。また、他のネットワークプロトコルにくらべてネットワークのオーバーヘッドや転送量が非常に増加します。必要なデータだけをやりとりするといった賢い機能はない (サーバ側で転送時になんらかの作業をすることができない) ので、HTTP はよく _ダム (dumb)_ プロトコルなどと呼ばれています。HTTP とその他のプロトコルの間の効率の違いに関する詳細な情報は、第 9 章を参照ください。

## サーバ用の Git の取得 ##

Git サーバを立ち上げるには、既存のリポジトリをエクスポートして新たなベアリポジトリ (作業ディレクトリを持たないリポジトリ) を作らなければなりません。これは簡単にできます。リポジトリをクローンして新たにベアリポジトリを作成するには、clone コマンドでオプション `--bare` を指定します。慣例により、ベアリポジトリのディレクトリ名の最後は `.git` とすることになっています。

	$ git clone --bare my_project my_project.git
	Initialized empty Git repository in /opt/projects/my_project.git/

このコマンドを実行したときの出力はちょっとわかりにくいかもしれません。`clone` は基本的に `git init` をしてから `git fetch` をするのと同じことなので、`git init` の部分の部分の出力も見ることになります。そのメッセージは「空のディレクトリを作成しました」というものです。実際にどんなオブジェクトの転送が行われたのかは何も表示されませんが、きちんと転送は行われています。これで、`my_project.git` ディレクトリに Git リポジトリのデータができあがりました。

これは、おおざっぱに言うと次の操作と同じようなことです。

	$ cp -Rf my_project/.git my_project.git

設定ファイルにはちょっとした違いもありますが、ほぼこんなものです。作業ディレクトリなしで Git リポジトリを受け取り、それ単体のディレクトリを作成しました。

### ベアリポジトリのサーバ上への設置 ###

ベアリポジトリを取得できたので、あとはそれをサーバ上においてプロトコルを準備するだけです。ここでは、`git.example.com` というサーバがあってそこに SSH でアクセスできるものと仮定しましょう。Git リポジトリはサーバ上の `/opt/git` ディレクトリに置く予定です。新しいリポジトリを作成するには、ベアリポジトリを次のようにコピーします。

	$ scp -r my_project.git user@git.example.com:/opt/git

この時点で、同じサーバに SSH でアクセスできてかつ `/opt/git` ディレクトリへの読み込みアクセス権限がある人なら、次のようにしてこのリポジトリをクローンできるようになりました。

	$ git clone user@git.example.com:/opt/git/my_project.git

ユーザが SSH でアクセスでき、かつ `/opt/git/my_project.git` ディレクトリへの書き込みアクセス権限があれば、すでにプッシュもできる状態になっています。`git init` コマンドで `--shared` オプションを指定すると、リポジトリに対するグループ書き込みパーミッションを自動的に追加することができます。

	$ ssh user@git.example.com
	$ cd /opt/git/my_project.git
	$ git init --bare --shared

既存の Git リポジトリからベアリポジトリを作成し、メンバーが SSH でアクセスできるサーバにそれを配置するだけ。簡単ですね。これで、そのプロジェクトでの共同作業ができるようになりました。

複数名が使用する Git サーバをたったこれだけの作業で用意できるというのは特筆すべきことです。サーバ SSH アクセス可能なアカウントを作成し、ベアリポジトリをサーバのどこかに置き、そこに読み書き可能なアクセス権を設定する。これで準備OK。他には何もいりません。

次のいくつかのセクションでは、より洗練された環境を作るための方法を説明します。いちいちユーザごとにアカウントを作らなくて済む方法、一般向けにリポジトリへの読み込みアクセスを開放する方法、ウェブ UI の設定、Gitosis の使い方などです。しかし、数名のメンバーで閉じたプロジェクトでの作業なら、SSH サーバとベアリポジトリ _さえ_ あれば十分なことは覚えておきましょう。

### ちょっとしたセットアップ ###

小規模なグループ、あるいは数名の開発者しかいない組織で Git を使うなら、すべてはシンプルに進められます。Git サーバを準備する上でもっとも複雑なことのひとつは、ユーザ管理です。同一リポジトリに対して「このユーザは読み込みのみが可能、あのユーザは読み書きともに可能」などと設定したければ、アクセス権とパーミッションの設定は多少難しくなります。

#### SSH アクセス ####

開発者全員が SSH でアクセスできるサーバがすでにあるのなら、リポジトリを用意するのは簡単です。先ほど説明したように、ほとんど何もする必要はないでしょう。より複雑なアクセス制御をリポジトリ上で行いたい場合は、そのサーバの OS 上でファイルシステムのパーミッションを設定するとよいでしょう。

リポジトリに対する書き込みアクセスをさせたいメンバーの中にサーバのアカウントを持っていない人がいる場合は、新たに SSH アカウントを作成しなければなりません。あなたがサーバにアクセスできているということは、すでに SSH サーバはインストールされているということです。

その状態で、チームの全員にアクセス権限を与えるにはいくつかの方法があります。ひとつは全員分のアカウントを作成すること。直感的ですがすこし面倒です。ひとりひとりに対して `adduser` を実行して初期パスワードを設定するという作業をしなければなりません。

もうひとつの方法は、'git' ユーザをサーバ上に作成し、書き込みアクセスが必要なユーザには SSH 公開鍵を用意してもらってそれを 'git' ユーザの `~/.ssh/authorized_keys` に追加します。これで、全員が 'git' ユーザでそのマシンにアクセスできるようになりました。これがコミットデータに影響を及ぼすことはありません。SSH で接続したときのユーザとコミットするときに記録されるユーザとは別のものだからです。

あるいは、SSH サーバの認証を LDAP サーバやその他の中央管理形式の仕組みなど既に用意されているものにするとこもできます。各ユーザがサーバ上でシェルへのアクセスができさえすれば、どんな仕組みの SSH 認証であっても動作します。

## SSH 公開鍵の作成 ##

多くの Git サーバでは、SSH の公開鍵認証を使用しています。この方式を使用するには、各ユーザが自分の公開鍵を作成しなければなりません。公開鍵のつくりかたは、OS が何であってもほぼ同じです。まず、自分がすでに公開鍵を持っていないかどうか確認します。デフォルトでは、各ユーザの SSH 鍵はそのユーザの `~/.ssh` ディレクトリに置かれています。自分が鍵を持っているかどうかを確認するには、このディレクトリに行ってその中身を調べます。

	$ cd ~/.ssh
	$ ls
	authorized_keys2  id_dsa       known_hosts
	config            id_dsa.pub

そして「○○」「○○.pub」というファイル名の組み合わせを探します。「○○」の部分は、通常は `id_dsa` あるいは `id_rsa` となります。もし見つかったら、`.pub` がついているほうのファイルがあなたの公開鍵で、もう一方があなたの秘密鍵です。そのようなファイルがない (あるいはそもそも `.ssh` ディレクトリがない) 場合は、`ssh-keygen` というプログラムを実行してそれを作成します。このプログラムは Linux/Mac なら SSH パッケージに含まれており、Windows では MSysGit パッケージに含まれています。

	$ ssh-keygen 
	Generating public/private rsa key pair.
	Enter file in which to save the key (/Users/schacon/.ssh/id_rsa): 
	Enter passphrase (empty for no passphrase): 
	Enter same passphrase again: 
	Your identification has been saved in /Users/schacon/.ssh/id_rsa.
	Your public key has been saved in /Users/schacon/.ssh/id_rsa.pub.
	The key fingerprint is:
	43:c5:5b:5f:b1:f1:50:43:ad:20:a6:92:6a:1f:9a:3a schacon@agadorlaptop.local

まず、鍵の保存先 (`.ssh/id_rsa`) を指定し、それからパスフレーズを二回入力するよう求められます。鍵を使うときにパスフレーズを入力したくない場合は、パスフレーズを空のままにしておきます。

さて、次に各ユーザは自分の公開鍵をあなた (あるいは Git サーバの管理者である誰か) に送らなければなりません (ここでは、すでに公開鍵認証を使用するように SSH サーバが設定済みであると仮定します)。公開鍵を送るには、`.pub` ファイルの中身をコピーしてメールで送ります (訳注: メールなんかで送っていいの? とツッコミたいところだ……)。公開鍵は、このようなファイルになります。

	$ cat ~/.ssh/id_rsa.pub 
	ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAklOUpkDHrfHY17SbrmTIpNLTGK9Tjom/BWDSU
	GPl+nafzlHDTYW7hdI4yZ5ew18JH4JW9jbhUFrviQzM7xlELEVf4h9lFX5QVkbPppSwg0cda3
	Pbv7kOdJ/MTyBlWXFCR+HAo3FXRitBqxiX1nKhXpHAZsMciLq8V6RjsNAQwdsdMFvSlVK/7XA
	t3FaoJoAsncM1Q9x5+3V0Ww68/eIFmb1zuUFljQJKprrX88XypNDvjYNby6vw/Pb0rwert/En
	mZ+AW4OZPnTPI89ZPmVMLuayrD2cE86Z/il8b+gw3r3+1nKatmIkjn2so1d01QraTlMqVSsbx
	NrRFi9wrf+M7Q== schacon@agadorlaptop.local

各種 OS 上での SSH 鍵の作り方については、GitHub の `http://github.com/guides/providing-your-ssh-key` に詳しく説明されています。

## サーバのセットアップ ##

それでは、サーバ側での SSH アクセスの設定について順を追って見ていきましょう。この例では `authorized_keys` 方式でユーザの認証を行います。また、Ubuntu のような標準的な Linux ディストリビューションを動かしているものと仮定します。まずは 'git' ユーザを作成し、そのユーザの `.ssh` ディレクトリを作りましょう。

	$ sudo adduser git
	$ su git
	$ cd
	$ mkdir .ssh

次に、開発者たちの SSH 公開鍵をそのユーザの `authorized_keys` に追加していきましょう。受け取った鍵が一時ファイルとして保存されているものとします。先ほどもごらんいただいたとおり、公開鍵の中身はこのような感じになっています。

	$ cat /tmp/id_rsa.john.pub
	ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCB007n/ww+ouN4gSLKssMxXnBOvf9LGt4L
	ojG6rs6hPB09j9R/T17/x4lhJA0F3FR1rP6kYBRsWj2aThGw6HXLm9/5zytK6Ztg3RPKK+4k
	Yjh6541NYsnEAZuXz0jTTyAUfrtU3Z5E003C4oxOj6H0rfIF1kKI9MAQLMdpGW1GYEIgS9Ez
	Sdfd8AcCIicTDWbqLAcU4UpkaX8KyGlLwsNuuGztobF8m72ALC/nLF6JLtPofwFBlgc+myiv
	O7TCUSBdLQlgMVOFq1I2uPWQOkOWQAHukEOmfjy2jctxSDBQ220ymjaNsHT4kgtZg2AYYgPq
	dAv8JggJICUvax2T9va5 gsg-keypair

これを `authorized_keys` に追加していきましょう。

	$ cat /tmp/id_rsa.john.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.josie.pub >> ~/.ssh/authorized_keys
	$ cat /tmp/id_rsa.jessica.pub >> ~/.ssh/authorized_keys

さて、彼らが使うための空のリポジトリを作成しましょう。`git init` に `--bare` オプションを指定して実行すると、作業ディレクトリのない空のリポジトリを初期化します。

	$ cd /opt/git
	$ mkdir project.git
	$ cd project.git
	$ git --bare init

これで、John と Josie そして Jessica はプロジェクトの最初のバージョンをプッシュできるようになりました。このリポジトリをリモートとして追加し、ブランチをプッシュすればいいのです。何か新しいプロジェクトを追加しようと思ったら、そのたびに誰かがサーバにログインし、ベアリポジトリを作らなければならないことに注意しましょう。'git' ユーザとリポジトリを作ったサーバのホスト名を `gitserver` としておきましょう。`gitserver` がそのサーバを指すように DNS を設定しておけば、このようなコマンドを使えます。

	# John のコンピュータで
	$ cd myproject
	$ git init
	$ git add .
	$ git commit -m 'initial commit'
	$ git remote add origin git@gitserver:/opt/git/project.git
	$ git push origin master

これで、他のメンバーがリポジトリをクローンして変更内容を書き戻せるようになりました。

	$ git clone git@gitserver:/opt/git/project.git
	$ vim README
	$ git commit -am 'fix for the README file'
	$ git push origin master

この方法を使えば、小規模なチーム用の読み書き可能な Git サーバをすばやく立ち上げることができます。

万一の場合に備えて 'git' ユーザができることを制限するのも簡単で、Git に関する作業しかできない制限付きシェル `git-shell` が Git に付属しています。これを 'git' ユーザのログインシェルにしておけば、'git' ユーザはサーバへの通常のシェルアクセスができなくなります。これを使用するには、ユーザのログインシェルとして bash や csh ではなく `git-shell` を指定します。そのためには `/etc/passwd` ファイルを編集しなければなりません。

	$ sudo vim /etc/passwd

いちばん最後に、このような行があるはずです。

	git:x:1000:1000::/home/git:/bin/sh

ここで `/bin/sh` を `/usr/bin/git-shell` (`which git-shell` を実行してインストール先を探し、それを指定します) に変更します。変更後はこのようになるでしょう。

	git:x:1000:1000::/home/git:/usr/bin/git-shell

これで、'git' ユーザは Git リポジトリへのプッシュやプル以外のシェル操作ができなくなりました。それ以外の操作をしようとすると、このように拒否されます。

	$ ssh git@gitserver
	fatal: What do you think I am? A shell?
	Connection to gitserver closed.

## 一般公開 ##

匿名での読み込み専用アクセス機能を追加するにはどうしたらいいでしょうか? 身内に閉じたプロジェクトではなくオープンソースのプロジェクトを扱うときに、これを考えることになります。あるいは、自動ビルドや継続的インテグレーション用に大量のサーバが用意されており、それがしばしば入れ替わるという場合など。単なる読み込み専用の匿名アクセスのためだけに毎回 SSH 鍵を作成しなければならないのは大変です。

おそらく一番シンプルな方法は、静的なウェブサーバを立ち上げてそのドキュメントルートに Git リポジトリを置き、本章の最初のセクションで説明した `post-update` フックを有効にすることです。先ほどの例を続けてみましょう。リポジトリが `/opt/git` ディレクトリにあり、マシン上で Apache が稼働中であるものとします。念のために言いますが、別に Apache に限らずどんなウェブサーバでも使えます。しかしここでは、Apache の設定を例にして何が必要なのかを説明していきます。

まずはフックを有効にします。

	$ cd project.git
	$ mv hooks/post-update.sample hooks/post-update
	$ chmod a+x hooks/post-update

バージョン 1.6 より前の Git を使っている場合は `mv` コマンドは不要です。Git がフックのサンプルに .sample という拡張子をつけるようになったのは、つい最近のことです。

この `post-update` は、いったい何をするのでしょうか? その中身はこのようになります。

	$ cat .git/hooks/post-update 
	#!/bin/sh
	exec git-update-server-info

SSH 経由でサーバへのプッシュが行われると、Git はこのコマンドを実行し、HTTP 経由での取得に必要なファイルを更新します。

次に、Apache の設定に VirtualHost エントリを追加して Git プロジェクトのディレクトリをドキュメントルートに設定します。ここでは、ワイルドカード DNS を設定して `*.gitserver` へのアクセスがすべてこのマシンに来るようになっているものとします。

	<VirtualHost *:80>
	    ServerName git.gitserver
	    DocumentRoot /opt/git
	    <Directory /opt/git/>
	        Order allow, deny
	        allow from all
	    </Directory>
	</VirtualHost>

また、`/opt/git` ディレクトリの所有グループを `www-data` にし、ウェブサーバがこのリポジトリにアクセスできるようにしなければなりません。CGI スクリプトを実行する Apache インスタンスのユーザ権限で動作することになるからです。

	$ chgrp -R www-data /opt/git

Apache を再起動すれば、プロジェクトの URL を指定してリポジトリのクローンができるようになります。

	$ git clone http://git.gitserver/project.git

この方法を使えば、多数のユーザに HTTP での読み込みアクセス権を与える設定がたった数分でできあがります。多数のユーザに認証なしでのアクセスを許可するためのもうひとつの方法として、Git デーモンを立ち上げることもできます。しかし、その場合はプロセスをデーモン化させなければなりません。その方法については次のセクションで説明します。

## GitWeb ##

これで、読み書き可能なアクセス方法と読み込み専用のアクセス方法を用意できるようになりました。次にほしくなるのは、ウェブベースでの閲覧方法でしょうか。Git には標準で GitWeb という CGI スクリプトが付属しており、これを使うことができます。GitWeb の使用例は、たとえば `http://git.kernel.org` で確認できます (図 4-1 を参照ください)。

Insert 18333fig0401.png 
図 4-1. GitWeb のユーザインターフェイス

自分のプロジェクトでためしに GitWeb を使ってみようという人のために、一時的なインスタンスを立ち上げるためのコマンドが Git に付属しています。これを実行するには `lighttpd` や `webrick` といった軽量なサーバが必要です。Linux マシンなら、たいてい `lighttpd` がインストールされています。これを実行するには、プロジェクトのディレクトリで `git instaweb` と打ち込みます。Mac の場合なら、Leopard には Ruby がプレインストールされています。したがって `webrick` が一番よい選択肢でしょう。`instaweb` を lighttpd 以外で実行するには、`--httpd` オプションを指定します。

	$ git instaweb --httpd=webrick
	[2009-02-21 10:02:21] INFO  WEBrick 1.3.1
	[2009-02-21 10:02:21] INFO  ruby 1.8.6 (2008-03-03) [universal-darwin9.0]

これは、HTTPD サーバをポート 1234 で起動させ、自動的にウェブブラウザを立ち上げてそのページを表示させます。非常にお手軽です。ひととおり見終えてサーバを終了させたくなったら、同じコマンドに `--stop` オプションをつけて実行します。

	$ git instaweb --httpd=webrick --stop

ウェブインターフェイスをチーム内で常時立ち上げたりオープンソースプロジェクト用に公開したりする場合は、CGI スクリプトを設定して通常のウェブサーバに配置しなければなりません。Linux のディストリビューションの中には、`apt` や `yum` などで `gitweb` パッケージが用意されているものもあります。まずはそれを探してみるとよいでしょう。手動での GitWeb のインストールについて、さっと流れを説明します。まずは Git のソースコードを取得しましょう。その中に GitWeb が含まれており、CGI スクリプトを作ることができます。

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	$ cd git/
	$ make GITWEB_PROJECTROOT="/opt/git" \
	        prefix=/usr gitweb/gitweb.cgi
	$ sudo cp -Rf gitweb /var/www/

コマンドを実行する際に、Git リポジトリの場所 `GITWEB_PROJECTROOT` 変数で指定しなければならないことに注意しましょう。さて、次は Apache にこのスクリプトを処理させるようにしなければなりません。VirtualHost に次のように追加しましょう。

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

GitWeb は、CGI に対応したウェブサーバならどんなものを使っても動かすことができます。何か別のサーバのほうがよいというのなら、そのサーバで動かすのもたやすいことでしょう。これで、`http://gitserver/` にアクセスすればリポジトリをオンラインで見られるようになりました。また `http://git.gitserver` で、HTTP 越しのクローンやフェッチもできます。

## Gitosis ##

ユーザの公開鍵を `authorized_keys` にまとめてアクセス管理する方法は、しばらくの間はうまくいくでしょう。しかし、何百人ものユーザを管理する段階になると、この方式はとても面倒になります。サーバのシェルでの操作が毎回発生するわけですし、またアクセス制御が皆無な状態、つまり公開鍵を登録した人はすべてのプロジェクトのすべてのファイルを読み書きできる状態になってしまいます。

ここで、よく使われている Gitosis というソフトウェアについて紹介しましょう。Gitosis は、`authorized_keys` ファイルを管理したりちょっとしたアクセス制御を行ったりするためのスクリプト群です。ユーザを追加したりアクセス権を定義したりするための UI に、ウェブではなく独自の Git リポジトリを採用しているというのが興味深い点です。プロジェクトに関する情報を準備してそれをプッシュすると、その情報に基づいて Gitosis がサーバを設定するというクールな仕組みになっています。

Gitosis のインストールは簡単だとはいえませんが、それほど難しくもありません。Linux サーバ上で運用するのがいちばん簡単でしょう。今回の例では、ごく平凡な Ubuntu 8.10 サーバを使います。

Gitosis は Python のツールを使います。まずは Python の setuptools パッケージをインストールしなければなりません。Ubuntu なら python-setuptools というパッケージがあります。

	$ apt-get install python-setuptools

次に、プロジェクトのメインサイトから Gitosis をクローンしてインストールします。

	$ git clone git://eagain.net/gitosis.git
	$ cd gitosis
	$ sudo python setup.py install

これで、Gitosis が使う実行ファイル群がインストールされました。Gitosis は、リポジトリが `/home/git` にあることが前提となっています。しかしここではすでに `/opt/git` にリポジトリが存在するので、いろいろ設定しなおすのではなくシンボリックリンクを作ってしまいましょう。

	$ ln -s /opt/git /home/git/repositories

Gitosis は鍵の管理も行うので、まず現在の鍵ファイルを削除してあとでもう一度鍵を追加し、Gitosis に `authorized_keys` を自動管理させなければなりません。ここではまず `authorized_keys` を別の場所に移動します。

	$ mv /home/git/.ssh/authorized_keys /home/git/.ssh/ak.bak

次は 'git' ユーザのシェルをもし `git-shell` コマンドに変更していたのなら、元に戻さなければなりません。人にログインさせるのではなく、かわりに Gitosis に管理してもらうのです。`/etc/passwd` ファイルにある

	git:x:1000:1000::/home/git:/usr/bin/git-shell

の行を、次のように戻しましょう。

	git:x:1000:1000::/home/git:/bin/sh

いよいよ Gitosis の初期設定です。自分の秘密鍵を使って `gitosis-init` コマンドを実行します。サーバ上に自分の公開鍵をおいていない場合は、まず公開鍵をコピーしましょう。

	$ sudo -H -u git gitosis-init < /tmp/id_dsa.pub
	Initialized empty Git repository in /opt/git/gitosis-admin.git/
	Reinitialized existing Git repository in /opt/git/gitosis-admin.git/

これで、指定した鍵を持つユーザが Gitosis 用の Git リポジトリを変更できるようになりました。次に、新しいリポジトリの `post-update` スクリプトに実行ビットを設定します。

	$ sudo chmod 755 /opt/git/gitosis-admin.git/hooks/post-update

これで準備完了です。きちんと設定できていれば、Gitosis の初期設定時に登録した公開鍵を使って SSH でサーバにログインできるはずです。結果はこのようになります。

	$ ssh git@gitserver
	PTY allocation request failed on channel 0
	fatal: unrecognized command 'gitosis-serve schacon@quaternion'
	  Connection to gitserver closed.

これは「何も Git のコマンドを実行していないので、接続を拒否した」というメッセージです。では、実際に何か Git のコマンドを実行してみましょう。Gitosis 管理リポジトリをクローンします。

	# on your local computer
	$ git clone git@gitserver:gitosis-admin.git

`gitosis-admin` というディレクトリができました。次のような内容になっています。

	$ cd gitosis-admin
	$ find .
	./gitosis.conf
	./keydir
	./keydir/scott.pub

`gitosis.conf` が、ユーザやリポジトリそしてパーミッションを指定するためのファイルです。`keydir` ディレクトリには、リポジトリへの何らかのアクセス権を持つ全ユーザの公開鍵ファイルを格納します。ユーザごとにひとつのファイルとなります。`keydir` ディレクトリ内のファイル名 (この例では `scott.pub`) は人によって異なるでしょう。これは、`gitosis-init` スクリプトでインポートした公開鍵の最後にある説明をもとにして Gitosis がつけた名前です。

`gitosis.conf` ファイルを見ると、今のところは先ほどクローンした `gitosis-admin` プロジェクトについての情報しか書かれていません。

	$ cat gitosis.conf 
	[gitosis]

	[group gitosis-admin]
	writable = gitosis-admin
	members = scott

これは、'scott' ユーザ（Gitosis の初期化時に公開鍵を指定したユーザ）だけが `gitosis-admin` プロジェクトにアクセスできるという意味です。

では、新しいプロジェクトを追加してみましょう。`mobile` という新しいセクションを作成し、モバイルチームのメンバーとモバイルチームがアクセスするプロジェクトを書き入れます。今のところ存在するユーザは 'scott' だけなので、とりあえずは彼をメンバーとして追加します。そして、新しいプロジェクト `iphone_project` を作ることにしましょう。

	[group mobile]
	writable = iphone_project
	members = scott

`gitosis-admin` プロジェクトに手を入れたら、それをコミットしてサーバにプッシュしないと変更が反映されません。

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

新しい `iphone_project` プロジェクトにプッシュするには、ローカル側のプロジェクトに、このサーバをリモートとして追加します。サーバ側でわざわざベアリポジトリを作る必要はありません。先ほどプッシュした地点で、Gitosis が自動的にベアリポジトリの作成を済ませています。

	$ git remote add origin git@gitserver:iphone_project.git
	$ git push origin master
	Initialized empty Git repository in /opt/git/iphone_project.git/
	Counting objects: 3, done.
	Writing objects: 100% (3/3), 230 bytes, done.
	Total 3 (delta 0), reused 0 (delta 0)
	To git@gitserver:iphone_project.git
	 * [new branch]      master -> master

パスを指定する必要がないことに注目しましょう (実際、パスを指定しても動作しません)。コロンの後にプロジェクト名を指定するだけで、Gitosis がプロジェクトを見つけてくれます。

このプロジェクトに新たなメンバーを迎え入れることになりました、公開鍵を追加しなければなりません。しかし、今までのようにサーバ上の `~/.ssh/authorized_keys` に追記する必要はありません。ユーザ単位の鍵ファイルを `keydir` ディレクトリ内に置くだけです。鍵ファイルにつけた名前が、`gitosis.conf` でその人を指定するときの名前となります。では、John と Josie そして Jessica の公開鍵を追加しましょう。

	$ cp /tmp/id_rsa.john.pub keydir/john.pub
	$ cp /tmp/id_rsa.josie.pub keydir/josie.pub
	$ cp /tmp/id_rsa.jessica.pub keydir/jessica.pub

そして彼らを 'mobile' チームに追加し、`iphone_project` を読み書きできるようにします。

	[group mobile]
	writable = iphone_project
	members = scott john josie jessica

この変更をコミットしてプッシュすると、この四人のユーザがプロジェクトへの読み書きをできるようになります。

Gitosis にはシンプルなアクセス制御機能もあります。John には読み込み専用のアクセス権を設定したいという場合は、このようにします。

	[group mobile]
	writable = iphone_project
	members = scott josie jessica

	[group mobile_ro]
	readonly = iphone_project
	members = john

John はプロジェクトをクローンして変更内容を受け取れます。しかし、手元での変更をプッシュしようとすると Gitosis に拒否されます。このようにして好きなだけのグループを作成し、それぞれに個別のユーザとプロジェクトを含めることができます。また、グループのメンバーとして別のグループを指定し (その場合は先頭に `@` をつけます)、メンバーを自動的に継承することもできます。

	[group mobile_committers]
	members = scott josie jessica

	[group mobile]
	writable  = iphone_project
	members   = @mobile_committers

	[group mobile_2]
	writable  = another_iphone_project
	members   = @mobile_committers john

何か問題が発生した場合には、`[gitosis]` セクションの下に `loglevel=DEBUG` を書いておくと便利です。設定ミスでプッシュ権限を奪われてしまった場合は、サーバ上の `/home/git/.gitosis.conf` を直接編集して元に戻します。Gitosis は、このファイルから情報を読み取っています。`gitosis.conf` ファイルへの変更がプッシュされてきたときに、その内容をこのファイルに書き出します。このファイルを手動で変更しても、次に `gitosis-admin` プロジェクトへのプッシュが成功した時点でその内容が書き換えられることになります。

## Git デーモン ##

認証の不要な読み取り専用アクセスを一般に公開する場合は、HTTP を捨てて Git プロトコルを使うことを考えることになるでしょう。主な理由は速度です。Git プロトコルのほうが HTTP に比べてずっと効率的で高速です。Git プロトコルを使えば、ユーザの時間を節約することになります。

Git プロトコルは、認証なしで読み取り専用アクセスを行うためのものです。ファイアウォールの外にサーバがあるのなら、一般に公開しているプロジェクトにのみ使うようにしましょう。ファイアウォール内で使うのなら、たとえば大量のメンバーやコンピュータ (継続的インテグレーションのビルドサーバなど) に対して SSH の鍵なしで読み取り専用アクセスを許可するという使い方もあるでしょう。

いずれにせよ、Git プロトコルは比較的容易にセットアップすることができます。デーモン化するためには、このようなコマンドを実行します。

	git daemon --reuseaddr --base-path=/opt/git/ /opt/git/

`--reuseaddr` は、前の接続がタイムアウトするのを待たずにサーバを再起動させるオプションです。`--base-path` オプションを指定すると、フルパスをしていしなくてもプロジェクトをクローンできるようになります。そして最後に指定したパスは、Git デーモンに公開させるリポジトリの場所です。ファイアウォールを使っているのなら、ポート 9418 に穴を開けなければなりません。

プロセスをデーモンにする方法は、OS によってさまざまです。Ubuntu の場合は Upstart スクリプトを使います。

	/etc/event.d/local-git-daemon

のようなファイルを用意して、このようなスクリプトを書きます。

	start on startup
	stop on shutdown
	exec /usr/bin/git daemon \
	    --user=git --group=git \
	    --reuseaddr \
	    --base-path=/opt/git/ \
	    /opt/git/
	respawn

セキュリティを考慮して、リポジトリに対する読み込み権限しかないユーザでこのデーモンを実行させるようにしましょう。新しいユーザ 'git-ro' を作り、このユーザでデーモンを実行させるとよいでしょう。ここでは、説明を簡単にするために Gitosis と同じユーザ 'git' で実行させることにします。

マシンを再起動すれば Git デーモンが自動的に立ち上がり、終了させても再び起動するようになります。再起動せずに実行させるには、次のコマンドを実行します。

	initctl start local-git-daemon

その他のシステムでは、`xinetd` や `sysvinit` システムのスクリプトなど、コマンドをデーモン化して監視できる仕組みを使います。

次に、どのプロジェクトに対して Git プロトコルでの認証なしアクセスを許可するのかを Gitosis に指定します。各リポジトリ用のセクションを追加すれば、Git デーモンからの読み込みアクセスを許可するように指定することができます。Git プロトコルでのアクセスを iphone プロジェクトに許可したい場合は、`gitosis.conf` の最後に次のように追加します。

	[repo iphone_project]
	daemon = yes

この変更をコミットしてプッシュすると、デーモンがこのプロジェクトへのアクセスを受け付けるようになります。

Gitosis を使わずに Git デーモンを設定したい場合は、Git デーモンで公開したいプロジェクトに対してこのコマンドを実行しなければなりません。

	$ cd /path/to/project.git
	$ touch git-daemon-export-ok

このファイルが存在するプロジェクトについては、Git は認証なしで公開してもよいものとみなします。

Gitosis を使うと、どのプロジェクトを GitWeb で見せるのかを指定することもできます。まずは次のような行を `/etc/gitweb.conf` に追加しましょう。

	$projects_list = "/home/git/gitosis/projects.list";
	$projectroot = "/home/git/repositories";
	$export_ok = "git-daemon-export-ok";
	@git_base_url_list = ('git://gitserver');

GitWeb でどのプロジェクトを見せるのかを設定するには、Gitosis の設定ファイルで `gitweb` を指定します。たとえば、iphone プロジェクトを GitWeb で見せたい場合は、`repo` の設定は次のようになります。

	[repo iphone_project]
	daemon = yes
	gitweb = yes

これをコミットしてプッシュすると、GitWeb で iphone プロジェクトが自動的に表示されるようになります。

## Git のホスティング ##

Git サーバを立ち上げる作業が面倒なら、外部の専用ホスティングサイトに Git プロジェクトを置くという選択肢があります。この方法には多くの利点があります。ホスティングサイトでプロジェクトを立ち上げるのは簡単ですし、サーバのメンテナンスや日々の監視も不要です。自前のサーバを持っているとしても、オープンソースのコードなどはホスティングサイトで公開したいこともあるかもしれません。そのほうがオープンソースコミュニティのメンバーに見つけてもらいやすく、そして支援を受けやすくなります。

今ではホスティングの選択肢が数多くあり、それぞれ利点もあれば欠点もあります。最新の情報を知るには、Git wiki で GitHosting のページを調べましょう。

	http://git.or.cz/gitwiki/GitHosting

これらすべてについて網羅することは不可能ですし、たまたま私自身がこの中のひとつで働いていることもあるので、ここでは GitHub を使ってアカウントの作成からプロジェクトの立ち上げまでの手順を説明します。どのような流れになるのかを見ていきましょう。

GitHub は最大のオープンソース Git ホスティングサイトで、公開リポジトリだけでなく非公開のリポジトリもホスティングできる数少ないサイトのひとつです。つまり、オープンソースのコードと非公開のコードを同じ場所で管理できるのです。実際、本書に関する非公開の共同作業についても GitHub を使っています。

### GitHub ###

GitHub がその他多くのコードホスティングサイトと異なるのは、プロジェクトの位置づけです。プロジェクトを主体に考えるのではなく、GitHub ではユーザ主体の構成になっています。私が GitHub に `grit` プロジェクトを公開したとして、それは `github.com/grit` ではなく `github.com/schacon/grit` となります。どのプロジェクトにも「正式な」バージョンというものはありません。たとえ最初の作者がプロジェクトを放棄したとしても、それをユーザからユーザへと自由に移動することができます。

GitHub は営利企業なので、非公開のリポジトリについては料金をとって管理しています。しかし、フリーのアカウントを取得すればオープンソースのプロジェクトを好きなだけ公開することができます。その方法についてこれから説明します。

### ユーザアカウントの作成 ###

まずはフリー版のユーザアカウントを作成しましょう。Pricing and Signup のページ `http://github.com/plans` で、フリーアカウントの "Sign Up" ボタンを押すと (図 4-2 を参照ください)、新規登録ページに移動します。

Insert 18333fig0402.png
図 4-2. GitHub のプラン説明ページ

ユーザ名を選び、メールアドレスを入力します。アカウントとパスワードがこのメールアドレスに関連づけられます (図 4-3 を参照ください)。

Insert 18333fig0403.png 
図 4-3. GitHub のユーザ登録フォーム

それが終われば、次に SSH の公開鍵を追加しましょう。新しい鍵を作成する方法については、さきほど「ちょっとしたセットアップ」のところで説明しましょう。公開鍵の内容をコピーし、SSH Public Key のテキストボックスに貼り付けます。"explain ssh keys" のリンクをクリックすると、主要 OS 上での公開鍵の作成手順を詳しく説明してくれます。"I agree, sign me up" ボタンをクリックすると、あなたのダッシュボードに移動します (図 4-4 を参照ください)。

Insert 18333fig0404.png 
図 4-4. GitHub のユーザダッシュボード

では次に、新しいリポジトリの作成に進みましょう。

### 新しいリポジトリの作成 ###

ダッシュボードで、Your Repositories の横にあるリンク "create a new one" をクリックしましょう。新規リポジトリの作成フォームに進みます (図 4-5 を参照ください)。

Insert 18333fig0405.png 
図 4-5. GitHub での新しいリポジトリの作成

ここで必要なのはプロジェクト名を決めることだけです。ただ、それ以外に説明文を追加することもできます。ここで "Create Repository" ボタンを押せば、GitHub 上での新しいリポジトリのできあがりです (図 4-6 を参照ください)。

Insert 18333fig0406.png 
図 4-6. GitHub でのプロジェクトのヘッダ情報

まだ何もコードが追加されていないので、ここでは「新しいプロジェクトを作る方法」「既存の Git プロジェクトをプッシュする方法」「Subversion の公開リポジトリからインポートする方法」が説明されています (図 4-7 を参照ください)。

Insert 18333fig0407.png 
図 4-7. 新しいリポジトリに関する説明

この説明は、本書でこれまでに説明してきたものとほぼ同じです。まだ Git プロジェクトでないプロジェクトを初期化するには、次のようにします。

	$ git init
	$ git add .
	$ git commit -m 'initial commit'

ローカルにある Git リポジトリを使用する場合は、GitHub をリモートに登録して master ブランチをプッシュします。

	$ git remote add origin git@github.com:testinguser/iphone_project.git
	$ git push origin master

これで GitHub 上でリポジトリが公開され、だれもがプロジェクトにアクセスできるような URL ができあがりました。この例の場合は `http://github.com/testinguser/iphone_project` です。各プロジェクトのページのヘッダには、ふたつの Git URL が表示されています (図 4-8 を参照ください)。

Insert 18333fig0408.png 
図 4-8. 公開 URL とプライベート URL が表示されたヘッダ

Public Clone URL は、読み込み専用の公開 URL で、これを使えば誰でもプロジェクトをクローンできます。この URL は、あなたのウェブサイトをはじめとしたお好みの場所で紹介することができます。

Your Clone URL は、読み書き可能な SSH の URL で、先ほどアップロードした公開鍵に対応する SSH 秘密鍵を使った場合にのみアクセスできます。他のユーザがこのプロジェクトのページを見てもこの URL は表示されず、公開 URL のみが見えるようになっています。

### Subversion からのインポート ###

GitHub では、Subversion で公開しているプロジェクトを Git にインポートすることもできます。先ほどの説明ページの最後のリンクをクリックすると、Subversion からのインポート用ページに進みます。このページにはインポート処理についての情報が表示されており、公開 Subversion リポジトリの URL を入力するテキストボックスが用意されています。

Insert 18333fig0409.png 
図 4-9. Subversion からのインポート

もしそのプロジェクトが非常に大規模なものであったり標準とは異なるものであったり、あるいは公開されていないものであったりした場合は、この手順ではうまくいかないでしょう。第 7 章で、手動でのプロジェクトのインポート手順について詳しく説明します。

### 共同作業者の追加 ###

では、チームの他のメンバーを追加しましょう。John、Josie そして Jessica は全員すでに GitHub のアカウントを持っており、彼らもこのリポジトリにプッシュできるようにしたければ、プロジェクトの共同作業者として登録します。そうすれば、彼らの公開鍵をつかったプッシュも可能となります。

プロジェクトのヘッダにある "edit" ボタンをクリックするかプロジェクトの上の Admin タブを選択すると、GitHub プロジェクトの管理者用ページに移動します (図 4-10 を参照ください)。

Insert 18333fig0410.png 
図 4-10. GitHub の管理者用ページ

別のユーザにプロジェクトへの書き込み権限を付与するには、“Add another collaborator”リンクをクリックします。新しいテキストボックスがあらわれるので、そこにユーザ名を記入します。何か入力すると、マッチするユーザ名の候補がポップアップ表示されます。ユーザが見つかれば、Add ボタンをクリックすればそのユーザを共同作業者に追加できます (図 4-11 を参照ください)。

Insert 18333fig0411.png 
図 4-11. プロジェクトへの共同作業者の追加

対象者を全員追加し終えたら、Repository Collaborators のところにその一覧が見えるはずです (図 4-12 を参照ください)。

Insert 18333fig0412.png 
図 4-12. プロジェクトの共同作業者一覧

誰かのアクセス権を剥奪したい場合は、"revoke" リンクをクリックすればそのユーザはプッシュできなくなります。また、今後新たにプロジェクトを作ったときに、この共同作業者一覧をコピーして使うこともできます。

### あなたのプロジェクト ###

プロジェクトをプッシュするか、あるいは Subversion からのインポートを済ませると、プロジェクトのメインページは図 Figure 4-13 のようになります。

Insert 18333fig0413.png 
図 4-13. GitHub プロジェクトのメインページ

他の人がこのプロジェクトにアクセスしたときに見えるのがこのページとなります。このページには、さまざまな情報を見るためのタブが用意されています。Commits タブに表示されるのはコミットの一覧で、`git log` コマンドの出力と同様にコミット時刻が新しい順に表示されます。Network タブには、このプロジェクトをフォークして何か貢献してくれた人の一覧が表示されます。Downloads タブには、プロジェクト内でタグが打たれている任意の点について tar や zip でまとめたものをアップロードすることができます。Wiki タブには、プロジェクトに関するドキュメントやその他の情報を書き込むための wiki が用意されています。Graphs タブは、プロジェクトに対する貢献やその他の統計情報を視覚化して表示します。そして、Source タブにはプロジェクトのメインディレクトリの一覧が表示され、もし README ファイルがあればその内容が下に表示されます。このタブでは、最新のコミットについての情報も表示されます。

### Forking Projects ###

If you want to contribute to an existing project to which you don’t have push access, GitHub encourages forking the project. When you land on a project page that looks interesting and you want to hack on it a bit, you can click the "fork" button in the project header to have GitHub copy that project to your user so you can push to it.

This way, projects don’t have to worry about adding users as collaborators to give them push access. People can fork a project and push to it, and the main project maintainer can pull in those changes by adding them as remotes and merging in their work.

To fork a project, visit the project page (in this case, mojombo/chronic) and click the "fork" button in the header (see Figure 4-14).

Insert 18333fig0414.png 
Figure 4-14. Get a writable copy of any repository by clicking the "fork" button.

After a few seconds, you’re taken to your new project page, which indicates that this project is a fork of another one (see Figure 4-15).

Insert 18333fig0415.png 
Figure 4-15. Your fork of a project.

### GitHub Summary ###

That’s all we’ll cover about GitHub, but it’s important to note how quickly you can do all this. You can create an account, add a new project, and push to it in a matter of minutes. If your project is open source, you also get a huge community of developers who now have visibility into your project and may well fork it and help contribute to it. At the very least, this may be a way to get up and running with Git and try it out quickly.

## Summary ##

You have several options to get a remote Git repository up and running so that you can collaborate with others or share your work.

Running your own server gives you a lot of control and allows you to run the server within your own firewall, but such a server generally requires a fair amount of your time to set up and maintain. If you place your data on a hosted server, it’s easy to set up and maintain; however, you have to be able to keep your code on someone else’s servers, and some organizations don’t allow that.

It should be fairly straightforward to determine which solution or combination of solutions is appropriate for you and your organization.
