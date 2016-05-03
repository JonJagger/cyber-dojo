package hiker

import ("testing")

func Test_life_the_universe_and_everything(t *testing.T) {
    if (answer() != 42) {
        t.Error("answer() != 42 as expected.")
    }
}
