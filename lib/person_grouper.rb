require 'csv'
require 'pry'
require_relative './matcher'

class PersonGrouper
  def initialize(file_path, match_type)
    @file_path = file_path
    @match_type = match_type
    @rows = []
    @headers = []
    @key_graph = {}
  end

  def group_and_output
    load_rows
    build_key_graph
    binding.pry
  end

  private

  def load_rows
    csv = CSV.read(@file_path, headers: true)
    @headers = csv.headers
    @rows = csv.each_with_index.map { |row, index| [index, row.to_h] }
  end

  def build_key_graph
    matcher = Matcher.new(@match_type)

    @rows.each do |i, i_row|
      @rows.each do |j, j_row|
        next if i >= j

        next unless matcher.match?(i_row, j_row)

        @key_graph[i] ||= []
        @key_graph[i] << j
        @key_graph[j] ||= []
        @key_graph[j] << i
      end
    end
  end
end
