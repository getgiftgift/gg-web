window.fbAsyncInit = ->
  FB.init
    appId: '462905540438142'
    xfbml: true
    version: 'v2.1'
  return

((d, s, id) ->
  js = undefined
  fjs = d.getElementsByTagName(s)[0]
  if d.getElementById(id)
    return
  js = d.createElement(s)
  js.id = id
  js.src = '//connect.facebook.net/en_US/sdk.js#xfbml=1&appId=462905540438142&version=v2.0'
  fjs.parentNode.insertBefore js, fjs
  return
) document, 'script', 'facebook-jssdk'