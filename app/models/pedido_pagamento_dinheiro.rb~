class PedidoPagamentoDinheiro < PedidoPagamento

  attr_reader :cliente
	
  def initialize(valor)
    super(valor)
    @tipo_pagamento = "dinheiro"
  end
    
  def descricao
     return tipo_pagamento.capitalize
  end 

end