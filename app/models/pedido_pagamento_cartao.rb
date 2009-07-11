class PedidoPagamentoCartao < PedidoPagamento
	
  def initialize(valor, cartao)
    super(valor)
    @tipo_pagamento = "cartao"
    write_attribute(:cartao, cartao)
  end
    
  def descricao
      return "Cartão - "+ cartao
  end 

end
