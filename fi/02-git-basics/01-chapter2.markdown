# Gitin perusteet #

Jos voit lukea vain yhden kappaleen päästäksesi vauhtiin Gitin kanssa, se on tämä kappale. Tämä kappale sisältää jokaisen peruskomennon, jonka tarvitset tehdäksesi valtavan määrän asioita, joiden kanssa viimein tulet käyttämään aikaasi Gitillä työskennellessäsi. Tämän kappaleen lopussa, sinun tulisi pystyä konfiguroimaan ja alustamaan tietolähde, aloittamaan ja lopettamaan tiedostojen jäljitys sekä valmistelemaan ja tehdä pysyviä muutoksia. Me myös näytämme sinulle kuinka asettaa Git niin, että se jättää tietyt tiedostot ja tiedostomallit huomioimatta, kuinka kumota virheet nopeasti ja helposti, kuinka selata projektisi historiaa ja tarkastella muutoksia pysyvien muutosten välillä sekä kuinka työntää ja vetää etätietolähteistä.

## Git-tietolähteen hankinta ##

Voit hankkia itsellesi Git-projektin käyttäen kahta yleistä lähestymistapaa. Ensimmäinen ottaa jo olemassa olevan projektin tai hakemiston ja tuo sen Gitiin. Toinen kloonaa olemassa olevan Git tietolähteen toiselta palvelimelta.

### Tietolähteen alustaminen jo olemassa olevalle hakemistolle ###

Jos aloitat jo olemassa olevan projektin jäljittämisen Gitillä, sinun täytyy mennä projektisi hakemistoon ja kirjoittaa

	$ git init

Tämä luo uuden alihakemiston nimeltä `.git`, joka sisältää kaikki tarvittavat tietolähdetiedostot - luurangon Git-tietolähteelle. Tällä hetkellä mitään projektissasi ei vielä jäljitetä. (Katso *Luku 9* saadaksesi enemmän tietoa siitä, mitä tiedostoja tarkalleen ottaen juuri luomasi `.git`-hakemisto sisältää.)

Jos haluat aloittaa versionhallinnan jo olemassa oleville tiedostoille (tyhjän kansion sijaan), sinun täytyy mitä luultavammin aloittaa näiden tiedostojen jäljittäminen ja tehdä alustava pysyvä muutos. Sinä saavutat tämän muutamalla `git add` -komennolla, joista ensimmäiset määrittävät, mitä tiedostoja haluat jäljittää, ja joita seuraa pysyvän muutoksen luonti:

	$ git add *.c
	$ git add README
	$ git commit –m 'initial project version'

Me käymme pian läpi mitä nämä komennot tekevät. Tällä hetkellä sinulla on Git-tietolähde, joka jäljittää tiedostoja sekä alustava pysyvä muutos.

### Olemassa olevan tietolähteen kloonaus ###

Jos haluat kopion olemassa olevasta tietolähteestä - esimerkiksi projektista, johon haluat olla osallisena - komento, jonka tarvitset, on `git clone`. Jos muut VCS-järjestelmät, kuten Subversion, ovat sinulle tuttuja, huomaat, että komento on `clone` eikä `checkout`. Tämä on tärkeä ero - Git saa kopion melkein kaikesta datasta mitä palvelimella on. Jokainen versio jokaisesta tiedostosta projektin historiassa tulee vedetyksi, kun suoritat `git clone` -komennon. Itse asiassa, jos palvelimesi levy korruptoituu, voit käyttää mitä tahansa klooneista, miltä tahansa asiakassovellukselta, asettaaksesi palvelimen takaisin tilaan, jossa se oli, kun se kloonattiin (voit menettää jotain palvelinpuolen sovelluskoukkuja ja muuta, mutta kaikki versioitu data on tallessa - katso *Luku 4* tarkempia yksityiskohtia varten).

Kloonaat tietolähteen `git clone [url]` -komennolla. Esimerkiksi, jos haluat kloonata Gritiksi kutsutun Ruby Git -kirjaston, voit tehdä sen näin:

	$ git clone git://github.com/schacon/grit.git

Tämä luo hakemiston nimeltä `grit`, alustaa `.git`-hakemiston sen sisään, vetää kaiken datan tietolähteestä, ja hakee viimeisimmän version työkopion. Jos menet uuteen `grit`-hakemistoon, näet projektin tiedostot valmiina työtä varten tai käytettäväksi. Jos haluat kloonata tietolähteen hakemistoon, joka on nimetty joksikin muuksi kuin grit, voit antaa nimen seuraavanlaisella komentorivioptiolla:

	$ git clone git://github.com/schacon/grit.git mygrit

Tämä komento tekee saman asian kuin edellinenkin, mutta kohdehakemisto on nimeltään `mygrit`.

Gitissä on monta erilaista siirtoprotokollaa, joita voit käyttää. Edellinen esimerkki käyttää `git://`-protokollaa, mutta voit myös nähdä `http(s)://` tai `user@server:/path.git`, joka käyttää SSH-siirtoprotokollaa. *Luku 4* esittelee kaikki saatavilla olevat optiot, joilla palvelin voidaan asettaa päästämään Git-tietolähteen, sekä jokaisin hyvät ja huonot puolet.

## Muutosten tallennus tietolähteeseen ##

Sinulla on oikea Git-tietolähde ja tiedonhaku (checkout) tai työkopio projektin tiedostoista. Sinun täytyy tehdä joitain muutoksia ja pysyviä tilannekuvia näistä muutoksista sinun tietolähteeseesi joka kerta, kun projekti saavuttaa tilan, jonka haluat tallentaa.

Muista, että jokainen tiedosto työhakemistossasi voi olla yhdessä kahdesta tilasta: *jäljitetty* tai *jäljittämätön*. *Jäljitetyt* tiedostot ovat tiedostoja, jotka olivat viimeisimmässä tilannekuvassa; ne voivat olla *muokkaamattomia*, *muokattuja* tai *valmisteltuja*. *Jäljittämättömät* tiedostot ovat kaikkea muuta - mitkä tahansa tiedostoja työhakemistossasi, jotka eivät olleet viimeisimmässä tilannekuvassa ja jotka eivät ole valmistelualueella. Kun ensimmäisen kerran kloonaat tietolähteen, kaikki tiedostoistasi tulevat olemaan jäljitettyjä ja muokkaamattomia, koska sinä juuri hait ne etkä ole muokannut vielä mitään.

Editoidessasi tiedostoja Git näkee ne muokattuina, koska olet muuttanut niitä viimeisimmän pysyvän muutoksen jälkeen. *Valmistelet* nämä muutetut tiedostot, jonka jälkeen muutat kaikki valmistellut muutokset pysyvästi, ja sykli toistuu. Tämä elämänsykli on kuvattu Kuvassa 2-1.

Insert 18333fig0201.png 
Kuva 2-1. Tiedostojesi tilan elämänsykli.

### Tiedostojesi tilan tarkistaminen ###

Päätyökalu tiedostojesi eri tilojen selvittämiseen on `git status` -komento. Jos suoritat tämän komennon suoraan kloonauksen jälkeen, sinun tulisi nähdä jotain vastaavaa:

	$ git status
	# On branch master
	nothing to commit, working directory clean

Tämä tarkoittaa, että sinulla on puhdas työhakemisto - toisin sanoen, jäljitettyjä tiedostoja ei ole muutettu. Git ei myöskään näe yhtään jäljittämätöntä tiedostoa, muuten ne olisi listattu näkymään. Lopuksi komento kertoo sinulle missä haarassa olet. Tällä hetkellä se on aina `master`-haara, joka on oletusarvo; sinun ei tarvitse huolehtia siitä nyt. Seuraava luku käy läpi haarautumiset ja viittaukset yksityiskohtaisesti.

Sanotaan vaikka, että lisäät uuden tiedoston projektiin, vaikka yksinkertaisen `README`-tiedoston. Jos tiedosto ei ollut olemassa ennen, ja ajat `git status` -komennon, näet jäljittämättömän tiedoston tällä tavoin:

	$ vim README
	$ git status
	# On branch master
	# Untracked files:
	#   (use "git add <file>..." to include in what will be committed)
	#
	#	README
	nothing added to commit but untracked files present (use "git add" to track)

Voit nähdä, että juuri luomasi `README`-tiedosto on jäljittämätön, koska se on otsikon ”Untracked files” alla tilatulosteessa. Jäljittämätön tarkoittaa periaatteessa sitä, että Git näkee tiedoston, jota ei ollut edellisessä tilannekuvassa (pysyvässä muutoksessa); Git ei aloita sisällyttämään sitä sinun pysyviin muutostilannekuviisi, ennen kuin sinä varta vasten käsket sen tehdä niin. Se tekee tämän, että et vahingossa alkaisi lisätä generoituja binaaritiedostoja tai muita tiedostoja, joita et tarkoittanut lisätä. Haluat lisätä READMEn, joten aloitetaan jäljittämään tiedostoa.

