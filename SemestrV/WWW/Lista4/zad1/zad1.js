var div = document.createElement('div');
div.id = 'menu';
div.setAttribute("style", "border-style: solid;");


function addLink(color) {
  var a = document.createElement('a');
  a.setAttribute('href', '#');
  a.setAttribute('onclick', `color('${color}')`);
  a.innerHTML = color;
  return a;
}

function color(x) {
  document.getElementById("menu").style.borderColor = x;
};

//document.body.appendChild(div);
//document.getElementById('menu').appendChild(addLink(color));