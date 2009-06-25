class PedidoPagamento
  
  TIPOS_PAGAMENTO = [
  # Displayed stored in db
  [ "Dinheiro" , "check" ],
  [ "Credit card" , "cc" ],
  [ "Purchase order" , "po" ]
  ]

  attr_reader :valor
  attr_reader :tipo_pagamento
    
  def descricao
    raise "Abstract method!"
  end

  def initialize(valor)
    validar_valor(valor)
    @valor = valor
  end
  
protected

  def validar_valor (valor)
    if !valor || valor.nil?
      raise "Pagamento deve ter um valor informado!"
    elsif ( valor < 0.01 )
      raise "Valor do pagamento deve ser um número positivo!"
    end
  end  

end