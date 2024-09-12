class AddReferences < ActiveRecord::Migration[6.1]
  def change
    add_reference :labels, :user
  end
end
