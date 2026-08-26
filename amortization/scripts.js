// activer/désactiver les champs passés en paramètres
function toggleInputs(idcb, idfields) {
	const elem = document.getElementById(idcb);
	for (let id of idfields) {
		const field = document.getElementById(id);
		if (elem.checked) {
			field.removeAttribute("disabled");
		}
		else {
			field.setAttribute("disabled","disabled");
		}
	}
}

function toggleVisibility(id_check, fields) {
	const elem = document.getElementById(id_check);
	fields.forEach(function (id_field) {
		const field = document.getElementById(id_field);
		if (elem.checked) {
			field.classList.remove('hidden');
		} else {
			field.classList.add('hidden');
		}
	});
}

// fixer l'exercice des sélecteurs de compte
function setAccountYear(button_names, id_year) {
	for (const name of button_names) {
		const button = document.querySelector("button[data-name=" + name + "]");
		if (button != null) {
			const b_value = button.value;
			const new_value = b_value.replace(/id_year=\d+/, 'id_year=' + id_year);
			button.setAttribute('value', new_value);
		}
	}
}

/**
 * renvoyer la valeur en secondes d'une date au format j/m/a
 * @param {string} date
 */
function str2sec(date) {
	const jma = date.split('/');
	const dd = new Date(jma[2], jma[1]-1, jma[0]);
	return dd.getTime()/1000;
}

// renvoyer la valeur en secondes d'un champ date
function getDate(idelem) {
	return str2sec(document.getElementById(idelem).value);
}

// (unused) désactiver les options du sélecteur qui ne sont pas dans un tableau de valeurs
function disableOptions(idSelect, init, values) {
	for (let i = init; i < idSelect.options.length; ++i) {
		const choix = idSelect.options[i];
		if (! values.includes(choix.value)) {
			choix.setAttribute('disabled', 'true');
			choix.removeAttribute('selected');
		}
	}
}

// afficher la date de fin de l'exercice choisi
function setDateEnd(id_exercices, id_date, id_years) {
	const selected_year = document.getElementById(id_exercices).value;
	if (selected_year == '') {
		document.getElementById(id_date).value = '';
		return;
	}
	const years_data = document.getElementById(id_years);
	for (const choix of years_data.options) {
		if (choix.value == selected_year) {
			const epox = choix.text.split(' ');
			const date_fin = new Date(epox[1] * 1000);
			document.getElementById(id_date).value = date_fin.toLocaleDateString();
			break;
		}
	}
}

// renvoyer la valeur numérique d'un montant formaté en €
function getNumber(text) {
	return Number(text.replace(/[^0-9,]/g, '').replace(/,/, '.'));
}

// calculer le montant d'un amortissement
// @param montant immo
// @param durée immo (années)
// @param somme amortissements
// @param date début
// @param date de fin
// @result montant de l'amortissement
function computeAmort(montant_immo, duree_immo, somme_amort, date_debut, date_fin) {
	const nbjours = 1 + (date_fin - date_debut) / (60*60*24);
	return Math.round(Math.min(montant_immo / duree_immo / 365 * nbjours, montant_immo - somme_amort));
}

// calculer et afficher le montant de l'amortissement
function displayAmort(id_immo, id_duree, id_amort, id_years, id_exercices, id_montant, id_erreur, id_date=null)
{
	const div_erreur = document.getElementById(id_erreur);
	div_erreur.setAttribute('class', 'hidden');
	let case_montant = document.getElementById(id_montant);
	const selected_year = document.getElementById(id_exercices).value;
	if (selected_year == '') {
		case_montant.value = '';
		return;
	}
	const years_data = document.getElementById(id_years);
	let date_debut, date_fin;
	for (const choix of years_data.options) {
		if (choix.value == selected_year) {
			const epox = choix.text.split(' ');
			date_debut = epox[0];
			date_fin = epox[1];
			break;
		}
	}
	if (id_date != null) {
		const date_choisie = str2sec(document.getElementById(id_date).value);
		if (date_debut <= date_choisie && date_choisie <= date_fin) {
			date_fin = date_choisie;
		} else {
			div_erreur.setAttribute('class', '');
		}
	}
	const montant_immo = Number(document.getElementById(id_immo).value);
	const duree_immo = Number(document.getElementById(id_duree).value);
	const somme_amort = Number(document.getElementById(id_amort).value);
	const montant_amort = computeAmort(montant_immo, duree_immo, somme_amort, date_debut, date_fin);
	case_montant.value = montant_amort/100;
	case_montant.innerText = montant_amort;
}

function setSelectorYear(button_names, f_years_selector)
{
	const selector = document.getElementById(f_years_selector);
	const selected_year = document.getElementById(f_years_selector).value;
	setAccountYear(button_names, selected_year);
}

// config : gestion des ajouts/suppression comptes immo

