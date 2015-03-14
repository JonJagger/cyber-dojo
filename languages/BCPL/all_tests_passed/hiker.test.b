
GET "hiker.b"
GET "libhdr"

LET assert.int.equal(expected,actual,message) BE
{   IF expected NE actual DO
    {
        LET brk = 2
        writef("assert.int.equal FAILED: %s*N", message)
        writef("expected: %n*N", expected)
        writef("  actual: %n*N", actual);
        abort(brk)
    }
}

LET life.the.universe.and.everything() BE
{   assert.int.equal(42, answer(), "answer() = 42")
}

LET start() BE
{   life.the.universe.and.everything()
    writef("All tests passed")
}
