import { onCall, HttpsError } from "firebase-functions/v2/https";
import * as admin from "firebase-admin";
import { getFirestore } from "firebase-admin/firestore";

// Initializes the Admin SDK
admin.initializeApp();
const db = getFirestore();

/**
 * DELETES A USER
 */
export const deleteUserAuth = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "You must be logged in.");
  }

  const targetUid = request.data.uid;
  if (!targetUid) {
    throw new HttpsError("invalid-argument", "Missing 'uid'.");
  }

  try {
    await admin.auth().deleteUser(targetUid);
    return { success: true, message: `Deleted user ${targetUid}` };
  } catch (error) {
    console.error("Error deleting user:", error);
    throw new HttpsError("internal", "Failed to delete user.");
  }
});

/**
 * BACKFILL EMAILS TO FIRESTORE (Run Once)
 */
export const backfillEmailsToFirestore = onCall(async (request) => {
  try {
    let count = 0;
    let nextPageToken: string | undefined;

    do {
      const listUsersResult = await admin.auth().listUsers(1000, nextPageToken);
      const batch = db.batch();

      listUsersResult.users.forEach((userRecord) => {
        if (userRecord.email) {
          const userRef = db.collection("users").doc(userRecord.uid);
          batch.set(userRef, {
            uid: userRecord.uid,
            email: userRecord.email,
            displayName: userRecord.displayName || "",
          }, { merge: true });
          count++;
        }
      });

      await batch.commit();
      nextPageToken = listUsersResult.pageToken;
    } while (nextPageToken);

    return {
      success: true,
      message: `Successfully synced ${count} users to Firestore.`
    };
  } catch (error) {
    console.error("Backfill failed:", error);
    throw new HttpsError("internal", "An error occurred during backfill.");
  }
});