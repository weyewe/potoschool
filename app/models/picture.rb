require 'rscribd'
require 'transloadit'
require 'open-uri'

class Picture < ActiveRecord::Base
  belongs_to :project_submission
  
  # so that we can call @picture.revisions
  # and @revision.original_picture
  has_many :revisions, :class_name => "Revision"
  belongs_to :original_picture, :class_name => "Revision",
    :foreign_key => "original_picture_id"
    
  has_many :score_revisions
    
  # for the picture has many revisions
  has_many :revisionships
  has_many :revisions, :through => :revisionships
  has_many :inverse_revisionships, :class_name => "Revisionship", :foreign_key => "revision_id"
  has_many :inverse_revisions, :through => :inverse_revisionships, :source => :picture  
  
    # # user.rb
    # has_many :friendships
    # has_many :friends, :through => :friendships
    # has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
    # has_many :inverse_friends, :through => :inverse_friendships, :source => :user
    # 
    # # friendship.rb
    # belongs_to :user
    # belongs_to :friend, :class_name => "User"
    
    # class Employee < ActiveRecord::Base
    #   has_many :subordinates, :class_name => "Employee"
    #   belongs_to :manager, :class_name => "Employee",
    #     :foreign_key => "manager_id"
    # end
    # We can do this shit: @employee.subordinates and @employee.manager.
    
    
    

=begin
  The commenting logic. 
  Only teacher that can add positional comments 
=end
  acts_as_commentable
  # has_many :comments
  has_many :positional_comments
  
  def is_original?
    self.is_original 
  end
  
  def any_picture_submission_approved?
    self.original_picture.approved_revision_id != nil
  end
  
  
  def original_picture
    if self.is_original == true 
      return self
    else
      Picture.find_by_id( self.original_id )
      # return self.inverse_revisions.first
    end
  end
  
  def approved_picture
    Picture.find_by_id( self.original_picture.approved_revision_id )
  end
  
  def last_revision
    last_revision  = self.original_picture.revisions.last 
    if last_revision.nil?
      return self.original_picture
    else
      return last_revision 
    end
  end
  
  def last_approved_revision
    last_revision_id = self.original_picture.approved_revision_id
    if last_revision_id.nil?
      return self.original_picture
    else
      return Picture.find_by_id( last_revision_id )
    end
  end
  
  
  def highest_approved_pictures_score
    
    # people.sort_by { |id, score| score } # ascending . so, last will give the highest score
    
    
    original_picture = self.original_picture
    pic_id_score_hash  = {}
    original_picture.revisions.where(:is_approved => true, :is_graded => true  ).each do |x|
      pic_id_score_hash[x.id] = x.score 
    end
    if original_picture.is_approved == true  and original_picture.is_graded == true 
      pic_id_score_hash[original_picture.id] = original_picture.score 
    end
    
    
    if pic_id_score_hash.length == 0 
      return nil
    else
      max_id_value_pair  = pic_id_score_hash.sort_by { |id, score| score } .last
      return max_id_value_pair
    end
  end
  
  # restrict commenting capability to several people 
  def allow_comment?(user) 
    # for now, we allow everyone
    return true 
  end
  
  def can_be_graded?
    # if not rejected, if not accepted, if not graded  , if graded
    not ( self.is_approved == false ) # so, is_approved == nil will do 
  end
  
  def set_score( score, current_user )
    
    project = self.project_submission.project 
    if ( not project.created_by?(current_user) ) or 
        ( score < 0   ) or 
        ( score > 100 ) 
      return nil
    end
    
    self.is_graded = true 
    self.score = score
    
    self.save
    
  end
  
  
  # def get_root_comments
  #   comment_type = self.class.to_s
  #   Comment.find(:all, :conditions => {:commentable_type => comment_type,
  #       :commentable_id => self.id, 
  #       :parent_id => nil } , :order => "created_at ASC"  )
  # end
  
=begin
  For storage calculation 
=end

  def images_size
    self.original_image_size + 
      self.byproduct_image_size
  end
  
  def byproduct_to_original_ratio
    self.byproduct_image_size / self.original_image_size.to_f
  end
  
  def byproduct_image_size
    self.display_image_size + 
      self.index_image_size + 
        self.revision_image_size
  end
  
   
=begin
  For picture navigation with NEXT and PREV button
