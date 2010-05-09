# Getting Started #
# Alkusanat #

This chapter will be about getting started with Git.  We will begin at the beginning by explaining some background on version control tools, then move on to how to get Git running on your system and finally how to get it setup to start working with.  At the end of this chapter you should understand why Git is around, why you should use it and you should be all setup to do so.

Tämä luku auttaa sinut pääsemään alkuun Gitin kanssa. Me aloitamme aluksi selittämällä vähän versionhallinta työkalujen taustaa, jonka jälkeen siirrymme siihen, kuinka saat Gitin järjestelmääsi ja lopulta, kuinka se asennetaan työskentely valmiiksi. Tämän luvun lopussa sinun tulisi ymmärtää miksi Git on olemassa, miksi sinun tulisi sitä käyttää ja kaikki pitäis olla valmista, jotta voisit sitä käyttää.

## About Version Control ##
## Versionhallinnasta ##

What is version control, and why should you care? Version control is a system that records changes to a file or set of files over time so that you can recall specific versions later. For the examples in this book you will use software source code as the files being version controlled, though in reality you can do this with nearly any type of file on a computer.

Mitä on versionhallinta ja miksi sinun pitäisi siitä välittää? Versionhallinta on menetelmä, joka ajan kuluessa tallentaa muutoksia tiedostoon tai joukkoon tiedostoja, jotta sinä voit palata tiettyihin versioihin myöhemmin. Esimerkkeinä tässä kirjassa, sinä käytät ohjelmiston lähdekoodia tiedostoina jotka ovat versiohallittavana, vaikkakin todellisuudessa sinä voit tehdä tämän melkeinpä millä tahansa tiedostolla tietokoneellasi.

If you are a graphic or web designer and want to keep every version of an image or layout (which you would most certainly want to), a Version Control System (VCS) is a very wise thing to use. It allows you to revert files back to a previous state, revert the entire project back to a previous state, compare changes over time, see who last modified something that might be causing a problem, who introduced an issue and when, and more. Using a VCS also generally means that if you screw things up or lose files, you can easily recover. In addition, you get all this for very little overhead.

Jos sinä olet graafinen- tai web suunnittelija ja haluat säilyttää jokaisen version kuvasta tai leiskasta (minkä sinä mitä varmimmin haluat), versionhallintamenetelmä (VCS) on erittäin viisas asia käytettäväksi. Se mahdollistaa, että voit palauttaa tiedoston takaisin edelliseen tilaan, palauttaa koko projektin takaisin edelliseen tilaan, vertailla muutoksia ajan kuluessa, nähdä kuka viimeksi muokkasi jotain mikä voi olla ongelman aiheuttaja, kuka esitteli ongelman ja milloin, ja muuta. VCS:n käyttö pääasiassa tarkoittaa sitä, että jos sinä sotket jotain tai menetät tiedostoja, voit helposti palautua edelliseen toimivaan tilaan. Lisäksi, saat kaiken tämän erittäin vähällä ylläpidolla.

### Local Version Control Systems ###
### Paikalliset versionhallinta järjestelmät ###

Many people’s version-control method of choice is to copy files into another directory (perhaps a time-stamped directory, if they’re clever). This approach is very common because it is so simple, but it is also incredibly error prone. It is easy to forget which directory you’re in and accidentally write to the wrong file or copy over files you don’t mean to.

Monen ihmisen versionhallinta ratkaisu on kopioida tiedostoja toiseen kansioon (ehkäpä aikaleimattu kansio, jos he ovat fiksuja). Tämä lähestymistapa on erittäin yleinen, koska se on niin yksinkertainen, mutta se on myös erittäin virhealtis. On helppo unohtaa missä hakemistossa olet ja epähuomiossa kirjoittaa väärään tiedostoon tai kopioida sellaisten tiedostojen päälle, joihin et tarkoittanut koskea.

To deal with this issue, programmers long ago developed local VCSs that had a simple database that kept all the changes to files under revision control (see Figure 1-1).

Tämän ongelman ratkaisemiksi, ohjelmoijat kauan sitten kehittivät paikallisen VCS:n, jolla oli yksinkertainen tietokanta, joka piti kaikki tiedostojen muutokset muutostenhallinnan alla (katso Kuva 1-1).

