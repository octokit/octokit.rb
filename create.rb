Attempt to read /? with auth=null
	/: "true"
		=> true
  var Firebase = require('firebase');
  var myRootRef = new Firebase('https://myprojectname.firebaseIO-demo.com/');
  myRootRef.set("hello world!");
  
  Read was allowed.
