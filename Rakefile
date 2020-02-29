# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'
require 'redis'
# extend ImdbImporter::StaticNodes
# extend ImdbImporter

Rails.application.load_tasks

namespace :import do
    task :batch_create => :environment do
        start_time = Time.now
        ImdbImporter.new.batch_create
        puts "Time to finish: #{Time.now - start_time}"
    end

    task :test => :environment do
        redis = Redis.new

        test_obj = {
        a: {
        name: 1,
        address: 'World'
        },
        b: {
            name: 'Test2',
            address: 'Test2'
        }
        }

        redis.set('foo', test_obj.to_json)

        puts "redis get: #{JSON.parse(redis.get('foo'))}"
    end
end

