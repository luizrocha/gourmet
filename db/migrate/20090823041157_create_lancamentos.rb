class CreateLancamentos < ActiveRecord::Migration
  def self.up
    create_table :lancamentos do |t|
      t.string  :type
      
      #Atributos Comuns
      t.string :descricao, :null => true
      t.decimal :valor, :null => false, :precision => 8, :scale => 2
      t.datetime :data, :null => false
      t.integer :centro_de_custo_id, :null => false, :options => "CONSTRAINT fk_lancamento_centro_de_custos REFERENCES centro_de_custos(id)"
      t.string :tipo_credito_debito, :null => false, :limit => 1
      t.timestamps

      #Lancamentos_Compras
      t.string :fornecedor, :null => true
      t.string :numero_nota_fiscal, :null => true
      t.integer :forma_de_pagamento_id, :null => true, :options => "CONSTRAINT fk_lancamento_forma_de_pagamentos REFERENCES forma_de_pagamentos(id)"
      t.datetime :data_de_vencimento, :null => true      
    end
    
    add_index :lancamentos, :forma_de_pagamento_id
    add_index :lancamentos, :centro_de_custo_id
    add_index :lancamentos, :data
    
  end

  def self.down
    remove_index :lancamentos, :forma_de_pagamento_id
    remove_index :lancamentos, :centro_de_custo_id
    remove_index :lancamentos, :data
    drop_table :lancamentos
  end
  
end