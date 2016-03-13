module StockholdersHelper
  def check_exist(is_exist)
    if is_exist
      return '<span class="glyphicon glyphicon-ok"></span>'.html_safe 
    else
      return '<span class="glyphicon glyphicon-remove"></span>'.html_safe 
    end
  end
end
