module Products
    class GetProduct
        def initialize(id)
          @id = id
        end

        def call
            Product.find_by(id: @id)
        end
    end
end