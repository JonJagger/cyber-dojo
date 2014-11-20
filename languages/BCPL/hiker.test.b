
GET "hiker.b"
GET "libhdr"

LET lifetheuniverseandeverything() = VALOF
{ LET expected = 42
  LET actual = answer()
  IF expected NE actual DO
  { writef("answer() NE 42*n")
    abort(2)
  }
}

LET start() = VALOF
{ lifetheuniverseandeverything()
  writef("All tests passed*n")
}