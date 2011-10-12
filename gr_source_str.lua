local coroutine = coroutine
local source    = source


--- <p>Unterklasse von <a href="/modules/source.html">source</a></p>
--  <p>Klasse von <a href="/modules/source.html">source</a>-Objekten,
--  die genau eine Zeichenkette generieren und dann nichts mehr.</p>
--  <p>Beachte die allgemeinen Erl&auml;uterungen im Kapitel
--  zum Modul <a href="/modules/source.html">source</a> bez&uuml;glich
--  <a href="/modules/source.html">source</a>-Objekten.</p>
module "source.str"

--- <p>erzeugt ein Objekt der Klasse
--  <a href="/modules/source.str.html">source.str</a>.</p>
--  @param s Zeichenkette, die vom zu erzeugenden
--  <a href="/modules/source.html">source</a>-Objekt generiert werden soll.
--  @return das Objekt der Klasse
--  <a href="/modules/source.str.html">source.str</a>
function new(self, s)
 local co = coroutine.create(
  function()
   coroutine.yield(s)
  end
 )
 return source.new(self, co)
end

