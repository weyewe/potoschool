class Picture < ActiveRecord::Base
  belongs_to :project_submission
  
  # so that we can call @picture.revisions
  # and @revision.original_picture
  has_many :revisions, :class_name => "Revision"
  belongs_to :original_picture, :class_name => "Revision",
    :foreign_key => "original_picture_id"
    
    # class Employee < ActiveRecord::Base
    #   has_many :subordinates, :class_name => "Employee"
    #   belongs_to :manager, :class_name => "Employee",
    #     :foreign_key => "manager_id"
    # end
    # We can do this shit: @employee.subordinates and @employee.manager.
    
  acts_as_commentable
  
  
  def self.extract_uploads(resize_original, resize_index , resize_show, resize_revision, params, uploads )
    project_submission = ProjectSubmission.find_by_id(params[:project_submission_id] )
    
    new_picture = ""
    image_name = ""
    if params[:is_original].to_i == ORIGINAL_PICTURE 
      counter = 0 
      
      # start looping all the transloadit data
      uploads.each do |upload|
        original_id = upload[:original_id]

        original_image_url  = ""
        index_image_url     = ""
        revision_image_url  = ""
        display_image_url   = ""
        original_image_size    = ""
        index_image_size       = ""
        revision_image_size    = ""
        display_image_size     = ""
        
        
        resize_original.each do |r_index|
          if r_index[:original_id] == original_id 
            original_image_url  = r_index[:url]
            original_image_size = r_index[:size]
            image_name = r_index[:name]
            break
          end
        end
        
        
        resize_index.each do |r_index|
          if r_index[:original_id] == original_id 
            index_image_url  = r_index[:url]
            index_image_size = r_index[:size]
            break
          end
        end
        
        resize_show.each do |s_index|
          if s_index[:original_id] == original_id 
            display_image_url  = s_index[:url]
            display_image_size  = s_index[:size]
            break
          end
        end
        
        
        resize_revision.each do |s_index|
          if s_index[:original_id] == original_id 
            revision_image_url  = s_index[:url]
            revision_image_size  = s_index[:size]
            break
          end
        end
        
        new_picture = Picture.create(
             :original_image_url => original_image_url     ,
             :index_image_url    =>   index_image_url      ,
             :revision_image_url =>   revision_image_url   ,
             :display_image_url  =>  display_image_url     ,
             :project_submission_id => project_submission.id, 
             :original_image_size    => original_image_size      ,
             :index_image_size       => index_image_size         ,
             :revision_image_size    => revision_image_size      ,
             :display_image_size     => display_image_size       ,
             :name => image_name
        )
        
        counter =  counter + 1 
      end
    elsif params[:is_original].to_i == REVISION_PICTURE
      original_picture = Picture.find_by_id(params[:original_picture_id])
      index_picture_url = resize_index.first[:url]
      show_picture_url = resize_show.first[:url]
      image_name = resize_show.first[:name]
      new_picture = Picture.create(:index_resized_url => index_picture_url , 
                    :show_resized_url => show_picture_url , 
                    :project_id => project.id , 
                    # :title =>  original_picture.title , 
                    :title => image_name,
                    :is_original => false ,
                    :user_id => user.id , 
                    :original_picture_id => original_picture.id )
    end
    
    
    # new_picture.get_original.project.neutralize
    # check_wizard_completion( project )
    
    return new_picture
  end
  
  
end
