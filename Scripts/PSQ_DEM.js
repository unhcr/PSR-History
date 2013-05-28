$(document).ready(function () {

  "use strict";

  // Ensure valid date range
  $("select.start-year").click(function (event) {
    $("select.end-year option").each(function () {
      $(this).prop("disabled", (this.value < event.target.value));
    });
  });
  $("select.end-year").click(function (event) {
    $("select.start-year option").each(function () {
      $(this).prop("disabled", (this.value > event.target.value));
    });
  });

  // Manage "All ..." selections in country select
  $("select.country").click(function (event) {
    if (event.target.value === "0") {
      $("select.country option[value!='0']").each(function () {
        $(this).prop("selected", false);
      })
    } else {
      $("select.country option[value='0']").prop("selected", false);
    }
  }

  // Ensure at least one numeric value column is selected
  var popTypes = $(".values input");
  popTypes.click(function () {
    if (popTypes.filter(":checked").length == 0) {
      $("#BodyPlaceHolder_cbxPOC").prop("checked", true);
    }
  })

});