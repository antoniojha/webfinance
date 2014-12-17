json.array!(@spendings) do |spending|
  json.extract! spending, :id, :transaction_date, :description, :amount, :balance, :image_url, :picture_file_name, :picture_content_type, :picture_file_size, :picture_updated_at, :category, :account_item_id
  json.url spending_url(spending, format: :json)
end
