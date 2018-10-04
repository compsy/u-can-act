ev_name = 'test_quest'
evaluatie = Questionnaire.find_by_name(ev_name)
evaluatie ||= Questionnaire.new(name: ev_name)
evaluatie.key = File.basename(__FILE__)[0...-3]
evaluatie.content = [{
                       id: :v1,
                       type: :dropdown,
                       label: 'RMC-regio',
                       title: 'Bij welke RMC-regio hoort uw school?',
                       tooltip: '<p>Als u het niet zeker weet, kunt u op dit kaartje kijken:</p><img height="640" src="/evaluatieonderzoek/rmcregios.png">',
                       options: [
                         '1. Oost-Groningen',
                         '2. Noord-Groningen-Eemsmond',
                         '3. Centraal en Westelijk Groningen',
                         '4. Friesland Noord',
                         '5. Zuid-West Friesland',
                         '6. De Friese Wouden',
                         '7. Noord- en Midden Drenthe',
                         '8. Zuid-Oost Drenthe',
                         '9. Zuid-West Drenthe',
                         '10. IJssel-Vecht',
                         '11. Stedendriehoek',
                         '12. Twente',
                         '13. Achterhoek',
                         '14. Arnhem/Nijmegen',
                         '15. Rivierenland',
                         '16. Eem en Vallei',
                         '17. Noordwest-Veluwe',
                         '18. Flevoland',
                         '19. Utrecht',
                         '20. Gooi en Vechtstreek',
                         '21. Agglomeratie Amsterdam',
                         '22. West-Friesland',
                         '23. Kop van Noord-Holland',
                         '24. Noord-Kennemerland',
                         '25. West-Kennemerland',
                         '26. Zuid-Holland-Noord',
                         '27. Zuid-Holland-Oost',
                         '28. Haaglanden',
                         '29. Rijnmond',
                         '30. Zuid-Holland-Zuid',
                         '31. Oosterschelde regio',
                         '32. Walcheren',
                         '33. Zeeuwsch-Vlaanderen',
                         '34. West-Brabant',
                         '35. Midden-Brabant',
                         '36. Noord-Oost-Brabant',
                         '37. Zuidoost-Brabant',
                         '38. Gewest Limburg-Noord',
                         '39. Gewest Zuid-Limburg'
                       ]
                     }, {
                       section_start: 'Tot slot',
                       id: :v2,
                       type: :number,
                       title: 'Wat is je postcode?',
                       tooltip: 'some tooltip',
                       pattern: '[0-9]{4}',
                       hint: 'Alleen de 4 nummers van de postcode.',
                       maxlength: 4,
                       placeholder: '1234',
                       required: true,
                       section_end: true,
                       min: 0,
                       max: 9999
                     }]
evaluatie.title = 'De huidige aanpak van voortijdig schoolverlaten en jongeren in kwetsbare posities: een evaluatie van het nationale beleid'
evaluatie.save!
