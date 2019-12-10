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

    task :create_movie_nodes => :environment do
        File.open('/Users/dangutt/Desktop/imdb_data/title.basics.tsv') do |file|
            query_str = String.new
            file.each_with_index do |row, index|
                row = row.split("\t")
                content = content_check(row[1])
                if row[4] == '0' && index > 0 && row[5].to_i >= 1950
                    if content == 1
                        movie = ImdbParser::Movie.new(row)
                        movie.save!
                    # elsif content == 2
                    #     tv_content = TVContent.new(row)
                        puts "Created #{row[2]} as a Movie Node"
                    end
                end
            end
        end
    end

    task :create_indices => :environment do 
        create_indices
    end

    task :create_genre_nodes => :environment do 
        File.open('/Users/dangutt/Desktop/imdb_data/title.basics.tsv') do |file|
            final_list = []
            file.each_with_index do |row, index|
                row = row.split("\t")
                genres = row.last.split(',')
                genres.each do |genre|
                    new_genre = genre.gsub(/[^0-9a-z ]/i, '')
                    if !final_list.include?(new_genre)
                        final_list << new_genre
                    end
                end
                puts "final_list.length: #{final_list.length}"
                break if final_list.length == 30
            end
            puts final_list.inspect
            ImdbParser::Genre.create(final_list)
        end
    end
end
