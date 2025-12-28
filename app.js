// Primebuild ERP - minimal JS

function pbDebounce(fn, delay) {
  let t = null;
  return function (...args) {
    clearTimeout(t);
    t = setTimeout(() => fn.apply(this, args), delay);
  };
}

/**
 * Generic datalist suggest (shows name only, label inside option)
 */
function pbAttachDatalistSuggest(inputId, listId, url) {
  const inp = document.getElementById(inputId);
  const dl  = document.getElementById(listId);
  if (!inp || !dl) return;

  const run = pbDebounce(async () => {
    const term = (inp.value || "").trim();
    if (term.length < 1) {
      dl.innerHTML = "";
      return;
    }
    try {
      const res = await fetch(url + "?term=" + encodeURIComponent(term), { credentials: "same-origin" });
      const data = await res.json();
      dl.innerHTML = "";
      (data || []).forEach(row => {
        const opt = document.createElement("option");
        opt.value = row.name;      // show name only
        opt.label = row.label;     // extra info in dropdown
        dl.appendChild(opt);
      });
    } catch (e) {}
  }, 200);

  inp.addEventListener("input", run);
}

function pbAttachCustomerSuggest(inputId, listId, url) {
  pbAttachDatalistSuggest(inputId, listId, url);
}

function pbAttachSupplierSuggest(inputId, listId, url) {
  pbAttachDatalistSuggest(inputId, listId, url);
}
