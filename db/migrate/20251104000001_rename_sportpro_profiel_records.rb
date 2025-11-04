class RenameSportproProfielRecords < ActiveRecord::Migration[6.1]
  def up
    # Rename Protocol
    protocol = Protocol.find_by(name: 'sportpro_profiel_setup_protocol')
    existing_protocol = Protocol.find_by(name: 'sportpro_profiel')
    
    if protocol && !existing_protocol
      protocol.update!(name: 'sportpro_profiel')
      puts "Renamed protocol"
    elsif existing_protocol
      puts "Protocol 'sportpro_profiel' already exists - skipping"
    else
      puts "Protocol 'sportpro_profiel_setup_protocol' not found - skipping"
    end

    # Rename Push Subscription
    push_subscription = PushSubscription.find_by(name: 'base-platform-subscription-sportpro-profiel-setup')
    existing_push_subscription = PushSubscription.find_by(name: 'base-platform-subscription-sportpro-profiel')
    
    if push_subscription && !existing_push_subscription
      push_subscription.update!(name: 'base-platform-subscription-sportpro-profiel')
      puts "Renamed push subscription"
    elsif existing_push_subscription
      puts "Push subscription 'base-platform-subscription-sportpro-profiel' already exists - skipping"
    else
      puts "Push subscription 'base-platform-subscription-sportpro-profiel-setup' not found - skipping"
    end

    # Handle Questionnaire - check by name first, then by key
    questionnaire_by_name = Questionnaire.find_by(name: 'SportPro Profiel Setup')
    questionnaire_by_key = Questionnaire.find_by(key: 'sportpro_profiel_setup')
    existing_questionnaire = Questionnaire.find_by(key: 'sportpro_profiel')
    existing_by_name = Questionnaire.find_by(name: 'SportPro Profiel')
    
    if existing_questionnaire || existing_by_name
      puts "Questionnaire 'SportPro Profiel' already exists - skipping"
    elsif questionnaire_by_name
      questionnaire_by_name.update!(
        name: 'SportPro Profiel',
        title: 'SportPro Profiel',
        key: 'sportpro_profiel'
      )
      puts "Renamed questionnaire by name"
    elsif questionnaire_by_key
      questionnaire_by_key.update!(
        name: 'SportPro Profiel',
        title: 'SportPro Profiel',
        key: 'sportpro_profiel'
      )
      puts "Renamed questionnaire by key"
    else
      puts "No questionnaire to rename found - skipping"
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
