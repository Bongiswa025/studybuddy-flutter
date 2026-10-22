
importScripts(
  'https://www.gstatic.com/firebasejs/9.6.10/firebase-app-compat.js'
);

importScripts(
  'https://www.gstatic.com/firebasejs/9.6.10/firebase-messaging-compat.js'
);


const firebaseConfig = {
   apiKey: 'AIzaSyBSnZqhFlWjSP7ihLf_p3mjVMEDtt4xEXk',
  authDomain: 'studybuddy-fcm.firebaseapp.com',
  projectId: 'studybuddy-fcm',
  storageBucket: 'studybuddy-fcm.firebasestorage.app',
  messagingSenderId: '1064475260855',
  appId: '1:1064475260855:web:429d8049a20c2def155a32',
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();
messaging.onBackgroundMessage((message) => {
  console.log('StudyBuddy background message:', message);
});

