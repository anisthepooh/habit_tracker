# app/controllers/admin/communications_controller.rb
class Admin::CommunicationsController < Admin::BaseController
  def index
    @notifications = Noticed::Notification
      .includes(:recipient, :event)
      .order(created_at: :desc)
      .paginate(page: params[:page], per_page: 20)

    # Use a single query with aggregations for better performance
    stats_query = Noticed::Notification.group(
      "CASE 
        WHEN created_at >= '#{1.month.ago.to_formatted_s(:db)}' THEN 'this_month' 
        ELSE 'total' 
      END"
    ).count
    
    @stats = {
      total: Noticed::Notification.count,
      delivered: stats_query.values.sum, # All notifications are considered delivered in this system
      failed: 0, # No failure tracking yet
      this_month: stats_query['this_month'] || 0
    }
  end
end
