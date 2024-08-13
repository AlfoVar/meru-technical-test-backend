module Products
    class DeleteProduct
      def initialize(product)
        @product = product
      end
  
      def call
        @product.destroy if @product.is_a?(Product)
      end
    end
  end
  