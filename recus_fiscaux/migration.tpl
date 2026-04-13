{{if !$db_version}}
	{{*:table create="receipts"
		annule="INTEGER NOT NULL DEFAULT 0"
		entreprise="INTEGER NOT NULL DEFAULT 0"
		date="DATETIME NOT NULL"
		nom=
	*}}
	{{* Migrate transactions IDs to a separate table *}}
	{{:table create="receipts_transactions"
		id_transaction="INTEGER NULL REFERENCES !acc_transactions (id) ON DELETE CASCADE UNIQUE link"
		id_receipt="INTEGER NULL REFERENCES documents (id) ON DELETE CASCADE UNIQUE link"
	}}
	{{#load where="$$.linked_transactions IS NOT NULL"}}
		{{#foreach from=$linked_transactions item="id_transaction"}}
			{{:save table="receipts_transactions" id_transaction=$id_transaction id_receipt=$id}}
		{{/foreach}}
		{{:save id=$id linked_transactions=null}}
	{{/load}}
{{/if}}
