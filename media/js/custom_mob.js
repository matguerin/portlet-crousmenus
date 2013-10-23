(function($){
$(document).ready(function(){
	
	/*Remove "empty" paragraph.*/
	$('div.infoSection p').filter(function() {
        return $.trim($(this).text()) === '' && $(this).children().length == 0
    }).remove();
    
    $('span.noMenu').parent().parent().addClass('noMenu');
    
    $('a.showRestoInfo').attr('href', '#');
   
    $("a.showRestoMenus").each(function(){
		//$(this).attr('href', '#' + $(this).attr('name'));
	})

	$("div.menuContainer h3").each(function(){
		$(this).prepend("Sp&eacute;ciale '");
		$(this).append("'");
	});
		
	$('ul.dateListContainer').each(function(){
        var form=$(document.createElement('form')).insertBefore($(this).hide());
        var select=$(document.createElement('select')).appendTo(form);
        select.attr('id', select.parent().parent().attr('id') + 'Select');
        select.addClass('dateSelect');
        $('>li a', this).each(function(){
            option=$(document.createElement('option')).appendTo(select).val(this.href).html($(this).html());
            option.attr('value', $(this).attr('name'));
        
        });
	});


	$("a.showZoneRestos").click(function () {
		var divname= this.name;
		var wholeZonePanel = $("#" + divname).parent();
		if ($("#" + divname).is(":visible")) {
			$(wholeZonePanel).addClass("expandable");
			$(wholeZonePanel).removeClass("expanded");
			$("#" + divname).hide();
		} else {
			$(wholeZonePanel).addClass("expanded");
			$(wholeZonePanel).removeClass("expandable");
			$("#" + divname).show();
		}
		
	});

	$("a.showRestoMenus").click(function () {
		var divname= this.name;
		if ($("#" + divname).is(":visible")) {
			$("#" + divname).hide();
		} else {
			$("#" + divname).show();
		}
		
	});
	
	$("select.dateSelect").change(function () {
		var selectId = $(this).attr('id');
		var selectedOption = $("#" + selectId + " option:selected");
		var divname = $(selectedOption).attr('value');
		$("#" + divname).siblings(".menuContainer").hide();
		
		if ($("#" + divname).is(":visible")) {
			$("#" + divname).hide();
		} else {
			$("#" + divname).show();
		}		
	});
	$(".showRestoInfo").click(function () {
	   	var divname= this.name;
	   	$("#" + divname).show();
	});
	$("a.closeRestoInfoPopup").click(function () {
	  	$("div.restoInfoPopup").hide();
	});
	
	
	
});

})(jQuery);
