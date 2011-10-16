Allgemeine Hinweise:

* Nutzer, die dieses lua-Modul nur installieren wollen, gehen dabei am
  besten so wie [hier](https://github.com/dying-horse/gr_rocks/#readme)
  beschrieben vor.
* Mehr Dokumentation gibt es, wenn man im Basis-Verzeichnis
  `luadoc .` aufruft.  Hierzu benötigt man das
  [luadoc](http://keplerproject.github.com/luadoc/)-System, das man sich
  mit Hilfe von [luarocks](http://luarocks.org/) beschaffen kann:
  `luarocks install luadoc`.


Um `gr_source` zu aktivieren, verwende:

	require "gr_source"
	

`gr_source` definiert eine `source`-Klasse, deren Objekte in
`for`-Schleifen als Iterator dienen können.  Das folgende
Beispiel demonstriert den Gebrauch der Unterklasse
`source.file`:

	-- erzeugt Unterklasse my_file von source.file
	my_file = {}
	setmetatable(my_file, { __index = source.file })
	
	-- überlädt Methode except_open, um Fehlerbehandlung zu realisieren
	function my_file:except_open(name)
	 print("Kann Datei "..name.." nicht öffnen.\n")
	end
	
	-- gebraucht eine Instanz von my_file
	for s in my_file:new("irgendeine.datei")
	do     print(s)
	end

In diesem Beispiel wird der Inhalt der Datei irgendeine.datei
blockweise auf den Bildschirm ausgegeben.


Der Konstruktor
===============

Erzeugt werden Objekte der `source`-Klasse mit Hilfe von Coroutinen,
die all jene Dinge in ihren `yield`-Anweisungen liefern, die das
`source`-Objekt von sich geben soll.  Beispiel:

	co = coroutine.create(function()
	  coroutine.yield("Mon")
	  coroutine.yield("Tue")
	  coroutine.yield("Wed")
	  coroutine.yield("Thu")
	  coroutine.yield("Fri")
	  coroutine.yield("Sat")
	  coroutine.yield("Sun")
	 end
	)
	
	for s in source:new(co)
	do     print(s)
	end


Acceptoren
==========

Neben diesen Iteratoren stellt die `source`-Klasse den
Acceptor-Mechanismus bereit.  Acceptoren sind abstrakte Automaten,
die aus einer Zustandsüberführungsfunktion
`source.next()` und einer Zustandsfunktion
`source.cur()` bestehen.
`source.next()` rückt den Acceptor eine Position weiter und liefert
eines der folgenden möglichen Rückgabewerte:

* die Zeichenkette "stop", falls es keine Zeichen mehr zu lesen gibt,
* die Zeichenkette "go" sonst

Die Funktion `source.cur()` gibt das aktuell am Acceptor anliegende
Ding zurück.  `source.cur()` ergibt nur definierte Werte, wenn zuvor
wenigstens einmal `source.next()` aufgerufen wurde, und `source.next()`
den Wert "go" zurücklieferte.

Mit Hilfe von Acceptoren können Parser aufgebaut werden.
Derartige Parser verarbeiten ein `source`-Objekt als Argument und
liefern eines der folgenden Rückgabewerte:

* die Zeichenkette "no", falls der Parser den Zustand am Acceptor
  nicht acceptiert.  Der Zustand des Acceptors bleibt unverändert
  in diesem Falle.
* die Zeichenkette "stop", und eventuell einen zweiten Rückgabewert,
  falls der Zustand des Acceptors acceptiert wurde, nun aber kein
  Zeichen mehr am Acceptor anliegt.
* die Zeichenkette "go", und eventuell einen zweiten Rückgabewert,
  falls der Zustand des Acceptors acceptiert wurde, und noch
  Zeichen vorhanden sind, die gelesen werden könnten.
* manchmal die Zeichenkette "unclosed", und eventuell einen zweiten
  Rückgabewert, falls die Zeichen am Acceptor verbraucht sind, aber
  mehr Zeichen erwartet werden.  Ein solcher Fall kann zum Beispiel
  bei Zeichenketten eintreten, bei denen das abschließende "
  fehlt.

Der zweite Rückgabewert gibt die Bedeutung der vom Parser gelesenen
Zeichen zurück.  Der Aufruf eines Parsers setzt voraus, daß mindestens
einmal zuvor `source.next()` oder ein anderer Parser aufgerufen wurde
und dabei die Rückgabewerte "stop" oder "unclosed" nicht auftraten.

Es folgt ein Beispiel:  Es parst in " eingeschlossene Zeichenketten.

	-- der Acceptor
	function parse_string(src)
	 if     src:cur() ~= '"'
	 then   return "no"
	 end
	
	 local accu = ""
	 while true
	 do     local ret
	        ret = src:next()
	        if     ret == "stop"
	        then   return "unclosed", accu
	        elseif src:cur() == '"'
	        then   return ret, accu
	        end
	        accu = accu .. src:cur()
	 end
	end
	
	-- source.bytes:new liefert source-Objekt, das
	-- das als Argument übergebene source-Objekt in die char
	-- zerlegt, aus denen es besteht.
	src = source.bytes:new(my_file:new("irgendeine.datei"))
	ret = src:next() -- erster Aufruf, um src zu initialisieren
        if     (ret == "stop")
        then   ... -- tue entsprechende Dinge, um abzubrechen
        end
	
	-- gebraucht den Acceptor
	ret, string = parse_string(src)
	if     ret == "no"
	then   print "no"
	else   print(ret..": "..string.."\n")
	end
