import * as React from 'react';
import { useState } from 'react';
import { useProducts } from '@/hooks/useProducts';
import { useDebounce } from '@/hooks/useDebounce';
import { ProductCard } from '@/components/products/ProductCard';
import { ProductFilters } from '@/components/products/ProductFilters';

export default function Home() {
    const [search, setSearch] = useState('');
    const [category, setCategory] = useState('all');
    const debouncedSearch = useDebounce(search, 500);

    const { data: products, isLoading, error } = useProducts(debouncedSearch, category === 'all' ? null : category);

    return (
        <div className="min-h-screen pt-16">
            {/* Hero Section */}
            <section className="bg-primary/5 py-12 md:py-24 border-b">
                <div className="container px-4 md:px-6">
                    <div className="flex flex-col items-center space-y-4 text-center">
                        <h1 className="text-3xl font-bold tracking-tighter sm:text-4xl md:text-5xl lg:text-6xl/none">
                            Discover Quality Products
                        </h1>
                        <p className="mx-auto max-w-[700px] text-muted-foreground md:text-xl">
                            Browsing our latest collection of premium items. Filter, search, and find exactly what you need.
                        </p>
                    </div>
                </div>
            </section>

            <div className="container py-8">
                <ProductFilters
                    searchQuery={search}
                    onSearchChange={setSearch}
                    selectedCategory={category}
                    onCategoryChange={setCategory}
                />

                {isLoading ? (
                    <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
                        {[...Array(8)].map((_, i) => (
                            <div key={i} className="h-[350px] rounded-lg border bg-muted animate-pulse" />
                        ))}
                    </div>
                ) : error ? (
                    <div className="text-center py-12 text-destructive">
                        <p>Error loading products. Please try again later.</p>
                    </div>
                ) : products?.length === 0 ? (
                    <div className="text-center py-12 text-muted-foreground">
                        <p>No products found matching your search.</p>
                    </div>
                ) : (
                    <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
                        {products.map((product) => (
                            <ProductCard key={product.product_id} product={product} />
                        ))}
                    </div>
                )}
            </div>
        </div>
    );
}
