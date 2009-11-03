class CreateUsuarios < ActiveRecord::Migration
  def self.up
    create_table :usuarios do |t|
      t.string :nome
      t.string :hashed_password
      t.string :salt

      t.timestamps
    end
    
    usuarioMaster = Usuario.new()
    usuarioMaster.password = "master"
    usuarioMaster.nome = "master"
    usuarioMaster.save!
  end

  def self.down
    drop_table :usuarios
  end
end
