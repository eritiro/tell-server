module NavigationHelper

  def menu_items

    items = Array.new
    add_item items, :locations
    add_item items, :users

    items
  end

  def menu current
    @current_menu = current
  end

private

  def add_item items, key, text = key.to_s, path = key
    items << { text: text, path: path, current: params[:controller].include?(key.to_s) }
  end

end