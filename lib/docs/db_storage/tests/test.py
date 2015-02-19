import sys
sys.path.append('../')
import unittest
from scrapy.http import HtmlResponse
from refly_scraper.items import ReferenceItem
from importer import DocImporter



    
class ImporterTest(unittest.TestCase):
    def test_json(self):
        importer = DocImporter('javascript')
        entries = importer.processJSON('data/test_index.json')


        self.assertEqual(entries[0]['name'], 'About')
        self.assertEqual(len(entries), 6)

    def test_getContent(self):
        importer = DocImporter('javascript')
        content = importer.getContent('data/test_data.html')
        self.assertIsNotNone(content)

        