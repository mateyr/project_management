# frozen_string_literal: true

# Integrates Tailwind CSS styles and addresses issues related to merging
# default and custom classes, ensuring consistent styling of form elements
# while avoiding conflicts with Tailwind's CSS specificity rules
class TailwindFormBuilder < SimpleForm::FormBuilder
  include TailwindUtils

  def input(attribute_name, options = {}, &block)
    wrapper_class = 'flex-auto'
    input_wrapper_class = 'relative rounded-md shadow-sm'
    input_class = "appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md placeholder-gray-400 focus:outline-none focus:border-blue-300 transition duration-150 ease-in-out #{'text-gray-500 bg-gray-50' if options.dig(
      :input_html, :disabled
    )}"
    # hint_class = "mt-2 text-sm"
    error_class = "mt-2 text-sm error text-red-600"

    options[:wrapper_html] = merge_classes(wrapper_class, **(options[:wrapper_html] || {}))
    options[:input_wrapper_html] = merge_classes(input_wrapper_class, **(options[:input_wrapper_html] || {}))
    options[:input_html] = merge_classes(input_class, **(options[:input_html] || {}))
    # options[:hint_html] = merge_classes(hint_class, **(options[:hint_html] || {}))
    options[:error_html] = merge_classes(error_class, **(options[:error_html] || {}))

    # Sets :error to false by default if not provided.
    # This ensures errors are not displayed automatically unless explicitly specified.
    options[:error] ||= false

    super(attribute_name, options, &block)
  end

  def label(attribute_name, *args, &block)
    label_options = args.extract_options!.dup
    label_class = "block text-sm font-medium leading-5  text-gray-700"
    label_options = merge_classes(label_class, **label_options)

    super(attribute_name, *(args << label_options), &block)
  end

  def button(type, *args, &block)
    return super(type, *args, &block) if type == :submit

    button_options = args.extract_options!.dup
    button_class = "btn btn--primary"

    button_options = merge_classes(button_class, **button_options)
    args << button_options

    super(type, *args, &block)
  end

  def submit(value = nil, options = {})
    submit_class = "btn btn--primary"
    submit_options = merge_classes(submit_class, **options)

    super(value, submit_options)
  end
end
