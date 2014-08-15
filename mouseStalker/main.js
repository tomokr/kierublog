var mousex, mousey;

document.onmousemove=function(e){
		document.getElementById("Mo").style.left=e.pageX+15+"px";
		document.getElementById("Mo").style.top=e.pageY+15+"px";
		mousex = e.pageX;
		mousey = e.pageY;
}

document.addEventListener('click',function(e){
	document.body.appendChild(createImg());
},false);

function createImg(left){
        var imgDivElem = document.createElement("div");
        var imgElem = imgDivElem.appendChild(document.createElement("img"));
        imgElem.src="newton.jpg";
        imgDivElem.style.position = "absolute";
        imgDivElem.style.left = mousex+15+"px";
        imgDivElem.style.bottom = "0px";

        return imgDivElem;
}