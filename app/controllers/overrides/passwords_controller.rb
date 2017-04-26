#could not get crazy PUT/PATCH to work with devise out of box. LOL
#todo to check if PATCH works with devise next time
module Overrides
  class PasswordsController < DeviseTokenAuth::PasswordsController
    before_filter :check_patch_method, :only => :create

    alias :super_create :create

    def check_patch_method
      if params[:_method] == 'patch'
        #PATCH method => override POST =>update password
        params[:password] = params[:user][:password]
        params[:password_confirmation] = params[:user][:password_confirmation]

        #before_filter from parent
        set_user_by_token

        update

        @patch_method_used = true
      end
    end

    #override super_create if patch is used
    def create
      if @patch_method_used.nil?
        super_create
      else
        @patch_method_used = nil
      end
    end

  end
end
