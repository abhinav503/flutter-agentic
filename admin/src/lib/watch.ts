import {
  onSnapshot,
  type FirestoreError,
  type Query,
  type QuerySnapshot,
} from "firebase/firestore";

/**
 * Subscribes to `query`, mapping each snapshot before handing it on — and,
 * unlike a bare `onSnapshot(query, cb)`, gives the failure somewhere to go.
 *
 * Without an error callback the Firestore SDK swallows a failed listen: a
 * permission denial, an offline client or a missing index simply never calls
 * back. Every list in this dashboard renders "No X yet." when its array is
 * empty, so a broken listener looked exactly like an empty collection — which
 * is precisely how a store that *did* have products was reported as having
 * none, with nothing in the UI to suggest otherwise.
 *
 * The console line is the floor: even a caller that ignores `onError` now
 * leaves a trace. Callers that pass one can tell the difference in the UI.
 */
export function watchQuery<T>(
  query: Query,
  map: (snapshot: QuerySnapshot) => T,
  onChange: (value: T) => void,
  onError?: (error: FirestoreError) => void,
) {
  return onSnapshot(
    query,
    (snapshot) => onChange(map(snapshot)),
    (error) => {
      console.error("Firestore listener failed", error);
      onError?.(error);
    },
  );
}
