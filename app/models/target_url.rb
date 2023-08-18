class TargetUrl < ApplicationRecord
    attr_accessor :slug

    # needs to be dependent, otherwise deleting target, will still
    # have dangling short_url
    has_many :short_urls, dependent: true

    validates :target_url, presence: true
    validate :valid_url_format
    after_validation :add_http_prefix, if: -> { errors.empty? }

    private
    def valid_url_format
        return unless target_url.present?

        valid_url_pattern = "^(?:http(s)?:\/\/)?[\\w\\.-]+(?:\\.[\\w\\.-]+)+[\\w\\-\\._~:/?#\\[\\]@!\$&'\\(\\)\\*+,;=.]+$"

        unless target_url.match?(Regexp.new(valid_url_pattern))
            errors.add(:target_url, "must be a valid URL")
        end
    end

    def add_http_prefix
        unless target_url.start_with?("http://") || target_url.start_with?("https://")
            self.target_url = "http://#{target_url}"
        end
    end
end
