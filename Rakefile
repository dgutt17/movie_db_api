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
        start_time = Time.now
        File.open('/Users/dangutt/Desktop/imdb_data/title.basics.tsv') do |file|
            movie_nodes = []
            movie_to_genre_rel = []
            movie_to_year_rel = []
            count = 0
            create_node_str = "UNWIND {list} as row CREATE (n:Movie) SET n+= row"
            create_rel_str = "UNWIND {list} as row MATCH (from:Movie {imdb_id: row.from}) MATCH (to:Genre {name: row.to}) CREATE (from)-[rel:CATEGORIZED_AS]->(to) SET rel += row"
            create_rel_str_2 = "UNWIND {list} as row MATCH (from:Movie {imdb_id: row.from}) MATCH (to:Year {value: row.to}) CREATE (from)-[rel:RELEASED]->(to) SET rel += row"
            logout_row = "UNWIND {list} as row return row"

            file.each_with_index do |row, index|
                row = row.split("\t")
                content = content_check(row[1])
                if row[4] == '0' && index > 0 && row[5].to_i >= 1950
                    if content == 1
                        count += 1
                        movie = ImdbParser::Movie.new(row)
                        movie_nodes << movie.node
                        movie_to_genre_rel << movie.create_genre_relationship
                        movie_to_year_rel << movie.create_year_relationship
                    # elsif content == 2
                    #     tv_content = TVContent.new(row)
                        puts "Created #{row[2]} as a Movie Node"
                    end
                end
                if count == 50000
                    count = 0
                    puts "unwinding.............................................."
                    $neo4j_session.query(create_node_str, list: movie_nodes)
                    $neo4j_session.query(create_rel_str, list: movie_to_genre_rel.flatten)
                    $neo4j_session.query(create_rel_str_2, list: movie_to_year_rel)
                    movie_nodes = []
                    movie_to_genre_rel = []
                    movie_to_year_rel = []
                    puts "done..................................................."
                end
            end
            if movie_nodes.length > 0 
                puts "unwinding.............................................."
                $neo4j_session.query(create_node_str, list: movie_nodes)
                $neo4j_session.query(create_rel_str, list: movie_to_genre_rel.flatten!, label: 'CATEGORIZED_AS')
                $neo4j_session.query(create_rel_str, list: movie_to_year_rel, label: 'RELEASED')
                puts "done..................................................."
            end
        end
        puts "Time to finish: #{Time.now - start_time}"
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
