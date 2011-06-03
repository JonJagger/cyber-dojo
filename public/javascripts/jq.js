
function jq(myid) { 
  // When I have a dom-node whose id has CSS special characters
  // (such as a dot, which I often do in filenames)
  // then I need to turn these characters off when
  // creating the jQuery id selector string...
  // From the jQuery FAQ

   return $j('#' + myid.replace(/(:|\.)/g,'\\$1'));
}

