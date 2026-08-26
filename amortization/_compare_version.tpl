{{* -*- brindille -*- *}}

{{*
	Comparer deux numéros de version n1.n2[.n3]
	@param nv1
	@param nv2
	@result comp : -1 si nv1 < nv2, 0 si nv1 = nv2, 1 si nv1 > nv2
*}}

{{:assign nv1=$nv1|cat:"."}}
{{:assign nv2=$nv2|cat:"."}}
{{:assign var="tv1" value=$nv1|explode:"."}}
{{:assign var="tv2" value=$nv2|explode:"."}}

{{:assign comp=0}}
{{:assign i=0}}
{{#foreach from=$tv1 item="e1"}}
	{{:assign var="e2" from="tv2.%d"|args:$i}}
	{{if $e1 < $e2}}
		{{:assign comp=-1}}
		{{:break}}
	{{elseif $e1 > $e2}}
		{{:assign comp=1}}
		{{:break}}
	{{/if}}
	{{:assign i="%d+1"|math:$i}}
{{/foreach}}
{{*
	cas où le premier tableau a moins d'éléments que le 2ème
	et où les éléments présents dans les deux tableaux sont identiques
 *}}
{{if $comp == 0 && $tv1|count < $tv2|count}}
	{{:assign comp = -1}}
{{/if}}
