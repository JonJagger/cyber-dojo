
GET "hiker.b"
GET "libhdr"

LET life.the.universe.and.everything() BE
{ LET expected = 42
  LET actual = answer()
  IF expected NE actual DO
  { writes("answer() NE 42*n")
    abort(2)
  }
}

LET start() BE
{ life.the.universe.and.everything()
  writes("All tests passed*n")
}
