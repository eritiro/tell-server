module UsersHelper
  def send_system_notification(user, title, text)
    if user.device_token.present?
      GCM.send_notification user.device_token, {
        title: title,
        message: text,
        type: 'system'
      }
    end
  end
end
