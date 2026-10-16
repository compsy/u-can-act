/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// console.log('Hello World from Webpacker')
import 'babel-polyfill'

import '../stylesheets/application.scss'

// Make jquery available
import $ from 'jquery'
global.$ = global.jQuery = $

// I18n stuff
import I18n from '../../../public/javascripts/i18n';
// The layout puts the Rails locales in meta tags. Fall back to nl, the previous fixed value, when they are missing.
const metaContent = name => {
  const meta = document.querySelector(`meta[name="${name}"]`)
  return meta && meta.content
}
I18n.defaultLocale = metaContent('i18n-default-locale') || 'nl'
I18n.locale = metaContent('i18n-locale') || I18n.defaultLocale
require('../../../public/javascripts/translations')
// Questionnaire content can be in more languages than the interface, so fall back to English for those
// (same as config.i18n.fallbacks in config/application.rb). nl and en keep their own behaviour.
;['fi', 'de', 'es', 'pt'].forEach(locale => { I18n.locales[locale] = [locale, 'en', 'nl'] })

// Support component names relative to this directory:
const componentRequireContext = require.context('components', true)
const ReactRailsUJS = require('react_ujs')
ReactRailsUJS.useContext(componentRequireContext)
