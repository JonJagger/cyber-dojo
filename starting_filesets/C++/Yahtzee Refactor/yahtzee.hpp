#ifndef YAHTZEE_INCLUDED
#define YAHTZEE_INCLUDED

class yahtzee 
{
protected:
	int dice[5];
	
public:
	yahtzee(int d1, int d2, int d3, int d4, int _5);
	static int chance(int d1, int d2, int d3, int d4, int d5);
	static int Yahtzee(int d1, int d2, int d3, int d4, int d5);
	static int ones(int d1, int d2, int d3, int d4, int d5);
	static int twos(int d1, int d2, int d3, int d4, int d5);
	static int threes(int d1, int d2, int d3, int d4, int d5);
	int fours();
	int fives();
	int sixes();
	static int score_pair(int d1, int d2, int d3, int d4, int d5);
	static int two_pair(int d1, int d2, int d3, int d4, int d5);
	static int four_of_a_kind(int _1, int _2, int d3, int d4, int d5);
	static int three_of_a_kind(int d1, int d2, int d3, int d4, int d5);
	static int smallStraight(int d1, int d2, int d3, int d4, int d5);
	static int largeStraight(int d1, int d2, int d3, int d4, int d5);
	static int fullHouse(int d1, int d2, int d3, int d4, int d5);
};

#endif
