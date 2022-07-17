import setClockCountdown from './setClockCountdown';

const Clock = {
  mounted() {
    this.timer = setClockCountdown(this);
  },
  beforeUpdate() {
    clearInterval(this.timer);
  },
  updated() {
    this.timer = setClockCountdown(this);
  },
  destroyed() {
    clearInterval(this.timer);
  },
};

export default Clock;