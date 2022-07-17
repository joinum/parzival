import setCountdown from './setCountdown';

const Countdown = {
  mounted() {
    this.timer = setCountdown(this);
  },
  beforeUpdate() {
    clearInterval(this.timer);
  },
  updated() {
    this.timer = setCountdown(this);
  },
  destroyed() {
    clearInterval(this.timer);
  },
};

export default Countdown;