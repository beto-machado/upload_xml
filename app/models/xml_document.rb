class XmlDocument < ApplicationRecord
  belongs_to :document
  validates :document_id, uniqueness: true
end
