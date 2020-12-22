class AddAcceptedStateToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :accepted, :boolean, default: false
  end
end
