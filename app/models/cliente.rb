class Cliente < ActiveRecord::Base
  
    cattr_reader :per_page
    @@per_page = 9 
    usar_como_cpf :cpf
      
    belongs_to :responsavel, :class_name => "Cliente", :foreign_key => :id_responsavel
    has_many :dependentes, :class_name => "Cliente", :foreign_key => :id_responsavel

    validates_presence_of :nome, :message => "deve ser preenchido"
    validates_length_of :nome, :maximum => 50, :message => "pode ter no máximo 50 caracteres"
    #validates_length_of :bloco, :maximum => 2, :message => "pode ter no máximo 2 caracteres"
    #validates_length_of :apartamento, :maximum => 4, :message => "pode ter no máximo 4 caracteres"
    validates_numericality_of :bloco, :apartamento, :message => "deve ser preenchido com um número"

end
/#
t.string :nome, :limit => 50, :null => false
t.string :bloco, :limit => 3
t.string :apartamento, :limit => 4
t.text  :observacao
t.string :email
t.decimal :limite_credito, :precision => 8, :scale => 2
t.decimal :saldo, :null => false, :default => 0, :precision => 8, :scale => 2
t.string :telefone
t.string :telefone_comercial
t.string :telefone_celular
t.string :cpf
t.string :rg
t.string :endereco_comercial
#/