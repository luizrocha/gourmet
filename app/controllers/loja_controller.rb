class LojaController < ApplicationController
  protect_from_forgery :only => [:create, :update, :destroy] 
  before_filter :busca_lista_compras, :except => :esvazia_lista_compras


  def index
  end
  
  def autocomplete_novo_item
    @produtos = Produto.find(:all, :conditions => "descricao like '#{params[:compras][:novo_item]}%'", :order => "descricao")
    if (!@produtos || @produtos.length == 0) then
      @produtos = Produto.find(:all, :conditions => "codigo_barras = '#{params[:compras][:novo_item]}'", :order => "descricao")
    end
    render :layout=>false
  end

  def adiciona_produto_lista_compras
    flash[:notice] = nil
    produto = Produto.find_by_descricao(params[:descricao_item]) if params[:descricao_item]
    produto = Produto.find_by_codigo_barras(params[:codigo_barras_item]) if params[:codigo_barras_item]
    quantidade = BigDecimal.new(params[:quantidade_item])
    begin
      validar_Item_Venda(quantidade, produto)
      @item_corrente = @listacompras.adiciona_produto(produto, quantidade)
    rescue Exception => e:
      flash[:notice] = e.to_s 
    end
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
    @listacompras = (session[:listacompras] ||= Compras.new)
  end
  
  def validar_Item_Venda(quantidade, produto)
     if (!produto) then
       raise "Produto não encontrado!"
     end
     if ( quantidade < 0) then
       raise "Quantidade não pode ser negativa!"
     end
     q,m = quantidade.divmod(BigDecimal("1")) 
     produto_permite_fracao = produto.permitidaVendaFracionaria
     if (m != 0 && !produto_permite_fracao ) then
       raise "Venda fracionaria não permitida para este produto!"
     end
  end  
  
  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => 'index'
  end

end
