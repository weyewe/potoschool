# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Debita46::Application.initialize!

ROLE_NAME = {
  :student => "Student",
  :teacher => "Teacher", 
  :school_admin => "SchoolAdmin" 
}


TRUE_CHECK = 1
FALSE_CHECK = 0


ORIGINAL_PICTURE   = 1
REVISION_PICTURE   = 0

NORMAL_COMMENT     = 0
POSITIONAL_COMMENT = 1

ACCEPT_SUBMISSION = 1
REJECT_SUBMISSION = 0

ADD_GROUP_LEADER = 1 
REMOVE_GROUP_LEADER = 0

DEFAULT_DEADLINE_HOUR = 23
DEFAULT_DEADLINE_MINUTE = 59 


DISPLAY_IMAGE_WIDTH = 590

EVENT_TYPE  = {
  :create_comment => 1,  # yes  # notification is working  #background notification is working 
  :reply_comment => 2,  # yes  #the view details depends on the destination
                        #  destination is working  # working total! 
  :submit_picture => 3 ,   #added  #notification is working  ## working with background job
  :submit_picture_revision => 4,  #added # notification is working  # working 
  :grade_picture => 5,  #reject is working  
  :create_project => 6   #added  # notification working  # working with background job
}


# Special for File Upload
PICTURE_FILETYPE = {
  :image => 1,
  :doc => 2,
  :ppt => 3,
  :xls => 4,
  :pdf => 5,
  :open_document => 6,
  :open_office_xml => 7,
  :plain_text => 8,
  :postscript => 9,
  :rtf => 10,
  :tif => 11, 
  :others => 999
}

FILETYPE_REGEX = {
  :doc => /(\.(doc|docx))$/,
  :ppt => /(\.(ppt|pps|pptx|ppsx))$/,
  :xls => /(\.(xls|xlsx))$/,
  :pdf => /(\.(pdf))$/,
  :open_document => /(\.(odt|odp|ods|odf|odg))$/,
  :open_office_xml => /(\.(sxw|sxi|sxc|sxd))$/,
  :plain_text => /(\.(txt))$/,
  :postscript => /(\.(ps))$/,
  :rtf => /(\.(rtf))$/,
  :tif => /(\.(tif|tiff))$/
}

FILEICON_URL= {
  :doc => 'https://s3.amazonaws.com/potoschool_icon/doc_file_icon1.png',
  :ppt => 'https://s3.amazonaws.com/potoschool_icon/recover-powerpoint-presentations.png',
  :xls => 'https://s3.amazonaws.com/potoschool_icon/Excel-icon.png',
  :pdf => 'https://s3.amazonaws.com/potoschool_icon/pdf_icon-300x300.png',
  :open_document => 'https://s3.amazonaws.com/potoschool_icon/odt.png',
  :open_office_xml => 'https://s3.amazonaws.com/potoschool_icon/open_office.png',
  :plain_text => 'https://s3.amazonaws.com/potoschool_icon/txt.png',
  :postscript => 'https://s3.amazonaws.com/potoschool_icon/post_script.png',
  :rtf => 'https://s3.amazonaws.com/potoschool_icon/rtf_icon.png',
  :tif => 'https://s3.amazonaws.com/potoschool_icon/tif_icon.png', 
  :others => 'https://s3.amazonaws.com/potoschool_icon/other_file_type.png'
}

# Rails.env.production?
# Rails.env.development?

TAGGER_IMAGE_URL = "https://s3.amazonaws.com/potoschool_icon/tag_hotspot_on_62x62.png"
SHOWLOADING_LOADER_URL = "https://s3.amazonaws.com/potoschool_icon/loading.gif"
DEFAULT_PROFILE_PIC_URL = "https://s3.amazonaws.com/potoschool_icon/default_profile_pic.jpg"
=begin
  The update to be done 
  Picture.all.each {|x| x.picture_filetype = PICTURE_FILETYPE[:image] ; x.save }
  
  Picture.where(:picture_filetype => 2).each do |x|
    x.assign_filetype
  end
=end