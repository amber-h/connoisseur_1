require 'json'
require 'open-uri'
require 'erb'

class HtmlGenerator

	def index
		puts "HtmlGenerator: index"
		raw_response = open("http://lcboapi.com/products").read
		# Parse JSON­formatted text into a Ruby Hash
		parsed_response = JSON.parse(raw_response)
		# Return the actual result data from the response, ignoring metadata
		@products = parsed_response["result"]
		
		
		@p1 = @products[0]["name"]
		@p2 = @products[1]["name"]

		

		generate_html( 'index.erb', 'index.html' )

		#useful info: "name" , "price_in_cents", "image_url"
	end

	def show(product_id)
		puts "HtmlGenerator: show [id]"
		raw_response = open("http://lcboapi.com/products/#{product_id}").read
		# write the same as the index method but passing a product_id inend
		parsed_response = JSON.parse(raw_response)
		@product = parsed_response["result"]
		puts @product
		generate_html( 'show.erb', 'show.html' )
	end

	def product_info(product)
		@name = product['name']
		@price_in_cents = '$' + (product['price_in_cents']/100).to_s
		@image_thumb_url    = product['image_thumb_url']
		@image_url = product['image_url']
		@serving_suggestion = product['serving_suggestion']
		@tasting_note = product['tasting_note']
		@primary_category = product['primary_category']
		@secondary_category = product['secondary_category']
		@producer_name = product['producer_name']
	end

	def generate_html(erb_file, html_file)
		html_template = File.read( erb_file )
		erb_result = ERB.new( html_template ).result(binding)
		puts erb_result

		File.open( html_file, 'w') { |file| file.write(erb_result) }
	end

	

	

end
