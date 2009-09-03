class LancamentoComprasController < ApplicationController
  def index
    @lancamento_compras = LancamentoCompra.find(:all, :order => "data")    
    total = 0
    @lancamento_compras.each do |lancamento|
  	  total += lancamento.valor
    end
    @valor_total = total

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lancamento_compras }
      format.xls { send_data @lancamento_compras.to_xls }
    end
  end

  def por_filtro
    whereClause = " id >= 0 ";
    filtro = params[:filtro]
    if (filtro[:data] == "1") then
      data_inicial = Date.new(filtro['data_inicial(1i)'].to_i,filtro['data_inicial(2i)'].to_i,filtro['data_inicial(3i)'].to_i)
      data_final = DateTime.new(filtro['data_final(1i)'].to_i,filtro['data_final(2i)'].to_i,filtro['data_final(3i)'].to_i,23,59,59)
      whereClause = whereClause + " and data >= '#{data_inicial}' and data <= '#{data_final}' "
    end
    if (filtro[:data_vencimento] == "1") then
      data_vencimento_inicial = Date.new(filtro['data_vencimento_inicial(1i)'].to_i,filtro['data_vencimento_inicial(2i)'].to_i,filtro['data_vencimento_inicial(3i)'].to_i)
      data_vencimento_final = DateTime.new(filtro['data_vencimento_final(1i)'].to_i,filtro['data_vencimento_final(2i)'].to_i,filtro['data_vencimento_final(3i)'].to_i,23,59,59)
      whereClause = whereClause + " and data_de_vencimento >= '#{data_vencimento_inicial}' and data_de_vencimento <= '#{data_vencimento_final}' "
    end
    if (filtro[:forma_de_pagamento] == "1") then
      forma_de_pagamento_id = filtro[:forma_de_pagamento_id]
      whereClause = whereClause + " and forma_de_pagamento_id = #{forma_de_pagamento_id} "
    end
    if (filtro[:centro_de_custo] == "1") then
      centro_de_custo_id = filtro[:centro_de_custo_id]
      whereClause = whereClause + " and centro_de_custo_id = #{centro_de_custo_id} "
    end
    puts "Where clause: "+whereClause
    #Faz a consulta
    @lancamento_compras = LancamentoCompra.find(:all, :conditions => "#{whereClause}", :order => "data")
    total = 0
    @lancamento_compras.each do |lancamento|
  	  total += lancamento.valor
    end
    @valor_total = total
    session[:lancamento_compras] = @lancamento_compras
    respond_to do |format|
      format.xls { send_data @lancamento_compras.to_xls } if params[:commit] == "Excel"
      format.html # index.html.erb
      format.xml  { render :xml => @lancamento_compras }
      format.js if request.xhr?
    end  
  end

  def exportar_excel
   send_data session[:lancamento_compras].to_xls
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
