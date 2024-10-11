# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_10_10_132650) do
  create_table "authentications", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "provider", null: false
    t.string "uid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authentications_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_authentications_on_user_id"
  end

  create_table "comments", charset: "utf8mb4", force: :cascade do |t|
    t.text "content", null: false
    t.bigint "user_id", null: false
    t.bigint "video_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_comments_on_user_id"
    t.index ["video_id"], name: "index_comments_on_video_id"
  end

  create_table "likes", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "video_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_likes_on_user_id"
    t.index ["video_id"], name: "index_likes_on_video_id"
  end

  create_table "ramen_shops", charset: "utf8mb4", force: :cascade do |t|
    t.string "place_id", null: false
    t.string "name"
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.string "phone_number"
    t.text "opening_hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  create_table "video_tags", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "video_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_video_tags_on_tag_id"
    t.index ["video_id"], name: "index_video_tags_on_video_id"
  end

  create_table "videos", charset: "utf8mb4", force: :cascade do |t|
    t.string "menu_name"
    t.integer "price"
    t.string "file"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ramen_shop_id"
    t.text "comment"
    t.string "place_id"
    t.index ["ramen_shop_id"], name: "fk_rails_0a063615c2"
    t.index ["user_id"], name: "index_videos_on_user_id"
  end

  add_foreign_key "authentications", "users"
  add_foreign_key "comments", "users"
  add_foreign_key "comments", "videos"
  add_foreign_key "likes", "users"
  add_foreign_key "likes", "videos"
  add_foreign_key "video_tags", "tags"
  add_foreign_key "video_tags", "videos"
  add_foreign_key "videos", "ramen_shops"
  add_foreign_key "videos", "users"
end
