import { useQuery } from '@tanstack/react-query';
import { api } from '@/lib/api';

// Fetch categories with optional search
export function useCategories(searchQuery = '') {
    return useQuery({
        queryKey: ['categories', searchQuery],
        queryFn: async () => {
            const { data } = await api.get('/categories/', {
                params: { name: searchQuery }
            });
            return data.data || [];
        },
        retry: 1,
    });
}
