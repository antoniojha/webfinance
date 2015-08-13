json.array!(@contacts) do |contact|
  json.extract! contact, :id, :title, :issue_content, :email
  json.url contact_url(contact, format: :json)
end
