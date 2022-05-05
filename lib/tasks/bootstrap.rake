# frozen_string_literal: true

namespace :app do
  desc 'Bootstraps application'
  task :bootstrap do
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:test:prepare'].invoke

    Rake::Task['db:seed'].invoke if Application.first.nil?
  end
end
