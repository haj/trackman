class XmlDestination < ActiveRecord::Base
  # INIT GEM
  acts_as_tenant(:company)

  # RELATIONSHIPS
  belongs_to :company
  has_many :orders, dependent: :nullify
  has_one :attachment, as: :attachable, dependent: :nullify

  # Nested Attr
  accepts_nested_attributes_for :attachment, allow_destroy: true, reject_if: :all_blank  
  accepts_nested_attributes_for :orders, allow_destroy: true, reject_if: :all_blank  

  # Attr Accessor
  attr_accessor :tmp_attachment_id  

  # Callback
  before_create :assign_attachment

  def assign_attachment
    self.build_attachment(tmp_attachment_id: tmp_attachment_id, description: 'order')
  end
end
