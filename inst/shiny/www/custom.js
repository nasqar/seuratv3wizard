shinyjs.addStatusIcon = function(params)
{
  var tabname = params[0];
  var status = params[1];

  var menuitem = $('.sidebar-menu > li > a[data-value="' + tabname +'"]');

    menuitem.children('#loading-bar-spinner').remove();
    menuitem.children('#checkmarkdone').remove();
    menuitem.children('#xmarkdone').remove();
    menuitem.children('span.badge').remove();


    switch(status)
    {
      case 'loading':
        $("button.btn").removeClass("button-3d");
        $("button.btn").attr("disabled", "disabled");
        
        $("a.btn").addClass("hidden");
        menuitem.append('<div id="loading-bar-spinner" class="spinner"><div class="spinner-icon"></div></div>');
        break;

      case 'done':
        menuitem.append('<svg id="checkmarkdone" class="checkmark pull-right" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 52 52">\
    <circle class="checkmark__circle" cx="26" cy="26" r="25" fill="none"/> \
    <path class="checkmark__check" fill="none" d="M14.1 27.2l7.1 7.2 16.7-16.8"/></svg>');
        $("button.btn").addClass("button-3d");
        $("button.btn").removeAttr("disabled");
        
        $("a.btn").removeClass("hidden");
        break;
      case 'fail':
        menuitem.append('<svg id="xmarkdone" class="xmark pull-right" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 52 52">\
    <circle class="xmark__circle" cx="26" cy="26" r="25" fill="none"/> \
    <path class="xmark__check" fill="none" d="M16 16 36 36 M36 16 16 36"/></svg>');
        $("button.btn").addClass("button-3d");
        $("button.btn").removeAttr("disabled");
        break;
      case 'next':
        menuitem.append('<span class="badge" style="float: right; background-color:#4877d2">Next</span>');
        break;
        
      case 'graph':
        menuitem.append('<span class="badge" style="float: right; background-color:#a685f3"><i class="fa fa-bar-chart"></i></span>');
        break;

      case 'download':
        menuitem.append('<span class="badge" style="float: right;"><i class="fa fa-download"></i></span>');
        break;



    }

};

shinyjs.collapse = function(boxid) {
  $('#' + boxid).closest('.box').find('[data-widget=collapse]').click();
};


