class Item < ActiveRecord::Base
  attr_accessible :description, :discussion, :image, :name, :price
end
