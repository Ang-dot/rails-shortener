require 'rails_helper'

RSpec.describe TargetUrl, type: :model do
  describe "validations" do
    it "is valid with a valid target_url" do
      target_url = build(:target_url)
      expect(target_url).to be_valid
    end

    it "is invalid without a target_url" do
      target_url = build(:target_url, target_url: nil)
      target_url.valid?
      expect(target_url.errors[:target_url]).to include("can't be blank")
    end

    it "is invalid with an invalid target_url" do
      target_url = build(:target_url, target_url: "example-without-dot-whatever")
      target_url.valid?
      expect(target_url.errors[:target_url]).to include("must be a valid URL")
    end

    it "gets a non-null title tag" do
      target_url = build(:target_url, target_url: "http://coingecko.com")

      # do no test Controller method in model testing
      # controller tests are separate, check spec/controllers/portfolios_controller_spec.rb
      controller = UrlCreationsController.new
      title_tag = controller.send(:get_title_tag, target_url.target_url)
      expect(title_tag).not_to be_nil
    end

  end
end
