module Docs
  class Postgresql < UrlScraper
    self.name = 'PostgreSQL'
    self.type = 'postgres'
    self.version = '9.4'
    self.base_url = "http://www.postgresql.org/docs/#{version}/static/"
    self.root_path = 'reference.html'
    self.initial_paths = %w(sql.html admin.html sql-keywords-appendix.html)

    html_filters.insert_before 'normalize_urls', 'postgresql/extract_metadata'
    html_filters.push 'postgresql/clean_html', 'postgresql/entries', 'title'

    options[:domain] = 'http://www.refly.xyz'
    options[:title] = false
    options[:root_title] = 'PostgreSQL'
    options[:docset_uri] = '/postgresql'
    options[:follow_links] = ->(filter) { filter.initial_page? }

    options[:only] = %w(
      arrays.html
      rowtypes.html
      rangetypes.html
      transaction-iso.html
      explicit-locking.html
      applevel-consistency.html
      locking-indexes.html
      config-setting.html
      locale.html
      collation.html
      multibyte.html
      using-explain.html
      planner-stats.html
      explicit-joins.html
      populate.html
      non-durability.html
      logfile-maintenance.html
      continuous-archiving.html
      sql-keywords-appendix.html
      dynamic-trace.html)

    options[:only_patterns] = [
      /\Asql\-/,
      /\Aapp\-/,
      /\Addl\-/,
      /\Adml\-/,
      /\Aruntime\-/,
      /\Aqueries\-/,
      /\Apattern\-/,
      /\Adatatype\-/,
      /\Afunctions\-/,
      /\Atypeconv\-/,
      /\Atextsearch\-/,
      /\Amvcc\-/,
      /\Aindexes\-/,
      /\Aruntime\-config\-/,
      /\Aauth\-/,
      /\Aclient\-authentication/,
      /\Amanage\-ag/,
      /\Aroutine/,
      /\Abackup\-/,
      /\Amonitoring\-/,
      /\Awal\-/,
      /\Adisk/,
      /functions/,
      /bitstring_operators/,
      /role/,
      /recovery/,
      /standby/]

    options[:skip] = %w(
      ddl-others.html
      functions-event-triggers.html
      functions-trigger.html
      textsearch-migration.html)

    options[:attribution] = <<-HTML
      &copy; 1996&ndash;2014 The PostgreSQL Global Development Group<br>
      Licensed under the PostgreSQL License.
    HTML
  end
end
