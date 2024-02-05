class WikiTemplatesg < ActiveRecord::Base
  unloadable

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  validates :text, presence: true
  validates :name, presence: true
end

