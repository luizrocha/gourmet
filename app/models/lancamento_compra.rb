class LancamentoCompra < Lancamento

  belongs_to :forma_de_pagamento
  belongs_to :compra
  
  validates_presence_of :valor, :data, :tipo_credito_debito, :status, :forma_de_pagamento_id, :data_de_vencimento, :compra_id, :message => "deve ser preenchido"
  validates_length_of :tipo_credito_debito, :maximum => 1, :message => "pode ter no máximo 1 caractere"
  validates_numericality_of :valor, :message => "deve ser preenchido com um número"
  validates_inclusion_of :tipo_credito_debito, :in => %w( C D ), :message => "não pode ser diferente de (C)rédito e (D)ébito"
  validates_length_of :descricao, :maximum => 100, :allow_nil => true, :message => "pode ter no máximo 100 caracteres"
  validate :valor_deve_ser_positivo

  #Referentes ao Tipo Lancamento Compra
  validate :valida_tipo_lancamento_debito_para_compras


  def before_validation
    self.tipo_credito_debito = "D"
  end

  protected    
    def valida_tipo_lancamento_debito_para_compras
        errors.add :tipo_credito_debito, 'tipo lancamento deve ser Débito para lancamento de compra' if (!tipo_credito_debito.blank? && tipo_credito_debito == "C") 
    end
    
    
end
