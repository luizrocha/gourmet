class PedidoPagamentoDinheiro < PedidoPagamento

  def initialize(valor)
    super(valor)
    @tipo_pagamento = "dinheiro"
  end
    
  def descricao
     return "Dinheiro"
  end 

end
