module ApplicationHelper
  def modal(modal_id:, modal_title:, modal_body:)
    render "shared/modal", modal_id: modal_id, modal_title: modal_title, modal_body: modal_body
  end
end
