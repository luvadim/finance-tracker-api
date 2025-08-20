module Transactions
  class ProcessVoiceMessage < BaseService
    def initialize(voice_url, user, transaction_params)
      @voice_url = voice_url
      @user = user
      @transaction_params = transaction_params
    end

    def call
      text = Transactions::AudioProcessor.call(@voice_url)
      transactions = Transactions::ListOfTransactionsFromText.call(text)
      processed_transactions = []
      
      transactions.each do |transaction|
        if transaction['product'].present? && transaction['amount'].present?
          product = @user.products.find_by('lower(name) = ?', transaction['product'].downcase)
          if product
            processed_transactions << create_voice_transaction(@user, transaction['amount'], product)
          else
            processed_transactions << {
              category: nil,
              product: transaction['product'],
              amount: transaction['amount'],
            }
          end
        end
      end

      processed_transactions
    end

    private

    def create_voice_transaction(user, amount, product)
      full_params = @transaction_params.merge(category_id: product.category_id, amount: amount)

      transaction = user.transactions.build(full_params)
      response = {
        category: transaction.category.name,
        product: product.name,
        amount: transaction.amount,
        account_id: transaction.account_id,
        category_id: product.category_id,
      }

      if transaction.save
        response
      else
        {
          category: nil,
          product: product.name,
          amount: amount,
        }
      end
    end
  end
end