module LojaHelper
  
  def item_esta_selecionado_para_calculo_parcial(item_id)
    puts("Verificando no helper se item esta marcado para selecao! ID: "+item_id.to_s)
    items_selecionados = session[:items_selecionados]
    puts("Array Items Selecionados: "+items_selecionados.to_s)
    return (items_selecionados and items_selecionados.has_key?(item_id.to_s) )
  end
  
end
