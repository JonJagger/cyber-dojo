
import std.stdio;

int answer()
{
    return 6 * 9;
}

unittest
{
    assert(answer() == 42, "answer() == 42");
}

void main()
{
    writeln("All tests passed");
}