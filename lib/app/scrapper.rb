require 'nokogiri'
require 'open-uri'
require 'rubygems'
require "google_drive"
require 'CSV'

require './lib/views/end.rb'


class Scrapper



	def initialize
	    @result=[]  
	end



	def get_townhall_urls

	  
	    myhash_each = {}
	  
	    doc = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
	    
	        content = doc.css('tr')
	      
	       

	              # LIMITATION A 10 MAIRIES POUR ALLER PLUS VITE
	             10.times do |i|


	              
	              name= content.css('.lientxt')[i].text

	              
	              repertoire=content.css('.lientxt')[i]['href'].delete_prefix('.')
	              domaine="http://annuaire-des-mairies.com"
	              
	              
	              link= domaine+repertoire
	              
	              email=get_townhall_email(link).join
	              
	              myhash_each= {name => email}
	                
	              @result << myhash_each

	        end
	     
	      
	    
	     return @result


	end




	def get_townhall_email(townhall_url) 

	my_hash_each = {}
	my_array = []
	doc = Nokogiri::HTML(open(townhall_url))

	    doc.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]').each do |tr|
	    my_array << tr.text
	    end


	return my_array
	end



	def save_as_JSON
	    File.open("db/emails.json","w") do |f|
	      f.write(@result.to_json)
	    end
	    End.new.message_fin
	end




	def save_as_spreadsheet

	    session = GoogleDrive::Session.from_config("client_id.json")
	    myspreadsheet = session.spreadsheet_by_key("1Lh4W28BPcdw8hwZSq9WjIqETfVm47_dKXBa1nHzAWcs").worksheets[0]
	    i=1

	    
	        @result.each do |line|

	           
	                line.each do |mairie, mail|
	                myspreadsheet[i, 1] = mairie
	                myspreadsheet[i, 2] = mail
	                i+=1
	                myspreadsheet.save
	                end
	        end
	    puts End.new.message_fin
	end




	def save_as_csv

	    csv = File.open("db/emails.csv","w")
	    
	    
	    @result.each do |line|

	                
	                line.each do |mairie, mail|
	                    csv.puts ("#{mairie},#{mail}")
	                end
	    end
	    End.new.message_fin
	end

	
end