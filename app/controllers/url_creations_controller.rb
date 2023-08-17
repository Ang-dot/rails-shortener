require 'open-uri'
require 'nokogiri'

class UrlCreationsController < ApplicationController
    before_action :require_user_signed_in!, only: [:create]
    after_action :get_geolocation, :update_num_clicks, only: [:redirect]

    def index
        @target_urls = TargetUrl.where(user_id: Current.user.id)
        @target_url = TargetUrl.new
        flash.now[:notice] = "No URLs shortened yet. Try it now!" if @target_urls.empty?
    end

    def new
        @target_url = TargetUrl.new
    end

    def create
        original_target_url = url_params[:target_url]
        sanitised_target_url = sanitize_target_url(original_target_url)

        @target_url = TargetUrl.find_or_initialize_by(user_id: Current.user.id, target_url: sanitised_target_url)
        @target_url.user_id = Current.user.id
        @target_url.title_tag = get_title_tag(sanitised_target_url)

        @target_url.target_url = original_target_url
        @slug = url_params[:slug]

        if @slug.present?
            handle_custom_slug
        else
            handle_default_slug
        end

    rescue ActiveRecord::RecordInvalid => e
        @target_url.errors.add(:target_url, e.message)
        render :new
    end

    def redirect
        @short_url = ShortUrl.find_by(short_path: params[:short_path])

        if @short_url.present?
            @target_url = TargetUrl.find_by(id: @short_url.target_url_id)
            redirect_to @target_url.target_url, allow_other_host: true
        else
            render 'main/error'
        end
    end

    def show
        @short_url = ShortUrl.find_by(short_path: params[:id])
    end

    private

    def sanitize_target_url(url)
        url.start_with?("http://") || url.start_with?("https://") ? url : "http://#{url}"
    end

    def handle_custom_slug
        if !valid_short_path?(@slug)
            flash[:danger] = "Invalid custom slug. Only alphanumeric characters are allowed and it must be within 6 to 15 characters."
            redirect_to new_url_creation_path(target_url: @target_url.target_url, slug: @slug)
        elsif duplicate_short_path_exists?(@slug)
            flash[:danger] = "A shortened URL with the same custom slug is taken. Please try again."
            redirect_to new_url_creation_path(target_url: @target_url.target_url, slug: @slug)
        else
            save_target_and_short_url
        end
    end

    def handle_default_slug
        save_target_and_short_url
    end

    def save_target_and_short_url
        if @target_url.save
            @short_url = @target_url.short_urls.build(short_path: @slug || generate_random_short_path)
            if @short_url.valid?
                @short_url.save
                redirect_to url_creations_path, notice: "Your URL has been shortened!"
            else
                @target_url.errors.add(:base, "There was an error while creating the short URL. Please try again.")
                render :new
            end
        else
            @target_url.errors.add(:base, "There was an error while creating the short URL. Please try again.")
            render :new
        end
    end

    def valid_short_path?(short_path)
        short_path.match?(/\A[a-zA-Z0-9]{6,15}\z/)
    end

    def duplicate_short_path_exists?(short_path)
        ShortUrl.exists?(short_path: short_path)
    end

    def generate_random_short_path
        loop do
            short_path = SecureRandom.hex(3)
            return short_path unless duplicate_short_path_exists?(short_path)
        end
    end

    def update_num_clicks
        @short_url&.increment!(:num_clicks)
    end

    def get_geolocation
        if @short_url.present?
            city, country = get_city_and_country
            @short_url.geolocation.create(city: city, country: country)
        end
    end

    def get_city_and_country
        if request.local?
            ['Local Host', 'Local Host']
        else
            [request.location.city, request.location.country]
        end
    end

    def get_title_tag(url)
        Nokogiri::HTML(URI.open(url)).at_css("title")&.text || "(No title found)"
    rescue StandardError
        "(No title found)"
    end

    def url_params
        params.require(:target_url).permit(:target_url, :slug)
    end
end
