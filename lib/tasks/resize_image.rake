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