class LancamentoCompra < Lancamento

  belongs_to :forma_de_pagamento

  validates_presence_of :valor, :data, :centro_de_custo_id, :tipo_credito_debito, :message => "deve ser preenchido"
  validates_length_of :tipo_credito_debito, :maximum => 1, :message => "pode ter no máximo 1 caractere"
  validates_numericality_of :valor, :message => "deve ser preenchido com um número"
  validates_inclusion_of :tipo_credito_debito, :in => %w( C D ), :message => "não pode ser diferente de (C)rédito e (D)ébito"
  validates_length_of :descricao, :maximum => 100, :allow_nil => true, :message => "pode ter no máximo 100 caracteres"
  validate :valor_deve_ser_positivo

  #Referentes ao Tipo Lancamento Compra
  validates_presence_of :fornecedor, :message => "deve ser preenchido"
  validates_length_of :numero_nota_fiscal, :maximum => 50, :message => "pode ter no máximo 50 caracteres"
  validates_length_of :fornecedor, :maximum => 100, :allow_nil => true, :message => "pode ter no máximo 100 caracteres"
  validate :valida_data_de_vencimento_obrigatoria_para_boleto
  validate :valida_data_de_vencimento_maior_que_data_lancamento
  validate :valida_tipo_lancamento_debito_para_compras

  protected
    def valida_data_de_vencimento_maior_que_data_lancamento
       errors.add :data_de_vencimento, 'data de vencimento deve ser maior que a data do lançamento' if (!data_de_vencimento.nil? && data_de_vencimento < data)
    end
    
    def valida_data_de_vencimento_obrigatoria_para_boleto
       #errors.add :data_de_vencimento, 'data de vencimento obrigatória para boletos bancários' if (!data_de_vencimento.nil? && forma_de_pagamento.nome == "Boleto") 
    end

    def valida_tipo_lancamento_debito_para_compras
        errors.add :tipo_credito_debito, 'tipo lancamento deve ser Débito para lancamento de compra' if (!tipo_credito_debito.nil? && tipo_credito_debito == "C") 
    end
    
    def valor_deve_ser_positivo
      errors.add :valor, 'deve ser um valor positivo' if (!valor.nil? && valor <= 0)
    end
    
end
