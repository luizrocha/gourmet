class Pedido
  attr_reader :items
  attr_reader :pagamentos
  
  def initialize
    @items = []
    @pagamentos = []
  end
  
  def adiciona_produto(produto, quantidade = nil)
    validar_item_venda(quantidade, produto)
    item_corrente = @items.find {|item| item.produto == produto}
    if item_corrente
        item_corrente.incrementa_quantidade(quantidade)  
    else
      item_corrente = PedidoItem.new(produto, quantidade)
      @items << item_corrente
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
    @pagamentos << pagamento
    pagamento
  end
  
  def altera_quantidade_produto(produto, quantidade)
    validar_item_venda(quantidade, produto)
    item_corrente = @items.find {|item| item.produto == produto}
    if item_corrente
        item_corrente.modifica_quantidade(quantidade)  
    end
    item_corrente
  end
  
  def remove_produto(produto)
    item_corrente = @items.find {|item| item.produto == produto}
    @items.delete(item_corrente)
    item_corrente
  end
  
  def valor_total
    @items.sum { |item| item.valor_total }
  end
  
  def valor_servico
    @items.sum { |item| ( item.produto.adiciona_taxa_servico ? (item.valor_total * 0.1) : 0 )}
  end
  
  def valor_total_com_servico
    return valor_total + valor_servico
  end

  def valor_pago_de_servico
      if ( (valor_pago - valor_total) > 0 ) then
        return (valor_pago - valor_total)
      else
        return 0
      end
  end

  def valor_restante
    if ( valor_total - valor_pago ) > 0 then
      return (valor_total - valor_pago)
    else
      return 0
    end
  end

  def valor_pago
    return @pagamentos.sum { |pagamento| pagamento.valor }
  end

  def obtem_item_produto (produto)
    @items.find {|item| item.produto == produto}
  end

  def total_de_items
    @items.sum { |item| item.quantidade }
  end

private

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


end