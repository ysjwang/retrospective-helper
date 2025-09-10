class RetrospectiveItem < ApplicationRecord
  belongs_to :retrospective_session

  enum :category, [:continue, :start, :stop, :misc]

  validates :category, presence: true, inclusion: { in: categories.keys }
  validates :name, length: { maximum: 255 }, allow_blank: true
  validates :comments, length: { maximum: 1000 }, allow_blank: true
  validates :due_date, presence: false # Optional date field
end
