class LancamentoComprasController < ApplicationController
  def index
    @lancamento_compras = LancamentoCompra.find(:all, :order => "data")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lancamento_compras }
      format.xls { send_data @lancamento_compras.to_xls }
    end
  end

  def por_ordenacao
    @lancamento_compras = LancamentoCompra.find(:all, :order => params[:ordem])
    @ordem = params[:ordem]
    @tipo_ordenacao = params[:tipo_ordenacao]
    if @tipo_ordenacao == "asc" then 
      @tipo_ordenacao = "desc" 
    else 
      @tipo_ordenacao = "asc" 
    end
    respond_to do |format|
      format.html { render :action => "index" }
      format.xml { render :xml => @lancamento_compras }
      format.xls { send_data @lancamento_compras.to_xls }
      format.js if request.xhr?
    end
  end

  def show
    @lancamento_compra = LancamentoCompra.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lancamento_compra }
    end
  end

  def new
    @lancamento_compra = LancamentoCompra.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lancamento_compra }
    end
  end

  def edit
    @lancamento_compra = LancamentoCompra.find(params[:id])
  end

  def create
    @lancamento_compra = LancamentoCompra.new(params[:lancamento_compra])

    respond_to do |format|
      if @lancamento_compra.save
        flash[:notice] = 'Lancamento was successfully created.'
        format.html { redirect_to(@lancamento_compra) }
        format.xml  { render :xml => @lancamento_compra, :status => :created, :location => @lancamento_compra }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lancamento_compra.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @lancamento_compra = LancamentoCompra.find(params[:id])

    respond_to do |format|
      if @lancamento_compra.update_attributes(params[:lancamento_compra])
        flash[:notice] = 'Lancamento was successfully updated.'
        format.html { redirect_to(@lancamento_compra) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lancamento_compra.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @lancamento_compra = LancamentoCompra.find(params[:id])
    @lancamento_compra.destroy

    respond_to do |format|
      format.html { redirect_to(lancamentos_url) }
      format.xml  { head :ok }
    end
  end
end
