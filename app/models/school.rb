class School < ActiveRecord::Base
  has_many :users, :through => :enrollments
  has_many :enrollments
  
  has_many :terms 
  
  has_many :subjects
  
  has_many :failed_registrations
  
=begin
  For setup
=end

  def find_subject_by_code(code)
    Subject.find(:first, :conditions => {
      :school_id => self.id,
      :code => code.upcase 
    })
  end
  
  def find_student_by_nim( nim ) 
    self.students.find_by_nim( nim.upcase )
  end

  
  def teachers
    teacher_role = Role.find_by_name ROLE_NAME[:teacher]

    self.users.includes(:assignments).where{
      (assignments.role_id == teacher_role.id )
    }
  end
  
  def students
     student_role = Role.find_by_name ROLE_NAME[:student]

     self.users.includes(:assignments).where{
       (assignments.role_id == student_role.id )
     }
     
  end
  
  def has_enrollment?(user)
    Enrollment.find(:first,:conditions => {
      :user_id => user.id,
      :school_id => self.id
    })
  end
  
  
  
  
  def all_active_subjects
    self.subjects.where(:is_active => true ).
                includes(:courses, :subject_registrations ).
                order("created_at DESC")
  end
  
  def all_passive_subjects
    self.subjects.where(:is_active => false ).
                includes(:courses, :subject_registrations ).
                order("created_at DESC")
  end
  
  
  def send_total_statistic
    self.subjects.each do |subject|
      subject.courses.each do |course|
        NewsletterMailer.send_statistic(course,subject).deliver
      end
    end
  end
  
  def set_time_zone( offset_timezone)
    offset = offset_timezone.split("_")[0]
    time_zone = offset_timezone.split("_")[1]
    self.time_zone = time_zone
    self.utc_offset= offset.to_i
    self.save
  end
  
  def get_time_zone
    if self.time_zone.nil?  ||self.time_zone.length == 0 
      return "UTC"
    end
    
    self.time_zone 
  end
  
  def get_utc_offset
    if self.utc_offset.nil?
      return 0
    end
    
    return self.utc_offset 
  end
  
=begin
  delivery hours 
=end

  def array_of_scheduled_delivery_hours
    self.scheduled_delivery_hours.split(",").map {|x| x.to_i }
  end
  
  def set_delivery_method( selected_delivery_method, delivery_hours)
    # the delivery hour is specified at the user's time zone.. we need to convert it to UTC
    if selected_delivery_method == NOTIFICATION_DELIVERY_METHOD[:instant]
      self.delivery_method = NOTIFICATION_DELIVERY_METHOD[:instant]
      self.scheduled_delivery_hours = '' 
      self.save 
      # we must clear all the PolledDelivery
      PolledDelivery.delay.clear_all_pending_delivery( self )
      
      return 
    elsif selected_delivery_method == NOTIFICATION_DELIVERY_METHOD[:scheduled] && 
        delivery_hours.length != 0  #yeah, he uploaded the schedule 
      self.delivery_method = NOTIFICATION_DELIVERY_METHOD[:scheduled]
      self.scheduled_delivery_hours =  delivery_hours.map{ |x| ( x - self.get_utc_offset) %24 }.join(",")
      self.save 
      return
    else
        
    end
  end
  
  def delivery_hours_in_server_time
    self.scheduled_delivery_hours.split(",").map{|x| ( x.to_i )%24 }.sort
  end
  
  def delivery_hours_in_school_timezone
    # converting the delivery hours to user timezone
    self.scheduled_delivery_hours.split(",").map{|x| ( x.to_i + self.get_utc_offset )%24 }.sort
   
  end
  
end