Insert 18333fig0101.png 
Figure 1-1. Local version control diagram.

Kuva 1-1. Paikallinen versionhallinta diagrammi.

One of the more popular VCS tools was a system called rcs, which is still distributed with many computers today. Even the popular Mac OS X operating system includes the  rcs command when you install the Developer Tools. This tool basically works by keeping patch sets (that is, the differences between files) from one change to another in a special format on disk; it can then re-create what any file looked like at any point in time by adding up all the patches.

Yksi suosituimmista VCS työkaluista oli rcs:ksi kutsuttu järjestelmä, joka on yhä tänä päivänä toimitettu monen tietokoneen mukana. Jopa suosittu Mac OS X käyttöjärjestelmä sisältää rcs komennon, Developer Tools paketin asennuksen jälkeen. Tämä työkalu periaatteessa toimii pitämällä pätsi kokoelmia (muutoksia tiedostojen välillä) yhdestä muutoksesta toiseen, erikoisformaatissa kiintolevyllä; se voi täten uudelleen luoda sen, miltä mikä tahansa tiedosto näytti, millä tahansa ajan hetkellä, lisäämällä kaikki tarvittavat pätsit.

### Centralized Version Control Systems ###
### Keskitetyt versionhallinta järjestelmät ###

The next major issue that people encounter is that they need to collaborate with developers on other systems. To deal with this problem, Centralized Version Control Systems (CVCSs) were developed. These systems, such as CVS, Subversion, and Perforce, have a single server that contains all the versioned files, and a number of clients that check out files from that central place. For many years, this has been the standard for version control (see Figure 1-2).

Seuraava suuri ongelma mihin ihmiset törmäävät on, että heillä on tarve tehdä yhteistyötä muissa järjestelmissä olevien kehittäjien kanssa. Tämän ongelman ratkaisemiseksi luotiin keskitetyt versionhallinta järjestelmät (CVCS). Nämä järjestelmät, kuten CVS, Subversion, ja Perforce, omaavat yksittäisen palvelimen joka sisältää kaikki versioidut tiedostot, ja asiakkaita jotka hakevat tiedostot tästä keskitetystä paikasta. Monet vuodet, tämä on ollut versionhallinnan standardi (katso Kuva 1-2).

Insert 18333fig0102.png 
Figure 1-2. Centralized version control diagram.
Kuva 1-2. Keskitetyn versionhallinnan diagrammi.

This setup offers many advantages, especially over local VCSs. For example, everyone knows to a certain degree what everyone else on the project is doing. Administrators have fine-grained control over who can do what; and it’s far easier to administer a CVCS than it is to deal with local databases on every client.

Tämä asetelma tarjoaa monta etua, erityisesti paikalliseen VCS:n verrattuna. Esimerkiksi, jokainen tietää, jossain määrin, mitä kukin projektissa oleva tekee. Järjestelmänvalvojilla on hienosäädetty kontrolli siihen, mitä kukin voi tehdä; ja on paljon helpompi valvoa CVCS:ä, kuin toimia joka asiakkaan paikallisen tietokannan kanssa.

However, this setup also has some serious downsides. The most obvious is the single point of failure that the centralized server represents. If that server goes down for an hour, then during that hour nobody can collaborate at all or save versioned changes to anything they’re working on. If the hard disk the central database is on becomes corrupted, and proper backups haven’t been kept, you lose absolutely everything—the entire history of the project except whatever single snapshots people happen to have on their local machines. Local VCS systems suffer from this same problem—whenever you have the entire history of the project in a single place, you risk losing everything.

