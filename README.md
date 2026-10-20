# Mi Gym
Sitio estático + Supabase (sin login). Tu código secreto (GYM_CODE en config.js) identifica tus datos.

1. Supabase → SQL Editor → pegar `supabase.sql` → Run.
2. `config.js` ya trae tu URL, tu anon key y tu código secreto.
3. Subir todos los archivos a GitHub (Add file → Upload files; si ya existen, se reemplazan).
4. Vercel redeploya solo al detectar el cambio.
5. Abrir la URL, Progreso → pegar respaldo viejo → Restaurar.

Backups: Supabase guarda una copia diaria en la tabla `gym_store_history`.
