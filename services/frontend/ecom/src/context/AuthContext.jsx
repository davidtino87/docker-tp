import { createContext, useState, useEffect } from 'react';
import { api } from '@/lib/api';

export const AuthContext = createContext(null);

export function AuthProvider({ children }) {
    const [user, setUser] = useState(null);
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        // Check for existing token on mount
        const token = localStorage.getItem('access_token');
        if (token) {
            // Set user as authenticated
            setUser({ token });
        }
        setIsLoading(false);
    }, []);

    const login = async (email, password) => {
        try {
            // Backend expects query parameters for this endpoint
            const response = await api.post('/admin/login', null, {
                params: {
                    email,
                    password
                }
            });

            const { access_token } = response.data;

            localStorage.setItem('access_token', access_token);
            setUser({ email, token: access_token });

            return response.data;
        } catch (error) {
            throw error;
        }
    };

    const register = async (email, password) => {
        try {
            // Backend expects query parameters for this endpoint
            const response = await api.post('/admin/register', null, {
                params: {
                    email,
                    password
                }
            });

            return response.data;
        } catch (error) {
            throw error;
        }
    };

    const logout = () => {
        localStorage.removeItem('access_token');
        setUser(null);
    };

    return (
        <AuthContext.Provider value={{ user, login, register, logout, isLoading }}>
            {children}
        </AuthContext.Provider>
    );
}
