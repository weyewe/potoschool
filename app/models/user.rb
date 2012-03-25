class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :username, :email, :password, :password_confirmation, :remember_me,
          :name, :nim
          
  attr_accessor :login
  
  # Models  => Role locking is based on user
  has_many :assignments
  has_many :roles, :through => :assignments
  
  
  # validation
  validates_presence_of :username
  validates_uniqueness_of :username
  validates_confirmation_of :password , :message => "Password doesn't match password confirmation"
  
  
  # student, teacher, admin belongs to school through enrollments
  has_many :schools, :through => :enrollments
  has_many :enrollments
  
  # subject has many teachers through subject_teaching_assignments
  has_many :subjects, :through => :subject_teaching_assignments
  has_many :subject_teaching_assignments
  
  #teacher has many courses through course teaching assignment
  has_many :courses, :through => :course_teaching_assignments
  has_many :course_teaching_assignments
  
  # student, registering for the subject
  has_many :subjects, :through => :subject_registrations
  has_many :subject_registrations
  
  
  # student. registering for the course 
  has_many :courses, :through => :course_registrations
  has_many :course_registrations
  
  # student, registered to a group
  has_many :groups , :through => :group_memberships
  has_many :group_memberships
  
  # student, submit project
  has_many :projects, :through => :project_submissions
  has_many :project_submissions
  
  
  # after_create :send_invitation 
  
  
  def User.retrieve_or_create( user_params )
    user = User.find_by_email user_params[:email]
    
    if user.nil?
      new_password = UUIDTools::UUID.timestamp_create.to_s[0..7]
      User.create :username => (User.count + 1).to_s,
                  :password => new_password ,
                  :password_confirmation => new_password , 
                  :email => user_params[:email]
                  
      # send the notification 
      # User.delay.send_new_registration_notification( new_user, new_password)
    else
      return user 
    end
  end
  
  def User.retrieve_or_create_with_password( user_params , password )
    user = User.find_by_email user_params[:email]
    
    if user.nil?
      User.create :username => (User.count + 1).to_s,
                  :password => password ,
                  :password_confirmation => password , 
                  :email => user_params[:email],
                  :name => user_params[:name],
                  :nim => user_params[:nim]
                  
      # send the notification 
      # User.delay.send_new_registration_notification( new_user, new_password)
    else
      return user 
    end
  end
  
    
  
  def User.create_and_assign_roles( new_user, role_id_array)
    for role_id in role_id_array
      role = Role.find_by_id( role_id.to_i )
      new_user.roles << role 
    end
    
    new_user.save
  end
  
  
  def update_roles( new_role_id_array )
    current_role_id_array = Assignment.find(:all, :conditions => {
      :user_id => self.id
    }).collect{ |x| x.role_id }
    
    role_to_be_destroyed  = current_role_id_array - new_role_id_array
    role_to_be_created    = new_role_id_array   - current_role_id_array
    
    role_to_be_destroyed.each do |x|
      Assignment.find(:first, :conditions => {
        :role_id => x, :user_id => self.id
      }).destroy 
    end
    
    role_to_be_created.each do |x|
      Assignment.create :role_id => x , :user_id  => self.id
    end
    
  end
  
  
  
  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end
  
  def add_role_if_not_exist(role_id)
    result = Assignment.find(:all, :conditions => {
      :user_id => self.id,
      :role_id => role_id
    })
    
    if result.size == 0 
      Assignment.create :user_id => self.id, :role_id => role_id
    end
  end
  
  
  
=begin
  Code for school_admin
=end
  # assumption -> the current_user's enrollment is only 1 
  # and the current user is the SchoolAdmin
  def get_managed_school
    self.schools.first 
  end
  
  def manage_school?(school)
    get_managed_school.id == school.id 
  end
  
  def get_enrolled_school
    get_managed_school
  end
  
  

  
  
=begin
  Code for teacher
