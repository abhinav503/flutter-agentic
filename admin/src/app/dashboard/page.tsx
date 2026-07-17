"use client";

import { useEffect, useState } from "react";
import { useStore } from "@/lib/store-context";
import { watchCategories } from "@/lib/categories";
import { watchProducts } from "@/lib/products";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

export default function DashboardOverviewPage() {
  const { storeId, storeName } = useStore();
  const [categoryCount, setCategoryCount] = useState<number | null>(null);
  const [productCount, setProductCount] = useState<number | null>(null);

  useEffect(() => {
    if (!storeId) return;
    const unsubCategories = watchCategories(storeId, (c) => setCategoryCount(c.length));
    const unsubProducts = watchProducts(storeId, (p) => setProductCount(p.length));
    return () => {
      unsubCategories();
      unsubProducts();
    };
  }, [storeId]);

  return (
    <div className="flex flex-col gap-6">
      <div>
        <h1 className="text-lg font-semibold">{storeName ?? "Overview"}</h1>
        <p className="text-sm text-muted-foreground">
          Manage your catalog from Categories and Products in the sidebar.
        </p>
      </div>

      <div className="grid grid-cols-2 gap-4 sm:grid-cols-3">
        <Card>
          <CardHeader>
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Categories
            </CardTitle>
          </CardHeader>
          <CardContent className="text-2xl font-semibold">
            {categoryCount ?? "…"}
          </CardContent>
        </Card>
        <Card>
          <CardHeader>
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Products
            </CardTitle>
          </CardHeader>
          <CardContent className="text-2xl font-semibold">
            {productCount ?? "…"}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
