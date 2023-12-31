class RegistrationsController < ApplicationController
    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)

        if @user.save
            sign_in_user(@user)
        else
            render :new
        end
    end

    private

    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
    end

    def sign_in_user(user)
        session[:user_id] = user.id
        redirect_to root_path, notice: "You have successfully signed up!"
    end
end
