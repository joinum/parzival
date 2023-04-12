function msToTime(duration) {
  var seconds = Math.floor((duration / 1000) % 60),
      minutes = Math.floor((duration / (1000 * 60)) % 60),
      hours = Math.floor((duration / (1000 * 60 * 60)) % 24);

  hours = (hours < 10) ? "0" + hours : hours;
  minutes = (minutes < 10) ? "0" + minutes : minutes;
  seconds = (seconds < 10) ? "0" + seconds : seconds;

  return hours + ":" + minutes + ":" + seconds;
}

function setCountdown(hook) {
  var timerEnd = hook.el.dataset.end_date;

  var countdownDate = new Date(timerEnd);

  var interval = setInterval(function () {
    var now = new Date().getTime();

    var distance = countdownDate.getTime() - now;

    document.getElementById(hook.el.id).innerHTML = msToTime(distance);

    if (distance < 0) {
      clearInterval(interval);
    }
  }, 1000);

  return interval;
}

export default setCountdown;