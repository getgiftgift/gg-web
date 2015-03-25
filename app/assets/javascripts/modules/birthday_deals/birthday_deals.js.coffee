#// Place all the behaviors and hooks related to the matching controller here.
#// All this logic will automatically be available in application.js.

$(document).ready ->
  $('select#user_location_id').change( ->
    $(this).parent().parent('form').submit())  
  $('#instructions').hide()
  # $('#account, .geobox').hide()
  # $('#account, .geobox').delay(3000).fadeIn(2000)
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
  


  # count = true
  # count2 = true
  
  # # step1/3 shows when dom is ready
  # step1 = 
  #   $('.list > a:first').qtip
  #     content:    
  #       text: 'Click on a present to open it'
  #     viewport: $(window)    
  #     hide: false
  #     show:
  #       ready: true
  #       delay: 3000
  #     position:
  #           my: 'bottom center'
  #           at: 'top center'
  #         style:
  #           def: false
  #           classes: 'bday_tooltip'

  # step2 = $('.card-box:visible').qtip
  #       content: 
  #         text: 'Keep It if you like, or Trash It if you don\'t'
  #       viewport: $(window)     
  #       hide:
  #         fixed: true 
  #         event: false
  #       show:
  #         fixed: true
  #         event: false
  #       position:
  #             my: 'top center'
  #             at: 'bottom center'
  #       style:
  #         def: false
  #         classes: 'bday_tooltip'            

  # step3 =
  #   $('#account').qtip
  #     content:
  #       title:  
  #         text: 'Go here'
  #         button: 'Close'
  #       text: 'To redeem your gifts'  
  #     viewport: $(window)    
  #     hide:
  #       event: false
  #     show:
  #       event: false
  #     position: 
  #       my: 'right top'
  #       at: 'left center'
  #     style:
  #       def: false
  #       classes: 'bday_tooltip' 

  # event handler to show step 3/3
  # $('.bottom-buttons').click (event) ->
  #   if count2 == true
  #     $(step3).qtip('show')
  #     count2 = false  
  #   $('#qtip-2').remove()

  # event handler to show step2/3 
  $('.birthday-box').click (event) ->
      
      
    # $(step2).qtip('show')
    # step2 = $('#card_'+$(this).attr('id')).qtip
    #     content: 
    #       text: 'Keep It if you like, or Trash It if you don\'t'
    #     viewport: $(window)     
    #     hide:
    #       fixed: true 
    #       event: false
    #     show:
    #       fixed: true
    #       event: false
    #     position:
    #           my: 'top center'
    #           at: 'bottom center'
    #     style:
    #       def: false
    #       classes: 'bday_tooltip'
     
       
    # if $('.white-box > div').is(':visible')
    #   event.preventDefault()   
    # else
    #   $('#qtip-0').remove()    
      $('#details').fadeIn()
      $('.card-box').hide()
      $('#card_'+$(this).attr('id')).show()
      # if count == true
      #   $(step2).qtip('show')
      #   count = false     
      
    # $('#details').attr('class', 'box-'+$(this).data('box'))
    # img = $(this).children('img')[0]
    # src = $(img).attr('src').replace('closed','open')
    # $(img).attr('src', src)