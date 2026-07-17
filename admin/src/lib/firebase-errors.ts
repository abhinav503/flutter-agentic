import { FirebaseError } from "firebase/app";

// Firebase Auth error → readable message. `auth/invalid-credential` covers
// both "no such account" and "wrong password" as one code — Email
// Enumeration Protection is on for this project, so the server
// (INVALID_LOGIN_CREDENTIALS) deliberately won't say which, to stop an
// attacker from probing which emails are registered. Don't split this case;
// route it to a generic message instead.
const MESSAGES: Record<string, string> = {
  "auth/invalid-credential": "Incorrect email or password.",
  "auth/wrong-password": "Incorrect email or password.",
  "auth/user-not-found": "Incorrect email or password.",
  "auth/invalid-email": "That doesn't look like a valid email address.",
  "auth/missing-password": "Enter a password.",
  "auth/user-disabled": "This account has been disabled.",
  "auth/too-many-requests": "Too many attempts. Wait a moment and try again.",
  "auth/network-request-failed":
    "Network error — check your connection and try again.",
  "auth/email-already-in-use": "An account with this email already exists.",
  "auth/weak-password": "Password must be at least 6 characters.",
};

export function authErrorMessage(error: unknown): string {
  if (error instanceof FirebaseError) {
    return MESSAGES[error.code] ?? "Something went wrong. Please try again.";
  }
  return "Something went wrong. Please try again.";
}