Kuitenkin, tässä asetelmassa on myös muutama vakava haittapuoli. Kaikkein selvin on keskitetty vikapiste, jota keskitetty palvelin edustaa. Jos kyseessä oleva palvelin ajetaan alas tunniksi, niin tämän tunnin aikana kukaan ei pysty tekemään yhteistyötä keskenään tai tallentamaan versioituja muutoksia mihinkään mitä he työskentelevät. Jos kiintolevy - jolla keskitetty tietokanta sijaitsee - korruptoituu, ja kunnollisia varmuuskopioita ei ole hallussa, menetät täysin kaiken - koko projektin historian, paitsi ne yksittäiset tilannekuvat joita ihmisillä sattuu olemaan heidän paikallisilla koneillaan. Paikalliset VCS järjestelmät kärsivät tästä samasta ongelmasta - milloin tahansa sinulla on koko projektin historia yhdessä paikassa, sinulla on riski menettää se kaikki.

### Distributed Version Control Systems ###
### Hajautetut versionhallinta järjestelmät ###

This is where Distributed Version Control Systems (DVCSs) step in. In a DVCS (such as Git, Mercurial, Bazaar or Darcs), clients don’t just check out the latest snapshot of the files: they fully mirror the repository. Thus if any server dies, and these systems were collaborating via it, any of the client repositories can be copied back up to the server to restore it. Every checkout is really a full backup of all the data (see Figure 1-3).

Tämä on missä hajautetut versionhallinta järjestelmät (DVCS) astuvat mukaan. DVCS:ssä (kuten Git, Mercurial, Bazaar tai Darcs), asiakkaat eivät vain hae viimeisintä tilannekuvaa tiedostoista: he täysin peilaavat koko tietolähteen. Täten, jos mikä tahansa palvelin kuolee, ja nämä järjestelmät tekivät yhteistyötä sen läpi, mikä tahansa asiakas tietolähde pystytään kopioimaan takaisin palvelimelle tiedon palauttamiseksi. Jokainen tiedonhaku on tosiasiassa täysi varmuuskopio kaikesta datasta (katso Kuva 1-3).

Insert 18333fig0103.png 
Figure 1-3. Distributed version control diagram.
Kuva 1-3. Hajautettu versionhallinta diagrammi.

Furthermore, many of these systems deal pretty well with having several remote repositories they can work with, so you can collaborate with different groups of people in different ways simultaneously within the same project. This allows you to set up several types of workflows that aren’t possible in centralized systems, such as hierarchical models.

Lisäksi, monet näistä järjestelmistä selviytyvät melko hyvin siitä, että niillä on monia etä tietolähteitä, joiden kanssa ne voivat työskennellä, joten sinä voit tehdä monenlaista yhteistyötä monenlaisen ihmisryhmän kanssa yhtäaikaa, samassa projektissa. Tämä mahdollistaa sen että voit aloittaa monelaisia työnkulkuja, jotka eivät ole mahdollisia keskitetyissä järjestelmissä, kuten hierarkiset mallit.

## A Short History of Git ##
## Gitin lyhyt historia ##

As with many great things in life, Git began with a bit of creative destruction and fiery controversy. The Linux kernel is an open source software project of fairly large scope. For most of the lifetime of the Linux kernel maintenance (1991–2002), changes to the software were passed around as patches and archived files. In 2002, the Linux kernel project began using a proprietary DVCS system called BitKeeper.

Kuten moni muu suuri asia elämässä, Git alkoi hippusella luovaa tuhoamista ja liekehtivää erimielisyyttä. Linux kernel on kohtalaisen suuren mittakaavan avoimen lähdekoodin projekti. Suurimman osan Linux kernelin ylläpidon elinkaaresta (1991-2002), muutokset ohjelmistoon olivat siirretty ympäriinsä pätseinä ja pakattuina tiedostoina. Vuonna 2002, Linux kernel projekti alkoi käyttämään BitKeeperiksi kutsuttua yksityistä DVCS järjestelmää.

In 2005, the relationship between the community that developed the Linux kernel and the commercial company that developed BitKeeper broke down, and the tool’s free-of-charge status was revoked. This prompted the Linux development community (and in particular Linus Torvalds, the creator of Linux) to develop their own tool based on some of the lessons they learned while using BitKeeper. Some of the goals of the new system were as follows:

