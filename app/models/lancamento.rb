class Lancamento < ActiveRecord::Base
  validates_presence_of :valor, :data, :tipo_credito_debito, :status, :message => "deve ser preenchido"
  validates_length_of :tipo_credito_debito, :maximum => 1, :message => "pode ter no máximo 1 caractere"
  validates_numericality_of :valor, :message => "deve ser preenchido com um número"
  validates_inclusion_of :tipo_credito_debito, :in => %w( C D ), :message => "não pode ser diferente de (C)rédito e (D)ébito"
  validates_length_of :descricao, :maximum => 100, :allow_nil => true, :message => "pode ter no máximo 100 caracteres"
  validate :valor_deve_ser_positivo

protected

  def valor_deve_ser_positivo
    errors.add :valor, 'deve ser um valor positivo' if (!valor.nil? && valor <= 0)
  end


end
