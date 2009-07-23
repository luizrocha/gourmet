require 'test_helper'

class ProdutoTest < ActiveSupport::TestCase

  test "Testa atributos obrigatorios nao definidos" do
    produto = Produto.new
    assert !produto.valid?
    assert produto.errors.invalid?(:unidade_venda_id)
    assert produto.errors.invalid?(:descricao)
    assert produto.errors.invalid?(:valor_venda)    
  end

  test "Testa numero negativo no valor de venda que deve ser positivo" do
    produto = Produto.new(:descricao => "XXX", :unidade_venda_id =>"0", :valor_venda => -1)
    assert !produto.valid?
    assert_equal "deve ser no mínimo de 1 centavo" , produto.errors.on(:valor_venda)
  end
  
  test "Testa numero abaixo de 1 centavo no valor de venda que deve ser no minimo 1 centavo" do
    produto = Produto.new(:descricao => "XXX", :unidade_venda_id =>"0", :valor_venda => 0.001)
    assert !produto.valid?
    assert_equal "deve ser no mínimo de 1 centavo" , produto.errors.on(:valor_venda)
  end

  test "Testa valor de venda positivo acima de 1 centavo" do
    produto = Produto.new(:descricao => "XXX", :unidade_venda_id =>"1", :valor_venda => "1")
    assert produto.valid? , "Produto deveria ser valido #{produto.errors.inspect}"  
  end
  
  test "Testa valor nao numerico na variavel valor_venda que somente deve aceitar numeros" do
    produto = Produto.new(:descricao => "XXX", :unidade_venda_id =>"1", :valor_venda => "abc")
    assert !produto.valid?
    
    produto.valor_venda = "1"
    assert produto.valid? , "Produto deveria ser valido #{produto.errors.inspect}"  
  end

  test "Testa valor nao numerico na variavel estoque_minimo que somente deve aceitar numeros" do
    produto = Produto.new(:descricao => "XXX", :unidade_venda_id =>"1", :valor_venda => "1")
    produto.estoque_minimo = "abc"
    assert !produto.valid?
    assert_equal "deve ser preenchido com um número válido" , produto.errors.on(:estoque_minimo)
    
    produto.estoque_minimo = "1"
    assert produto.valid? , "Produto deveria ser valido #{produto.errors.inspect}"  
  end

  test "Testa valor nao numerico na variavel estoque_maximo que somente deve aceitar numeros" do
    produto = Produto.new(:descricao => "XXX", :unidade_venda_id =>"1", :valor_venda => "1")
    produto.estoque_maximo = "abc"
    assert !produto.valid?
    assert_equal "deve ser preenchido com um número válido" , produto.errors.on(:estoque_maximo)
    
    produto.estoque_maximo = "1"
    assert produto.valid? , "Produto deveria ser valido #{produto.errors.inspect}"  
  end
  
  test "Testa descricao com mais de 50 caracteres" do
    produto = Produto.new(:unidade_venda_id =>"1", :valor_venda => "1")
    produto.descricao = "123456789012345678901234567890123456789012345678901"
    assert !produto.valid?
    assert_equal "pode ter no máximo 50 caracteres" , produto.errors.on(:descricao)
    #puts (produto.errors.full_messages)    
    
    produto.descricao = "12345678901234567890123456789012345678901234567890"
    assert produto.valid? , "Produto deveria ser valido #{produto.errors.inspect}"  
  end
  
  test "Testa codigo-de-barras que deve ser unico" do
    produto1 = Produto.new(:descricao => "XXX", :unidade_venda_id =>"1", :valor_venda => "1")
    produto1.codigo_barras = "99383498394"
    assert produto1.valid? , "Produto deveria ser valido #{produto1.errors.inspect}"  
    
    produto2 = Produto.new(:descricao => "YYY", :unidade_venda_id =>"1", :valor_venda => "2")
    #Codigo de barras do produto 2 ja existe num fixture para simular o erro
    produto2.codigo_barras = "423424543"
    assert !produto2.valid?
    assert_not_nil produto2.errors.on(:codigo_barras)
  end
  
end