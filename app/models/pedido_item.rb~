class PedidoItem < ActiveRecord::Base
  	
  belongs_to :pedido
  belongs_to :produto
  
  def before_save
      calcular_valor_item
  end

  def incrementa_quantidade (qtd = nil)
    if (qtd)
      qtd += read_attribute(:quantidade)
      write_attribute(:quantidade, qtd)
    else
      qtd = read_attribute(:quantidade)
      write_attribute(:quantidade, qtd + 1)
    end
  end
  
  def decrementa_quantidade
    quantidade -= 1 if quantidade > 0
  end
  
  def descricao
    produto.descricao
  end

private
  def calcular_valor_item
    self.valor_total = (produto.valor_venda * quantidade)
  end

end
