# frozen_string_literal: true

# An affective slider is a horizontal range with a gradient wedge underneath it and an image plus label at both ends.
# The variant determines which images are shown, the first and last labels are shown at the ends.
class AffectiveSliderGenerator < RangeGenerator
  WEDGE_IMAGE = 'affective_slider/wedge.svg'
  VARIANT_IMAGES = {
    pleasure: %w[affective_slider/unhappy.svg affective_slider/happy.svg],
    activation: %w[affective_slider/calm_heart.svg affective_slider/racing_heart.svg]
  }.freeze

  def generate(question)
    tag.div(super(question.except(:vertical, :gradient)), class: 'affective-slider')
  end

  private

  def range_labels(question)
    minmax = range_slider_minmax(question)
    left_image, right_image = variant_images(question)
    labels_body = safe_join([
                              end_label(question[:labels].first, left_image, 'left-align', minmax[:min]),
                              end_label(question[:labels].last, right_image, 'right-align', minmax[:max])
                            ])
    safe_join([
                tag.div(image_tag(resolved_image_path(WEDGE_IMAGE), alt: ''), class: 'affective-slider-wedge'),
                tag.div(labels_body, class: 'row label-row')
              ])
  end

  def variant_images(question)
    VARIANT_IMAGES.fetch(question[:variant]&.to_sym) do
      raise "Unknown affective slider variant #{question[:variant].inspect} for question #{question[:id]}, " \
            "expected one of #{VARIANT_IMAGES.keys.inspect}"
    end
  end

  def end_label(label, image, alignment, value)
    body = safe_join([
                       image_tag(resolved_image_path(image), alt: '', class: 'affective-slider-icon'),
                       tag.span(label, class: 'affective-slider-label')
                     ])
    tag.div(tag.span(body, class: 'affective-slider-end'),
            class: "col #{alignment} s6",
            data: { value: number_to_string(value) })
  end

  def resolved_image_path(image)
    ActionController::Base.helpers.image_path(image)
  end
end
