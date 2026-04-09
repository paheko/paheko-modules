{{if !$module.db_version}}
	{{:table create="eco_organisations"
		name="TEXT NOT NULL UNIQUE COMMENT 'Nom'"
	}}

	{{:table create="eco_movements" comment="Catégories de mouvements"
		id_organisation="INTEGER NOT NULL REFERENCES eco_organisations (id) ON DELETE CASCADE"
		label="TEXT NOT NULL COMMENT 'Libellé'"
		code="TEXT NULL COMMENT 'Code'"
	}}

	{{:table create="eco_categories" comment="Catégories d'objets"
		id_organisation="INTEGER NOT NULL REFERENCES eco_organisations (id) ON DELETE CASCADE"
		filiere="TEXT NOT NULL COMMENT 'Code filière'"
		code="TEXT NULL"
		label="TEXT NOT NULL"
	}}

	{{:table create="movements" comment="Types de mouvements"
		label="TEXT NOT NULL COMMENT 'Libellé'"
		type="TEXT NOT NULL COMMENT 'Entrée ou sortie'"
		archived="INTEGER NOT NULL DEFAULT 0"
	}}

	{{:table create="categories" comment="Catégories d'objets"
		label="TEXT NOT NULL COMMENT 'Libellé'"
		weight="INTEGER NOT NULL COMMENT 'Poids par défaut'"
		movement_type="TEXT NOT NULL COMMENT 'Entrée/sortie'"
		archived="INTEGER NOT NULL DEFAULT 0"
	}}

	{{:table create="events" comment="Entrées / sorties"
		type="TEXT NOT NULL COMMENT 'Entrée / sortie'"
		id_movement="INTEGER NOT NULL REFERENCES movements (id) ON DELETE RESTRICT"
		id_category="INTEGER NULL REFERENCES categories (id) ON DELETE RESTRICT"
		label="TEXT NULL COMMENT 'Libellé du mouvement'"
		weight="INTEGER NOT NULL"
		qty="INTEGER NOT NULL"
		total_weight="INTEGER NOT NULL"
		date="DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP"
		id_eco_organisation="INTEGER NULL REFERENCES eco_organisations (id) ON DELETE RESTRICT"
		id_eco_category="INTEGER NULL REFERENCES eco_categories (id) ON DELETE RESTRICT"
		id_eco_movement="INTEGER NULL REFERENCES eco_movements (id) ON DELETE RESTRICT"
		id_velo="INTEGER NULL"
		id_pos_session="INTEGER NULL"
	}}

	{{:table create="movements_links" comment="Lien entre type de mouvement et éco-organisme"
		id_movement="INTEGER NOT NULL REFERENCES movements (id) ON DELETE CASCADE"
		id_eco_movement="INTEGER NOT NULL REFERENCES eco_movements (id) ON DELETE CASCADE"
	}}

	{{:read csv="./eco_categories.csv" assign="categories"}}
	{{:read csv="./eco_mouvements.csv" assign="mouvements"}}

	{{:save table="eco_organisations" name="Ecologic" assign="ecologic"}}

	{{#foreach from=$categories item="cat" key="line"}}
		{{:save table="eco_organisations" label=$cat.organisme assign="org"}}
		{{if !$cat.code|or:$cat.nom}}
			{{:error message="Eco-catégorie invalide sur ligne %d"|args:$line}}
		{{/if}}
		{{:save table="eco_categories" id_organisation=$org.id filiere=$cat.filiere code=$cat.code|or:null label=$cat.nom|or:null}}
	{{/foreach}}

	{{#foreach from=$mouvements item="mvt"}}
		{{:save table="eco_organisations" label=$mvt.organisme assign="org"}}
		{{:save table="eco_movements" id_organisation=$org.id type=$mvt.type code=$mvt.code label=$mvt.nom}}
	{{/foreach}}

	{{if $module.documents_table}}
		{{* Import des types d'entrée / sortie *}}
		{{:insert
			INTO @MODULE_movements (id, key, label, type)
			SELECT id, key, $$.label, $$.target FROM @DOCUMENTS WHERE $$.type = 'category'
		}}

		{{* Import des catégories d'objets *}}
		{{:insert
			INTO @MODULE_categories (id, key, label, weight, movement_type)
			SELECT id, key, $$.label, $$.weight, $$.target FROM @DOCUMENTS WHERE $$.type = 'object'
		}}

		{{* Création des liens avec les mouvements des éco-organismes *}}
		{{:insert
			INTO @MODULE_movements_links (key, id_movement, id_eco_movement)
			SELECT uuid(), a.id, b.id
			FROM @DOCUMENTS doc
			INNER JOIN @MODULE_movements m ON m.label = doc.$$.label
			INNER JOIN @MODULE_eco_movements em ON em.code = doc.$$.ecologic
		}}

		{{* Import des entrées / sorties *}}
		{{:insert
			INTO @MODULE_events (id, key, id_movement, id_category, label, weight, qty, total_weight,
				date, id_eco_category, id_eco_movement, id_velo, id_pos_session)
			SELECT a.id, a.key, m.id, NULL, a.$$.object, a.$$.weight, a.$$.qty, a.$$.total_weight, a.$$.date,
				NULL, em.id, a.$$.velo_id, a.$$.pos_session_id
			FROM @DOCUMENTS
			LEFT JOIN @MODULE_movements m ON m.label = a.$$.category
			LEFT JOIN @MODULE_eco_movements em ON em.code = a.$$.ecologic
			WHERE (a.$$.type = 'entry' OR a.$$.type = 'exit')
		}}

		{{:table delete="@DOCUMENTS"}}
	{{/if}}

	{{*
	{{#load type="category"}}
		{{:save table="movements"
			id=$id
			key=$key
			label=$label
			type=$type
		}}
		{{:assign var="movements[%s%s]"|args:$type:$label}}
	{{/load}}
	{{#load type="entry"}}
		{{:assign var="id_movement" from="movements.%s"|args:$category}}
		{{:assign var="id_eco_movement" from="eco_movements.%s"|args:$ecologic}}
		{{:save table="events"
			key             = $key
			type            = $type
			id_movement     = $id_movement
			id_category     = null
			label           = $object
			weight          = $weight
			qty             = $qty
			total_weight    = $total_weight
			date            = $date
			id_eco_category = null
			id_eco_movement = $id_eco_movement
			id_velo         = $velo_id
			id_pos_session  = $pos_session_id
		}}
	{{/load}}
	*}}
{{/if}}