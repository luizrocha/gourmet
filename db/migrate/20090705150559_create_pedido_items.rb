class CreatePedidoItems < ActiveRecord::Migration
  def self.up
    create_table :pedido_items do |t|
      t.integer :produto_id, :null => true, :options => "CONSTRAINT fk_pedido_item_produtos REFERENCES produtos(id)"
      t.integer :pedido_id, :null => false, :options => "CONSTRAINT fk_pedido_item_pedido REFERENCES pedidos(id)"
      t.integer :quantidade, :null => false
      t.decimal :valor_total, :null => true, :precision => 8, :scale => 2
      t.decimal :valor_unitario, :null => true, :precision => 8, :scale => 2
      t.timestamps
    end
    add_index :pedido_items, :pedido_id
  end

  def self.down
    remove_index :pedido_items, :pedido_id
    drop_table :pedido_items
  end
end