=end

  def next_pic
    original_pic = self.original_picture
    id_list = original_pic.project_submission.original_pictures_id
    
    current_pic_index = id_list.index( original_pic.id )
    
    if current_pic_index <  ( id_list.length - 1 )
      return  Picture.find_by_id( id_list.at ( current_pic_index + 1  ) ).last_revision 
    else
      return nil 
    end
  end
  
  def prev_pic
    original_pic = self.original_picture
    id_list = original_pic.project_submission.original_pictures_id
    current_pic_index = id_list.index( original_pic.id )
    
    if current_pic_index > 0 
      return Picture.find_by_id(  id_list.at( current_pic_index - 1 )   ).last_revision
    else
      return nil 
    end
  end
  
  
  
  
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
             :name => image_name,
             :is_original => true 
        )
        
        counter =  counter + 1 
        
        #  for the UserActivity timeline event 
        UserActivity.create_new_entry(EVENT_TYPE[:submit_picture], 
                          project_submission.user , 
                          new_picture , 
                          project_submission.project  )
     
        project_submission.update_submission_data( new_picture )
      end
    elsif params[:is_original].to_i == REVISION_PICTURE
      original_picture = Picture.find_by_id(params[:original_picture_id])
      original_image_url  = resize_original.first[:url]
      index_image_url     = resize_index.first[:url]
      revision_image_url  = resize_revision.first[:url]
      display_image_url   = resize_show.first[:url]
      original_image_size    = resize_original.first[:size]
      index_image_size       = resize_index.first[:size]   
      revision_image_size    = resize_revision.first[:size]
      display_image_size     = resize_show.first[:size]    
      
      # index_picture_url = resize_index.first[:url]
      # show_picture_url = resize_show.first[:url]
      image_name = resize_show.first[:name]
      new_picture = original_picture.revisions.create(
           :original_image_url => original_image_url     ,
           :index_image_url    =>   index_image_url      ,
           :revision_image_url =>   revision_image_url   ,
           :display_image_url  =>  display_image_url     ,
           :project_submission_id => project_submission.id, 
           :original_image_size    => original_image_size      ,
           :index_image_size       => index_image_size         ,
           :revision_image_size    => revision_image_size      ,
           :display_image_size     => display_image_size       ,
           :name => image_name,
           :original_id => original_picture.id
      )
    
      #  for the UserActivity
       UserActivity.create_new_entry(EVENT_TYPE[:submit_picture_revision], 
                          project_submission.user , 
                          new_picture , 
                          original_picture  )
                          
      project_submission.update_submission_data( new_picture )
    end
    
    return new_picture
  end
  
  
  def self.extract_scribd_upload(resize_original, params, uploads )
    # only 1 image upload at once.. 
    project_submission = ProjectSubmission.find_by_id(params[:project_submission_id] )
   
    original_image_url  = resize_original.first[:url]    
    original_image_size    = resize_original.first[:size] 
    image_name = resize_original.first[:name]
    new_picture = ""
    original_picture = ""
    
    new_picture_hash = {
    # original image url is the s3 store location. 
    # the original image size remains constant
         :original_image_url => original_image_url  ,  
         :project_submission_id => project_submission.id  , 
         :original_image_size    => original_image_size ,     
         :name => image_name
    }
    
    
    if params[:is_original].to_i == ORIGINAL_PICTURE
      new_picture_hash[:is_original] = true 
      new_picture = Picture.create(new_picture_hash)
    elsif params[:is_original].to_i == REVISION_PICTURE
      original_picture = Picture.find_by_id(params[:original_picture_id])
      new_picture_hash[:original_id] = original_picture.id 
      new_picture = original_picture.revisions.create( new_picture_hash )
    end
    
    # new_picture.save 
    
    if params[:is_original].to_i == REVISION_PICTURE
      project_submission.update_submission_data( new_picture )
    end
    
    new_picture.upload_to_scribd # this should be delayed
    return new_picture 
  end
  

  def upload_to_scribd
    scribd_read = YAML::load( File.open( Rails.root.to_s + "/config/scribd.yml") )
    
    Scribd::API.instance.key = scribd_read['auth']['key']
    Scribd::API.instance.secret = scribd_read['auth']['secret']
    
    begin
      
      Scribd::User.login scribd_read['auth']['username'], scribd_read['auth']['password']
      doc = Scribd::Document.new 
      doc.file = self.original_image_url  
      doc.access = "private"
      doc.title = self.name 
      doc.save
      
      self.doc_id = doc.id.to_s
      self.doc_access_key  = doc.access_key 
      # self.picture_filetype = PICTURE_FILETYPE[:scribd]
      self.save 
      self.assign_filetype
      
      # Launch a checking code to start observing, 30 seconds from now 
    
      
    rescue Scribd::ResponseError => e
      puts "failed code=#{e.code} error='#{e.message}'"
    end
  end
  
  
  def assign_filetype
    FILETYPE_REGEX.each do |key, value|
      if value.match self.original_image_url
        self.picture_filetype = PICTURE_FILETYPE[key] 
        self.save
        return
      end
    end
    
    self.picture_filetype = PICTURE_FILETYPE[:others] 
    self.save 
  end
  
  # the display section is the location of the display: index? revision? 
  def get_icon( display_section ) 
    if self.picture_filetype == PICTURE_FILETYPE[:image]
      message = display_section + "_image_url"
      return self.send( message )
    else
      return FILEICON_URL[ PICTURE_FILETYPE.invert[ self.picture_filetype ]  ]
    end
  end
  
  
  
  def upload_datetime_local(school)
    self.created_at.in_time_zone(school.get_time_zone)
  end
  
  
  
