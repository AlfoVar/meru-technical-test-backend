module Products
    class CreateProduct
      def initialize(params)
        @params = params
      end
  
      def call
        product = Product.new(@params)
        if product.save
          { success: true, product: product }
        else
          { success: false, errors: product.errors.full_messages }
        end
      end
    end
  end