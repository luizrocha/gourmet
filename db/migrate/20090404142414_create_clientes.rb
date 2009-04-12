class CreateClientes < ActiveRecord::Migration
  def self.up
    create_table :clientes do |t|
      
      t.string :nome, :limit => 50, :null => false
      t.integer :bloco
      t.integer :apartamento
      t.text  :observacao
      t.decimal :limite_credito, :precision => 8, :scale => 2
      t.decimal :saldo, :null => false, :default => 0, :precision => 8, :scale => 2
      t.string :categoria, :null => false, :limit => 1 #(M)orador, (V)isitante e (F)uncionário
      
      t.string :email
      t.string :telefone
      t.string :telefone_comercial
      t.string :telefone_celular
      t.string :cpf
      t.string :rg
      t.string :endereco_comercial

      #relacionamento com principal
      t.integer :id_responsavel

      t.timestamps
    end
    
    add_index :clientes, :nome
    add_index :clientes, :bloco
    add_index :clientes, :apartamento
  end

  def self.down
    remove_index :clientes, :nome
    remove_index :clientes, :bloco
    remove_index :clientes, :apartamento
    drop_table :clientes
  end
end

