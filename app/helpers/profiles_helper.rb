module ProfilesHelper
  def current_month_has_plan?
    user=current_user
    if user.backgrounds.count>0
    (user.backgrounds.order(:created_at).last.created_at.month == Time.zone.today.month)? true : false
    else
      false
    end
  end
  def current_month_plan
    user=current_user
    if user.backgrounds.count>0
      user.backgrounds.order(:created_at).last
    else
      nil
    end
  end
end
