class PedidoPagamentoCartao < PedidoPagamento

  attr_reader :cartao
	
  def initialize(valor, cartao)
    super(valor)
    @tipo_pagamento = "cartao"
    @cartao = cartao
  end
    
  def descricao
      return tipo_pagamento.capitalize + " - "+ @cartao
  end 

end