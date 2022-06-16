var video = document.getElementById('video');
var canvas = document.getElementById("canvas");
var context = canvas.getContext("2d");


video.setAttribute('playsinline', '');
video.setAttribute('autoplay', '');
video.setAttribute('muted', '');
video.style.width = '200px';
video.style.height = '200px';

/* Setting up the constraint */
var facingMode = "environment"; // Can be 'user' or 'environment' to access back or front camera (NEAT!)
var constraints = {
audio: false,
video: {
    facingMode: facingMode
}
};

/* Stream it to video element */
navigator.mediaDevices.getUserMedia(constraints).then(function success(stream) {
    video.srcObject = stream;
});

        
video.addEventListener('play', function () {
    var $this = this; //cache
    var x = 400;
    var y = x * $this.videoHeight / $this.videoWidth;
    var delay = 1000 / 60;
    (function loop() {
        if (!$this.paused && !$this.ended) {
            context.drawImage($this, 0, 0, x, y);
            var image = context.getImageData(0, 0, x, y).data;
            const code = jsQR(image, x, y);
            
            if(code && code.data != "") {
                //Success
                console.log(code.data);
            }
                

            setTimeout(loop, delay);
        }
    })();
}, 0);