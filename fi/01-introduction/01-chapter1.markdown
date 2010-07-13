# Alkusanat #

Tämä luku auttaa sinut pääsemään alkuun Gitin kanssa. Me aloitamme aluksi selittämällä vähän versionhallinta työkalujen taustaa, jonka jälkeen siirrymme siihen, kuinka saat Gitin järjestelmääsi ja lopulta, kuinka se asennetaan työskentely valmiiksi. Tämän luvun lopussa sinun tulisi ymmärtää miksi Git on olemassa, miksi sinun tulisi sitä käyttää ja kaikki pitäis olla valmista, jotta voisit sitä käyttää.

## Versionhallinnasta ##

Mitä on versionhallinta ja miksi sinun pitäisi siitä välittää? Versionhallinta on menetelmä, joka ajan kuluessa tallentaa muutoksia tiedostoon tai joukkoon tiedostoja, jotta sinä voit palata tiettyihin versioihin myöhemmin. Esimerkkeinä tässä kirjassa, sinä käytät ohjelmiston lähdekoodia tiedostoina, jotka ovat versiohallittavana, vaikkakin todellisuudessa sinä voit tehdä tämän melkeinpä millä tahansa tiedostolla tietokoneellasi.

Jos sinä olet graafinen- tai web suunnittelija ja haluat säilyttää jokaisen version kuvasta tai leiskasta (minkä sinä mitä varmimmin haluat), versionhallintamenetelmä (VCS) on erittäin viisas asia käytettäväksi. Se mahdollistaa, että voit palauttaa tiedoston takaisin edelliseen tilaan, palauttaa koko projektin takaisin edelliseen tilaan, vertailla muutoksia ajan kuluessa, nähdä kuka viimeksi muokkasi jotain mikä voi olla ongelman aiheuttaja, kuka esitteli ongelman ja milloin, ja muuta. VCS:n käyttö pääasiassa tarkoittaa sitä, että jos sinä sotket jotain tai menetät tiedostoja, voit helposti palautua edelliseen toimivaan tilaan. Lisäksi, saat kaiken tämän erittäin vähällä ylläpidolla.

### Paikalliset versionhallinta järjestelmät ###

Monen ihmisen versionhallintaratkaisu on kopioida tiedostoja toiseen kansioon (ehkäpä aikaleimattu kansio, jos he ovat fiksuja). Tämä lähestymistapa on erittäin yleinen, koska se on niin yksinkertainen, mutta se on myös erittäin virhealtis. On helppo unohtaa missä hakemistossa olet ja epähuomiossa kirjoittaa väärään tiedostoon tai kopioida sellaisten tiedostojen päälle, joihin et tarkoittanut koskea.

Tämän ongelman ratkaisemiksi, ohjelmoijat kauan sitten kehittivät paikallisen VCS:n, jolla oli yksinkertainen tietokanta, joka piti kaikki tiedostojen muutokset muutostenhallinnan alla (katso Kuva 1-1).

Insert 18333fig0101.png 
Kuva 1-1. Paikallinen versionhallinta diagrammi.

Yksi suosituimmista VCS työkaluista oli rcs:ksi kutsuttu järjestelmä, joka on yhä tänä päivänä toimitettu monen tietokoneen mukana. Jopa suosittu Mac OS X käyttöjärjestelmä sisältää rcs komennon, Developer Tools paketin asennuksen jälkeen. Tämä työkalu periaatteessa toimii pitämällä pätsi kokoelmia (muutoksia tiedostojen välillä) yhdestä muutoksesta toiseen, erikoisformaatissa kiintolevyllä; se voi täten uudelleen luoda sen, miltä mikä tahansa tiedosto näytti, millä tahansa ajan hetkellä, lisäämällä kaikki tarvittavat pätsit.

### Keskitetyt versionhallinta järjestelmät ###

Seuraava suuri ongelma mihin ihmiset törmäävät on, että heillä on tarve tehdä yhteistyötä muissa järjestelmissä olevien kehittäjien kanssa. Tämän ongelman ratkaisemiseksi luotiin keskitetyt versionhallinta järjestelmät (CVCS). Nämä järjestelmät, kuten CVS, Subversion, ja Perforce, omaavat yksittäisen palvelimen joka sisältää kaikki versioidut tiedostot, ja asiakkaita jotka hakevat tiedostot tästä keskitetystä paikasta. Monet vuodet, tämä on ollut versionhallinnan standardi (katso Kuva 1-2).

