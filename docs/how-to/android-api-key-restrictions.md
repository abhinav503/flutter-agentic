# Android API key restrictions (and the blocked-client error)

The symptom, in the app, on any Firebase Auth call:

```
An internal error has occurred.
[ Requests from this Android client application com.cordeliaapps.superapp are blocked. ]
```

Nothing is wrong with the build. A Google Cloud API key carries an
**application restriction** — an allow-list of (package name, SHA-1 signing
certificate) pairs — and the calling app isn't on it. The check happens
server-side on every request, so the fix never needs a rebuild, a version bump
or a new upload: edit the list and builds shipped months ago start working.

## The two things everyone gets wrong

**1. Firebase fingerprints and the GCP key restriction are different lists.**
Firebase Console → Project settings → Your apps → Add fingerprint feeds other
Firebase features. It does **not** touch the API key's allow-list. Adding it
there and nowhere else changes nothing about this error. The block is enforced
in **GCP Console → APIs & Services → Credentials → <the key>**.

**2. The Play Console's "Classical key" SHA-1 is not necessarily the cert your
installed build carries.** After a signing-key rotation there are two classical
certificates, and a build already on a device keeps the older one until it
updates. Allow-list both, always.

## Which key the app actually uses

`google-services.json` may list several keys for the project — the one used at
runtime is the one in `firebase_options.dart`, since `main.dart` initialises
with `DefaultFirebaseOptions.currentPlatform`:

```bash
grep -n -A2 "FirebaseOptions android" apps/ecommerce/cordelia/lib/firebase_options.dart
```

Android and iOS have separate keys. Restricting the Android one cannot break
iOS, and vice versa.

## Collect every fingerprint

**Play App Signing** — Play Console → **Protected with Play** → App signing
(direct URL: `play.google.com/console/u/0/developers/<dev>/app/<app>/keymanagement`;
the old *Test and release → App integrity* page now redirects there). Click
**Download certificates**, then:

```bash
cd ~/Downloads/certificates
for f in *.der; do echo "== $f"; keytool -printcert -file "$f" | grep -i "SHA1:"; done
```

- `deployment_cert.der` — the pre-rotation deployment certificate.
- `hybrid_classical_cert.der` — the classical half of the quantum-ready key.
- `hybrid_pqc_cert.der` — **skip it.** ML-DSA signature algorithm
  (`2.16.840.1.101.3.4.3.18`); Android restrictions validate the classical cert
  only.

**Upload key** — from the app's own signing config, no console needed:

```bash
PROPS=apps/ecommerce/cordelia/android/key.properties
keytool -list -v \
  -keystore "$(grep '^storeFile=' $PROPS | cut -d= -f2-)" \
  -alias    "$(grep '^keyAlias='  $PROPS | cut -d= -f2-)" \
  -storepass "$(grep '^storePassword=' $PROPS | cut -d= -f2-)" | grep -i "SHA1:"
```

**Debug key** — needed for `flutter run`:

```bash
keytool -list -v -keystore ~/.android/debug.keystore \
  -alias androiddebugkey -storepass android | grep -i "SHA1:"
```

**A device's actual build** — ground truth when the console is ambiguous:

```bash
adb shell pm path com.cordeliaapps.superapp
adb pull <path it prints> /tmp/app.apk
keytool -printcert -jarfile /tmp/app.apk | grep -i "SHA1:"
```

## Add them

GCP → Credentials → the key → **Application restrictions → Android apps**, one
item per (package, fingerprint) pair. Every package that ships against this key
needs its own rows — a key shared by several Android clients blocks the ones
you leave out.

Save, then allow ~5 minutes. On the device, **force-stop** the app rather than
backgrounding it: Firebase Auth caches the rejection for the process lifetime.

## Verify without a device

The decisive check. It sends the same `X-Android-Package` / `X-Android-Cert`
headers the SDK does, against a deliberately invalid login — so it creates
nothing and changes nothing.

```bash
KEY=<the android api key>
probe() {
  out=$(curl -s -X POST \
    "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$KEY" \
    -H "Content-Type: application/json" \
    -H "X-Android-Package: $1" \
    -H "X-Android-Cert: $2" \
    -d '{"email":"probe@example.invalid","password":"x","returnSecureToken":true}')
  echo "$out" | grep -q "are blocked" && echo "BLOCKED $1 $2" || echo "ALLOWED $1 $2"
}

probe com.cordeliaapps.superapp 95605EFE8BEF52B4DD2F2F8C4766E3E56B1EAC26
probe com.cordeliaapps.superapp 0000000000000000000000000000000000000000   # control
```

The cert is the SHA-1 in **uppercase hex with no colons**.

- `ALLOWED` prints `INVALID_LOGIN_CREDENTIALS` — the key accepted the caller and
  the *credentials* failed, which is the pass condition.
- Always probe a bogus fingerprint too. If that comes back ALLOWED, the key has
  no application restriction at all and the others passing means nothing.

## Two errors that look alike

| Message | Cause | Fix |
|---|---|---|
| "Requests from this **Android client application** … are blocked" | Application restriction — package/SHA-1 not allow-listed | this document |
| "Requests to this **API** … are blocked" | API restriction — the API isn't on the key's allowed list | add Identity Toolkit API, Token Service API, Firebase Installations API, FCM, Cloud Storage |

## This project, as of 2026-08-21

Certificate hashes are public by construction (so is a client API key), so
these are recorded rather than looked up again each time.

| Source | SHA-1 |
|---|---|
| Play deployment cert | `95:60:5E:FE:8B:EF:52:B4:DD:2F:2F:8C:47:66:E3:E5:6B:1E:AC:26` |
| Play hybrid classical | `C8:85:98:3A:A6:11:F5:AA:CF:F6:93:04:D3:38:C4:92:6D:AB:8F:62` |
| Upload key (`upload`) | `BA:73:9B:65:8C:28:27:C7:BF:EA:35:13:F4:C7:12:C1:0A:44:5E:E5` |
| Debug keystore | `52:EE:29:C8:B5:20:AF:C3:A5:86:FA:B1:60:49:C3:52:B5:21:5F:5A` |

Known gap: `com.flutteragentic.gravia` shares this key and is on none of these
rows, so its Android builds will hit the same error the next time one runs.
`com.example.entries` is a leftover client in the Firebase project and should
be deleted.

## If you lose the upload keystore

`android/key.properties` holds the passwords in plaintext and points at the
`.jks`. Without that file no further build can be uploaded to the existing
listing — Google can reset an upload key, but it is a support round-trip.
Back it up off the build machine.
