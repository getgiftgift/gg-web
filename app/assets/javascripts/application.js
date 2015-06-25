// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//

//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require foundation
//= require_tree .



$(function() {
  $(document).foundation();
  resize_main_section();
  
  //  remove url garbage
  if (window.location.hash == "#_=_") {
    window.location.hash = "";   };

  $("#voucher_table").tablesorter();
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

resize_main_section = function(){
  $('section.main-section').css('height',$(window).height()-70)
}