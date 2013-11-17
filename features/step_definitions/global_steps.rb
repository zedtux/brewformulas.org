Given /^no ([^"]+) exist(?: in ([^"]+))?$/ do |model_name, namespace|
  model_name = model_name.gsub(/ /, "_").classify
  namespace = namespace.gsub(/ /, "_").classify if namespace
  model = if namespace
    "#{namespace}::#{model_name}"
  else
    model_name
  end.constantize
  model.destroy_all
  ActiveRecord::Base.connection.reset_pk_sequence!(model.table_name)
  ActiveRecord::Base.connection.execute("REINDEX TABLE #{model.table_name}")
end
