# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  agent = window.navigator.userAgent
  unless agent.match(/Android/i) || agent.match(/webOS/i) || agent.match(/iPhone/i) || agent.match(/iPad/i) || agent.match(/iPod/i) || agent.match(/BlackBerry/i) || agent.match(/Windows Phone/i)

    $('a.redeem-btn').replaceWith("<h4><i class='fi-alert' style='color: #ff4500; font-size: 1.3em;'></i> Redeem on a mobile device.</hr>")
    $('#redeem-txt, #verification-number').remove()