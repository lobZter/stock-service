# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
@setModal = (image) ->
  $('#enlarge_image').attr 'src', image.src
  $('#image_modal').modal 'show'
  return