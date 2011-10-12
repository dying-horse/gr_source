local coroutine     = coroutine
local error         = source.error
local io            = io
local source        = source

--- <p>Unterklasse von <a href="/modules/source.html">source</a></p>
--  <p>Klasse von
--  <a href="/modules/source.html">source</a>-Objekten, die den Inhalt
--  von Dateien blockweise generiert.</p>
--  <p>Beachte die allgemeinen Erl&auml;uterungen im Kapitel
--  zum Modul <a href="/modules/source.html">source</a> bez&uuml;glich
--  <a href="/modules/source.html">source</a>-Objekten.
module "source.file"

--- <p>Fehlermeldung, da&szlig; Datei <code>name</code>
--  nicht ge&ouml;ffnet werden kann, etwa weil sie nicht existiert.<p>
--  <p>Gew&ouml;hnlich wird diese Methode mit einer geeigneten
--  Fehlerbearbeitungsroutine &uuml;berladen.</p>
--  @param name Dateiname als Zeichenkette, die nicht ge&ouml;ffnet
--  werden kann.
function except_open(self, name)
 self:error("cannot open file " .. name)
end

--- <p>erzeugt ein
--  <a href="/modules/source.file.html">source.file</a>-Objekt.</p>
--  @param name eine Zeichenkette, die den Dateinamen enth&auml;lt.
--  @param opt  (optional) ein table mit optionalen Parametern.
--  <ul>
--   <li>Schl&uuml;ssel <code>"blksize"</code>: Blockgr&ouml;&szlig;e</li>
--  </ul>
--  @return das Objekt der Klasse
--  <a href="/modules/source.file.html">source.file</a>
function new(self, name, opt)
 local lopt    = opt or {}
 local blksize = lopt.blksize or 4096
 local co = coroutine.create(
  function()
   local fd, err = io.open(name)
   if   (fd)
   then while true
        do   local blk = fd:read(blksize or 4096)
             if   (blk)
             then coroutine.yield(blk)
             else do   fd:close()
                       return
                  end
             end
        end
   else self:except_open(name)
        return
   end
  end
 )
 local ret = source.new(self, co)
 ret.opt   = lopt
 return ret
end 