Insert 18333fig0102.png 
Kuva 1-2. Keskitetyn versionhallinnan diagrammi.

Tämä asetelma tarjoaa monta etua, erityisesti paikalliseen VCS:n verrattuna. Esimerkiksi, jokainen tietää, jossain määrin, mitä kukin projektissa oleva tekee. Järjestelmänvalvojilla on hienosäädetty kontrolli siihen, mitä kukin voi tehdä; ja on paljon helpompi valvoa CVCS:ä, kuin toimia joka asiakkaan paikallisen tietokannan kanssa.

Kuitenkin, tässä asetelmassa on myös muutama vakava haittapuoli. Kaikkein selvin on keskitetty vikapiste, jota keskitetty palvelin edustaa. Jos kyseessä oleva palvelin ajetaan alas tunniksi, niin tämän tunnin aikana kukaan ei pysty tekemään yhteistyötä keskenään tai tallentamaan versioituja muutoksia mihinkään mitä he työskentelevät. Jos kiintolevy - jolla keskitetty tietokanta sijaitsee - korruptoituu, ja kunnollisia varmuuskopioita ei ole hallussa, menetät täysin kaiken - koko projektin historian, paitsi ne yksittäiset tilannekuvat joita ihmisillä sattuu olemaan heidän paikallisilla koneillaan. Paikalliset VCS järjestelmät kärsivät tästä samasta ongelmasta - milloin tahansa sinulla on koko projektin historia yhdessä paikassa, sinulla on riski menettää se kaikki.

### Hajautetut versionhallinta järjestelmät ###

Tämä on missä hajautetut versionhallinta järjestelmät (DVCS) astuvat mukaan. DVCS:ssä (kuten Git, Mercurial, Bazaar tai Darcs), asiakkaat eivät vain hae viimeisintä tilannekuvaa tiedostoista: he täysin peilaavat koko tietolähteen. Täten, jos mikä tahansa palvelin kuolee, ja nämä järjestelmät tekivät yhteistyötä sen läpi, mikä tahansa asiakas tietolähde pystytään kopioimaan takaisin palvelimelle tiedon palauttamiseksi. Jokainen tiedonhaku on tosiasiassa täysi varmuuskopio kaikesta datasta (katso Kuva 1-3).

Insert 18333fig0103.png 
Kuva 1-3. Hajautettu versionhallinta diagrammi.

Lisäksi, monet näistä järjestelmistä selviytyvät melko hyvin siitä, että niillä on monia etätietolähteitä, joiden kanssa ne voivat työskennellä, joten sinä voit tehdä monenlaista yhteistyötä monenlaisien ihmisryhmien kanssa samaan aikaan, samassa projektissa. Tämä mahdollistaa sen että voit aloittaa monelaisia työnkulkuja, jotka eivät ole mahdollisia keskitetyissä järjestelmissä, kuten hierarkiset mallit.

## Gitin lyhyt historia ##

Kuten moni muu suuri asia elämässä, Git alkoi hippusella luovaa tuhoamista ja liekehtivää erimielisyyttä. Linux kernel on kohtalaisen suuren mittakaavan avoimen lähdekoodin projekti. Suurimman osan Linux kernelin ylläpidon elinkaaresta (1991-2002), muutokset ohjelmistoon olivat siirretty ympäriinsä pätseinä ja pakattuina tiedostoina. Vuonna 2002, Linux kernel projekti alkoi käyttämään BitKeeperiksi kutsuttua yksityistä DVCS järjestelmää.

Vuonna 2005, suhde Linux kerneliä kehittävän yhteisön ja kaupallisen BitKeeperiä kehittävän yhtiön välillä katkesi, ja ilmaisen statuksen työkalut olivat kumottu. Tämä johdatti Linuxin kehittäjä yhteisön (ja erityisesti Linus Torvaldsin, Linuxin luojan) kehittämään heidän omaa työkalua, perustuen oppeihin, joita he oppivat BitKeeperin käyttö-aikanaan. Muutamat uuden järjestelmän tavoitteista olivat seuraavanlaiset:

