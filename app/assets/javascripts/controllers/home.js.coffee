$(document).ready ->

    $(".toggle").click ->
        $(".to-be-toggled").fadeToggle( "fast", "linear" )

    if (typeof gon != "undefined") && gon.resource == "cars" && gon.map_id != "cars_show"
        Cars.AllCars.show()