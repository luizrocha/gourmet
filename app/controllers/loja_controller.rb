class LojaController < ApplicationController
  protect_from_forgery :only => [:create, :update, :destroy] 
  before_filter :busca_lista_compras, :except => :esvazia_lista_compras
  before_filter :busca_parametro_modo_selecao
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
        item = @pedido.obter_item_corrente(produto)
        if (item.quantidade > quantidade)
          flash[:notice] = 'Lembre-se que remover ou diminuir a quantidade de um produto gera um evento para Auditoria'
        end
        @pedido.altera_quantidade_produto(produto, quantidade) 
      end
      @pedido.save!
	
    rescue Exception => e:
      flash[:notice] = e.to_s
      puts e.to_s 
    end
    respond_to do |format|
      format.js 
    end
  end
  
  def alterar_quantidade_item_selecionado
    items_selecionados = (session[:items_selecionados] ||= Hash.new)
    id = params[:id]
    qtd = BigDecimal.new(params[:item_selecionado][:quantidade])
    #Verificar se item realmente esta na lista de selecionados
    if (items_selecionados[id] and items_selecionados[id] == true) then
      items_quantidade = (session[:items_selecionados_quantidade] ||= Hash.new)
      items_valor = (session[:items_selecionados_valor] ||= Hash.new)
      items_quantidade[id] = qtd
      #Calcular Valores parciais, retornando valor total
      valor_calculado = @pedido.calcular_valores_parciais(items_selecionados,items_quantidade,items_valor)
      #Armazenando na session os items, quantidades e valores parciais
      session[:items_selecionados] = items_selecionados
      session[:items_selecionados_quantidade] = items_quantidade
      session[:items_selecionados_valor] = items_valor

      puts("Valor Calculado dos Selecionados: "+valor_calculado.to_s)
      respond_to do |format|
        format.js {render :layout=>false, :template => "loja/adiciona_produto_lista_compras.rjs"}
      end
      
    end
  end
  
  def chavear_selecao_parcial
    if ( session[:modo_selecao] ) then
      session[:modo_selecao] = nil
      session[:items_selecionados] = nil
      session[:items_selecionados_quantidade] = nil
      session[:items_selecionados_valor] = nil
      @modo_selecao = nil
    else
      session[:modo_selecao] = true
      @modo_selecao = true
    end
    respond_to do |format|
      format.js {render :layout=>false, :template => "loja/adiciona_produto_lista_compras.rjs"}
    end
  end
  
  def selecionar_item
    items = (session[:items_selecionados] ||= Hash.new)
    items_quantidade = (session[:items_selecionados_quantidade] ||= Hash.new)
    items_valor = (session[:items_selecionados_valor] ||= Hash.new)
    id = params[:id]
    #Verifica se Item esta selecionado. Se estiver, remove-o do array dos selecionados
    if (items[id] and items[id] == true) then
      items.delete(id)
      items_qtd.delete(id)
      items_valor.delete(id)
      puts("Item Removido do Array dos Selecionados: "+params[:id])
    #Senao, adiciona-o no array dos selecionados e inicializa arrays auxiliares
    else
      items[id] = true
      items_quantidade[id] = 0
      items_valor[id] = 0
      puts("Item Inserido no Array dos Selecionados: "+params[:id])
    end    
    #Calcular Valores parciais, retornando valor total
    valor_calculado = @pedido.calcular_valores_parciais(items,items_quantidade,items_valor)
    #Armazenando na session os items, quantidades e valores parciais
    session[:items_selecionados] = items
    session[:items_selecionados_quantidade] = items_quantidade
    session[:items_selecionados_valor] = items_valor
    
    puts("Valor Calculado dos Selecionados: "+valor_calculado.to_s)
    respond_to do |format|
      format.js {render :layout=>false, :template => "loja/adiciona_produto_lista_compras.rjs"}
    end
    
  end
  
  def editar_produto_lista_compras
    produto = Produto.find_by_id(params[:id]) if params[:id]
    @item_corrente = @pedido.obter_item_corrente(produto)
    respond_to do |format|
       format.js {render :layout => false}       
    end  
  end
  
  
  def remover_produto_lista_compras
    produto = Produto.find_by_id(params[:id]) if params[:id]    
    begin
      @pedido.remove_produto(produto)
      @pedido.save
      flash[:notice] = 'Lembre-se que remover ou diminuir a quantidade de um produto gera um evento para Auditoria'
    rescue Exception => e:
      flash[:notice] = e.to_s
    end
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
    if( tipo_pgto.eql? "Cartao" ) then
      cartao = params[:bandeira_cartao]
    elsif( tipo_pgto.eql? "Conta" ) then
      cliente_nome = params[:tipo_pagamento_conta_cliente]
      cliente_bloco = params[:tipo_pagamento_conta_bloco]
      cliente_apartamento = params[:tipo_pagamento_conta_apartamento]
      #Buscar Ref do Cliente
      cliente = nil
    end
    
    begin
      if(pgto_valor > @pedido.valor_restante) then
        flash[:notice] = "Pagamento ultrapassou restante para quitar o pedido! Diferença será adicionada como serviço!"
      end
      @pedido.adiciona_pagamento(pgto_valor, cliente, cartao)
      @pedido.save
    rescue Exception => e:
      flash[:notice] = e.to_s
    end
    respond_to do |format|
      format.js
    end
  end

  def descartar_pedido 
    begin
      @pedido.cancelar_pedido
      @pedido.save!
      session[:pedido_id] = nil
    rescue Exception => e:
          redirect_to_index("Erro ao Cancelar Pedido: " +e.to_s)
    end
    redirect_to_index("Dados do Pedido Descartado foram armazenados para Posterior Auditoria!")
  end

  def finalizar_pedido
    begin
      @pedido.finalizar_pedido
      @pedido.save!
      session[:pedido_id] = nil
    rescue Exception => e:
          redirect_to_index("Erro ao Finalizar Pedido: " +e.to_s)
    end
    redirect_to_index
  end

  def esvazia_lista_compras
    pedido_id = session[:pedido_id]
    session[:pedido] = nil
  end

private
  def busca_parametro_modo_selecao
    @modo_selecao = session[:modo_selecao]
  end

  def busca_lista_compras
    pedido_id = session[:pedido_id]
    if ( pedido_id == nil ) then
      @pedido = Pedido.new
      @pedido.status = "A"
      @pedido.save
      @pedido.errors.each_full { |msg| puts msg }
      session[:pedido_id] = @pedido.id
    elsif
      @pedido = Pedido.find(pedido_id)
    end
  end

  def limpar_aviso
    flash[:notice] = nil
  end

  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => 'index'
  end

end