* Nopeus
* Yksinkertainen design
* Vahva tuki epälineaariselle kehitykselle (tuhansia rinnakkaisia haaroja)
* Täysin hajautettu
* Pystyy tehokkaasti selviytymään suurista projekteista kuten Linuxin kernel (nopeus ja tiedon koko)

Syntymästään lähtien 2005, Git on kehittynyt ja aikuistunut helpoksi käyttää ja silti säilyttämään nämä alkuperäiset ominaisuudet. Se on uskomattoman nopea, se on erittäin tehokas suurien projektien kanssa, ja se on uskomattoman haarautuva järjestelmä epälineaariselle kehitykselle (Katso Luku 3).

## Git perusteet ##

Joten, mitä on Git pähkinänkuoressa? Tämä on tärkeä osa-alue omaksua, koska jos ymmärrät mitä Git on ja periaatteet kuinka se toimii, Gitin tehokas käyttö tulee mahdollisesti olemaan paljon helpompaa. Kun opettelet Gitin käyttöä, yritä tyhjentää mielesi asioista, joita mahdollisesti tiedät muista VCS:stä, kuten Subversionista ja Perforcesta; tämän tekeminen auttaa sinua välttämään hienoisen sekaantumisen kun käytät työkalua. Git säilyttää ja ajattelee informaatiota huomattavasti erilailla kuin nämä muut järjestelät, vaikkakin käyttöliittymä on melko samanlainen; näiden eroavaisuuksien ymmärtäminen auttaa sinua välttämään sekaantumisia käyttäessäsi Gittiä.

### Tilannekuvia, ei eroavaisuuksia ###

Suurin eroavaisuus Gitin ja minkä tahansa muun VCS:n (Subversion ja ystävät mukaanlukien) on tapa jolla Git ajattelee dataansa. Käsitteellisesti, moni muu järjestelmä varastoi informaatiotansa listana tiedostopohjaisista muutoksista. Nämä järjestelmät (CVS, Subversion, Perforce, Bazaar, ja niin edelleen) ajattelevat informaatiota jota ne varastoivat, kokoelmana tiedostoja ja ajan kuluessa jokaiseen tiedostoon tehtyinä muutoksina, kuten kuvattu Kuvassa 1-4.

Insert 18333fig0104.png 
Kuva 1-4. Muut järjestelmät tapaavat varastoida dataa muutoksina joka tiedoston alkuperäiseen versioon.

Git ei ajattele tai varastoi dataansa tällä tavalla. Sen sijaan, Git ajattelee dataansa enemmän kokoelmana tilannekuvia pikkuruisesta tiedostojärjestelmästä. Joka kerta kun sinä teet pysyvän muutoksen (commit), tai tallennat projektisi tilan Gitissä, Git periaatteessa ottaa kuvan siitä miltä sinun tiedostosi näyttävät kyseisellä hetkellä ja varastoi viitteen tähän tilannekuvaan. Ollakseen tehokas, jos tiedostoja ei ole muutettu, Git ei varastoi tiedostoa uudestaan - vaan linkittää sen edelliseen identtiseen tiedostoon jonka se on jo varastoinut. Git ajattelee dataansa enemmän kuten Kuva 1-5 osoittaa.

Insert 18333fig0105.png 
Kuva 1-5. Git varastoi dataa projektin tilannekuvina ajan kuluessa.

Tämä on tärkeä ero Gitin ja melkein minkä tahansa muun VCS:n välilä. Se pistää Gitin harkitsemaan uudelleen melkein joka versionhallinan aspektia, jotka monet muut järjestelmät kopioivat edeltäneestä sukupolvesta. Tämä tekee Gitistä kuin pikkuruisen tiedostojärjestelmän, jolla on muutamia uskomattoman tehokkaita työkaluja päälle rakennettuna, ennemmin kuin simppelin VCS:n. Me tutkimme joitain hyötyjä, joita saavutat ajattelemalla datastasi tällätavoin, kun käsittelemme Gitin haarautumista Luvussa 3.

### Lähes jokainen operaatio on paikallinen ###

Monet operaatiot Gitissä tarvitsevat ainoastaa paikallisia tiedostoja ja resursseja operoidakseen - yleensä mitään informaatiota toiselta koneelta tietoverkostasi ei tarvita. Jos olet tottunut CVCS:n, joissa suurin osa operaatioista sisältää tietoverkon viiveen, tämä Gitin aspekti laittaa sinut ajattelemaan, jotta nopeuden jumalat ovat siunanneet Gitin sanoinkuvaamattomilla voimilla. Koska sinulla on projektisi koko historia paikallisella levylläsi, suurinosa operaatioista näyttää melkein välittömiltä.

