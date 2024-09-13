require 'capybara/rspec'
require 'selenium-webdriver'

# カスタムドライバーの定義
Capybara.register_driver :selenium_chrome_headless do |app|
  url = ENV["SELENIUM_DRIVER_URL"]
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('no-sandbox')
  options.add_argument('headless')
  options.add_argument('disable-gpu')
  options.add_argument('disable-dev-shm-usage')
  options.add_argument('remote-debugging-port=9222')
  options.add_argument('window-size=950, 800')

  Capybara::Selenium::Driver.new(app,
                                 browser: :remote,
                                 url: url,
                                 capabilities: options)
end

# System Specの設定
RSpec.configure do |config|
  # System Specのテスト実行前に実行される共通定義（jsフラグが未指定の場合）
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  # System Specのテスト実行前に実行される共通定義（jsフラグをtrueとする場合）
  config.before(:each, type: :system, js: true) do
    # 定義したカスタムドライバーを使用する
    driven_by :selenium_chrome_headless
    Capybara.server_host = '0.0.0.0'
    Capybara.server_port = 3001
    Capybara.app_host = 'http://web:3000' # webサービスを使用する
  end

  Capybara.default_max_wait_time = 5
end
