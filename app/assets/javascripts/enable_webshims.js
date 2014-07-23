webshim.setOptions("forms-ext", {
  "month": {
    "yearSelect": true,
    "monthSelect": true,
    "monthNames": "monthNames",
    "classes": "hide-inputbtns"
  }
});
webshim.polyfill("forms forms-ext");
