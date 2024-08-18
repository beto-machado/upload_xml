class Document < ApplicationRecord
  has_one :xml_document
  has_one_attached :file

  validate :file_presence

  private

  def file_presence
    errors.add(:file, "can't be blank") if file.blank?
  end
end