Esimerkiksi, selataksesi projektisi historiaa, Gitin ei tarvitse mennä ulkoiselle palvelimelle ottaakseen historian ja näyttääkseen sen sinulle - se yksinkertaisesti lukee sen suoraan sinun paikallisesta tietokannastasi. Tämä tarkoittaa, että näet projektin historian melkein välittömästi. Jos haluat nähdä muutokset tiedoston nykyisen version ja kuukausi sitten olleen version välillä, Git voi katsoa tiedoston tilannekuvan kuukausi sitten ja tehdä paikallisen muutoslaskelman, sen sijaan, jotta sen pitäisi joko kysyä etäpalvelimelta sitä tai jotta sen tarvitsisi vetää vanhempi versio etäpalvelimelta, jotta se voisi tehdä sen paikallisesti.

Tämä myös tarkoittaa sitä, että on hyvin vähän asioita joita et voi tehdä, jos olet yhteydetön tai poissa VPN:stä. Jos nouset lentokoneeseen tai junaan ja haluat tehdä vähän töitä, voit iloisesti tehdä pysyviä muutoksia kunnes saat tietoverkon takaisin ja voit lähettää muutoksesi. Jos menet kotiin ja et saa VPN asiakasohjelmaasi toimimaan oikein, voit yhä työskennellä. Monissa muissa järjestelmissä, tämän tekeminen on joko mahdotonta tai kivuliasta. Perforcessa, esimerkiksi, et voi tehdä paljoa mitään, silloin kun et ole yhteydessä palvelimeen; Subversiossa ja CVS:ssä voit editoida tiedostojasi, mutta et voi tehdä pysyviä muutoksia tietokantaasi (koska tietokantasi on yhteydetön). Tämä kaikki saattaa vaikuttaa, ettei se ole nyt niin suuri juttu, mutta saatat yllättyä kuin suuren muutoksen se voi tehdä.

### Git on eheä ###

Kaikki Gitissä on tarkistussummattu ennen kuin se on varastoitu ja on tämän jälkeen viitattu tällä tarkistussummalla. Tämä tarkoittaa, että on mahdotonta muuttaa minkään tiedoston sisältöä tai kansiota ilman, ettei Git tietäisi siitä. Tämä toiminnallisuus on rakennettu Gittiin alimmalla tasolla ja se on kiinteä osa sen filosofiaa. Et voi menettää informaatiota tiedonsiirrossa tai saada tiedostoihisi korruptiota, ilman ettei Git pystyisi sitä huomaamaan.

Mekanismi jota Git käyttää tarkistussummaan on kutsuttu SHA-1 tarkisteeksi. Tämä on 40-merkkinen merkkijono, joka koostuu hexadesimaali merkeistä (0-9 ja a-f) ja joka on Gitissä laskettu tiedoston sisältöön tai hakemisto rakenteeseen pohjautuen. SHA-1 tarkiste voi näyttää tällaiselta:

	24b9da6552252987aa493b52f8696cd6d3b00373

Voit nähdä nämä tarkiste arvot jokapuolella Gitissä, koska se käyttää niitä niin paljon. Itseasiassa, Git varastoi kaiken, ei pohjautuen tiedoston nimeen, vaan Gitin tietokantaan osoitteistavaan sisällön tarkiste arvoon.

### Git yleensä vain lisää dataa ###

Kun teet toimintoja Gitissä, melkein kaikki niistä ainoastaan lisää dataa Gitin tietokantaan. On erittäin vaikea saada järjestelmä tekemään mitään, mikä olisi kumoamaton tai saada se poistamaan dataa millään tavoin. Kuten missä tahansa VCS:ssä, voit menettää tai sotkea muutoksia, joita ei ole vielä tehty pysyviksi; mutta sen jälkeen kun teet pysyvän tilannekuvan muutoksen Gittiin, se on erittäin vaikeaa hävittää, etenkin jos sinä säännöllisesti työnnät tietokantasi toiseen tietolähteeseen.

