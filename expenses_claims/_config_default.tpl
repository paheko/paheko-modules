{{if !$module.config.categories}}
	{{:assign var="module.config.categories."
		label="Déplacement (forfaitaire)"
		account="6251"
		price=50
	}}
	{{:assign var="module.config.categories."
		label="Déplacement (au kilomètre)"
		account="6251"
		vehicle=true
	}}
	{{:assign var="module.config.categories."
		label="Frais postaux ou télécommunication"
		account="626"
	}}
	{{:assign var="module.config.categories."
		label="Fournitures d'entretien et petit équipement"
		account="6063"
	}}
	{{:assign var="module.config.categories."
		label="Logiciels à faible valeur (< 500 €)"
		account="6065"
	}}
{{/if}}

{{:assign var="vehicles"
	speedbike="Vélo électrique rapide (speed bike, > 25 km/h)"
	ecyclomoteur="Moto ou scooter électrique <= 50 cc"
	emoto1cv="Moto ou scooter électrique > 50 cc — 1 ou 2 CV"
	emoto3cv="Moto ou scooter électrique > 50 cc — 3 à 5 CV"
	emoto6cv="Moto ou scooter électrique > 50 cc — 6 CV et plus"
	e3cv="Voiture électrique — 3CV et moins"
	e4cv="Voiture électrique — 4CV"
	e5cv="Voiture électrique — 5CV"
	e6cv="Voiture électrique — 6CV"
	e7cv="Voiture électrique — 7CV et plus"

	3cv="Voiture thermique — 3CV et moins"
	4cv="Voiture thermique — 4CV"
	5cv="Voiture thermique — 5CV"
	6cv="Voiture thermique — 6CV"
	7cv="Voiture thermique — 7CV et plus"
	cyclomoteur="Moto ou scooter thermique <= 50 cc"
	moto1cv="Moto ou scooter thermique > 50 cc — 1 ou 2 CV"
	moto3cv="Moto ou scooter thermique > 50 cc — 3 à 5 CV"
	moto6cv="Moto ou scooter thermique > 50 cc — 6 CV et plus"
}}
