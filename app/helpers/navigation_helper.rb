module NavigationHelper

  def menu_items
    return [] unless user_signed_in?
    items = Array.new

    add_item items, :metric, Event
    add_item items, :location
    add_item items, :user
    add_item items, :version
    add_item items, :notification

    items
  end

private

  def add_item items, key, klass = key.to_s.camelize.constantize
    if can? :index, klass
      plural = key.to_s.pluralize
      items << { text: plural.camelize, path: "/#{plural}", current: params[:controller] == plural.to_s }
    end
  end

end