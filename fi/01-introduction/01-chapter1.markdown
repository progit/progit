# Alkusanat #

Tämä luku auttaa sinut pääsemään alkuun Gitin kanssa. Me aloitamme aluksi selittämällä vähän versionhallintatyökalujen taustaa, jonka jälkeen siirrymme siihen, kuinka saat Gitin järjestelmääsi ja lopulta, kuinka se asennetaan työskentelyvalmiiksi. Tämän luvun lopussa sinun tulisi ymmärtää miksi Git on olemassa, miksi sinun tulisi käyttää sitä ja kaikki pitäisi olla valmista, jotta voisit käyttää sitä.

## Versionhallinnasta ##

Mitä on versionhallinta ja miksi sinun pitäisi välittää siitä? Versionhallinta on järjestelmä, joka ajan kuluessa tallentaa muutoksia tiedostoon tai joukkoon tiedostoja, jotta sinä voit palata tiettyihin versioihin myöhemmin. Vaikka esimerkit tässä kirjassa näyttävät ohjelmiston lähdekoodia versiohallittavina tiedostoina, todellisuudessa mikä tahansa tiedosto tietokoneellasi voidaan asettaa versiohallittavaksi.

Jos sinä olet graafinen tai web suunnittelija ja haluat säilyttää jokaisen version kuvasta tai leiskasta (minkä sinä varmasti haluat), on erittäin viisasta käyttää versionhallintajärjestelmää (VCS). Se mahdollistaa sen, että voit palauttaa tiedoston takaisin edelliseen tilaan, palauttaa koko projektin takaisin edelliseen tilaan, katselmoida ajan kuluessa tehtyjä muutoksia, nähdä kuka viimeksi muokkasi jotain, mikä voi olla ongelman aiheuttaja, kuka esitteli ongelman ja milloin, ja muuta. VCS:n käyttö tarkoittaa pääasiassa sitä, että jos sinä sotket jotain tai menetät tiedostoja, voit helposti palautua edelliseen toimivaan tilaan. Lisäksi saat kaiken tämän erittäin vähällä ylläpidolla.

### Paikalliset versionhallintajärjestelmät ###

Monen ihmisen versionhallintaratkaisu on kopioida tiedostoja toiseen kansioon (ehkäpä aikaleimattu kansio, jos he ovat fiksuja). Tämä lähestymistapa on erittäin yleinen, koska se on niin yksinkertainen, mutta se on myös erittäin virhealtis. On helppo unohtaa missä hakemistossa olet ja epähuomiossa kirjoittaa väärään tiedostoon tai kopioida sellaisten tiedostojen päälle, joihin et tarkoittanut koskea.

Tämän ongelman ratkaisemiksi ohjelmoijat kehittivät kauan sitten paikallisen VCS:n, jolla oli yksinkertainen tietokanta, joka piti kaikki tiedostojen muutokset muutostenhallinnan alla (katso Kuva 1-1).

Insert 18333fig0101.png
Kuva 1-1. Paikallinen versionhallinta -diagrammi.

Yksi suosituimmista VCS-työkaluista oli rcs:ksi kutsuttu järjestelmä, joka yhä tänä päivänä toimitetaan monen tietokoneen mukana. Jopa suosittu Mac OS X -käyttöjärjestelmä sisältää rcs-komennon Developer Tools -paketin asennuksen jälkeen. Tämä työkalu toimii periaatteessa pitämällä pätsikokoelmia (muutoksia tiedostojen välillä) yhdestä korjauksesta toiseen erikoisformaatissa kiintolevyllä; se voi täten luoda uudelleen sen, miltä mikä tahansa tiedosto näytti millä tahansa ajanhetkellä lisäämällä kaikki tarvittavat pätsit.

### Keskitetyt versionhallintajärjestelmät ###

