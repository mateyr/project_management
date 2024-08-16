# frozen_string_literal: true

module TailwindUtils
  def merge_classes(default_class, **kwargs)
    kwargs[:class] = TailwindMerge::Merger.new.merge([default_class, kwargs[:class]])
    kwargs
  end
end
