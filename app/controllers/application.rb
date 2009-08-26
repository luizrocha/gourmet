# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :autorizacao, :except => :login
  helper :all # include all helpers, all the time
  layout "gourmet"

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => '112cbd50a752c97cfb0a9dcd85ea64da'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  protected
  def autorizacao
    unless Usuario.find_by_id(session[:usuario_id])
      session[:original_uri] = request.request_uri
      flash[:notice] = "Por favor, identifique-se. Sistema restrito!"
      redirect_to :controller => 'administracao' , :action => 'login'
    end
  end

end
