{{#foreach from=$module.config.accounts|explode:','|map:'trim' value="a"}}
	{{:assign var="module.config.accounts.%d"|args:$a value=$a}}
{{/foreach}}
{{:save key="config"
	accounts=$module.config.accounts|arrayval
}}
