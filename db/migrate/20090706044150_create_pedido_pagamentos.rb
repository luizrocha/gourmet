class CreatePedidoPagamentos < ActiveRecord::Migration
  def self.up
    create_table :pedido_pagamentos do |t|
      t.string  :type

      #Atributos Comuns
      t.integer :pedido_id, :null => false, :options => "CONSTRAINT fk_pedido_pagamentos_pedido REFERENCES pedidos(id)"
      t.decimal :valor, :null => false, :precision => 8, :scale => 2
      t.boolean :cancelado, :null => false, :default => false

      #Atributo Pagamentos em Conta (Vinculado ao Cliente)
      t.integer :cliente_id, :null => true, :options => "CONSTRAINT fk_pedido_pagamentos_cliente REFERENCES clientes(id)"

      #Atributo Pagamentos em Cartao
      t.string :cartao, :null => true

      t.timestamps
    end
    add_index :pedido_pagamentos, :pedido_id
    add_index :pedido_pagamentos, :cliente_id
  end

  def self.down
    remove_index :pedido_pagamentos, :pedido_id
    remove_index :pedido_pagamentos, :cliente_id
    drop_table :pedido_pagamentos
  end
end
