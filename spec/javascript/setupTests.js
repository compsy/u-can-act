import Enzyme from 'enzyme'
import EnzymeAdapter from '@cfaester/enzyme-adapter-react-18'

Enzyme.configure({ adapter: new EnzymeAdapter() });

// Make jquery available
import $ from 'jquery';
global.$ = global.jQuery = $;

// materialize-css is only used in the specs
require('materialize-css')

// I18n stuff
import I18n from '../../public/javascripts/i18n';
I18n.defaultLocale = 'nl';
I18n.locale = 'nl';

import util from 'util';
Object.defineProperty(global, 'TextEncoder', {
  value: util.TextEncoder,
});

// comment the line below if you want the tests to spec with e.g.,  "[missing "nl.pages.klaar.header" translation]'
// instead of the actual text.
require('../../public/javascripts/translations')

// To check if we're in a test
process.env.TESTING = 'true'
