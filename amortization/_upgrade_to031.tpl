{{* -*- brindille -*- *}}

{{*
	Mettre à niveau vers v0.31
	- créer un doc de liaison pour chaque amortissement lié à une immobilisation
	  mais uniquement pour les immo déjà gérées, sinon l'upgrade
	  vers 0.33 ne fonctionnera pas car on pourrait se retrouver avec
	  des liaisons immo <-> amort sans doc associé à l'immo donc la
	  transformation de link vers amort_link ne pourra se faire

	  - id ligne d'immobilisation
	  - id ligne d'amortissement
	  - id écriture d'amortissement
*}}

{{* lister les immobilisations *}}
{{:include file="_get_config.html" keep="module.config"}}

{{:assign account_condition="("}}
{{#foreach from=$module.config.prefixes item="code"}}
	{{:assign code=$code|cat:"%"|quote_sql}}
	{{:assign account_condition=$account_condition|cat:" account.code LIKE "|cat:$code|cat:" OR "}}
{{/foreach}}
{{:assign account_condition=$account_condition|cat:"0)"}}

{{:assign filter_condition=" AND NOT ("}}
{{#foreach from=$module.config.filters item="filter"}}
	{{:assign filter="%"|cat:$filter|cat:"%"|quote_sql}}
	{{:assign filter_condition=$filter_condition|cat:" trans.label LIKE "|cat:$filter|cat:" OR "}}
{{/foreach}}
{{:assign filter_condition=$filter_condition|cat:"0)"}}

{{:assign condition=$account_condition|cat:" AND debit > 0 AND NOT (trans.status & 16)"|cat:$filter_condition}}

{{#select
	line.id as immo_line_id
	FROM acc_transactions AS trans
	INNER JOIN acc_transactions_lines AS line ON line.id_transaction = trans.id
	INNER JOIN acc_accounts AS account ON line.id_account = account.id
	INNER JOIN acc_years AS years ON trans.id_year = years.id
	WHERE !condition
	ORDER BY trans.date DESC;
	!condition=$condition
}}
	{{* voir si l'immo est prise en charge *}}
	{{#load type="immo" where="$$.line = :line_id" :line_id=$immo_line_id|intval}}
		{{:assign status=$status}}
	{{else}}
		{{:assign status="unknown"}}
	{{/load}}

	{{* ne pas faire la liaison si pas de doc *}}
	{{if $status == "ignored" || $status == "unknown"}}
		{{:continue}}
	{{/if}}

	{{* lister les écritures d'amortissement liées *}}
	{{:assign amort_lines=null}}
	{{#select
		CASE links.id_related = t_immo.id
			WHEN true THEN links.id_transaction
			WHEN false THEN links.id_related
		END as amort_trans_id,
		l_amort.id AS amort_line_id
		FROM acc_transactions_lines as l_immo
		INNER JOIN acc_transactions as t_immo on t_immo.id = l_immo.id_transaction
		INNER JOIN acc_transactions_links as links
			ON (t_immo.id = links.id_transaction OR t_immo.id = links.id_related)
		INNER JOIN acc_transactions_lines as l_amort on amort_trans_id = l_amort.id_transaction
		INNER JOIN acc_accounts AS account ON l_amort.id_account = account.id
		WHERE l_immo.id = :line_id AND l_amort.credit <> 0 AND account.code LIKE '28%';
		:line_id = $immo_line_id|intval
		assign="amort_lines."
	}}
	{{/select}}

	{{#foreach from=$amort_lines item="line"}}
		{{*  chercher un doc associé *}}
		{{#load type="link"
			where="$$.immo_line_id = :immo_line_id
				AND $$.amort_line_id = :amort_line_id
				AND $$.amort_trans_id = :amort_trans_id"
			:immo_line_id = $immo_line_id
			:amort_line_id = $line.amort_line_id
			:amort_trans_id = $line.amort_trans_id
			assign="link"
		}}
		{{else}}
			{{* pas de doc => le créer *}}
			{{:save
				key=""|uuid
				type="link"
				immo_line_id=$immo_line_id
				amort_line_id=$line.amort_line_id
				amort_trans_id=$line.amort_trans_id
			}}
		{{/load}}
	{{/foreach}}
{{/select}}
