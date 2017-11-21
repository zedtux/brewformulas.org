class FormulasSweeper < ActionController::Caching::Sweeper
  observe Import, Homebrew::Formula

  def after_save(record)
    return unless can_sweep_the_cache_for?(record)

    ActionController::Base.new.expire_fragment('formulas')
  end

  private

  def can_sweep_the_cache_for?(record)
    return true if record.class == Import

    if record.class == Homebrew::Formula && record.description_changed?
      return true
    end

    false
  end
end
