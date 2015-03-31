module SchedulesHelper
  
  def current_month_dates(date)
    (date.beginning_of_month .. date.end_of_month).map{ |date|
      [date.strftime("%m-%d-%Y(%a)"), date]
      }
  end
  def hours_in_day
    time_start = Time.now.beginning_of_day+6.hours
    time_end = Time.now.end_of_day
    times=[time_start].tap { |array| array << array.last + 1.hour while array.last <= time_end }
    times.each_with_index do |time,index|
      if index <times.size-1
        times[index]=time.strftime("%l:%M%P")+"-"+times[index+1].strftime("%l:%M%P")
      end
    end
    times.pop
    times
  end
end
