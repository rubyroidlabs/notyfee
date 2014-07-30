webshim.setOptions("forms-ext", {
  "replaceUI": true,
  "month": {
    "yearSelect": true,
    "monthSelect": true,
    "monthNames": "monthNames",
    "classes": "hide-inputbtns"
  }
});
webshim.polyfill("forms forms-ext");