Vuonna 2005, suhde Linux kerneliä kehittävän yhteisön ja kaupallisen BitKeeperiä kehittävän yhtiön välillä katkesi, ja ilmaisen statuksen työkalut olivat kumottu. Tämä johdatti Linuxin kehittäjä yhteisön (ja erityisesti Linus Torvaldsin, Linuxin luojan) kehittämään heidän omaa työkalua, perustuen oppeihin joita he oppivat BitKeeperin käyttö aikanaan. Muutamat uuden järjestelmän tavoitteista olivat seuraavanlaiset:

*	Speed
*	Simple design
*	Strong support for non-linear development (thousands of parallel branches)
*	Fully distributed
*	Able to handle large projects like the Linux kernel efficiently (speed and data size)

* Nopeus
* Yksinkertainen malli
* Vahva tuki epälineaariselle kehitykselle (tuhansia rinnakkaisia haaroja)
* Täysin hajautettu
* Pystyy tehokkaasti selviytymään suurista projekteista kuten Linuxin kernel (nopeus ja tiedon koko)

Since its birth in 2005, Git has evolved and matured to be easy to use and yet retain these initial qualities. It’s incredibly fast, it’s very efficient with large projects, and it has an incredible branching system for non-linear development (See Chapter 3).

Syntymästään lähtien 2005, Git on kehittynyt ja aikuistunut helpoksi käyttää ja silti säilyttämään nämä alkuperäiset ominaisuudet. Se on uskomattoman nopea, se on erittäin tehokas suurien projektien kanssa, ja se on uskomattoman haarautuva järjestelmä epälineaariselle kehitykselle (Katso Luku 3).

## Git Basics ##
## Git perusteet ##

So, what is Git in a nutshell? This is an important section to absorb, because if you understand what Git is and the fundamentals of how it works, then using Git effectively will probably be much easier for you. As you learn Git, try to clear your mind of the things you may know about other VCSs, such as Subversion and Perforce; doing so will help you avoid subtle confusion when using the tool. Git stores and thinks about information much differently than these other systems, even though the user interface is fairly similar; understanding those differences will help prevent you from becoming confused while using it.

Joten, mitä on Git pähkinänkuoressa? Tämä on tärkeä osa-alue omaksua, koska jos ymmärrät mitä Git on ja periaatteet kuinka se toimii, Gitin tehokas käyttö tulee mahdollisesti olemaan paljon helpompaa. Kun opettelet Gitin käyttöä, yritä tyhjentää mielesi asioista joita mahdollisesti tiedät muista VCS:stä, kuten Subversionista ja Perforcesta; tämän tekeminen auttaa sinua välttämään hienoisen sekaantumisen kun käytät työkalua. Git säilyttää ja ajattelee informaatiosta huomattavasti erilailla kuin nämä muut järjestelät, vaikkakin käyttöliittymä on melko samanlainen; näiden eroavaisuuksien ymmärtäminen auttaa sinua välttämään sekaantumisia käyttäessäsi Gittiä.

### Snapshots, Not Differences ###
### Tilannekuvia, ei eroavaisuuksia ###

The major difference between Git and any other VCS (Subversion and friends included) is the way Git thinks about its data. Conceptually, most other systems store information as a list of file-based changes. These systems (CVS, Subversion, Perforce, Bazaar, and so on) think of the information they keep as a set of files and the changes made to each file over time, as illustrated in Figure 1-4.

Suurin eroavaisuus Gitin ja minkä tahansa muun VCS:n (Subversion ja ystävät mukaanlukien) on tapa jolla Git ajattelee dataansa. Käsitteellisesti, moni muu järjestelmä varastoi informaatiotansa listana tiedostopohjaisista muutoksista. Nämä järjestelmät (CVS, Subversion, Perforce, Bazaar, ja niin edelleen) ajattelevat informaatiota jota ne varastoivat, kokoelmana tiedostoja ja ajan kuluessa jokaiseen tiedostoon tehtyinä muutoksina, kuten kuvattu Kuvassa 1-4.

Insert 18333fig0104.png 
Figure 1-4. Other systems tend to store data as changes to a base version of each file.
Kuva 1-4. Muut järjestelmät tapaavat varastoida dataa muutoksina joka tiedoston alkuperäiseen versioon.

