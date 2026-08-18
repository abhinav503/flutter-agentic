import {
  BadgePercent,
  Bell,
  Box,
  CreditCard,
  FileText,
  Globe,
  ImageIcon,
  KeyRound,
  Package,
  Receipt,
  Rocket,
  Settings,
  ShoppingCart,
  Star,
  Store,
  TrendingUp,
  Truck,
  Upload,
  Users,
  Wand2,
  type LucideProps,
} from "lucide-react";

/**
 * The docs icon set.
 *
 * A closed map rather than a dynamic lookup: MDX authors name an icon as a
 * string, and a string that doesn't resolve should be a type error at build
 * time, not a hole in the page. The template reached for Iconify's whole
 * hugeicons set for this — lucide is already a dependency and ships only what
 * is imported here.
 */
const icons = {
  rocket: Rocket,
  store: Store,
  package: Package,
  "credit-card": CreditCard,
  receipt: Receipt,
  "trending-up": TrendingUp,
  globe: Globe,
  settings: Settings,
  upload: Upload,
  wand: Wand2,
  image: ImageIcon,
  box: Box,
  cart: ShoppingCart,
  truck: Truck,
  key: KeyRound,
  bell: Bell,
  star: Star,
  coupon: BadgePercent,
  users: Users,
  file: FileText,
} as const;

export type DocIconName = keyof typeof icons;

export function DocIcon({ name, ...props }: { name: DocIconName } & LucideProps) {
  const Icon = icons[name];
  return <Icon aria-hidden="true" {...props} />;
}
