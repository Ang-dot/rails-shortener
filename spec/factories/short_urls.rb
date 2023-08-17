FactoryBot.define do
    factory :short_url do

        sequence(:short_path) { |n| "short#{n}"}
        num_clicks { 0 }
        target_url
    end
end