require 'csv'
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
    @matcher = Matcher.new(@match_type, @headers)
    build_key_graph
    assign_person_ids
    write_output
  end

  private

  def load_rows
    csv = CSV.read(@file_path, headers: true)
    @headers = csv.headers
    @rows = csv.each_with_index.map { |row, index| [index, row.to_h] }
  end

  def build_key_graph
    @rows.map do |i, row|
      keys = @matcher.get_keys(row)
      keys.each do |key|
        @key_graph[key] ||= new_node
        keys.each do |other_key|
          next if key == other_key

          update_edges(key, other_key)
        end
      end
    end
  end

  def update_edges(key, other_key)
    @key_graph[key][:edges] << other_key unless @key_graph[key][:edges].include?(other_key)
    @key_graph[other_key] ||= new_node
    @key_graph[other_key][:edges] << key unless @key_graph[other_key][:edges].include?(key)
  end

  def new_node
    {
      edges: [],
      person_id: nil
    }
  end

  def assign_person_ids
    current_id = 0

    @key_graph.each_value do |node|
      next if node[:person_id]

      node[:person_id] = current_id
      node[:edges].each do |neighbor|
        next if @key_graph[neighbor][:person_id]

        update_edges_person_id(neighbor, current_id)
      end
      current_id += 1
    end
  end

  def write_output
    [['PersonId'] + @headers] + @rows.map do |i, row|
      keys = @matcher.get_keys(row)
      person_id = keys.map { |key| @key_graph[key][:person_id] }.compact.first
      [person_id] + row.values
    end
  end

  def update_edges_person_id(key, current_id)
    return if key.nil? || @key_graph[key][:person_id]

    @key_graph[key][:person_id] = current_id

    @key_graph[key][:edges].each do |neighbor|
      update_edges_person_id(neighbor, current_id)
    end
  end
end
