import sys
sys.path.append('../')
import unittest
from scrapy.http import HtmlResponse
from refly_scraper.items import ReferenceItem
from importer import DocImporter



    
class ImporterTest(unittest.TestCase):
    def test_json(self):
        importer = DocImporter('javascript')
        entries = importer.processJSON('tests/data/test_javascript.json')
        self.assertEqual(entries[0]['name'], 'P1')
        self.assertEqual(len(entries), 11)

    def test_PHP(self):
        importer = DocImporter('php')
        entries = importer.processJSON('tests/data/test_php.json')
        content = importer.ProcessContent(entries, importer.getContent('tests/data/test_php.html'))
        self.assertEqual(content, '<ul class="chunklist chunklist_part"><li><a href="/javascript/p1">P1</a></li><li><a href="/javascript/p2">P2</a></li><li><a href="/javascript/p3">P3</a></li><li><a href="/javascript/p4">P4</a></li><li><a href="/javascript/p5">P5</a></li><li><a href="/javascript/p6">P6</a></li><li><a href="/javascript/p7">P7</a></li><li><a href="/javascript/p8">P8</a></li><li><a href="/javascript/p9">P9</a></li><li><a href="/javascript/p10">P10</a></li><li><a href="/javascript/p11">P11</a></li><li><a href="/javascript/p12">P12</a></li></ul>')

    def test_JavaScript(self):
        importer = DocImporter('php')
        entries = importer.processJSON('tests/data/test_javascript.json')
        content = importer.ProcessContent(entries, importer.getContent('tests/data/test_javascript.html'))
        self.assertEqual(content, '<dl><dt><a href="/javascript/statements/block" title="A block statement"><code>Block</code></a></dt><dt><a href="/javascript/statements/break" title="The break statement"><code>break</code></a></dt><dt><a href="/javascript/statements/continue" title="The continue statement"><code>continue</code></a></dt><dt><a href="/javascript/statements/empty" title="An empty statement"><code>Empty</code></a></dt><dt><a href="/javascript/statements/if...else" title="The if statement"><code>if...else</code></a></dt><dt><a href="/javascript/statements/switch" title="The switch statement"><code>switch</code></a></dt><dt><a href="/javascript/statements/throw" title="The throw statement"><code>throw</code></a></dt><dt><a href="/javascript/statements/try...catch" title="The try...catch statement"><code>try...catch</code></a></dt><dt><a href="/javascript/operators/yield" title="The yield operator"><code>try...catch</code></a></dt><dt><a href="/javascript/operators/yield+" title="The yield* operator"><code>try...catch</code></a></dt><dt><a href="/javascript/functions/arguments" title="The arguments functions"><code>arguments</code></a></dt></dl>')

    def test_CSS(self):
        importer = DocImporter('php')
        entries = importer.processJSON('tests/data/test_css.json')
        content = importer.ProcessContent(entries, importer.getContent('tests/data/test_css.html'))
        self.assertEqual(content, '<a href="/css/height"><code>height</code></a>, <a href="/css/box-sizing"><code>box-sizing</code></a>, <a href="/css/min-width"><code>min-width</code></a>, <a href="/css/max-width"><code>max-width</code></a><a href="/css/_percentage_" title="Values of the &lt;percentage&gt; CSS data type are interpolated as real, floating-point numbers.">percentage</a>')

    def test_DOM(self):
        importer = DocImporter('dom')
        entries = importer.processJSON('tests/data/test_dom.json')
        content = importer.ProcessContent(entries, importer.getContent('tests/data/test_dom.html'))
        self.assertEqual(content, '<a href="/dom/eventtarget" title="EventTarget is an interface implemented by objects that can receive events and may have listeners for them."><code>EventTarget</code></a><a href="/dom/document/loadoverlay" title="The documentation about this has not yet been written; please consider contributing!"><code>document.load</code></a><a href="/dom/document/compatmode" title="Indicates whether the document is rendered in Quirks mode or Standards mode."><code>Document.compatMode</code></a><a href="document/domconfig" title="This should return the DOMConfiguration for the document."><code>Document.domConfig</code></a><a href="/dom/document/implementation" title="Returns a DOMImplementation object associated with the current document."><code>Document.implementation</code></a>')
        
