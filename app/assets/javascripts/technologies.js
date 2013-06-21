

$(document).ready(function(){

        $("table > tr > td").click(function(){
            $(this).next("table tr").fadeToggle(600);
        });
    });