require 'rails_helper'

RSpec.describe Products::GetProduct, type: :service do
  let(:product) do
    product = Product.new(name: 'Producto 1', description: 'Descripción del producto', price: 100.0)
    product.save
    product
  end

  it 'encuentra un producto por ID' do
    service = described_class.new(product.id)
    found_product = service.call

    expect(found_product).to eq(product)
  end

  it 'retorna nil si el producto no existe' do
    service = described_class.new(-1) # ID inválido
    found_product = service.call

    expect(found_product).to be_nil
  end
end