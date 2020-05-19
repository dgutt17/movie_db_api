# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

namespace :import do
    task :batch_create => :environment do
        start_time = Time.now
        ImdbImporter.new.batch_create
        puts "Time to finish: #{Time.now - start_time}"
    end

    task :test => :environment do
        puts "Hello World"
    end
end
