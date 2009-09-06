class UsuariosController < ApplicationController

    def index
      @usuarios = Usuario.find(:all, :order => :nome)

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @usuarios }
      end
    end

    def show
      @usuario = Usuario.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @usuario }
      end
    end

    def new
      @usuario = Usuario.new

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @usuario }
      end
    end

    def edit
      @usuario = Usuario.find(params[:id])
    end

    def create
      @usuario = Usuario.new(params[:usuario])

      respond_to do |format|
        if @usuario.save
          flash[:notice] = "Usuario #{@usuario.nome} foi criado com sucesso."
          format.html { redirect_to(:action=>'index') }
          format.xml  { render :xml => @usuario, :status => :created, :location => @usuario }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @usuario.errors, :status => :unprocessable_entity }
        end
      end
    end

    def update
      @usuario = Usuario.find(params[:id])
      
      respond_to do |format|
        if @usuario.update_attributes(params[:usuario])
          flash[:notice] = "Usuario #{@usuario.nome} foi atualizado com sucesso."
          format.html { redirect_to(:action=>'index') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @usuario.errors, :status => :unprocessable_entity }
        end
      end
    end

    def destroy
      @usuario = Usuario.find(params[:id])
      begin
        flash[:notice] = "User #{@user.name} deleted"
        @usuario.destroy
      rescue Exception => e
        flash[:notice] = e.message
      end

      respond_to do |format|
        format.html { redirect_to(usuarios_url) }
        format.xml  { head :ok }
      end
    end
    
end  
