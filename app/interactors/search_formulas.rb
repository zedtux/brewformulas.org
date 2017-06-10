require_dependency 'concerns/interactor_timer'

class SearchFormulas
  include Interactor
  include InteractorTimer

  def call
    copy_term_in_terms_if_needed!

    sanity_checks!
    enables_all_search_options_if_all_search_options_disabled!

    search_query = search_formula_from_terms

    context.results = search_query.page(context.page)
    context.result_count = search_query.count
  end

  private

  def sanity_checks!
    return true if context.terms

    context.fail!(errors: { terms: 'is missing' })
  end

  def enables_all_search_options_if_all_search_options_disabled!
    return if context.names == '1' || context.filenames == '1' ||
              context.descriptions == '1'

    context.names = '1'
    context.filenames = '1'
    context.descriptions = '1'
  end

  def copy_term_in_terms_if_needed!
    return if context.terms
    return unless context.term

    context.terms = context.term
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
