class CreateUnidadeVendas < ActiveRecord::Migration
  def self.up
    create_table :unidade_vendas do |t|
      t.string :sigla
      t.string :nome
      t.boolean :fracionario
      t.timestamps
    end
    
    #Adiciona Coluna Referencia
    add_column :produtos, :unidade_venda_id, :integer
    
    unitario = UnidadeVenda.create(:nome => "Unitário", :sigla => "UN", :fracionario => false)
    kg = UnidadeVenda.create(:nome => "Kilo", :sigla => "KG", :fracionario => true)
    litro = UnidadeVenda.create(:nome => "Litro", :sigla => "LT", :fracionario => true)
     
    #Migra os dados da antiga coluna unidade_venda para a nova tabela
    Produto.find(:all).each do |produto|
      produto.unidade_venda = unitario
      produto.save!
    end
    
    change_column :produtos, :unidade_venda_id, :integer, :null => false
    remove_column :produtos, :unidade_venda
    #execute %Q[alter table orders add constraint fk_order_payment_type foreign key (payment_type_id) references payment_types(id)]    
  end

  def self.down
    drop_table :unidade_vendas    
    remove_column :produtos, :unidade_venda_id
  end
end
