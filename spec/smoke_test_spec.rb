require 'rails_helper'

RSpec.describe 'Smoke test' do
  it 'verifies RSpec is configured correctly' do
    expect(true).to be true
  end

  it 'verifies database cleaner is working' do
    expect(ActiveRecord::Base.connection.active?).to be true
  end

  it 'verifies faker is working' do
    expect(Faker::Name.name).to be_a(String)
  end

  it 'verifies factory_bot is working' do
    expect(FactoryBot).to be_a(Module)
  end
end
