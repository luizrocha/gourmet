class LojaController < ApplicationController
  protect_from_forgery :only => [:create, :update, :destroy] 
  before_filter :busca_lista_compras, :except => :esvazia_lista_compras

  def index
  end
  
  def autocomplete_novo_item
    @produtos = Produto.find(:all, :conditions => "descricao like '#{params[:compras][:novo_item]}%'", :order => "descricao")
    render :layout=>false
  end

  def adiciona_produto_lista_compras
    flash[:notice] = nil
    produto = Produto.find_by_descricao(params[:descricao_item]) if params[:descricao_item]
    produto = Produto.find_by_codigo_barras(params[:codigo_barras_item]) if params[:codigo_barras_item]
    quantidade = BigDecimal.new(params[:quantidade_item])
    begin
      @item_corrente = @pedido.adiciona_produto(produto, quantidade)
    rescue Exception => e:
      flash[:notice] = e.to_s 
    end
    respond_to do |format|
      format.js 
    end
  end
  
  def adiciona_pagamento
    flash[:notice] = nil
    #Tratamento Parametros e Lookups Referencias
    pgto_valor = BigDecimal.new(params[:valor].gsub(",","."))
    tipo_pgto = params[:tipo_pagamento]
    if ( tipo_pgto.eql? "Cartao" ) then
      cartao = params[:bandeira_cartao]
    elsif ( tipo_pgto.eql? "Conta" ) then
      cliente_nome = params[:tipo_pagamento_conta_cliente]
      cliente_bloco = params[:tipo_pagamento_conta_bloco]
      cliente_apartamento = params[:tipo_pagamento_conta_apartamento]
      #Buscar Ref do Cliente
      cliente = nil
    end
    
    begin
      @pedido.adiciona_pagamento(pgto_valor, cliente, cartao)
    rescue Exception => e:
      flash[:notice] = e.to_s
    end
    respond_to do |format|
      format.js
    end
  end

  def esvazia_lista_compras
    session[:pedido] = nil
    respond_to do |format|
      format.js if request.xhr?
      format.html {redirect_to_index}
    end
  end

private
  def busca_lista_compras
    @pedido = (session[:pedido] ||= Pedido.new)
  end

  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => 'index'
  end

end
