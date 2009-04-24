jQuery(document).ready(function() {
    //$(document).bind('keydown', {combi:'Ctrl+E',disableinInput: true},function(){window.alert("hello");}); 
    jQuery(document).bind('keydown', 'f4',function (evt){ 
		var visibility_descricao = jQuery("#selecao-produto-busca-item-descricao").css("visibility");
		var visibility_codbarras = jQuery("#selecao-produto-busca-item-codigo-barras").css("visibility");
		
		if (visibility_descricao == "hidden") {
			jQuery("#selecao-produto-busca-item-descricao").css("visibility", "visible");						
			jQuery("#selecao-produto-busca-item-codigo-barras").css("visibility", "hidden");
			jQuery("#compras_quantidade_item").bind('keydown', 'return',function (evt){ 
				jQuery("#compras_novo_item").focus();
			});			
		} else if (visibility_codbarras == "hidden") {
			jQuery("#selecao-produto-busca-item-descricao").css("visibility", "hidden");						
			jQuery("#selecao-produto-busca-item-codigo-barras").css("visibility", "visible");
			jQuery("#compras_quantidade_item").bind('keydown', 'return',function (evt){ 
				jQuery("#compras_codigo_barras_item").focus();
				return false;
			});
		}
		jQuery("#compras_quantidade_item").focus().select();
	});
	jQuery("#compras_quantidade_item").bind('keydown', 'return',function (evt){ 
		jQuery("#compras_novo_item").focus();
	});			
	jQuery("#compras_codigo_barras_item").bind('keydown', 'return',function (evt){ 
		jQuery("#selecao-produto-busca-item-codigo-barras > form").submit();
		jQuery("#compras_quantidade_item").focus().select();
		return false;
	});
	jQuery("#selecao-produto-busca-item-codigo-barras").css("visibility", "hidden");
	jQuery("#compras_quantidade_item").focus().select();
	
	
	
});