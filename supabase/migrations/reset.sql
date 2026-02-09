-- remove realtime publication
ALTER PUBLICATION supabase_realtime DROP TABLE IF EXISTS public.menu_items;
ALTER PUBLICATION supabase_realtime DROP TABLE IF EXISTS public.orders;
ALTER PUBLICATION supabase_realtime DROP TABLE IF EXISTS public.profiles;

-- drop trigger
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- drop functions
DROP FUNCTION IF EXISTS public.handle_new_user();
DROP FUNCTION IF EXISTS public.delete_user();
DROP FUNCTION IF EXISTS public.is_admin();

-- drop tables
DROP TABLE IF EXISTS public.orders CASCADE;
DROP TABLE IF EXISTS public.menu_items CASCADE;
DROP TABLE IF EXISTS public.profiles CASCADE;
