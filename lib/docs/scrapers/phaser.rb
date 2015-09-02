module Docs
  class Phaser < UrlScraper
    self.type = 'phaser'
    self.version = '2.4.1'
    self.base_url = "http://phaser.io/docs/#{version}"

    html_filters.push 'phaser/entries', 'phaser/clean_html'
    options[:domain] = 'http://www.refly.xyz'
    options[:root_title] = 'Phaser'
    options[:docset_uri] = '/phaser'
    options[:skip] = %w(
      /docs_pixi-jsdoc.js.html
      /p2.Body.html
      /Phaser.html
      /PIXI.html
      /PIXI.WebGLMaskManager.html
      /PIXI.WebGLShaderManager.html
      /PIXI.WebGLSpriteBatch.html
      /PIXI.WebGLStencilManager.html)

    options[:attribution] = <<-HTML
      &copy; 2015 Richard Davey, Photon Storm Ltd.<br>
      Licensed under the MIT License.
    HTML
  end
end