=begin
  For resizing in image-default quality (smaller size)
=end
  def resize_quality
    if Rails.env.production?
      transloadit_read = YAML::load( File.open( Rails.root.to_s + "/config/transloadit.yml") )
      bucket = 'potoschool'
    elsif Rails.env.development?
      transloadit_read = YAML::load( File.open( Rails.root.to_s + "/config/transloadit_dev.yml") )
      bucket = 'potoschool-dev'
    end
    
    
    transloadit = Transloadit.new(
      :key    => transloadit_read['auth']['key'],
      :secret => transloadit_read['auth']['secret']
    )
    
    # step = import, crop, resize_comment, resize_collaborator, store_to_s3


    import = transloadit.step 'import', '/http/import', 
      :url => self.original_image_url
      
      
      # "original_image_url
      #   "index_image_url"
      #   "revision_image_url
      #   "display_image_url"
      #   

    
    resize_revision = transloadit.step 'revision', '/image/resize', 
      :use => "import",
      :width => 160
      
    resize_index = transloadit.step 'index', '/image/resize', 
      :use => "import",
      :width => 260
      
    resize_display = transloadit.step 'display', '/image/resize', 
      :use => "import",
      :width => 590
        
    
  
    store_revision  = transloadit.step 'store_revision', '/s3/store',
      :key    => 'AKIAIIMPWOLZCXR3TNLA',
      :secret => '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',
      :bucket => bucket, 
      :use => 'revision'
      
    store_index  = transloadit.step 'store_index', '/s3/store',
      :key    => 'AKIAIIMPWOLZCXR3TNLA',
      :secret => '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',
      :bucket => bucket, 
      :use => 'index'
      
    store_display  = transloadit.step 'store_display', '/s3/store',
      :key    => 'AKIAIIMPWOLZCXR3TNLA',
      :secret => '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',
      :bucket => bucket, 
      :use => 'display'

    assembly = transloadit.assembly(
      :steps => [ import,  resize_index, resize_revision, resize_display, 
              store_index, store_revision, store_display ]
    )
    
    # file = open(self.profile_pic)
    #  response = assembly.submit! file
    response = assembly.submit!

    while not response.completed? do
      puts "In the cycle"
      sleep 5
      response.reload!
    end
    
    puts "The content of result is \n"*10
    puts response["results"]
        # 
        # @profile.save_profile_pic_post_cropping( params[:transloadit][:results][:resize_comment].first[:url],
        #   params[:transloadit][:results][:resize_collaborator].first[:url] )
        #   
        
        # "original_image_url
        #   "index_image_url"
        #   "revision_image_url
        #   "display_image_url"
        #
      
      
    puts "The result is \n"*5
      
    self.index_image_url = response["results"]["index"].first["url"]
    self.revision_image_url = response["results"]["revision"].first["url"]
    self.display_image_url = response["results"]["display"].first["url"]
    
    self.index_image_size = response["results"]["index"].first["size"]
    self.revision_image_size = response["results"]["revision"].first["size"]
    self.display_image_size = response["results"]["display"].first["size"]
    self.save
  end
  
  def match_dev
    dev_regex =  /potoschool_dev/
    ( not dev_regex.match(self.original_image_url).nil? ) or 
    ( not dev_regex.match(self.revision_image_url).nil? ) or 
    ( not dev_regex.match(self.index_image_url).nil? ) or 
    ( not dev_regex.match(self.display_image_url).nil? ) 
  end
  
=begin  
  Related to the UserActivity Timeline 
=end
  
  def self.new_user_activity_for_grading( event_type, grader, subject, secondary_subject )
    UserActivity.create_new_entry(event_type , 
                        grader , 
                        subject , 
                        secondary_subject  )
  end
  
  

  
end