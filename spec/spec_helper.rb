ENV["RAILS_ENV"] = 'test'

require 'coveralls'
Coveralls.wear!

require File.expand_path("../../config/environment", __FILE__)

require 'rspec/rails'
require 'capybara/rspec'
require 'elasticsearch/extensions/test/cluster'
require 'sidekiq/testing'

ActiveRecord::Migration.maintain_test_schema!

Elasticsearch::Model.client = Elasticsearch::Client.new(host: "localhost:9250") unless ENV["CI"]

redis_url = "redis://localhost:6380"
Sidekiq.configure_client do |config|
  config.redis = {url: redis_url, namespace: "seirenes_sidekiq"}
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.infer_spec_type_from_file_location!

  # If you use database_cleaner, comment out following line.
  config.before(:suite) do
    DatabaseRewinder.strategy = :transaction
    DatabaseRewinder.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseRewinder.start
  end

  config.after(:each) do
    DatabaseRewinder.clean
  end

  # for Delorean
  config.include Delorean

  config.include FactoryGirl::Syntax::Methods

  # for poltergeist
  require "capybara/poltergeist"
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome, switches: %w(--no-sandbox))
  end
  Capybara.javascript_driver = :chrome

  config.before(:suite) do
    system(Rails.root.join("node_modules", ".bin", "gulp").to_s)
  end

  config.before(:each, elasticsearch: true) do
    unless ENV["CI"]
      unless Elasticsearch::Extensions::Test::Cluster.running?(on: 9250)
        Elasticsearch::Extensions::Test::Cluster.start port: 9250, nodes: 1
      end
    end

    Pasokara.__elasticsearch__.create_index! force: true
    Pasokara.__elasticsearch__.refresh_index!
    Elasticsearch::Model.client.indices.flush
  end

  at_exit do
    if Elasticsearch::Extensions::Test::Cluster.running?(on: 9250)
      Elasticsearch::Extensions::Test::Cluster.stop port: 9250
    end
  end

  config.before(:each, redis: true) do
    unless $redis_pid
      $redis_pid = spawn_process(
        command: "redis-server #{Rails.root.join('spec', 'redis_test.conf')}",
        spawn_checker: -> { sleep 0.2; true },
      )
    end
    Redis.new(url: redis_url).flushall
  end

  config.before(:each, sidekiq: true) do
    Sidekiq::Testing.disable!

    unless $sidekiq_pid
      log = Rails.root.join('log', 'sidekiq_test.log').to_s
      $redis_pid = spawn_process(
        command: "bundle exec sidekiq -q seirenes -c 1",
        env: {"REDIS_PORT" => "6380"},
        stdout_log: log,
        spawn_checker: -> { File.read(log) =~ /Starting processing/ },
      )
    end
  end

  config.after(:each, sidekiq: true) do
    Sidekiq::Testing.fake!
  end
end
