const music = new Audio("../sounds/namazu.mp3");

$(function() {
  var timer = $(".screen");

  var closest_task_time = $(".fa-music").first().parent().parent().siblings().last().text();
  closest_task_time = closest_task_time.split(":");
  var closest_hour = parseInt(closest_task_time[0]);
  var closest_min = parseInt(closest_task_time[1]);

  $(".fa-music").hide();

  function time_refreash(){
    var data = $.ajax({
      type: 'GET',
      url: '/current_time',
      success: function(data) {
        var time = data.split(":");
        var hour = parseInt(time[0]);
        var minute = parseInt(time[1]);

        if (closest_hour === hour && minute === closest_min)
        {
          $(".fa-music").first().show();
          music.play();
        }

        timer.html(data);
        setTimeout(function() {time_refreash();}, 3000);
      }
    });
  }

  time_refreash();
});

