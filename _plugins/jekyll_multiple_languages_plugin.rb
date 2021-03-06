
module Jekyll
  @parsedlangs = {}
  def self.langs
    @parsedlangs
  end
  def self.setlangs(l)
    @parsedlangs = l
  end
  class Site
    alias :process_org :process
    def process
      if !self.config['baseurl']
        self.config['baseurl'] = ""
      end
      #Variables
      config['baseurl_root'] = self.config['baseurl']
      baseurl_org = self.config['baseurl']
      languages = self.config['languages']
      exclude_org = self.exclude
      dest_org = self.dest

      #Loop
      self.config['lang'] = self.config['default_lang'] = languages.first
      puts
      puts "Building site for default language: \"#{self.config['lang']}\" to: #{self.dest}"
      process_org
      languages.drop(1).each do |lang|

        # Build site for language lang
        @dest = @dest + "/" + lang
        self.config['baseurl'] = self.config['baseurl'] + "/" + lang
        self.config['lang'] = lang

        # exclude folders or files from beeing copied to all the language folders
        exclude_from_localizations = self.config['exclude_from_localizations'] || []
        @exclude = @exclude + exclude_from_localizations

        puts "Building site for language: \"#{self.config['lang']}\" to: #{self.dest}"
        process_org

        #Reset variables for next language
        @dest = dest_org
        @exclude = exclude_org

        self.config['baseurl'] = baseurl_org
      end
      Jekyll.setlangs({})
      puts 'Build complete'
    end

    alias :read_posts_org :read_posts
    def read_posts(dir)
      if dir == ''
        read_posts("_i18n/#{self.config['lang']}/")
      else
        read_posts_org(dir)
      end
    end
  end

  class LocalizeTag < Liquid::Tag

    def initialize(tag_name, key, tokens)
      super
      @key = key.strip
    end

    def render(context, delimiter=".")
      if "#{context[@key]}" != "" #Check for page variable
        key = "#{context[@key]}"
      else
        key = @key
      end
      lang = context.registers[:site].config['lang']
      unless Jekyll.langs.has_key?(lang)
        puts "Loading translation from file #{context.registers[:site].source}/_i18n/#{lang}.yml"
        Jekyll.langs[lang] = YAML.load_file("#{context.registers[:site].source}/_i18n/#{lang}.yml")
      end
      translation = Jekyll.langs[lang].access(key, delimiter) if key.is_a?(String)
      if translation.nil? or translation.empty?
        translation = Jekyll.langs[context.registers[:site].config['default_lang']].access(key)
        puts "Missing i18n key: #{lang}:#{key}"
        puts "Using translation '%s' from default language: %s" %[translation, context.registers[:site].config['default_lang']]
      end
      translation
    end
  end
end

unless Hash.method_defined? :access
  class Hash
    def access(path, delimiter=".")
      ret = self
      path.split(delimiter).each do |p|
        if p.to_i.to_s == p
          ret = ret[p.to_i]
        else
          ret = ret[p.to_s] || ret[p.to_sym]
        end
        break unless ret
      end
      ret
    end
  end
end

module Blurb
  DELIMITER = "^^^"

  class LocalizeTag < Liquid::Tag
    def initialize(tag_name, key, tokens)
      super
      @key = key.strip
      @tag_name = tag_name
      @tokens = tokens
    end

    def render(context)
      key = full_key context, @key
      jekyll_render context, key
    end

    private
    def full_key(context, given_key)
      page = context["page"]["name"].gsub('.html', '')
      "#{page}#{DELIMITER}#{key context, given_key}"
    end

    def key(context, key)
      if "#{context[@key]}" != "" #Check for page variable
        "#{context[@key]}"
      else
        @key
      end
    end

    def jekyll_render(context, key)
      Jekyll::LocalizeTag.new(@tag_name, key, @tokens).render context, DELIMITER
    end
  end

  class LocalizeBlock < Liquid::Block
    def render(context)
      res = super
      stripped = res.strip.gsub("\n", '')
      jekyll_render context, key(context, stripped)
    end

    private
    def key(context, given_key)
      page = context["page"]["name"].gsub('.html', '')
      "#{page}#{DELIMITER}#{given_key}"
    end

    def jekyll_render(context, key)
      Jekyll::LocalizeTag.new(@tag_name, key, @tokens).render context, DELIMITER
    end
  end
end

Liquid::Template.register_tag('t', Blurb::LocalizeTag)
Liquid::Template.register_tag('tb', Blurb::LocalizeBlock)
Liquid::Template.register_tag('translate', Jekyll::LocalizeTag)