### Uusien tiedostojen jäljitys ###

Jotta voisit jäljittää uusia tiedostoja, sinun täytyy käyttää `git add` -komentoa. Aloittaaksesi `README`-tiedoston jäljittämisen, voit ajaa tämän:

	$ git add README

Jos ajat status-komennon uudestaan, näet että `README`-tiedostosi on nyt jäljitetty ja valmisteltu:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#

Voit nähdä, että se on valmisteltu, koska se on otsikon ”Changes to be committed” alla. Jos teet pysyvän muutoksen tässä kohtaa, versio tiedostosta sillä hetkellä kun ajoit `git add` -komennon on se, joka tulee olemaan historian tilannekuvassa. Voit palauttaa mieleen hetken, jolloin ajoit `git init` -komennon aikaisemmin, ajoit sen jälkeen `git add (tiedostot)` -komennon - tämä komento aloitti tiedostojen jäljittämisen hakemistossa. `Git add` -komento ottaa polun nimen joko tiedostolle tai hakemistolle; jos se on hakemisto, komento lisää kaikki tiedostot hakemiston alta rekursiivisesti.

### Muutettujen tiedostojen valmistelu ###

Muutetaanpa tiedostoa, joka on jo jäljitetty. Jos muutat aikaisemmin jäljitettyä `benchmarks.rb`-tiedostoa ja sen jälkeen ajat `status`-komennon uudestaan, saat suunnilleen tämän näköisen tulosteen:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#	modified:   benchmarks.rb
	#

`Benchmarks.rb`-tiedosto näkyy kohdan ”Changes not staged for commit” alla - mikä tarkoittaa, että tiedostoa, jota jäljitetään, on muokattu työskentelyhakemistossa, mutta sitä ei vielä ole valmisteltu. Valmistellaksesi sen, ajat `git add` -komennon (se on monitoimikomento - käytät sitä aloittaaksesi uusien tiedostojen jäljittämisen, valmistellaksesi tiedostoja, ja tehdäksesi muita asioita, kuten merkataksesi liitoskonfliktitiedostot ratkaistuksi). Ajetaanpa nyt `git add` -komento valmistellaksemme `benchmarks.rb`-tiedoston, ja ajetaan sitten `git status` -komento uudestaan:

	$ git add benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#

Kummatkin tiedostot ovat valmisteltuja ja tulevat menemään seuraavaan pysyvään muutokseen. Oletetaan, että tässä kohdassa muistat pienen muutoksen, jonka haluat tehdä `benchmarks.rb`-tiedostoon, ennen kuin teet pysyvää muutosta. Avaat tiedoston uudestaan ja muutat sitä, jonka jälkeen olet valmis tekemään pysyvän muutoksen. Ajetaan silti `git status` -komento vielä kerran:

	$ vim benchmarks.rb 
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#	modified:   benchmarks.rb
	#

Mitä ihmettä? Nyt `benchmarks.rb` on listattu sekä valmisteltuna että valmistelemattomana. Miten se on mahdollista? Tapahtuu niin, että Git valmistelee tiedoston juuri sellaisena kuin se on, kun ajat `git add` -komennon. Jos teet pysyvän muutoksen nyt, `benchmark.rb`-tiedoston versio sillä hetkellä, kun ajoit `git add` -komennon, on se, joka menee tähän pysyvään muutokseen, eikä se tiedoston versio, joka on työskentelyhakemistossasi sillä hetkellä, kun ajat `git commit` -komennon. Jos muutat tiedostoa sen jälkeen, kun olet ajanut `git add` -komennon, sinun täytyy ajaa `git add` uudestaan valmistellaksesi uusimman version tiedostosta:

	$ git add benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#	modified:   benchmarks.rb
	#

### Tiedostojen sivuuttaminen ###

Usein sinulla on luokka tiedostoja, joita et halua Gitin automaattisesti lisäävän tai edes näyttävän, että ne ovat jäljittämättömiä. Näitä ovat yleensä automaattisesti generoidut tiedostot, kuten lokitiedostot tai tiedostot, jotka sinun rakennejärjestelmä on luonut. Tällaisissa tapauksissa, voit luoda tiedostonlistausmalleja löytääksesi ne, `.gitignore`-tiedostoon. Tässä on esimerkki `.gitignore`-tiedostosta:

	$ cat .gitignore
	*.[oa]
	*~

Ensimmäinen rivi kertoo Gitille, että jokainen tiedosto, joka loppuu `.o`- tai `.a`- päätteeseen, sivuutetaan - näitä ovat mm. *olio-* ja *arkistotiedostot*, jotka voivat olla ohjelmakoodisi rakennuksen tulos. Toinen rivi kertoo Gitille, että kaikki tiedostot, jotka loppuvat tildeen (`~`), jotka ovat yleensä monen tekstieditorin, kuten Emacsin tapa merkata väliaikaisia tiedostoja, sivuutetaan. Voit myös sisällyttää `log`-, `tmp`-, tai `pid`-hakemiston; automaattisesti generoidun dokumentaation; ja niin edelleen. Välttääksesi sellaisten tiedostojen joutumisten Git-tietolähteeseen, joita et sinne alunperinkään halua menevän, on `.gitignore`-tiedoston asettaminen ennen varsinaisen työskentelyn aloittamista yleensä hyvä idea.

Säännöt malleille, joita voit laittaa `.gitignore`-tiedostoon ovat seuraavanlaiset:

*	Tyhjät rivit ja rivit, jotka alkavat `#`-merkillä, sivuutetaan.
*	Yleiset keräysmallit toimivat.
*	Voit päättää malleja kauttaviivalla (`/`) määrittääksesi hakemiston.
*	Voit kieltää mallin aloittamalla sen huutomerkillä (`!`).

Keräysmallit ovat kuin yksinkertaistettuja säännöllisiä lausekkeita, joita komentorivit käyttävät. Asteriski (`*`) löytää nolla tai enemmän merkkiä; `[abc]` löytää jokaisen merkin, joka on hakasulkujen sisällä (tässä tapauksessa a:n, b:n tai c:n); kysymysmerkki (`?`) löytää yksittäisen merkin; hakasulut, jotka ovat väliviivalla erotettujen merkkien ympärillä (`[0-9]`) löytävät jokaisen merkin, joka on merkkien välissä, tai on itse merkki (tässä tapauksessa merkit 0:sta 9:ään).

Tässä toinen esimerkki .gitignore-tiedostosta:

	# kommentti – tämä sivuutetaan
	# ei .a tiedostoja
	*.a
	# mutta jäljitä lib.a, vaikka sivuutatkin .a tiedostot yllä
	!lib.a
	# sivuttaa vain juuren TODO-tiedosto, ei subdir/TODO-tiedostoa
	/TODO
	# sivuttaa kaikki tiedostot build/-hakemistosta
	build/
	# sivuttaa doc/notes.txt, mutta ei doc/server/arch.txt
	doc/*.txt
	# sivuuttaa kaikki .txt-tiedostot doc/-hakemistosta
	doc/**/*.txt

`**/`-malli on saatavilla Gitin versiosta 1.8.2 lähtien.

### Valmisteltujen ja valmistelemattomien muutosten tarkastelu ###

Jos `git status` -komento on liian epämääräinen sinulle - haluat tietää tarkalleen mitä on muutettu, et ainoastaan sitä, mitkä tiedostot ovat muuttuneet - voit käyttää `git diff` -komentoa. Me käsittelemme `git diff` -kommenon yksityiskohtaisesti myöhemmin; mutta sinä tulet mahdollisesti käyttämään sitä useasti, vastataksesi näihin kahteen kysymykseen: Mitä olet muuttanut, mutta et ole vielä valmistellut? Ja mitä sellaista olet valmistellut, josta olet tekemässä pysyvän muutoksen? Vaikkakin `git status` vastaa näihin kysymyksiin yleisesti, `git diff` näyttää sinulle tarkalleen ne rivit, jotka on lisätty ja poistettu - vähän niin kuin pätsi.

Sanotaan vaikka, että muokkaat ja valmistelet `README`-tiedostoa uudestaan, jonka jälkeen muokkaat `benchmarks.rb`-tiedostoa, ilman että valmistelet sitä. Jos ajat `status`-komennon, näet jälleen kerran jotain tällaista:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	new file:   README
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#
	#	modified:   benchmarks.rb
	#

Nähdäksesi, mitä olet muuttanut, mutta et vielä valmistellut, kirjoita `git diff` ilman mitään muita argumentteja:

	$ git diff
	diff --git a/benchmarks.rb b/benchmarks.rb
	index 3cb747f..da65585 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -36,6 +36,10 @@ def main
	           @commit.parents[0].parents[0].parents[0]
	         end

	+        run_code(x, 'commits 1') do
	+          git.commits.size
	+        end
	+
	         run_code(x, 'commits 2') do
	           log = git.commits('master', 15)
	           log.size

