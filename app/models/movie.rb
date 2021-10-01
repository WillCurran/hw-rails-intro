class Movie < ActiveRecord::Base
    def self.all_ratings
        self.all.map { |m| m.rating }.to_set
    end
    
    def self.with_ratings ratings
        self.all.where(rating: ratings)
    end
end