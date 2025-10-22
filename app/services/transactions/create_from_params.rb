class Transactions::CreateFromParams
  include Interactor

  def call
    description = context.params[:description]&.downcase
    category_id = find_category_id(description)

    unless category_id
      context.fail!(category_required?: true)
      return
    end

    full_params = context.params.merge(category_id: category_id)
    transaction = context.user.transactions.build(full_params)

    if transaction.save
      context.transaction = transaction
    else
      context.fail!(errors: transaction.errors.full_messages)
    end
  end

  private

  def find_category_id(description)
    return context.params[:category_id] if context.params[:category_id].present?

    product = context.user.products.find_by('lower(name) = ?', description)

    product&.category_id
  end
end