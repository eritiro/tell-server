module NavigationHelper

  def menu_items
    return [] unless user_signed_in?
    items = Array.new

    add_item items, Location
    add_item items, User

    items
  end

private

  def add_item items, klass, text = klass.to_s, path = klass
    if can? :index, klass
      key = klass.to_s.pluralize.downcase
      items << { text: text, path: path, current: params[:controller].include?(key.to_s) }
    end
  end

end