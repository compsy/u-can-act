# frozen_string_literal: true

module RelativePathRedirect
  RELATIVE_PATH = %r{\A/(?![/\\])[^\\[:space:][:cntrl:]]*\z}

  private

  def relative_path(value)
    value if value.is_a?(String) && RELATIVE_PATH.match?(value)
  end
end
