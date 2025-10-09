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
