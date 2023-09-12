/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// HTTP functions
const {onCall, HttpsError} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// import all other function files
const auth = require("./auth.js");

// Sample HTTP function that returns a message
exports.helloWorld = onCall((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  return {response: "Hello from RenderCloud's Firebase functions!"};
});

// -- Auth module --

// HTTP request for sign up
// Parameters: email, password
exports.signUp = onCall((req, res) => {
  const email = req.data.email;
  const password = req.data.password;

  return auth.createUser(email, password)
      .then((userRecord) => {
        // See the UserRecord reference doc for the contents of userRecord.
        logger.info("Successfully created new user:", userRecord.uid);
        return {"userId": userRecord.uid};
      })
      .catch((error) => {
        logger.info("Error creating new user:", error);
        throw new HttpsError(error);
      });
});
