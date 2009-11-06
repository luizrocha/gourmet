class Compra < ActiveRecord::Base
  
  belongs_to :centro_de_custo
  has_many :lancamento_compra
  
  validates_presence_of :centro_de_custo_id, :fornecedor, :message => "deve ser preenchido"
  validates_length_of :fornecedor, :maximum => 100, :allow_nil => true, :message => "pode ter no máximo 100 caracteres"
  validates_length_of :numero_nota_fiscal, :maximum => 100, :allow_nil => true, :message => "pode ter no máximo 100 caracteres"

  def valor_total
    valor_total = 0
    lancamento_compra.each do |lancamento|
  	  valor_total += lancamento.valor
    end
    valor_total
  end
  
  def self.find_all_ativas_periodo(data_inicial, data_final)
    find(:all, :conditions => ["data > ? AND data < ?", data_inicial, data_final])
  end
  
  def parcelasPendentes?
    lancamento_compra.each do |lancamento|
      if (!lancamento.pagamentoConfirmado?)
        return true
      end
    end
    return false
  end
  
  def parcelasPendentesJaVencidas?
    lancamento_compra.each do |lancamento|
      if (lancamento.data_de_vencimento < Time.now && !lancamento.pagamentoConfirmado? )
        return true
      end
    end
    return false
  end

  def parcelasPagas?
    return !parcelasPendentes?
  end


end