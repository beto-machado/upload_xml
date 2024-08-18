FactoryBot.define do
  factory :document do
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/nota_fiscal.xml'), 'application/xml') }
  end
end
