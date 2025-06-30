module ApplicationHelper
  def modal(modal_id:, modal_title:, modal_body:)
    render "shared/modal", modal_id: modal_id, modal_title: modal_title, modal_body: modal_body
  end

  MOOD_MAP = {
  "happy" => "😀",
  "sad" => "😞",
  "angry" => "😠",
  "tired" => "😴",
  "excited" => "🤩",
  "neutral" => "😐",
  "anxious" => "😰",
  "loved" => "❤️"
}.freeze

def mood_label(value)
  MOOD_MAP[value] || value.to_s.humanize
end

def ios_device?
  return false unless request.user_agent

  user_agent = request.user_agent.downcase
  user_agent.include?("iphone") || user_agent.include?("ipad") || user_agent.include?("ipod")
end
end
