class PedidoItem < ActiveRecord::Base
  	
	belongs_to :pedido
  belongs_to :produto
  
	
	def initialize(produto, quantidade = nil)
	  @produto = produto
    if (quantidade)
      @quantidade = quantidade
    else
	    @quantidade = 1
    end
    calcular_valor_item
  end
  
  def incrementa_quantidade (quantidade = nil)
    if (quantidade)
      @quantidade += quantidade
    else
      @quantidade += 1
    end
    calcular_valor_item
  end
  
  def decrementa_quantidade
    @quantidade -= 1 if @quantidade > 0
    calcular_valor_item
  end
  
  def modifica_quantidade(quantidade)
    @quantidade = quantidade
    calcular_valor_item
  end
  
  def descricao
    @produto.descricao
  end

private
  def calcular_valor_item
    @valor_total = @produto.valor_venda * @quantidade
  end

end