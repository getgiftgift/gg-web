#// Place all the behaviors and hooks related to the matching controller here.
#// All this logic will automatically be available in application.js.

$(document).ready ->
  $('select#user_location_id').change( ->
    $(this).parent().parent('form').submit())  
  $('#instructions').hide()
  $('.flash').delay(6000).fadeOut(2000)
  $('#box_container').css('bottom', '-'+$('#box_container').css('height'))
  $('#logo').css('top', '-256px')
  $('#flags-left').css('left', '-410px')
  $('#flags-right').css('right', '-410px')
  $('#flags-left').delay(500).animate
    left: '-10px'
    , 2500
    , 'linear'
  $('#flags-right').delay(500).animate
    right: '-10px'
    , 2500
    , 'linear'
  $('#box_container').animate
    bottom: '35px'
    , 3000, 'linear'
  $('#logo').delay(2500).animate
    top: '10%'
    , 4000, 'easeInOutElastic', ->
      $('#instructions').fadeIn(2000)  
  $('.birthday-box.closed').click( ->
    $(this).removeClass('closed').addClass('open')
    )
   
  $('.birthday-box').click (event) ->
      $('#details').fadeIn()
      $('.card-box').hide()
      $('#card_'+$(this).attr('id')).show()
