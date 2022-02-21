module PasswordValidator
  extend ActiveSupport::Concern

  MIN_CHARS, MAX_CHARS = 8, 20

  included do
    validates :password, presence: true
    validate :password_complexity
  end

  def password_complexity
    return unless password.present?

    change_count = add_delete_count + replace_count

    if change_count > 0
      errors.add(:base, I18n.t('user.errors.password.change_chars', count: change_count, name: name))
    end
  end

  # Detects consective repeating chars in a row and returns chars count required to remove it.
  # For exampe, in case of 'asdAAA123', it will return 1.
  def replace_count
    password.scan(/(.)\1\1/).length
  end

  def add_delete_count
    chars_count = password.length

    unless password =~ Regexp.new("^.{#{MIN_CHARS},#{MAX_CHARS}}$")
      change_count = [MIN_CHARS - chars_count, chars_count - MAX_CHARS].max
    end

    (change_count || 0) + required(:small) + required(:capital) + required(:digit)
  end

  # Returns if 1 if given char type is not present in password else returns 0
  def required(char_type)
    case char_type
    when :small
      !(password =~ /[a-z]/) && 1 || 0
    when :capital
      !(password =~ /[A-Z]/) && 1 || 0
    when :digit
      !(password =~ /\d/) && 1 || 0
    else
      0
    end
  end
end
