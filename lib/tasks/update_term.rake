



task :update_term => :environment do 
  School.all.each do |school|
    term = Term.create_term({:title => "#{school.name}-First Term"}, school.school_admins.first )
    school.subjects.each do |subject|
      subject.term_id = term.id 
      subject.save 
      subject.courses.each do |course|
        course.term_id = term.id
        course.save
        course.projects.each do |project|
          project.term_id = term.id 
          project.save
        end
      end
    end
  end
end

