class RetrospectiveSession < ApplicationRecord
  before_validation :generate_uuid, on: :create

  validates :uuid, presence: true, uniqueness: true

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid if uuid.blank?
  end
end
