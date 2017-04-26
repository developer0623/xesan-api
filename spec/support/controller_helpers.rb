module ControllerHelpers
  def login_with(user = double('user'), scope = :member)
    current_member = "current_#{scope}".to_sym
    current_user = :current_user
    if user.nil?
      allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => scope})
      allow(controller).to receive(current_member).and_return(nil)
      allow(controller).to receive(current_user).and_return(nil)
    else
      allow(request.env['warden']).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(current_member).and_return(user)
      allow(controller).to receive(current_user).and_return(user)
    end
  end
end
