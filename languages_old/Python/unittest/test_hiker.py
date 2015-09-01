import hiker
import unittest

class TestHiker(unittest.TestCase):

    def test_life_the_universe_and_everything(self):
        '''simple example to start you off'''
        douglas = hiker.Hiker()
        self.assertEqual(42, douglas.answer())


if __name__ == '__main__':
    unittest.main()
