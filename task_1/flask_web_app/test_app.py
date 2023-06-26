import unittest
import app

class FlaskTestCase(unittest.TestCase):

    def setUp(self):
        app.app.testing = True
        self.app = app.app.test_client()

    def test_hello_world(self):
        rv = self.app.get('/')
        self.assertEqual(rv.data, b'Hello, me!')

if __name__ == '__main__':
    unittest.main()
