class Matcher
  def initialize(match_type, headers)
    @match_type = match_type
    @email_keys = headers.select { |header| header.downcase.include?('email') }
    @phone_keys = headers.select { |header| header.downcase.include?('phone') }
  end

  def get_keys(row)
    case @match_type
    when 'email'
      get_keys_by_type(row, @email_keys, 'email')
    when 'phone'
      get_keys_by_type(row, @phone_keys, 'phone')
    when 'email_or_phone'
      get_keys_by_type(row, @email_keys, 'email') + get_keys_by_type(row, @phone_keys, 'phone')
    else
      raise ArgumentError, "Invalid match type: #{@match_type}"
    end
  end

  private

  def get_keys_by_type(row, keys, type)
    return_keys = []
    keys.each do |key|
      value = row[key]
      next if value.nil? || value.strip.empty?

      return_keys << normalize_phone(value) if type == 'phone'
      return_keys << value.downcase.strip if type == 'email'
    end
    return_keys
  end

  def normalize_phone(phone)
    return nil if phone.nil? || phone.strip.empty?

    digits_only = phone.gsub(/\D/, '') # Remove non-digit characters
    if digits_only.length == 10
      digits_only
    elsif digits_only.length == 11 && digits_only.start_with?('1')
      digits_only[1..] # Remove leading '1'
    else
      nil # Invalid phone number format
    end
  end
end
