-- Pegar y ejecutar en Supabase → SQL Editor → New query → Run

create table if not exists public.gym_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{"sessions":[]}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.gym_data enable row level security;

create policy "gym_data select propio" on public.gym_data for select using (auth.uid() = user_id);
create policy "gym_data insert propio" on public.gym_data for insert with check (auth.uid() = user_id);
create policy "gym_data update propio" on public.gym_data for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "gym_data delete propio" on public.gym_data for delete using (auth.uid() = user_id);

-- Copia de seguridad automática: guarda una foto de tus datos como máximo 1 vez por día
create table if not exists public.gym_data_history (
  id bigint generated always as identity primary key,
  user_id uuid not null,
  data jsonb not null,
  saved_at timestamptz not null default now()
);

alter table public.gym_data_history enable row level security;
create policy "gym_history select propio" on public.gym_data_history for select using (auth.uid() = user_id);

create or replace function public.gym_snapshot() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if not exists (
    select 1 from public.gym_data_history h
    where h.user_id = old.user_id and h.saved_at > now() - interval '1 day'
  ) then
    insert into public.gym_data_history (user_id, data) values (old.user_id, old.data);
  end if;
  return new;
end $$;

drop trigger if exists gym_snapshot_trg on public.gym_data;
create trigger gym_snapshot_trg before update on public.gym_data
for each row execute function public.gym_snapshot();
