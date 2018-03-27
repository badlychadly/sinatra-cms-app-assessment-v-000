class Idea < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  validates_presence_of :content
  validates :content, length: { minimum: 6 }, uniqueness: { case_sensitive: false }
  validates :category, presence: true, on: [ :create, :update ],
    unless: Proc.new { |c| Idea.exists?(c.id) }




end
