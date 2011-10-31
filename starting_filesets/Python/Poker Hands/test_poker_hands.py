import poker_hands
import unittest

class TestPokerHands(unittest.TestCase):

    def test_str(self):
        '''simple example to start you off'''
        obj = poker_hands.Untitled()
        self.assertEqual(6 * 9, obj.answer())


if __name__ == '__main__':
    unittest.main()
