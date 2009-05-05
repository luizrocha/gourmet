// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
jQuery(document).ready(function() {
	//*********************************************************************
	//					DEFINE NAVEGACOES ENTRE CAMPOS
	//						Tecla ENTER to Next Field
	//*********************************************************************
	
	//Descricao To produto_unidade_venda
	jQuery("#produto_descricao").bind('keydown', 'return',function (evt){ 
		jQuery("#produto_unidade_venda_id").focus().select();
		return false;
	});
	
	//Descricao To produto_unidade_venda
	jQuery("#produto_descricao").bind('keydown', 'tab',function (evt){ 
		jQuery("#produto_unidade_venda_id").focus().select();
		return false;
	});
		
	//Unidade Venda TO Valor Venda
	jQuery("#produto_unidade_venda_id").bind('keydown', 'return',function (evt){ 
		jQuery("#produto_valor_venda").focus().select();
		return false;
	});
	
	//Valor Venda TO Codigo Barras
	jQuery("#produto_valor_venda").bind('keydown', 'return',function (evt){ 
		jQuery("#produto_codigo_barras").focus().select();
		return false;
	});	
		
	//Codigo Barras To EstoqueMinimo
	jQuery("#produto_codigo_barras").bind('keydown', 'return',function (evt){ 
		jQuery("#produto_estoque_minimo").focus().select();
		return false;
	});
	
	//Estoque Minimo TO Estoque Maximo
	jQuery("#produto_estoque_minimo").bind('keydown', 'return',function (evt){ 
		jQuery("#produto_estoque_maximo").focus().select();
		return false;
	});
	
	//Estoque Maximo TO Fabricante
	jQuery("#produto_estoque_maximo").bind('keydown', 'return',function (evt){ 
		jQuery("#produto_fabricante").focus().select();
		return false;
	});	
	
	//Fabricante TO Referencia Fabricante
	jQuery("#produto_fabricante").bind('keydown', 'return',function (evt){ 
		jQuery("#produto_referencia_fabricante").focus().select();
		return false;
	});	

	//*********************************************************************
	//					AJUSTES DIFERENCIAR SUBMETER VIA ENTER OU BOTAO
	//						
	//*********************************************************************

	//Se usuário digitar ENTER no último campo (Referencia Fabricante), o produto
	//será criado e a tela de cadastro de novo produto será exibida.
	//Se o usuário clicar no botão enviar do formulário, o produto será criado
	//e a tela de listagem de produtos será exibida.
	jQuery("#produto_referencia_fabricante").bind('keydown', 'return',function (evt){ 
		jQuery("#produto_submit").val("Criar-ModoRapido");
		return true;
	});
	
	
	//*********************************************************************
	//					AJUSTES INICIAIS
	//						
	//*********************************************************************
	
	//Foco inicial em Descricao no caso de novo Produto.
	if ( jQuery("#produto_id").length == 0) {
		jQuery("#produto_descricao").focus().select();	
	}
	

})