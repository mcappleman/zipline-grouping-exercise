require 'rspec'
require 'spec_helper'
require_relative '../lib/matcher'

describe Matcher do
  context 'get_keys' do
    let(:headers) { %w[Name Email1 Email2 Phone1 Phone2] }
    let(:row) do
      {
        'Name' => 'Alice',
        'Email1' => 'a.b@test.com',
        'Email2' => '',
        'Phone1' => '123-456-7890',
        'Phone2' => '987-654-3210'
      }
    end
    it 'returns email keys for email match type' do
      matcher = Matcher.new('email', headers)
      keys = matcher.get_keys(row)
      expect(keys).to eq(['a.b@test.com'])
    end

    it 'returns phone keys for phone match type' do
      matcher = Matcher.new('phone', headers)
      keys = matcher.get_keys(row)
      expect(keys).to eq(%w[1234567890 9876543210])
    end

    it 'returns both email and phone keys for email_or_phone match type' do
      matcher = Matcher.new('email_or_phone', headers)
      keys = matcher.get_keys(row)
      expect(keys).to eq(['a.b@test.com', '1234567890', '9876543210'])
    end

    it 'raises an error for invalid match type' do
      matcher = Matcher.new('invalid_type', headers)
      expect { matcher.get_keys(row) }.to raise_error(ArgumentError, 'Invalid match type: invalid_type')
    end

    it 'handles rows with missing or empty values' do
      row_with_missing_values = {
        'Name' => 'Bob',
        'Email1' => '',
        'Email2' => nil,
        'Phone1' => '555-555-5555',
        'Phone2' => nil
      }
      matcher = Matcher.new('email_or_phone', headers)
      keys = matcher.get_keys(row_with_missing_values)
      expect(keys).to eq(['5555555555'])
    end
  end
end
