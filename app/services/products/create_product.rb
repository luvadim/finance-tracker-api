module Products
  class CreateProduct < BaseService
    def initialize(user, product_params)
      @user = user
      @product_params = product_params
    end

    def call
      product = @user.products.build(@product_params)
      if product.save
        product
      else
        nil
      end
    end
  end
end