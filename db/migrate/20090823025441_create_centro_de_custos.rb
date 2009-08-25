class CreateCentroDeCustos < ActiveRecord::Migration
  def self.up
    create_table :centro_de_custos do |t|
      t.string :nome
      t.timestamps
    end
    
    alimentos = CentroDeCusto.create(:nome => "Alimentos")
    bebidas = CentroDeCusto.create(:nome => "Bebidas")
    mercadinho = CentroDeCusto.create(:nome => "Mercadinho")
  end

  def self.down
    drop_table :centro_de_custos
  end
end