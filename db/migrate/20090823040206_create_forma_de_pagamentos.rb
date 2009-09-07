class CreateFormaDePagamentos < ActiveRecord::Migration
  def self.up
    create_table :forma_de_pagamentos do |t|
        t.string :nome
        t.timestamps
      end

      dinheiro = FormaDePagamento.create(:nome => "Dinheiro")
      boleto = FormaDePagamento.create(:nome => "Boleto")
      cheque = FormaDePagamento.create(:nome => "Cheque")
      hipercard = FormaDePagamento.create(:nome => "Hipercard Juliana")
      transferencia = FormaDePagamento.create(:nome => "Transferencia Bancária")
      debitoBcoReal = FormaDePagamento.create(:nome => "Cartão Débito BCO Real")
      
  end

  def self.down
    drop_table :forma_de_pagamentos
  end
end