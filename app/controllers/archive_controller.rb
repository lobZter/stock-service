class ArchiveController < ApplicationController
  
  def stockholder_archive
  end
  
  def company_archive
  end
  
  def transaction_archive
    @transactions = Transaction.where("is_deleted=?", true)
  end
  
  def capital_increase_archive
  end
  
end
