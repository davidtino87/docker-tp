import { Link } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { useCart } from '@/context/CartContext';
import { Button } from '@/components/ui/button';
import { ShoppingCart } from 'lucide-react';
import { SignInModal } from '@/components/auth/SignInModal';
import { SignUpModal } from '@/components/auth/SignUpModal';
import { useState } from 'react';

export default function Header() {
    const { user, logout } = useAuth();
    const { cartCount } = useCart();
    const [isSignInOpen, setIsSignInOpen] = useState(false);
    const [isSignUpOpen, setIsSignUpOpen] = useState(false);

    return (
        <header className="sticky top-0 z-50 w-full border-b bg-background/95 backdrop-blur supports-[backdrop-filter]:bg-background/60">
            <div className="container flex h-16 items-center justify-between">
                <Link to="/" className="flex items-center space-x-2">
                    <span className="text-xl font-bold">E-Com Flow</span>
                </Link>
                <div className="flex items-center space-x-4">
                    <Button variant="ghost" size="icon" className="relative">
                        <ShoppingCart className="h-5 w-5" />
                        {cartCount > 0 && (
                            <span className="absolute -top-1 -right-1 h-4 w-4 rounded-full bg-primary text-[10px] font-medium text-primary-foreground flex items-center justify-center">
                                {cartCount}
                            </span>
                        )}
                    </Button>
                    {user ? (
                        <>
                            <span className="text-sm text-muted-foreground mr-2">
                                {user.email}
                            </span>
                            <Link to="/admin">
                                <Button variant="ghost">Dashboard</Button>
                            </Link>
                            <Button variant="outline" onClick={logout}>
                                Logout
                            </Button>
                        </>
                    ) : (
                        <>
                            <Button variant="ghost" onClick={() => setIsSignInOpen(true)}>
                                Sign In
                            </Button>
                            <Button onClick={() => setIsSignUpOpen(true)}>
                                Sign Up
                            </Button>
                        </>
                    )}
                </div>
            </div>

            <SignInModal
                open={isSignInOpen}
                onOpenChange={setIsSignInOpen}
            />

            <SignUpModal
                open={isSignUpOpen}
                onOpenChange={setIsSignUpOpen}
            />
        </header>
    );
}