Git doesn’t think of or store its data this way. Instead, Git thinks of its data more like a set of snapshots of a mini filesystem. Every time you commit, or save the state of your project in Git, it basically takes a picture of what all your files look like at that moment and stores a reference to that snapshot. To be efficient, if files have not changed, Git doesn’t store the file again—just a link to the previous identical file it has already stored. Git thinks about its data more like Figure 1-5. 

Git ei ajattele tai varastoi dataansa tällä tavalla. Sen sijaan, Git ajattelee dataansa enemmän kokoelmana tilannekuvia pikkuruisesta tiedostojärjestelmästä. Joka kerta kun sinä teet pysyvän muutoksen (commit), tai tallennat projektisi tilan Gitissä, Git periaatteessa ottaa kuvan siitä miltä sinun tiedostosi näyttävät kyseisellä hetkellä ja varastoi viitteen tähän tilannekuvaan. Ollakseen tehokas, jos tiedostoja ei ole muutettu, Git ei varastoi tiedostoa uudestaan - vaan linkittää sen edelliseen identtiseen tiedostoon jonka se on jo varastoinut. Git ajattelee dataansa enemmän kuten Kuva 1-5 osoittaa.

Insert 18333fig0105.png 
Figure 1-5. Git stores data as snapshots of the project over time.
Kuva 1-5. Git varastoi dataa projektin tilannekuvina ajan kuluessa.

This is an important distinction between Git and nearly all other VCSs. It makes Git reconsider almost every aspect of version control that most other systems copied from the previous generation. This makes Git more like a mini filesystem with some incredibly powerful tools built on top of it, rather than simply a VCS. We’ll explore some of the benefits you gain by thinking of your data this way when we cover Git branching in Chapter 3.

Tämä on tärkeä ero Gitin ja melkein minkä tahansa muun VCS:n välilä. Se pistää Gitin harkitsemaan uudelleen melkein joka versionhallinan aspektia, jotka monet muut järjestelmät kopioivat edeltäneestä sukupolvesta. Tämä tekee Gitistä kuin pikkuruisen tiedostojärjestelmän, jolla on muutamia uskomattoman tehokkaita työkaluja päälle rakennettuna, ennemmin kuin simppelin VCS:n. Me tutkimme joitain hyötyjä joita saavutat ajattelemalla datastasi tällätavoin, kun käsittelemme Gitin haarautumista Luvussa 3.

### Nearly Every Operation Is Local ###
### Lähes jokainen operaatio on paikallinen ###

Most operations in Git only need local files and resources to operate – generally no information is needed from another computer on your network.  If you’re used to a CVCS where most operations have that network latency overhead, this aspect of Git will make you think that the gods of speed have blessed Git with unworldly powers. Because you have the entire history of the project right there on your local disk, most operations seem almost instantaneous.

Monet operaatiot Gitissä tarvitsevat ainoastaa paikallisia tiedostoja ja resursseja operoidakseen - yleensä mitään informaatiota toiselta koneelta tietoverkostasi ei tarvita. Jos olet tottunut CVCS:n, joissa suurin osa operaatioista sisältää tietoverkon viiveen, tämä Gitin aspekti laittaa sinut ajattelemaan, jotta nopeuden jumalat ovat siunanneet Gitin sanoinkuvaamattomilla voimilla. Koska sinulla on projektisi koko historia paikallisella levylläsi, suurinosa operaatioista näyttää melkein välittömiltä.

For example, to browse the history of the project, Git doesn’t need to go out to the server to get the history and display it for you—it simply reads it directly from your local database. This means you see the project history almost instantly. If you want to see the changes introduced between the current version of a file and the file a month ago, Git can look up the file a month ago and do a local difference calculation, instead of having to either ask a remote server to do it or pull an older version of the file from the remote server to do it locally.

Esimerkiksi, selataksesi projektisi historiaa, Gitin ei tarvitse mennä ulkoiselle palvelimelle ottaakseen historian ja näyttääkseen sen sinulle - se yksinkertaisesti lukee sen suoraan sinun paikallisesta tietokannastasi. Tämä tarkoittaa, että näet projektin historian melkein välittömästi. Jos haluat nähdä muutokset tiedoston nykyisen version ja kuukausi sitten olleen version välillä, Git voi katsoa tiedoston tilannekuvan kuukausi sitten ja tehdä paikallisen muutoslaskelman, sen sijaan, jotta sen pitäisi joko kysyä etäpalvelimelta sitä tai jotta sen tarvitsisi vetää vanhempi versio etäpalvelimelta, jotta se voisi tehdä sen paikallisesti.

