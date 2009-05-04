class CreateProdutos < ActiveRecord::Migration
  def self.up
    create_table :produtos do |t|
      t.string :descricao, :limit => 50, :null => false
      t.string :fabricante
      t.string :referencia_fabricante
      t.integer :referencia
      t.string :codigo_barras 
      t.decimal :estoque_minimo, :precision => 10, :scale => 2
      t.decimal :estoque_maximo, :precision => 10, :scale => 2
      t.decimal :valor_venda, :precision => 8, :scale => 2, :null => false
      t.string :unidade_venda, :limit => 2, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :produtos
  end
end
