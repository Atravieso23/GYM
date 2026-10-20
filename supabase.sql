-- Pegar y ejecutar en Supabase → SQL Editor → New query → Run
-- Sin login: tu "código secreto" (GYM_CODE en config.js) identifica tus datos.

create table if not exists public.gym_store (
  code text primary key check (length(code) >= 16),
  data jsonb not null default '{"sessions":[]}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.gym_store enable row level security;

create table if not exists public.gym_store_history (
  id bigint generated always as identity primary key,
  code text not null,
  data jsonb not null,
  saved_at timestamptz not null default now()
);
alter table public.gym_store_history enable row level security;
-- (sin políticas: nadie puede leer las tablas directo; solo las funciones de abajo)

create or replace function public.gym_get(p_code text) returns jsonb
language sql security definer set search_path = public as $$
  select data from public.gym_store where code = p_code
$$;

create or replace function public.gym_put(p_code text, p_data jsonb) returns void
language plpgsql security definer set search_path = public as $$
begin
  if length(p_code) < 16 then raise exception 'codigo invalido'; end if;
  if exists (select 1 from public.gym_store where code = p_code) then
    -- copia de seguridad automática: máximo 1 por día
    if not exists (select 1 from public.gym_store_history h where h.code = p_code and h.saved_at > now() - interval '1 day') then
      insert into public.gym_store_history (code, data) select code, data from public.gym_store where code = p_code;
    end if;
    update public.gym_store set data = p_data, updated_at = now() where code = p_code;
  else
    insert into public.gym_store (code, data) values (p_code, p_data);
  end if;
end $$;

revoke all on function public.gym_get(text) from public;
revoke all on function public.gym_put(text, jsonb) from public;
grant execute on function public.gym_get(text) to anon, authenticated;
grant execute on function public.gym_put(text, jsonb) to anon, authenticated;
