class SessionsController < ApplicationController
    def new
    end

    def create
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
            sign_in_user(user)
        else
            flash[:danger] = "Email or password is invalid. Please try again."
            render :new
        end
    end

    def destroy
        sign_out_user
        redirect_to root_path, notice: "You have successfully logged out!"
    end

    private

    def sign_in_user(user)
        session[:user_id] = user.id
        redirect_to root_path, notice: "You have successfully signed in!"
    end

    def sign_out_user
        session[:user_id] = nil
    end
end