Seuraava suuri ongelma, mihin ihmiset törmäävät, on, että heillä on tarve tehdä yhteistyötä muissa järjestelmissä olevien kehittäjien kanssa. Tämän ongelman ratkaisemiseksi luotiin keskitetyt versionhallintajärjestelmät (CVCS). Nämä järjestelmät, kuten CVS, Subversion ja Perforce, omaavat yksittäisen palvelimen, joka sisältää kaikki versioidut tiedostot, ja asiakkaita, jotka hakevat tiedostot tästä keskitetystä paikasta. Monet vuodet tämä on ollut versionhallinnan standardi (katso Kuva 1-2).

Insert 18333fig0102.png
Kuva 1-2. Keskitetty versionhallinta -diagrammi.

Tämä asetelma tarjoaa monta etua, erityisesti paikalliseen VCS:n verrattuna. Esimerkiksi, jokainen tietää jossain määrin, mitä kukin projektissa oleva tekee. Järjestelmänvalvojilla on hienosäädetty kontrolli siihen, mitä kukin voi tehdä; ja on paljon helpompi valvoa CVCS:ää, kuin toimia jokaisen asiakkaan paikallisen tietokannan kanssa.

Tässä asetelmassa on kuitenkin myös muutama vakava haittapuoli. Kaikkein selvin on keskitetty vikapiste, jota keskitetty palvelin edustaa. Jos kyseessä oleva palvelin ajetaan alas tunniksi, tämän tunnin aikana kukaan ei pysty tekemään yhteistyötä keskenään tai tallentamaan versioituja muutoksia mihinkään, mitä he työstävät. Jos kiintolevy - jolla keskitetty tietokanta sijaitsee - korruptoituu, ja kunnollisia varmuuskopioita ei ole hallussa, menetät täysin kaiken - koko projektin historian, paitsi ne yksittäiset tilannekuvat, joita ihmisillä sattuu olemaan heidän paikallisilla koneillaan. Paikalliset VCS-järjestelmät kärsivät tästä samasta ongelmasta - milloin tahansa sinulla on koko projektin historia yhdessä paikassa, sinulla on riski menettää se kaikki.

### Hajautetut versionhallintajärjestelmät ###

Tässä kohdassa hajautetut versionhallintajärjestelmät (DVCS) astuvat mukaan. DVCS:ssä (kuten Git, Mercurial, Bazaar tai Darcs) asiakkaat eivät vain hae viimeisintä tilannekuvaa tiedostoista: ne peilaavat täysin koko tietolähteen. Täten, jos mikä tahansa palvelin kuolee, ja nämä järjestelmät tekivät yhteistyötä sen kautta, mikä tahansa asiakastietolähde pystytään kopioimaan takaisin palvelimelle tiedon palauttamiseksi. Jokainen tiedonhaku on todellisuudessa täysi varmuuskopio kaikesta datasta (katso Kuva 1-3).

Insert 18333fig0103.png
Kuva 1-3. Hajautettu versionhallinta -diagrammi.

Lisäksi monet näistä järjestelmistä selviytyvät melko hyvin siitä, että niillä on monia etätietolähteitä, joiden kanssa ne voivat työskennellä, joten sinä voit tehdä monenlaista yhteistyötä monenlaisien ihmisryhmien kanssa samaan aikaan samassa projektissa. Tämä mahdollistaa sen, että voit aloittaa monenlaisia työnkulkuja, jotka eivät ole mahdollisia keskitetyissä järjestelmissä, kuten hierarkkiset mallit.

## Gitin lyhyt historia ##

Kuten moni muu suuri asia elämässä, Git alkoi hippusella luovaa tuhoamista ja liekehtivää erimielisyyttä. Linux kernel on kohtalaisen suuren mittakaavan avoimen lähdekoodin projekti. Suurimman osan Linux kernelin ylläpidon elinkaaresta (1991-2002) muutokset ohjelmistoon siirrettiin ympäriinsä pätseinä ja pakattuina tiedostoina. Vuonna 2002 Linux kernel -projekti alkoi käyttää BitKeeperiksi kutsuttua yksityistä DVCS-järjestelmää.

