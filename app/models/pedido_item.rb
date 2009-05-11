class PedidoItem

	attr_reader :produto, :quantidade
	
	def initialize(produto, quantidade = nil)
	  @produto = produto
    if (quantidade)
      @quantidade = quantidade
    else
	    @quantidade = 1
    end
  end
  
  def incrementa_quantidade (quantidade = nil)
    if (quantidade)
      @quantidade += quantidade
    else
      @quantidade += 1
    end
  end
  
  def decrementa_quantidade
    @quantidade -= 1 if @quantidade > 0
  end
  
  def descricao
    @produto.descricao
  end
  
  def valor_total
    @produto.valor_venda * @quantidade
  end

end