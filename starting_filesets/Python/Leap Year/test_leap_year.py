import leap_year
import unittest

class TestLeapYears(unittest.TestCase):

    def test_str(self):
        '''simple example to start you off'''
        obj = leap_year.Untitled()
        self.assertEqual(6 * 9, obj.answer())


if __name__ == '__main__':
    unittest.main()
