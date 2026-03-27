require "csv"

puts "Clearing old data..."
Product.destroy_all
Page.destroy_all

puts "Making sure categories exist..."

category_data = [
  {
    name: "Fiber Crafts",
    description: "Crafts of any type made using yarn, floss or other fibers"
  },
  {
    name: "Sculptures",
    description: "Products made using sculpting techniques, using materials like clay, wood and stone"
  },
  {
    name: "Original Physical Art",
    description: "Original copies of a number of art forms. Some examples being: paintings, sketches, illustrations"
  },
  {
    name: "Prints",
    description: "Scanned prints of specific art pieces."
  }
]

categories = {}

category_data.each do |category_info|
  category = Category.find_or_create_by!(name: category_info[:name]) do |c|
    c.description = category_info[:description]
  end

  # update description too, in case category already existed
  category.update!(description: category_info[:description])

  categories[category.name] = category
end

puts "Loading products from CSV..."

csv_path = Rails.root.join("db", "products.csv")
product_count = 0

CSV.foreach(csv_path, headers: true) do |row|
  category = categories[row["category_name"]]

  if category.nil?
    puts "Skipping #{row["title"]} because category '#{row["category_name"]}' was not found."
    next
  end

  Product.create!(
    title: row["title"],
    description: row["description"],
    price: row["price"].to_f,
    stock_quantity: row["stock_quantity"].to_i,
    image_url: row["image_url"],
    is_featured: row["is_featured"].to_s.strip.downcase == "true",
    is_active: row["is_active"].to_s.strip.downcase == "true",
    category: category
  )

  product_count += 1
end

puts "Creating pages..."

Page.find_or_create_by!(slug: "about") do |page|
  page.title = "About ArtForYou"
  page.content = "ArtForYou is a company built to bring genuine human made art to the masses at a reasonable price for both the customer AND the artist."
end

Page.find_or_create_by!(slug: "contact") do |page|
  page.title = "Contact ArtForYou"
  page.content = "Contact ArtForYou for questions about products, artists, and general inquiries."
end

puts "Done!"
puts "#{Category.count} categories in database."
puts "#{Product.count} products in database."
puts "#{Page.count} pages in database."