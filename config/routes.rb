Rails.application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :users, ActiveAdmin::Devise.config

  namespace :feedback do
    resources :feedbacks
  end

  namespace :usage do
    resources :code_snippet
    resources :ab_result, only: [:create]
  end

  namespace :admin_api, defaults: { format: 'json' } do
    resources :feedback, only: [:index]
    resources :code_snippets, only: [:index]
  end

  get '/robots.txt', to: 'static#robots'
  get '/jwt', to: 'static#jwt'

  get '(/:locale)/*landing_page', to: 'static#default_landing', constraints: LandingPageConstraint.matches?.merge(locale: LocaleConstraint.available_locales), as: :static

  get 'markdown/show'

  get '/signout', to: 'sessions#destroy'

  post '/jobs/code_example_push', to: 'jobs#code_example_push'
  post '/jobs/open_pull_request', to: 'jobs#open_pull_request'

  get '/coverage', to: 'dashboard#coverage'
  get '/stats', to: 'dashboard#stats'
  get '/stats/summary', to: 'dashboard#stats_summary'

  get '/use-cases/(:code_language)', to: 'use_case#index', constraints: CodeLanguage.route_constraint, as: :use_cases
  get '/use-cases/*document(/:code_language)', to: 'use_case#show', constraints: CodeLanguage.route_constraint

  get '/*product/use-cases(/:code_language)', to: 'use_case#index', constraints: DocumentationConstraint.documentation

  get '/*product/use-cases(/:code_language)', to: 'use_case#index', constraints: lambda { |request|
    products = Product.all.map { |p| p['path'] }

    # If there's no language in the URL it's an implicit match
    includes_language = true

    # If there's a language in the URL, match on that too
    if request['code_language']
      language = CodeLanguage.linkable.map(&:key).map(&:downcase)
      includes_language = language.include?(request['code_language'])
    end

    products.include?(request['product']) && includes_language
  }

  get '(/:locale)/documentation', to: 'static#documentation', constraints: LocaleConstraint.new, as: :documentation

  get '/migrate/tropo/(/*guide)', to: 'static#migrate_details'

  get '/legacy', to: 'static#legacy'
  get '(/:locale)/team', to: 'static#team', constraints: LocaleConstraint.new

  get '/community/slack', to: 'slack#join'
  post '/community/slack', to: 'slack#invite'

  get '(/:locale)/tools', to: 'static#tools', constraints: LocaleConstraint.new, as: :tools
  get '/community/past-events', to: 'static#past_events'

  get '/feeds/events', to: 'feeds#events'

  get '(/:locale)/extend', to: 'extend#index', constraints: LocaleConstraint.new, as: :extend
  get '(/:locale)/extend/:title', to: 'extend#show', constraints: LocaleConstraint.new

  get '/event_search', to: 'static#event_search'
  match '/search', to: 'search#results', via: %i[get post]

  get '/api-errors', to: 'api_errors#index'
  get '/api-errors/generic/:id', to: 'api_errors#show'
  get '/api-errors/:definition(/*subapi)', to: 'api_errors#index_scoped', as: 'api_errors_scoped', constraints: OpenApiConstraint.errors_available
  get '/api-errors/*definition/:id', to: 'api_errors#show', constraints: OpenApiConstraint.errors_available

  get '(/:locale)/api', to: 'api#index', as: :api

  scope '(/:locale)', constraints: LocaleConstraint.new do
    mount ::Nexmo::OAS::Renderer::API, at: '/api'
  end

  authenticated(:user) do
    mount Split::Dashboard, at: 'split' if ENV['REDIS_URL']
  end

  scope '(/:locale)', constraints: LocaleConstraint.new do
    resources :careers, only: [:index]
  end

  get '(/:locale)/task/(*tutorial_step)', to: 'tutorial#single', constraints: LocaleConstraint.new
  get '(/:locale)/*product/tutorials', to: 'tutorial#list', constraints: DocumentationConstraint.documentation.merge(locale: LocaleConstraint.available_locales)
  get '(/:locale)/tutorials', to: 'tutorial#list', constraints: DocumentationConstraint.documentation.merge(locale: LocaleConstraint.available_locales)
  get '(/:locale)/(*product)/tutorials/(:tutorial_name)(/*tutorial_step)(/:code_language)', to: 'tutorial#index', constraints: DocumentationConstraint.product.merge(locale: LocaleConstraint.available_locales)
  get '(/:locale)/tutorials/(:tutorial_name)(/*tutorial_step)(/:code_language)', to: 'tutorial#index', constraints: CodeLanguage.route_constraint.merge(locale: LocaleConstraint.available_locales)

  scope '(/:locale)', constraints: LocaleConstraint.new do
    get '/*product/api-reference', to: 'markdown#api'
  end

  get '(/:locale)/:namespace/*document', to: 'markdown#show', constraints: { namespace: 'product-lifecycle', locale: LocaleConstraint.available_locales }, as: 'product_lifecycle'

  get '(/:locale)/:namespace/*document(/:code_language)', to: 'markdown#show', constraints: DocumentationConstraint.documentation.merge(namespace: 'contribute', locale: LocaleConstraint.available_locales)

  get '(/:locale)/*product/*document(/:code_language)', to: 'markdown#show', constraints: DocumentationConstraint.documentation.merge(locale: LocaleConstraint.available_locales)

  get '*unmatched_route', to: 'application#not_found'

  root 'static#landing'
end
