module ApplicationHelper

  def field_with_errors(object, method, &block)
    if block_given?
      if object.errors[method].empty?
        concat capture(&block)
      else
        concat content_tag(:div, capture(&block), class: "field_with_errors")
      end
    end
  end

  def local_phone_number number
    number.to_s.chars.insert(1, "-").join
  end

end
