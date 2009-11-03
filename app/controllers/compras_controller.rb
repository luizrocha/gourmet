class ComprasController < ApplicationController
  require 'spreadsheet'

  def index
    @compras = Compra.find(:all, :order => "data" )
    session[:compras] = @compras
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @compras }
    end
  end

  def por_filtro
    whereClause = " id >= 0 ";
    filtro = params[:filtro]
    if (filtro[:data] == "1") then
      data_inicial = converte_para_data(filtro['data_inicial'])
      data_final = converte_para_data(filtro['data_final'],23,59,59)
      whereClause = whereClause + " and data >= '#{data_inicial}' and data <= '#{data_final}' "
    end
    if (filtro[:data_vencimento] == "1") then
      data_vencimento_inicial = converte_para_data(filtro['data_vencimento_inicial'])
      data_vencimento_final = converte_para_data(filtro['data_vencimento_final'],23,59,59)
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
    @lancamento_compras = LancamentoCompra.find(:all, :conditions => "#{whereClause}", :order => "data_de_vencimento, forma_de_pagamento_id, centro_de_custo_id")
    total = 0
    @lancamento_compras.each do |lancamento|
  	  total += lancamento.valor
    end
    @valor_total = total
    session[:lancamento_compras] = @lancamento_compras
    respond_to do |format|
      format.xls  { render :layout => false }
      format.html
      format.xml  { render :xml => @lancamento_compras }
      format.js if request.xhr?
    end  
  end

  def exportar_excel
    @lancamento_compras = session[:lancamento_compras]
    respond_to do |format|
      format.xls  { render :layout => false }
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
    @compra = Compra.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @compra }
    end
  end

  def new
    @compra = Compra.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @compra }
    end
  end

  def edit
    @lancamento_compra = LancamentoCompra.find(params[:id])
  end

  def create
    @compra = Compra.new(params[:compra])
    @compra.data = converte_para_data params[:compra][:data]
    
    respond_to do |format|
      if @compra.save
        flash[:notice] = 'Lancamento was successfully created.'
        format.html { redirect_to(@compra) }
        format.xml  { render :xml => @compra, :status => :created, :location => @compra }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @compra.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @lancamento_compra = LancamentoCompra.find(params[:id])

    respond_to do |format|
      if @lancamento_compra.update_attributes(params[:lancamento_compra])
        @lancamento_compra.data = converte_para_data params[:lancamento_compra][:data]
        @lancamento_compra.data_de_vencimento = converte_para_data params[:lancamento_compra][:data_de_vencimento]
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
  
private
  
  def converte_para_data(strData, hora=nil, minuto=nil, segundo=nil)
    date_array = strData.split("/")
    if ( hora && minuto && segundo ) then
      return DateTime.new(date_array[2].to_i, date_array[1].to_i,
      date_array[0].to_i, hora, minuto, segundo)
    else
      return Date.new(date_array[2].to_i, date_array[1].to_i, date_array[0].to_i)
    end
  end
  
end
