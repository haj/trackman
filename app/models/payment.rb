# == Schema Information
#
# Table name: payments
#
#  id         :integer          not null, primary key
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Payment < ActiveRecord::Base
end
