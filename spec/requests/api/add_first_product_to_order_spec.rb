RSpec.describe 'POST /api/order/', type: :request do
  let!(:product_to_add_to_order) { create(:product) }
  let!(:registered_user) { create(:user) }
  let!(:authorization_headers) { registered_user.create_new_auth_token }

  describe 'with a valid product id' do
    before do
      post '/api/orders/',
           params: { product_id: product_to_add_to_order.id },
           headers: authorization_headers
    end

    it { expect(response).to have_http_status 201 }

    it 'is expected to have a message' do
      expect(
        JSON.parse(response.body)['message']
      ).to eq 'Product was successfully added to your order'
    end

    it 'is expected to have "items" key with product in it' do
      expect(JSON.parse(response.body)['order']['items'].count).to eq 1
    end

    it 'is expected to have product data in "item"' do
      expect(
        JSON.parse(response.body)['order']['items'][0]['title']
      ).to eq 'MyString'
    end
  end
end
