module ApplicationHelper

  def bootstrap_class_for(flash_type)
    case flash_type
    when :success
      "alert-success"
    when :error
      "alert-danger"
    when :warning
      "alert-warning"
    when :notice
      "alert-info"
    else
      flash_type.to_s
    end
  end

  def import_status_class(import)
    return "" unless import.ended_at

    import.success? ? "success" : "danger"
  end

end
