module NavigationHelper

  def menu_items
    return [] unless user_signed_in?
    items = Array.new

    add_item items, :locations
    add_item items, :users

    items
  end

private

  def add_item items, key, text = key.to_s, path = key
    items << { text: text, path: path, current: params[:controller].include?(key.to_s) }
  end

end