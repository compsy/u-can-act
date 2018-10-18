import Enzyme from 'enzyme'
import EnzymeAdapter from 'enzyme-adapter-react-16'

Enzyme.configure({ adapter: new EnzymeAdapter() })

import I18n from 'i18n'
I18n.defaultLocale = 'nl'
I18n.locale = 'nl'

// comment the line below if you want the tests to spec with e.g.,  "[missing "nl.pages.klaar.header" translation]'
// instead of the actual text.
require('translations')
