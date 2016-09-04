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
  after_create :create_order

  def assign_attachment
    self.build_attachment(tmp_attachment_id: tmp_attachment_id, description: 'order')
  end

  def create_order
    file = File.open("public/#{attachment.tmp_attachment.file_url}")
    xml  = Nokogiri::XML(file)

    xml.children.children.map do |c|
      if c.class.to_s != "Nokogiri::XML::Text"
        customer_name = c.children.children[0].text
        latitude      = c.children.children[1].text
        longitude     = c.children.children[2].text
        package       = c.children.children[3].text

        self.orders.create(
          customer_name: customer_name,
          latitude: latitude,
          longitude: longitude,
          package: package
        )
      end
    end
  end
end
