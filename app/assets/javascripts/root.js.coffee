$(document).ready ->
  page = 2

  $allFormulasTab = $ 'div#all_formulas'
  $newFormulasTab = $ 'div#new_since_a_week'
  $inactiveFormulasTab = $ 'div#inactive'

  $allFormulasContainer = $allFormulasTab.find('div.list-group')
  $newFormulasContainer = $newFormulasTab.find('div.list-group')
  $inactiveFormulasContainer = $inactiveFormulasTab.find('div.list-group')

  appendFormulas = ($tab, $container, formulas) ->
    # if not found in DOM
    $container = createDOMcontainer($tab) if $container.length < 1

    for formula in formulas
      domElement = createDOMformula(formula)
      $container.append(domElement)

  updateFormulas = ->
    request = $.ajax({
      url: "/?format=json&page=#{page}"
      method: 'GET'
    })

    request.done((response) ->
      appendFormulas($allFormulasTab,
                     $allFormulasContainer,
                     response.formulas)

      appendFormulas($newFormulasTab,
                     $newFormulasContainer,
                     response.new_formulas)

      appendFormulas($inactiveFormulasTab,
                     $inactiveFormulasContainer,
                     response.new_formulas)
      page += 1
    )

  createDOMformula = (data) ->
    h4Heading = $("<h4 class=\"list-group-item-heading\">#{data.formula}</h4>")
    smallFormula = "<small>#{data.formula}</small>"
    if (data.new)
      successLabel = '<span class="label label-success">New</span>'
      h4Heading.append(smallFormula, successLabel)

    anchor = $("<a class=\"list-group-item\" href=\"/#{data.formula}\"></a>")
    itemText = "<p class=\"list-group-item-text\">#{data.description}</p>"
    anchor.append(h4Heading, itemText)

  createDOMcontainer = ($tab) ->
    $container = $('<div class="list-group"></div>')
    $tab.find('.alert').replaceWith($container)
    $container

  listenOnScroll(updateFormulas)
