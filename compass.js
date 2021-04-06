// ==UserScript==
// @name         COMPASS sync script
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description
// @author       You
// @match        [REDACTED]
// @grant GM_xmlhttpRequest
// ==/UserScript==

(function() {
    'use strict';
    let div = document.createElement('div');
    div.innerHTML = '<button id="myButton" style="top:0;right:0;position:absolute;z-index:9999;color:red" type="button">ADD WEEK TO GOOGLE CALENDAR</button>';
    document.body.appendChild(div);
    document.getElementById("myButton").addEventListener("click", () => {
      for (let y = 0; y < 7; y++) {
        setTimeout(() => {
            let epoch = Date.now();
            let cal = `https://[REDACTED].compass.education/Services/Calendar.svc/GetCalendarEventsByUser?sessionstate=readonly&includeOnCall=true&_dc=${epoch}`;
            let date = (new Date((new Date).getTime() + y * 1000 * 60 * 60 * 24)).toISOString().split('T')[0];
            console.log(date);
            let data = {
                "activityId": null,
                "endDate": date,
                "homePage": true,
                "limit": 25,
                "locationId": null,
                "page": 1,
                "staffIds": null,
                "start": 0,
                "startDate": date,
                "userId": 5054
            };
            let res = fetch(cal, {
                method: 'POST',
                body: JSON.stringify(data),
                headers: {
                    "X-Requested-With": "XMLHttpRequest",
                    "Content-Type": "application/json"
                }
            }).then((d) => d.json()).then((d) => d.d).then((res) => {
                let evs = res.filter((i) => i.runningStatus === 1).map((i) => {
                    console.log(i.longTitleWithoutTime)
                    return {title: i.longTitleWithoutTime, start: i.start, end: i.finish};
                });
                console.log(evs);
                if (evs == []) {
                    return;
                }
                GM_xmlhttpRequest({
                  method: "POST",
                  url: "https://script.google.com/a/[REDACTED]",
                  data: JSON.stringify(evs),
                  headers: {
                    "Content-Type": "application/json"
                  },
                  onload: function(response) {
                    console.log(response.status);
                    console.log(response.responseText);
                  }
                });
            });
        }, 1000 + y * 2000);
      }
    }, false);
})();
