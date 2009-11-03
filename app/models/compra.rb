class Compra < ActiveRecord::Base

  belongs_to :centro_de_custo
  has_many :lancamento_compra
  
  validates_presence_of :centro_de_custo_id, :fornecedor, :message => "deve ser preenchido"
  validates_length_of :fornecedor, :maximum => 100, :allow_nil => true, :message => "pode ter no máximo 100 caracteres"
  validates_length_of :numero_nota_fiscal, :maximum => 100, :allow_nil => true, :message => "pode ter no máximo 100 caracteres"

  def valor_total
    #lancamento_compra.each do |lancamento|
  	#  valor_total += lancamento.valor
    #end
    0
    #valor_total
  end
  
  def self.find_all_ativas_periodo(data_inicial, data_final)
    find(:all, :conditions => ["data > ? AND data < ?", data_inicial, data_final])
  end

end