class FormulasSweeper < ActionController::Caching::Sweeper
  observe Import

  def after_save(import)
    ActionController::Base.new.expire_fragment('formulas')
  end
end
