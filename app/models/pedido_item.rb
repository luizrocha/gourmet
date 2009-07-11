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
    #Se nao foi persistido valor unitario - primeira vez que item esta sendo inserido no carrinho
    #Valor unitario persistido para previnir alteracoes de precos apos o pedido ja estar aberto
    if ( !read_attribute(:valor_unitario) ) then
      write_attribute(:valor_unitario, produto.valor_venda)
    end
    valor_unitario = read_attribute(:valor_unitario) 
    write_attribute(:valor_total, valor_unitario * quantidade)
  end

end
