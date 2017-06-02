require_dependency 'concerns/interactor_timer'

class SearchFormulas
  include Interactor
  include InteractorTimer

  def call
    sanity_checks!

    search_query = search_formula_from_terms

    context.results = search_query.all
    context.result_count = search_query.count
  end

  private

  def sanity_checks!
    return true if context.terms

    context.fail!(errors: { terms: 'is missing' })
  end

  def build_sql_query
    sql = []

    sql << 'name ILIKE :terms' if context.names == '1'
    sql << 'filename ILIKE :terms' if context.filenames == '1'
    sql << 'description ILIKE :terms' if context.descriptions == '1'

    sql.join(' OR ')
  end

  def search_formula_from_terms
    Homebrew::Formula.where(build_sql_query, terms: "%#{context.terms}%")
                     .order(:name)
  end
end
