module ClientesHelper
  
	def adiciona_dependente_link(nome)
		link_to_function nome do |page|
	  	page.insert_html :bottom, :tabela_dependentes, :partial => 'cliente_dependentes', :object => Cliente.new
		end
	end

	def fields_for_cliente(cliente, &block)
		prefix = cliente.new_record? ? 'new' : cliente.id
		fields_for("cliente[dependentes][]", cliente, &block)
		#{prefix}_item_attributes
	end
  
  
end
