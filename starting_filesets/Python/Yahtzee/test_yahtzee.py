import yahtzee
import unittest

class TestYahtzee(unittest.TestCase):

    def test_str(self):
        '''simple example to start you off'''
        obj = yahtzee.Untitled()
        self.assertEqual(6 * 9, obj.answer())


if __name__ == '__main__':
    unittest.main()
