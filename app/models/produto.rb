class Produto < ActiveRecord::Base
  
  cattr_reader :per_page
  @@per_page = 9
  
  
  validates_presence_of :descricao, :unidade_venda, :valor_venda, :message => "deve ser preenchido"
  validates_uniqueness_of :referencia, :message => "deve ser um valor único"
  validates_numericality_of :valor_venda, :message => "deve ser preenchido com um número válido"
  validates_length_of :unidade_venda, :maximum => 2, :message => "pode ter no máximo 2 caracteres"
  validates_length_of :descricao, :maximum => 50, :message => "pode ter no máximo 50 caracteres"
  validate :valor_venda_deve_ser_no_minimo_1_centavo

  
  protected
    def valor_venda_deve_ser_no_minimo_1_centavo
      errors.add :valor_venda, 'deve ser no mínimo de 1 centavo' if valor_venda.nil? || valor_venda < 0.01
    end
  
end
