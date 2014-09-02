
# Actions defined in this helper files can be used in all views.
module ApplicationHelper
  require 'string'

  # Return a link for use un layout navigation
  def nav_link(text, controller, action="index")    
    link_to_unless_current text,  :controller => controller,
                    :action => action
  end

  # Return true if some user us logged in, false otherwise.
  def logged_in?    
    not session[:user_id].nil?
  end

  # Generates a short cut text_field_for method
  def text_field_for(form, field,
            size = HTML_TEXT_FIELD_SIZE,
            maxlength = DB_STRING_MAX_LENGTH)
  
    # label = 
    content_tag(:label, "#{field.humanize}:", :for => field) + "" + (form.text_field field, :size => size, :maxlength => maxlength)

    # form_field = 



    # content_tag(:div, "#{label}" + "<br/>" + "#{form_field}", :class => "form_row")
  end


end