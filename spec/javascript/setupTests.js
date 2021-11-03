import Enzyme from 'enzyme'
import EnzymeAdapter from 'enzyme-adapter-react-16'

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

// comment the line below if you want the tests to spec with e.g.,  "[missing "nl.pages.klaar.header" translation]'
// instead of the actual text.
require('../../public/javascripts/translations')

// To check if we're in a test
process.env.TESTING = 'true'
