//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require foundation
//= require_tree .

$(function() {
  $(document).foundation();
  $("#voucher_table").tablesorter();
  // $(".messages").fadeOut(3000)
});

update_gift_counter = function(){
  $('p#counter').replaceWith("<p id='counter'>"+gifts_remain()+" "+gifts_word()+" left.</p>")
};

gifts_remain = function() {
  var gifts_left;
  return gifts_left = $('.birthday-box:hidden').size();
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