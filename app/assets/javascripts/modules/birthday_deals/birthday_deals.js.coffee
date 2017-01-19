#// Place all the behaviors and hooks related to the matching controller here.
#// All this logic will automatically be available in application.js.

$(document).ready ->
  $('select#user_location_id').change( ->
    $(this).parent().parent('form').submit())
  $('.flash').delay(6000).fadeOut(2000)
  $('#box_container').css('bottom', '-'+$('#box_container').css('height'))

  ##
  # Animation for the giftbox.
  # show the speech box after animation completes,
  # don't show if the details box is visible.
  $('#gift-area').animate bottom: '40%', 3000, 'linear', ->
    # unless $('.white-box').is(":visible")
      # $('#speech-box').show()

  $('.birthday-box.closed').click( ->
    $(this).removeClass('closed').addClass('open')
    )

  $('.birthday-box').click (event) ->
    $('#details').fadeIn()
    $('.card-box').hide()
    $('#speech-box').hide()
    $('#card_'+$(this).attr('id')).show()


  # update_gift_counter()

  # $('p#counter').replaceWith("<p>" + gifts_left + " "+word+" left.</p>")
  # $('p#counter').replaceWith("<p>" + $('.birthday-box:hidden').size() + " Gifts left.</p>")

  $('#cancel').click ->
    $('#confirm-redeem').foundation('reveal', 'close')

  $(".free-presents").click ->
    $(".free-presents").hide()
    $('.flex-video').show()
