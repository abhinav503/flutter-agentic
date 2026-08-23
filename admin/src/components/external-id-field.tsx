import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

// The id a source system (Shopify, WooCommerce, an ERP) knows a record by.
// Optional everywhere, but once set it is what a re-import matches on — so
// a rename in either system updates the record instead of duplicating it.
export function ExternalIdField({
  id,
  value,
  onChange,
}: {
  id: string;
  value: string;
  onChange: (value: string) => void;
}) {
  return (
    <div className="flex flex-col gap-1.5">
      <Label htmlFor={id}>External ID (optional)</Label>
      <Input
        id={id}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        placeholder="e.g. the Shopify handle or ERP code"
      />
      <p className="text-xs text-muted-foreground">
        Imports match on this, so a rename updates this record instead of
        creating a second one.
      </p>
    </div>
  );
}
