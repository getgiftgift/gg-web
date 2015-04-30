#// Place all the behaviors and hooks related to the matching controller here.
#// All this logic will automatically be available in application.js.

$(document).ready ->
  $('select#user_location_id').change( ->
    $(this).parent().parent('form').submit())  
  $('.flash').delay(6000).fadeOut(2000)
  $('#box_container').css('bottom', '-'+$('#box_container').css('height'))
  $('#gift-area').animate bottom: '50%', 3000, 'linear', ->  
    $('#speech-box').show()

  $('.birthday-box.closed').click( ->
    $(this).removeClass('closed').addClass('open')
    )
   
  $('.birthday-box').click (event) ->
    $('#details').fadeIn()
    $('.card-box').hide()
    $('#speech-box').hide()
    $('#card_'+$(this).attr('id')).show()
  
  $('#cancel').click ->
    $('#confirm-redeem').foundation('reveal', 'close');