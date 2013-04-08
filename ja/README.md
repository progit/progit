書籍「Pro Git」のコンテンツ
===========================

(トップディレクトリにあるREADMEの日本語訳です)

これは、書籍「Pro Git」のコンテンツのソースコードです。
Creative Commons Attribution-Non Commercial-Share Alike 3.0 license のもとで公開
しています。お楽しみください。本書が Git を学ぶ手助けとなることを期待します。また、
Apress や私を支援してくださる意味でも、ぜひ書籍版を Amazon からご購入ください。

http://tinyurl.com/amazonprogit

訳注: 上のtinyurlは、amazon.comのアフィリエイトIDつきのURLにリダイレクトされます。

このコンテンツは以下のURLでも公開されており､翻訳版も10ヶ国語分公開されています｡

http://git-scm.com/book/

Ebookのつくりかた
=====================

Fedora なら、たとえばこのようにします。

    $ yum install ruby calibre rubygems ruby-devel rubygem-ruby-debug rubygem-rdiscount
    $ gem install rdiscount
    $ makeebooks en  # これで mobi ファイルができあがります

Mac OSなら､このようにできます｡

1. rubyとrubygems をインストールします｡
2. `$ gem install rdiscount`
3. Calibre for MacOSをダウンロードし､コマンドラインツールをインストールします｡
4. `$ makeebooks zh` #こうするとmobiファイルができあがります｡

不具合
=====================
技術的な間違いやその他の修正を要する点を発見した場合は、[issueを作成](https://github.com/progit/progit/issues)してください｡
そうすればメンテナーの誰かが確認してくれるでしょう｡

訳注: 当然、issueは英語で書いてください :-) 日本語訳に関する指摘は、日本語版の
翻訳に参加しているメンバーの誰かにメッセージを送っていただけるとありがたいです。

翻訳
=====================
この本を翻訳してくだされば、その翻訳を git-scm.com のサイトで公開させて
いただきます。このプロジェクトの適切なサブディレクトリ( [ISO 639](http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) で命名してください｡)に翻訳を保存し、
pull requestを送ってください｡

訳注: 日本語訳はjaサブディレクトリを使用してください｡

pull requestの送り方
=====================
- 翻訳ファイルの文字コードはUTF-8にしてください｡
- 原文の変更と翻訳の変更､pull requestは分けてください｡
- 翻訳の変更をpull requestにして送る場合､pull requestのタイトルとコミットメッセージに国別の接頭詞をつけてください｡ 例) [ja] Update chapter 2.
- 翻訳の変更は､マージ時にコンフリクトが発生しないよう注意してください｡メンテナーはコンフリクトの解消を行いません｡
- ファイルが変更されてもPDF/電子書籍への変換､git-scm.comの更新がうまくいくよう､可能な限り確認してください｡