// Associer au bouton « Enlever » de chaque ligne l'action de suppression de la ligne
function initLine(row) {
	let removeBtn = row.querySelector('button[name="remove_line"]');
	if (removeBtn != null) {
		removeBtn.onclick = () => {
			let count = removeBtn.closest("table").querySelectorAll('tbody tr').length;
			var min = removeBtn.getAttribute('min');

			if (count <= min) {
				alert("Il n'est pas possible d'avoir moins de " + min + " ligne(s).");
				return false;
			}

			row.parentNode.removeChild(row);
			return true;
		};
	}
}

// Associer au bouton « Ajouter » de chaque table l'action d'ajouter une ligne
function addLine(button, codes) {
	button.onclick = () => {
		let lines = button.closest("table").querySelectorAll('tbody tr');
		let line = lines[lines.length - 1];
		let newNode = line.cloneNode(true);

		// Réinitialiser le sélecteur de compte
		let selectButton = newNode.querySelector('.input-list button');
		let url = selectButton.value;
		let new_url = url.replace(/codes=[0-9]+\*?/, "codes=" + codes);
		selectButton.value = new_url;

		// gestionnaire d'événement du sélecteur
		selectButton.onclick = () => {
			g.current_list_input = selectButton.parentNode;
			let url = selectButton.value + (selectButton.value.indexOf('?') > 0 ? '&' : '?') + '_dialog';
			g.openFrameDialog(url);
			return false;
		};

		// réinitialiser le libellé associé au sélecteur
		let lib = newNode.querySelector('.input-list span.label');
		lib.innerText = '';

		// si besoin, ajouter le bouton de suppression
		let action_cell = newNode.querySelector('td.actions');
		let removeBtn = newNode.querySelector('button[name="remove_line"]');
		if (removeBtn == null) {
			const attributs = {
				"title" : "Enlever une ligne",
				"min": "1",
				"name": "remove_line",
				"data-icon": "➖",
				"type": "button",
				"class": "icn-btn",
				"value": "1",
				"aria-label": "Enlever une ligne"
			};
			let new_button = document.createElement("button");
			new_button.appendChild(document.createTextNode("Enlever"));
			for (let attr in attributs) {
				new_button.setAttribute(attr, attributs[attr]);
			}
			action_cell.appendChild(new_button);
		}

		// ajouter la nouvelle ligne
		line.parentNode.appendChild(newNode);
		initLine(newNode);
	};
}

// afficher le montant
function addAmountLine(amount, label, parent) {
	const node = document.createElement("tr");
	const col_compte = document.createElement("td");
	col_compte.classList.add("label");
	const col_montant = document.createElement("td");
	col_montant.classList.add("money");
	const montant = document.createTextNode(new Intl.NumberFormat("fr-FR", { style: "currency", currency: "EUR" }).format(amount / 100., ));
	col_compte.appendChild(document.createTextNode(label));
	col_montant.appendChild(montant);
	node.appendChild(col_compte);
	node.appendChild(col_montant);
	parent.appendChild(node);
}

// calculer et afficher le total des lignes sélectionnées
function computeTotal(id_total, id_url) {

	// calculer le total par compte et le total général
	let total = new Object;
	let total_general = 0;
	const transactions = [];
	let lines = document.querySelectorAll('.list tbody tr');
	for (const line of lines) {
		let button = line.querySelector('input[type=checkbox]');
		if (button.checked) {
			let money = line.querySelector('.money');
			let code = line.querySelector('.account_code a').innerText;
			if (code in total) {
				total[code] += getNumber(money.innerText) * 100;
			} else {
				total[code] = getNumber(money.innerText) * 100;
			}
			total_general += getNumber(money.innerText) * 100;
			const number = line.querySelector('.num a').innerText.slice(1);
			transactions.push(number);
		}
	}
	// afficher les totaux
	const body = document.getElementById(id_total).querySelector('table tbody');
	const new_body = document.createElement('tbody');

	for (const code in total) {
		addAmountLine(total[code], "Compte " + code + " : ", new_body);
	}
	body.parentNode.replaceChild(new_body, body);

	// et le total général
	const foot = document.getElementById(id_total).querySelector('table tfoot');
	if (Object.keys(total).length > 1) {
		const new_foot = document.createElement('tfoot');
		addAmountLine(total_general, "Total : ", new_foot);
		foot.parentNode.replaceChild(new_foot, foot);
	} else {
		// pas besoin de total général si moins de 2 comptes
		for (const e of foot.children) {
			foot.removeChild(e);
		}
	}

	// mettre à jour les paramètres de l'url
	let url = document.getElementById(id_url);
	let new_href = url.href.replace(/trans=.*/, 'trans=' + Object.values(transactions));
	url.href = new_href;
}

// dupliquer la dernière ligne d'une table
function copyLine(button) {
	button.onclick = () => {
		let lines = button.closest("table").querySelectorAll('tbody tr');
		let line = lines[lines.length - 1];
		let newNode = line.cloneNode(true);
		let libelle = newNode.querySelector('input');
		libelle.value = '';

		// ajouter la nouvelle ligne
		line.parentNode.appendChild(newNode);
		initLine(newNode);
	};
}
