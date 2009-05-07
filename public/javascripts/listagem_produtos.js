jQuery(document).ready(function() {
	//*********************************************************************
	//		CONFIGURA EXIBICAO PRODUTO COM DUPLO-CLIQUE NA LINHA DO PRODUTO
	//						
	//*********************************************************************
	jQuery("table tr").dblclick(function(){
		jQuery("td:first > form",this).submit();
	});
	
	//*********************************************************************
	//					AJUSTES INICIAIS
	//						
	//*********************************************************************
	
	//Foco inicial no autocomplete Descricao
	jQuery("#produto_descricao").focus().select();	

})