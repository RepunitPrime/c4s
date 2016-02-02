# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 201601197051563) do

  create_table "ad_comments", force: :cascade do |t|
    t.text     "comment_body"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "ad_comments", ["post_id"], name: "index_ad_comments_on_post_id"
  add_index "ad_comments", ["user_id"], name: "index_ad_comments_on_user_id"

  create_table "article_attachments", force: :cascade do |t|
    t.integer  "article_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "attach_file_file_name"
    t.string   "attach_file_content_type"
    t.integer  "attach_file_file_size"
    t.datetime "attach_file_updated_at"
  end

  add_index "article_attachments", ["article_id"], name: "index_article_attachments_on_article_id"

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.text     "text",           default: ""
    t.integer  "vote",           default: 0
    t.integer  "views",          default: 0
    t.integer  "count_comments", default: 0
    t.integer  "topic_id"
    t.integer  "user_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "Tags"
    t.string   "tags_search"
  end

  add_index "articles", ["topic_id"], name: "index_articles_on_topic_id"
  add_index "articles", ["user_id"], name: "index_articles_on_user_id"

  create_table "buy_sell_books", force: :cascade do |t|
    t.string   "title"
    t.string   "author"
    t.string   "edition"
    t.string   "detail"
    t.string   "attachment"
    t.string   "topic"
    t.boolean  "isDeleted"
    t.integer  "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_Size"
    t.datetime "image_update_at"
    t.float    "cost"
  end

  create_table "comments", force: :cascade do |t|
    t.text     "comment_body"
    t.integer  "user_id"
    t.integer  "article_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "post_id"
  end

  add_index "comments", ["article_id"], name: "index_comments_on_article_id"
  add_index "comments", ["post_id"], name: "index_comments_on_post_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "detail"
    t.string   "attachment"
    t.string   "topic"
    t.boolean  "isDeleted"
    t.integer  "user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "cost"
  end

  add_index "posts", ["user_id"], name: "index_posts_on_user_id"

  create_table "redactor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "redactor_assets", ["assetable_type", "assetable_id"], name: "idx_redactor_assetable"
  add_index "redactor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_redactor_assetable_type"

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.integer  "count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topics", force: :cascade do |t|
    t.string   "topic_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "username"
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "address"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "activation_digest"
    t.boolean  "activated"
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "profile_pic_file_name"
    t.string   "profile_pic_content_type"
    t.integer  "profile_pic_file_size"
    t.datetime "profile_pic_updated_at"
  end

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"

end
