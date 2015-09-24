module Docs
  class Request < Typhoeus::Request
    include Instrumentable


    USER_AGENTS = [
      'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6',
      'Mozilla/5.0 (X11; U; Linux i686; en-US) AppleWebKit/534.3 (KHTML, like Gecko)',
      'Chrome/6.0.472.63 Safari/534.3',
      'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)',
      'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)',
      'Yahoo! Slurp/Site Explorer',
      'Googlebot/2.1 ( http://www.googlebot.com/bot.html)',
      'msnbot/1.1 (+http://search.msn.com/msnbot.htm)',
      'Python-urllib/2.1',
      'Version/3.0 Mobile/1A543a Safari/419.3',
      'Version/6.0.0.141 Mobile Safari/534.1+',
    ]

    def self.run(*args, &block)
      request = new(*args)
      request.on_complete(&block) if block
      request.run
    end

    def initialize(url, options = {})
      rand_user_agent = USER_AGENTS[rand(USER_AGENTS.length)]
      default_options = {
        followlocation: true,
        headers: { 'User-Agent' => rand_user_agent }
      }
      super url.to_s, default_options.merge(options)
      
    end

    def response=(value)
      value.extend Response if value
      super
    end

    def run
      instrument 'response.request', url: base_url do |payload|
        response = super
        payload[:response] = response
        response
      end
    end
  end
end
