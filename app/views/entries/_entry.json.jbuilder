json.extract! entry, :id, :date, :description, :mood, :created_at, :updated_at
json.url entry_url(entry, format: :json)
