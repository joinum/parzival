import { Html5Qrcode, Html5QrcodeSupportedFormats } from "../vendor/html5-qrcode.js"

function parseURL(url) {
  try {
    const url_obj = new URL(url);
    if (url_obj.host !== window.location.host) return null;
    return url_obj.pathname.split("/").at(-1);
  } catch {
    return null;
  }
}

export const QrScanner = {

  mounted() {
    const config = { fps: 4, qrbox: (width, height) => {return { width: width * 0.8, height: height * 0.9 }}};
    this.scanner = new Html5Qrcode(this.el.id, { formatsToSupport: [ Html5QrcodeSupportedFormats.QR_CODE ] });

    const onScanSuccess = (decodedText, decodedResult) => {
      const uuid = parseURL(decodedText);
  
      if (uuid && uuid !== this.lastRead) {
        this.lastRead = uuid;
        if (this.el.dataset.on_success)
          Function("uuid", this.el.dataset.on_success)(uuid);
      }
    }

    const startScanner = () => {
      this.scanner.start({ facingMode: "environment" }, config, onScanSuccess)
      .then((_) => {
        if (this.el.dataset.on_start)
          Function(this.el.dataset.on_start)();
      }, (e) => {
        if (this.el.dataset.on_error)
          Function(this.el.dataset.on_error)();
      });
    }

    if (this.el.dataset.ask_perm) {
      document.getElementById(this.el.dataset.ask_perm).addEventListener("click", startScanner);
    }

    if (this.el.dataset.open_on_mount !== undefined)
      startScanner();
  },

  destroyed() {
    this.scanner.stop().then((_) => {
      if (this.el.dataset.on_stop)
        Function(this.el.dataset.on_stop)();
    });
  }
}