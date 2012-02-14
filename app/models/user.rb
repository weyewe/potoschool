class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :username, :email, :password, :password_confirmation, :remember_me
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
  
  
  
  def User.retrieve_or_create( user_params )
    user = User.find_by_email user_params[:email]
    
    if user.nil?
      new_password = UUIDTools::UUID.timestamp_create.to_s[0..7]
      User.create :username => (User.count + 1).to_s,
                  :password => new_password ,
                  :password_confirmation => new_password , 
                  :email => user_params[:email]
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
  
  # assumption -> the current_user's enrollment is only 1 
  # and the current user is the SchoolAdmin
  def get_managed_school
    self.schools.first 
  end
  
  
  
  
   
   
  
  
 
  
  
    
  
  
  
  
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