Vuonna 2005 suhde Linux kerneliä kehittävän yhteisön ja kaupallisen BitKeeperiä kehittävän yhtiön välillä katkesi, ja työkalun ilmaisuus kumoutui. Tämä johdatti Linuxin kehittäjäyhteisön (ja erityisesti Linus Torvaldsin, Linuxin luojan) kehittämään heidän omaa työkalua, perustuen oppeihin, joita he oppivat BitKeeperin käyttöaikanaan. Muutamat uuden järjestelmän tavoitteista olivat seuraavanlaiset:

* Nopeus
* Yksinkertainen rakenne
* Vahva tuki epälineaariselle kehitykselle (tuhansia rinnakkaisia haaroja)
* Täysin hajautettu
* Kyky käsitellä tehokkaasti suuria projekteja, kuten Linuxin kerneliä (nopeus ja tiedon koko)

Syntymästään lähtien, vuonna 2005, Git on kehittynyt ja aikuistunut helpoksi käyttää ja silti säilyttänyt nämä alkuperäiset ominaisuudet. Se on uskomattoman nopea, se on erittäin tehokas suurien projektien kanssa, ja siinä on uskomaton haarautumisjärjestelmä epälineaariselle kehitykselle (Katso Luku 3).

## Gitin perusteet ##

Joten, mitä Git on pähkinänkuoressa? Tämä on tärkeä osa-alue omaksua, koska jos ymmärrät, mitä Git on, ja periaatteet kuinka se toimii, Gitin tehokas käyttö tulee mahdollisesti olemaan paljon helpompaa. Kun opettelet Gitin käyttöä, yritä tyhjentää mielesi asioista, joita mahdollisesti tiedät muista VCS:istä, kuten Subversionista ja Perforcesta; tämän tekeminen auttaa sinua välttämään hienoisen sekaantumisen kun käytät työkalua. Git säilyttää ja ajattelee informaatiota huomattavasti eri lailla kuin nämä muut järjestelmät, vaikkakin käyttöliittymä on melko samanlainen; näiden eroavaisuuksien ymmärtäminen auttaa sinua välttämään sekaantumisia käyttäessäsi Gitiä.

### Tilannekuvia, ei eroavaisuuksia ###

Suurin eroavaisuus Gitin ja minkä tahansa muun VCS:n (Subversion ja kumppanit mukaan lukien) välillä on tapa, jolla Git ajattelee dataansa. Käsitteellisesti moni muu järjestelmä varastoi informaatiotansa listana tiedostopohjaisista muutoksista. Nämä järjestelmät (CVS, Subversion, Perforce, Bazaar, ja niin edelleen) ajattelevat informaatiota jota ne varastoivat kokoelmana tiedostoja ja ajan kuluessa jokaiseen tiedostoon tehtyinä muutoksina, kuten on kuvattu Kuvassa 1-4.

Insert 18333fig0104.png
Kuva 1-4. Muut järjestelmät tapaavat varastoida dataa muutoksina, jokaisen tiedoston alkuperäiseen versioon.

Git ei ajattele tai varastoi dataansa tällä tavalla. Sen sijaan Git ajattelee dataansa enemmän kokoelmana tilannekuvia pikkuruisesta tiedostojärjestelmästä. Joka kerta, kun sinä teet pysyvän muutoksen (commitin), tai tallennat projektisi tilan Gitissä, Git ottaa periaatteessa kuvan siitä, miltä sinun tiedostosi näyttävät kyseisellä hetkellä, ja varastoi viitteen tähän tilannekuvaan. Ollakseen tehokas, jos tiedostoa ei ole muutettu, Git ei varastoi sitä uudestaan - vaan linkittää sen edelliseen identtiseen tiedostoon, jonka se on jo varastoinut. Git ajattelee dataansa enemmän kuten Kuva 1-5 osoittaa.

