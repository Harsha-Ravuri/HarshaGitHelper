#Note: This code wouldn't work if there's more than 100 repos. Pagination IS NOT taken care of. 

#beginning = Time.now
require 'octokit'

# note: !!! DO NOT EVER USE HARD-CODED VALUES 
ACC_TOK = '4bb4fb8c683235929fa81819bf544f85e657ce1d'
client = Octokit::Client.new :access_token => ACC_TOK

results = client.repos("harsha-ravuri", per_page: 100, page: 1) #just to get the pages
total_count = results.length

total_count = 0

output = File.open( "HARSHA_Git_Repo_List.txt","w" )

results.each do |repo|
    output << "Git repo full name: " +repo.full_name+ "\n"
    #output << repo.contents_url + "\n"
    url_path = repo.contents_url.chomp("/{+path}").to_s
    url_path = url_path + "?&access_token=" + ACC_TOK

    url_path_languages = repo.languages_url.to_s + "?&access_token=" + ACC_TOK


    output << "url path = #{url_path}" + "\n"

    response_contents = Faraday.get(url_path)
    jsonextracted_contents = JSON.parse(response_contents.body)

    response_lang = Faraday.get(url_path_languages)
    jsonextracted_lang = JSON.parse(response_lang.body)
    
    if jsonextracted_contents.to_s.include? "This repository is empty."
        output << "Empty repo" + "\n"
    else
        output << "Files: "
        contents_string = ""
        jsonextracted_contents.each do |jsonSubblock|
            contents_string = contents_string + "#{jsonSubblock["name"]}" + " , "
        end
        contents_string =  contents_string + "\n"

        output << contents_string

        output << "Languages: "
        lang_string =  ""

        jsonextracted_lang.each do |jsonSubblock|
            lang_string = lang_string + "#{jsonSubblock[0]}" + " , "
        end
        lang_string = lang_string + "\n"

        output << lang_string

    end
end

=begin

#Code that takes care of pagination(some fixes needed)
for i in (1..number_of_pages.to_i)
    results = client.repos("harsha-ravuri", per_page: 100, page: i)
    total_count = total_count + results.length
    results.each do |repo|
        output << "Git repo full name: " +repo.full_name+ "\n"
        #output << repo.contents_url + "\n"
        url_path = repo.contents_url.chomp("/{+path}").to_s
        url_path = url_path + "?&access_token=" + ACC_TOK

        url_path_languages = repo.languages_url.to_s + "?&access_token=" + ACC_TOK


        output << "url path = #{url_path}" + "\n"

        response_contents = Faraday.get(url_path)
        jsonextracted_contents = JSON.parse(response_contents.body)

        response_lang = Faraday.get(url_path_languages)
        jsonextracted_lang = JSON.parse(response_lang.body)
        
        if jsonextracted_contents.to_s.include? "This repository is empty."
            output << "Empty repo" + "\n"
        else
            output << "Files: "
            contents_string = ""
            jsonextracted_contents.each do |jsonSubblock|
                contents_string = contents_string + "#{jsonSubblock["name"]}" + " , "
            end
            contents_string =  contents_string + "\n"

            output << contents_string

            output << "Languages: "
            lang_string =  ""

            jsonextracted_lang.each do |jsonSubblock|
                lang_string = lang_string + "#{jsonSubblock[0]}" + " , "
            end
            lang_string = lang_string + "\n"

            output << lang_string

        end
    end
end
puts "total: #{total_count}"
output.close

puts "Time elapsed: #{Time.now - beginning} seconds."

=end
