# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090826012305) do

  create_table "centro_de_custos", :force => true do |t|
    t.string   "nome"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clientes", :force => true do |t|
    t.string   "nome",               :limit => 50,                                                :null => false
    t.integer  "bloco"
    t.integer  "apartamento"
    t.text     "observacao"
    t.decimal  "limite_credito",                   :precision => 8, :scale => 2
    t.decimal  "saldo",                            :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.string   "categoria",          :limit => 1,                                                 :null => false
    t.string   "email"
    t.string   "telefone"
    t.string   "telefone_comercial"
    t.string   "telefone_celular"
    t.string   "cpf"
    t.string   "rg"
    t.string   "endereco_comercial"
    t.integer  "id_responsavel"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "clientes", ["apartamento"], :name => "index_clientes_on_apartamento"
  add_index "clientes", ["bloco"], :name => "index_clientes_on_bloco"
  add_index "clientes", ["nome"], :name => "index_clientes_on_nome"

  create_table "forma_de_pagamentos", :force => true do |t|
    t.string   "nome"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lancamentos", :force => true do |t|
    t.string   "type"
    t.string   "descricao"
    t.decimal  "valor",                              :precision => 8, :scale => 2, :null => false
    t.datetime "data",                                                             :null => false
    t.integer  "centro_de_custo_id",                                               :null => false
    t.string   "tipo_credito_debito",   :limit => 1,                               :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fornecedor"
    t.string   "numero_nota_fiscal"
    t.integer  "forma_de_pagamento_id"
    t.datetime "data_de_vencimento"
  end

  add_index "lancamentos", ["centro_de_custo_id"], :name => "index_lancamentos_on_centro_de_custo_id"
  add_index "lancamentos", ["data"], :name => "index_lancamentos_on_data"
  add_index "lancamentos", ["forma_de_pagamento_id"], :name => "index_lancamentos_on_forma_de_pagamento_id"

  create_table "pedido_items", :force => true do |t|
    t.integer  "pedido_id",                                    :null => false
    t.integer  "quantidade",                                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "produto_id"
    t.decimal  "valor_total",    :precision => 8, :scale => 2
    t.decimal  "valor_unitario", :precision => 8, :scale => 2
  end

  create_table "pedido_pagamentos", :force => true do |t|
    t.string   "type"
    t.integer  "pedido_id",                                                   :null => false
    t.decimal  "valor",      :precision => 8, :scale => 2,                    :null => false
    t.boolean  "cancelado",                                :default => false, :null => false
    t.integer  "cliente_id"
    t.string   "cartao"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pedido_pagamentos", ["cliente_id"], :name => "index_pedido_pagamentos_on_cliente_id"
  add_index "pedido_pagamentos", ["pedido_id"], :name => "index_pedido_pagamentos_on_pedido_id"

  create_table "pedidos", :force => true do |t|
    t.integer  "numero_mesa"
    t.integer  "quantidade_pessoas"
    t.datetime "data_abertura"
    t.datetime "data_finalizacao"
    t.string   "status",             :limit => 1,                               :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "valor_total",                     :precision => 8, :scale => 2
    t.decimal  "valor_pago_servico",              :precision => 8, :scale => 2
    t.decimal  "valor_pago_total",                :precision => 8, :scale => 2
  end

  create_table "produtos", :force => true do |t|
    t.string   "descricao",             :limit => 50,                    :null => false
    t.string   "fabricante"
    t.string   "referencia_fabricante"
    t.integer  "referencia"
    t.string   "codigo_barras"
    t.decimal  "estoque_minimo"
    t.decimal  "estoque_maximo"
    t.decimal  "valor_venda",                                            :null => false
    t.datetime "data_cadastro"
    t.datetime "data_ultima_alteracao"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unidade_venda_id",                                       :null => false
    t.boolean  "adiciona_taxa_servico",               :default => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "unidade_vendas", :force => true do |t|
    t.string   "sigla"
    t.string   "nome"
    t.boolean  "fracionario"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "usuarios", :force => true do |t|
    t.string   "nome"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
