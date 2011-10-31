import prime_factors
import unittest

class TestPrimeFactors(unittest.TestCase):

    def test_str(self):
        '''simple example to start you off'''
        obj = prime_factors.Untitled()
        self.assertEqual(6 * 9, obj.answer())


if __name__ == '__main__':
    unittest.main()
