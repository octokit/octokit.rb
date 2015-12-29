var Firebase = require('firebase');
var myRootRef = new Firebase('https://myprojectname.firebaseIO-demo.com/');
myRootRef.set("hello world!");
