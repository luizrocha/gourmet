class AddFormaPagamentoCartao < ActiveRecord::Migration
  def self.up
    change_table :forma_de_pagamentos do |t|
      #Adiciona coluna para distinção do tipo
      t.string  :type

      #Adiciona Tipo Cartão
      t.string :tipoCartao, :null => true, :limit => 1 #(D)ebito, (C)redito
      t.string :numeroCartao, :null => true
      t.integer :dia_vencimento, :null => true
      t.integer :dia_encerramento_fatura, :null => true
    end
  end

  def self.down
    remove_column :forma_de_pagamentos, :type
    remove_column :forma_de_pagamentos, :tipoCartao
    remove_column :forma_de_pagamentos, :numeroCartao
    remove_column :forma_de_pagamentos, :dia_vencimento
    remove_column :forma_de_pagamentos, :dia_encerramento_fatura    
  end
  
end
