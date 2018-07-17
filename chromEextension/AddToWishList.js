function addToWishList(){
	chrome.tabs.query({"active": true, "currentWindow": true}, function (tabs) {
    tabURL = tabs[0].url;
   	Send(tabURL);
});
}

function Send(url){
var xhr = new XMLHttpRequest();
xhr.open('GET', 'http://localhost/Wishlist/Items/Set?url=' + url);
xhr.onload = function() {
    if (xhr.status === 200) {
      // tempAlert("send",4000);
    }
    else {
        alert('Request failed.  Returned status of ' + xhr.status);
    }
};
xhr.send();
}

function tempAlert(msg,duration)
{
 var el = document.createElement("div");
 el.setAttribute("style","position:absolute;top:40%;left:20%;background-color:white;width:50px;");
 el.innerHTML = msg;
 setTimeout(function(){
  el.parentNode.removeChild(el);
 },duration);
 document.body.appendChild(el);
}