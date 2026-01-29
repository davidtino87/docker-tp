import { useParams, useNavigate } from 'react-router-dom';
import { useProduct } from '@/hooks/useProducts';
import { useCart } from '@/context/CartContext';
import { Button } from '@/components/ui/button';
import { Loader2, ArrowLeft } from 'lucide-react';
import { Separator } from '@/components/ui/separator';

export default function ProductDetails() {
    const { id } = useParams();
    const navigate = useNavigate();
    const { data: product, isLoading, error } = useProduct(id);
    const { addToCart } = useCart();

    if (isLoading) {
        return (
            <div className="flex h-[50vh] items-center justify-center">
                <Loader2 className="h-8 w-8 animate-spin text-primary" />
            </div>
        );
    }

    if (error || !product) {
        return (
            <div className="flex flex-col items-center justify-center h-[50vh] space-y-4">
                <p className="text-destructive text-lg">Failed to load product details</p>
                <Button variant="outline" onClick={() => navigate('/')}>
                    Go Back Home
                </Button>
            </div>
        );
    }

    return (
        <div className="container py-10">
            <Button variant="ghost" className="mb-6 pl-0 hover:pl-2 transition-all" onClick={() => navigate(-1)}>
                <ArrowLeft className="mr-2 h-4 w-4" />
                Back
            </Button>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-8 lg:gap-12">
                {/* Product Image */}
                <div className="aspect-square relative overflow-hidden rounded-lg border bg-muted">
                    {product.image ? (
                        <img
                            src={product.image}
                            alt={product.name}
                            className="object-cover w-full h-full"
                        />
                    ) : (
                        <div className="flex items-center justify-center w-full h-full text-muted-foreground">
                            No Image Available
                        </div>
                    )}
                </div>

                {/* Product Info */}
                <div className="flex flex-col space-y-6">
                    <div>
                        <h1 className="text-3xl font-bold tracking-tight">{product.name}</h1>
                        <div className="mt-4 text-2xl font-bold text-primary">
                            ${product.price}
                        </div>
                    </div>

                    <Separator />

                    <div className="space-y-4">
                        <h3 className="text-lg font-semibold">Description</h3>
                        <p className="text-muted-foreground leading-relaxed">
                            {product.description || "No description provided."}
                        </p>
                    </div>

                    <div className="space-y-4 pt-6">
                        <div className="flex items-center space-x-2">
                            <span className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 ${product.stock > 0 ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}>
                                {product.stock > 0 ? 'In Stock' : 'Out of Stock'}
                            </span>
                            {product.stock > 0 && (
                                <span className="text-sm text-muted-foreground">
                                    {product.stock} units available
                                </span>
                            )}
                        </div>

                        <Button
                            className="w-full md:w-auto md:min-w-[200px]"
                            size="lg"
                            disabled={product.stock <= 0}
                            onClick={() => addToCart(product)}
                        >
                            {product.stock > 0 ? 'Add to Cart' : 'Out of Stock'}
                        </Button>
                    </div>
                </div>
            </div>
        </div>
    );
}
