import { useState } from "react"
import { Plus } from "lucide-react"
import { useProducts } from "@/hooks/useProducts"
import { Button } from "@/components/ui/button"
import { ProductTable } from "@/components/admin/ProductTable"
import { ProductForm } from "@/components/admin/ProductForm"

export default function AdminDashboard() {
    const [isCreateOpen, setIsCreateOpen] = useState(false)
    const { data: products, isLoading, error } = useProducts()

    return (
        <div className="min-h-screen pt-16">
            <div className="container py-8 space-y-8">
                <div className="flex justify-between items-center">
                    <div>
                        <h1 className="text-3xl font-bold tracking-tight">Dashboard</h1>
                        <p className="text-muted-foreground">
                            Manage your products and inventory
                        </p>
                    </div>
                    <Button onClick={() => setIsCreateOpen(true)}>
                        <Plus className="mr-2 h-4 w-4" />
                        Add Product
                    </Button>
                </div>

                {isLoading ? (
                    <div className="h-64 flex items-center justify-center border rounded-md bg-muted/10">
                        <p>Loading products...</p>
                    </div>
                ) : error ? (
                    <div className="h-64 flex items-center justify-center border rounded-md bg-destructive/10 text-destructive">
                        <p>Error loading products</p>
                    </div>
                ) : (
                    <ProductTable products={products || []} />
                )}
            </div>

            <ProductForm
                open={isCreateOpen}
                onOpenChange={setIsCreateOpen}
            />
        </div>
    )
}