This also means that there is very little you can’t do if you’re offline or off VPN. If you get on an airplane or a train and want to do a little work, you can commit happily until you get to a network connection to upload. If you go home and can’t get your VPN client working properly, you can still work. In many other systems, doing so is either impossible or painful. In Perforce, for example, you can’t do much when you aren’t connected to the server; and in Subversion and CVS, you can edit files, but you can’t commit changes to your database (because your database is offline). This may not seem like a huge deal, but you may be surprised what a big difference it can make.

Tämä myös tarkoittaa sitä, että on hyvin vähän asioita joita et voi tehdä, jos olet yhteydetön tai poissa VPN:stä. Jos nouset lentokoneeseen tai junaan ja haluat tehdä vähän töitä, voit iloisesti tehdä pysyviä muutoksia (commit) kunnes saat tietoverkon takaisin ja voit lähettää muutoksesi. Jos menet kotiin ja et saa VPN asiakasohjelmaasi toimimaan oikein, voit yhä työskennellä. Monissa muissa järjestelmissä, tämän tekeminen on joko mahdotonta tai kivuliasta. Perforcessa, esimerkiksi, et voi tehdä paljoa mitään, silloin kun et ole yhteydessä palvelimeen; Subversiossa ja CVS:ssä voit editoida tiedostojasi, mutta et voi tehdä pysyviä muutoksia (commit) tietokantaasi (koska tietokantasi on yhteydetön). Tämä saattaa vaikuttaa ettei se ole niin suuri juttu, mutta saatat yllättyä kuin suuren muutoksen se voi tehdä.

### Git Has Integrity ###
### Git on eheä ###

Everything in Git is check-summed before it is stored and is then referred to by that checksum. This means it’s impossible to change the contents of any file or directory without Git knowing about it. This functionality is built into Git at the lowest levels and is integral to its philosophy. You can’t lose information in transit or get file corruption without Git being able to detect it.

Kaikki Gitissä on tarkistussummattu ennen kuin se on varastoitu ja on tämän jälkeen viitattu tällä tarkistussummalla. Tämä tarkoittaa, että on mahdotonta muuttaa minkään tiedoston sisältöä tai kansiota ilman, ettei Git tietäisi siitä. Tämä toiminnallisuus on rakennettu Gittiin alimmalla tasolla ja kiinteä osa sen filosofiaa. Et voi menettää informaatiota tiedonsiirrossa tai saada tiedosto korruptiota ilman ettei Git pystyisi sitä huomaamaan.

The mechanism that Git uses for this checksumming is called a SHA-1 hash. This is a 40-character string composed of hexadecimal characters (0–9 and a–f) and calculated based on the contents of a file or directory structure in Git. A SHA-1 hash looks something like this:

	24b9da6552252987aa493b52f8696cd6d3b00373
	
Mekanismi jota Git käyttää tarkistussummaan on kutsuttu SHA-1 tarkisteeksi. Tämä on 40-merkkinen merkkijono, joka koostuu hexadesimaali merkeistä (0-9 ja a-f) ja joka on Gitissä laskettu tiedoston sisältöön tai hakemisto rakenteeseen pohjautuen. SHA-1 tarkiste voi näyttää tällaiselta:

	24b9da6552252987aa493b52f8696cd6d3b00373

You will see these hash values all over the place in Git because it uses them so much. In fact, Git stores everything not by file name but in the Git database addressable by the hash value of its contents.

Voit nähdä nämä tarkiste arvot jokapuolella Gitissä, koska se käyttää niitä niin paljon. Itseasiassa, Git varastoi kaiken, ei pohjautuen tiedoston nimeen, vaan Gitin tietokantaan osoitteistavaan sisällön tarkiste arvoon.

### Git Generally Only Adds Data ###