=end

  def enrollment_code_for(subject)
    Enrollment.find(:first, :conditions => {
      :user_id => self.id, :school_id => subject.school.id
    }).enrollment_code
  end
  
  def total_courses_count
    CourseTeachingAssignment.find(:all, :conditions => {
      :user_id => self.id,
      :is_active => true 
    }).count
  end
  
  def all_courses_for_subject(subject)
    Course.joins(:course_teaching_assignments => :user ).
          where(
          { :course_teaching_assignments => {:user => {:id => self.id } } }    &
          { :course_teaching_assignments => {:is_active => true}} & 
          { :subject_id => subject.id}
          
          )
  end
  
  def all_courses_taught

    Course.joins(:course_teaching_assignments => :user ).
          where(
          { :course_teaching_assignments => {:user => {:id => self.id } } }    &
          { :course_teaching_assignments => {:is_active => true}}
          
          )
    
  end
  
  def teach_course?(course)
    not CourseTeachingAssignment.find(:first,:conditions => {
      :user_id => self.id,
      :course_id => course.id
    }).nil?
  end
  
  def all_courses_and_groups_taught

    Course.includes(:groups).joins(:course_teaching_assignments => :user ).
          where(:course_teaching_assignments => {:user => {:id => self.id } } )
    
  end
  
  def total_subjects_count
    SubjectTeachingAssignment.find(:all, :conditions => {
      :user_id => self.id,
      :is_active => true 
    }).count
  end
  
  def all_subjects_taught 
    Subject.joins(:subject_teaching_assignments => :user ).
          where({   :subject_teaching_assignments => {:user => {:id => self.id } } }  & 
                {   :subject_teaching_assignments => {:is_active => true }   })
  end
  
  def all_active_projects
    # we have to use eager loading
    # project.course
    # project.course.subject  
    ## all these shit in one single query. Or else, time consuming 
    all_courses_id = self.all_courses_taught.select(:id).collect do | course |
      course.id
    end
    
    # find all courses taught by the teacher
    # for each of the courses, find all the active projects 
    
    Project.find(:all, :conditions => {
      :is_active => true, 
      :course_id  => all_courses_id
    }, :order => "created_at ASC")
    
  end
  
  def all_projects
    all_courses_id = self.all_courses_taught.select(:id).collect do | course |
      course.id
    end
    
    # Project.find(:all, :conditions => {
    #       :course_id  => all_courses_id
    #     }, :order => "created_at ASC")
    
    Project.where(:course_id => all_courses_id)
    
  end
  
  def all_passive_projects
    # we have to use eager loading
    # project.course
    # project.course.subject  
    ## all these shit in one single query. Or else, time consuming 
    all_courses_id = self.all_courses_taught.select(:id).collect do | course |
      course.id
    end
    
    # find all courses taught by the teacher
    # for each of the courses, find all the active projects 
    
    Project.find(:all, :conditions => {
      :is_active => false, 
      :course_id  => all_courses_id
    }, :order => "deadline_datetime DESC")
  end
  
  
  def total_courses_count_for(subject)
    SubjectTeachingAssignment.find(:all, :conditions => {
      :user_id => self.id, :subject_id => subject.id, :is_active => true 
    }).count
  end
  
  def is_teaching_subject?(subject)
    not SubjectTeachingAssignment.find(:first, :conditions => {
      :user_id => self.id, :subject_id => subject.id, :is_active => true 
    }).nil? 
  end
  
  def is_teaching_course?(course)
    not CourseTeachingAssignment.find(:first, :conditions => {
      :user_id => self.id, :course_id => course.id, :is_active => true 
    }).nil? 
  end
  
  
  # grading the submission
  
  def is_allowed_to_grade?(project_submission)
    # if the teacher has the course teaching assignment 
    project = project_submission.project
    CourseTeachingAssignment.find(:first, :conditions => {
      :course_id => project.course.id,
      :user_id => self.id,
      :is_active  => true 
    })
  end
  
  
  
  

=begin
  Code for student
=end

  def project_submission_for_project( project ) 
    ProjectSubmission.find(:first, :conditions => {
      :project_id => project.id , 
      :user_id => self.id
    })
  end
  
  def is_subject_registered?(subject)
    not SubjectRegistration.find(:first, :conditions => {
      :user_id => self.id , :subject_id => subject.id,
      :is_active => true 
      }).nil?
  end


  

  def is_course_registered?(course)
    not CourseRegistration.find(:first, :conditions => {
      :user_id => self.id , :course_id => course.id,
      :is_active => true 
      }).nil?
  end

  def is_group_member?(group)
    GroupMembership.find(:first, :conditions => {
      :group_id => group.id, :user_id => self.id
    })
  end
  
  def is_group_leader?(group)
    Group.group_leader_id == self.id 
  end
  
  
  def is_submission_owner?(project_submission)
    project_submission.user_id == self.id
  end
  
  # for a given course, student can only be registered in 1 group 
  def group_for_course(course)
    student = self
    group_memberships = GroupMembership.where{  
      (group_id.in(  course.groups.select{id}  )) & 
      (user_id.eq student.id)
    }

    if group_memberships.length == 0 
      return nil
    else
      group_memberships.first.group
    end
  end
  
  def registered_course_for_subject( subject )
    student = self 
    course_registrations = CourseRegistration.where{
      (course_id.in( subject.courses.select{id})) &
      (user_id.eq student.id)
    }
    
    if course_registrations.length == 0 
      return nil
    else
      course_registrations.first.course
    end
  end
  
  def group_membership_for( group )
    group_membership = GroupMembership.find(:first, :conditions => {
      :group_id => group.id,
      :user_id => self.id 
    })
    
    if group_membership.nil?
      return GroupMembership.new
    end
    
    return group_membership
  end

 
    
  
  
=begin
  In user registration
=end

  def User.send_new_registration_notification( new_user, new_password)
    NewsletterMailer.notify_new_user_registration( new_user, new_password ).deliver
  end
  
  # def self.send_all_failed_registration
  #     destination = ["kumakinsey@gmail.com", "w.yunnal@gmail.com"]
  #     puts "before the delayed job"
  #     self.delay.execute_send_all_failed_registration(destination)
  #   end
  #   
  #   def self.execute_send_all_failed_registration(email)
  #     puts "delayed job execution"
  #     NewsletterMailer.importing_update( email ).deliver
  #   end
  
  protected
  def self.find_for_database_authentication(conditions)
       login = conditions.delete(:login)
       where(conditions).where({:username => login} | { :email => login}).first
     end
   
     def self.find_or_initialize_with_errors(required_attributes, attributes, error=:invalid)
       case_insensitive_keys.each { |k| attributes[k].try(:downcase!) }
   
       attributes = attributes.slice(*required_attributes)
       attributes.delete_if { |key, value| value.blank? }
   
       if attributes.size == required_attributes.size
         if attributes.has_key?(:login)
           login = attributes.delete(:login)
           record = find_record(login)
         else
           record = where(attributes).first
         end
       end
   
       unless record
         record = new
   
         required_attributes.each do |key|
           value = attributes[key]
           record.send("#{key}=", value)
           record.errors.add(key, value.present? ? error : :blank)
         end
       end
       record
     end
   
     def self.find_record(login)
       where({:username => login} | { :email => login}).first
     end
end
