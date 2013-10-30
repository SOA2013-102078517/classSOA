class Movie < ActiveRecord::Base
  before_save :capitalize_title
  has_many :reviews 

  def capitalize_title
    self.title = self.title.split(/\s+/).map(&:downcase).
      map(&:capitalize).join(' ')
  end

  def self.all_ratings ; %w[G PG PG-13 R NC-17] ; 
  end #  shortcut: array of strings
  validates :title, :presence => true
  validates :release_date, :presence => true
  validate :released_1930_or_later # uses custom validator below
  validates :rating, :inclusion => {:in => Movie.all_ratings},
    :unless => :grandfathered?
  def released_1930_or_later
    errors.add(:release_date, 'must be 1930 or later') if
      self.release_date < Date.parse('1 Jan 1930')
  end
  @@grandfathered_date = Date.parse('1 Nov 1968')
  def grandfathered? ; self.release_date >= @@grandfathered_date ;
  end

  scope :with_good_reviews, lambda { |threshold|
    Movie.joins(:reviews).group(:movie_id).
      having(['AVG(reviews.potatoes) > ?', threshold])
  }
  scope :for_kids, lambda
  {
    Movie.where('rating in ?', %w(G PG))
  }
end

