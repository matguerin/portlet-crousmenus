(function($){
$(document).ready(function(){
	$('div.menuContainer h2').after('<div class="menuDetails">');
	$('div.menuContainer h4').before('<div class="menuPart">');
	$('div.detail h2').prepend('&gt;&gt; ');
	
	/*Remove "empty" paragraph.*/
	$('div.infoSection p').filter(function() {
        return $.trim($(this).text()) === '' && $(this).children().length == 0
    }).remove();
    
    $('span.noMenu').parent().parent().addClass('noMenu');

	$("div.menuContainer h3").each(function(){
		$(this).prepend("Sp&eacute;ciale '");
		$(this).append("'");
		$(this).prependTo($(this).prev());
	});
	$("div.menuContainer h4").each(function(){
		$(this).prependTo($(this).prev());
	});
	$("div.menuContainer ul").each(function(){
		$(this).appendTo($(this).prev());
	});
	$("div.menuContainer div.menuPart").each(function(){
		$(this).appendTo($(this).prev());
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
	
	$("a.showDateMenu").click(function () {
		var divname= this.name;
		var dateItem = $(this).parent();
		$(dateItem).addClass("currentDate");
		$(dateItem).siblings("li").removeClass("currentDate");
		$(dateItem).parent().siblings(".menuContainer").hide();
		if ($("#" + divname).is(":visible")) {
			$("#" + divname).hide();
		} else {
			$("#" + divname).show();
		}
		
	});
	$(".showRestoInfo").click(function () {
	   	var divname= this.name;
	   	$("#" + divname).show();
	   	$("#" + divname).removeClass("openedFromHover");
	});
	$(".showRestoInfo").mouseover(function (e) {
		$("div.restoInfoPopup").hide();
	   	var divname= this.name;
	   	$("#" + divname).show();
	   	$("#" + divname).css('left', e.pageX+8);
	   	$("#" + divname).css('top', e.pageY-($("#" + divname).height() / 3));
	   	$("#" + divname).addClass("openedFromHover");	
	});
	$(".showRestoInfo").mouseout(function () {
	   	var divname= this.name;
	   	if ($("#" + divname).hasClass("openedFromHover")) {
	   		$("#" + divname).removeClass("openedFromHover");
	   		$("#" + divname).hide();
	   	}
	});
	$("a.closeRestoInfoPopup").click(function () {
	  	$("div.restoInfoPopup").hide();
	});
	
	
	
});

})(jQuery);