Tämä komento vertailee sitä, mitä sinun työskentelyhakemistossa on verrattuna siihen, mitä sinun valmistelualueellasi on. Tulos kertoo tekemäsi muutokset, joita et ole vielä valmistellut.

Jos haluat nähdä, mitä sellaista olet valmistellut, joka menee seuraavaan pysyvään muutokseen, voit käyttää `git diff --cached` -komentoa. (Gitin versiosta 1.6.1 lähtien voit käyttää myös `git diff --staged` -komentoa, joka on helpompi muistaa.) Tämä komento vertailee valmisteltuja muutoksia viimeisimpään pysyvään muutokseen.

	$ git diff --cached
	diff --git a/README b/README
	new file mode 100644
	index 0000000..03902a1
	--- /dev/null
	+++ b/README2
	@@ -0,0 +1,5 @@
	+grit
	+ by Tom Preston-Werner, Chris Wanstrath
	+ http://github.com/mojombo/grit
	+
	+Grit is a Ruby library for extracting information from a Git repository

On tärkeää ottaa huomioon, että `git diff` itsessään ei näytä kaikkia muutoksia viimeisimmästä pysyvästä muutoksesta lähtien - vain muutokset, jotka ovat yhä valmistelemattomia. Tämä voi olla sekavaa, koska kun olet valmistellut kaikki muutoksesi, `git diff` ei anna ollenkaan tulostetta.

Toisena esimerkkinä, jos valmistelet `benchmarks.rb`-tiedoston ja sitten muokkaat sitä, voit käyttää `git diff` -komentoa nähdäksesi tiedoston valmistellut muutokset ja valmistelemattomat muutokset:

	$ git add benchmarks.rb
	$ echo '# test line' >> benchmarks.rb
	$ git status
	# On branch master
	#
	# Changes to be committed:
	#
	#	modified:   benchmarks.rb
	#
	# Changes not staged for commit:
	#
	#	modified:   benchmarks.rb
	#

Nyt voit käyttää `git diff` -komentoa nähdäksesi, mitä on yhä valmistelematta:

	$ git diff 
	diff --git a/benchmarks.rb b/benchmarks.rb
	index e445e28..86b2f7c 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -127,3 +127,4 @@ end
	 main()

	 ##pp Grit::GitRuby.cache_client.stats 
	+# test line

Ja `git diff --cached` -komentoa nähdäksesi, mitä olet valmistellut tähän mennessä:

	$ git diff --cached
	diff --git a/benchmarks.rb b/benchmarks.rb
	index 3cb747f..e445e28 100644
	--- a/benchmarks.rb
	+++ b/benchmarks.rb
	@@ -36,6 +36,10 @@ def main
	          @commit.parents[0].parents[0].parents[0]
	        end

	+        run_code(x, 'commits 1') do
	+          git.commits.size
	+        end
	+              
	        run_code(x, 'commits 2') do
	          log = git.commits('master', 15)
	          log.size

### Pysyvien muutoksien tekeminen ###

Nyt, kun valmistelualueesi on asetettu niin kuin sen haluat, voit tehdä muutoksistasi pysyviä. Muista, että kaikki, mikä vielä on valmistelematta - mitkä tahansa tiedostot, jotka olet luonut tai joita olet muokannut, joihin et ole ajanut `git add` -komentoa editoinnin jälkeen - eivät mene pysyvään muutokseen. Ne pysyvät muokattuina tiedostoina levylläsi.
Tässä tapauksessa oletamme, että viime kerran, kun ajoit `git status` -komennon, näit, että kaikki oli valmisteltu, joten olet valmis tekemään pysyvän muutoksen. Helpoin tapa pysyvän muutoksen tekoon on kirjoittaa `git commit`:

	$ git commit

Tämän suorittaminen aukaisee editorisi. (Tämä on asetettu komentorivisi `$EDITOR` ympäristömuuttujalla - yleensä vim tai emacs, kuitenkin voit konfiguroida sen käyttämään mitä haluat, käyttäen `git config --global core.editor` -komentoa, kuten *Luvussa 1* näit).

Editori näyttää seuraavanlaisen tekstin (tämä esimerkki on Vimistä):

	# Please enter the commit message for your changes. Lines starting
	# with '#' will be ignored, and an empty message aborts the commit.
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       new file:   README
	#       modified:   benchmarks.rb 
	~
	~
	~
	".git/COMMIT_EDITMSG" 10L, 283C

Voit nähdä, että oletuksena pysyvän muutoksen viesti sisältää viimeisimmän `git status` -komennon tulosteen kommentoituna ja yhden tyhjän rivin ylhäällä. Voit poistaa nämä kommentit ja kirjoittaa pysyvän muutoksen viestisi, tai voit jättää kommentit viestiin auttamaan sinua muistamaan mihin olet pysyvää muutosta tekemässä. (Saadaksesi vieläkin tarkemman muistutukseen muutoksistasi, voit antaa `-v`-option `git commit` -komennolle. Tämä optio laittaa myös diff-muutostulosteen editoriin, jotta näet tarkalleen mitä teit.) Kun poistut editorista, Git luo pysyvän muutoksesi viestilläsi (kommentit ja diff pois lukien).

Vaihtoehtoisesti, voit kirjoittaa pysyvän muutoksen viestin suoraan `commit`-kommennolla antamalla sen `-m`-lipun jälkeen, näin:

	$ git commit -m "Story 182: Fix benchmarks for speed"
	[master]: created 463dc4f: "Fix benchmarks for speed"
	 2 files changed, 3 insertions(+), 0 deletions(-)
	 create mode 100644 README

Nyt olet luonut ensimmäisen pysyvän muutoksen! Voit nähdä, että pysyvä muutos on antanut sinulle tulosteen itsestään: kertoen mihin haaraan teit pysyvän muutoksen (`master`), mikä SHA-1 tarkistussumma pysyvällä muutoksella on (`463dc4f`), kuinka monta tiedostoa muutettiin ja tilastoja pysyvän muutoksen rivien lisäyksistä ja poistoista.

Muista, että pysyvä muutos tallentaa tilannekuvan valmistelualueestasi. Kaikki, mitä et valmistellut on yhä istumassa projektissasi muokattuna; voit tehdä toisen pysyvän muutoksen lisätäksesi ne historiaasi. Joka kerta, kun teet pysyvän muutoksen, olet tallentamassa tilannekuvaa projektistasi. Tilannekuvaa, johon voit palata tai jota voit vertailla myöhemmin. 

### Valmistelualueen ohittaminen ###

Vaikka valmistelualue voi olla uskomattoman hyödyllinen pysyvien muutoksien tekoon tarkalleen niin kuin ne haluat, on valmistelualue joskus hieman liian monimutkainen, kuin mitä työnkulussasi tarvitsisit. Jos haluat ohittaa valmistelualueen, Git tarjoaa siihen helpon oikoreitin. Antamalla `-a`-option `git commit` -komennolle, asettaa Gitin automaattisesti valmistelemaan jokaisen jo jäljitetyn tiedoston ennen pysyvää muutosta, antaen sinun ohittaa `git add` -osan:

	$ git status
	# On branch master
	#
	# Changes not staged for commit:
	#
	#	modified:   benchmarks.rb
	#
	$ git commit -a -m 'added new benchmarks'
	[master 83e38c7] added new benchmarks
	 1 files changed, 5 insertions(+), 0 deletions(-)

Huomaa, miten sinun ei tarvitse ajaa `git add` -komentoa `benchmarks.rb`-tiedostolle tässä tapauksessa pysyvää muutosta tehdessäsi.

### Tiedostojen poistaminen ###

Poistaaksesi tiedoston Gitistä, sinun täytyy poistaa se sinun jäljitetyistä tiedostoistasi (tarkemmin sanoen, poistaa se valmistelualueeltasi) ja sitten tehdä pysyvä muutos. Komento `git rm` tekee tämän ja myös poistaa tiedoston työskentelyhakemistostasi, joten et näe sitä enää jäljittämättömänä tiedostona.

Jos yksinkertaisesti poistat tiedoston työskentelyhakemistostasi, näkyy se ”Changes not staged for commit” otsikon alla (se on, _valmistelematon_) `git status` -tulosteessasi:

	$ rm grit.gemspec
	$ git status
	# On branch master
	#
	# Changes not staged for commit:
	#   (use "git add/rm <file>..." to update what will be committed)
	#
	#       deleted:    grit.gemspec
	#

Jos ajat tämän jälkeen `git rm` -komennon, se valmistelee tiedostot poistoon:

	$ git rm grit.gemspec
	rm 'grit.gemspec'
	$ git status
	# On branch master
	#
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       deleted:    grit.gemspec
	#