Insert 18333fig0105.png
Kuva 1-5. Git varastoi dataa projektin tilannekuvina ajan kuluessa.

Tämä on tärkeä ero Gitin ja melkein minkä tahansa muun VCS:n välillä. Se laittaa Gitin harkitsemaan uudelleen melkein jokaista versionhallinnan aspektia, jotka monet muut järjestelmät kopioivat edeltäneestä sukupolvesta. Tämä tekee Gitistä kuin pikkuruisen tiedostojärjestelmän, jolla on muutamia uskomattoman tehokkaita työkaluja päälle rakennettuna, ennemmin kuin simppelin VCS:n. Me tutkimme joitain hyötyjä, joita saavutat ajattelemalla datastasi tällä tavoin, kun käsittelemme Gitin haarautumista Luvussa 3.

### Lähes jokainen operaatio on paikallinen ###

Monet operaatiot Gitissä tarvitsevat ainoastaan paikallisia tiedostoja ja resursseja operoidakseen - yleensä mitään informaatiota toiselta koneelta tietoverkostasi ei tarvita. Jos olet tottunut CVCS:ään, joissa suurin osa operaatioista sisältää tietoverkon viiveen, tämä Gitin aspekti laittaa sinut ajattelemaan, että nopeuden jumalat ovat siunanneet Gitin sanoinkuvaamattomilla voimilla. Koska sinulla on projektisi koko historia paikallisella levylläsi, suurin osa operaatioista näyttää melkein välittömiltä.

Esimerkiksi, selataksesi projektisi historiaa, Gitin ei tarvitse mennä ulkoiselle palvelimelle ottaakseen historian ja näyttääkseen sen sinulle - se yksinkertaisesti lukee sen suoraan sinun paikallisesta tietokannastasi. Tämä tarkoittaa sitä, että näet projektin historian melkein välittömästi. Jos haluat nähdä muutokset tiedoston nykyisen version ja kuukausi sitten olleen version välillä, Git voi katsoa tiedoston tilannekuvan kuukausi sitten ja tehdä paikallisen muutoslaskelman, sen sijaan, että sen pitäisi joko kysyä etäpalvelimelta sitä tai että sen tarvitsisi vetää vanhempi versio etäpalvelimelta, jotta se voisi tehdä sen paikallisesti.

Tämä myös tarkoittaa sitä, että on hyvin vähän asioita joita et voi tehdä, jos olet yhteydetön tai poissa VPN:stä. Jos nouset lentokoneeseen tai junaan ja haluat tehdä vähän töitä, voit iloisesti tehdä pysyviä muutoksia kunnes saat tietoverkon takaisin ja voit lähettää muutoksesi. Jos menet kotiin etkä saa VPN-asiakasohjelmaasi toimimaan oikein, voit yhä työskennellä. Monissa muissa järjestelmissä tämän tekeminen on joko mahdotonta tai kivuliasta. Esimerkiksi Perforcessa et voi tehdä paljoa mitään, silloin kun et ole yhteydessä palvelimeen; Subversionissa ja CVS:ssä voit editoida tiedostojasi, mutta et voi tehdä pysyviä muutoksia tietokantaasi (koska tietokantasi on yhteydetön). Tämä kaikki saattaa vaikuttaa siltä, ettei se ole nyt niin suuri juttu, mutta saatat yllättyä kuinka suuren muutoksen se voi tehdä.

### Git on eheä ###

Kaikki Gitissä tarkistussummataan ennen kuin se varastoidaan ja tämän jälkeen viitataan tällä tarkistussummalla. Tämä tarkoittaa, että on mahdotonta muuttaa minkään tiedoston sisältöä tai kansiota ilman, ettei Git tietäisi siitä. Tämä toiminnallisuus on rakennettu Gitiin alimmalla tasolla ja se on kiinteä osa sen filosofiaa. Et voi menettää informaatiota tiedonsiirrossa tai saada tiedostoihisi korruptiota ilman, ettei Git pystyisi sitä huomaamaan.

