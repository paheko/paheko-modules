{{* -*- brindille -*- *}}

{{*
	Mettre à niveau vers v0.33, pour gérer les écritures du bilan d'ouverture
	où le montant d'une ligne d'immo ou d'une ligne d'amort peut être
	réparti entre plusieurs immo et plusieurs amort

	- modifier le doc d'immo
	  - date => date_mes (date mise en service)

	- modifier le doc de liaison d'amortissement
	  - id ligne d'immobilisation => id doc immobilisation
	  - id ligne d'amortissement
	  - id écriture d'amortissement
	  - ajouter montant amortissement
*}}

{{* doc immo *}}
{{#load type="immo" assign="elem"}}
	{{if $elem.date != null}}
		{{:assign var="elem.date_mes" value=$elem.date}}
		{{:assign var="docs." value=$elem}}
		{{:delete id=$elem.id}}
	{{/if}}
{{/load}}

{{* créer les nouveaux documents *}}
{{#foreach from=$docs item="doc"}}
	{{:save
		key=""|uuid
		type=$doc.type
		line=$doc.line
		duration=$doc.duration
		label=$doc.label
		amount=$doc.amount
		date_achat=$doc.date_achat
		date_mes=$doc.date_mes
		status=$doc.status
	}}
{{/foreach}}

{{* lister les liaisons actuelles ligne amort => ligne immo *}}
{{#load type="link" assign="link"}}
	{{#load type="immo" where="$$.line = :immo_line_id" :immo_line_id=$link.immo_line_id assign="immo"}}
		{{:assign link_doc=null}}
		{{:assign var="link_doc.immo_doc_id" value=$immo.id}}
		{{:assign var="link_doc.amort_line_id" value=$link.amort_line_id}}
		{{:assign var="link_docs." value=$link_doc}}
	{{else}}
		{{* liaison orpheline : ignorer *}}
	{{/load}}
	{{:delete id=$link.id}}
{{/load}}

{{* créer les nouvelles liaisons *}}
{{#foreach from=$link_docs item="link"}}
	{{:save
		key=""|uuid
		type="amort_link"
		immo_doc_id=$link.immo_doc_id
		amort_line_id=$link.amort_line_id
		amount=null
	}}
{{/foreach}}
