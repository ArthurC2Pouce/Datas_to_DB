require_relative '../app/scrapper'

class Index

   
    def initialize
        save(choix)
    end



    def choix
        puts "=============================================================="
        puts "  *  Choisissez comment vous voulez sauvegarder vos données  *"  
        puts "=============================================================="
        puts "                 * 3 formats disponibles *                    "
        puts "=============================================================="
        puts " > 1 - format JSON"
        puts " > 2 - format Google Spreadsheet"
        puts " > 3 - format CSV"
        puts "=============================================================="
        print "> "
       return choice = gets.chomp.to_i
     end




    def save(choice)


    mairie=Scrapper.new


    puts  mairie.get_townhall_urls

            
            case choice

            when 1
                mairie.save_as_JSON
                
            when 2
                mairie.save_as_spreadsheet
               
            when 3
                mairie.save_as_csv
                
            end

        
    end



end