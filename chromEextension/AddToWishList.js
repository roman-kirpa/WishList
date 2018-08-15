function addToWishList(){
	chrome.tabs.query({"active": true, "currentWindow": true}, function (tabs) {
    tabURL = tabs[0].url;
   	Send(tabURL);
});
}

function Send(url){
var xhr = new XMLHttpRequest();
xhr.open('GET', 'http://localhost/Wishlist/Items/Set?url=' + url);
xhr.onload = function(data) {
    if (xhr.status === 200) {
       debugger;
       var el = document.createElement( 'html' );
       el.innerHTML = data.target.responseText;
       var title = el.getElementsByTagName('h2')
        alert(title[0].innerHTML);
       // tempAlert(title[0].innerHTML,4000);
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
 el.setAttribute("style","position:absolute;margin-top:100px;margin-left:100px;background-color:red;width:500px;height:25px;");
 el.innerHTML = msg;
 setTimeout(function(){
  el.parentNode.removeChild(el);
 },duration);
 document.body.appendChild(el);
}