//= require jquery
//= require jquery-ujs
//= require jquery-ui
//= require foundation
//= require_tree .

$(function() {
  $(document).foundation();
  $("#voucher_table").tablesorter();
  // $(".messages").fadeOut(3000)
});

update_gift_counter = function() {
  $("p#counter").replaceWith(
    "<p id='counter'>" + gifts_remain() + " " + gifts_word() + " left.</p>"
  );
};

gifts_remain = function() {
  return $(".birthday-box:hidden").length;
};

gifts_word = function() {
  var word = "";
  if (gifts_remain() > 1) {
    word = "Gifts";
  } else if (gifts_remain() === 1) {
    word = "Gift";
  }
  return word;
};
