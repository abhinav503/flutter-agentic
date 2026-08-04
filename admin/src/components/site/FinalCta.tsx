import { GhostLink } from "./ui";
import { AuthCta } from "./AuthCta";

export function FinalCta() {
  return (
    <section aria-labelledby="final-cta-heading" className="border-t border-border py-20 sm:py-24">
      <div className="mx-auto w-full max-w-6xl px-5 sm:px-8">
        <div className="hero-wash surface-panel rounded-3xl px-8 py-14 text-center sm:px-14">
          <h2
            id="final-cta-heading"
            className="mx-auto max-w-2xl text-balance text-3xl font-extrabold tracking-tight text-ink sm:text-4xl"
          >
            Get your own grocery app, and keep every rupee of the sale
          </h2>
          <p className="mx-auto mt-4 max-w-xl text-pretty text-base leading-7 text-muted-foreground">
            Create your store, pick a template and start adding products. We are currently
            onboarding early stores.
          </p>
          <div className="mt-8 flex flex-wrap justify-center gap-3">
            <AuthCta mode="signup">Start free — create your store</AuthCta>
            <GhostLink href="mailto:cordeliaapps@gmail.com">Email the CordeliaApps team</GhostLink>
          </div>
        </div>
      </div>
    </section>
  );
}
