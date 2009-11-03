class CreateLancamentos < ActiveRecord::Migration
  def self.up
    #Cria tabela de Lancamentos
    create_table :lancamentos do |t|
      #Atributos Comuns
      t.string :descricao, :null => true
      t.decimal :valor, :null => false, :precision => 8, :scale => 2
      t.datetime :data, :null => false
      t.string :tipo_credito_debito, :null => false, :limit => 1 #(C)redito, (D)ebito
      t.string :status, :null => false, :limit => 1 #(P)endente , (C)onfirmado
      t.timestamps
      
    end
    add_index :lancamentos, :data    
  end

  def self.down
    remove_index :lancamentos, :data
    drop_table :lancamentos
  end
  
end