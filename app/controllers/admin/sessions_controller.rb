class Admin::SessionsController < ApplicationController
    skip_before_action :require_login, only: %i[new create]
    layout "admin"

    def new; end

    def create
        @user = login(params[:email], params[:password], params[:role])

        if @user
            flash[:notice] = t('flash.admin.sessions.login_success')
            redirect_to admin_root_path
        else
            flash[:error] = t('flash.admin.sessions.login_failure')
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        logout
        flash[:notice] = t('flash.sessions.logout')
        redirect_to admin_login_path, status: :see_other
    end
end
