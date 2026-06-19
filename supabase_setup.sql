-- ElectroControl Don Corriente v25 - Supabase sin login
-- Ejecutar en Supabase > SQL Editor > New query > Run

create table if not exists public.electrocontrol_state (
  id text primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.electrocontrol_state enable row level security;

drop policy if exists "electrocontrol_state_select_public" on public.electrocontrol_state;
drop policy if exists "electrocontrol_state_insert_public" on public.electrocontrol_state;
drop policy if exists "electrocontrol_state_update_public" on public.electrocontrol_state;

create policy "electrocontrol_state_select_public"
on public.electrocontrol_state for select
to anon, authenticated
using (true);

create policy "electrocontrol_state_insert_public"
on public.electrocontrol_state for insert
to anon, authenticated
with check (true);

create policy "electrocontrol_state_update_public"
on public.electrocontrol_state for update
to anon, authenticated
using (true)
with check (true);

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end; $$;

drop trigger if exists trg_electrocontrol_state_updated_at on public.electrocontrol_state;
create trigger trg_electrocontrol_state_updated_at
before update on public.electrocontrol_state
for each row execute function public.set_updated_at();

insert into public.electrocontrol_state (id, data)
values ('main', '{}'::jsonb)
on conflict (id) do nothing;
