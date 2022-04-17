// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration
module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/*_web.ex",
    "../lib/*_web/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
        primary: "#b62020",
        secondary: "#ea3b2d",
        tertiary: "#ef5e56",
        quaternary: "#e49f9d",
        quinary: "#ffffff",
        success: "#008F05",
        failure: "#FF4444",
        warning: "#E09200",
      },
      fontFamily: {
        montserrat: ["Montserrat"],
      },
      screens: {
        "xs": "500px",
        "0.5xl": "1370px",
      },
    },
  },
  plugins: [require("@tailwindcss/forms")],
};