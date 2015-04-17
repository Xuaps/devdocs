#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys
sys.path.append('../')
import unittest
import pprint
import re
from scrapy.http import HtmlResponse
from refly_scraper.items import ReferenceItem
from importer import DocImporter


class ImporterTest(unittest.TestCase):

    link_re = re.compile('href="(?!http:\/\/)([\(\)\*:$_\#\/%\-\w\.]*)"', re.IGNORECASE)

    def test_json(self):
        importer = DocImporter('javascript')
        entries = importer.processJSON('tests/data/test_javascript.json')
        self.assertEqual(entries[0]['name'], 'P1')
        self.assertEqual(len(entries), 11)

# LINK TESTS

    def test_json(self):
        importer = DocImporter('javascript')
        entries = importer.processJSON('tests/data/test_javascript.json')
        self.assertEqual(entries[0]['name'], 'P1')
        self.assertEqual(len(entries), 11)

    def test_BackboneJS(self):
        importer = DocImporter('backbone')
        entries = importer.processJSON('tests/data/test_backbone.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_backbone.html'))
        errorcounter = self.Uris_x_parent_uris("backbone","../../../public/docs/javascript/index.json")
        anchornotfound = self.CheckAnchors('backbone')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/backbonejs/backbone.on">on</a></li><li><a href="/backbonejs/model.validate">validation</a></li><li><a href="/backbonejs/backbone.listento">listenTo</a></li><li><a href="/backbonejs/model.destroy">destroyed</a></li></ul>')

    def test_Bower(self):
        importer = DocImporter('bower')
        entries = importer.processJSON('tests/data/test_bower.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_bower.html'))
        errorcounter = self.Uris_x_parent_uris("bower","../../../public/docs/bower/index.json")
        anchornotfound = self.CheckAnchors('bower')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/bower/analytics">analytics</a></li> <li><a href="/bower/cwd">cwd</a></li><li><a href="/bower/https-proxy">https-proxy</a></li><li><a href="/bower/color">color</a></li><li><a href="/bower/register">Register</a></li><li><a href="/bower/analytics">analytics</a></li><li><a href="/bower/init"><code>bower init</code></a></li></ul>')

    def test_Chai(self):
        importer = DocImporter('chai')
        entries = importer.processJSON('tests/data/test_chai.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_chai.html'))
        errorcounter = self.Uris_x_parent_uris("chai","../../../public/docs/chai/index.json")
        anchornotfound = self.CheckAnchors('chai')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="guide/plugins/">core concepts</a></li><li><a href="/chai/addproperty" class="clean-button">View addProperty API</a></li><li><a href="/chai/addmethod" class="clean-button">View addMethod API</a></li><li><a href="/chai/building_a_helper">Building a Helper</a></li></ul>')

    def test_Cordova(self):
        importer = DocImporter('cordova')
        entries = importer.processJSON('tests/data/test_cordova.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_cordova.html'))
        errorcounter = self.Uris_x_parent_uris("cordova","../../../public/docs/cordova/index.json")
        anchornotfound = self.CheckAnchors('cordova')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/apache-cordova/overview#overview">Overview</a></li><li><a href="/apache-cordova/the_command-line_interface#the%20command-line%20interface">The Command-Line Interface</a></li><li><a href="/apache-cordova/amazon_fire_os_configuration#amazon%20fire%20os%20configuration">Amazon Fire OS Configuration</a></li><li><a href="/apache-cordova/amazon_fire_os_webviews#amazon%20fire%20os%20webviews">Amazon Fire OS WebViews</a></li><li><a href="/apache-cordova/amazon_fire_os_plugins#amazon%20fire%20os%20plugins">Amazon Fire OS Plugins</a></li></ul>')

    def test_CSS(self):
        importer = DocImporter('php')
        entries = importer.processJSON('tests/data/test_css.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_css.html'))
        errorcounter = self.Uris_x_parent_uris("css","../../../public/docs/css/index.json")
        anchornotfound = self.CheckAnchors('css')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<a href="/css/height"><code>height</code></a>, <a href="/css/box-sizing"><code>box-sizing</code></a>, <a href="/css/min-width"><code>min-width</code></a>, <a href="/css/max-width"><code>max-width</code></a><a href="/css/_percentage_#interpolation" title="Values of the &lt;percentage&gt; CSS data type are interpolated as real, floating-point numbers.">percentage</a>')

    def test_D3(self):
        importer = DocImporter('d3')
        entries = importer.processJSON('tests/data/test_d3.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_d3.html'))
        errorcounter = self.Uris_x_parent_uris("css","../../../public/docs/d3/index.json")
        anchornotfound = self.CheckAnchors('d3')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<div><a href="/d3/selection.attr">attributes</a>, <a href="/d3/selection.style">styles</a>, <a href="/d3/selection.property">properties</a>, <a href="/d3/selection.html">HTML</a> and <a href="/d3/selection.text">text</a></div>')

    def test_DOM(self):
        importer = DocImporter('dom')
        entries = importer.processJSON('tests/data/test_dom.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_dom.html'))
        errorcounter = self.Uris_x_parent_uris("dom","../../../public/docs/dom/index.json")
        anchornotfound = self.CheckAnchors('dom')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<a href="/dom/eventtarget" title="EventTarget is an interface implemented by objects that can receive events and may have listeners for them."><code>EventTarget</code></a><a href="/dom/document/loadoverlay" title="The documentation about this has not yet been written; please consider contributing!"><code>document.load</code></a><a href="/dom/document/compatmode" title="Indicates whether the document is rendered in Quirks mode or Standards mode."><code>Document.compatMode</code></a><a href="document/domconfig" title="This should return the DOMConfiguration for the document."><code>Document.domConfig</code></a><a href="/dom/document/implementation" title="Returns a DOMImplementation object associated with the current document."><code>Document.implementation</code></a>')

    def test_DOM_EVENTS(self):
        importer = DocImporter('dom_events')
        entries = importer.processJSON('tests/data/test_dom_events.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_dom_events.html'))
        errorcounter = self.Uris_x_parent_uris("dom_events","../../../public/docs/dom_events/index.json")
        anchornotfound = self.CheckAnchors('dom_events')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/dom_events/loadstart"><code>loadstart</code></a></li><li><a href="/dom_events/progress"><code>progress</code></a></li><li><a href="/dom_events/error_(progressevent)"><code>error</code></a></li><li><a href="/dom_events/abort_(progressevent)"><code>abort</code></a></li><li><a href="/dom_events/load"><code>load</code></a></li><li><a href="/dom_events/loadend"><code>loadend</code></a></li></ul>')

    def test_Ember(self):
        importer = DocImporter('ember')
        entries = importer.processJSON('tests/data/test_ember.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_ember.html'))
        errorcounter = self.Uris_x_parent_uris("ember","../../../public/docs/ember/index.json")
        anchornotfound = self.CheckAnchors('ember')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/ember/classes/view">Ember.View</a></li><li><a href="/ember/modules/ember-views">ember-views</a></li></ul>')

    def test_Express(self):
        importer = DocImporter('express')
        entries = importer.processJSON('tests/data/test_express.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_express.html'))
        errorcounter = self.Uris_x_parent_uris("express","../../../public/docs/express/index.json")
        anchornotfound = self.CheckAnchors('express')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/express/app.render">app.render</a></li><li><a href="/express/app.route">app.route</a></li><li><a href="/express/app.method">app.METHOD</a></li><li><a href="/express/req.baseurl">baseUrl</a></li></ul>')

    def test_Git(self):
        importer = DocImporter('git')
        entries = importer.processJSON('tests/data/test_git.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_git.html'))
        errorcounter = self.Uris_x_parent_uris("git","../../../public/docs/git/index.json")
        anchornotfound = self.CheckAnchors('git')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/git/gitattributes">gitattributes[5]</a></li><li><a href="/git/git-upload-archive">git-upload-archive[1]</a></li><li><a href="/git/git-http-backend">ATTRIBUTES</a></li><li><a href="/git/git-log">git-log[1]</a></li><li><a href="/git/git-blame">git-blame[1]</a></li></ul>')

    def test_Go(self):
        importer = DocImporter('go')
        entries = importer.processJSON('tests/data/test_go.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_go.html'))
        errorcounter = self.Uris_x_parent_uris("go","../../../public/docs/go/index.json")
        anchornotfound = self.CheckAnchors('go')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/go/archive/zip/writer_zip">zip</a></li><li><a href="/go/bytes/map_bytes">bytes</a></li><li><a href="/go/compress/lzw">lzw</a></li><li><a href="/go/go_programming_language/sub-repositories">Sub-repositories</a></li></ul>')

    def test_Grunt(self):
        importer = DocImporter('grunt')
        entries = importer.processJSON('tests/data/test_grunt.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_grunt.html'))
        errorcounter = self.Uris_x_parent_uris("grunt","../../../public/docs/grunt/index.json")
        anchornotfound = self.CheckAnchors('grunt')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/grunt/using-the-cli">Using the CLI</a></li><li><a href="/grunt/api/grunt">grunt.fatal</a></li></ul>')

    def test_Haskell(self):
        importer = DocImporter('haskell')
        entries = importer.processJSON('tests/data/test_haskell.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_haskell.html'))
        errorcounter = self.Uris_x_parent_uris("haskell","../../../public/docs/haskell/index.json")
        anchornotfound = self.CheckAnchors('haskell')
        anchornotfound = self.CheckAnchors('haskell')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/haskell/data-intmap-lazy#v:mapwithkey">mapWithKey</a></li><li><a href="/haskell/data-intmap-strict/intmap_a#t:intmap">IntMap</a></li><li><a href="/haskell/data-intmap-strict/intmap_a#t:key">Key</a></li><li><a href="/haskell/data-intmap-strict/intmap_a#v:foldrwithkey">foldrWithKey</a></li></ul>')

    def test_HTML(self):
        importer = DocImporter('html')
        entries = importer.processJSON('tests/data/test_html.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_html.html'))        
        errorcounter = self.Uris_x_parent_uris("html","../../../public/docs/html/index.json")
        anchornotfound = self.CheckAnchors('html')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/html/global_attributes" style="line-height: 21px;" title="HTML/Global attributes">global attributes</a></li><li><a href="/html/element/base" title="The HTML Base Element (&lt;base&gt;) specifies the base URL to use for all relative URLs contained within a document. There can be only one &lt;base&gt; element in a document."><code>&lt;base&gt;</code></a></li><li><a href="/html/element/link" title="The HTML Link Element (&lt;link&gt;) specifies relationships between the current document and an external resource. Possible uses for this element include defining a relational framework for navigation. This Element is most used to link to style sheets."><code>&lt;link&gt;</code></a></li><li><a href="/html/element/meter" title="The HTML &lt;meter&gt; Element represents either a scalar value within a known range or a fractional value."><code>&lt;meter&gt;</code></a></li><li><a href="/html/element/meter" title="The HTML &lt;meter&gt; Element represents either a scalar value within a known range or a fractional value."><code>&lt;meter&gt;</code></a></li><li><a href="/html/element/basefont" title="The HTML basefont element (&lt;basefont&gt;) establishes a default font size for a document. Font size then can be varied relative to the base font size using the &lt;font&gt; element."><code>&lt;basefont&gt;</code></a></li><li><a href="/html/element/option" title="In a Web form, the HTML &lt;option&gt; element is used to create a control representing an item within a &lt;select&gt;, an &lt;optgroup&gt; or a &lt;datalist&gt; HTML5 element."><code>&lt;option&gt;</code></a></li></ul>')

    def test_JavaScript(self):
        importer = DocImporter('javascript')
        entries = importer.processJSON('tests/data/test_javascript.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_javascript.html'))       
        errorcounter = self.Uris_x_parent_uris("javascript","../../../public/docs/javascript/index.json")
        anchornotfound = self.CheckAnchors('javascript')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<dl><dt><a href="/javascript/statements/block" title="A block statement"><code>Block</code></a></dt><dt><a href="/javascript/statements/break" title="The break statement"><code>break</code></a></dt><dt><a href="/javascript/statements/continue" title="The continue statement"><code>continue</code></a></dt><dt><a href="/javascript/statements/empty" title="An empty statement"><code>Empty</code></a></dt><dt><a href="/javascript/statements/if...else" title="The if statement"><code>if...else</code></a></dt><dt><a href="/javascript/statements/switch" title="The switch statement"><code>switch</code></a></dt><dt><a href="/javascript/statements/throw" title="The throw statement"><code>throw</code></a></dt><dt><a href="/javascript/statements/try...catch" title="The try...catch statement"><code>try...catch</code></a></dt><dt><a href="/javascript/operators/yield" title="The yield operator"><code>try...catch</code></a></dt><dt><a href="/javascript/operators/yield+" title="The yield* operator"><code>try...catch</code></a></dt><dt><a href="/javascript/functions/arguments" title="The arguments functions"><code>arguments</code></a></dt></dl>')

    def test_JQuery(self):
        importer = DocImporter('jquery')
        entries = importer.processJSON('tests/data/test_jquery.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_jquery.html'))
        errorcounter = self.Uris_x_parent_uris("jquery","../../../public/docs/jquery/index.json")
        anchornotfound = self.CheckAnchors('jquery')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/jquery/jquery.parsehtml">$.parseHTML()</a></li><li><a href="/jquery/jquery.each"><em>each</em> function</a></li><li><a href="/jquery/jquery.merge"><em>Merge</em> function</a></li><li><a href="/jquery/jquery.parsehtml">ParseHtml function</a></li><li><a href="/jquery/jquery.proxy">Proxy function</a></li></ul>')

    def test_JQueryMobile(self):
        importer = DocImporter('jquerymobile')
        entries = importer.processJSON('tests/data/test_jquerymobile.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_jquerymobile.html'))
        errorcounter = self.Uris_x_parent_uris("jquerymobile","../../../public/docs/jquerymobile/index.json")
        anchornotfound = self.CheckAnchors('jquerymobile')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/jquerymobile/configuring_defaults"><code>ns</code> global option</a></li><li><a href="/jquerymobile/collapsible">Collapsible</a></li><li><a href="/jquerymobile/collapsibleset">Collapsible set</a></li><li><a href="/jquerymobile/flipswitch">Flip toggle switch</a></li></ul>')

    def test_JQueryUI(self):
        importer = DocImporter('jqueryui')
        entries = importer.processJSON('tests/data/test_jqueryui.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_jqueryui.html'))
        errorcounter = self.Uris_x_parent_uris("jqueryui","../../../public/docs/jqueryui/index.json")
        anchornotfound = self.CheckAnchors('jqueryui')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/jqueryui/jquery.widget">Widget Factory</a></li><li><a href="/jqueryui/theming/css-framework">jQuery UI CSS framework</a></li><li><a href="/jqueryui/easings">easing</a></li><li><a href="/jqueryui/theming/icons">an icon provided by the jQuery UI CSS Framework</a></li></ul>')

    def test_Less(self):
        importer = DocImporter('less')
        entries = importer.processJSON('tests/data/test_less.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_less.html'))
        errorcounter = self.Uris_x_parent_uris("less","../../../public/docs/less/index.json")
        anchornotfound = self.CheckAnchors('less')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/less/data-uri">data-uri</a></li><li><a href="/less/default">default</a></li><li><a href="/less/desaturate">desaturate</a></li><li><a href="/less/difference">difference</a></li></ul>')

    def test_Lodash(self):
        importer = DocImporter('lodash')
        entries = importer.processJSON('tests/data/test_lodash.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_lodash.html'))
        errorcounter = self.Uris_x_parent_uris("lodash","../../../public/docs/lodash/index.json")
        anchornotfound = self.CheckAnchors('lodash')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/lodash/_.property"><code>_.<span class="me1">property</span></code></a></li><li><a href="/lodash/_.matches"><code>_.<span class="me1">matches</span></code></a></li><li><a href="/lodash/_.matchesproperty"><code>_.<span class="me1">matchesProperty</span></code></a></li><li><a href="/lodash/_.detect"><code>_.<span class="me1">find</span></code></a></li></ul>')

    def test_MarkDown(self):
        importer = DocImporter('markdown')
        entries = importer.processJSON('tests/data/test_markdown.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_markdown.html'))
        errorcounter = self.Uris_x_parent_uris("markdown","../../../public/docs/markdown/index.json")
        anchornotfound = self.CheckAnchors('markdown')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul> <li><a href="/markdown/overview">Overview</a><li><a href="/markdown/philosophy">Philosophy</a></li> <li><a href="/markdown/inline_html">Inline HTML</a></li> <li><a href="/markdown/automatic_escaping_for_special_characters">Automatic Escaping for Special Characters</a></li><li><a href="/markdown/paragraphs_and_line_breaks">Paragraphs and Line Breaks</a></li> <li><a href="/markdown/headers">Headers</a></li> <li><a href="/markdown/blockquotes">Blockquotes</a></li> <li><a href="/markdown/lists">Lists</a></li> <li><a href="/markdown/code_blocks">Code Blocks</a></li> <li><a href="/markdown/horizontal_rules">Horizontal Rules</a></li></ul>')

    def test_Mongoose(self):
        importer = DocImporter('mongoosejs')
        entries = importer.processJSON('tests/data/test_mongoosejs.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_mongoosejs.html'))
        errorcounter = self.Uris_x_parent_uris("mongoosejs","../../../public/docs/mongoosejs/index.json")
        anchornotfound = self.CheckAnchors('mongoosejs')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/mongoosejs/schematype">SchemaType</a></li><li><a href="/mongoosejs/schema.add">Schema#add</a></li><li><a href="/mongoosejs/middleware">middleware</a></li><li><a href="/mongoosejs/schematype.index">at</a></li></ul>')

    def test_Nginx(self):
        importer = DocImporter('nginx')
        entries = importer.processJSON('tests/data/test_nginx.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_nginx.html'))
        errorcounter = self.Uris_x_parent_uris("nginx","../../../public/docs/nginx/index.json")
        anchornotfound = self.CheckAnchors('nginx')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/nginx/server">server</a></li><li><a href="/nginx/debug_connection">selected client addresses</a></li><li><a href="/nginx/error_log">error_log</a></li><li><a href="/nginx/auth_request_set">auth_request_set</a><br><a href="/nginx/autoindex">autoindex</a></li><li><a href="/nginx/autoindex_format">autoindex_format</a></li></ul>')

    def test_Node(self):
        importer = DocImporter('node')
        entries = importer.processJSON('tests/data/test_node.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_node.html'))
        errorcounter = self.Uris_x_parent_uris("node","../../../public/docs/node/index.json")
        anchornotfound = self.CheckAnchors('node')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/nodejs/stream.writable">Writable Stream</a></li><li><a href="/nodejs/http.incomingmessage">http.IncomingMessage</a></li><li><a href="/nodejs/eventemitter">EventEmitter</a></li><li><a href="/nodejs/buffer.inspect_max_bytes#buffer_buffer">Buffer</a></li><li><a href="/nodejs/agent.destroy"><code>destroy()</code></a></li><li><a href="/nodejs/new_agent">constructor options</a></li></ul>')

    def test_PostgreSQL(self):
        importer = DocImporter('postgresql')
        entries = importer.processJSON('tests/data/test_postgresql.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_postgresql.html'))
        errorcounter = self.Uris_x_parent_uris("postgresql","../../../public/docs/postgresql/index.json")
        anchornotfound = self.CheckAnchors('postgresql')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/postgresql/function/and">Logical Operators</a></li><li><a href="functions-comparison">Comparison Operators</a></li><li><a href="/postgresql/math">Mathematical Functions and Operators</a></li><li><a href="/postgresql/string_functions_and_operators">String Functions and Operators</a></li><li><a href="/postgresql/binary_string_functions_and_operators">Binary String Functions and Operators</a></li><li><a href="/postgresql/bit_string_functions_and_operators">Bit String Functions and Operators</a></li><li><a href="/postgresql/pattern_matching">Pattern Matching</a></li><li><a href="/postgresql/function/like"><code class="FUNCTION">LIKE</code></a></li><li><a href="/postgresql/function/similar_to_regular_expressions"><code class="FUNCTION">SIMILAR TO</code> Regular Expressions</a></li></ul>')

    def test_PHP(self):
        importer = DocImporter('php')
        entries = importer.processJSON('tests/data/test_php.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_php.html'))
        errorcounter = self.Uris_x_parent_uris("php","../../../public/docs/php/index.json")
        anchornotfound = self.CheckAnchors('php')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul class="chunklist chunklist_part"><li><a href="/javascript/p1">P1</a></li><li><a href="/javascript/p2">P2</a></li><li><a href="/javascript/p3">P3</a></li><li><a href="/javascript/p4">P4</a></li><li><a href="/javascript/p5">P5</a></li><li><a href="/javascript/p6">P6</a></li><li><a href="/javascript/p7">P7</a></li><li><a href="/javascript/p8">P8</a></li><li><a href="/javascript/p9">P9</a></li><li><a href="/javascript/p10">P10</a></li><li><a href="/javascript/p11">P11</a></li><li><a href="/javascript/p12">P12</a></li></ul>')

    def test_Python2(self):
        importer = DocImporter('python2')
        entries = importer.processJSON('tests/data/test_python2.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_python2.html'))
        errorcounter = self.Uris_x_parent_uris("python2","../../../public/docs/python2/index.json")
        anchornotfound = self.CheckAnchors('python2')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a class="reference internal" href="/python2/array.array.extend" title="array.array.extend"><code>extend()</code></a></li><li><a class="reference internal" href="/python2/array.array.tofile" title="array.array.tofile"><code>tofile()</code></a></li><li><a class="reference internal" href="/python2/array.array.fromlist" title="array.array.fromlist"><code>fromlist()</code></a></li><li><a class="reference internal" href="/python2/array.array.fromunicode" title="array.array.fromunicode"><code>fromunicode()</code></a</li><li><a class="reference internal" href="exceptions#exceptions.TypeError" title="exceptions.TypeError"><code>TypeError</code></a></li></ul>')

    def test_Python3(self):
        importer = DocImporter('python')
        entries = importer.processJSON('tests/data/test_python3.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_python3.html'))
        errorcounter = self.Uris_x_parent_uris("python","../../../public/docs/python/index.json")
        anchornotfound = self.CheckAnchors('python')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a class="reference internal" href="/python3/base_event_loop#asyncio-event-loop"><em>event loop</em></a></li><li><a class="reference internal" href="/python3/transports_and_protocols_low-level_api#asyncio-transport"><em>transport</em></a></li><li><a class="reference internal" href="/python3/asyncio.future#asyncio.future" title="asyncio.Future"><tt class="xref py py-class docutils literal"><span class="pre">Future</span></tt></a></li><li><a class="reference internal" href="/python3/base_event_loop">18.5.1. Base Event Loop</a></li></ul>')

    def test_React(self):
        importer = DocImporter('react')
        entries = importer.processJSON('tests/data/test_react.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_react.html'))
        errorcounter = self.Uris_x_parent_uris("react","../../../public/docs/react/index.json")
        anchornotfound = self.CheckAnchors('react')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/react/animation"><code>TransitionGroup</code> and <code>CSSTransitionGroup</code></a></li><li><a href="/react/two-way-binding-helpers"><code>LinkedStateMixin</code></a></li><li><a href="/react/class-name-manipulation"><code>classSet</code></a></li><li><a href="/react/react_elements_">ReactElement / ReactElement Factory</a></li><li><a href="/react/react_components_">ReactComponent / ReactComponent Class</a></li><li><a href="/react/react_nodes_">ReactNode</a></li></ul>')

    def test_RequireJS(self):
        importer = DocImporter('requirejs')
        entries = importer.processJSON('tests/data/test_requirejs.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_requirejs.html'))
        errorcounter = self.Uris_x_parent_uris("requirejs","../../../public/docs/requirejs/index.json")
        anchornotfound = self.CheckAnchors('requirejs')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/requirejs/_introduction__">Introduction</a></li><li><a href="/requirejs/define_a_module_with_a_name">Module Name</a></li><li><a href="/requirejs/_example_loading_jquery_from_a_cdn__">Example loading jquery from a CDN</a></li><li><a href="/requirejs/_mapping_modules_to_use_noconflict__">Mapping Modules to use noConflict</a></li><li><a href="/requirejs/_mapping_modules_to_use_noconflict__">later</a></li><li><a href="api#config-map">map config</a></li></ul>')

    def test_Sass(self):
        importer = DocImporter('sass')
        entries = importer.processJSON('tests/data/test_sass.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_sass.html'))
        errorcounter = self.Uris_x_parent_uris("sass","../../../public/docs/sass/index.json")
        anchornotfound = self.CheckAnchors('sass')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/sass/hsla" title="Sass::Script::Functions#hsla (method)">hsla($hue, $saturation, $lightness, $alpha)</a></li><li><a href="/sass/adjust_hue" title="Sass::Script::Functions#adjust_hue (method)">adjust-hue($color, $degrees)</a></li><li><a href="/sass/red" title="Sass::Script::Functions#red (method)">red($color)</a></li><li><a href="/sass/-load_paths" title="&lt;code&gt;:load_paths&lt;/code&gt; array"><code>:load_paths</code> array</a></li></ul>')

    def test_Sinon(self):
        importer = DocImporter('sinon')
        entries = importer.processJSON('tests/data/test_sinon.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_sinon.html'))
        errorcounter = self.Uris_x_parent_uris("sinon","../../../public/docs/sinon/index.json")
        anchornotfound = self.CheckAnchors('sinon')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/sinonjs/assertions">Assertions</a></li><li><a href="/sinonjs/clock.restore">clock.restore()</a></li><li><a href="/sinonjs/clock.tick">clock.tick()</a></li><li><a href="/sinonjs/expectation.atleast">expectation.atLeast()</a></li></ul>')

    def test_SVG(self):
        importer = DocImporter('svg')
        entries = importer.processJSON('tests/data/test_svg.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_svg.html'))
        errorcounter = self.Uris_x_parent_uris("svg","../../../public/docs/svg/index.json")
        anchornotfound = self.CheckAnchors('svg')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<h3 id="Global_attributes">Global attributes</h3><ul><li><a href="/svg/attribute#conditionalproccessing" title="en/SVG/Attribute#ConditionalProccessing">Conditional processing attributes</a> \xbb</li><li><a href="/svg/attribute#core" title="en/SVG/Attribute#Core">Core attributes</a></li><li><a href="/svg/attribute#graphicalevent" title="en/SVG/Attribute#GraphicalEvent">Graphical event attributes</a></li><li><a href="/svg/attribute#presentation" title="en/SVG/Attribute#Presentation">Presentation attributes</a></li><li><a href="/svg/attribute#xlink" title="en/SVG/Attribute#XLink">XLink attributes</a> </li><li><code><a href="/svg/attribute/class">class</a></code></li><li><code><a href="/svg/attribute/style">style</a></code></li><li><code><a href="/svg/attribute/externalresourcesrequired">externalResourcesRequired</a></code></li><li><code><a href="/svg/attribute/dx">dx</a></code></li><li><code><a href="/svg/attribute/dy">dy</a></code></li></ul>')

    def test_Underscore(self):
        importer = DocImporter('underscore')
        entries = importer.processJSON('tests/data/test_underscore.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_underscore.html'))
        errorcounter = self.Uris_x_parent_uris("underscore","../../../public/docs/underscore/index.json")
        anchornotfound = self.CheckAnchors('underscore')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/underscorejs/isempty">isEmpty</a></li><li><a href="/underscorejs/groupby">groupBy</a></li><li><a href="/underscorejs/zip">zip</a></li><li><a href="/underscorejs/findindex">_.findIndex</a></li></ul>')

    def test_XPATH(self):
        importer = DocImporter('xpath')
        entries = importer.processJSON('tests/data/test_xpath.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_xpath.html'))
        errorcounter = self.Uris_x_parent_uris("xpath","../../../public/docs/xpath/index.json")
        anchornotfound = self.CheckAnchors('xpath')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/xpath/functions/boolean" title="en/XPath/Functions/boolean">boolean()</a></li> <li><a href="/xpath/functions/ceiling" title="en/XPath/Functions/ceiling">ceiling()</a></li> <li><a href="/xpath/functions/choose" title="en/XPath/Functions/choose">choose()</a></li> <li><a href="/xpath/functions/concat" title="en/XPath/Functions/concat">concat()</a></li> <li><a href="/xpath/functions/contains" title="en/XPath/Functions/contains">contains()</a></li> <li><a href="/xpath/functions/count" title="en/XPath/Functions/count">count()</a></li></ul>')

    def test_Yii(self):
        importer = DocImporter('yii')
        entries = importer.processJSON('tests/data/test_yii.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_yii.html'))
        errorcounter = self.Uris_x_parent_uris("yii","../../../public/docs/yii/index.json")
        anchornotfound = self.CheckAnchors('yii')
        self.assertEqual(anchornotfound, 0)
        self.assertEqual(errorcounter, 0)
        self.assertEqual(content, u'<ul><li><a href="/yii/db.connection_open">open()</a></li><li><a href="/yii/yii-db-datareader">yii\db\DataReader</a></li><li><a href="/yii/db.connection_$slaves">$slaves</a></li><li><a href="/yii/db.connection_$username">$username</a></li</ul>')


    #UTILITIES
    def CreateUriList(self, entries):
        urilist = {}
        for entry in entries:
            urilist[entry['parsed_uri']] = entry['parent_uri']
        return urilist

    def Uris_x_parent_uris(self, docset, json_file):
        importer = DocImporter(docset)
        entries = importer.processJSON(json_file)
        urilist = self.CreateUriList(entries)
        errorcounter = 0
        for entry in entries:
            if entry['parent_uri']!= 'null' and entry['parent_uri'] not in urilist:
                errorcounter += 1
                print 'parent_uri: ' + entry['parent_uri']
        return errorcounter

    def CheckAnchors(self, docset):
         content_path = '../../../public/docs/'
         json_file = content_path + docset + '/index.json'
         importer = DocImporter(docset)
         entries = importer.processJSON(json_file)
         anchornotfound = 0
         for entry in entries:
            path = entry['path']
            if not entry['path'].endswith('.html'):
                path += '.html'
            filename = content_path + docset + '/' + path
            content = importer.getContent(filename)
            if entry['anchor']!= "":
               if content.find('id="' + entry['anchor']+ '"') == -1:
                   anchornotfound += 1
                   print entry['anchor']
         return anchornotfound