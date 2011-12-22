module SessionsHelper
  
  def sign_in(user)
    # set the cookie
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    # set the current user
    self.current_user = user
  end
  
  # Sets an instance variable equal to user.  Basically a setter.
  def current_user=(user)
    @current_user = user
  end
  
  # getter
  def current_user
    # could be written as @current_user = @current_user || user_from_remember_token
    @current_user ||= user_from_remember_token
  end
  
  def signed_in?
    !self.current_user.nil?
  end
  
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  private
    
    def clear_return_to
      session[:return_to] = nil
    end  
    
    def store_location
      session[:return_to] = request.fullpath
    end    
  
    def user_from_remember_token
      # '*' unwrapps [user.id, user.salt] and passes to args
      User.authenticate_with_salt(*remember_token)
    end  
    
    def remember_token
      # .signed is new in Rails 3.  Or return two element array to match :remeber_token.
      cookies.signed[:remember_token] || [nil, nil]
    end
  
end
