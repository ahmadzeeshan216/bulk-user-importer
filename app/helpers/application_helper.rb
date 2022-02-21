module ApplicationHelper
  def flash_message_classes(type)
    case type.to_sym
    when :error
      'alert alert-danger'
    when :notice
      'alert alert-info'
    else
      ''
    end
  end
end