Mekanismi, jota Git käyttää tarkistussummaan, on kutsuttu SHA-1-tarkisteeksi. Tämä on 40-merkkinen merkkijono, joka koostuu heksadesimaalimerkeistä (0-9 ja a-f) ja joka on Gitissä laskettu tiedoston sisältöön tai hakemisto rakenteeseen pohjautuen. SHA-1-tarkiste voi näyttää tällaiselta:

	24b9da6552252987aa493b52f8696cd6d3b00373

Voit nähdä nämä tarkistearvot joka puolella Gitissä, koska se käyttää niitä niin paljon. Itse asiassa, Git varastoi kaiken, ei pohjautuen tiedoston nimeen, vaan Gitin tietokantaan osoitteistavaan sisällön tarkistearvoon.

### Git yleensä vain lisää dataa ###

Kun teet toimintoja Gitissä, melkein kaikki niistä ainoastaan lisäävät dataa Gitin tietokantaan. On erittäin vaikea saada järjestelmä tekemään mitään, mikä olisi kumoamaton, tai saada se poistamaan dataa millään tavoin. Kuten missä tahansa VCS:ssä, voit menettää tai sotkea muutoksia, joita ei ole vielä tehty pysyviksi; mutta sen jälkeen, kun teet pysyvän tilannekuvan muutoksen Gitiin, se on erittäin vaikeaa hävittää etenkin, jos sinä säännöllisesti työnnät tietokantasi toiseen tietolähteeseen.

Tämä tekee Gitin käyttämisestä hauskaa, koska me tiedämme, että voimme kokeilla erilaisia asioita ilman vaaraa, että sotkisimme vakavasti versionhallintamme. Syväluotaavamman tarkastelun siihen, miten Git varastoi dataansa ja kuinka voit palauttaa datan, joka näyttää hävinneeltä, katso Luku 9.

### Kolme tilaa ###

Lue nyt huolellisesti. Tämä on pääasia muistaa Gitistä, jos sinä haluat lopun opiskeluprosessistasi menevän sulavasti. Gitillä on kolme pääasiallista tilaa, joissa tiedostosi voivat olla: pysyvästi muutettu (commited), muutettu (modified), ja valmisteltu (staged). Pysyvästi muutettu tarkoittaa, että data on turvallisesti varastoitu sinun paikalliseen tietokantaasi. Muutettu tarkoittaa, että olet muuttanut tiedostoa, mutta et ole tehnyt vielä pysyvää muutosta tietokantaasi. Valmisteltu tarkoittaa, että olet merkannut muutetun tiedoston nykyisessä versiossaan menemään seuraavaan pysyvään tilannekuvaan.

Tämä johdattaa meidät kolmeen seuraavaan osaan Git-projektia: Git-hakemisto, työskentelyhakemisto, ja valmistelualue.

Insert 18333fig0106.png
Kuva 1-6. Työskentelyhakemisto, valmistelualue, ja Git-hakemisto.

Git-hakemisto on paikka, johon Git varastoi metadatan ja oliotietokannan projektillesi. Tämä on kaikkein tärkein osa Gitiä, ja se sisältää sen, mitä kopioidaan, kun kloonaat tietovaraston toiselta tietokoneelta.

Työskentelyhakemisto on yksittäinen tiedonhaku yhdestä projektin versiosta. Nämä tiedostot vedetään ulos pakatusta tietokannasta Git-hakemistosta ja sijoitetaan levylle sinun käytettäväksesi tai muokattavaksesi.

Valmistelualue on yksinkertainen tiedosto, yleensä se sisältyy Git-hakemistoosi, joka varastoi informaatiota siitä, mitä menee seuraavaan pysyvään muutokseen. Sitä viitataan joskus indeksiksi, mutta on tulossa standardiksi viitata sitä valmistelualueeksi.

