RSpec.describe 'PUT /api/orders/:id', type: :request do
  let!(:registered_user) { create(:user) }
  let!(:authorization_headers) { registered_user.create_new_auth_token }
  let!(:existing_order) { create(:order, user: registered_user) }
  let!(:product_already_in_order) { create(:product) }
  let!(:product_to_add) { create(:product, title: 'Vesuvio') }

  describe 'with a valid product id' do
    before do
      existing_order.items.create(product: product_already_in_order)
      put "/api/orders/#{existing_order.id}",
          params: { product_id: product_to_add.id },
          headers: authorization_headers
    end

    it { expect(response).to have_http_status 201 }

    it 'is expected to have product data in "item"' do
      expect(
        JSON.parse(response.body)['order']['items'][1]['title']
      ).to eq 'Vesuvio'
    end
  end
end
