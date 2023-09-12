/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// HTTP functions
const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// import all other function files
const auth = require("./auth.js");

// Sample HTTP function that returns a message
exports.helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});

  response.send("Hello from RenderCloud's Firebase functions!");
});

// -- Auth module --

// HTTP request for sign up
// Parameters: email, password
exports.signUp = onRequest((req, res) => {
  const email = req.body.email;
  const password = req.body.password;

  return auth.createUser(email, password)
      .then((userRecord) => {
        // See the UserRecord reference doc for the contents of userRecord.
        logger.info("Successfully created new user:", userRecord.uid);
        res.status(200).json({"userId": userRecord.uid});
      })
      .catch((error) => {
        logger.info("Error creating new user:", error);
        res.status(500).json({"error": error});
      });
});
