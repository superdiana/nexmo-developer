require 'rails_helper'

RSpec.describe 'Markdown', type: :request do
  describe '#show' do
    context 'with a namespace' do
      it 'responds 200 for product-lifecycle' do
        get '/product-lifecycle/beta'

        expect(response).to have_http_status(:ok)
      end

      it 'responds 200 for contribute' do
        get '/contribute/overview'

        expect(response).to have_http_status(:ok)
      end

      it '/contribute redirects' do
        get '/contribute'

        expect(response).to redirect_to('/contribute/overview')
      end
    end

    context 'when the file specifies a redirect' do
      it 'redirects' do
        get '/client-sdk/sdk-documentation/ios/ios'

        expect(response).to redirect_to('/sdk/stitch/ios/')
      end
    end

    context 'requesting a document in a language it is not available' do
      it 'redirects to the english version' do
        expect(DocFinder).to receive(:find).and_raise(DocFinder::MissingDoc)
        expect(DocFinder).to receive(:find)
          .and_return(DocFinder::Doc.new(path: 'path/to/doc', available_languages: ['en']))

        get '/cn/messaging/sms/overview'

        expect(response).to redirect_to('/en/messaging/sms/overview')
      end
    end
  end

  describe '#api' do
    context 'with an existing redirect' do
      it 'redirects' do
        get '/messages/api-reference'

        expect(response).to redirect_to('/api/messages-olympus')
      end
    end

    context 'without one' do
      it 'renders 404' do
        get '/non_existing/api-reference'

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
