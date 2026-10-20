# Mi Gym

App para registrar entrenamientos. Sitio estático (sin build) + Supabase para guardar los datos.

## 0. Antes de nada: rescatá tus datos actuales
Abrí la app vieja (si todavía tiene datos) → Progreso → **Copiar respaldo** y pegalo en un bloc de notas.

## 1. Supabase (la base de datos)
1. Creá una cuenta y un proyecto en https://supabase.com (plan gratis).
2. Menú **SQL Editor → New query**, pegá todo `supabase.sql` y tocá **Run**.
3. **Project Settings → API**: copiá `Project URL` y la clave `anon public`.
4. (Opcional, recomendado para uso personal) **Authentication → Providers → Email**: desactivá "Confirm email" para entrar sin confirmar por mail.

## 2. Configurar la app
Abrí `config.js` y reemplazá `SUPABASE_URL` y `SUPABASE_ANON_KEY` con lo que copiaste.
(La anon key es pública por diseño; la seguridad la dan las reglas RLS del SQL. Nunca uses la `service_role`.)

## 3. GitHub
1. Creá un repositorio nuevo en https://github.com/new (privado está bien).
2. **Add file → Upload files**, subí TODO el contenido de esta carpeta (index.html, config.js, manifest, íconos, supabase.sql, README) y hacé **Commit**.

## 4. Vercel
1. https://vercel.com → **Add New → Project** → importá el repo de GitHub.
2. Framework Preset: **Other**. Sin comando de build ni carpeta de salida. **Deploy**.
3. Si dejaste activada la confirmación por mail: en Supabase → **Authentication → URL Configuration**, poné tu URL de Vercel en **Site URL**.

## 5. Primer uso
1. Abrí tu URL de Vercel, tocá **Crear cuenta** y entrá.
2. Progreso → pegá tu respaldo en el cuadro → **Restaurar** (dos toques).
3. Agregala a la pantalla de inicio desde el navegador.

## Cómo te protege de perder datos
- Todo se guarda en Supabase (tu cuenta) y también en el celular.
- Supabase guarda además una copia diaria automática en la tabla `gym_data_history` (Table Editor).
- Las actualizaciones de la app (cambios en GitHub) no tocan tus datos.
