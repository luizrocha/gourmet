class ProdutosController < ApplicationController

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
      format.html { render :action => "index" }
      format.xml { render :xml => @produtos }
      format.js if request.xhr?
    end
  end

  def por_descricao
    @produtos = 
      respond_to do |format|
      format.html { render :action => "index" }
      format.xml { render :xml => @produtos }
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
        flash[:notice] = 'Produto was successfully updated.'
        format.html { redirect_to(@produto) }
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
