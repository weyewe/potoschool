

jQuery(function($){

  $('#target').Jcrop({
    onChange:   showCoords,
    onSelect:   showCoordsFinal,
    onRelease:  clearCoords,
    maxSize: [62,62]
  }  ,function(){
    PilipotoJcropApi = this;
  });

});

// Simple event handler, called from onChange and onSelect
// event handlers, as per the Jcrop invocation above
function showCoords(c)
{
  
  // $('#x1').val(c.x);
  // $('#y1').val(c.y);
  // $('#x2').val(c.x2);
  // $('#y2').val(c.y2);
  // $('#w').val(c.w);
  // $('#h').val(c.h);
  $('#title_container').addClass("hide"); //if reselecting, hide the form
};

function showCoordsFinal(c)
{
  
  $('#x1').val(c.x);
  $('#y1').val(c.y);
  $('#x2').val(c.x2);
  $('#y2').val(c.y2);
  $('#w').val(c.w);
  $('#h').val(c.h);
  // alert("boom, here we are, x1=" + c.x + ", x2=" + c.x2 + ", y1=" + c.y + ", y2=" + c.y2);
  
  // prefill the form with these values
  // hidden tag. user only need to fill it
  // show the feedback form , 
  
  $('#title_container').css('left', c.x);
  $('#title_container').css('top', c.y2);
  $("#x1").val(c.x);
  $("#x2").val(c.x2);
  $("#y1").val(c.y);
  $("#y2").val(c.y2);
  $('#title_container').removeClass("hide");
  
  $("#comment_value").focus();
  
  
};



function clearCoords()
{
  $('#coords input').val('');
  $('#h').css({color:'red'});
  window.setTimeout(function(){
    $('#h').css({color:'inherit'});
    },500);
  };