class Term < ActiveRecord::Base
  belongs_to :school 
  has_many :projects 
  has_many :courses
  has_many :subjects 
  
  validates_presence_of :title 
  
  def Term.create_term(params_term, employee)
    if not employee.has_role?(:school_admin)
      return nil
    end
    
    Term.create(:title => params_term[:title], :school_id => employee.get_managed_school.id)
  end
  
  def close
    self.is_active = false 
    self.save 
  end
  
  def activate
    self.is_active = true 
    self.save 
  end
end
