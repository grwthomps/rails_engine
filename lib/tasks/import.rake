require 'csv'

desc "Import data from csv files"
task :import_csv => [:environment] do
  files = {
    Merchant => 'db/import/merchants.csv',
    Customer => 'db/import/customers.csv',
    Item => 'db/import/items.csv',
    Invoice => 'db/import/invoices.csv',
    InvoiceItem => 'db/import/invoice_items.csv',
    Transaction => 'db/import/transactions.csv'
  }

  files.each do |model, path|
    CSV.foreach(path, :headers => true) do |row|
      model.create!(row.to_h)
    end
  end
end
