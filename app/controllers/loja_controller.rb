class LojaController < ApplicationController
  protect_from_forgery :only => [:create, :update, :destroy] 
  before_filter :busca_lista_compras, :except => :esvazia_lista_compras
  before_filter :limpar_aviso

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
    modo_edicao = params[:modo_edicao]
    begin
      if (modo_edicao != 'true') then
        @pedido.adiciona_produto(produto, quantidade)
      else
        item = @pedido.obtem_item_produto(produto)
        if (item.quantidade > quantidade)
          flash[:notice] = 'Lembre-se que remover ou diminuir a quantidade de um produto gera um evento para Auditoria'
        end
        @pedido.altera_quantidade_produto(produto, quantidade)        
      end
    rescue Exception => e:
      flash[:notice] = e.to_s 
    end
    respond_to do |format|
      format.js 
    end
  end
  
  def editar_produto_lista_compras
    produto = Produto.find_by_id(params[:id]) if params[:id]
    @item_corrente = @pedido.items.find {|item| item.produto == produto}
    respond_to do |format|
       format.js {render :layout => false}       
    end  
  end
  
  
  def remover_produto_lista_compras
    produto = Produto.find_by_id(params[:id]) if params[:id]    
    @pedido.remove_produto(produto)
    flash[:notice] = 'Lembre-se que remover ou diminuir a quantidade de um produto gera um evento para Auditoria'
    respond_to do |format|
      format.js {render :layout=>false, :template => "loja/adiciona_produto_lista_compras.rjs"}
    end
  end
  
  def remove_pagamento
    
    
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
      if (pgto_valor > @pedido.valor_restante) then
        flash[:notice] = "Pagamento ultrapassou restante para quitar o pedido! Diferença será adicionada como serviço!"
      end
      @pedido.adiciona_pagamento(pgto_valor, cliente, cartao)
    rescue Exception => e:
      flash[:notice] = e.to_s
    end
    respond_to do |format|
      format.js
    end
  end

  def descartar_pedido 
    esvazia_lista_compras
    redirect_to_index ("Dados do Pedido Descartado foram armazenados para Posterior Auditoria!")
  end

  def finalizar_pedido
    
  end

  def esvazia_lista_compras
    session[:pedido] = nil
  end

private
  def busca_lista_compras
    @pedido = (session[:pedido] ||= Pedido.new)
  end

  def limpar_aviso
    flash[:notice] = nil
  end

  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => 'index'
  end

end
