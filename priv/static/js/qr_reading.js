import { Html5Qrcode, Html5QrcodeSupportedFormats } from "html5-qrcode";

function parseURL(url) {
  try {
    const url_obj = new URL(url);
    //TODO: check host
    //if (url_obj.host !== ${HOST_URL}) return null;
    return url_obj.pathname.split("/").at(-1);
  } catch {
    return null;
  }
}

const QrScanner = {

  mounted() {
    const config = { fps: 4, qrbox: (width, height) => {return { width: width * 0.8, height: height * 0.9 }}};
    this.scanner = new Html5Qrcode(this.el.id, { formatsToSupport: [ Html5QrcodeSupportedFormats.QR_CODE ] });

    const onScanSuccess = (decodedText, decodedResult) => {
      const uuid = parseURL(decodedText);
  
      if (uuid && uuid !== this.lastRead) {
        this.lastRead = uuid;
        if (typeof onSuccess === "function") {
          onSuccess(uuid);
        }
      }
    }

    const startScanner = () => {
      this.scanner.start({ facingMode: "environment" }, config, onScanSuccess)
      .then((_) => {
        console.log(onStart);
        if (typeof onStart === "function") {
          onStart();
        }
      }, (e) => {
        if (typeof onError === "function") {
          onError();
        }
      });
    }

    if (this.el.getAttribute("ask-perm")) {
      document.getElementById(this.el.getAttribute("ask-perm")).addEventListener("click", startScanner);
    }

    if (this.el.hasAttribute("open-on-mount")) {
      startScanner();
    }
  },

  destroyed() {
    this.scanner.stop().then((_) => {
      if (typeof onStop === "function") {
        onStop();
      }
    });
  }
}

export default QrScanner;