# frozen_string_literal: true

SimpleForm.setup do |config|
  # Wrappers configration
  config.wrappers :plain do |b|
    b.use :html5
    b.use :placeholder
    b.use :label
    b.wrapper :input_wrapper, tag: :div do |component|
      component.use :input
    end
    b.use :error, wrap_with: { tag: :span }
  end

  # Default configuration
  # config.generate_additional_classes_for = []
  config.default_wrapper = :plain
  config.label_text = ->(label, _required, _explicit_label) { label.to_s }
  # config.boolean_style = :nested
  # config.form_class = 'bg-white py-8 px-4 shadow sm:rounded-lg sm:px-10'
  # config.button_class = 'w-full mt-6 flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-blue-500 hover:bg-blue-500 focus:outline-none focus:border-indigo-700 focus:shadow-outline-indigo active:bg-indigo-700 transition duration-150 ease-in-out'
  # config.error_notification_tag = :div
  # config.error_notification_class = 'error_notification'
  # config.browser_validations = false
  # config.boolean_label_class = 'checkbox'
end
