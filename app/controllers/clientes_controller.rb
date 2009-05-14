class ClientesController < ApplicationController
  protect_from_forgery :only => [:create, :update, :destroy] 


    def autocomplete_cliente
      nomeToken = params[:nome] if params[:nome]
      bloco = params[:bloco] if (params[:bloco] && params[:bloco].length > 0)
      apartamento = params[:apartamento] if (params[:apartamento] && params[:apartamento].length > 0)
      #Se tiver bloco e apto, ignora token do nome
      if (bloco && apartamento) then
        @clientes = Cliente.find(:all, :conditions => "bloco = '#{bloco}' and apartamento = '#{apartamento}'", :order => "nome")
      elsif (bloco) then
        @clientes = Cliente.find(:all, :conditions => "nome like '#{nomeToken}%' and bloco = '#{bloco}'", :order => "nome")        
      elsif (apartamento) then
        @clientes = Cliente.find(:all, :conditions => "nome like '#{nomeToken}%' and apartamento = '#{apartamento}'", :order => "nome")
      else
        @clientes = Cliente.find(:all, :conditions => "nome like '#{nomeToken}%'", :order => "nome")
      end
      render :layout=>false
    end

  def por_ordenacao
    @clientes = Cliente.paginate(:all, :order => params[:ordem], :page => params[:page])
    @ordem = params[:ordem]
    @tipo_ordenacao = params[:tipo_ordenacao]
    if @tipo_ordenacao == "asc" then 
      @tipo_ordenacao = "desc" 
    else 
      @tipo_ordenacao = "asc" 
    end
    respond_to do |format|
      format.html { render :action => "index" }
      format.xml { render :xml => @clientes }
      format.js if request.xhr?
    end
  end

  def por_bloco_apto
    @clientes = Cliente.find(:all, :conditions => "apartamento = '#{params[:apartamento]}%' and bloco = '#{params[:bloco]}'", :order => "nome")
    respond_to do |format|
      format.html { render :action => "index" }
      format.xml { render :xml => @clientes }
      format.js if request.xhr?
    end
  end

  # GET /clientes
  # GET /clientes.xml
  def index
    @clientes = Cliente.paginate(:all, :order => "nome, bloco, apartamento", :page => params[:page])
    @tipo_ordenacao = "asc"
    @ordem = "nome, bloco, apartamento"
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @clientes }
    end
  end

  # GET /clientes/1
  # GET /clientes/1.xml
  def show
    @cliente = Cliente.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cliente }
    end
  end

  # GET /clientes/new
  # GET /clientes/new.xml
  def new
    @cliente = Cliente.new
    @cliente.dependentes.build

    

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cliente }
    end
  end

  # GET /clientes/1/edit
  def edit
    @cliente = Cliente.find(params[:id])
  end

  # POST /clientes
  # POST /clientes.xml
  def create
    @cliente = Cliente.new(params[:cliente])

    respond_to do |format|
      if @cliente.save
        flash[:notice] = 'Cliente was successfully created.'
        format.html { redirect_to(clientes_url) }
        format.xml  { render :xml => @cliente, :status => :created, :location => @cliente }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cliente.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /clientes/1
  # PUT /clientes/1.xml
  def update
    @cliente = Cliente.find(params[:id])

    respond_to do |format|
      if @cliente.update_attributes(params[:cliente])
        flash[:notice] = 'Cliente was successfully updated.'
        format.html { redirect_to(clientes_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cliente.errors, :status => :unprocessable_entity }
      end
    end
  end

  def remover_dependente
  end

  def adiciona_dependente
    puts "Params: "+params.to_s
    if params[:cliente].has_key? :id then
      @cliente = Cliente.find(params[:id])
    else
      @cliente = Cliente.new(params[:cliente])
    end

    adicional = Cliente.new(:nome => params[:novo_dependente][:nome], :email => params[:novo_dependente][:email], :limite_credito => params[:novo_dependente][:limite_credito])
    adicional.responsavel = @cliente
    @cliente.dependentes << adicional

    respond_to do |format|
      format.js if request.xhr?  
    end
  end

  # DELETE /clientes/1
  # DELETE /clientes/1.xml
  def destroy
    @cliente = Cliente.find(params[:id])
    @cliente.destroy

    respond_to do |format|
      format.html { redirect_to(clientes_url) }
      format.xml  { head :ok }
    end
  end
end
