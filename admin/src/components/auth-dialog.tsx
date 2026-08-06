"use client";

import {
  createContext,
  useCallback,
  useContext,
  useState,
  type FormEvent,
  type ReactNode,
} from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth-context";
import { authErrorMessage } from "@/lib/firebase-errors";
import { trackSignupCompleted } from "@/lib/telemetry";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";

export type AuthMode = "login" | "signup";

const AuthDialogContext = createContext<((mode: AuthMode) => void) | null>(
  null,
);

/** Opens the sign-in / sign-up dialog. Any client component can call it. */
export function useAuthDialog() {
  const openAuth = useContext(AuthDialogContext);
  if (!openAuth) {
    throw new Error("useAuthDialog must be used within an AuthDialogProvider");
  }
  return openAuth;
}

/**
 * Hosts the auth dialog for the marketing pages. Signing in is a modal over
 * whatever the visitor was reading — the page keeps its scroll position, and
 * there is no sign-in screen to bounce through.
 *
 * **It only ever opens from a click** — Log in, or any "Start free" CTA. There
 * is deliberately no way to request it on arrival: a visitor's first sight of
 * the marketing page must be the marketing page, not a sign-in form over a
 * blurred one. `/login` and `/signup` used to render this page with the dialog
 * pre-opened; both now redirect to `/` (see next.config.ts) precisely because
 * that is the same thing by another route.
 */
export function AuthDialogProvider({ children }: { children: ReactNode }) {
  const [mode, setMode] = useState<AuthMode | null>(null);

  const openAuth = useCallback((next: AuthMode) => setMode(next), []);

  return (
    <AuthDialogContext.Provider value={openAuth}>
      {children}
      <AuthDialog
        mode={mode}
        onModeChange={setMode}
        onClose={() => setMode(null)}
      />
    </AuthDialogContext.Provider>
  );
}

function AuthDialog({
  mode,
  onModeChange,
  onClose,
}: {
  mode: AuthMode | null;
  onModeChange: (mode: AuthMode) => void;
  onClose: () => void;
}) {
  const router = useRouter();
  const { signIn, signUp } = useAuth();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [submitting, setSubmitting] = useState(false);

  const isSignup = mode === "signup";

  // A failed sign-in shouldn't still be complaining on the other form, or the
  // next time the dialog opens — both transitions clear it.
  function switchMode() {
    setError(null);
    onModeChange(isSignup ? "login" : "signup");
  }

  function close() {
    setError(null);
    setPassword("");
    onClose();
  }

  async function handleSubmit(event: FormEvent) {
    event.preventDefault();
    setError(null);
    setSubmitting(true);
    try {
      if (isSignup) {
        await signUp(email, password);
        // After the await, so a failed sign-up never counts as a conversion.
        trackSignupCompleted();
      } else {
        await signIn(email, password);
      }
      close();
      // replace, not push. RedirectIfSignedIn reacts to the same auth change
      // and also navigates here; two pushes would stack duplicate history
      // entries, so Back would land on /dashboard again. Both being replaces
      // makes the pair idempotent whichever wins the race — and Back should
      // not return to the marketing page you just signed in from anyway.
      router.replace("/dashboard");
    } catch (err) {
      setError(authErrorMessage(err));
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <Dialog
      open={mode !== null}
      onOpenChange={(open) => {
        if (!open) close();
      }}
    >
      <DialogContent className="p-6 sm:max-w-md">
        <DialogHeader>
          <DialogTitle className="text-xl font-extrabold tracking-tight text-ink">
            {isSignup ? "Create your store account" : "Welcome back"}
          </DialogTitle>
          <DialogDescription>
            {isSignup
              ? "You'll pick a template and name your store next."
              : "Manage your store's catalog, orders, and pricing."}
          </DialogDescription>
        </DialogHeader>

        <form onSubmit={handleSubmit} className="mt-2 flex flex-col gap-4">
          <div className="flex flex-col gap-1.5">
            <Label htmlFor="auth-email">Email</Label>
            <Input
              id="auth-email"
              type="email"
              required
              autoComplete="email"
              value={email}
              onChange={(event) => setEmail(event.target.value)}
              placeholder="you@store.com"
              className="h-10"
            />
          </div>

          <div className="flex flex-col gap-1.5">
            <Label htmlFor="auth-password">Password</Label>
            <Input
              id="auth-password"
              type="password"
              required
              minLength={isSignup ? 6 : undefined}
              autoComplete={isSignup ? "new-password" : "current-password"}
              value={password}
              onChange={(event) => setPassword(event.target.value)}
              placeholder={isSignup ? "At least 6 characters" : "••••••••"}
              className="h-10"
            />
          </div>

          {error && (
            <p role="alert" className="text-sm font-medium text-destructive">
              {error}
            </p>
          )}

          <Button
            type="submit"
            disabled={submitting}
            className="h-11 rounded-full text-sm font-semibold shadow-[var(--shadow-soft)]"
          >
            {submitting
              ? isSignup
                ? "Creating account…"
                : "Signing in…"
              : isSignup
                ? "Create account"
                : "Sign in"}
          </Button>
        </form>

        <p className="text-sm text-muted-foreground">
          {isSignup ? "Already have an account?" : "New store owner?"}{" "}
          <button
            type="button"
            onClick={switchMode}
            className="font-semibold text-primary underline underline-offset-4 hover:text-primary/80"
          >
            {isSignup ? "Sign in" : "Create an account"}
          </button>
        </p>
      </DialogContent>
    </Dialog>
  );
}
