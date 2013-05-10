class Task < ActiveRecord::Base
  belongs_to :user

  attr_accessible :title

  validates_presence_of :title

  default_scope order('completed ASC, created_at DESC')

  def open!
    update_column(:completed, false)
  end

  def complete!
    update_column(:completed, true)
  end
end