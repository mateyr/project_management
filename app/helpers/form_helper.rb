# frozen_string_literal: true

module FormHelper
  include TailwindUtils

  def tailwind_form_for(object, **options, &block)
    form_class = "bg-white py-8 px-10 shadow rounded-lg flex flex-col flex-wrap justify-between gap-6"
    options[:html] = merge_classes(form_class, **(options[:html] || {}))
    options[:builder] = TailwindFormBuilder

    simple_form_for(object, **options, &block)
  end

  def form_error_notification(object)
    return unless object.errors.any?

    tag.div class: "flex items-start gap-1 w-full text-red-500 bg-red-50 p-2 rounded-md" do
      object.errors.full_messages.to_sentence.capitalize
    end
  end
end
