class Document < ApplicationRecord
  has_one :xml_document
  has_one_attached :file
end