Normaali Git-työnkulku menee jokseenkin näin:

1. Muokkaat tiedostoja työskentelyhakemistossasi.
2. Valmistelet tiedostosi, lisäten niistä tilannekuvia valmistelualueellesi.
3. Teet pysyvän muutoksen, joka ottaa tiedostot sellaisina, kuin ne ovat valmistelualueella, ja varastoi tämän tilannekuvan pysyvästi sinun Git-tietolähteeseesi.

Jos tietty versio tiedostosta on Git-hakemistossa, se on yhtä kuin pysyvä muutos. Jos sitä on muokattu, mutta se on lisätty valmistelualueelle, se on valmisteltu. Ja jos se on muuttunut siitä, kun se on haettu, mutta sitä ei ole valmisteltu, se on muutettu. Luvussa 2 opit enemmän näistä tiloista ja kuinka voit hyödyntää niitä tai ohittaa valmisteluvaiheen kokonaan.

## Gitin asennus ##

Ryhdytäänpä käyttämään Gitiä. Ensimmäiset asiat ensin - sinun täytyy asentaa se. Voit saada sen monella tavalla; kaksi yleisintä tapaa on asentaa se suoraan lähdekoodista tai asentaa jo olemassa oleva paketti sovellusalustallesi.

### Asennus suoraan lähdekoodista ###

Jos voit, on yleensä hyödyllistä asentaa Git suoraan lähdekoodista, koska näin saat kaikkein viimeisimmän version. Jokainen Gitin versio tapaa sisältää hyödyllisiä käyttöliittymäparannuksia, joten uusimman version hakeminen on yleensä paras reitti, jos tunnet olosi turvalliseksi kääntäessäsi ohjelmistoa sen lähdekoodista. On yleinen tilanne, että moni Linux-jakelu sisältää erittäin vanhoja paketteja; joten, jollet käytä erittäin päivitettyä jakelua tai backportteja, lähdekoodista asennus voi olla paras ratkaisu.

Asentaaksesi Gitin, tarvitset seuraavat kirjastot joista Git on riippuvainen: curl, zlib, openssl, expat, ja libiconv. Esimerkiksi, jos olet järjestelmässä, jossa on yum (kuten Fedora) tai apt-get (kuten Debian-pohjaiset järjestelmät), voit käyttää yhtä näistä komennoista asentaaksesi kaikki riippuvaisuudet:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev libssl-dev

Kun sinulla on kaikki tarvittavat riippuvuudet, voit mennä eteenpäin ja kiskaista uusimman tilannekuvan Gitin verkkosivuilta:

	http://git-scm.com/download

Tämän jälkeen käännä ja asenna:

	$ tar -zxf git-1.7.2.2.tar.gz
	$ cd git-1.7.2.2
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

Kun tämä on tehty, voit myös ottaa Gitin päivitykset Gitin itsensä kautta:

	$ git clone git://git.kernel.org/pub/scm/git/git.git

### Asennus Linuxissa ###

Jos haluat asentaa Gitin Linuxissa binääriasennusohjelman kautta, voit yleensä tehdä näin yksinkertaisella paketinhallintaohjelmalla, joka tulee julkaisusi mukana. Jos olet Fedorassa, voit käyttää yumia:

	$ yum install git-core

Tai jos olet Debian-pohjaisessa julkaisussa kuten Ubuntussa, kokeile apt-getiä:

	$ apt-get install git

### Asennus Macissä ###

On olemassa kaksi helppoa tapaa asentaa Git Macissä. Helpoin on käyttää graafista Git-asennusohjelmaa, jonka voit ladata Googlen Code -verkkosivuilta (katso Kuva 1-7):

	http://sourceforge.net/projects/git-osx-installer/

Insert 18333fig0107.png
Kuva 1-7. Git OS X -asennusohjelma.

