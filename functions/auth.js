// A module that provides a simple authentication API

// Initialize firebase admin
const {initializeApp} = require("firebase-admin/app");
const admin = initializeApp();

// Creates a user given an email and password
// Returns a userRecord
exports.creatUser = function(email, password) {
  return admin.auth().createUser({
    email: email,
    emailVerified: false,
    phoneNumber: "",
    password: password,
    displayName: "",
    photoURL: "",
    disabled: false,
  });
};
