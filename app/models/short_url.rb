class ShortUrl < ApplicationRecord

    validates :short_path, 
        presence: true, 
        uniqueness: true,
        length: { minimum: 6 }

    validates :num_clicks, 
        presence: true, 
        numericality: { greater_than_or_equal_to: 0 }

    belongs_to :target_url

    has_many :geolocation

end