When you do actions in Git, nearly all of them only add data to the Git database. It is very difficult to get the system to do anything that is not undoable or to make it erase data in any way. As in any VCS, you can lose or mess up changes you haven’t committed yet; but after you commit a snapshot into Git, it is very difficult to lose, especially if you regularly push your database to another repository.

This makes using Git a joy because we know we can experiment without the danger of severely screwing things up. For a more in-depth look at how Git stores its data and how you can recover data that seems lost, see “Under the Covers” in Chapter 9.

### The Three States ###

Now, pay attention. This is the main thing to remember about Git if you want the rest of your learning process to go smoothly. Git has three main states that your files can reside in: committed, modified, and staged. Committed means that the data is safely stored in your local database. Modified means that you have changed the file but have not committed it to your database yet. Staged means that you have marked a modified file in its current version to go into your next commit snapshot.

This leads us to the three main sections of a Git project: the Git directory, the working directory, and the staging area.

Insert 18333fig0106.png 
Figure 1-6. Working directory, staging area, and git directory.

The Git directory is where Git stores the metadata and object database for your project. This is the most important part of Git, and it is what is copied when you clone a repository from another computer.

The working directory is a single checkout of one version of the project. These files are pulled out of the compressed database in the Git directory and placed on disk for you to use or modify.

The staging area is a simple file, generally contained in your Git directory, that stores information about what will go into your next commit. It’s sometimes referred to as the index, but it’s becoming standard to refer to it as the staging area.

The basic Git workflow goes something like this:

1.	You modify files in your working directory.
2.	You stage the files, adding snapshots of them to your staging area.
3.	You do a commit, which takes the files as they are in the staging area and stores that snapshot permanently to your Git directory.

If a particular version of a file is in the git directory, it’s considered committed. If it’s modified but has been added to the staging area, it is staged. And if it was changed since it was checked out but has not been staged, it is modified. In Chapter 2, you’ll learn more about these states and how you can either take advantage of them or skip the staged part entirely.

## Installing Git ##

Let’s get into using some Git. First things first—you have to install it. You can get it a number of ways; the two major ones are to install it from source or to install an existing package for your platform.

### Installing from Source ###

If you can, it’s generally useful to install Git from source, because you’ll get the most recent version. Each version of Git tends to include useful UI enhancements, so getting the latest version is often the best route if you feel comfortable compiling software from source. It is also the case that many Linux distributions contain very old packages; so unless you’re on a very up-to-date distro or are using backports, installing from source may be the best bet.

To install Git, you need to have the following libraries that Git depends on: curl, zlib, openssl, expat, and libiconv. For example, if you’re on a system that has yum (such as Fedora) or apt-get (such as a Debian based system), you can use one of these commands to install all of the dependencies:

	$ yum install curl-devel expat-devel gettext-devel \
	  openssl-devel zlib-devel

	$ apt-get install libcurl4-gnutls-dev libexpat1-dev gettext \
	  libz-dev
	
When you have all the necessary dependencies, you can go ahead and grab the latest snapshot from the Git web site:

	http://git-scm.com/download
	
Then, compile and install:

	$ tar -zxf git-1.6.0.5.tar.gz
	$ cd git-1.6.0.5
	$ make prefix=/usr/local all
	$ sudo make prefix=/usr/local install

After this is done, you can also get Git via Git itself for updates:

	$ git clone git://git.kernel.org/pub/scm/git/git.git
	
### Installing on Linux ###

If you want to install Git on Linux via a binary installer, you can generally do so through the basic package-management tool that comes with your distribution. If you’re on Fedora, you can use yum:

	$ yum install git-core

Or if you’re on a Debian-based distribution like Ubuntu, try apt-get:

	$ apt-get install git-core

### Installing on Mac ###

There are two easy ways to install Git on a Mac. The easiest is to use the graphical Git installer, which you can download from the Google Code page (see Figure 1-7):

	http://code.google.com/p/git-osx-installer

Insert 18333fig0107.png 
Figure 1-7. Git OS X installer.

The other major way is to install Git via MacPorts (`http://www.macports.org`). If you have MacPorts installed, install Git via

	$ sudo port install git-core +svn +doc +bash_completion +gitweb

