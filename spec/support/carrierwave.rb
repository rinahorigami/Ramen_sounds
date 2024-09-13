RSpec.configure do |config|
  config.before(:suite) do
    CarrierWave.configure do |carrierwave_config|
      carrierwave_config.storage = :file
      carrierwave_config.enable_processing = false
    end
  end

  config.after(:suite) do
    FileUtils.rm_rf(Dir["#{Rails.root}/spec/support/uploads"])
  end
end