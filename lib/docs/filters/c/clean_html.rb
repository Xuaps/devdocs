module Docs
  class C
    class CleanHtmlFilter < Filter
      NUMERIC_RANDOM = [
        'bernoulli_distribution',
        'binomial_distribution',
        'cauchy_distribution',
        'chi_squared_distribution',
        'discard_block_engine',
        'discrete_distribution',
        'exponential_distribution',
        'extreme_value_distribution',
        'fisher_f_distribution',
        'geometric_distribution',
        'independent_bits_engine',
        'linear_congruential_engine',
        'gamma_distribution',
        'lognormal_distribution',
        'mersenne_twister_engine',
        'negative_binomial_distribution',
        'piecewise_constant_distribution',
        'poisson_distribution',
        'seed_seq',
        'shuffle_order_engine',
        'student_t_distribution',
        'subtract_with_carry_engine',
        'uniform_int_distribution',
        'uniform_real_distribution',
        'weibull_distribution',
        'normal_distribution',
        'piecewise_linear_distribution',
        'random_device'
      ]
      FUNCTION = [
        'function',
        'reference_wrapper'
      ]
      NUMERIC_VALARRAY = [
        'gslice_array',
        'mask_array',
        'slice_array',
        'indirect_array'
      ]
      THREAD_THREAD = [
        'id/operator_cmp',
        'id/operator_ltlt',
        'id/hash',
        'id/id'
      ]
      LOCALE_LOCALE = [
        'facet/facet',
        'id/id'
      ]
      def call
        css('h1').remove if root_page? 

        css('#siteSub', '#contentSub', '.printfooter', '.t-navbar', '.editsection', '#toc',
            '.t-dsc-sep', '.t-dcl-sep', '#catlinks', '.ambox-notice', '.mw-cite-backlink',
            '.t-sdsc-sep:first-child:last-child', '.t-example-live-link').remove

        css('#bodyContent', '.mw-content-ltr', 'span[style]').each do |node|
          node.before(node.children).remove
        end

        css('h2 > span[id]', 'h3 > span[id]', 'h4 > span[id]', 'h5 > span[id]', 'h6 > span[id]').each do |node|
          node.parent['id'] = node['id']
          node.before(node.children).remove
        end

        css('table[style]', 'th[style]', 'td[style]').remove_attr('style')

        css('.t-dsc-hitem > td', '.t-dsc-header > td').each do |node|
          node.name = 'th'
          node.content = ' ' if node.content.empty?
        end

        css('tt', 'span > span.source-cpp').each do |node|
          node.name = 'code'
        end

        css('div > span.source-cpp').each do |node|
          node.name = 'pre'
          node.inner_html = node.inner_html.gsub('<br>', "\n")
          node.content = node.content
        end

        css('div > a > img[alt="About this image"]').each do |node|
          node.parent.parent.remove
        end

        css('area[href]').each do |node|
          node['href'] = node['href'].remove('.html')
        end

        css('a[href]').each do |node|
          if !node['href'].start_with? 'http://'
            node['href'] = node['href'].remove('.html').remove('../').gsub('%23', '#').gsub('%28', '(').gsub('%29', ')').gsub('%21', '!').gsub('%7b', '{').gsub('%7e', '~').gsub('%2a', '*').gsub('%2b', '+').gsub('%3d', '=')
            if node['href'].start_with? 'operator'
                node['href'] = slug
            elsif node['href'].end_with? '*' or node['href'].end_with? '+' or node['href'].end_with? '()' or node['href'].end_with? '!'
                node['href'] = node['href'].split('/')[0..-2].join('/')
            elsif node['href'].include? '/~'
                node['href'] = slug
            elsif node['href'].include? '~'
                node['href'] = node['href'].remove! '~'
            elsif node['href'].start_with? 'string/basic_string'
                node['href'] = 'string/basic_string'
            end
            subhref = node['href'].split('/')[0]
            if NUMERIC_RANDOM.include? subhref
                node['href'] = 'numeric/random/' + node['href']
            end
            if FUNCTION.include? subhref
                node['href'] = 'utility/functional/' + node['href']
            end
            if NUMERIC_VALARRAY.include? subhref
                node['href'] = 'numeric/valarray/' + node['href']
            end
            if THREAD_THREAD.include? node['href'] and slug.start_with? 'thread'
                 node['href'] = 'thread/thread/' + node['href']
            end
            if LOCALE_LOCALE.include? node['href'] and slug.start_with? 'locale'
                 node['href'] = 'locale/locale/' + node['href']
            end
            if node['href'] == 'bad_array_new_length/bad_array_new_length'
                node['href'] = 'memory/new/bad_array_new_length/bad_array_new_length'
            end
            if node['href'] == 'index'
                node['href'] = 'header/utility'
            end
          end
        end

        css('h1 ~ .fmbox').each do |node|
          node.name = 'div'
          node.content = node.content
        end

        doc
      end
    end
  end
end
