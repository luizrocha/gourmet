class PedidoPagamentoConta < PedidoPagamento

  has_one :cliente

  def initialize(valor, cliente)
    super(valor)
    tipo_pagamento = "conta"
    cliente = cliente
  end
    
  def descricao
      if (cliente.bloco && cliente.apartamento) then
        return tipo_pagamento.capitalize + " - ["+ cliente.bloco.concat(cliente.apartamento)  +"] " + cliente.nome
      else
        return tipo_pagamento.capitalize + " - "+ cliente.nome
      end
  end 

end
