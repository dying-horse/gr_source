local coroutine = coroutine
local ipairs    = ipairs
local source    = source
local string    = string

--- <p>Unterklasse von <a href="/modules/source.html">source</a></p>
--  <p><a href="/modules/source.html">source</a>-Objekte, die
--  von anderen <a href="/modules/source.html">source</a>-Objekten
--  erzeugte Zeichenketten in die Einzelzeichen, d.h. in
--  Zeichenkette der L&auml;nge 1, zerlegen, und diese dann von sich
--  geben.</p>
--  <p>Beachte die allgemeinen Erl&auml;uterungen im Kapitel
--  zum Modul <a href="/modules/source.html">source</a> bez&uuml;glich
--  <a href="/modules/source.html">source</a>-Objekten.
module "source.bytes"

--- <p>erzeugt Objekte der Klasse
--  <a href="/modules/source.bytes.html">source.bytes</a></p>
--  @param src <a href="/modules/source.html">source</a>-Objekt
--  @return das Objekt der Klasse
--  <a href="/modules/source.bytes.html">source.bytes</a>
function new(self, src)
 local co = coroutine.create(
  function()
   for blk in src
   do    for i, b in ipairs { string.byte(blk, 1, -1) }
         do  coroutine.yield(string.char(b))
         end
   end
  end
 )
 return source.new(self, co)
end

