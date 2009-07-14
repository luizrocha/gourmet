class Pedido < ActiveRecord::Base
  
  has_many :items, :class_name => "PedidoItem", :foreign_key => :pedido_id
  has_many :pagamentos, :class_name => "PedidoPagamento", :foreign_key => :pedido_id
  
  def before_create
    status = "A"
  end

  def adiciona_produto(produto, quantidade = nil)
    validar_item_venda(quantidade, produto)
    item_corrente = obter_item_corrente(produto)
    if item_corrente
        item_corrente.incrementa_quantidade(quantidade)
	item_corrente.save!  
    else
      item_corrente = PedidoItem.new
      item_corrente.produto = produto
      item_corrente.pedido = self
      item_corrente.quantidade = quantidade if quantidade
      item_corrente.quantidade = 1 if !quantidade
      item_corrente.save!
      items << item_corrente
    end
    item_corrente
  end
  
  def adiciona_pagamento(valor, cliente = nil, cartao = nil)
    validar_valor_pagamento(valor)
    if (cliente) 
      pagamento = PedidoPagamentoConta.new(valor, cliente)
    elsif (cartao)
        pagamento = PedidoPagamentoCartao.new(valor, cartao)
    else
        pagamento = PedidoPagamentoDinheiro.new(valor)
    end
    pagamentos << pagamento
    pagamento
  end
  
  def altera_quantidade_produto(produto, quantidade)
    validar_item_venda(quantidade, produto)
    item_corrente = obter_item_corrente(produto)
    if item_corrente
        item_corrente.quantidade = quantidade
    end
    item_corrente.save!
    item_corrente
  end
  
  def cancelar_pedido()
    encerrar_pedido("C")  #Finaliuza Stauts p/ Cancelado
    ##TODO: Adicionar Auditoria
  end
  
  def finalizar_pedido()
    encerrar_pedido("F")  #Finaliuza Stauts p/ Finalizado
  end
  
  def remove_produto(produto)
    item_corrente = obter_item_corrente(produto)
    PedidoItem.delete(item_corrente.id)
    item_corrente
  end
  
  def valor_total
    if (status == "A") then
      total = 0
      items.each do |item|
	 total += item.valor_total
      end
      return total
    else
      return read_attribute(:valor_total)
    end
  end
  
  def valor_servico
    #items.sum { |item| ( item.produto.adiciona_taxa_servico ? (item.valor_total * 0.1) : 0 )}
    total = 0
    items.each do |item|
	total += ( item.produto.adiciona_taxa_servico ? (item.valor_total * 0.1) : 0 )
    end
    total
  end
  
  def valor_total_com_servico
    return valor_total + valor_servico
  end

  def valor_pago_servico
    if (status == "A") then
	      if ( (valor_pago - valor_total) > 0 ) then
          return (valor_pago - valor_total)
      	#elsif ( valor_servico > 0 ) then
      	#  return ( valor_servico )
    	  else
          return 0
      	end
    else
      	return read_attribute(:valor_pago_servico)
    end    
  end

  def valor_restante
    if ( valor_total - valor_pago ) > 0 then
      return (valor_total - valor_pago)
    else
      return 0
    end
  end
  
  def valor_restante_com_servico
    if ( valor_total_com_servico - valor_pago ) > 0 then
      return (valor_total_com_servico - valor_pago)
    else
      return 0
    end
  end    

  def valor_pago
    #return pagamentos.sum { |pagamento| pagamento.valor }
    total = 0
    pagamentos.each do |pagamento|
	total += pagamento.valor
    end
    total
  end

  def total_de_items
    #items.sum { |item| item.quantidade }
    total = 0
    items.each do |item|
        total += item.quantidade
    end
    total
  end

  def obter_item_corrente (produto)
    obter_item_por_produto_id(produto.id.to_s)
  end

def calcular_valores_parciais(items)
  valor_calculado = 0.0
  items.each_pair { |id, booleano|
    puts("Percorrendo Array[id]: "+id+", booleando="+booleano.to_s)
     if(booleano) then
       item = obter_item_por_produto_id(id)
       puts("Item no Loop: "+item.produto.descricao+", valor_unit="+item.valor_unitario.to_s)
       valor_calculado += item.valor_unitario
     end
  }
  valor_calculado
end

private

def obter_item_por_produto_id(produto_id)
     PedidoItem.find_by_produto_id_and_pedido_id(produto_id, id.to_s)
end

def validar_item_venda(quantidade, produto)
   if (!produto) then
     raise "Produto não encontrado!"
   end
   if ( quantidade <= 0) then
     raise "Quantidade deve ser um número positivo!"
   end
   q,m = quantidade.divmod(BigDecimal("1")) 
   produto_permite_fracao = produto.permitidaVendaFracionaria
   if (m != 0 && !produto_permite_fracao ) then
     raise "Venda fracionaria não permitida para este produto!"
   end
end

def validar_valor_pagamento (valor)
end

def encerrar_pedido(status)
    write_attribute(:valor_total, valor_total)
    write_attribute(:valor_pago_servico, valor_pago_servico)
    write_attribute(:valor_pago_total, valor_pago)
    write_attribute(:status, status)
end

end
