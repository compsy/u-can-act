import Enzyme from 'enzyme'
import EnzymeAdapter from 'enzyme-adapter-react-16'

Enzyme.configure({ adapter: new EnzymeAdapter() })

import I18n from 'i18n'
I18n.defaultLocale = 'nl'
I18n.locale = 'nl'