Seuraavan kerran, kun teet pysyvän muutoksen, tiedosto katoaa ja sitä ei jäljitetä enää. Jos muokkasit tiedostoa ja lisäsit sen jo indeksiin, täytyy sinun pakottaa poisto `-f`-optiolla. Tämä on turvallisuusominaisuus, joka estää vahingossa tapahtuvan datan poistamisen, datan, jota ei ole vielä tallennettu tilannekuvaksi ja jota ei voida palauttaa Gitistä.

Toinen hyödyllinen asia, jonka saatat haluta tehdä, on tiedoston pitäminen työskentelypuussa, mutta samalla sen poistaminen valmistelualueelta. Toisin sanoen, voit haluta pitää tiedoston kovalevylläsi, mutta et halua, että Git jäljittää sitä enää. Tämä on erityisesti hyödyllinen, jos unohdit lisätä jotain `.gitignore`-tiedostoosi ja vahingossa valmistelit sellaisen, kuten suuri lokitiedosto tai joukko `.a`-muotoon käännettyjä tiedostoja. Tehdäksesi tämän, käytä `--cached`-optiota:

	$ git rm --cached readme.txt

Voit antaa tiedostoja, hakemistoja tai tiedoston keräysmalleja `git rm` -komennolle. Tämä tarkoittaa sitä, että voit tehdä asioita kuten:

	$ git rm log/\*.log

