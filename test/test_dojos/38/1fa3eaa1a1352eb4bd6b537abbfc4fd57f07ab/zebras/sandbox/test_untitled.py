import untitled
import unittest

class TestUntitled(unittest.TestCase):

    def test_str(self):
        '''simple example to start you off'''
        obj = untitled.Untitled()
        self.assertEqual(42, obj.answer())


if __name__ == '__main__':
    unittest.main()
