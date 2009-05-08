jQuery(document).ready(function() {
	//F4 - Alterna entre modo codigos-barras/produto por descricao
    jQuery(document).bind('keydown', 'f6',function (evt){ 
		var visibility_descricao = jQuery("#selecao-produto-busca-item-descricao").css("visibility");
		var visibility_codbarras = jQuery("#selecao-produto-busca-item-codigo-barras").css("visibility");
		
		if (visibility_descricao == "hidden") {
			jQuery("#selecao-produto-busca-item-descricao").css("visibility", "visible");						
			jQuery("#selecao-produto-busca-item-codigo-barras").css("visibility", "hidden");
			jQuery("#compras_quantidade_item").bind('keydown', 'return',function (evt){ 
				jQuery("#compras_novo_item").focus().select();
				return false;
			});
			jQuery("#compras_novo_item").focus().select();
		} else if (visibility_codbarras == "hidden") {
			jQuery("#selecao-produto-busca-item-descricao").css("visibility", "hidden");						
			jQuery("#selecao-produto-busca-item-codigo-barras").css("visibility", "visible");
			jQuery("#compras_quantidade_item").bind('keydown', 'return',function (evt){ 
				jQuery("#compras_codigo_barras_item").focus().select();
				return false;
			});
			jQuery("#compras_codigo_barras_item").focus().select();
		}
		return false;
	});		
	
	//F5 - Foco no campo Quantidade Item
    jQuery(document).bind('keydown', 'f7',function (evt){ 
		jQuery("#compras_quantidade_item").val("1");
		jQuery("#compras_codigo_barras_item").val("");
		jQuery("#compras_novo_item").val("");
		jQuery("#compras_quantidade_item").focus().select();	
	});
	
	//Handle de submit no campo codigo_barras para adicionar produto
	jQuery("#compras_codigo_barras_item").bind('keydown', 'return',function (evt){ 
			codigo_barras  = jQuery("#compras_codigo_barras_item").val();
			quantidade = jQuery("#compras_quantidade_item").val();
			new Ajax.Request('/loja/adiciona_produto_lista_compras', {asynchronous:true, evalScripts:true, method:'post', parameters:'authenticity_token=18694f0f8b9836a93f2b1d22e2d09ca925c87b3c&codigo_barras_item='+codigo_barras+'&quantidade_item='+quantidade}); 
			jQuery("#compras_codigo_barras_item").val("");
			jQuery("#compras_codigo_barras_item").focus().select();
			jQuery("#compras_quantidade_item").val("1");
			return false;
	});
	
	//Inicializacao com campo codigo barras visivel e produto descricao invisivel.
	//jQuery("#selecao-produto-busca-item-descricao").css("visibility", "hidden");
	//Inicializacao do foco no campo codigo de barras.
	jQuery("#compras_codigo_barras_item").focus().select();
	//Mapeamento Inicial da tecla ENTER no campo Quantidade transfere foco para campo Codigo Barras
	jQuery("#compras_quantidade_item").bind('keydown', 'return',function (evt){ 
		jQuery("#compras_codigo_barras_item").focus().select();
		return false;
	});
	
	
	//jQuery("#tipo-pagamento-accordion").accordion();
});