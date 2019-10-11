# frozen_string_literal: true

title = 'Maandag'

name = 'KCT Maandag'
questionnaire = Questionnaire.find_by_name(name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

content = [
  {
    type: :raw,
    content: '
    <p class="flow-text section-explanation">
    Wil je hieronder zo eerlijk en nauwkeurig mogelijk aangeven hoe jij je op dit moment voelt?

    <table>
      <tr><td>6</td><td></td></tr>
      <tr><td>7</td><td>heel, heel licht inspannend</td></tr>
      <tr><td>8</td><td></td></tr>
      <tr><td>9</td><td>heel licht inspannend</td></tr>
      <tr><td>10</td><td></td></tr>
      <tr><td>11</td><td>licht inspannend</td></tr>
      <tr><td>12</td><td></td></tr>
      <tr><td>13</td><td>redelijk inspannend</td></tr>
      <tr><td>14</td><td></td></tr>
      <tr><td>15</td><td>inspannend</td></tr>
      <tr><td>16</td><td></td></tr>
      <tr><td>17</td><td>heel inspannend</td></tr>
      <tr><td>18</td><td></td></tr>
      <tr><td>19</td><td>heel, heel inspannend</td></tr>
      <tr><td>20</td><td></td></tr>
    </table>

    </p>'
  }, {
    id: :v1,
    type: :radio,
    required: true,
    title: 'Hoe inspannend was deze week voor jou?',
    options: [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
  },
  {
    id: :v2,
    type: :radio,
    title: 'Hoe vermoeid voel je je op dit moment?',
    options: %w['Helemaal niet vermoeid' 2 3 4 5 6 'Heel erg vermoeid'],
  },
  {
    id: :v3,
    type: :radio,
    title: 'Hoe heb je de afgelopen nachten geslapen?',
    options: %w['Heel erg slecht' 2 3 4 5 6 'Heel erg goed'],
  },

]
questionnaire.content = content
questionnaire.title = title
questionnaire.save!
