desc "Resize image with lower quality"

# steps: clean duplicates
# then, do the final parsing 
task :store_current => :environment do 
  filename = 'to_be_deleted.txt'
  Picture.all.each do |pic|
    if pic.picture_filetype == PICTURE_FILETYPE[:image]
      puts "Gonna write #{pic.id}"
    else
      next
    end
    
    File.open(Rails.root.to_s + "/lib/tasks/" + "#{filename}", 'a') do |f| 
      f.puts(pic.index_image_url) 
      f.puts(pic.display_image_url) 
      f.puts(pic.revision_image_url) 
    end
  end
end



task :change_image_quality => :environment do 
  Picture.all.each do |pic|
    if pic.picture_filetype == PICTURE_FILETYPE[:image]
      pic.delay.resize_quality
    else
      next
    end
  end
end


task :fix_database_to_accomodate_is_graded => :environment do 
  Picture.all.each do |pic|
    if pic.score != 0 and pic.is_approved == true 
      pic.is_graded = true 
    end
    pic.save 
  end
end

task :move_email_to_development => :environment do 
  array = ["fotoferdytan@gmail.com", "kurniast@yahoo.com", "kelas_fotografi@yahoo.com"  ]
  if Rails.env.development?
    array.each do |email|
      a =  User.find_by_email email
      a.password = 'willy1234'
      a.password_confirmation = 'willy1234'
      a.save
    end
  end
end


task :set_all_past_user_activity_to_true => :environment do 
  UserActivity.all.each do |x|
    x.is_notification_sent = true 
    x.save 
  end
end



