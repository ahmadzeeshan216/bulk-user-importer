module UsersHelper
  def pretty_creation_message(user)
    if user.errors.any?
      user.errors.full_messages.to_sentence
    else
      t('user.success.creation', name: user.name)
    end
  end
end
