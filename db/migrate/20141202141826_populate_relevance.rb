class PopulateRelevance < ActiveRecord::Migration
  def change
    Location.update_all("relevance = capacity")
  end
end
