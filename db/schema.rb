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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120721154054) do

  create_table "assignments", :force => true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",   :default => 0
    t.string   "commentable_type", :default => ""
    t.string   "title",            :default => ""
    t.text     "body",             :default => ""
    t.string   "subject",          :default => ""
    t.integer  "user_id",          :default => 0,  :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "course_registrations", :force => true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",  :default => true
  end

  create_table "course_teaching_assignments", :force => true do |t|
    t.integer  "course_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",  :default => true
  end

  create_table "courses", :force => true do |t|
    t.string   "name"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",         :default => true
    t.integer  "term_id"
    t.string   "registration_code"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "enrollments", :force => true do |t|
    t.integer  "school_id"
    t.integer  "user_id"
    t.string   "enrollment_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "failed_registrations", :force => true do |t|
    t.string   "email"
    t.string   "nim"
    t.string   "name"
    t.string   "subject_name"
    t.string   "course_name"
    t.integer  "school_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "reason"
  end

  create_table "group_memberships", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.integer  "course_id"
    t.integer  "group_leader_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pictures", :force => true do |t|
    t.string   "name"
    t.integer  "revision_id"
    t.integer  "project_submission_id"
    t.string   "original_image_url"
    t.string   "index_image_url"
    t.string   "revision_image_url"
    t.string   "display_image_url"
    t.integer  "original_image_size"
    t.integer  "index_image_size"
    t.integer  "revision_image_size"
    t.integer  "display_image_size"
    t.boolean  "is_deleted",            :default => false
    t.boolean  "is_selected",           :default => false
    t.boolean  "is_original",           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_approved"
    t.integer  "approved_revision_id"
    t.integer  "original_id"
    t.integer  "score",                 :default => 0
    t.string   "doc_id"
    t.string   "doc_access_key"
    t.integer  "picture_filetype",      :default => 1
    t.boolean  "conversion_status",     :default => false
    t.boolean  "is_graded",             :default => false
  end

  create_table "polled_deliveries", :force => true do |t|
    t.boolean  "is_delivered",                 :default => false
    t.string   "recipient_email"
    t.integer  "user_activity_id"
    t.time     "notification_raised_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "notification_raised_datetime"
  end

  create_table "positional_comments", :force => true do |t|
    t.integer  "comment_id"
    t.integer  "x_start"
    t.integer  "y_start"
    t.integer  "x_end"
    t.integer  "y_end"
    t.integer  "picture_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_submissions", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.boolean  "is_approved"
    t.integer  "approved_submission_id"
    t.datetime "approval_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "first_submission_time"
    t.integer  "total_original_submission", :default => 0
    t.integer  "total_picture_submission",  :default => 0
    t.integer  "score"
  end

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "is_group_project",  :default => false
    t.integer  "course_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",         :default => true
    t.datetime "deadline_datetime"
    t.integer  "total_submission"
    t.datetime "starting_datetime"
    t.boolean  "publish_grade",     :default => false
    t.integer  "term_id"
  end

  create_table "revisionships", :force => true do |t|
    t.integer  "picture_id"
    t.integer  "revision_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schools", :force => true do |t|
    t.string   "name"
    t.string   "billing_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "time_zone",                :default => "UTC"
    t.integer  "utc_offset"
    t.integer  "delivery_method",          :default => 1
    t.string   "scheduled_delivery_hours", :default => ""
  end

  create_table "score_revisions", :force => true do |t|
    t.integer  "picture_id"
    t.integer  "old_score"
    t.integer  "new_score"
    t.integer  "score_reviser_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subject_registrations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",  :default => true
  end

  create_table "subject_teaching_assignments", :force => true do |t|
    t.integer  "subject_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",  :default => true
  end

  create_table "subjects", :force => true do |t|
    t.integer  "school_id"
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.boolean  "is_closed",     :default => false
    t.date     "starting_date"
    t.date     "ending_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",     :default => true
    t.integer  "term_id"
  end

  create_table "terms", :force => true do |t|
    t.integer  "school_id"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_active",   :default => true
  end

  create_table "user_activities", :force => true do |t|
    t.string   "subject_type"
    t.string   "actor_type"
    t.string   "secondary_subject_type"
    t.integer  "subject_id"
    t.integer  "actor_id"
    t.integer  "secondary_subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_notification_sent",   :default => false
    t.integer  "event_type"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "username",               :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nim"
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
