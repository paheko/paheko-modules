{{* -*- brindille -*- *}}

{{if $module.table}}
	{{* supprimer les documents sans écriture associée *}}
	{{:assign var="docs." type="amort_link" field="amort_line_id"}}
	{{:assign var="docs." type="credit_link" field="credit_line_id"}}
	{{:assign var="docs." type="cession_link" field="cession_line_id"}}
	{{:assign var="docs." type="exit_link" field="exit_line_id"}}
	{{:assign var="docs." type="immo" field="line"}}

	{{#foreach from=$docs}}

		{{:assign join_field="$$."|cat:$field}}
		{{:assign type_name=$type|quote_sql}}
		{{:assign type_cond="$$.type"|cat:" = "|cat:$type_name}}

		{{* vérifier existence écriture associée au doc *}}
		{{#select
			info.id as info_id,
			$$.immo_doc_id as immo_doc_id,
			line.id as line_id
			FROM !table AS info
			LEFT JOIN acc_transactions_lines as line ON !join_field = line.id
			WHERE !type_cond
			;
			!table=$module.table
			!type_cond = $type_cond
			!join_field = $join_field
			assign="line"
		}}
			{{if $line.line_id == null}}
				{{:delete id=$line.info_id}}
			{{/if}}

			{{* vérifier existence doc immo *}}
			{{if $type != "immo"}}
				{{#load id=$immo_doc_id assign="immo_doc"}}
				{{else}}
					{{:delete id=$line.info_id}}
				{{/load}}
			{{/if}}
		{{/select}}

	{{/foreach}}
{{/if}}
