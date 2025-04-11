require 'rspec'
require 'spec_helper'
require_relative '../lib/matcher'

describe Matcher do
  context 'when it has a single email column and single phone column' do
    let(:headers) { %w[FirstName LastName Email Phone Zip] }
    let(:row1) do
      {
        'Email' => 'test@example.com',
        'Phone' => '123-456-7890'
      }
    end

    let(:row2) do
      {
        'Email' => 'test2@example.com',
        'Phone' => '+1-123-456-7890'
      }
    end

    let(:row3) do
      {
        'Email' => 'test2@example.com',
        'Phone' => '123-456-7891'
      }
    end

    it 'matches by email' do
      matcher = Matcher.new('email', headers)
      expect(matcher.match?(row1, row2)).to be false
      expect(matcher.match?(row1, row3)).to be false
      expect(matcher.match?(row2, row3)).to be true
    end

    it 'matches by phone' do
      matcher = Matcher.new('phone', headers)
      expect(matcher.match?(row1, row2)).to be true
      expect(matcher.match?(row1, row3)).to be false
      expect(matcher.match?(row2, row3)).to be false
    end

    it 'matches by email_or_phone' do
      matcher = Matcher.new('email_or_phone', headers)
      expect(matcher.match?(row1, row2)).to be true
      expect(matcher.match?(row1, row3)).to be false
      expect(matcher.match?(row2, row3)).to be true
    end
  end

  context 'when it has multiple email and phone columns' do
    let(:headers) { %w[FirstName LastName Email1 Email2 Phone1 Phone2 Zip] }

    let(:row1) do
      {
        'Email1' => 'test@example.com',
        'Email2' => '',
        'Phone1' => '123-456-7890',
        'Phone2' => ''
      }
    end

    let(:row2) do
      {
        'Email1' => '',
        'Email2' => 'TEST@example.com',
        'Phone1' => '',
        'Phone2' => '(123) 456-7890'
      }
    end

    let(:row3) do
      {
        'Email1' => 'different@example.com',
        'Email2' => '',
        'Phone1' => '999-999-9999',
        'Phone2' => ''
      }
    end

    it 'matches by email using multiple email columns' do
      matcher = Matcher.new('email', headers)
      expect(matcher.match?(row1, row2)).to be true
      expect(matcher.match?(row1, row3)).to be false
      expect(matcher.match?(row2, row3)).to be false
    end

    it 'matches by phone using multiple phone columns' do
      matcher = Matcher.new('phone', headers)
      expect(matcher.match?(row1, row2)).to be true
      expect(matcher.match?(row1, row3)).to be false
      expect(matcher.match?(row2, row3)).to be false
    end

    it 'matches by email_or_phone using either' do
      matcher = Matcher.new('email_or_phone', headers)
      expect(matcher.match?(row1, row2)).to be true
      expect(matcher.match?(row1, row3)).to be false
      expect(matcher.match?(row2, row3)).to be false
    end
  end
end
