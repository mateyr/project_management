class TailwindFormBuilder < SimpleForm::FormBuilder
  def input(attribute_name, options = {}, &block)
    # The default Tailwind classes for the various parts of the Simple Form wrapper layout.
    input_class = "appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md placeholder-gray-400 focus:outline-none focus:shadow-outline-blue focus:border-blue-300 transition duration-150 ease-in-out sm:text-sm sm:leading-5 #{'text-gray-500 bg-gray-50' if options.dig(
      :input_html, :disabled
    )}"
    input_wrapper_class = "w-full mt-1 relative rounded-md shadow-sm"
    wrapper_class = "mt-6 w-full"
    label_wrapper_class = "border"
    hint_class = "mt-2 text-sm"
    error_class = "mt-2 text-sm error text-red-600"

    case options[:as]
    when :boolean
      input_class = "focus:ring-indigo-500"

      options[:boolean_style] ||= :inline
      options[:wrapper] ||= :plain_boolean

      input_wrapper_class = "flex h-10"

    when :file
      input_class = "block w-full file:px-4 file:py-2"

    when :date, :datetime
      options[:html5] = options.fetch(:html5, true) # use HTML5 date/time inputs by default
    end

    options[:input_html] = arguments_with_updated_default_class(input_class, **(options[:input_html] || {}))
    options[:input_wrapper_html] = arguments_with_updated_default_class(input_wrapper_class,
                                                                        **(options[:input_wrapper_html] || {}))
    options = convert_col_span_argument_to_class(**options)
    options[:wrapper_html] = arguments_with_updated_default_class(wrapper_class,
                                                                  **options[:wrapper_html] || {})
    options[:label_wrapper_html] = arguments_with_updated_default_class(label_wrapper_class,
                                                                        **(options[:label_wrapper_html] || {}))
    options[:hint_html] = arguments_with_updated_default_class(hint_class, **(options[:hint_html] || {}))
    options[:error_html] = arguments_with_updated_default_class(error_class, **(options[:error_html] || {}))
    super(attribute_name, options, &block)
  end

  def label(attribute_name, *args, &block)
    options = args.extract_options!.dup
    default_class = 'block text-sm font-medium leading-5  text-gray-700'
    options = arguments_with_updated_default_class(default_class, **options)

    super(attribute_name, *(args << options), &block)
  end

  # Renders a generic button. A submit button is handled by the method below instead.
  def button(type, *args, &block)
    return super(type, *args, &block) if type == :submit # submit buttons are delegated to the `submit` method below

    button_options = args.extract_options!.dup
    default_classes = "w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-blue-500 hover:bg-blue-500 focus:outline-none focus:border-indigo-700 focus:shadow-outline-indigo active:bg-indigo-700 transition duration-150 ease-in-out"

    button_options = convert_col_span_argument_to_class(key: nil, **button_options)
    button_options = arguments_with_updated_default_class(default_classes, **button_options)
    args << button_options

    super(type, *args, &block)
  end

  # Renders a submit button.
  def submit(value = nil, options = {})
    default_classes = "w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-blue-500 hover:bg-blue-500 focus:outline-none focus:border-indigo-700 focus:shadow-outline-indigo active:bg-indigo-700 transition duration-150 ease-in-out"

    button_options = convert_col_span_argument_to_class(key: nil, **options)
    button_options = arguments_with_updated_default_class(default_classes, **button_options)

    # ActionController::Base.helpers.content_tag(:div, class: 'mt-6') do
    super(value, button_options)
    # end
  end

  def convert_col_span_argument_to_class(key: :wrapper_html, class_prefix: "sm:", **kwargs)
    kwargs = kwargs.dup
    return kwargs unless kwargs.key?(:col_span)

    col_span = kwargs.delete(:col_span)

    css_class = if key
                  kwargs.dig(key, :class).to_s
                else
                  kwargs[:class]
                end

    css_class = ((css_class || "").split << "#{class_prefix}col-span-#{col_span}").join(" ")

    if key
      kwargs[key] ||= {}
      kwargs[key][:class] = css_class
    else
      kwargs[:class] = css_class
    end

    kwargs
  end

  def arguments_with_updated_default_class(default_class, prefix: nil, **kwargs)
    kwargs = kwargs.dup
    classes = default_class.to_s
    prefix = "#{prefix}_" if prefix

    remove_key = :"remove_default_#{prefix}class"
    class_key = :"#{prefix}class"

    if kwargs[remove_key].present?
      classes = (classes.split - kwargs[remove_key].split).join(' ')
      kwargs.delete(remove_key)
    end

    # simple_form sometimes uses array of classes instead of strings
    kwargs[class_key] = kwargs[class_key].map(&:to_s).join(' ') if kwargs[class_key].is_a?(Array)

    kwargs[class_key] = (classes.split + kwargs[class_key].to_s.split).join(' ')
    kwargs
  end
end
