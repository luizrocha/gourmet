class LojaController < ApplicationController
  protect_from_forgery :only => [:create, :update, :destroy] 
  before_filter :busca_lista_compras, :except => :esvazia_lista_compras


  def index
  end
  
  def autocomplete_novo_item
    @produtos = Produto.find(:all, :conditions => "descricao like '#{params[:compras][:novo_item]}%'", :order => "descricao")
    render :layout=>false
  end

  def adiciona_produto_lista_compras
    produto = Produto.find_by_descricao(params[:descricao_item]) if params[:descricao_item]
    produto = Produto.find_by_codigo_barras(params[:compras][:codigo_barras_item]) if params[:compras]
    quantidade = params[:quantidade_item]
    if !produto then redirect_to_index end
    @item_corrente = @listacompras.adiciona_produto(produto, quantidade)
    respond_to do |format|
      format.js 
    end
  end

  def esvazia_lista_compras
    session[:listacompras] = nil
    respond_to do |format|
      format.js if request.xhr?
      format.html {redirect_to_index}
    end
  end

private
  def busca_lista_compras
    @listacompras = (session[:listacompras] ||= ListaCompras.new)
  end
  
  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => 'index'
  end

end
