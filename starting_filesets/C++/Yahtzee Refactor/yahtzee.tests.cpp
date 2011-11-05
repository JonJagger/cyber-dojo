#include "yahtzee.hpp"
#include <assert.h>

static void chance_scores_sum_of_all_dice() 
{
    int expected = 15;
    int actual = yahtzee::chance(2,3,4,5,1);
    assert(expected == actual);
    assert(yahtzee::chance(3,3,4,5,1) == 16);
}

static void yahtzee_scores_50() 
{
    int expected = 50;
    int actual = yahtzee::Yahtzee(4,4,4,4,4);
    assert(expected == actual);
    assert(yahtzee::Yahtzee(6,6,6,6,6) == 50);
    assert(yahtzee::Yahtzee(6,6,6,6,3) == 0);
}

static void test_1s() 
{
    assert((yahtzee::ones(1,2,3,4,5) == 1) == true);
    assert(yahtzee::ones(1,2,1,4,5) == 2);
    assert(yahtzee::ones(6,2,2,4,5) == 0);
    assert(yahtzee::ones(1,2,1,1,1) == 4);
}

static void test_2s() 
{
    assert(yahtzee::twos(1,2,3,2,6) == 4);
    assert(yahtzee::twos(2,2,2,2,2) == 10);
}

void test_threes() 
{
    assert(yahtzee::threes(1,2,3,2,3) == 6);
    assert(yahtzee::threes(2,3,3,3,3) == 12);
}

void fours_test() 
{
    assert(yahtzee(4,4,4,5,5).fours() == 12);
    assert(yahtzee(4,4,5,5,5).fours() == 8);
    assert(yahtzee(4,5,5,5,5).fours() == 4);
}

void fives() 
{
    assert((new yahtzee(4,4,4,5,5))->fives() == 10);
    assert((new yahtzee(4,4,5,5,5))->fives() == 15);
    assert((new yahtzee(4,5,5,5,5))->fives() == 20);
}

void sixes_test() 
{
    assert((new yahtzee(4,4,4,5,5))->sixes() == 0);
    assert((new yahtzee(4,4,6,5,5))->sixes() == 6);
    assert((new yahtzee(6,5,6,6,5))->sixes() == 18);
}

void one_pair() 
{
    assert(yahtzee::score_pair(3,4,3,5,6) == 6);
    assert(yahtzee::score_pair(5,3,3,3,5) == 10);
    assert(yahtzee::score_pair(5,3,6,6,5) == 12);
}

void two_Pair() 
{
    assert(yahtzee::two_pair(3,3,5,4,5) == 16);
    assert(yahtzee::two_pair(3,3,5,5,5) == 0);
}

void three_of_a_kind() 
{
    assert(yahtzee::three_of_a_kind(3,3,3,4,5) == 9);
    assert(yahtzee::three_of_a_kind(5,3,5,4,5) == 15);
    assert(yahtzee::three_of_a_kind(3,3,3,3,5) == 0);
}

void four_of_a_knd() 
{
    assert(yahtzee::four_of_a_kind(3,3,3,3,5) == 12);
    assert(yahtzee::four_of_a_kind(5,5,5,4,5) == 20);
    assert(yahtzee::three_of_a_kind(3,3,3,3,3) == 0);
}

void smallStraight() 
{
    assert(yahtzee::smallStraight(1,2,3,4,5) == 15);
    assert(yahtzee::smallStraight(2,3,4,5,1) == 15);
    assert(yahtzee::smallStraight(1,2,2,4,5) == 0);
}

void largeStraight() 
{
    assert(yahtzee::largeStraight(6,2,3,4,5) == 20);
    assert(yahtzee::largeStraight(2,3,4,5,6) == 20);
    assert(yahtzee::largeStraight(1,2,2,4,5) == 0);
}

void fullHouse() 
{
    assert(yahtzee::fullHouse(6,2,2,2,6) == 18);
    assert(yahtzee::fullHouse(2,3,4,5,6) == 0);
}

int main()
{
    chance_scores_sum_of_all_dice();
    yahtzee_scores_50();
    test_1s();
    test_2s(); 
    test_threes();
    fours_test();
    fives();
    sixes_test();
    one_pair();
    two_Pair();
    three_of_a_kind();
    four_of_a_knd();
    smallStraight();
    largeStraight(); 
    fullHouse();
}



