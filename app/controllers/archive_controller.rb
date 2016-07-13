class ArchiveController < ApplicationController
  
  def stockholder_archive
  end
  
  def company_archive
  end
  
  def transactions_archive
    @transactions = Transaction.where("is_deleted=?", true)
  end
  
  def capital_increases_archive
  end
  
end