Huomaa kenoviiva (`\`) `*`-merkin edessä. Windowsin järjestelmäkonsolissa kenoviiva täytyy jättää pois. Tämä on tarpeellinen, koska Git tekee oman tiedostonimilaajennuksensa komentorivisi tiedostonimilaajennuksen lisänä. Tämä komento poistaa kaikki tiedostot, joilla on `.log`-liite, `log/`-hakemistosta. Voit myös tehdä näin:

	$ git rm \*~

Tämä komento poistaa kaikki tiedostot, jotka loppuvat `~`-merkkiin.

### Tiedostojen siirtäminen ###

Toisin kuin monet muut VCS-järjestelmät, Git ei jäljitä suoranaisesti tiedostojen siirtämistä. Jos nimeät tiedoston uudelleen Gitissä, Gitiin ei tallenneta metadataa, joka kertoo, että nimesit tiedoston uudelleen. Git on kuitenkin melko älykäs selvittämään sen myöhemmin — käsittelemme tiedostojen siirtämisen havaitsemista hieman myöhemmin.

Siksi on hieman sekavaa, että Gitissä on `mv`-komento. Jos haluat nimetä tiedoston uudelleen Gitissä, voit ajaa jotakuinkin seuraavasti

	$ git mv lähdetiedosto kohdetiedosto

ja se toimii hienosti. Itse asiassa, jos ajat jotakuinkin tällä tavalla ja katsot tilaa, näet Gitin pitävän sitä uudelleennimettynä tiedostona:

	$ git mv README.txt README
	$ git status
	# On branch master
	# Your branch is ahead of 'origin/master' by 1 commit.
	#
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       renamed:    README.txt -> README
	#

Tämä on kuitenkin sama, kuin ajaisit seuraavasti:

	$ mv README.txt README
	$ git rm README.txt
	$ git add README

Git ymmärtää sen olevan uudelleennimeäminen epäsuorasti, joten ei ole väliä, nimeätkö tiedoston uudelleen tällä tavalla vai `mv`-komennolla. Ainoa todellinen ero on, että `mv` on yksi komento kolmen sijaan — se on helppokäyttötoiminto. Tärkeämpää, voit käyttää tiedoston uudelleennimeämiseen mitä työkalua haluat ja käsitellä add/rm myöhemmin, ennen kuin teet pysyvän muutoksen.

## Pysyvien muutosten historian tarkasteleminen ##

Kun olet luonut useita pysyviä muutoksia tai kloonannut tietovaraston, jonka historiassa on pysyviä muutoksia, haluat todennäköisesti katsoa taaksepäin nähdäksesi, mitä on tapahtunut. Yksinkertaisin ja tehokkain työkalu tähän on `git log` -komento.

Nämä esimerkit käyttävät erittäin yksinkertaista projektia nimeltä `simplegit`, jota käytän useasti havainnollistamisessa. Saadaksesi projektin, aja

	git clone git://github.com/schacon/simplegit-progit.git

Kun ajat `git log` tässä projektissa, sinun tulisi saada vastaavanlainen tuloste:

	$ git log
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	commit a11bef06a3f659402fe7563abf99ad00de2209e6
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 10:31:28 2008 -0700

	    first commit

Oletuksena, ilman argumentteja, `git log` listaa tietovarastoon tehdyt pysyvät muutokset käänteisessä aikajärjestyksessä. Se tarkoittaa, että uusin pysyvä muutos tulee ensimmäiseksi. Kuten voit nähdä, tämä komento listaa kustakin pysyvästä muutoksesta sen SHA-1-tarkisteen,  tekijän nimen ja sähköpostin, luontipäiväyksen sekä viestin.

`Git log` -komennolle on saatavilla valtava määrä ja lajitelma optioita näyttääkseen sinulle tarkalleen etsimäsi. Näytämme tässä sinulle joitakin käytetyimpiä optioita.

Yksi hyödyllisimmistä optioista on `-p`, joka näyttää kunkin pysyvän muutoksen eroavaisuuden. Voit myös käyttää `-2`, joka rajaa tulosteen ainoastaan kahteen viimeisimpään kirjaukseen:

	$ git log -p -2
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	diff --git a/Rakefile b/Rakefile
	index a874b73..8f94139 100644
	--- a/Rakefile
	+++ b/Rakefile
	@@ -5,5 +5,5 @@ require 'rake/gempackagetask'
	 spec = Gem::Specification.new do |s|
	     s.name      =   "simplegit"
	-    s.version   =   "0.1.0"
	+    s.version   =   "0.1.1"
	     s.author    =   "Scott Chacon"
	     s.email     =   "schacon@gee-mail.com

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	diff --git a/lib/simplegit.rb b/lib/simplegit.rb
	index a0a60ae..47c6340 100644
	--- a/lib/simplegit.rb
	+++ b/lib/simplegit.rb
	@@ -18,8 +18,3 @@ class SimpleGit
	     end

	 end
	-
	-if $0 == __FILE__
	-  git = SimpleGit.new
	-  puts git.show
	-end
	\ No newline at end of file

Tämä optio näyttää saman informaation, mutta jokaista kirjausta seuraavalla eroavaisuudella. Tämä on erittäin hyödyllinen koodin katselmoinnissa tai nopeasti tarkistettaessa, mitä tapahtui pysyvien muutosten sarjassa, jonka työtoveri on lisännyt.

Joskus on helpompaa katselmoida muutoksia sanatasolla kuin rivitasolla. Gitissä on saatavilla `--word-diff`-optio, jonka voit lisätä `git log -p` -komentoon saadaksesi sanatason eroavaisuuden normaalin rivitasoisen eroavaisuuden sijaan. Sanatason eroavaisuuden formaatti on melko hyödytön käytettäessä sitä lähdekoodiin, mutta siitä tulee kätevä käytettäessä sitä isoihin tekstitiedostoihin, kuten kirjoihin tai väitöskirjaasi. Tässä on esimerkki:

	$ git log -U1 --word-diff
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	diff --git a/Rakefile b/Rakefile
	index a874b73..8f94139 100644
	--- a/Rakefile
	+++ b/Rakefile
	@@ -7,3 +7,3 @@ spec = Gem::Specification.new do |s|
	    s.name      =   "simplegit"
	    s.version   =   [-"0.1.0"-]{+"0.1.1"+}
	    s.author    =   "Scott Chacon"

Kuten voit nähdä, tässä tulosteessa ei ole lisättyjä ja poistettuja rivejä, kuten normaalissa eroavaisuudessa. Muutokset esitetään sen sijaan rivin sisällä. Voit nähdä lisätyn sanan ympäröitynä `{+ +}` -merkeillä ja poistetun ympäröitynä `[- -]` -merkeillä. Voit myös haluta vähentää tavallisen kolmen rivin kontekstin eroavaisuustulosteessa vain yhden rivin kontekstiksi, koska asiayhteys on nyt sanatasolla ei rivitasolla. Voit tehdä tämän `-U1`-optiolla, kuten teimme esimerkissä yläpuolella.

Voit myös käyttää yhteenveto-optioiden sarjaa `git log`in kanssa. Esimerkiksi, jos haluat nähdä hieman lyhennettyjä tilastoja kustakin pysyvästä muutoksesta, voit käyttää `--stat`-optiota:

	$ git log --stat
	commit ca82a6dff817ec66f44342007202690a93763949
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Mar 17 21:52:11 2008 -0700

	    changed the version number

	 Rakefile |    2 +-
	 1 files changed, 1 insertions(+), 1 deletions(-)

	commit 085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 16:40:33 2008 -0700

	    removed unnecessary test code

	 lib/simplegit.rb |    5 -----
	 1 files changed, 0 insertions(+), 5 deletions(-)

	commit a11bef06a3f659402fe7563abf99ad00de2209e6
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sat Mar 15 10:31:28 2008 -0700

	    first commit

	 README           |    6 ++++++
	 Rakefile         |   23 +++++++++++++++++++++++
	 lib/simplegit.rb |   25 +++++++++++++++++++++++++
	 3 files changed, 54 insertions(+), 0 deletions(-)

Kuten voit nähdä, `--stat`-optio tulostaa kunkin pysyvän muutoksen alapuolelle listan muokatuista tiedostoista, kuinka montaa tiedostoa muutettiin ja kuinka monta riviä lisättiin ja poistettiin näissä tiedostoissa. Se esittää myös lopuksi yhteenvedon tiedoista.
Toinen todella hyödyllinen optio on `--pretty`. Tämä optio muuttaa lokitulosteen oletuksesta poikkeaviin muotoihin. Saatavilla on muutama esikäännetty optio käytettäväksesi. `Oneline`-optio tulostaa kunkin pysyvän muutoksen yhdelle riville,  mikä on hyödyllistä, jos katselet monia pysyviä muutoksia. Lisäksi `short`-, `full`- ja `fuller`-optiot näyttävät tulosteen karkeasti ottaen alkuperäisessä muodossa, mutta vastaavasti vähemmillä tai enemmillä tiedoilla:

	$ git log --pretty=oneline
	ca82a6dff817ec66f44342007202690a93763949 changed the version number
	085bb3bcb608e1e8451d4b2432f8ecbe6306e7e7 removed unnecessary test code
	a11bef06a3f659402fe7563abf99ad00de2209e6 first commit

Kiinnostavin optio on `format`, joka antaa sinun määritellä oman formaatin lokitulosteelle. Tämä on hyödyllinen varsinkin, kun  luot tulostetta koneellista parsimista varten — koska sinä määrittelet formaatin eksplisiittisesti, tiedät, ettei se muutu Gitin päivitysten myötä:

	$ git log --pretty=format:"%h - %an, %ar : %s"
	ca82a6d - Scott Chacon, 11 months ago : changed the version number
	085bb3b - Scott Chacon, 11 months ago : removed unnecessary test code
	a11bef0 - Scott Chacon, 11 months ago : first commit

Taulukko 2-1 listaa joitakin hyödyllisempiä optioita, joita format hyväksyy.

<!-- Attention to translators: this is a table declaration.
The lines must be formatted as follows
<TAB><First column text><TAB><Second column text>
-->

	Optio	Tulosteen kuvaus
	%H	Pysyvän muutoksen tarkiste
	%h	Lyhennetty pysyvän muutoksen tarkiste
	%T	Puun tarkiste
	%t	Lyhennetty puun tarkiste
	%P	Vanhempien tarkisteet
	%p	Lyhennetyt vanhempien tarkisteet
	%an	Tekijän nimi
	%ae	Tekijän sähköpostiosoite
	%ad	Tekijän päiväys (muoto riippuu --date=-optiosta)
	%ar	Tekijän päiväys, suhteellinen
	%cn	Hyväksyjän nimi
	%ce	Hyväksyjän sähköpostiosoite
	%cd	Hyväksyjän päiväys
	%cr	Hyväksyjän päiväys, suhteellinen
	%s	Aihe

Saatat ihmetellä, mitä eroa on _tekijällä_ ja _hyväksyjällä_. _Tekijä_ on henkilö, joka alunperin kirjoitti muutoksen, kun taas _hyväksyjä_ on henkilö, joka lopulta otti muutoksen käyttöön. Joten, jos sinä lähetät muutoksen projektiin ja joku ydinjäsenistä ottaa muutoksen käyttöön, te saatte molemmat kunniaa — sinä tekijänä ja ydinjäsen hyväksyjänä. Käsittelemme tätä eroa enemmän *Luvussa 5*.

`Oneline`- ja `format`-optiot ovat  erityisen hyödyllisiä yhdessä toisen `--graph`-nimisen `log`-komennon option kanssa. Tämä optio lisää kivan pienen ASCII-kaavion esittämään haarasi ja yhdistämisten historiaa, jonka voimme nähdä Grit-projektin tietovaraston kopiossamme:

	$ git log --pretty=format:"%h %s" --graph
	* 2d3acf9 ignore errors from SIGCHLD on trap
	*  5e3ee11 Merge branch 'master' of git://github.com/dustin/grit
	|\
	| * 420eac9 Added a method for getting the current branch.
	* | 30e367c timeout code and tests
	* | 5a09431 add timeout protection to grit
	* | e1193f8 support for heads with slashes in them
	|/
	* d6016bc require time for xmlschema
	*  11d191e Merge branch 'defunkt' into local

Ne ovat vain joitakin yksinkertaisia tulosteenmuotoiluoptioita `git log`ille — monia muitakin on olemassa. Taulukko 2-2 listaa optiot, jotka olemme käsitelleet tähän mennessä sekä joitakin muita yleisiä muotoiluoptioita, jotka voivat olla hyödyllisiä, yhdessä sen kanssa, miten ne muuttavat `log`-komennon tulostetta.

<!-- Attention to translators: this is a table declaration.
The lines must be formatted as follows
<TAB><First column text><TAB><Second column text>
-->

	Optio	Kuvaus
	-p	Näyttää tehdyt muutokset kunkin pysyvän muutoksen yhteydessä.
	--word-diff	Näyttää tehdyt muutokset sanatason eroavaisuuksina.
	--stat	Näyttää kussakin pysyvässä muutoksessa muutetuista tiedostoista tilaston.
	--shortstat	Näyttää vain muuttuneet/lisätyt/poistetut-rivin –stat-komennosta.
	--name-only	Näyttää muutettujen tiedostojen listan pysyvän muutoksen tietojen jälkeen.
	--name-status	Näyttää lisäksi listan vaikutetuista tiedostoista lisätty/muokattu/poistettu-tiedon kera.
	--abbrev-commit	Näyttää vain muutaman ensimmäisen merkin SHA-1-tarkistesummasta kaikkien 40 merkin sijaan.
	--relative-date	Näyttää päiväykset suhteellisessa muodossa (esimerkiksi, ”2 viikkoa sitten”) täyden päiväysmuotoilun käyttämisen sijaan.
	--graph	Näyttää ASCII-kaavion haarasi ja yhdistämisten historiasta lokitulosteen vieressä.
	--pretty	Näyttää pysyvät muutokset vaihtoehtoisessa muodossa. Vaihtoehtoihin kuuluu oneline, short, full, fuller ja format (jossa voit määritellä oman muotoilusi).
	--oneline	Helppokäyttöoptio `--pretty=oneline –abbrev-commit`ille.

### Tulosteen rajaaminen ###

Lisäyksenä tulosteen muotoiluoptioihin, `git log` hyväksyy useita hyödyllisiä rajaamisoptioita — optioita, jotka antavat sinun näyttää vain osajoukon pysyvistä muutoksista. Olet nähnyt yhden sellaisen option ennestään — `-2`-option, joka näyttää vain kaksi viimeisintä pysyvää muutosta. Itse asiassa, voit käyttää `-<n>`:tä, jossa `n` on mikä tahansa kokonaisluku näyttääksesi viimeiset `n` pysyvää muutosta. Todellisuudessa käytät sitä epätodennäköisesti usein, koska oletuksena Git putkittaa kaiken tulosteen sivuttajan läpi, joten näet vain yhden sivun lokitulosteesta kerralla.

Aikarajausoptiot, kuten `--since` ja `--until`, ovat kuitenkin erittäin hyödyllisiä. Esimerkiksi tämä komento hakee listan pysyvistä muutoksista, jotka on tehty kahden viimeisen viikon aikana.

	$ git log --since=2.weeks

Tämä komento toimii useilla muodoilla — voit määritellä tietyn päivämäärän (”15. 1. 2008”) tai suhteellisen päiväyksen, kuten ”2 vuotta 1 päivä ja 3 minuuttia sitten”.

Voit myös suodattaa listan pysyviin muutoksiin, joihin sopii  jokin hakukriteeri. `--author`-optio antaa sinun suodattaa tietyllä tekijällä ja `--grep`-optio etsiä avainsanoja pysyvän muutoksen viestistä (Huomaa, että jos haluat määritellä sekä tekijä- että grep-optiot, täytyy sinun lisätä `--all-match` tai komento sopii pysyviin muutoksiin, jotka täyttävät vain toisen ehdon.)

Viimeinen todella hyödyllinen `git log`ille suodattimena annettava optio on hakemistopolku (path). Jos määrittelet hakemiston tai tiedoston nimen, voit rajata lokitulosteen pysyviin muutoksiin, jotka esittelivät muutokset niihin tiedostoihin. Tämä on aina viimeinen optio ja yleensä varustettu kahden viivan (`--`) etuliitteellä, jotta hakemistopolut erotettaisiin optioista.

Taulukossa 2-3 listaamme nämä ja muutaman muun yleisen option referenssiksesi.

<!-- Attention to translators: this is a table declaration.
The lines must be formatted as follows
<TAB><First column text><TAB><Second column text>
-->

	Optio	Kuvaus
	-(n)	Näyttää vain viimeisimmät n pysyvää muutosta
	--since, --after	Rajaa pysyvät muutokset tietyn päivämäärän jälkeen tehtyihin.
	--until, --before	Rajaa pysyvät muutokset tiettyä päivämäärää ennen tehtyihin.
	--author	Näyttää vain pysyvät muutokset, joiden tekijämerkintä sopii tiettyyn merkkijonoon.
	--committer	Näyttää vain pysyvät muutokset, joiden hyväksyjämerkintä sopii tiettyyn merkkijonoon.

Esimerkiksi, jos haluat nähdä, mitkä testitiedostoja muokanneet pysyvät muutokset Gitin lähdekoodihistoriassa Junio Hamano teki lokakuussa 2008, joita ei ole yhdistetty, voit ajaa jotakuinkin seuraavasti:

	$ git log --pretty="%h - %s" --author=gitster --since="2008-10-01" \
	   --before="2008-11-01" --no-merges -- t/
	5610e3b - Fix testcase failure when extended attribute
	acd3b9e - Enhance hold_lock_file_for_{update,append}()
	f563754 - demonstrate breakage of detached checkout wi
	d1a43f2 - reset --hard/read-tree --reset -u: remove un
	51a94af - Fix "checkout --track -b newbranch" on detac
	b0ad11e - pull: allow "git pull origin $something:$cur

Tämä komento näyttää melkein 20 000 pysyvän muutoksen Gitin lähdekoodihistoriasta 6 näihin ehtoihin sopivaa pysyvää muutosta.

### GUI:n käyttäminen historian visualisointiin ###

Jos haluat käyttää graafisempaa työkalua visualisoidaksesi pysyvien muutosten historiaasi, voit haluta katsoa `gitk`:ksi kutsuttua Tcl/Tk-ohjelmaa, jota levitetään Gitin kanssa. Gitk on periaatteessa visuaalinen `git log` -työkalu ja se hyväksyy lähes kaikki suodatusoptiot, joita `git log`kin hyväksyy. Jos kirjoitat projektissasi komentoriville `gitk`, sinun pitäisi saada Kuvaa 2-2 vastaava tulos.

Insert 18333fig0202.png
Kuva 2-2. Gitk -historian visualisoija.

Voit nähdä pysyvien muutosten historian ikkunan ylemmässä puoliskossa yhdessä kivan syntyperäkaavion kanssa. Vertailuohjelma ikkunan alemmassa puoliskossa näyttää sinulle napsauttamassasi pysyvässä muutoksessa esitellyt muutokset.

## Asioiden kumoaminen ##

Saatat haluta kumota jotain missä tahansa työvaiheessa. Esittelemme tässä muutaman perustyökalun tekemiesi muutosten kumoamiseen. Ole huolellinen, koska et voi aina peruuttaa joitakin näistä kumoamisista. Tämä on yksi muutamasta alueesta Gitissä, joissa voit menettää jonkin verran työtä, jos teet sen väärin.

### Viimeisimmän pysyvän muutoksen muuttaminen ###

Yksi yleinen kumoaminen tapahtuu, kun teet pysyvän muutoksen liian aikaisin ja mahdollisesti unohdat lisätä joitakin tiedostoja tai sähläät pysyvän muutoksen viestin kanssa. Jos haluat yrittää tehdä pysyvää muutosta uudestaan, voit tehdä sen `--amend`-optiolla:

	$ git commit --amend

Tämä komento ottaa valmistelualueesi ja käyttää sitä pysyvään muutokseen. Jos et ole tehnyt muutoksia viimeisimmän pysyvän muutoksesi jälkeen (esimerkiksi, jos ajat tämän komennon heti edellisen pysyvän muutoksesi jälkeen), tilannekuvasi näyttää tarkalleen samalta ja kaikki, mitä muutat, on pysyvän muutoksesi viesti.

Sama pysyvän muutoksen viestin editori aktivoituu, mutta se sisältää jo viestin edellisestä pysyvästä muutoksesta. Voit muokata viestiä samoin kuin aina, mutta se korvaa edellisen pysyvän muutoksesi.

Esimerkkinä, jos teet pysyvän muutoksen ja sitten huomaat unohtaneesi valmistelee muutokset tiedostossa, jonka haluat lisätä tähän pysyvään muutokseen, voit tehdä jotakuinkin seuraavasti:

	$ git commit -m 'initial commit'
	$ git add unohtunut_tiedosto
	$ git commit --amend

Näiden kolmen komennon jälkeen päädyt yhteen pysyvään muutokseen — toinen pysyvä muutos korvaa ensimmäisen.

### Valmistellun tiedoston valmistelun purkaminen ###

Kaksi seuraavaa kappaletta havainnollistavat, kuinka paimentaa muutoksia valmistelualueellasi ja työskentelyhakemistossasi. Mukava osa on, että komento, jota käytät selvittääksesi näiden kahden alueen tilan, muistuttaa sinua myös, kuinka peruuttaa muutokset niihin. Sanokaamme, esimerkiksi, että olet muuttanut kahta tiedostoa ja haluat tehdä niistä kaksi erillistä pysyvää muutosta, mutta kirjoitit vahingossa `git add *` ja valmistelit ne molemmat. Kuinka voit purkaa toisen valmistelun? `Git status` -komento muistuttaa sinua:

	$ git add .
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#       modified:   benchmarks.rb
	#

Heti ”Changes to be committed” -tekstin alla, sanotaan "use `git reset HEAD <file>...` to unstage". Joten, käyttäkäämme tätä neuvoa purkaaksemme `benchmarks.rb`-tiedoston valmistelun:

	$ git reset HEAD benchmarks.rb
	benchmarks.rb: locally modified
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#
	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   benchmarks.rb
	#

Komento on hieman kummallinen, mutta se toimii. `Benchmarks.rb`-tiedosto on muokattu mutta valmistelematon jälleen.

### Muutetun tiedoston muutosten kumoaminen ###

Mitä, jos tajuat, ettet halua säilyttää muutoksiasi `benchmarks.rb`-tiedostoon? Kuinka voit helposti kumota sen muutokset — palauttaa sen takaisin sellaiseksi, miltä se näytti, kun teit viimeksi pysyvän muutoksen (tai alun perin kloonasit tai miten saitkaan sen työskentelyhakemistoosi)? Onneksi `git status` kertoo sinulle myös, miten tämä tehdään. Edellisessä esimerkkitulosteessa valmistelematon alue näyttää tältä:

	# Changes not staged for commit:
	#   (use "git add <file>..." to update what will be committed)
	#   (use "git checkout -- <file>..." to discard changes in working directory)
	#
	#       modified:   benchmarks.rb
	#

Se kertoo sinulle melko selvästi, kuinka hylätä tekemäsi muutokset (ainakin Gitin uudemmat versiot, 1.6.1 ja uudemmat, tekevät tämän — jos sinulla on vanhempi versio, suosittelemme lämpimästi sen päivittämistä saadaksesi joitakin näistä mukavammista käytettävyysominaisuuksista). Tehkäämme kuten se sanoo:

	$ git checkout -- benchmarks.rb
	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#       modified:   README.txt
	#

Voit nähdä, että muutokset on peruutettu. Sinun tulisi myös ymmärtää, että tämä on vaarallinen komento: kaikki tähän tiedostoon tekemäsi muutokset ovat mennyttä — kopioit juuri toisen tiedoston sen päälle. Älä koskaan käytä tätä komentoa ellet ehdottomasti tiedä, ettet halua säilyttää tiedostoa. Jos sinun täytyy ainoastaan saada se pois tieltä, käymme läpi kätkemisen ja haarautumisen seuraavassa luvussa; ne ovat usein parempia tapoja toimia.

Muista, että kaikki, mistä on tehty pysyvä muutos Gitiin, voidaan melkein aina palauttaa. Jopa poistetuissa haaroissa olleet tai `--amend`-optiolla ylikirjoitetut pysyvät muutokset voidaan palauttaa (katso *Luku 9* datan palauttamiseksi). Kuitenkin, mitään, minkä hävität ja mistä ei ole tehty pysyvää muutosta, ei nähdä todennäköisesti koskaan uudelleen.

## Working with Remotes ##

To be able to collaborate on any Git project, you need to know how to manage your remote repositories. Remote repositories are versions of your project that are hosted on the Internet or network somewhere. You can have several of them, each of which generally is either read-only or read/write for you. Collaborating with others involves managing these remote repositories and pushing and pulling data to and from them when you need to share work.
Managing remote repositories includes knowing how to add remote repositories, remove remotes that are no longer valid, manage various remote branches and define them as being tracked or not, and more. In this section, we’ll cover these remote-management skills.

### Showing Your Remotes ###

To see which remote servers you have configured, you can run the `git remote` command. It lists the shortnames of each remote handle you’ve specified. If you’ve cloned your repository, you should at least see *origin* — that is the default name Git gives to the server you cloned from:

	$ git clone git://github.com/schacon/ticgit.git
	Initialized empty Git repository in /private/tmp/ticgit/.git/
	remote: Counting objects: 595, done.
	remote: Compressing objects: 100% (269/269), done.
	remote: Total 595 (delta 255), reused 589 (delta 253)
	Receiving objects: 100% (595/595), 73.31 KiB | 1 KiB/s, done.
	Resolving deltas: 100% (255/255), done.
	$ cd ticgit
	$ git remote
	origin

You can also specify `-v`, which shows you the URL that Git has stored for the shortname to be expanded to:

	$ git remote -v
	origin  git://github.com/schacon/ticgit.git (fetch)
	origin  git://github.com/schacon/ticgit.git (push)

If you have more than one remote, the command lists them all. For example, my Grit repository looks something like this.

	$ cd grit
	$ git remote -v
	bakkdoor  git://github.com/bakkdoor/grit.git
	cho45     git://github.com/cho45/grit.git
	defunkt   git://github.com/defunkt/grit.git
	koke      git://github.com/koke/grit.git
	origin    git@github.com:mojombo/grit.git

This means we can pull contributions from any of these users pretty easily. But notice that only the origin remote is an SSH URL, so it’s the only one I can push to (we’ll cover why this is in *Chapter 4*).

### Adding Remote Repositories ###

I’ve mentioned and given some demonstrations of adding remote repositories in previous sections, but here is how to do it explicitly. To add a new remote Git repository as a shortname you can reference easily, run `git remote add [shortname] [url]`:

	$ git remote
	origin
	$ git remote add pb git://github.com/paulboone/ticgit.git
	$ git remote -v
	origin	git://github.com/schacon/ticgit.git
	pb	git://github.com/paulboone/ticgit.git

Now you can use the string `pb` on the command line in lieu of the whole URL. For example, if you want to fetch all the information that Paul has but that you don’t yet have in your repository, you can run `git fetch pb`:

	$ git fetch pb
	remote: Counting objects: 58, done.
	remote: Compressing objects: 100% (41/41), done.
	remote: Total 44 (delta 24), reused 1 (delta 0)
	Unpacking objects: 100% (44/44), done.
	From git://github.com/paulboone/ticgit
	 * [new branch]      master     -> pb/master
	 * [new branch]      ticgit     -> pb/ticgit

Paul’s master branch is accessible locally as `pb/master` — you can merge it into one of your branches, or you can check out a local branch at that point if you want to inspect it.

### Fetching and Pulling from Your Remotes ###

As you just saw, to get data from your remote projects, you can run:

	$ git fetch [remote-name]

The command goes out to that remote project and pulls down all the data from that remote project that you don’t have yet. After you do this, you should have references to all the branches from that remote, which you can merge in or inspect at any time. (We’ll go over what branches are and how to use them in much more detail in *Chapter 3*.)

If you clone a repository, the command automatically adds that remote repository under the name *origin*. So, `git fetch origin` fetches any new work that has been pushed to that server since you cloned (or last fetched from) it. It’s important to note that the `fetch` command pulls the data to your local repository — it doesn’t automatically merge it with any of your work or modify what you’re currently working on. You have to merge it manually into your work when you’re ready.

If you have a branch set up to track a remote branch (see the next section and *Chapter 3* for more information), you can use the `git pull` command to automatically fetch and then merge a remote branch into your current branch. This may be an easier or more comfortable workflow for you; and by default, the `git clone` command automatically sets up your local master branch to track the remote master branch on the server you cloned from (assuming the remote has a master branch). Running `git pull` generally fetches data from the server you originally cloned from and automatically tries to merge it into the code you’re currently working on.

### Pushing to Your Remotes ###

When you have your project at a point that you want to share, you have to push it upstream. The command for this is simple: `git push [remote-name] [branch-name]`. If you want to push your master branch to your `origin` server (again, cloning generally sets up both of those names for you automatically), then you can run this to push your work back up to the server:

	$ git push origin master

This command works only if you cloned from a server to which you have write access and if nobody has pushed in the meantime. If you and someone else clone at the same time and they push upstream and then you push upstream, your push will rightly be rejected. You’ll have to pull down their work first and incorporate it into yours before you’ll be allowed to push. See *Chapter 3* for more detailed information on how to push to remote servers.

### Inspecting a Remote ###

If you want to see more information about a particular remote, you can use the `git remote show [remote-name]` command. If you run this command with a particular shortname, such as `origin`, you get something like this:

	$ git remote show origin
	* remote origin
	  URL: git://github.com/schacon/ticgit.git
	  Remote branch merged with 'git pull' while on branch master
	    master
	  Tracked remote branches
	    master
	    ticgit

It lists the URL for the remote repository as well as the tracking branch information. The command helpfully tells you that if you’re on the master branch and you run `git pull`, it will automatically merge in the master branch on the remote after it fetches all the remote references. It also lists all the remote references it has pulled down.

That is a simple example you’re likely to encounter. When you’re using Git more heavily, however, you may see much more information from `git remote show`:

	$ git remote show origin
	* remote origin
	  URL: git@github.com:defunkt/github.git
	  Remote branch merged with 'git pull' while on branch issues
	    issues
	  Remote branch merged with 'git pull' while on branch master
	    master
	  New remote branches (next fetch will store in remotes/origin)
	    caching
	  Stale tracking branches (use 'git remote prune')
	    libwalker
	    walker2
	  Tracked remote branches
	    acl
	    apiv2
	    dashboard2
	    issues
	    master
	    postgres
	  Local branch pushed with 'git push'
	    master:master

This command shows which branch is automatically pushed when you run `git push` on certain branches. It also shows you which remote branches on the server you don’t yet have, which remote branches you have that have been removed from the server, and multiple branches that are automatically merged when you run `git pull`.

### Removing and Renaming Remotes ###

If you want to rename a reference, in newer versions of Git you can run `git remote rename` to change a remote’s shortname. For instance, if you want to rename `pb` to `paul`, you can do so with `git remote rename`:

	$ git remote rename pb paul
	$ git remote
	origin
	paul

It’s worth mentioning that this changes your remote branch names, too. What used to be referenced at `pb/master` is now at `paul/master`.

If you want to remove a reference for some reason — you’ve moved the server or are no longer using a particular mirror, or perhaps a contributor isn’t contributing anymore — you can use `git remote rm`:

	$ git remote rm paul
	$ git remote
	origin

## Tagging ##

Like most VCSs, Git has the ability to tag specific points in history as being important. Generally, people use this functionality to mark release points (`v1.0`, and so on). In this section, you’ll learn how to list the available tags, how to create new tags, and what the different types of tags are.

### Listing Your Tags ###

Listing the available tags in Git is straightforward. Just type `git tag`:

	$ git tag
	v0.1
	v1.3

This command lists the tags in alphabetical order; the order in which they appear has no real importance.

You can also search for tags with a particular pattern. The Git source repo, for instance, contains more than 240 tags. If you’re only interested in looking at the 1.4.2 series, you can run this:

	$ git tag -l 'v1.4.2.*'
	v1.4.2.1
	v1.4.2.2
	v1.4.2.3
	v1.4.2.4

### Creating Tags ###

Git uses two main types of tags: lightweight and annotated. A lightweight tag is very much like a branch that doesn’t change — it’s just a pointer to a specific commit. Annotated tags, however, are stored as full objects in the Git database. They’re checksummed; contain the tagger name, e-mail, and date; have a tagging message; and can be signed and verified with GNU Privacy Guard (GPG). It’s generally recommended that you create annotated tags so you can have all this information; but if you want a temporary tag or for some reason don’t want to keep the other information, lightweight tags are available too.

### Annotated Tags ###

Creating an annotated tag in Git is simple. The easiest way is to specify `-a` when you run the `tag` command:

	$ git tag -a v1.4 -m 'my version 1.4'
	$ git tag
	v0.1
	v1.3
	v1.4

The `-m` specifies a tagging message, which is stored with the tag. If you don’t specify a message for an annotated tag, Git launches your editor so you can type it in.

You can see the tag data along with the commit that was tagged by using the `git show` command:

	$ git show v1.4
	tag v1.4
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 14:45:11 2009 -0800

	my version 1.4
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

That shows the tagger information, the date the commit was tagged, and the annotation message before showing the commit information.

### Signed Tags ###

You can also sign your tags with GPG, assuming you have a private key. All you have to do is use `-s` instead of `-a`:

	$ git tag -s v1.5 -m 'my signed 1.5 tag'
	You need a passphrase to unlock the secret key for
	user: "Scott Chacon <schacon@gee-mail.com>"
	1024-bit DSA key, ID F721C45A, created 2009-02-09

If you run `git show` on that tag, you can see your GPG signature attached to it:

	$ git show v1.5
	tag v1.5
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 15:22:20 2009 -0800

	my signed 1.5 tag
	-----BEGIN PGP SIGNATURE-----
	Version: GnuPG v1.4.8 (Darwin)

	iEYEABECAAYFAkmQurIACgkQON3DxfchxFr5cACeIMN+ZxLKggJQf0QYiQBwgySN
	Ki0An2JeAVUCAiJ7Ox6ZEtK+NvZAj82/
	=WryJ
	-----END PGP SIGNATURE-----
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

A bit later, you’ll learn how to verify signed tags.

### Lightweight Tags ###

Another way to tag commits is with a lightweight tag. This is basically the commit checksum stored in a file — no other information is kept. To create a lightweight tag, don’t supply the `-a`, `-s`, or `-m` option:

	$ git tag v1.4-lw
	$ git tag
	v0.1
	v1.3
	v1.4
	v1.4-lw
	v1.5

This time, if you run `git show` on the tag, you don’t see the extra tag information. The command just shows the commit:

	$ git show v1.4-lw
	commit 15027957951b64cf874c3557a0f3547bd83b3ff6
	Merge: 4a447f7... a6b4c97...
	Author: Scott Chacon <schacon@gee-mail.com>
	Date:   Sun Feb 8 19:02:46 2009 -0800

	    Merge branch 'experiment'

### Verifying Tags ###

To verify a signed tag, you use `git tag -v [tag-name]`. This command uses GPG to verify the signature. You need the signer’s public key in your keyring for this to work properly:

	$ git tag -v v1.4.2.1
	object 883653babd8ee7ea23e6a5c392bb739348b1eb61
	type commit
	tag v1.4.2.1
	tagger Junio C Hamano <junkio@cox.net> 1158138501 -0700

	GIT 1.4.2.1

	Minor fixes since 1.4.2, including git-mv and git-http with alternates.
	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Good signature from "Junio C Hamano <junkio@cox.net>"
	gpg:                 aka "[jpeg image of size 1513]"
	Primary key fingerprint: 3565 2A26 2040 E066 C9A7  4A7D C0C6 D9A4 F311 9B9A

If you don’t have the signer’s public key, you get something like this instead:

	gpg: Signature made Wed Sep 13 02:08:25 2006 PDT using DSA key ID F3119B9A
	gpg: Can't check signature: public key not found
	error: could not verify the tag 'v1.4.2.1'

### Tagging Later ###

You can also tag commits after you’ve moved past them. Suppose your commit history looks like this:

	$ git log --pretty=oneline
	15027957951b64cf874c3557a0f3547bd83b3ff6 Merge branch 'experiment'
	a6b4c97498bd301d84096da251c98a07c7723e65 beginning write support
	0d52aaab4479697da7686c15f77a3d64d9165190 one more thing
	6d52a271eda8725415634dd79daabbc4d9b6008e Merge branch 'experiment'
	0b7434d86859cc7b8c3d5e1dddfed66ff742fcbc added a commit function
	4682c3261057305bdd616e23b64b0857d832627b added a todo file
	166ae0c4d3f420721acbb115cc33848dfcc2121a started write support
	9fceb02d0ae598e95dc970b74767f19372d61af8 updated rakefile
	964f16d36dfccde844893cac5b347e7b3d44abbc commit the todo
	8a5cbc430f1a9c3d00faaeffd07798508422908a updated readme

Now, suppose you forgot to tag the project at `v1.2`, which was at the "updated rakefile" commit. You can add it after the fact. To tag that commit, you specify the commit checksum (or part of it) at the end of the command:

	$ git tag -a v1.2 -m 'version 1.2' 9fceb02

You can see that you’ve tagged the commit:

	$ git tag
	v0.1
	v1.2
	v1.3
	v1.4
	v1.4-lw
	v1.5

	$ git show v1.2
	tag v1.2
	Tagger: Scott Chacon <schacon@gee-mail.com>
	Date:   Mon Feb 9 15:32:16 2009 -0800

	version 1.2
	commit 9fceb02d0ae598e95dc970b74767f19372d61af8
	Author: Magnus Chacon <mchacon@gee-mail.com>
	Date:   Sun Apr 27 20:43:35 2008 -0700

	    updated rakefile
	...

### Sharing Tags ###

By default, the `git push` command doesn’t transfer tags to remote servers. You will have to explicitly push tags to a shared server after you have created them.  This process is just like sharing remote branches — you can run `git push origin [tagname]`.

	$ git push origin v1.5
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	* [new tag]         v1.5 -> v1.5

If you have a lot of tags that you want to push up at once, you can also use the `--tags` option to the `git push` command.  This will transfer all of your tags to the remote server that are not already there.

	$ git push origin --tags
	Counting objects: 50, done.
	Compressing objects: 100% (38/38), done.
	Writing objects: 100% (44/44), 4.56 KiB, done.
	Total 44 (delta 18), reused 8 (delta 1)
	To git@github.com:schacon/simplegit.git
	 * [new tag]         v0.1 -> v0.1
	 * [new tag]         v1.2 -> v1.2
	 * [new tag]         v1.4 -> v1.4
	 * [new tag]         v1.4-lw -> v1.4-lw
	 * [new tag]         v1.5 -> v1.5

Now, when someone else clones or pulls from your repository, they will get all your tags as well.

## Tips and Tricks ##

Before we finish this chapter on basic Git, a few little tips and tricks may make your Git experience a bit simpler, easier, or more familiar. Many people use Git without using any of these tips, and we won’t refer to them or assume you’ve used them later in the book; but you should probably know how to do them.

### Auto-Completion ###

If you use the Bash shell, Git comes with a nice auto-completion script you can enable. Download the Git source code, and look in the `contrib/completion` directory; there should be a file called `git-completion.bash`. Copy this file to your home directory, and add this to your `.bashrc` file:

	source ~/.git-completion.bash

If you want to set up Git to automatically have Bash shell completion for all users, copy this script to the `/opt/local/etc/bash_completion.d` directory on Mac systems or to the `/etc/bash_completion.d/` directory on Linux systems. This is a directory of scripts that Bash will automatically load to provide shell completions.

If you’re using Windows with Git Bash, which is the default when installing Git on Windows with msysGit, auto-completion should be preconfigured.

Press the Tab key when you’re writing a Git command, and it should return a set of suggestions for you to pick from:

	$ git co<tab><tab>
	commit config

In this case, typing `git co` and then pressing the Tab key twice suggests commit and config. Adding `m<tab>` completes `git commit` automatically.

This also works with options, which is probably more useful. For instance, if you’re running a `git log` command and can’t remember one of the options, you can start typing it and press Tab to see what matches:

	$ git log --s<tab>
	--shortstat  --since=  --src-prefix=  --stat   --summary

That’s a pretty nice trick and may save you some time and documentation reading.

### Git Aliases ###

Git doesn’t infer your command if you type it in partially. If you don’t want to type the entire text of each of the Git commands, you can easily set up an alias for each command using `git config`. Here are a couple of examples you may want to set up:

	$ git config --global alias.co checkout
	$ git config --global alias.br branch
	$ git config --global alias.ci commit
	$ git config --global alias.st status

This means that, for example, instead of typing `git commit`, you just need to type `git ci`. As you go on using Git, you’ll probably use other commands frequently as well; in this case, don’t hesitate to create new aliases.

This technique can also be very useful in creating commands that you think should exist. For example, to correct the usability problem you encountered with unstaging a file, you can add your own unstage alias to Git:

	$ git config --global alias.unstage 'reset HEAD --'

This makes the following two commands equivalent:

	$ git unstage fileA
	$ git reset HEAD fileA

This seems a bit clearer. It’s also common to add a `last` command, like this:

	$ git config --global alias.last 'log -1 HEAD'

This way, you can see the last commit easily:

	$ git last
	commit 66938dae3329c7aebe598c2246a8e6af90d04646
	Author: Josh Goebel <dreamer3@example.com>
	Date:   Tue Aug 26 19:48:51 2008 +0800

	    test for current head

	    Signed-off-by: Scott Chacon <schacon@example.com>

As you can tell, Git simply replaces the new command with whatever you alias it to. However, maybe you want to run an external command, rather than a Git subcommand. In that case, you start the command with a `!` character. This is useful if you write your own tools that work with a Git repository. We can demonstrate by aliasing `git visual` to run `gitk`:

	$ git config --global alias.visual '!gitk'

## Summary ##

At this point, you can do all the basic local Git operations — creating or cloning a repository, making changes, staging and committing those changes, and viewing the history of all the changes the repository has been through. Next, we’ll cover Git’s killer feature: its branching model.
