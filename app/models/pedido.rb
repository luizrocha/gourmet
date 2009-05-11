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
  
  def remove_produto(produto)
    item_corrente = @items.find {|item| item.produto == produto}
    item_corrente.decrementa_quantidade
    if (item_corrente.quantidade == 0)
      @items.delete(item_corrente)
    end
    item_corrente
  end
  
  def valor_total
    @items.sum { |item| item.valor_total }
  end

  def valor_restante
    total_pago = @pagamentos.sum { |pagamento| pagamento.valor }
    return (valor_total - total_pago)
  end

  def total_de_items
    @items.sum { |item| item.quantidade }
  end
  
private

def validar_item_venda(quantidade, produto)
   if (!produto) then
     raise "Produto não encontrado!"
   end
   if ( quantidade < 0) then
     raise "Quantidade não pode ser negativa!"
   end
   q,m = quantidade.divmod(BigDecimal("1")) 
   produto_permite_fracao = produto.permitidaVendaFracionaria
   if (m != 0 && !produto_permite_fracao ) then
     raise "Venda fracionaria não permitida para este produto!"
   end
end


  def validar_valor_pagamento (valor)
    if ( valor > valor_restante ) then
      raise "Pagamento não pode ser maior que valor restante para quitar o pedido!"
    end
  end

end