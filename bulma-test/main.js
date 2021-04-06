$(document).ready(function() {
    $('#start').click(function(){
        $("#start").addClass("is-loading");
        setTimeout(function (){
            $("#splash").removeClass("is-fullheight");
            $("#splash").addClass("is-small head");
            $("#splash-content").html('<h1 class="title is-1" id="splash-title">Hello</h1>');
            $("#page-content").load('./snip.txt');
        }, 5000);
    });
});
