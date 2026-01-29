import { Link } from 'react-router-dom';
import { Card, CardContent, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { useCart } from '@/context/CartContext';

export function ProductCard({ product }) {
    const { addToCart } = useCart();

    const handleAddToCart = (e) => {
        e.preventDefault(); // Prevent navigation when clicking the button
        addToCart(product);
    };

    return (
        <Link to={`/product/${product.product_id}`} className="block h-full">
            <Card className="flex flex-col h-full overflow-hidden transition-all hover:shadow-lg cursor-pointer group">
                <div className="aspect-square relative bg-muted/20 flex items-center justify-center overflow-hidden">
                    {product.image ? (
                        <img
                            src={product.image}
                            alt={product.name}
                            className="object-cover w-full h-full transition-transform group-hover:scale-105"
                        />
                    ) : (
                        <span className="text-4xl select-none">📦</span>
                    )}
                </div>
                <CardHeader className="p-4">
                    <div className="flex justify-between items-start gap-2">
                        <CardTitle className="line-clamp-1 text-lg group-hover:text-primary transition-colors">
                            {product.name}
                        </CardTitle>
                        {product.category_name && (
                            <div className="inline-flex items-center rounded-full border px-2.5 py-0.5 text-xs font-semibold transition-colors focus:outline-none focus:ring-2 focus:ring-ring focus:ring-offset-2 border-transparent bg-secondary text-secondary-foreground hover:bg-secondary/80">
                                {product.category_name}
                            </div>
                        )}
                    </div>
                </CardHeader>
                <CardContent className="p-4 pt-0 flex-grow">
                    <p className="text-sm text-muted-foreground line-clamp-2 min-h-[2.5em]">
                        {product.description || 'No description available'}
                    </p>
                </CardContent>
                <CardFooter className="p-4 flex items-center justify-between border-t bg-muted/5">
                    <span className="text-lg font-bold">
                        {new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(product.price)}
                    </span>
                    <Button size="sm" onClick={handleAddToCart}>Add to Cart</Button>
                </CardFooter>
            </Card>
        </Link>
    );
}
