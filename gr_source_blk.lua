local coroutine = coroutine
local source    = source

--- <p>Unterklasse von <a href="/modules/source.html">source</a></p>
--  <p><a href="/modules/source.html">source</a>-Objekte, die
--  von anderen <a href="/modules/source.html">source</a>-Objekten
--  erzeugte ASCII-Character zu je <code>n</code> Zeichen zu Bl&ouml;cken 
--  zusammensetzen, und diese dann von sich geben.</p>
--  <p>Beachte die allgemeinen Erl&auml;uterungen im Kapitel
--  zum Modul <a href="/modules/source.html">source</a> bez&uuml;glich
--  <a href="/modules/source.html">source</a>-Objekten.
module "source.blk"

--- <p>Fehlermeldung: L&auml;nge der Eingabe nicht durch
--   <code>n</code> teilbar, so da&szlig; Zeichen in der
--   Eingabe &uml;brigbleiben.</p>
--  <p>Gew&ouml;hnlich wird diese Methode mit einer geeigneten
--   Fehlerbehandlungsroutine &uuml;berladen.</p>
function except_blk()
 self:error('letzter Block unvollst&auml;ndig')
end

--- <p>erzeugt Objekte der Klasse
--  <a href="/modules/source.blk.html">source.bytes</a></p>
--  @param src <a href="/modules/source.html">source</a>-Objekt
--  @param n Bl&ouml;ckgr&ouml;&szlig;e
--  @return das Objekt der Klasse
--  <a href="/modules/source.blk.html">source.blk</a>
function new(self, src, n)
 local co = coroutine.create(
  function()
   while true
   do   local accu = ""
        for i = 1, n
        do   local status = src:next()
             if   status == "stop"
             then if   i ~= n
                  then self:except_blk()
                       return
                  end
             else accu = accu .. src:cur()
             end
        end
        coroutine.yield(accu)
        if   status == "stop"
        then return
        end
   end
  end
 )
 return source.new(self, co)
end