Tämä tekee Gitin käyttämisestä hauskaa, koska me tiedämme, että voimme kokeilla erillaisia asioita ilman vaaraa, että vakavasti sotkisimme versionhallintamme. Syvääluotaavamman tarkastelun siihen miten Git varastoi dataansa ja kuinka voit palautua datan joka näyttää hävinneeltä, katso "Kuorien alla" Kappaleesta 9.

### Kolme tilaa ###

Nyt, lue huolellisesti. Tämä on pääasia muistaa Gitistä, jos sinä haluat lopun opiskelu prosessistasi menevän sulavasti. Gitillä on kolme pääasiallista tilaa, joissa tiedostosi voivat olla: pysyvästi muutettu, muutettu, ja lavastettu. Pysyvästi muutettu tarkoittaa, että data on turvallisesti varastoitu sinun paikalliseen tietokantaasi. Muutettu tarkoittaa, että olet muuttanut tiedostoa, mutta et ole tehnyt vielä pysyvää muutosta tietokantaasi. Lavastettu tarkoittaa, että olet merkannut muutetun tiedoston nykyisessä versiossaan menemään seuraavaan pysyvään tilannekuvaan.

Tämä johdattaa meidät kolmeen seuraavaan osaan Git projektia: Git hakemisto, työskentely hakemisto, ja lavastus alue.

Insert 18333fig0106.png 
Kuva 1-6. Työskentely hakemisto, lavastus alue, ja git hakemisto.

Git hakemisto on paikka, mihin Git varastoi metadatan ja olio tietokannan projektillesi. Tämä on kaikkein tärkein osa Gittiä, ja se sisältää sen, mitä kopioidaan, kun kloonaat tietovaraston toiselta tietokoneelta.

Työskentely hakemisto on yksittäinen tiedonhaku yhdestä projektin versiosta. Nämä tiedostot ovat vedetty ulos pakatusta tietokannasta Git hakemistosta ja sijoitettu levylle sinun käytettäväksesi tai muokattavaksesi.

Lavastus alue on yksinkertainen tiedosto, yleensä se sisältyy Git hakemistoosi, joka varastoi informaatiota siitä, mitä menee seuraavaan pysyvään muutokseen. Sitä on joskus viitattu indeksiksi, mutta on tulossa standardiksi viitata sitä lavastus alueeksi.

Normaali Git työnkulku menee jokseenkin näin:

1.	Muokkaat tiedostoja työskentely hakemistossasi.
2.	Lavastat tiedostosi, lisäten niistä tilannekuvia lavastus alueellesi.
3.	Teet pysyvän muutoksen, joka ottaa tiedostot kuin ne ovat lavastus alueella ja varastoi tämän tilannekuvan pysyvästi sinun Git tietolähteeseesi.

Jos tietty versio tiedostosta on git hakemistossa, se on yhtä kuin pysyvä muutos. Jos sitä on muokattu, mutta se on lisätty lavastus alueelle, se on lavastettu. Ja jos se on muuttunut siitä kun se on haettu, mutta sitä ei ole lavastettu, se on muutettu. Luvussa 2, opit enemmän näistä tiloista ja kuinka voit hyödyntää niitä tai skipata lavastus osan kokonaan.

## Gitin asennus ##

Ryhdytäänpä käyttämään Gittiä. Ensimmäiset asiat ensin - sinun täytyy asentaa se. Voit saada sen monella tavalla; kaksi yleisintä tapaa on asentaa se suoraan lähdekoodista tai asentaa jo olemassa oleva paketti sovellusalustallesi.

### Asennus suoraan lähdekoodista ###

Jos voit, on yleensä hyödyllistä asentaa Git suoraan lähedekoodista, koska näin saat kaikkein viimeisimmän version. Jokainen Gitin versio tapaa sisältää hyödyllisiä käyttöliittymä parannuksia, joten uusimman version hakeminen on yleensä paras reitti, jos tunnet olosi turvalliseksi kääntäessäsi ohjelmistoa sen lähdekoodista. On yleinen tilanne, että moni Linux jakelu sisältää erittäin vanhoja paketteja; joten, jollet käytä erittäin päivitettyä jakelua tai ellet käytä backportteja, lähdekoodista asennus voi olla paras ratkaisu.

