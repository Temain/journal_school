# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
NProgress.configure
  showSpinner: false
  ease: 'ease'
  speed: 700


ready = ->
  $('#Container').mixItUp();

  $(".nav-item > button").click ->
    $(".nav-item").removeClass("active")
    $(this).parent().addClass("active")

  # links popvers
  $('.actions > #edit-link').popover();
  $('.actions > #write-off-link').popover();
  $('.actions > #repair-link').popover();
  $('.actions > #relocation-link').popover();
  $('.actions > #history-link').popover();
  $('.actions > #pdf-link').popover();
  $('.actions > .actions-link').popover();

  $('#actions-link').popover();
  $('#profile-link').popover();
  $('#log-out-link').popover()
  $('#back-link').popover();
  $('#reports-link').popover();
  $('pdf-link').popover();

  # scroll link
  $(".scroll-down").click ->
    $('body').animate({
      scrollTop : $(window).scrollTop() + $(document).height()
    },'slow');

  $(".scroll-up").click ->
    $('body').animate({
      scrollTop : 0
    },'slow');

  half = $(document).height() / 2;
  if $(document).scrollTop() > half
    $(".scroll-down").css("display", "none");
  else
    $(".scroll-up").css("display", "none");


  # Report by spare modal
  spares = new Bloodhound
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      remote: "/load_spares/#{ $('#report_by_spare_modal #equipment_type_id_').val() }?q=%QUERY"

  spares.initialize();

  $('#report_by_spare_modal #equipment_type_id_').on('change', () ->
    spares.remote.url = "/load_spares/#{ $('#report_by_spare_modal #equipment_type_id_').val() }?q=%QUERY"
  )

  $('#spare').typeahead(null, {
    name: 'spares',
    displayKey: 'name',
    source: spares.ttAdapter()
  });


  # manufacturers typeahead
  manufacturers =
    new Bloodhound
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      #prefetch: '/load_manufacturers',
      remote: '/load_manufacturers/?query=%QUERY'

  manufacturers.initialize();

  $('#remote .typeahead.manufacturer').typeahead(null, {
    name: 'manufacturers',
    displayKey: 'name',
    source: manufacturers.ttAdapter()
  });

  # equipment typeahead
  equipment =
    new Bloodhound
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
      queryTokenizer: Bloodhound.tokenizers.whitespace,
      #prefetch: '/load_equipment',
      remote: '/load_equipment/?query=%QUERY'

  equipment.initialize();

  $('#remote .typeahead.search-equipment').typeahead(null, {
    name: 'equipment',
    displayKey: (equipment) ->
        return "#{equipment.equipment_type.name} #{equipment.manufacturer.name} #{equipment.model}";
    source: equipment.ttAdapter()
    templates: {
      empty: [
        '<div class="empty-message">',
        'Ничего не найдено =(',
        '</div>'
      ].join('\n'),
      suggestion: (data) ->
        return '<p><strong>' + data.equipment_type.name + ' ' + data.manufacturer.name + '</strong> ' + data.model + '</p>';
    }
  }).on('typeahead:selected', (obj, equipment) ->
    $('#equipment_model').val(equipment.model);
    $('#manufacturer_name').val(equipment.manufacturer.name);
    $('#equipment_equipment_type_id').val(equipment.equipment_type.id);
  )

  # get relocation modal invoker
  $('#relocation_modal').on('show.bs.modal',(e) ->
    invoker = $(e.relatedTarget);
    item_id = invoker[0].attributes.id.value;
    $('#relocation_modal form').attr('action', '/equipment/'+ item_id + '/relocation');
    $('#new_department_id_').val(null);
  )

  # get writed_off modal invoker
  $('#writed_off_modal').on('show.bs.modal',(e) ->
    invoker = $(e.relatedTarget);
    item_id = invoker[0].attributes.id.value;
    $('#relocation_modal form').attr('action', '/equipment/'+ item_id);
  )

  # get repair modal invoker
  equipment_type_id = $('#repair_modal').on('show.bs.modal',(e) ->
    $("#spares").select2('data', null); # clear selection
    $('#action_date').val(formated_date(new Date()));
    $("reason_").val("");

    invoker = $(e.relatedTarget);
    item_id = invoker[0].attributes.id.value;
    equipment_type_id = invoker[0].attributes.equipment_type_id.value;
    $('#repair_modal form').attr('action', '/equipment/'+ item_id + '/repair');
    equipment_type_id
  )

  $('#report_by_department_modal').on('show.bs.modal',(e) ->
    $('#end_date').val(formated_date(new Date()));
    $('#start_date').val(moment().subtract('years', 1).format("DD.MM.YYYY"));
  )

  $('#datetimepicker, #start_date, #end_date').datetimepicker({
    language: 'ru',
    pickTime: false,
    startDate: new Date(2013, 2, 1),
    endDate: new Date(2013, 3, 30)
  });

  $('#action_date, #start_date, #end_date').on('change', (ev) ->
    date = ev.currentTarget.value;
    unless moment(date, "DD.MM.YYYY", "ru").isValid()
      $(this).val(formated_date(new Date()));
  )

  today = new Date();
  $.fn.datetimepicker.defaults = {
    showToday: true,
    defaultDate: today
  }

  $('#action_date').focus( ->
    $('#datetimepicker').data("DateTimePicker").show();
  )

  formated_date = (date) ->
    day = date.getDate();
    month = date.getMonth() + 1;
    year = date.getFullYear();
    if (month < 10)
     month = "0" + month;
    return day + "." + month + "." + year;


  # --------- select2 intialize ----------
  format = (spare) ->
      spare.name;

  load_spares_path = ->
    '/load_spares/' + String(equipment_type_id);

  lastResults = [];
  $("#spares").select2({
    placeholder: "Выберите детали...",
    multiple: true,
    ajax: {
      url: load_spares_path,
      dataType: 'json',
      data: (term, page) ->
        q: term;
      ,
      results: (data, page) ->
        lastResults = data;
        results: data;
    }

    formatResult: format,
    formatSelection: format,

    createSearchChoice: (term) ->
      if(lastResults.some((r) -> r.name == term ))
         id: term, name: term;
      else
         id: term, name: term + " (новая деталь)";
  });

  # item action menu
  $("a.actions-link").on('click', (e) ->
    #$(".actions > a").css("visibility", "visible");
    actions = $( this ).parent();
    actions.addClass("showed");
    actions_links = $(".actions.showed a").not("a.actions-link");
    $(".showed > a.actions-link").hide("fast");
    $.each(actions_links, (index, obj) ->
       $(this).show("fast");
    )
  )

  # prevent form submit on enter
  $('#remote .typeahead').keydown ->
    if(event.keyCode == 13)
      event.preventDefault();
      return false;



$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('click', (e) ->
  if( (!$(e.target).is('.actions.showed > a > i')))
    $(".actions.showed > a").not("a.actions-link").hide(1000);
    $(".showed > a.actions-link").show("fast");
    $(".actions.showed").removeClass("showed");
)
$(document).on('page:fetch', ->
  $('#Container').mixItUp('destroy');
)

$(document).on('page:load', ->
  $('#Container').mixItUp();
)

$(document).scroll( ->
  half = $(document).height() / 2;

  if $(document).scrollTop() > half
    $(".scroll-down").hide("slow");
    $(".scroll-up").show("slow");
  else
    $(".scroll-down").show("slow");
    $(".scroll-up").hide("slow");
)

$(document).on('DOMNodeInserted', (e) ->
  if (e.target.id == 'nprogress')
    $("#nprogress").css('z-index', 9999)
)