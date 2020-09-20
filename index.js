const express = require('express');
const bodyParser = require('body-parser');
const compression = require('compression');

var flash = require('connect-flash');
app = express();
const requireLogin = require('./middlewares/requirelogin');

const firebase = require('firebase/app');
require('firebase/auth');
require('firebase/database');
const admin = require('firebase-admin');
var serviceAccount = require('./config/serviceAccountKey.json');

app.use(
  require('express-session')({
    resave: false,
    saveUninitialized: false,
    secret: 'This is streetlight',
  })
);
app.use(express.static('public'));

app.use(flash());
app.use(function (req, res, next) {
  res.locals.error = req.flash('error');
  res.locals.success = req.flash('success');
  next();
});

app.set('view engine', 'ejs');
app.use(bodyParser.urlencoded({extended: true}));

app.use(compression());

var firebaseConfig = {
  apiKey: 'AIzaSyCzUSy8SElt8FMU7Bz59Mf2gj5sK5g-DcI',
  authDomain: 'guardian-angel-5259f.firebaseapp.com',
  databaseURL: 'https://guardian-angel-5259f.firebaseio.com',
  projectId: 'guardian-angel-5259f',
  storageBucket: 'guardian-angel-5259f.appspot.com',
  messagingSenderId: '839770846564',
  appId: '1:839770846564:web:b2c3d05267c30140f73671',
  measurementId: 'G-6MJS80Q9LV',
};
firebase.initializeApp(firebaseConfig);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://guardian-angel-5259f.firebaseio.com',
});
firebase.auth.Auth.Persistence.LOCAL;

app.get('/signin', (req, res) => {
  res.render('signin');
});

app.post('/signin', (req, res) => {
  var email = req.body.email;
  var password = req.body.password;

  var total = firebase.database().ref('Admin');

  total.once('value', (data) => {
    if (data.val()) {
      var zabhi = data.val();

      var teachers = Object.getOwnPropertyNames(data.val());
      teachers.forEach((teacher) => {
        if (
          zabhi[teacher].Email == email &&
          zabhi[teacher].Password == password
        ) {
          return firebase
            .auth()
            .signInWithEmailAndPassword(email, password)
            .then(() => {
              res.redirect('/emergency');
            })
            // .catch((err) => res.redirect('/signin'));
        }
      });
    }
  });
});

app.get('/logout', (req, res) => {
  firebase.auth().signOut();
  res.render('signin');
});

app.get('/emergency', (req, res) => {
  // var current_user = firebase.auth().currentUser;
  // if (current_user != null) {
  var admin = firebase.database().ref('Emergency/users');
  admin.once('value', (data) => {
    if (data.val()) {
      var users = Object.getOwnPropertyNames(data.val());

      var details = firebase.database().ref('User');
      details.once('value', (data) => {
        var data = data.val();

        res.render('users_list', {
          users: users,
          data: data,
          // user: current_user.displayName,
        });
      });
    } else {
      res.send('i m here');
    }
  });
  // }
});

app.get('/cmt-:eachUser', (req, res) => {
  // var current_user = firebase.auth().currentUser;
  // if (current_user != null) {
  const userId = req.params.eachUser;
  var total = firebase.database().ref('Emergency/users');

  total.once('value', (data) => {
    if (data.val()) {
      var users = Object.getOwnPropertyNames(data.val());
      var data1 = data.val();
      users.forEach((user) => {
        if (userId == user) {
          var details = firebase.database().ref('User');
          details.once('value', (data) => {
            data2 = data.val();


            var location = firebase.database().ref('Location/users');
            location.once('value', (data) => {
              data3 = data.val();
              console.log(data3[userId])

            res.render('blank-page', {
              data: data1[userId],
              det: data2[userId],
              locate: data3[userId]
            });
          });
        });
        }
      });
    }
  });
  // }
});

app.get('/nonc-:eachUser', (req, res) => {
  // var current_user = firebase.auth().currentUser;
  // if (current_user != null) {
  const userId = req.params.eachUser;

  var hardware = firebase.database().ref('Hardware/users');
  hardware.once('value', (data) => {
    var data1 = data.val();
    var details = firebase.database().ref('User');
    details.once('value', (data) => {
      data2 = data.val();

      var location = firebase.database().ref('Location/users');
      location.once('value', (data) => {
        data3 = data.val();
   

          var emergency = firebase.database().ref('Emergency/users');
          emergency.once('value',(data)=>{
            data4 = data.val(); 

            res.render('noncmt',{
              hard: data1[userId],
              det: data2[userId],
              locate: data3[userId],
              emerg: data4[userId]
            })
        })
      });
    });
  });

  // }
});

app.get('/', requireLogin, (req, res) => {
  var current_user = firebase.auth().currentUser;
  if (current_user != null) {
    var total = firebase.database().ref('Total');
    total.once('value', (data) => {
      if (data.val()) {
        res.render('dashboard', {
          data1: data.val(),
          user: current_user.displayName,
        });
      } else {
        res.render('dashboard', {
          user: current_user.displayName,
        });
      }
    });
  }
});

app.get('/members', requireLogin, (req, res) => {
  var current_user = firebase.auth().currentUser;
  if (current_user != null) {

    admin.once('value', (data) => {
      if (data.val()) {
        var teachers = Object.getOwnPropertyNames(data.val());

        res.render('members', {
          teacherNames: teachers,
          data: data.val(),
          user: current_user.displayName,
        });
      } else {
        res.send('i m here');
      }
    });
  }
});

app.get('/staff', (req, res) => {
  var current_user = firebase.auth().currentUser;
  if (current_user != null) {
    var admin = firebase.database().ref('Admin');
    admin.once('value', (data) => {
      if (data.val()) {
        var names = Object.getOwnPropertyNames(data.val());
        res.render('staff', {
          adminNames: names,
          data: data.val(),
          user: current_user.displayName,
        });
      } else {
        res.send('i m here');
      }
    });
  }
});

app.post('/staff', async (req, res) => {
  var email = req.body.email;
  var password = req.body.Password;
  var fname = req.body.fname;
  var sname = req.body.sname;
  var dept = req.body.dept;
  var auth = req.body.auth;

  var root = firebase.database().ref().child(auth);

  var mailval = email.toString();
  var n = mailval.indexOf('@');
  var root2 = root.child(email.substring(0, n));
  var userData = {
    Name: fname + ' ' + sname,
    Email: email,
    Password: password,
    Department: dept,
  };
  root2.set(userData);

  admin
    .auth()
    .createUser({
      email: email,
      password: password,
      displayName: fname + ' ' + sname,
    })
    .then((userRecord) => {
      userRecord.displayName = fname + ' ' + sname;
      console.log('Successfully created new user:', userRecord);
    });
  res.redirect('/staff');
});

const port = process.env.PORT || 8000;
app.listen(port, () => console.log(`Server started at port ${port}`));
