This is a translation of the original [README.md](../README.md) in English with
some additional information about the Korean translation.

# Pro Git

이곳에 담긴 내용물은 「Pro Git」 한국어판의 소스 코드로, 원본은 영어판 「Pro Git」입니다. 원작과
본 번역물은 [크리에이티브 커먼즈 저작자표시-비영리-동일조건변경허락 3.0 (CC BY-NC-SA
3.0)](https://creativecommons.org/licenses/by-nc-sa/3.0/) 조건에 따라 이용할 수
있습니다.

이 책을 통해 Git을 즐겁게 배울 수 있기를 바랍니다. [출판된 책을 Amazon에서 구입](http://tinyurl.com/amazonprogit)하시면
원저자인 Scott Chacon과 Apress 출판사에게 큰 도움이 됩니다.
[git-scm.com](http://git-scm.com/book/)에서 영어, 한국어 및 10여개의 다른 언어로 온라인에서
읽을 수도 있습니다.

# 전자책 만들기

페도라(16 이상)에서는 아래와 같이 할 수 있습니다.

    $ yum install ruby calibre rubygems ruby-devel rubygem-ruby-debug rubygem-rdiscount
    $ ./makeebooks en  # mobi 파일 생성

맥에서는 아래의 설명을 따르세요.

1. ruby와 rubygems을 설치
2. 터미널에서 `gem install rdiscount` 실행
3. 맥용 Calibre를 다운로드 및 명령줄 도구 설치. PDF를 만들려면 다음 소프트웨어도 설치해야 합니다:
    * pandoc: http://johnmacfarlane.net/pandoc/installing.html
    * xelatex: http://tug.org/mactex/
4. 터미널에서 `./makeebooks ko` 실행 (mobi 파일 생성)

## Pandoc 관련 노트

Pandoc 버전 1.9.1.1에서 확인된 [버그](https://github.com/jgm/pandoc/issues/964)로 인해
~표 이후의 글자가 사라지는 현상이 있습니다. 버전 1.11.1 이상을 사용해주세요. `pandoc -v` 명령으로
현재 버전을 알 수 있습니다.

## 역주

* 모든 명령어는 프로젝트의 루트 디렉토리에서 실행되어야 합니다.
* 한국어판 PDF를 만들려면 [나눔바른고딕](http://hangeul.naver.com),
  [나눔코딕코딩](http://dev.naver.com/projects/nanumfont/download) 글꼴이 필요합니다.

# 정오표

이 책에서 잘못된 점이나 수정되어야 하는 부분을 발견한 경우, GitHub 저장소에 [이슈를
등록](https://github.com/progit/progit/issues/new)해주세요.

# 번역

이 책을 새로운 언어로 번역하고 싶다면 [ISO 639](http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes)
코드에 맞는 이름으로 프로젝트의 루트 디렉토리에 새 디렉토리를 만든 뒤 pull request를 보내주세요.
번역된 책은 git-scm.com 웹사이트에 게시되어 누구나 볼 수 있게 됩니다.

# pull request 보내기

* 모든 파일은 UTF-8 인코딩을 사용해야 합니다.
* 영어 원본과 번역본의 변경 사항은 각각 다른 pull request로 보내주세요.
* 번역본을 수정할 때는 commit 메시지와 pull request의 제목을 해당 언어의 ISO 639 코드로
  시작해주세요. 예를 들어 한국어판의 내용을 수정했을 경우 `[ko] improve wording`처럼 제목을
  달면 됩니다.
* 변경 사항이 conflict 없이 자동으로 merge될 수 있어야 합니다.
* PDF 만들기, 전자책 만들기, git-scm.com 웹사이트 등이 잘 작동하는지 꼭 확인해주세요.

# 한국어판 출판 및 역자 정보

도서출판 인사이트를 통해서
[한국어판](http://www.insightbook.co.kr/books/programming-insight/프로-git)이
2013년 4월 19일에 출판되었습니다. 출판된 책을 구입하시면 인사이트와 역자들에게 도움이 됩니다.

## 역자 소개

* [박창우(Changwoo Park)](https://github.com/pismute), pismute at gmail dot com
* [이성환(Sean Lee)](https://github.com/lethee), lethee at gmail dot com
* [최용재(Yongjae choi)](https://github.com/lnyarl), lnyarl at gmail dot com
