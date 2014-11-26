
GET "hiker.b"
GET "libhdr"

LET life.the.universe.and.everything() = VALOF
{ LET expected = 42
  LET actual = answer()
  IF expected NE actual DO
  { writef("answer() NE 42*n")
    abort(2)
  }
}

LET start() = VALOF
{ life.the.universe.and.everything()
  writef("All tests passed*n")
}
