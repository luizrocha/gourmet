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

ActiveRecord::Schema.define(:version => 20090513040158) do

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

end
