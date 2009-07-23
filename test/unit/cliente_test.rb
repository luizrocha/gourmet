require 'test_helper'

class ClienteTest < ActiveSupport::TestCase

  test "Testa atributos obrigatorios" do
    cliente = Cliente.new
    assert !cliente.valid?
    assert cliente.errors.invalid?(:nome)
    assert cliente.errors.invalid?(:categoria)
    
    cliente.nome = "Teste"
    cliente.categoria = "V"
    assert cliente.valid?, "Cliente deveria ser valido #{cliente.errors.inspect}"
  end

  test "Testa nome abaixo de 50 caracteres" do
    cliente = Cliente.new(:categoria => "M")
    cliente.nome = "123456789012345678901234567890123456789012345678901"
    assert !cliente.valid?
    assert_equal "pode ter no máximo 50 caracteres" , cliente.errors.on(:nome)
    
    cliente.nome = "12345678901234567890123456789012345678901234567890"
    assert cliente.valid? , "Cliente deveria ser valido #{cliente.errors.inspect}"
  end

  test "Testa categoria com mais de 2 caracteres" do
    cliente = Cliente.new(:nome => "Teste")
    cliente.categoria = "12"
    assert !cliente.valid?
    
    cliente.categoria = "M"
    assert cliente.valid? , "Cliente deveria ser valido #{cliente.errors.inspect}"
  end

  test "Testa valor numerico no atributo apartamento" do
    cliente = Cliente.new(:nome => "Teste", :categoria => "M")
    cliente.apartamento = "abc123"
    assert !cliente.valid?
    assert_equal "deve ser preenchido com um número", cliente.errors.on(:apartamento)
    
    cliente.apartamento = 704
    assert cliente.valid?, "Cliente deveria ser valido #{cliente.errors.inspect}"
    
    cliente.apartamento = nil
    assert cliente.valid?, "Cliente deveria ser valido #{cliente.errors.inspect}"
  end

  test "Testa valor numerico no atributo bloco" do
    cliente = Cliente.new(:nome => "Teste", :categoria => "M")
    cliente.bloco = "abc123"
    assert !cliente.valid?
    assert_equal "deve ser preenchido com um número", cliente.errors.on(:bloco)
    
    cliente.bloco = 704
    assert cliente.valid?, "Cliente deveria ser valido #{cliente.errors.inspect}"
    
    cliente.bloco = nil
    assert cliente.valid?, "Cliente deveria ser valido #{cliente.errors.inspect}"
  end

  test "Testa valor numerico no atributo limite_credito" do
    cliente = Cliente.new(:nome => "Teste", :categoria => "M")
    cliente.limite_credito = "abc123"
    assert !cliente.valid?
    assert_equal "deve ser preenchido com um número", cliente.errors.on(:limite_credito)
    
    cliente.limite_credito = 70.4
    assert cliente.valid?, "Cliente deveria ser valido #{cliente.errors.inspect}"
    
    cliente.limite_credito = nil
    assert cliente.valid?, "Cliente deveria ser valido #{cliente.errors.inspect}"
  end

  test "Testa valor numerico no atributo saldo" do
    cliente = Cliente.new(:nome => "Teste", :categoria => "M")
    cliente.saldo = "abc123"
    assert !cliente.valid?
    assert_equal "deve ser preenchido com um número", cliente.errors.on(:saldo)
    
    cliente.saldo = 70.4
    assert cliente.valid?, "Cliente deveria ser valido #{cliente.errors.inspect}"
    
    cliente.saldo = nil
    assert cliente.valid?, "Cliente deveria ser valido #{cliente.errors.inspect}"    
  end

  test "Testa categoria (M)orador, (V)isitante e (F)uncionario" do
    cliente = Cliente.new(:nome => "Morador")
    cliente.categoria = "O"
    assert !cliente.valid?
    assert_equal "não pode ser diferente de (M)orador, (V)isitante e (F)uncionario", cliente.errors.on(:categoria)
    
    cliente.categoria = "M"
    assert cliente.valid?, "Cliente deveria ser valido #{cliente.errors.inspect}"
    
    cliente.categoria = "V"
    assert cliente.valid?, "Cliente deveria ser valido #{cliente.errors.inspect}"
    
    cliente.categoria = "F"
    assert cliente.valid?, "Cliente deveria ser valido #{cliente.errors.inspect}"
  end
  
end

=begin
usar_como_cpf :cpf
  
belongs_to :responsavel, :class_name => "Cliente", :foreign_key => :id_responsavel
has_many :dependentes, :class_name => "Cliente", :foreign_key => :id_responsavel

#validates_length_of :bloco, :maximum => 2, :message => "pode ter no máximo 2 caracteres"
#validates_length_of :apartamento, :maximum => 4, :message => "pode ter no máximo 4 caracteres"

t.string :nome, :limit => 50, :null => false
t.integer :bloco
t.integer :apartamento
t.text  :observacao
t.decimal :limite_credito, :precision => 8, :scale => 2
t.decimal :saldo, :null => false, :default => 0, :precision => 8, :scale => 2
t.string :categoria, :null => false, :limit => 1 #(M)orador, (V)isitante e (F)uncionário

t.string :email
t.string :telefone
t.string :telefone_comercial
t.string :telefone_celular
t.string :cpf
t.string :rg
t.string :endereco_comercial

#relacionamento com principal
t.integer :id_responsavel

=end

