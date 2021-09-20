const music = new Audio("../sounds/namazu.mp3");

$(function() {
  var timer = $(".screen");
  var closest_task_time = $(".fa-music").first().parent().parent().siblings().last().text();
  closest_task_time = parseInt(closest_task_time);
  $(".fa-music").hide();

  function time_refreash(){
    var data = $.ajax({
      type: 'GET',
      url: '/current_time',
      success: function(data) {

        if (parseInt(data) >= closest_task_time)
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
/*
// console.log('success', data);
// This logic is wrong rethink it - doesn't take into account 23 is greater than 6.
if (parseInt(data) >= closest_task_time)
{
  $(".fa-music").first().show();
} // Don't think else statement will activate.
else if (parseInt(data) + 1 >= closest_task_time)
{

What am I trying to do?
I have a string "06:00 Cherry" currently I am getting
the hour by parsing the string into an int
I'm also doing that for the current clock time.
  - This is causing inaccuraccies because the music icon should not appear till
  the time the task specifies.
  - Could there be a split method in javascipt?


string = "06:00 Cherry";
time = string.split(":");

hour = parseInt(time[0]);
minute = parseInt(time[1]);

console.log(`The hour is ${hour}, the minute is ${minute}`)





*/

