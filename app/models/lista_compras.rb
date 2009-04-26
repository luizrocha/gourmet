class ListaCompras
  attr_reader :items
  
  def initialize
    @items = []
  end
  
  def adiciona_produto(produto, quantidade = nil)
    item_corrente = @items.find {|item| item.produto == produto}
    if item_corrente
        item_corrente.incrementa_quantidade(quantidade)  
    else
      item_corrente = ListaComprasItem.new(produto, quantidade)
      @items << item_corrente
    end
    item_corrente
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

  def total_de_items
    @items.sum { |item| item.quantidade }
  end

end