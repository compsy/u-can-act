Questionnaire.all.each do |questionnaire|
  ResponseExporter.export_headers(questionnaire, bust_cache: true)
  Rails.logger.info "Calculated headers for questionnaire: #{questionnaire.key}"
end
