require "sequel"
require "sinatra"
require "sinatra/sequel"

set :database, ENV.delete("DATABASE_URL") || "postgresql://codificator:adminastor@db:5432"
set :logging, false

migration "products table" do
  database.create_table :products do
    primary_key :id
    text :description
  end

  require "csv"

  CSV.foreach "products.csv", "r", col_sep: "|", quote_char: "@" do |row|
    database[:products].insert row
  end
end

get "/api/products/:id?" do |id|
  database[:products][id.to_i].to_json
end

get "/api/products/?" do
  content_type "application/json"

  dataset = database[:products]
  if params[:description]
    dataset = dataset.where(Sequel.like(Sequel.function(:lower, :description), "#{params[:description]}%"))
  end

  dataset.all.to_json
end
