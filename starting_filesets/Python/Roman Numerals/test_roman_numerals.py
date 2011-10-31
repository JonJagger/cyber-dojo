import roman_numerals
import unittest

class TestRomanNumerals(unittest.TestCase):

    def test_str(self):
        '''simple example to start you off'''
        obj = roman_numerals.Untitled()
        self.assertEqual(6 * 9, obj.answer())


if __name__ == '__main__':
    unittest.main()
