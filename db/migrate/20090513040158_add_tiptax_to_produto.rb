class AddTiptaxToProduto < ActiveRecord::Migration
  def self.up
    add_column :produtos, :adiciona_taxa_servico, :boolean, :default => false
  end

  def self.down
    remove_column :produtos, :adiciona_taxa_servico
  end
end