Asentaaksesi Gitin, tarvitset seuraavat kirjastot joista Git on riippuvainen: curl, zlib, openssl, expat, ja libiconv. Esimerkiksi, jos olet järjestelmässä, jossa on yum (kuten Fedora) tai apt-get (kuten Debian pohjaiset järjestelmät), voit käyttää yhtä näistä komennoista asentaaksesi kaikki riippuvaisuudet:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev

Kun sinulla on kaikki tarvittavat riippuvuudet, voit mennä eteenpäin ja kiskaista uusimman tilannekuvan Gitin verkkosivuilta:

	http://git-scm.com/download

Tämän jälkeen, käännä ja asenna:

	$ tar -zxf git-1.6.0.5.tar.gz
	$ cd git-1.6.0.5
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

Kun tämä on tehty, voit myös ottaa Gitin päivitykset Gitin itsensä kautta:

	$ git clone git://git.kernel.org/pub/scm/git/git.git

### Asennus Linuxissa ###

Jos haluat asentaa Gitin Linuxille binääri asennusohjelman kautta, voit yleensä tehdä näin perus paketinhallinnointi ohjelmalla, joka tulee julkaisusi mukana. Jos olet Fedorassa, voit käyttää yummia:

	$ yum install git-core

Tai jos ole Debian alustaisessa julkaisussa kuten Ubuntu, kokeile apt-gettiä:

	$ yum install git-core

### Asennus Macilla ###

On olemassa kaksi helppoa tapaa asentaa Git Macille. Helpoin on käyttää graafista Git asennusohjelmaa, jonka voit ladata Googlen Code verkkosivuilta (katso Kuva 1-7):

	http://code.google.com/p/git-osx-installer

Insert 18333fig0107.png 
Kuva 1-7. Git OS X asennusohjelma.

Toinen pääasiallinen tapa on asentaa Git MacPortsien kautta (`http://www.macports.org`). Jos sinulla on MacPorts asennettuna, asenna Git näin:

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

Sinun ei tarvitse asentaa kaikkia ekstroista, mutta varmaankin haluat sisältää +svn ekstran tapauksessa, että sinun koskaan tarviaa käyttää Gittiä Subversion tietolähteiden kanssa (katso Luku 8).

### Asennus Windowsilla ###

Gitin asennus Windowsilla on erittäin helppoa. msysGit projektilla on yksi helpoimmista asennusmenetelmistä. Yksinkertaisesti lataa asennus exe tiedosto Googlen Code verkkosivuilta ja suorita se:

	http://code.google.com/p/msysgit

Asennuksen jälkeen, sinulla on kummatkin, komentorivi versio (sisältäen SSH-asiakasohjelman, joka osoittautuu hyödylliseksi myöhemmin) ja standardi graafinen käyttöliittymä.

## Ensikerran Git asetukset ##

Nyt kun sinulla on Git järjestelmässäsi, haluat tehdä muutamia asioita kustomoidaksesi Git ympäristöäsi. Sinun tulisi tarvita tehdä nämä asiat vain kerran; ne säilyvät Gitin päivitysten välissä. Voit myös muuttaa niitä minä tahansa hetkenä ajamalla komennot läpi uudestaan.

Git tulee mukanaan työkalu, jota git configiksi kutsutaan, tämä työkalu antaa sinun hakea ja asettaa konfiguraatio muuttujia, jotka kontrolloivat kaikkia aspekteja siitä, miltä Git näyttää ja miten se operoi. Nämä muuttujat voidaan varastoida kolmeen erilliseen paikkaan:

*	`/etc/gitconfig` tiedosto: Sisältää arvot jokaiselle käyttäjälle järjestelmässä ja heidän kaikki tietolähteensä. Jos annat option ` --system` `git config`:lle, se lukee ja kirjoittaa erityisesti tästä tiedostosta.
* `~/.gitconfig` tiedosto: Tämä on erityisesti käyttäjällesi. Voit tehdä Gitin lukemaan ja kirjoittamaan erityisesti tähän tiedostoon antamalla option `--global`.
* config tiedosto on Git hakemistossa (tämä on, `.git/config`) missä tahansa tietolähteistä jota juuri nyt käytät: Tämä on erityisesti tälle kyseessä olevalle tietolähteelle. Jokainen taso ylikirjoittaa arvoja aikaisemmilta tasoilta, joten arvot `.git/config`:ssa päihittää arvot `/etc/gitconfig`:ssa.

