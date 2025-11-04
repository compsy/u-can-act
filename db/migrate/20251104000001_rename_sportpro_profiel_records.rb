class RenameSportproProfielRecords < ActiveRecord::Migration[6.1]
  def up
    # Rename Protocol
    protocol = Protocol.find_by(name: 'sportpro_profiel_setup_protocol')
    if protocol
      protocol.update!(name: 'sportpro_profiel')
      puts "Renamed protocol"
    else
      puts "Protocol 'sportpro_profiel_setup_protocol' not found"
    end

    # Rename Push Subscription
    push_subscription = PushSubscription.find_by(name: 'base-platform-subscription-sportpro-profiel-setup')
    if push_subscription
      push_subscription.update!(name: 'base-platform-subscription-sportpro-profiel')
      puts "Renamed push subscription"
    else
      puts "Push subscription 'base-platform-subscription-sportpro-profiel-setup' not found"
    end

    # Rename Questionnaire by name
    questionnaire_by_name = Questionnaire.find_by(name: 'SportPro Profiel Setup')
    if questionnaire_by_name
      questionnaire_by_name.update!(
        name: 'SportPro Profiel',
        title: 'SportPro Profiel',
        key: 'sportpro_profiel'
      )
      puts "Renamed questionnaire by name"
    else
      puts "Questionnaire 'SportPro Profiel Setup' not found by name"
    end

    # Rename Questionnaire by key
    questionnaire_by_key = Questionnaire.find_by(key: 'sportpro_profiel_setup')
    if questionnaire_by_key && questionnaire_by_key != questionnaire_by_name
      questionnaire_by_key.update!(
        name: 'SportPro Profiel',
        title: 'SportPro Profiel',
        key: 'sportpro_profiel'
      )
      puts "Renamed questionnaire by key"
    elsif questionnaire_by_key
      puts "Questionnaire with key 'sportpro_profiel_setup' already updated"
    else
      puts "Questionnaire with key 'sportpro_profiel_setup' not found"
    end

    puts "\nMigration completed successfully!"
  end

  def down
    # Reverse the changes
    protocol = Protocol.find_by(name: 'sportpro_profiel')
    if protocol
      protocol.update!(name: 'sportpro_profiel_setup_protocol')
      puts "Reverted protocol"
    end

    push_subscription = PushSubscription.find_by(name: 'base-platform-subscription-sportpro-profiel')
    if push_subscription
      push_subscription.update!(name: 'base-platform-subscription-sportpro-profiel-setup')
      puts "Reverted push subscription"
    end

    questionnaire = Questionnaire.find_by(key: 'sportpro_profiel')
    if questionnaire
      questionnaire.update!(
        name: 'SportPro Profiel Setup',
        title: 'SportPro Profiel Setup',
        key: 'sportpro_profiel_setup'
      )
      puts "Reverted questionnaire"
    end

    puts "\nMigration rollback completed!"
  end
end
