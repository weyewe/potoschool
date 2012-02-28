class CoursesController < ApplicationController
  def new 
    
    @subject = Subject.find_by_id( params[:subject_id] )
    @new_course = Course.new 
    
    add_breadcrumb "Pick the subject", 'subjects_path'
    set_breadcrumb_for @subject, 'new_subject_course_path' + "(#{@subject.id})", 
              'Create new course for ' + "#{@subject.name}"
  end
  
  def create
    @subject = Subject.find_by_id(params[:subject_id])
    @course = Course.new( params[:course] )
    @course.subject_id = @subject.id
    
    @course.save 
    
    redirect_to new_subject_course_url(@subject)
  end
  
  
  def pick_subject_for_course_teaching_assignment
    add_breadcrumb "Pick the subject", 'pick_subject_for_course_teaching_assignment_path'
    @subjects = current_user.get_managed_school.all_active_subjects 
  end
  
  def new_course_teaching_assignment
    @subject = Subject.find_by_id( params[:subject_id] )
    @courses = @subject.courses
    
    add_breadcrumb "Pick the subject", 'pick_subject_for_course_teaching_assignment_path'
    set_breadcrumb_for @subject, 'new_course_teaching_assignment_path' + "(#{@subject.id})", 
              'Pick the course' 
    
  end
  
  def select_course_for_grade_summary
    #current_user is a teacher 
    @courses = current_user.all_courses_taught.includes(:subject)
    
    add_breadcrumb "Select the subject", 'select_course_for_grade_summary_path'
  end
  
  def show_student_grades_for_course
    @course  = Course.find_by_id( params[:course_id])
    @students = @course.students 
    @closed_projects = @course.get_closed_projects
    @projects = @course.projects.order("created_at ASC")
    
    add_breadcrumb "Pick the subject", 'select_course_for_grade_summary_path'
    set_breadcrumb_for @course, 'show_student_grades_for_course_path' + "(#{@course.id})", 
              'Student Grades'
  end
  
  def show_project_grading_details
    @project = Project.find_by_id(params[:project_id])
    @course = @project.course 
    @student = User.find_by_id(params[:student_id])
    
    
    
    add_breadcrumb "Pick the subject", 'select_course_for_grade_summary_path'
    set_breadcrumb_for @course, 'show_student_grades_for_course_path' + "(#{@course.id})", 
              'Student Grades'
    set_breadcrumb_for @course, 'show_project_grading_details_path' + "(#{@project.id}, #{@student.id})", 
              'Grading Details'
    
  end
  
  
  

end
