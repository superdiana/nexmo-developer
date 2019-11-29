class SidenavSubitem < SidenavItem
  include Rails.application.routes.url_helpers

  def title
    @title ||= TitleNormalizer.call(@folder)
  end

  def show_link?
    @folder[:is_file?] || @folder[:is_tabbed?]
  end

  def collapsible?
    @options['collapsible'].nil? || @options['collapsible']
  end

  def url
    @url ||= @folder[:external_link] || build_url
  end

  def build_url
    if @folder[:root] == 'config/tutorials'
      params = {
        tutorial_name: Navigation.new(@folder).path_to_url,
        controller: :tutorial,
        action: :index,
        product: @folder[:product],
        only_path: true
      }
      params.merge!(locale: I18n.locale) if enforce_locale?
      url_for(params)
    elsif @folder[:root] == '_use_cases'
      params = {
        document: Navigation.new(@folder).path_to_url,
        controller: controller,
        action: :show,
        only_path: true
      }
      params.merge!(locale: I18n.locale) if enforce_locale?
      url_for(params)
    else
      if enforce_locale?
        "/#{I18n.locale}/#{Navigation.new(@folder).path_to_url}"
      else
        "/#{Navigation.new(@folder).path_to_url}"
      end
    end
  end

  def controller
    if @folder[:path].starts_with?('_documentation')
      :markdown
    elsif @folder[:path].starts_with?('_use_cases')
      :use_case
    end
  end
end
