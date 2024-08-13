require 'rails_helper'

RSpec.describe Products::UpdateProduct, type: :service do
  let(:product) do
    product = Product.new(name: 'Producto 1', description: 'Descripción del producto', price: 100.0)
    product.save
    product
  end
  let(:new_params) { { name: 'Producto Actualizado', description: 'Descripción actualizada', price: 150.0 } }

  it 'actualiza un producto con los atributos correctos' do
    service = described_class.new(product, new_params)
    updated_product = service.call

    expect(updated_product.name).to eq('Producto Actualizado')
    expect(updated_product.description).to eq('Descripción actualizada')
    expect(updated_product.price).to eq(150.0)
  end

  it 'no actualiza el producto si los parámetros son inválidos' do
    invalid_params = { name: '', description: '', price: nil }
    service = described_class.new(product, invalid_params)
    updated_product = service.call

    expect(updated_product.name).not_to eq('')
    expect(updated_product.description).not_to eq('')
    expect(updated_product.price).not_to be_nil
  end
end