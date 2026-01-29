import { useEffect } from "react"
import { zodResolver } from "@hookform/resolvers/zod"
import { useForm } from "react-hook-form"
import { z } from "zod"
import { Button } from "@/components/ui/button"
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogHeader,
    DialogTitle,
} from "@/components/ui/dialog"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { useToast } from "@/components/ui/use-toast"
import { useCreateProduct, useUpdateProduct } from "@/hooks/useProducts"

const formSchema = z.object({
    name: z.string().min(1, "Name is required"),
    description: z.string().optional(),
    price: z.coerce.number().min(0.01, "Price must be greater than 0"),
    stock: z.coerce.number().int().min(0, "Stock must be positive"),
    sku: z.string().min(1, "SKU is required"),
})

export function ProductForm({ open, onOpenChange, productToEdit }) {
    const { toast } = useToast()
    const createProduct = useCreateProduct()
    const updateProduct = useUpdateProduct()

    const isEditing = !!productToEdit

    const form = useForm({
        resolver: zodResolver(formSchema),
        defaultValues: {
            name: "",
            description: "",
            price: "",
            stock: "",
            sku: "",
        },
    })

    useEffect(() => {
        if (productToEdit) {
            form.reset({
                name: productToEdit.name,
                description: productToEdit.description || "",
                price: productToEdit.price,
                stock: productToEdit.stock,
                sku: productToEdit.sku,
            })
        } else {
            form.reset({
                name: "",
                description: "",
                price: "",
                stock: "",
                sku: "",
            })
        }
    }, [productToEdit, form])

    async function onSubmit(values) {
        try {
            if (isEditing) {
                await updateProduct.mutateAsync({
                    id: productToEdit.product_id,
                    ...values
                })
                toast({ title: "Success", description: "Product updated successfully" })
            } else {
                await createProduct.mutateAsync(values)
                toast({ title: "Success", description: "Product created successfully" })
            }
            onOpenChange(false)
            if (!isEditing) form.reset()
        } catch (error) {
            toast({
                variant: "destructive",
                title: "Error",
                description: "Something went wrong. Please try again.",
            })
        }
    }

    return (
        <Dialog open={open} onOpenChange={onOpenChange}>
            <DialogContent className="sm:max-w-[425px]">
                <DialogHeader>
                    <DialogTitle>{isEditing ? "Edit Product" : "Create Product"}</DialogTitle>
                    <DialogDescription>
                        {isEditing ? "Update existing product details" : "Add a new product to your inventory"}
                    </DialogDescription>
                </DialogHeader>
                <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-4 pt-4">
                    <div className="space-y-2">
                        <Label htmlFor="name">Name</Label>
                        <Input id="name" {...form.register("name")} />
                        {form.formState.errors.name && (
                            <p className="text-sm text-destructive">{form.formState.errors.name.message}</p>
                        )}
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="description">Description</Label>
                        <Input id="description" {...form.register("description")} />
                    </div>

                    <div className="grid grid-cols-2 gap-4">
                        <div className="space-y-2">
                            <Label htmlFor="price">Price</Label>
                            <Input id="price" type="number" step="0.01" {...form.register("price")} />
                            {form.formState.errors.price && (
                                <p className="text-sm text-destructive">{form.formState.errors.price.message}</p>
                            )}
                        </div>

                        <div className="space-y-2">
                            <Label htmlFor="stock">Stock</Label>
                            <Input id="stock" type="number" {...form.register("stock")} />
                            {form.formState.errors.stock && (
                                <p className="text-sm text-destructive">{form.formState.errors.stock.message}</p>
                            )}
                        </div>
                    </div>

                    <div className="space-y-2">
                        <Label htmlFor="sku">SKU</Label>
                        <Input id="sku" {...form.register("sku")} disabled={isEditing} />
                        {form.formState.errors.sku && (
                            <p className="text-sm text-destructive">{form.formState.errors.sku.message}</p>
                        )}
                    </div>

                    <div className="flex justify-end pt-4">
                        <Button type="submit" disabled={form.formState.isSubmitting}>
                            {form.formState.isSubmitting ? "Saving..." : (isEditing ? "Update" : "Create")}
                        </Button>
                    </div>
                </form>
            </DialogContent>
        </Dialog>
    )
}
