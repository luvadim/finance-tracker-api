module Transactions
  class ListOfTransactionsFromText < BaseService
    SYSTEM_PROMPT = <<-PROMPT
      You are an expert at extracting structured data from text.
      From the user's text, extract all purchases, including the amount and the product for each.
      The amount should be a number.
      Respond ONLY with a valid JSON object containing a single key, "transactions", which is an array of objects. Each object in the array should have the keys "amount" and "product".
      If text is written in another language other than English, translate it to English before extracting the data.
      If you cannot find any transaction information, the array should be empty.
      PROMPT

    def initialize(text)
      @text = text
    end

    def call
      chat_response = OpenAi::JsonObjFromText.call(@text, SYSTEM_PROMPT)
      json_string = chat_response.dig("choices", 0, "message", "content")
      structured_data = JSON.parse(json_string)
    
      structured_data["transactions"]
    end
  end
end