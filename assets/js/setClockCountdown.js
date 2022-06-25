function setClockCountdown(hook) {
  var timerStart = hook.el.dataset.start_date;
  var timerEnd = hook.el.dataset.end_date;

  var countdownDate = new Date(timerEnd);

  var interval = setInterval(function () {
    var now = new Date().getTime();

    var interval = new Date(timerEnd) - new Date(timerStart)

    var distance = countdownDate.getTime() - now;

    var percentage = ((distance / interval) * 100) % 360

    document.getElementById(hook.el.id).innerHTML = `<div style="background: conic-gradient(red 0deg, red ${percentage}deg, yellow 0deg, yellow 360deg); width: 2.5rem; height: 2.5rem; border-radius: 0.5rem"/>`

    if (distance <= 0) {
      clearInterval(interval);
    }
  }, 1000);

  return interval;
}

export default setClockCountdown;