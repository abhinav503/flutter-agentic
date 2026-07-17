import { NextResponse } from "next/server";
import { getCategories } from "@/lib/categories";
import { groupCategories } from "@/lib/api/serializers";

// Matches CategoriesEntity/CategoryGroupEntity in gravia's categories
// feature — sections like "Snacks & Drinks" each holding their categories.
export async function GET(
  _request: Request,
  { params }: { params: Promise<{ storeId: string }> },
) {
  const { storeId } = await params;
  const categories = await getCategories(storeId);
  return NextResponse.json({ groups: groupCategories(categories) });
}
