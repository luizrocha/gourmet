class Produto < ActiveRecord::Base
  
  cattr_reader :per_page
  @@per_page = 12

  belongs_to :unidade_venda  
  
  validates_presence_of :descricao, :unidade_venda_id, :valor_venda, :message => "deve ser preenchido"
  validates_numericality_of :valor_venda, :message => "deve ser preenchido com um número válido"
  validates_numericality_of :estoque_minimo, :estoque_maximo, :allow_nil => true, :message => "deve ser preenchido com um número válido"
  validates_length_of :descricao, :maximum => 50, :message => "pode ter no máximo 50 caracteres"
  validate :valor_venda_deve_ser_no_minimo_1_centavo
  validates_uniqueness_of :codigo_barras, :allow_nil => true, :allow_blank => true, :message => "já é um código de outro produto cadastrado"

  def permitidaVendaFracionaria
    return (unidade_venda.fracionario)
  end
  
  protected
    def valor_venda_deve_ser_no_minimo_1_centavo
      errors.add :valor_venda, 'deve ser no mínimo de 1 centavo' if valor_venda.nil? || valor_venda < 0.01
    end
  
end
