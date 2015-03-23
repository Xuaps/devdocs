#!/usr/bin/python
# -*- coding: utf-8 -*-
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
        self.assertEqual(content, u'<ul class="chunklist chunklist_part"><li><a href="/javascript/p1">P1</a></li><li><a href="/javascript/p2">P2</a></li><li><a href="/javascript/p3">P3</a></li><li><a href="/javascript/p4">P4</a></li><li><a href="/javascript/p5">P5</a></li><li><a href="/javascript/p6">P6</a></li><li><a href="/javascript/p7">P7</a></li><li><a href="/javascript/p8">P8</a></li><li><a href="/javascript/p9">P9</a></li><li><a href="/javascript/p10">P10</a></li><li><a href="/javascript/p11">P11</a></li><li><a href="/javascript/p12">P12</a></li></ul>')

    def test_JavaScript(self):
        importer = DocImporter('php')
        entries = importer.processJSON('tests/data/test_javascript.json')
        content = importer.ProcessContent(entries, importer.getContent('tests/data/test_javascript.html'))
        self.assertEqual(content, u'<dl><dt><a href="/javascript/statements/block" title="A block statement"><code>Block</code></a></dt><dt><a href="/javascript/statements/break" title="The break statement"><code>break</code></a></dt><dt><a href="/javascript/statements/continue" title="The continue statement"><code>continue</code></a></dt><dt><a href="/javascript/statements/empty" title="An empty statement"><code>Empty</code></a></dt><dt><a href="/javascript/statements/if...else" title="The if statement"><code>if...else</code></a></dt><dt><a href="/javascript/statements/switch" title="The switch statement"><code>switch</code></a></dt><dt><a href="/javascript/statements/throw" title="The throw statement"><code>throw</code></a></dt><dt><a href="/javascript/statements/try...catch" title="The try...catch statement"><code>try...catch</code></a></dt><dt><a href="/javascript/operators/yield" title="The yield operator"><code>try...catch</code></a></dt><dt><a href="/javascript/operators/yield+" title="The yield* operator"><code>try...catch</code></a></dt><dt><a href="/javascript/functions/arguments" title="The arguments functions"><code>arguments</code></a></dt></dl>')

    def test_CSS(self):
        importer = DocImporter('php')
        entries = importer.processJSON('tests/data/test_css.json')
        content = importer.ProcessContent(entries, importer.getContent('tests/data/test_css.html'))
        self.assertEqual(content, u'<a href="/css/height"><code>height</code></a>, <a href="/css/box-sizing"><code>box-sizing</code></a>, <a href="/css/min-width"><code>min-width</code></a>, <a href="/css/max-width"><code>max-width</code></a><a href="/css/_percentage_" title="Values of the &lt;percentage&gt; CSS data type are interpolated as real, floating-point numbers.">percentage</a>')

    def test_DOM(self):
        importer = DocImporter('dom')
        entries = importer.processJSON('tests/data/test_dom.json')
        content = importer.ProcessContent(entries, importer.getContent('tests/data/test_dom.html'))
        self.assertEqual(content, u'<a href="/dom/eventtarget" title="EventTarget is an interface implemented by objects that can receive events and may have listeners for them."><code>EventTarget</code></a><a href="/dom/document/loadoverlay" title="The documentation about this has not yet been written; please consider contributing!"><code>document.load</code></a><a href="/dom/document/compatmode" title="Indicates whether the document is rendered in Quirks mode or Standards mode."><code>Document.compatMode</code></a><a href="document/domconfig" title="This should return the DOMConfiguration for the document."><code>Document.domConfig</code></a><a href="/dom/document/implementation" title="Returns a DOMImplementation object associated with the current document."><code>Document.implementation</code></a>')
        
    def test_XPATH(self):
        importer = DocImporter('xpath')
        entries = importer.processJSON('tests/data/test_xpath.json')
        content = importer.ProcessContent(entries, importer.getContent('tests/data/test_xpath.html'))
        self.assertEqual(content, u'<ul><li><a href="/xpath/functions/boolean" title="en/XPath/Functions/boolean">boolean()</a></li> <li><a href="/xpath/functions/ceiling" title="en/XPath/Functions/ceiling">ceiling()</a></li> <li><a href="/xpath/functions/choose" title="en/XPath/Functions/choose">choose()</a></li> <li><a href="/xpath/functions/concat" title="en/XPath/Functions/concat">concat()</a></li> <li><a href="/xpath/functions/contains" title="en/XPath/Functions/contains">contains()</a></li> <li><a href="/xpath/functions/count" title="en/XPath/Functions/count">count()</a></li></ul>')

    def test_SVG(self):
        importer = DocImporter('svg')
        entries = importer.processJSON('tests/data/test_svg.json')
        content = importer.ProcessContent(entries, importer.getContent('tests/data/test_svg.html'))
        self.assertEqual(content, u'<h3 id="Global_attributes">Global attributes</h3><ul><li><a href="/svg/attribute" title="en/SVG/Attribute#ConditionalProccessing">Conditional processing attributes</a> \xbb</li><li><a href="/svg/attribute" title="en/SVG/Attribute#Core">Core attributes</a></li><li><a href="/svg/attribute" title="en/SVG/Attribute#GraphicalEvent">Graphical event attributes</a></li><li><a href="/svg/attribute" title="en/SVG/Attribute#Presentation">Presentation attributes</a></li><li><a href="/svg/attribute" title="en/SVG/Attribute#XLink">XLink attributes</a> </li><li><code><a href="/svg/attribute/class">class</a></code></li><li><code><a href="/svg/attribute/style">style</a></code></li><li><code><a href="/svg/attribute/externalresourcesrequired">externalResourcesRequired</a></code></li><li><code><a href="/svg/attribute/dx">dx</a></code></li><li><code><a href="/svg/attribute/dy">dy</a></code></li></ul>')

    def test_HTML(self):
        importer = DocImporter('html')
        entries = importer.processJSON('tests/data/test_html.json')
        content = importer.ProcessContent(entries, importer.getContent('tests/data/test_html.html'))
        print 'HTML\n' + content
        self.assertEqual(content, u'<ul><li><a href="/html/global_attributes" style="line-height: 21px;" title="HTML/Global attributes">global attributes</a></li><li><a href="/html/element/base" title="The HTML Base Element (&lt;base&gt;) specifies the base URL to use for all relative URLs contained within a document. There can be only one &lt;base&gt; element in a document."><code>&lt;base&gt;</code></a></li><li><a href="/html/element/link" title="The HTML Link Element (&lt;link&gt;) specifies relationships between the current document and an external resource. Possible uses for this element include defining a relational framework for navigation. This Element is most used to link to style sheets."><code>&lt;link&gt;</code></a></li><li><a href="/html/element/meter" title="The HTML &lt;meter&gt; Element represents either a scalar value within a known range or a fractional value."><code>&lt;meter&gt;</code></a></li><li><a href="/html/element/basefont" title="The HTML basefont element (&lt;basefont&gt;) establishes a default font size for a document. Font size then can be varied relative to the base font size using the &lt;font&gt; element."><code>&lt;basefont&gt;</code></a></li></ul>')
        
