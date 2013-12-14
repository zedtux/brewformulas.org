#
# Main application helpers
#
# @author [guillaumeh]
#
module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type
    when :success then 'alert-success'
    when :error   then 'alert-danger'
    when :warning then 'alert-warning'
    when :notice  then 'alert-info'
    else
      flash_type.to_s
    end
  end

  def import_status_class(import)
    return '' unless import.ended_at

    import.success? ? 'success' : 'danger'
  end
end
