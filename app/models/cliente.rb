class Cliente < ActiveRecord::Base  
    cattr_reader :per_page
    @@per_page = 8 
    usar_como_cpf :cpf
      
    belongs_to :responsavel, :class_name => "Cliente", :foreign_key => :id_responsavel
    has_many :dependentes, :class_name => "Cliente", :foreign_key => :id_responsavel

    validates_presence_of :nome, :categoria, :message => "deve ser preenchido"
    validates_length_of :nome, :maximum => 50, :message => "pode ter no máximo 50 caracteres"
    validates_length_of :categoria, :maximum => 1, :message => "pode ter no máximo 1 caractere"
    validates_numericality_of :bloco, :apartamento, :limite_credito, :saldo, :allow_nil => true, :message => "deve ser preenchido com um número"
    validates_inclusion_of :categoria, :in => %w( M V F ), :message => "não pode ser diferente de (M)orador, (V)isitante e (F)uncionario"
    #validates_length_of :bloco, :maximum => 2, :message => "pode ter no máximo 2 caracteres"
    #validates_length_of :apartamento, :maximum => 4, :message => "pode ter no máximo 4 caracteres"
        
end
