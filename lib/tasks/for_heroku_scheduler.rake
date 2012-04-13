desc "Tasks associated with heroku scheduler"

# steps: clean duplicates
# then, do the final parsing 
task :production_clear_polled_deliveries => :environment do 
  # check all schools, check the delivery time. 
  # if the delivery time is between now and one hour from now
  # execute the delivery
  
  School.all.each do |school|
    current_time = Time.now #utc
    delivery_hours_in_server_time = school.delivery_hours_in_server_time  #utc 
    if delivery_hours_in_server_time.include?(  current_time.hour )
      PolledDelivery.delay.clear_all_pending_delivery( school )  
    end
  end
  
end


task :development_clear_polled_deliveries  => :environment do 
  school = School.find 1 
    PolledDelivery.delay.clear_all_pending_delivery( school )  
  
end