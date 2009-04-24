class ListaComprasItem

	attr_reader :produto, :quantidade
	
	def initialize(produto)
	  @produto = produto
	  @quantidade = 1
  end
  
  def incrementa_quantidade
    @quantidade += 1
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