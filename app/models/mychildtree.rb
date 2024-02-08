class Mychildtree < ActiveRecord::Base
  include Enumerable

  def self.columns
    @columns ||= []
  end

  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end

  attr_accessor :content, :name, :parent

  def parent=(parent)
    @parent = parent
  end

  def parentage
    parentageArray = []
    prevParent = self.parent
    while prevParent
      parentageArray << prevParent
      @parentsproject = Project.find(prevParent)
      if @parentsproject != nil
        prevParent = @parentsproject.parent_id
      else
        prevParent = nil
      end
    end
    parentageArray
  end
end

