jQuery(document).ready(function() {
	//*********************************************************************
	//					 MAPEAMENTOS TECLAS
	//						
	//*********************************************************************	
	//F3 - Foco no campo Quantidade Item
    jQuery(document).bind('keydown', 'alt+f3',function (evt){ 
		jQuery("#compras_quantidade_item").val("1");
		jQuery("#compras_codigo_barras_item").val("");
		jQuery("#compras_novo_item").val("");
		jQuery("#compras_quantidade_item").focus().select();
		return false;
	});
	
	//F8 - Exibe/Esconde DIV Insercao de Pagamentos
    jQuery(document).bind('keydown', 'alt+f8',function (evt){ 
		var visibility_adicionaPagamento = jQuery("#adiciona_pagamento").css("visibility");
		if (visibility_adicionaPagamento == "hidden") {
			exibeDivAdicionarPagamento();
		} else {
			escondeDivAdicionarPagamento();
		}
	});	

	//ENTER (no campo quantidade) - Transfere foco para campo busca produto.
	jQuery("#compras_quantidade_item").livequery('keydown', function(evt){
		switch (evt.keyCode) {
		  //Se tecla for ENTER
		  case 13: 
			modo_edicao = jQuery("#compras_modo_edicao").val();
			//Se estiver em modo de edicao, conclui edicao e atualiza produto
			if (modo_edicao == 'true') {
				adicionaItemCarrinho();
			} else {
			//Caso contrario, transfere foco para campo descricao
				jQuery("#compras_novo_item").focus().select();
				return true;
			}
		  	break;
		  default: return true;
		}
	});	
	
	//ENTER (no campo busca produto) - Se for numerico, adiciona por codigo barras, caso contrario, autocomplete
	jQuery("#compras_novo_item").livequery('keydown', function(evt){
		switch (evt.keyCode) {
		  //Se tecla for ENTER
		  case 13: 
			adicionaItemCarrinho();
		  return true;

		  //Para qualquer outra tecla diferente de ENTER, tratativa normal (devolve handler)
		  default: return true;
		}			
	});

	//ENTER (no campo valor pagamento) - Transfere focus para complemento, dependendo do tipo do pagamento
	jQuery("#pagamento_valor").bind('keydown', 'return', function(evt) {
		tipo = jQuery("#pagamento_tipo").val();
		valor = jQuery("#pagamento_valor").val();
		if (tipo == "Dinheiro") {
			jQuery("#pagamento_montante").focus().select();
		} else if (tipo == "Cartao") {
		} else if (tipo == "Conta") {
		} else if (tipo == "PrePago") {
		}
		return false;		
	});
	
	//KEYUP (no campo montante) - Realiza Calculo de Troco e Preenche Campo Troco
	jQuery("#pagamento_montante").bind('keyup', function(evt) {
		valor = jQuery("#pagamento_valor").val().replace(",",".");
		montante = jQuery("#pagamento_montante").val().replace(",",".");
		troco =  (valor - montante) * -1 ;
		if ( troco > 0 ) {
			jQuery("#pagamento_troco").val(troco);
		} else {
			jQuery("#pagamento_troco").val("0,00");
		}
	});

	//*********************************************************************
	//					MAPEAMENTO BOTOES
	//						
	//*********************************************************************

	//ADICIONA ACAO BOTAO ISERIR/ATUALIZAR CARRINHO
	jQuery("#botao_adicionar_item").live('click', function() {
		adicionaItemCarrinho();
	});

	//ADICIONA ACAO BOTAO INSERIR PAGAMENTO
	jQuery("#botao_adicionar_pagamento").live('click', function() {
		exibeDivAdicionarPagamento();
		return true;
	});

	//ADICIONA ACAO BOTAO CONFIRMAR INSERCAO PAGAMENTO
	jQuery("#botao_adiciona_pagamento_submit").live('click', function() {
		escondeDivAdicionarPagamento();
		return true;
	});

	//ADICIONA ACAO BOTAO INSERIR PAGAMENTO
	jQuery("#botao_encerrar_compra").live('click', function() {
		exibeDivAdicionarPagamento();
		return true;	
	});
	
	jQuery("#botao_adiciona_pagamento_cancelar").live('click', function() {
		escondeDivAdicionarPagamento();
		return true;	
	});
	

	//*********************************************************************
	//					MAPEAMENTO EVENTOS
	//						
	//*********************************************************************

 	//Click nos tipos pagamentos exibe suas respectivas divs, esconde as outras e reseta os campos
	jQuery("#pagamento_tipo").bind('click', function(evt){
		tipo = jQuery("#pagamento_tipo").val();
		if (tipo == "Dinheiro") {
			jQuery("#pagamento_complementos").css("visibility", "visible");
			jQuery(".pagamento_complemento").css("visibility", "hidden");	
			jQuery("#pagamento_complemento_dinheiro").css("visibility", "visible");			
		} else if (tipo == "Cartao") {
			jQuery("#pagamento_complementos").css("visibility", "visible");
			jQuery(".pagamento_complemento").css("visibility", "hidden");
			jQuery("#pagamento_complemento_cartao").css("visibility", "visible");			
		} else if (tipo == "Conta") {
			jQuery("#pagamento_complementos").css("visibility", "visible");		
			jQuery(".pagamento_complemento").css("visibility", "hidden");
			jQuery("#pagamento_complemento_conta").css("visibility", "visible");
		} else if (tipo == "PrePago") {
			jQuery("#pagamento_complementos").css("visibility", "visible");		
			jQuery(".pagamento_complemento").css("visibility", "hidden");
			jQuery("#pagamento_complemento_prepago").css("visibility", "visible");
		}
	});
	jQuery("#pagamento_tipo").change(function(){
		jQuery("#pagamento_valor").focus().select();	
	});
	
	//*********************************************************************
	//					AJUSTES INICIAIS
	//						
	//*********************************************************************
	
	//Foco inicial no campo busca produto.
	jQuery("#compras_novo_item").focus().select();
	
	//Esconde inicialmente DIV insercao pagamentos.
	jQuery("#adiciona_pagamento").css("visibility", "hidden");
	jQuery("#pagamento_complementos").css("visibility", "hidden");
	
	//Aplica formatacao valor monetario nos campos
	jQuery('#pagamento_valor').priceFormat({
	    prefix: '',
	    centsSeparator: ',',
	    thousandsSeparator: '.'
	});
	jQuery('#pagamento_montante').priceFormat({
	    prefix: '',
	    centsSeparator: ',',
	    thousandsSeparator: '.'
	});
	jQuery('#pagamento_troco').priceFormat({
	    prefix: '',
	    centsSeparator: ',',
	    thousandsSeparator: '.'
	});
	
});

