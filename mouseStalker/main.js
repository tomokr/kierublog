var mousex, mousey;
var counter_id = define_counter();
var animation_id = define_counter();
var g = 1; //重力
var window_height = $( window ).height();

document.onmousemove=function(e){
		document.getElementById("Mo").style.left=e.pageX+15+"px";
		document.getElementById("Mo").style.top=e.pageY+15+"px";
		mousex = e.pageX;
		mousey = e.pageY;
}

document.addEventListener('click',function(e){
	document.body.appendChild(createImg());
	animateImg();
},false);

function createImg(){
        var imgDivElem = document.createElement("div");
        var imgElem = imgDivElem.appendChild(document.createElement("img"));
        imgDivElem.id = "img"+counter_id();
        imgElem.src="newton.jpg";
        imgDivElem.style.position = "absolute";
        imgDivElem.style.left = mousex+15+"px";
        imgDivElem.style.top = mousey+15+"px";

        return imgDivElem;
}

function animateImg(){
	var imgDivElem = document.getElementById("img"+animation_id());
	var time = 0;
	var top = parseInt((imgDivElem.style.top).replace("px",""));
	var intervalID = setInterval(function (){
		if(top > window_height-146){
			clearInterval(intervalID);
			imgDivElem.style.top = window_height-146+"px";
			return;
		}
		time++;
		top += time*g;
		imgDivElem.style.top = top+"px";
	}, 50);

}

function define_counter() {
    var i = 0;
    return function() {
      return ++i;
    };
};

