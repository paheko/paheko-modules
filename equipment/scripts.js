/**
 * désactiver le tri des colonnes ayant la classe nosort dans une liste triable
 * @param {Node} liste - liste triable
 */
function disableColumSort(liste) {

	// chercher la première ligne du corps de la table
	let columns = liste.querySelectorAll("tbody > tr > td");

	// chercher la ligne de titres
	let titles = liste.querySelectorAll("thead > tr > th");

	// désactiver le tri
	for (let i = 0; i < titles.length; ++i) {
		let anchor = titles[i].querySelector("a");
		const classAttr = columns[i].getAttribute("class");
		if (anchor != null && classAttr != null && classAttr.includes("nosort")) {
			anchor.removeAttribute("href");
			anchor.removeAttribute("title");
			anchor.removeChild(anchor.firstElementChild);
			let headerClass = titles[i].getAttribute("class");
			if (headerClass == null) { headerClass = ""; }
			headerClass += "nosort";
			titles[i].setAttribute("class", headerClass);
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

/**
 * modifier la date de retour en fonction de la date de sortie et de la durée du prêt
 */
function setReturnDate(id_date, id_return_date, id_loan_duration)
{
	const loan_duration = document.getElementById(id_loan_duration).value;
	if (loan_duration !== undefined && loan_duration > 0) {
		let nbsec = getDate(id_date) + loan_duration*24*60*60;
		const date_retour = new Date(nbsec * 1000);
		document.getElementById(id_return_date).value = date_retour.toLocaleDateString();
	}
}

/**
 * changer la visibilité de la date de retour
 */
function toggleVisibility(id_date, id_type, div, id_return_date)
{
	const key = document.getElementById(id_type).value;
	let type_sortie;
	if (key !== undefined && key != '') {
		type_sortie = output_nature[key].type;
	}
	const div_date = document.getElementById(div);
	if (type_sortie == 'temporaire') {
		div_date.style.visibility = "visible";
		document.getElementById(id_date).onchange();
	} else {
		div_date.style.visibility = "hidden";
		document.getElementById(id_return_date).value = null;
	}
}