function exibeDivAdicionarPagamento() {
	jQuery("#adiciona_pagamento").css("visibility", "visible");
	jQuery("#pagamento_tipo").val("Dinheiro");
	jQuery("#pagamento_complementos").css("visibility", "visible");
	jQuery(".pagamento_complemento").css("visibility", "hidden");	
	jQuery("#pagamento_complemento_dinheiro").css("visibility", "visible");	
	valor = jQuery("#resumo_pagamento_restante").text().replace("R$","");
	jQuery("#pagamento_valor").val(valor);
	jQuery("#pagamento_valor").focus().select();
	jQuery("#pagamento_montante").val("");
	jQuery("#pagamento_troco").val("");
	//Esconde selecao pagamento e listagem produtos
	jQuery("#selecao-produto").css("visibility", "hidden");
	jQuery("#listagem-compras").css("visibility", "hidden");	
}

function escondeDivAdicionarPagamento() {
	jQuery("#adiciona_pagamento").css("visibility", "hidden");
	jQuery(".pagamento_complemento").css("visibility", "hidden");
	//Exibe selecao pagamento e listagem produtos
	jQuery("#selecao-produto").css("visibility", "visible");
	jQuery("#listagem-compras").css("visibility", "visible");			
}

function adicionaItemCarrinho(){
	descricao_produto  = jQuery("#compras_novo_item").val();
	quantidade = jQuery("#compras_quantidade_item").val();
	//Se primeiros caracteres sao numericos, continua como codigo barras			
	var regXPIniciaNumerico = /^\d/;
	var tokenEhCodigoBarras = regXPIniciaNumerico.exec(descricao_produto);
	if (tokenEhCodigoBarras) {
		new Ajax.Request('/loja/adiciona_produto_lista_compras', {asynchronous:true, evalScripts:true, method:'post', parameters:'authenticity_token=18694f0f8b9836a93f2b1d22e2d09ca925c87b3c&codigo_barras_item='+descricao_produto+'&quantidade_item='+quantidade}); 
	//Caso contrario, abandona requisicao e continua com insercao por descricao
	} else {
		modo_edicao = jQuery("#compras_modo_edicao").val();
		new Ajax.Request('/loja/adiciona_produto_lista_compras', {asynchronous:true, evalScripts:true, method:'post', parameters:'authenticity_token=18694f0f8b9836a93f2b1d22e2d09ca925c87b3c&descricao_item='+descricao_produto+'&quantidade_item='+quantidade+'&modo_edicao='+modo_edicao}); 
	}
	jQuery("#compras_quantidade_item").val("1");
	jQuery("#compras_novo_item").val("");
	jQuery("#compras_novo_item").focus().select();
}
