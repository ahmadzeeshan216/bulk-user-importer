ActiveRecord::Schema.define(version: 2022_02_21_132539) do

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "password", null: false
  end

end
