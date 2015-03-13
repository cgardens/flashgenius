$(document).ready(function() {
  bindEvents();
});

function bindEvents() {
  $(".cards-container").on("click", ".discard-button", discardQuestion);
}

function discardQuestion(event) {
  event.preventDefault();
  var that = this;
  $.ajax( {
    url: this.id,
    type: 'DELETE',
    dataType: 'json'
  }).done(
    function(response) {
      that.parentElement.remove();
  }).fail(
    function(response) {
      console.log("deleteToDo encountered an error, which sucks but is recoverable.")
  });
}



