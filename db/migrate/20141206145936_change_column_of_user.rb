class ChangeColumnOfUser < ActiveRecord::Migration
  def change
    rename_column :users, :auth_token, :auth_token_digest
  end
end
