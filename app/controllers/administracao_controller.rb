class AdministracaoController < ApplicationController
    
    def login
      session[:usuario_id] = nil
      if request.post?
        usuario = Usuario.authenticate(params[:nome], params[:password])
        if usuario
          session[:usuario_id] = usuario.id
          uri = session[:original_uri]
          session[:original_uri] = nil
          redirect_to( uri || { :action => "index" })
        else
          flash.now[:notice] = "Usuário e/ou senha inválidos!"
        end
      end
    end

    def logout
      session[:usuario_id] = nil
      flash[:notice] = "Desconectado"
      redirect_to(:action => "login")
    end


    def index
    end

  end
