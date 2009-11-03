class CreateCompras < ActiveRecord::Migration
  def self.up
    #Cria tabela de Compras
    create_table :compras, :force => true do |t|
      t.date   :data, :null => false
      t.string :fornecedor, :null => true
      t.string :numero_nota_fiscal, :null => true
      t.string :descricao, :null => true
      t.integer :centro_de_custo_id, :null => false, :options => "CONSTRAINT fk_lancamento_centro_de_custos REFERENCES centro_de_custos(id)"
      t.timestamps
    end
    
    #Adiciona colunas para criacao do tipo LancamentoCompra
    change_table :lancamentos do |t|
      #Adiciona coluna para distinção do tipo
      t.string  :type

      #adiciona colunas para tipo Lancamento_Compra
      t.integer :forma_de_pagamento_id, :null => true, :options => "CONSTRAINT fk_lancamento_forma_de_pagamentos REFERENCES forma_de_pagamentos(id)"
      t.datetime :data_de_vencimento, :null => true     
      t.integer :compra_id, :null => true, :options => "CONSTRAINT fk_lancamento_compras REFERENCES compras(id)"
    end
    
    #Indices
    add_index :lancamentos, :forma_de_pagamento_id
    add_index :compras, :centro_de_custo_id
  end

  def self.down
    #Remove Indices
    remove_index :lancamentos, :forma_de_pagamento_id
    remove_index :compras, :centro_de_custo_id
    
    #Remove coluna
    remove_column :lancamentos, :type
    remove_column :lancamentos, :forma_de_pagamento_id
    remove_column :lancamentos, :data_de_vencimento
    remove_column :lancamentos, :compra_id

    drop_table :compras
  end
end
