/** @type {import('tailwindcss').Config} */
module.exports = {
  // Every class the site uses is written in these files. Content from portfolio-config.json
  // is rendered as plain text, so it never introduces classes of its own.
  content: [
    './src/main/resources/templates/**/*.ftl',
    './src/main/resources/static/js/**/*.js',
  ],
  theme: {
    extend: {},
  },
  plugins: [],
};
