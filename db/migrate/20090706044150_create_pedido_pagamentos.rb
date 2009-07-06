class CreatePedidoPagamentos < ActiveRecord::Migration
  def self.up
    create_table :pedido_pagamentos do |t|
      t.integer :pedido_id, :null => false, :options => "CONSTRAINT fk_pedido_pagamentos_pedido REFERENCES pedidos(id)"
      t.integer :quantidade, :null => false
      t.decimal :valor_total, :null => false, :precision => 8, :scale => 2
      t.timestamps
    end
    add_index :pedido_pagamentos, :pedido_id
  end

  def self.down
    remove_index :pedido_pagamentos, :pedido_id
    drop_table :pedido_pagamentos
  end
end
