class Matcher
  def initialize(match_type, headers)
    @match_type = match_type
    @email_keys = headers.select { |header| header.downcase.include?('email') }
    @phone_keys = headers.select { |header| header.downcase.include?('phone') }
  end

  def match?(row1, row2)
    case @match_type
    when 'email'
      match_email(row1, row2)
    when 'phone'
      match_phone(row1, row2)
    when 'email_or_phone'
      match_email_or_phone(row1, row2)
    else
      raise ArgumentError, "Invalid match type: #{@match_type}"
    end
  end

  private

  def match_email(row1, row2)
    @email_keys.any? do |key1|
      @email_keys.any? do |key2|
        value1 = row1[key1]&.downcase&.strip
        value2 = row2[key2]&.downcase&.strip
        value1 == value2 && !value1.nil? && !value2.nil? && value1 != '' && value2 != ''
      end
    end
  end

  def match_phone(row1, row2)
    @phone_keys.any? do |key1|
      @phone_keys.any? do |key2|
        value1 = normalize_phone(row1[key1])
        value2 = normalize_phone(row2[key2])
        value1 == value2 && !value1.nil? && !value2.nil? && value1 != '' && value2 != ''
      end
    end
  end

  def match_email_or_phone(row1, row2)
    match_email(row1, row2) || match_phone(row1, row2)
  end

  def normalize_phone(phone)
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
