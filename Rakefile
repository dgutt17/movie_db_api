# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
extend ImdbParser::StaticNodes
extend ImdbParser

Rails.application.load_tasks

namespace :import do
    task :create_static_nodes => :environment do 
        create_month_nodes
        create_day_nodes
        create_imdb_score_nodes
        create_year_nodes
    end

    task :create_movie_and_genre_nodes => :environment do
        File.open('/Users/dangutt/Desktop/imdb_data/title.basics.tsv') do |file|
            query_str = String.new
            file.each_with_index do |row, index|
                row = row.split("\t")
                content = content_check(row[1])
                if row[4] == '0' && index > 0 && row[5].to_i >= 1950
                    if content == 1
                        movie = ImdbParser::Movie.new(row)
                    # elsif content == 2
                    #     tv_content = TVContent.new(row)
                        query_str += movie.query_string
                        puts "Created #{row[2]} as a Movie Node"
                    end
                end
                puts "index: #{index}"
                break if index >= 300000
            end
            query_str += ';'
            puts "query_str: #{query_str}"
            $neo4j_session.query(query_str)
        end
    end

    task :create_indices => :environment do 
        create_indices
    end
end
