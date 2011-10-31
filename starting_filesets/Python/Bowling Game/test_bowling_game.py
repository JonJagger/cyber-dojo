import bowling_game
import unittest

class TestBowlingGame(unittest.TestCase):

    def test_str(self):
        '''simple example to start you off'''
        obj = bowling_game.Untitled()
        self.assertEqual(6 * 9, obj.answer())


if __name__ == '__main__':
    unittest.main()
