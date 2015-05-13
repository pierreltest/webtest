module Jekyll
  class DraftTag < Liquid::Block
    def render(context)
      context.registers[:page]['draftable'] ? self.nodelist.first : ""
    end
  end

  class DraftPage < Page
    def initialize(site, base, dir, name)
      super
      data['draftable'] = true
    end

    def destination(dest)
      path = Jekyll.sanitized_path(File.join(dest, 'drafts'), URL.unescape_path(url))
      path = File.join(path, "index.html") if url =~ /\/$/
      path
    end
  end

  class DraftPageGenerator < Generator
    safe true

    def generate(site)
      draft_pages = []
      site.pages.each do |page|
        draft_pages << page if page.content.include?("{% draft %}")
      end

      puts("Found #{draft_pages.length} pages with draft content")

      draft_pages.each do |page|
        draft_page = DraftPage.new(site, 
          page.instance_variable_get('@base'),
          page.instance_variable_get('@dir'),
          page.name)
        site.pages << draft_page
      end
    end
  end
end

Liquid::Template.register_tag('draft', Jekyll::DraftTag)