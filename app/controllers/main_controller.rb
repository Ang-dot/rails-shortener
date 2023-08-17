class MainController < ApplicationController
    def index
        if Current.user
            redirect_to url_creations_path
        else
            @target_url = TargetUrl.new
        end
    end

    def error
    end
end