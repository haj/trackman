# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)
#  password               :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  company_id             :integer
#  invitation_token       :string(255)
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  invitations_count      :integer          default(0)
#  roles_mask             :integer
#  car_id                 :integer
#  first_name             :string(255)
#  last_name              :string(255)
#

# # == Schema Information
# #
# # Table name: users
# #
# #  id                     :integer          not null, primary key
# #  email                  :string(255)
# #  password               :string(255)
# #  created_at             :datetime
# #  updated_at             :datetime
# #  encrypted_password     :string(255)      default("")
# #  reset_password_token   :string(255)
# #  reset_password_sent_at :datetime
# #  remember_created_at    :datetime
# #  sign_in_count          :integer          default(0), not null
# #  current_sign_in_at     :datetime
# #  last_sign_in_at        :datetime
# #  current_sign_in_ip     :string(255)
# #  last_sign_in_ip        :string(255)
# #  company_id             :integer
# #  invitation_token       :string(255)
# #  invitation_created_at  :datetime
# #  invitation_sent_at     :datetime
# #  invitation_accepted_at :datetime
# #  invitation_limit       :integer
# #  invited_by_id          :integer
# #  invited_by_type        :string(255)
# #  invitations_count      :integer          default(0)
# #  roles_mask             :integer
# #  car_id                 :integer
# #  first_name             :string(255)
# #  last_name              :string(255)
# #

# require 'spec_helper'

# describe User do

#   before(:each) do
#     @attr = {
#       :email => "user@example.com",
#       :password => "changeme",
#       :password_confirmation => "changeme"
#     }
#   end

#   it "should create a new instance given a valid attribute" do
#     User.create!(@attr)
#   end

#   it "should require an email address" do
#     no_email_user = User.new(@attr.merge(:email => ""))
#     no_email_user.should_not be_valid
#   end

#   it "should accept valid email addresses" do
#     addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
#     addresses.each do |address|
#       valid_email_user = User.new(@attr.merge(:email => address))
#       valid_email_user.should be_valid
#     end
#   end

#   it "should reject duplicate email addresses" do
#     User.create!(@attr)
#     user_with_duplicate_email = User.new(@attr)
#     user_with_duplicate_email.should_not be_valid
#   end

#   it "should reject email addresses identical up to case" do
#     upcased_email = @attr[:email].upcase
#     User.create!(@attr.merge(:email => upcased_email))
#     user_with_duplicate_email = User.new(@attr)
#     user_with_duplicate_email.should_not be_valid
#   end

#   describe "passwords" do

#     before(:each) do
#       @user = User.new(@attr)
#     end

#     it "should have a password attribute" do
#       @user.should respond_to(:password)
#     end

#     it "should have a password confirmation attribute" do
#       @user.should respond_to(:password_confirmation)
#     end
#   end

#   describe "password validations" do

#     it "should require a password" do
#       User.new(@attr.merge(:password => "", :password_confirmation => "")).
#         should_not be_valid
#     end

#     it "should require a matching password confirmation" do
#       User.new(@attr.merge(:password_confirmation => "invalid")).
#         should_not be_valid
#     end

#     it "should reject short passwords" do
#       short = "a" * 5
#       hash = @attr.merge(:password => short, :password_confirmation => short)
#       User.new(hash).should_not be_valid
#     end

#   end

#   describe "password encryption" do

#     before(:each) do
#       @user = User.create!(@attr)
#     end

#     it "should have an encrypted password attribute" do
#       @user.should respond_to(:encrypted_password)
#     end

#     it "should set the encrypted password attribute" do
#       @user.encrypted_password.should_not be_blank
#     end

#   end

# end
