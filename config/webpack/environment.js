const { environment } = require('@rails/webpacker')
const Dotenv = require('dotenv-webpack');

// TODO: are these loaded by default?
const dotenvFiles = [
  `.env.${process.env.NODE_ENV}.local`,
  '.env.local',
  `.env.${process.env.NODE_ENV}`,
  '.env'
];
environment.plugins.prepend('Dotenv', new Dotenv());

module.exports = environment