Toinen pääasiallinen tapa on asentaa Git MacPortsin kautta (`http://www.macports.org`). Jos sinulla on MacPorts asennettuna, asenna Git näin:

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

Sinun ei tarvitse asentaa kaikkia ekstroista, mutta varmaankin haluat sisältää +svn-ekstran tapauksessa, jossa sinun täytyy joskus käyttää Gitiä Subversion-tietolähteiden kanssa (katso Luku 8).

### Asennus Windowsissa ###

Gitin asennus Windowsissa on erittäin helppoa. MsysGit-projektilla on yksi helpoimmista asennusmenetelmistä. Yksinkertaisesti lataa asennus-exe-tiedosto GitHub-verkkosivulta ja suorita se:

	http://msysgit.github.com/

Asennuksen jälkeen sinulla on sekä komentoriviversio (sisältäen SSH-asiakasohjelman, joka osoittautuu hyödylliseksi myöhemmin) että standardi graafinen käyttöliittymä.

Huomioitavaa Windowsin käytössä: sinun tulisi käyttää Gitiä tarjotulla msysGitin komentorivillä (Unix-tyylinen). Se sallii käytettävän tässä kirjassa annettuja monirivisiä komentoja. Jos sinun täytyy jostakin syystä käyttää natiivia Windows-komentoriviä tai konsolia, sinun täytyy käyttää lainausmerkkejä heittomerkkien sijaan (parametreille, joissa on välejä) ja ympäröidä lainausmerkeillä sirkumfleksiaksenttiin (^) päättyvät parametrit, jos ne ovat rivillä viimeisinä, koska se on jatkumissymboli Windowsissa.

## Ensikerran Git-asetukset ##

Nyt, kun sinulla on Git järjestelmässäsi, haluat tehdä muutamia asioita räätälöidäksesi Git-ympäristöäsi. Sinun tulisi tehdä nämä asiat vain kerran; ne säilyvät Gitin päivitysten välissä. Voit myös muuttaa niitä minä tahansa hetkenä ajamalla komennot läpi uudestaan.

Gitin mukanaan tulee työkalu, jota kutsutaan git configiksi. Tämä työkalu antaa sinun hakea ja asettaa kokoonpanomuuttujia, jotka kontrolloivat kaikkia aspekteja siitä, miltä Git näyttää ja miten se operoi. Nämä muuttujat voidaan varastoida kolmeen erilliseen paikkaan:

*	`/etc/gitconfig`-tiedosto: Sisältää arvot jokaiselle käyttäjälle järjestelmässä ja kaikkien heidän tietolähteensä. Jos annat option ` --system` `git config`ille, se lukee ja kirjoittaa erityisesti tähän tiedostoon.
* `~/.gitconfig`-tiedosto: Tämä on erityisesti käyttäjällesi. Voit pakottaa Gitin lukemaan ja kirjoittamaan erityisesti tähän tiedostoon antamalla option `--global`.
* config-tiedosto on Git-hakemistossa (tämä on, `.git/config`) missä tahansa tietolähteistä, jota juuri nyt käytät: Tämä on erityisesti kyseessä olevalle tietolähteelle. Jokainen taso ylikirjoittaa arvoja aikaisemmilta tasoilta, joten arvot `.git/config`issa päihittävät arvot `/etc/gitconfig`issa.

Windows-järjestelmissä Git etsii `.gitconfig`-tiedostoa `$HOME`-hakemistosta (`%USERPROFILE%` Windowsin ympäristössä), joka on `C:\Documents and Settings\$USER` tai `C:\Users\$USER` suurimmalle osalle ihmisistä , riippuen versiosta (`$USER` on `%USERNAME%` Windowsin ympäristössä). Se myös etsii yhä '/etc/gitconfig'ia, vaikkakin se on suhteellinen MSys-juureen, joka on missä tahansa minne päätät asentaa Gitin sinun Windows-järjestelmässäsi, kun suoritat asennusohjelman.

