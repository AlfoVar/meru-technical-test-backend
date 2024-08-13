require 'rails_helper'

RSpec.describe Products::CreateProduct, type: :service do
  let(:params) { { name: 'Producto 1', description: 'Descripción del producto', price: 100.0 } }

  it 'crea un producto con los atributos correctos' do
    service = described_class.new(params)
    product = service.call

    expect(product).to be_persisted
    expect(product.name).to eq('Producto 1')
    expect(product.description).to eq('Descripción del producto')
    expect(product.price).to eq(100.0)
  end

  it 'no crea un producto si los parámetros son inválidos' do
    invalid_params = { name: '', description: '', price: nil }
    service = described_class.new(invalid_params)
    product = service.call

    expect(product).not_to be_persisted
  end
end