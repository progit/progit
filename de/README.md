# Deutsche Übersetzung

Wenn du mitarbeiten willst, melde dich einfach. Ich werde dich als
Collaborator hinzufügen - es ist leichter im gleichen Repository zu arbeiten.

Wir haben die Arbeit bisher kaum strukturiert, mit Ausnahme folgender
Konvention, einer Mailingliste und untenstehenden Workflows.

-> Wenn du mit einem Kapitel anfangen willst, "checke" es dadurch "aus", daß
   du eine neue, leere Datei dafür anlegst, commitest und pushst.

Andere sehen dann, daß jemand bereits an diesem Kapitel arbeitet, und wir
können hoffentlich doppelte Arbeit vermeiden.

Mailingliste:

Unsere Mailingliste ist hier: http://groups.google.com/group/progit-german

Wenn du an der deutschen Übersetzung von Progit arbeitest oder arbeiten willst, sag uns dort bitte bescheid, damit wir uns alle eventuelle doppelte Arbeit sparen :)

Workflow:

Wir arbeiten lokal in einem working/topic branch. Du kannst diesen branch nach Github pushen, wenn du willst, aber du solltest die working branches anderer nicht ändern.

Der branch, in den wir unsere gemeinsame Arbeit an der deutschen Übersetzung synchronisieren (mergen) ist der branch translation-de. Wir verwenden dazu nicht master, damit es einfacher ist master in Sync mit Scott's Repository zu halten.

git clone git@github.com:svenfuchs/progit.git

# Lokalen working branch anlegen, darin arbeiten, rebasen und pushen
git checkout --track -b translation-de origin/translation-de
git checkout -b work
# ... Änderungen in diesem branch vornehmen ...
git checkout translation-de
git pull
git checkout work
git rebase translation-de
# ggf. Konflikte beheben:
# git mergetool
# git rebase --continue
git checkout translation-de
git merge work
git push

# Möglicherweise vorhandene Änderungen bei uns auf progit/master rebasen
git remote add progit git://github.com/progit/progit.git
git fetch progit
git rebase progit/master
# ggf. Konflikte beheben:
# git mergetool
# git rebase --continue
git push

# Änderungen aus translation-de auf master rebasen
git checkout master
git pull
git checkout translation-de
git rebase master
# ggf. Konflikte beheben:
# git mergetool
# git rebase --continue
git checkout master
git merge translation-de
git push

Einige Erfahrungen:

* Es macht Sinn, möglichst oft zu rebasen und zu pushen, damit man nicht
  allzuviele Konflikte erhält.

* Wenn du andere wirklich nerven willst, dann nimm Rechtschreibkorrekturen an
  ihren noch unfertigen Übersetzungen vor. Rechtschreibung und Feinheiten in
  Formulierungen zu korrigieren, daß man zahlreiche winzige Änderungen in
  verschiedenen Versionen von ganzen Absätzen zusammenführen muß. Das kostet
  massiv Zeit und lohnt sich einfach nicht, solange die Übersetzung noch nicht
  fertig ist.

* Es macht Sinn, die Englische Fassung des Textes zu kopieren und dann Absatz
  für Absatz die Übersetzung einzufügen, das Original aber vorläufig stehen zu
  lassen. Das macht es leichter, in späteren Iterationen mit dem Original zu
  vergleichen.

* Ich fand es nützlich in Iterationen zu arbeiten, um möglichst die ganze Zeit
  mentail im gleichen "Modus" zu bleiben. In meiner ersten Iteration habe ich
  das Original so zügig wie möglich übersetzt. Schwierigere Stellen oder Worte
  habe ich lediglich mit "xxx" markiert und bin weitergegangen. In der zweiten
  Iteration habe ich dann mehr auf den Stil geachtet, umformuliert und die
  (wenigen) zuvor ausgelassenen Stellen nach-übersetzt.

* Ich arbeite wesentlich effizienter, wenn ich mir eine Timebox setze und in
  mich in dieser Zeit von nichts anderem ablenken lasse. Das funktioniert für
  mich z.B. gut morgens in der U-Bahn auf dem Weg ins Office und nachmittags
  wieder zurück. Dort kann ich etwa eine halbe Stunde lang ungestört
  übersetzen - eine Zeitspanne, die ich als angenehm empfinde.

