module ReportHelper
  def to_icon(str)
    if str == "O"
      return '<span class="glyphicon glyphicon-ok"></span>'.html_safe
    elsif str == "X"
      return '<span class="glyphicon glyphicon-remove"></span>'.html_safe
    elsif str == "-"
      return '<span class="glyphicon glyphicon-minus"></span>'.html_safe
    end      
  end
end
