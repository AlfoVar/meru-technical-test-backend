require 'rails_helper'

RSpec.describe Products::DeleteProduct, type: :service do
  it 'elimina un producto existente' do
    # Crear el producto (precondición)
    product = Product.create(name: 'Producto 1', description: 'Descripción del producto', price: 100.0)
    
    # Verificar que el producto fue creado
    expect(product).to be_persisted
    
    # Eliminar el producto
    service = Products::DeleteProduct.new(product)
    expect {
      service.call
    }.to change(Product, :count).by(-1)

    # Verificar que el producto fue eliminado
    expect(Product.find_by(id: product.id)).to be_nil
  end
end