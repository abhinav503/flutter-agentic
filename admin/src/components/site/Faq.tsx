"use client";

/**
 * FAQ accordion — local state only. Mark as a client component.
 */
import { useState } from "react";
import { Plus } from "lucide-react";
import { SectionShell, SectionHeading } from "./ui";
import { faqItems } from "./faq-data";

export function Faq() {
  const [openId, setOpenId] = useState<string | null>(faqItems[0].id);

  return (
    <SectionShell id="faq" labelledBy="faq-heading">
      <SectionHeading
        id="faq-heading"
        eyebrow="FAQ"
        title="Questions store owners ask before launching"
      />

      <dl className="mt-12 divide-y divide-border border-y border-border">
        {faqItems.map((item) => {
          const open = openId === item.id;
          return (
            <div key={item.id} className="py-1">
              <dt>
                <button
                  type="button"
                  aria-expanded={open}
                  aria-controls={`${item.id}-answer`}
                  onClick={() => setOpenId(open ? null : item.id)}
                  className="flex w-full items-center justify-between gap-6 py-5 text-left"
                >
                  <h3 className="text-base font-semibold text-ink sm:text-lg">{item.question}</h3>
                  <Plus
                    aria-hidden="true"
                    className={`size-5 shrink-0 text-primary transition-transform duration-200 ${
                      open ? "rotate-45" : ""
                    }`}
                  />
                </button>
              </dt>
              <dd id={`${item.id}-answer`} hidden={!open} className="pb-6 pr-10">
                <p className="max-w-3xl text-sm leading-7 text-muted-foreground">{item.answer}</p>
              </dd>
            </div>
          );
        })}
      </dl>
    </SectionShell>
  );
}
