var load = function(url, func) {
    document.getElementById("demo").innerHTML = "Loading...";
    window.chttp = new XMLHttpRequest();
    window.chttp.onreadystatechange = function() {
        if (this.readyState == 4) {
            try {
                func();
            }
            catch(err) {
                document.getElementById("demo").innerHTML = "Error: "+err.message;
            }
        }
    }
    window.chttp.open("GET", url, true);
    window.chttp.send();
}

var loadbible = function() {
    var bible = JSON.parse(window.chttp.responseText);  // Store JSON in "bible"
    var result = "";  // Result = empty string
    for (var i = 0; i < bible.chapters.length; i++) {  // Loop through chapters...
        for (var ii = 0; ii < bible.chapters[i].verses.length; ii++) {  // Loop through verses...
            result = result + bible.chapters[i].verses[ii][ii + 1];  // Add each verse to result
            result = result + "<br>";  // Add line break
        }
    }
    document.getElementById("demo").innerHTML = result;  // Write result to DOM
}

var loadsnip = function() {
    document.getElementById("demo").innerHTML = window.chttp.responseText;
}

var oldt = function() {
    load("./www/ui/old-snip.txt", loadsnip);
}

var newt = function() {
    load("./www/ui/new-snip.txt", loadsnip);
}
