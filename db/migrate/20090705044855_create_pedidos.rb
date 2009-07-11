class CreatePedidos < ActiveRecord::Migration
  def self.up
    create_table :pedidos do |t|
      t.integer :numero_mesa
      t.integer :quantidade_pessoas
      t.timestamp :data_abertura
      t.timestamp :data_finalizacao
      t.string :status, :null => false, :limit => 1 #(A)berto, (F)inalizado e (C)ancelado
      t.decimal :valor_total, :null => true, :precision => 8, :scale => 2
      t.decimal :valor_pago_servico, :null => true, :precision => 8, :scale => 2
      t.decimal :valor_pago_total, :null => true, :precision => 8, :scale => 2
      t.timestamps
    end
    
    add_index :pedidos, :status
    add_index :pedidos, :data_finalizacao
    
  end

  def self.down
    remove_index :pedidos, :status
    remove_index :pedidos, :data_finalizacao
    drop_table :pedidos    
  end
end
