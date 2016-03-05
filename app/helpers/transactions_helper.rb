module TransactionsHelper
  def status_check(is_need, is_exist)
    if is_need
      if is_exist
        return '<span class="glyphicon glyphicon-ok"></span>'.html_safe 
      else
        return '<span class="glyphicon glyphicon-remove"></span>'.html_safe 
      end
    else
      return '<span class="glyphicon glyphicon-minus"></span>'.html_safe 
    end
  end
end
