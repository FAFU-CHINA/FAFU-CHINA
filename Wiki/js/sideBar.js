myID = document.getElementById('sideBar')

var myScrollFunc = function () {
  var y = window.scrollY
  if (y >= 200) {
    myID.className = 'sideBar_Show'
  } else {
    myID.className = 'sideBar_Hide '
  }
}

window.addEventListener('scroll', myScrollFunc)
