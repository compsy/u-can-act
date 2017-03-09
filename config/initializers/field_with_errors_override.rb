# Monkey patch to use a class instead of putting a div around invalid form fields.
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    class_attr_index = html_tag.index 'class="'
    class_attr_index ? html_tag.insert(class_attr_index+7, 'invalid ') : html_tag.insert(html_tag.index('>'),
                                                                                         ' class="invalid"')
end
