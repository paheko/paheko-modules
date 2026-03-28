{{if !$module.db_version}}
	{{:table create="ballots" comment="Liste des scrutins"
		label="TEXT NOT NULL"
		description="TEXT NULL"
		start_date="DATETIME NOT NULL"
		end_date="DATETIME NOT NULL"
		id_service="INTEGER NULL REFERENCES !services (id) ON DELETE SET NULL"
		id_category="INTEGER NULL REFERENCES !users_categories (id) ON DELETE SET NULL"
	}}

	{{:table create="ballots_questions" comment="Liste des questions"
		label="TEXT NOT NULL"
		description="TEXT NULL"
		id_ballot="INTEGER NOT NULL REFERENCES ballots (id) ON DELETE CASCADE"
	}}

	{{:table create="ballots_votes"
		vote="TEXT NOT NULL"
		datetime="DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP"
		id_user="INTEGER NULL REFERENCES !users (id) ON DELETE SET NULL"
		id_ballot="INTEGER NOT NULL REFERENCES ballots (id) ON DELETE CASCADE"
		id_ballot_question="INTEGER NOT NULL REFERENCES ballots_questions (id) ON DELETE CASCADE"
	}}
{{/if}}
{{if $module.db_version|version_compare:'<':'1.0.1'}}
	{{:column table="ballots" create="start_date" definition="DATETIME NOT NULL"}}
	{{:column table="ballots" create="end_date" definition="DATETIME NOT NULL"}}
{{/if}}
