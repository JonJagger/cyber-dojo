import recently_used_list
import unittest

class TestRecentlyUsedList(unittest.TestCase):

    def test_str(self):
        '''simple example to start you off'''
        obj = recently_used_list.Untitled()
        self.assertEqual(6 * 9, obj.answer())


if __name__ == '__main__':
    unittest.main()
