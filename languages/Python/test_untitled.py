import unittest
import untitled


class TestUntitled(unittest.TestCase):

    def test_str(self):
        """Simple example to start you off."""
        obj = untitled.Untitled()
        self.assertEqual(6 * 9, obj.answer())
