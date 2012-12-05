# Poznámky k překladu #

Tento český překlad naleznete v elektronické podobě na http://git-scm.com/book. Jeho zdrojové texty jsou spolu s texty originálu a se zdrojovými texty překladů do ostatních jazyků dostupné na GitHub (https://github.com/progit/progit).

## Historie překladu na GitHub ##

První kroky k překladu Pro Git ve výše zmíněném GitHub projektu pocházejí z klávesnice Jana Matějky ml. (alias Mosquitoe):

    Author: Jan Matějka ml. aka Mosquitoe <...@gmail.com>  2009-08-21 12:15:41
    Committer: Jan Matějka ml. aka Mosquitoe <...@gmail.com>  2009-08-21 12:15:41
    ...
    Branches: master, remotes/origin/master
    Follows:
    Precedes:

        [cs] Initial commit of the Czech version

Vzhledem k následujícím skutečnostem překladu zanechal...

## První kompletní překlad z Edice CZ.NIC ##

Z iniciativy sdružení CZ.NIC byl financován překlad celé knihy, která vyšla jako druhá kniha Edice CZ.NIC v roce 2009, (ISBN: 978-80-904248-1-4). Můžete si ji objednat v tištěné podobě -- viz http://knihy.nic.cz/. Je zde dostupná i volně, v podobě PDF souboru. V předmluvě najdete popis motivace k překladu. Na zadním přebalu knihy naleznete také následující souhrnné informace o autorovi, o knize a o Edici CZ.NIC...

**O autorovi:** Scott Chacon je popularizátorem systému správy verzí Git a pracuje také jako vývojář v Ruby na projektu GitHub.com. Ten umožňuje hosting, sdílení a kooperaci při vývoji kódu v systému Git. Scott je autorem dokumentu Git Internals Peepcode PDF, správcem domovské stránky Git a online knihy Git Community Book. O Gitu přednášel například na konferencích RailsConf, RubyConf, Scotland on Rails, Ruby Kaigi nebo OSCON. Pořádá také školení systému Git pro firmy.

**O knize:** Git je distribuovaný systém pro správu verzí, který se používá zejména při vývoji svobodného a open source softwaru. Git si klade za cíl být rychlým a efektivním nástrojem pro správu verzí. V knize se čtenář seznámí jak se stát rychlým a efektivním při jeho používání. Seznámí se nejen s principy používání, ale také s detaily jak Git funguje interně nebo s možnostmi, které nabízejí některé další doplňkové nástroje.

**O edici:** Edice CZ.NIC je jedním z osvětových projektů správce české domény nejvyšší úrovně. Cílem tohoto projektu je vydávat odborné, ale i populární publikace spojené s internetem a jeho technologiemi. Kromě tištěných verzí vychází v této edici současně i elektronická podoba knih. Ty je možné najít na stránkách knihy.nic.cz

## Zpětná synchronizace s originálem ##

Vzhledem k licenci dokumentu (Attribution-NonCommercial-ShareAlike 3.0 United States (CC BY-NC-SA 3.0)) se nabízí možnost českého překladu vydaného v Edici CZ.NIC dále nekomerčně využít.

V říjnu 2012 zahájil Petr Přikryl převod výše zmíněného PDF do podoby textového souboru využívajícího syntaxe *markdown* (viz https://github.com/pepr/progitCZ/). Prvotním cílem bylo dostat úplný, kvalitní český překlad přímo na server http://git-scm.com/. Druhým cílem byla synchronizace s originálem a doplnění oprav a úprav, které se od doby vydání překladu v Edici CZ.NIC objevily. Třetí cíl vyplývá z prvního a druhého: učinit text překladu živým a dostupným všem, kteří jej budou chtít upravovat a vylepšovat.

Obsah PDF souboru byl nejdříve vyexportován jako text ("Uložit jako - Text..."). Poté byly pro ten účel vytvořenými pythonovskými skripty extrahovány prvky dokumentu (nadpisy, odstavce, odrážky,...) a odstraněny prvky vzniklé sazbou (záhlaví stránek, čísla jednotlivých stránek, ...). V několika mezifázích byl původní text ručně upravován a dalšími pythonovskými skripty převáděn do "čistší" podoby -- bližší strukturou a značkování originálu. Při synchronizaci byla zajištěna identická podoba příkladů kódu. Při kontrole značkování v běžném textu byl původní překlad někdy změněn tak, aby přesněji odpovídal originálu v technickém smyslu (formulace *hlavní větev* nahrazena `master` tam, kde bylo v originálu uvedeno `master`). Synchronizace byla dokončena na začátku prosince 2012.
