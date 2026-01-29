import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from '@/lib/api';

// Fetch products with optional search
// Fetch products with optional search and category
export function useProducts(searchQuery = '', categoryId = null) {
    return useQuery({
        queryKey: ['products', searchQuery, categoryId],
        queryFn: async () => {
            const { data } = await api.get('/products/', {
                params: {
                    name: searchQuery,
                    category_id: categoryId
                }
            });
            return data.data || [];
        },
        retry: 1,
    });
}

// Fetch single product
export function useProduct(id) {
    return useQuery({
        queryKey: ['product', id],
        queryFn: async () => {
            const { data } = await api.get(`/products/${id}`);
            return data;
        },
        enabled: !!id,
    });
}

// Create product
export function useCreateProduct() {
    const queryClient = useQueryClient();

    return useMutation({
        mutationFn: async (productData) => {
            // Backend expects query parameters
            const { data } = await api.post('/products/', null, {
                params: productData,
            });
            return data;
        },
        onSuccess: () => {
            queryClient.invalidateQueries({ queryKey: ['products'] });
        },
    });
}

// Update product
export function useUpdateProduct() {
    const queryClient = useQueryClient();

    return useMutation({
        mutationFn: async ({ id, ...productData }) => {
            // Backend expects query parameters
            const { data } = await api.put(`/products/${id}`, null, {
                params: productData
            });
            return data;
        },
        onSuccess: () => {
            queryClient.invalidateQueries({ queryKey: ['products'] });
        },
    });
}

// Delete product
export function useDeleteProduct() {
    const queryClient = useQueryClient();

    return useMutation({
        mutationFn: async (productId) => {
            const { data } = await api.delete(`/products/${productId}`);
            return data;
        },
        onSuccess: () => {
            queryClient.invalidateQueries({ queryKey: ['products'] });
        },
    });
}
