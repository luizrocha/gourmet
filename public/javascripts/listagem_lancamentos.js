jQuery(document).ready(function() {
	//*********************************************************************
	//		CONFIGURA EXIBICAO PRODUTO COM DUPLO-CLIQUE NA LINHA DO PRODUTO
	//						
	//*********************************************************************
	jQuery("table tr").dblclick(function(){
		jQuery("td:first > form",this).submit();
	});
	
	5
	
	//*********************************************************************
	//	CONFIGURA EXIBICAO NOME FORNECEDOR NO CLIQUE NA LINHA DO LANCAMENTO
	//						
	//*********************************************************************
	jQuery("#valor",jQuery("table tr")).hover(
      function(){
        jQuery("span", this).show();
      }, 
      function () {
        jQuery("span", this).hide();
      }
    );
    
})