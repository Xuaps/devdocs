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

# LINK TESTS

    def test_Bower(self):
        importer = DocImporter('bower')
        entries = importer.processJSON('tests/data/test_bower.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_bower.html'))
        self.assertEqual(content, u'<ul><li><a href="/bower/analytics">analytics</a></li> <li><a href="/bower/cwd">cwd</a></li><li><a href="/bower/https-proxy">https-proxy</a></li><li><a href="/bower/color">color</a></li><li><a href="/bower/register">Register</a></li><li><a href="/bower/analytics">analytics</a></li><li><a href="/bower/init"><code>bower init</code></a></li></ul>')

    def test_Chai(self):
        importer = DocImporter('chai')
        entries = importer.processJSON('tests/data/test_chai.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_chai.html'))
        self.assertEqual(content, u'<ul><li><a href="guide/plugins/">core concepts</a></li><li><a href="/chai/addproperty" class="clean-button">View addProperty API</a></li><li><a href="/chai/addmethod" class="clean-button">View addMethod API</a></li></ul>')

    def test_Cordova(self):
        importer = DocImporter('cordova')
        entries = importer.processJSON('tests/data/test_cordova.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_cordova.html'))
        self.assertEqual(content, u'<ul><li><a href="/apache-cordova/overview">Overview</a></li><li><a href="/apache-cordova/the_command-line_interface">The Command-Line Interface</a></li><li><a href="/apache-cordova/amazon_fire_os_configuration">Amazon Fire OS Configuration</a></li><li><a href="/apache-cordova/amazon_fire_os_webviews">Amazon Fire OS WebViews</a></li><li><a href="/apache-cordova/amazon_fire_os_plugins">Amazon Fire OS Plugins</a></li></ul>')

    def test_CSS(self):
        importer = DocImporter('php')
        entries = importer.processJSON('tests/data/test_css.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_css.html'))
        self.assertEqual(content, u'<a href="/css/height"><code>height</code></a>, <a href="/css/box-sizing"><code>box-sizing</code></a>, <a href="/css/min-width"><code>min-width</code></a>, <a href="/css/max-width"><code>max-width</code></a><a href="/css/_percentage_" title="Values of the &lt;percentage&gt; CSS data type are interpolated as real, floating-point numbers.">percentage</a>')

    def test_D3(self):
        importer = DocImporter('d3')
        entries = importer.processJSON('tests/data/test_d3.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_d3.html'))
        self.assertEqual(content, u'<div><a href="/d3/selection.attr">attributes</a>, <a href="/d3/selection.style">styles</a>, <a href="/d3/selection.property">properties</a>, <a href="/d3/selection.html">HTML</a> and <a href="/d3/selection.text">text</a></div>')

    def test_DOM(self):
        importer = DocImporter('dom')
        entries = importer.processJSON('tests/data/test_dom.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_dom.html'))
        self.assertEqual(content, u'<a href="/dom/eventtarget" title="EventTarget is an interface implemented by objects that can receive events and may have listeners for them."><code>EventTarget</code></a><a href="/dom/document/loadoverlay" title="The documentation about this has not yet been written; please consider contributing!"><code>document.load</code></a><a href="/dom/document/compatmode" title="Indicates whether the document is rendered in Quirks mode or Standards mode."><code>Document.compatMode</code></a><a href="document/domconfig" title="This should return the DOMConfiguration for the document."><code>Document.domConfig</code></a><a href="/dom/document/implementation" title="Returns a DOMImplementation object associated with the current document."><code>Document.implementation</code></a>')

    def test_DOM_EVENTS(self):
        importer = DocImporter('dom_events')
        entries = importer.processJSON('tests/data/test_dom_events.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_dom_events.html'))
        self.assertEqual(content, u'<ul><li><a href="/dom_events/loadstart"><code>loadstart</code></a></li><li><a href="/dom_events/progress"><code>progress</code></a></li><li><a href="/dom_events/error_(progressevent)"><code>error</code></a></li><li><a href="/dom_events/abort_(progressevent)"><code>abort</code></a></li><li><a href="/dom_events/load"><code>load</code></a></li><li><a href="/dom_events/loadend"><code>loadend</code></a></li></ul>')

    def test_Ember(self):
        importer = DocImporter('ember')
        entries = importer.processJSON('tests/data/test_ember.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_ember.html'))
        self.assertEqual(content, u'<ul><li><a href="/ember/classes/view">Ember.View</a></li><li><a href="/ember/modules/ember-views">ember-views</a></li></ul>')

    def test_Git(self):
        importer = DocImporter('git')
        entries = importer.processJSON('tests/data/test_git.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_git.html'))
        self.assertEqual(content, u'<ul><li><a href="/git/gitattributes">gitattributes[5]</a></li><li><a href="/git/git-upload-archive">git-upload-archive[1]</a></li><li><a href="/git/git-http-backend">ATTRIBUTES</a></li><li><a href="/git/git-log">git-log[1]</a></li><li><a href="/git/git-blame">git-blame[1]</a></li></ul>')

    def test_Go(self):
        importer = DocImporter('go')
        entries = importer.processJSON('tests/data/test_go.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_go.html'))
        self.assertEqual(content, u'<ul><li><a href="/go/archive/zip/writer_zip">zip</a></li><li><a href="/go/bytes/map_bytes">bytes</a></li><li><a href="/go/compress/lzw">lzw</a></li><li><a href="/go/go_programming_language/sub-repositories">Sub-repositories</a></li></ul>')

    def test_Grunt(self):
        importer = DocImporter('grunt')
        entries = importer.processJSON('tests/data/test_grunt.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_grunt.html'))
        self.assertEqual(content, u'<ul><li><a href="/grunt/using-the-cli">Using the CLI</a></li><li><a href="/grunt/api/grunt">grunt.fatal</a></li></ul>')

    def test_HTML(self):
        importer = DocImporter('html')
        entries = importer.processJSON('tests/data/test_html.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_html.html'))        
        self.assertEqual(content, u'<ul><li><a href="/html/global_attributes" style="line-height: 21px;" title="HTML/Global attributes">global attributes</a></li><li><a href="/html/element/base" title="The HTML Base Element (&lt;base&gt;) specifies the base URL to use for all relative URLs contained within a document. There can be only one &lt;base&gt; element in a document."><code>&lt;base&gt;</code></a></li><li><a href="/html/element/link" title="The HTML Link Element (&lt;link&gt;) specifies relationships between the current document and an external resource. Possible uses for this element include defining a relational framework for navigation. This Element is most used to link to style sheets."><code>&lt;link&gt;</code></a></li><li><a href="/html/element/meter" title="The HTML &lt;meter&gt; Element represents either a scalar value within a known range or a fractional value."><code>&lt;meter&gt;</code></a></li><li><a href="/html/element/meter" title="The HTML &lt;meter&gt; Element represents either a scalar value within a known range or a fractional value."><code>&lt;meter&gt;</code></a></li><li><a href="/html/element/basefont" title="The HTML basefont element (&lt;basefont&gt;) establishes a default font size for a document. Font size then can be varied relative to the base font size using the &lt;font&gt; element."><code>&lt;basefont&gt;</code></a></li><li><a href="/html/element/option" title="In a Web form, the HTML &lt;option&gt; element is used to create a control representing an item within a &lt;select&gt;, an &lt;optgroup&gt; or a &lt;datalist&gt; HTML5 element."><code>&lt;option&gt;</code></a></li></ul>')

    def test_JQuery(self):
        importer = DocImporter('jquery')
        entries = importer.processJSON('tests/data/test_jquery.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_jquery.html'))
        self.assertEqual(content, u'<ul><li><a href="/jquery/jquery.parsehtml">$.parseHTML()</a></li><li><a href="/jquery/jquery.each"><em>each</em> function</a></li><li><a href="/jquery/jquery.merge"><em>Merge</em> function</a></li><li><a href="/jquery/jquery.parsehtml">ParseHtml function</a></li><li><a href="/jquery/jquery.proxy">Proxy function</a></li></ul>')

    def test_JQueryMobile(self):
        importer = DocImporter('jquerymobile')
        entries = importer.processJSON('tests/data/test_jquerymobile.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_jquerymobile.html'))
        self.assertEqual(content, u'<ul><li><a href="/jquerymobile/configuring_defaults"><code>ns</code> global option</a></li><li><a href="/jquerymobile/collapsible">Collapsible</a></li><li><a href="/jquerymobile/collapsibleset">Collapsible set</a></li><li><a href="/jquerymobile/flipswitch">Flip toggle switch</a></li></ul>')

    def test_JQueryUI(self):
        importer = DocImporter('jquery')
        entries = importer.processJSON('tests/data/test_jqueryui.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_jqueryui.html'))
        self.assertEqual(content, u'<ul><li><a href="/jqueryui/jquery.widget">Widget Factory</a></li><li><a href="/jqueryui/theming/css-framework">jQuery UI CSS framework</a></li><li><a href="/jqueryui/easings">easing</a></li><li><a href="/jqueryui/theming/icons">an icon provided by the jQuery UI CSS Framework</a></li></ul>')

    def test_JavaScript(self):
        importer = DocImporter('javascript')
        entries = importer.processJSON('tests/data/test_javascript.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_javascript.html'))       
        self.assertEqual(content, u'<dl><dt><a href="/javascript/statements/block" title="A block statement"><code>Block</code></a></dt><dt><a href="/javascript/statements/break" title="The break statement"><code>break</code></a></dt><dt><a href="/javascript/statements/continue" title="The continue statement"><code>continue</code></a></dt><dt><a href="/javascript/statements/empty" title="An empty statement"><code>Empty</code></a></dt><dt><a href="/javascript/statements/if...else" title="The if statement"><code>if...else</code></a></dt><dt><a href="/javascript/statements/switch" title="The switch statement"><code>switch</code></a></dt><dt><a href="/javascript/statements/throw" title="The throw statement"><code>throw</code></a></dt><dt><a href="/javascript/statements/try...catch" title="The try...catch statement"><code>try...catch</code></a></dt><dt><a href="/javascript/operators/yield" title="The yield operator"><code>try...catch</code></a></dt><dt><a href="/javascript/operators/yield+" title="The yield* operator"><code>try...catch</code></a></dt><dt><a href="/javascript/functions/arguments" title="The arguments functions"><code>arguments</code></a></dt></dl>')

    def test_MarkDown(self):
        importer = DocImporter('markdown')
        entries = importer.processJSON('tests/data/test_markdown.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_markdown.html'))
        self.assertEqual(content, u'<ul> <li><a href="/markdown/overview">Overview</a><li><a href="/markdown/philosophy">Philosophy</a></li> <li><a href="/markdown/inline_html">Inline HTML</a></li> <li><a href="/markdown/automatic_escaping_for_special_characters">Automatic Escaping for Special Characters</a></li><li><a href="/markdown/paragraphs_and_line_breaks">Paragraphs and Line Breaks</a></li> <li><a href="/markdown/headers">Headers</a></li> <li><a href="/markdown/blockquotes">Blockquotes</a></li> <li><a href="/markdown/lists">Lists</a></li> <li><a href="/markdown/code_blocks">Code Blocks</a></li> <li><a href="/markdown/horizontal_rules">Horizontal Rules</a></li></ul>')

    def test_Less(self):
        importer = DocImporter('less')
        entries = importer.processJSON('tests/data/test_less.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_less.html'))
        self.assertEqual(content, u'<ul><li><a href="/less/data-uri">data-uri</a></li><li><a href="/less/default">default</a></li><li><a href="/less/desaturate">desaturate</a></li><li><a href="/less/difference">difference</a></li></ul>')

    def test_Nginx(self):
        importer = DocImporter('nginx')
        entries = importer.processJSON('tests/data/test_nginx.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_nginx.html'))
        self.assertEqual(content, u'<ul><li><a href="/nginx/server">server</a></li><li><a href="/nginx/error_log">selected client addresses</a></li><li><a href="/nginx/error_log">error_log</a></li><li><a href="/nginx/auth_request_set">auth_request_set</a><br><a href="/nginx/autoindex">autoindex</a></li><li><a href="/nginx/autoindex_format">autoindex_format</a></li></ul>')

    def test_Node(self):
        importer = DocImporter('node')
        entries = importer.processJSON('tests/data/test_node.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_node.html'))
        self.assertEqual(content, u'<ul><li><a href="/nodejs/stream.writable">Writable Stream</a></li><li><a href="/nodejs/http.incomingmessage">http.IncomingMessage</a></li><li><a href="/nodejs/eventemitter">EventEmitter</a></li><li><a href="/nodejs/buffer.inspect_max_bytes">Buffer</a></li><li><a href="/nodejs/agent.destroy"><code>destroy()</code></a></li><li><a href="/nodejs/new_agent">constructor options</a></li></ul>')

    def test_PostgreSQL(self):
        importer = DocImporter('postgresql')
        entries = importer.processJSON('tests/data/test_postgresql.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_postgresql.html'))
        self.assertEqual(content, u'<ul><li><a href="/postgresql/function/and">Logical Operators</a></li><li><a href="functions-comparison">Comparison Operators</a></li><li><a href="/postgresql/math">Mathematical Functions and Operators</a></li><li><a href="/postgresql/string_functions_and_operators">String Functions and Operators</a></li><li><a href="/postgresql/binary_string_functions_and_operators">Binary String Functions and Operators</a></li><li><a href="/postgresql/bit_string_functions_and_operators">Bit String Functions and Operators</a></li><li><a href="/postgresql/pattern_matching">Pattern Matching</a></li><li><a href="/postgresql/function/like"><code class="FUNCTION">LIKE</code></a></li><li><a href="/postgresql/function/similar_to_regular_expressions"><code class="FUNCTION">SIMILAR TO</code> Regular Expressions</a></li></ul>')

    def test_PHP(self):
        importer = DocImporter('php')
        entries = importer.processJSON('tests/data/test_php.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_php.html'))
        self.assertEqual(content, u'<ul class="chunklist chunklist_part"><li><a href="/javascript/p1">P1</a></li><li><a href="/javascript/p2">P2</a></li><li><a href="/javascript/p3">P3</a></li><li><a href="/javascript/p4">P4</a></li><li><a href="/javascript/p5">P5</a></li><li><a href="/javascript/p6">P6</a></li><li><a href="/javascript/p7">P7</a></li><li><a href="/javascript/p8">P8</a></li><li><a href="/javascript/p9">P9</a></li><li><a href="/javascript/p10">P10</a></li><li><a href="/javascript/p11">P11</a></li><li><a href="/javascript/p12">P12</a></li></ul>')

    def test_React(self):
        importer = DocImporter('react')
        entries = importer.processJSON('tests/data/test_react.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_react.html'))
        self.assertEqual(content, u'<ul><li><a href="/react/animation"><code>TransitionGroup</code> and <code>CSSTransitionGroup</code></a></li><li><a href="/react/two-way-binding-helpers"><code>LinkedStateMixin</code></a></li><li><a href="/react/class-name-manipulation"><code>classSet</code></a></li><li><a href="/react/react_elements_">ReactElement / ReactElement Factory</a></li><li><a href="/react/react_components_">ReactComponent / ReactComponent Class</a></li><li><a href="/react/react_nodes_">ReactNode</a></li></ul>')

    def test_RequireJS(self):
        importer = DocImporter('requirejs')
        entries = importer.processJSON('tests/data/test_requirejs.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_requirejs.html'))
        self.assertEqual(content, u'<ul><li><a href="/requirejs/_introduction__">Introduction</a></li><li><a href="/requirejs/define_a_module_with_a_name">Module Name</a></li><li><a href="/requirejs/_example_loading_jquery_from_a_cdn__">Example loading jquery from a CDN</a></li><li><a href="/requirejs/_mapping_modules_to_use_noconflict__">Mapping Modules to use noConflict</a></li><li><a href="/requirejs/_mapping_modules_to_use_noconflict__">later</a></li><li><a href="api#config-map">map config</a></li></ul>')

    def test_Sinon(self):
        importer = DocImporter('sinon')
        entries = importer.processJSON('tests/data/test_sinon.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_sinon.html'))
        self.assertEqual(content, u'<ul><li><a href="/sinonjs/assertions">Assertions</a></li><li><a href="/sinonjs/clock.restore">clock.restore()</a></li><li><a href="/sinonjs/clock.tick">clock.tick()</a></li><li><a href="/sinonjs/expectation.atleast">expectation.atLeast()</a></li></ul>')

    def test_SVG(self):
        importer = DocImporter('svg')
        entries = importer.processJSON('tests/data/test_svg.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_svg.html'))
        self.assertEqual(content, u'<h3 id="Global_attributes">Global attributes</h3><ul><li><a href="/svg/attribute" title="en/SVG/Attribute#ConditionalProccessing">Conditional processing attributes</a> \xbb</li><li><a href="/svg/attribute" title="en/SVG/Attribute#Core">Core attributes</a></li><li><a href="/svg/attribute" title="en/SVG/Attribute#GraphicalEvent">Graphical event attributes</a></li><li><a href="/svg/attribute" title="en/SVG/Attribute#Presentation">Presentation attributes</a></li><li><a href="/svg/attribute" title="en/SVG/Attribute#XLink">XLink attributes</a> </li><li><code><a href="/svg/attribute/class">class</a></code></li><li><code><a href="/svg/attribute/style">style</a></code></li><li><code><a href="/svg/attribute/externalresourcesrequired">externalResourcesRequired</a></code></li><li><code><a href="/svg/attribute/dx">dx</a></code></li><li><code><a href="/svg/attribute/dy">dy</a></code></li></ul>')

    def test_XPATH(self):
        importer = DocImporter('xpath')
        entries = importer.processJSON('tests/data/test_xpath.json')
        importer.links = importer.CreateLinkCollection(entries)
        content = importer.ProcessContent(importer.getContent('tests/data/test_xpath.html'))
        self.assertEqual(content, u'<ul><li><a href="/xpath/functions/boolean" title="en/XPath/Functions/boolean">boolean()</a></li> <li><a href="/xpath/functions/ceiling" title="en/XPath/Functions/ceiling">ceiling()</a></li> <li><a href="/xpath/functions/choose" title="en/XPath/Functions/choose">choose()</a></li> <li><a href="/xpath/functions/concat" title="en/XPath/Functions/concat">concat()</a></li> <li><a href="/xpath/functions/contains" title="en/XPath/Functions/contains">contains()</a></li> <li><a href="/xpath/functions/count" title="en/XPath/Functions/count">count()</a></li></ul>')