Windows järjestelmissä, Git etsii `.gitconfig` tiedostoa `$HOME` hakemistosta (`C:\Documents and Settings\$USER` suurimmalle osalle ihmisistä). Se myös yhä etsii '/etc/gitconfig':a, vaikkakin se on suhteellinen MSys juureen, joka on missä tahansa minne päätät asentaa Gitin sinun Windows järjestelmässäsi, kun suoritat asennusohjelman.

### Identiteettisi ###

Ensimmäinen asia joka sinun tulisi tehdä Gittiä asentaessasi, on asettaa käyttäjänimesi ja sähköposti osoitteesi. Tämä on tärkeää, koska jokainen pysyvä muutos jonka Gitillä teet, käyttää tätä informaatiota, ja se on muuttumattomasti leivottu pysyviin muutoksiisi, joita liikuttelet ympäriinsä:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Tälläkin kertaa, sinun täytyy tehdä tämä ainoastaan kerran, jos annat `--global` option, koska silloin Git käyttää aina tätä informaation mitä tahansa teetkään järjestelmässäsi. Jos haluat yliajaa tämän toisella nimellä tai sähköposti osoitteella tietyille projekteille, voit aina ajaa komennon ilman `--global` optiota, kun olet projektissasi.

### Editorisi ###

Nyt kun identiteettisi on asetettu, voit konfiguroida oletus teksti-editorisi, jota käytetään kun Git tarvitsee sinua kirjoittamaan viestin. Oletusarvoisesti, Git käyttää järjestelmäsi oletus editoria, joka yleensä on Vi tai Vim. Jos haluat käyttää erillistä teksti editoria, kuten Emacs, voit tehdä seuraavanlaisesti:

	$ git config --global core.editor emacs
	
### Diff työkalusi ###

Seuraava hyödyllinen optio jota saatat haluta konfiguroida, on oletus diff työkalu, jota käytetään yhdentämiskonfliktien selvittämiseen. Sanotaan vaikka, että haluat käyttää vimdiffiä:

	$ git config --global merge.tool vimdiff

Git hyväksyy seuraavat yhdentämistyökalut kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge, ja opendiff. Voit myös käyttää kustomoitua työkalua; katso Luku 7 saadaksesi lisäinformaatiota tähän.

### Tarkista asetuksesi ###

Jos haluat tarkistaa asetuksesi, sinä voit käyttää `git config --list` komentoa listataksesi kaikki asetukset, jotka Git löytää tällä hetkellä:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

Voit nähdä avaimia useammin kuin kerran, koska Git lukee saman avaimen monesta eri tiedostosta (`/etc/gitconfig`:sta ja `~/.gitconfig`:sta, esimerkkinä). Tässä tapauksessa, Git käyttää viimeistä arvoa jokaisella yksittäiselle avaimelle jonka se näkee.

Voit myös tarkistaa mitä Git ajattelee tietyin avaimen arvosta, kirjoittamalla `git config {key}`:

	$ git config user.name
	Scott Chacon

## Avun saanti ##

Jos koskaan tarvitset apua Gittiä käytäessäsi, on olemassa kolme tapaa päästä minkä tahansa git komennon manuaalisivulle (manpage):

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

Esimerkiksi, saat manuaalisivun config komennolle suorittamalla:

	$ git help config

Nämä komennot ovat mukavia, koska pääset niihin käsiksi jokapaikasta, jopa yhteydettömässä tilassa.
Jos manuaalisivut ja tämä kirja eivät ole tarpeeksi ja tarvitset henkilökohtaista apua, voit yrittää `#git` tai `#github` kanavia Freenoden IRC palvelimella (irc.freenode.net). Nämä kanavat ovat säännöllisesti täynnä satoja ihmisiä, jotka ovat erittäin osaavia Gitin käyttäjiä ja ovat usein halukkaita auttamaan.

## Yhteenveto ##

Sinulla tulisi olla perus ymmärtämys siitä mikä Git on ja kuinka se eroaa muista CVCS järjestelmistä, joita mahdollisesti käytät. Sinulla myös tulisi olla toimiva versio Gitistä järjestelmässäsi, joka on konfiguroitu sinun henkilökohtaisella identiteetilläsi. Joten, nyt on aika opetella Gitin perusteita.
