class ProdutosController < ApplicationController
  protect_from_forgery :only => [:create, :update, :destroy] 

  # GET /produtos
  # GET /produtos.xml
  def index
    @produtos = Produto.paginate(:all, :order => "descricao", :page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @produtos }
    end
  end
  
  def por_letra
    @produtos = Produto.paginate(:all, :conditions => "descricao like '#{params[:letra]}%'", :order => "descricao", :page => params[:page])
    @letra = params[:letra]
    respond_to do |format|
      format.js if request.xhr?
      format.html { render :action => "index" }
      format.xml { render :xml => @produtos }
    end
  end

  def por_descricao
    #Se parametro passado for produto, entao renderiza listagem para autocomplete
    if (params[:produto]) then
      @autocomplete_render = true
      @produtos = Produto.find(:all, :conditions => "descricao like '#{params[:produto][:descricao]}%'", :order => "descricao")
      render :layout=>false, :template => "produtos/renderiza_autocomplete_descricao.html.erb" and return
    #Senao, renderiza listagem de produtos normalmente
    else
      @autocomplete_render = false    
      @produtos = Produto.paginate(:all, :conditions => "descricao like '#{params[:descricao]}%'", :order => "descricao", :page => params[:page])
      respond_to do |format|
        format.js if request.xhr?
        format.html { render :action => "index" }
        format.xml { render :xml => @produtos }
      end
    end
  end   

  # GET /produtos/1
  # GET /produtos/1.xml
  def show
    @produto = Produto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @produto }
    end
  end

  # GET /produtos/new
  # GET /produtos/new.xml
  def new
    @produto = Produto.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @produto }
    end
  end

  # GET /produtos/1/edit
  def edit
    @produto = Produto.find(params[:id])
  end

  # POST /produtos
  # POST /produtos.xml
  def create
    @produto = Produto.new(params[:produto])
    respond_to do |format|
      if @produto.save
        flash[:notice] = 'Produto foi criado com sucesso.'
        if (params[:commit].eql? "Criar-ModoRapido" ) then
          format.html { redirect_to :action => "new"}
        else
          format.html { redirect_to :action => "index"}          
        end
        format.xml  { render :xml => @produto, :status => :created, :location => @produto }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @produto.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /produtos/1
  # PUT /produtos/1.xml
  def update
    @produto = Produto.find(params[:id])

    respond_to do |format|
      if @produto.update_attributes(params[:produto])
        flash[:notice] = 'Produto atualizado com sucesso.'
        format.html { redirect_to :action => "index"}          
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @produto.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /produtos/1
  # DELETE /produtos/1.xml
  def destroy
    @produto = Produto.find(params[:id])
    @produto.destroy

    respond_to do |format|
      format.html { redirect_to(produtos_url) }
      format.xml  { head :ok }
    end
  end
end
