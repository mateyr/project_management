class Test < ApplicationRecord
  enum star: %i[not_started in_progress done]
end
