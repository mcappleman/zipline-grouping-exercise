require 'rspec'
require 'spec_helper'
require 'tempfile'
require_relative '../lib/person_grouper'

describe PersonGrouper do
  def write_temp_csv(data)
    file = Tempfile.new('csv')
    file.write(data)
    file.rewind
    file
  end

  let(:csv_data) do
    <<~CSV
      Name,Email1,Email2,Phone1,Phone2
      Alice,alice@example.com,,111 111-1111,
      A. Lee,,alice@example.com,,123 123-1234
      Bob,,bobby@example.com,+111-111-1111,
      Carol,carol@example.com,,222 222-2222,333-333-3333
    CSV
  end

  it 'groups records by email with multiple email columns' do
    file = write_temp_csv(csv_data)
    grouper = PersonGrouper.new(file.path, 'email')
    result = grouper.group_and_output
    _header, *rows = result
    id_map = rows.map { |row| [row[1], row[0]] }.to_h

    expect(id_map['Alice']).to eq(id_map['A. Lee'])
    expect(id_map['Alice']).not_to eq(id_map['Bob'])
    expect(id_map['Alice']).not_to eq(id_map['Carol'])
    expect(id_map['Bob']).not_to eq(id_map['Carol'])
  end

  it 'groups records by phone with multiple phone columns' do
    file = write_temp_csv(csv_data)
    grouper = PersonGrouper.new(file.path, 'phone')
    result = grouper.group_and_output
    _header, *rows = result
    id_map = rows.map { |row| [row[1], row[0]] }.to_h

    expect(id_map['Alice']).not_to eq(id_map['A. Lee'])
    expect(id_map['Alice']).to eq(id_map['Bob'])
    expect(id_map['Alice']).not_to eq(id_map['Carol'])
    expect(id_map['Bob']).not_to eq(id_map['Carol'])
  end

  it 'groups records by email_or_phone with multiple email/phone columns' do
    file = write_temp_csv(csv_data)
    grouper = PersonGrouper.new(file.path, 'email_or_phone')
    result = grouper.group_and_output

    _header, *rows = result
    id_map = rows.map { |row| [row[1], row[0]] }.to_h

    expect(id_map['Alice']).to eq(id_map['A. Lee'])
    expect(id_map['Alice']).to eq(id_map['Bob'])

    expect(id_map['Carol']).not_to eq(id_map['Alice'])

    file.close
    file.unlink
  end
end