You don’t have to add all the extras, but you’ll probably want to include +svn in case you ever have to use Git with Subversion repositories (see Chapter 8).

### Installing on Windows ###

Installing Git on Windows is very easy. The msysGit project has one of the easier installation procedures. Simply download the installer exe file from the Google Code page, and run it:

	http://code.google.com/p/msysgit

After it’s installed, you have both a command-line version (including an SSH client that will come in handy later) and the standard GUI.

## First-Time Git Setup ##

Now that you have Git on your system, you’ll want to do a few things to customize your Git environment. You should have to do these things only once; they’ll stick around between upgrades. You can also change them at any time by running through the commands again.

Git comes with a tool called git config that lets you get and set configuration variables that control all aspects of how Git looks and operates. These variables can be stored in three different places:

*	`/etc/gitconfig` file: Contains values for every user on the system and all their repositories. If you pass the option` --system` to `git config`, it reads and writes from this file specifically. 
*	`~/.gitconfig` file: Specific to your user. You can make Git read and write to this file specifically by passing the `--global` option. 
*	config file in the git directory (that is, `.git/config`) of whatever repository you’re currently using: Specific to that single repository. Each level overrides values in the previous level, so values in `.git/config` trump those in `/etc/gitconfig`.

On Windows systems, Git looks for the `.gitconfig` file in the `$HOME` directory (`C:\Documents and Settings\$USER` for most people). It also still looks for /etc/gitconfig, although it’s relative to the MSys root, which is wherever you decide to install Git on your Windows system when you run the installer.

### Your Identity ###

The first thing you should do when you install Git is to set your user name and e-mail address. This is important because every Git commit uses this information, and it’s immutably baked into the commits you pass around:

	$ git config --global user.name "John Doe"
	$ git config --global user.email johndoe@example.com

Again, you need to do this only once if you pass the `--global` option, because then Git will always use that information for anything you do on that system. If you want to override this with a different name or e-mail address for specific projects, you can run the command without the `--global` option when you’re in that project.

### Your Editor ###

Now that your identity is set up, you can configure the default text editor that will be used when Git needs you to type in a message. By default, Git uses your system’s default editor, which is generally Vi or Vim. If you want to use a different text editor, such as Emacs, you can do the following:

	$ git config --global core.editor emacs
	
### Your Diff Tool ###

Another useful option you may want to configure is the default diff tool to use to resolve merge conflicts. Say you want to use vimdiff:

	$ git config --global merge.tool vimdiff

Git accepts kdiff3, tkdiff, meld, xxdiff, emerge, vimdiff, gvimdiff, ecmerge, and opendiff as valid merge tools. You can also set up a custom tool; see Chapter 7 for more information about doing that.

### Checking Your Settings ###

If you want to check your settings, you can use the `git config --list` command to list all the settings Git can find at that point:

	$ git config --list
	user.name=Scott Chacon
	user.email=schacon@gmail.com
	color.status=auto
	color.branch=auto
	color.interactive=auto
	color.diff=auto
	...

You may see keys more than once, because Git reads the same key from different files (`/etc/gitconfig` and `~/.gitconfig`, for example). In this case, Git uses the last value for each unique key it sees.

You can also check what Git thinks a specific key’s value is by typing `git config {key}`:

	$ git config user.name
	Scott Chacon

## Getting Help ##

If you ever need help while using Git, there are three ways to get the manual page (manpage) help for any of the Git commands:

	$ git help <verb>
	$ git <verb> --help
	$ man git-<verb>

For example, you can get the manpage help for the config command by running

	$ git help config

These commands are nice because you can access them anywhere, even offline.
If the manpages and this book aren’t enough and you need in-person help, you can try the `#git` or `#github` channel on the Freenode IRC server (irc.freenode.net). These channels are regularly filled with hundreds of people who are all very knowledgeable about Git and are often willing to help.

## Summary ##

You should have a basic understanding of what Git is and how it’s different from the CVCS you may have been using. You should also now have a working version of Git on your system that’s set up with your personal identity. It’s now time to learn some Git basics.