### Identiteettisi ###

Ensimmäinen asia, joka sinun tulisi tehdä Gitiä asentaessasi, on asettaa käyttäjänimesi ja sähköpostiosoitteesi. Tämä on tärkeää, koska jokainen pysyvä muutos, jonka Gitillä teet, käyttää tätä informaatiota, ja se on muuttumattomasti leivottu pysyviin muutoksiisi, joita liikuttelet ympäriinsä:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Tälläkin kerralla, sinun täytyy tehdä tämä ainoastaan kerran, jos annat `--global`-option, koska silloin Git käyttää aina tätä informaatiota mitä tahansa teetkään järjestelmässäsi. Jos haluat ylikirjoittaa tämän toisella nimellä tai sähköpostiosoitteella tietyille projekteille, voit aina ajaa komennon ilman `--global` optiota, kun olet projektissasi.

### Editorisi ###

Nyt, kun identiteettisi on asetettu, voit konfiguroida oletustekstieditorisi, jota käytetään kun Git pyytää sinua kirjoittamaan viestin. Oletusarvoisesti, Git käyttää järjestelmäsi oletuseditoria, joka yleensä on Vi tai Vim. Jos haluat käyttää erillistä tekstieditoria, kuten Emacsia, voit tehdä seuraavanlaisesti:

	$ git config --global core.editor emacs
	
### Diff-työkalusi ###

Seuraava hyödyllinen optio, jota saatat haluta konfiguroida, on oletus-diff-työkalu, jota käytetään yhdentämiskonfliktien selvittämiseen. Sanotaan vaikka, että haluat käyttää vimdiffiä:

	$ git config --global merge.tool vimdiff

Git hyväksyy seuraavat yhdentämistyökalut kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge, ja opendiff. Voit myös käyttää räätälöityä työkalua; katso Luku 7 saadaksesi lisäinformaatiota tähän.

### Tarkista asetuksesi ###

Jos haluat tarkistaa asetuksesi, sinä voit käyttää `git config --list`-komentoa listataksesi kaikki asetukset, jotka Git löytää tällä hetkellä:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

Voit nähdä avaimia useammin kuin kerran, koska Git lukee saman avaimen monesta eri tiedostosta (`/etc/gitconfig`ista ja `~/.gitconfig`ista, esimerkkinä). Tässä tapauksessa, Git käyttää viimeistä arvoa jokaiselle yksittäiselle avaimelle jonka se näkee.

Voit myös tarkistaa, mitä Git ajattelee tietyn avaimen arvosta, kirjoittamalla `git config {key}`:

	$ git config user.name
	Scott Chacon

## Avunsaanti ##

Jos tarvitset joskus apua Gitiä käyttäessäsi, on olemassa kolme tapaa päästä minkä tahansa Git-komennon manuaalisivulle (manpagelle):

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

Esimerkiksi, saat manuaalisivun config-komennolle suorittamalla:

	$ git help config

Nämä komennot ovat mukavia, koska pääset niihin käsiksi joka paikasta, jopa yhteydettömässä tilassa.
Jos manuaalisivut ja tämä kirja eivät ole tarpeeksi, ja tarvitset henkilökohtaista apua, voit yrittää `#git`- tai `#github`-kanavia Freenoden IRC-palvelimella (irc.freenode.net). Nämä kanavat ovat säännöllisesti täynnä satoja ihmisiä, jotka ovat erittäin osaavia Gitin käyttäjiä ja ovat usein halukkaita auttamaan.

## Yhteenveto ##

Sinulla tulisi olla perusymmärtämys siitä, mikä Git on, ja kuinka se eroaa muista CVCS-järjestelmistä, joita mahdollisesti käytät. Sinulla tulisi myös olla toimiva versio Gitistä järjestelmässäsi, joka on konfiguroitu sinun henkilökohtaisella identiteetilläsi. Joten, nyt on aika opetella Gitin perusteita.
