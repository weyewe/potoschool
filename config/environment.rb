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


POTOSCHOOL_TUTORIAL_URL = "https://s3.amazonaws.com/potoschool_icon/TUTORIAL+POTOSCHOOL.pdf"

SNIFFING = 0


TOWN_OFFSET_HASH = {"Samoa"=>-11, " International Date Line West"=>-11, " Midway Island"=>-11, "Hawaii"=>-10, "Alaska"=>-9, "Pacific Time (US & Canada)"=>-8, " Tijuana"=>-8, "Mountain Time (US & Canada)"=>-7, " Arizona"=>-7, " Chihuahua"=>-7, " Mazatlan"=>-7, 
  "Central Time (US & Canada) "=>-6, "Central America"=>-6, " Guadalajara"=>-6, " Mexico City"=>-6, 
  " Monterrey"=>-6, " Saskatchewan"=>-6, "Eastern Time (US & Canada)"=>-5, " Bogota"=>-5, 
  " Indiana (East)"=>-5, " Lima"=>-5, " Quito"=>-5, "Caracas"=>-4.5, "Atlantic Time (Canada)"=>-4, 
  "Georgetown"=>-4, " La Paz"=>-4, " Santiago"=>-4, "Newfoundland"=>-3.5, "Buenos Aires"=>-3,
  "Brasilia"=>-3, " Greenland"=>-3, "Mid-Atlantic"=>-2, "Cape Verde Is."=>-1, "Azores"=>-1, "London"=>0, 
  " Casablanca"=>0, " Dublin"=>0, " Edinburgh"=>0, " Lisbon"=>0, " Monrovia"=>0, " UTC"=>0, "Paris"=>1, 
  "Amsterdam"=>1, " Belgrade"=>1, " Berlin"=>1, " Bern"=>1, " Bratislava"=>1, " Brussels"=>1, " Budapest"=>1,
  " Copenhagen"=>1, " Ljubljana"=>1, " Madrid"=>1, " Prague"=>1, " Rome"=>1, " Sarajevo"=>1, " Skopje"=>1,
  " Stockholm"=>1, " Vienna"=>1, " Warsaw"=>1, " West Central Africa"=>1, " Zagreb"=>1, "Cairo"=>2,
  "Athens"=>2, " Bucharest"=>2, " Harare"=>2, " Helsinki"=>2, " Istanbul"=>2, " Jerusalem"=>2,
  " Kyiv"=>2, " Minsk"=>2, " Pretoria"=>2, " Riga"=>2, " Sofia"=>2, " Tallinn"=>2, " Vilnius"=>2, 
  "Moscow"=>3, "Baghdad"=>3, " Kuwait"=>3, " Nairobi"=>3, " Riyadh"=>3, " St. Petersburg"=>3,
  " Volgograd"=>3, "Tehran"=>3.5, "Baku"=>4, "Abu Dhabi"=>4, " Muscat"=>4, " Tbilisi"=>4,
  " Yerevan"=>4, "Kabul"=>4.5, "Karachi"=>5, "Ekaterinburg"=>5, " Islamabad"=>5, " Tashkent"=>5, 
  "Mumbai"=>5.5, "Chennai"=>5.5, " Kolkata"=>5.5, " New Delhi"=>5.5, " Sri Jayawardenepura"=>5.5, 
  "Kathmandu"=>5.75, "Dhaka"=>6, "Almaty"=>6, " Astana"=>6, " Novosibirsk"=>6, "Rangoon"=>6.5, 
  "Jakarta"=>7, "Bangkok"=>7, " Hanoi"=>7, " Krasnoyarsk"=>7, "Hong Kong"=>8, "Beijing"=>8, " Chongqing"=>8, 
  " Irkutsk"=>8, " Kuala Lumpur"=>8, " Perth"=>8, " Singapore"=>8, " Taipei"=>8, " Ulaan Bataar"=>8,
  " Urumqi"=>8, "Tokyo"=>9, "Osaka"=>9, " Sapporo"=>9, " Seoul"=>9, " Yakutsk"=>9, "Adelaide"=>9.5, 
  "Darwin"=>9.5, "Sydney"=>10, "Brisbane"=>10, " Canberra"=>10, " Guam"=>10, " Hobart"=>10, 
  " Melbourne"=>10, " Port Moresby"=>10, " Vladivostok"=>10, "Solomon Is."=>11, "Kamchatka"=>11,
  " Magadan"=>11, " New Caledonia"=>11, "Auckland"=>12, "Fiji"=>12, " Marshall Is."=>12,
  " Wellington"=>12, "Nuku'alofa"=>13} 
  
POSITIONAL_COMMENT_MARKER_WIDTH = 44  # 52 - 4padding*2   << left and right
