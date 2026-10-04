-- Delinstag: Datenbank einrichten
-- Im Supabase-Dashboard: SQL Editor -> "New query" -> alles einfügen -> die zwei E-Mail-Adressen unten eintragen -> "Run".
-- Das Skript kann gefahrlos mehrmals ausgeführt werden.

-- 1) Wer darf rein? Genau zwei Adressen, je mit Rolle.
create table if not exists public.allowed_users (
  email text primary key,
  who   text not null check (who in ('linus', 'lisa'))
);
alter table public.allowed_users enable row level security;   -- keine Policy: niemand liest die Liste direkt

insert into public.allowed_users (email, who) values
  (lower('DEINE-EMAIL@example.com'),  'linus'),   -- <- Linus' Adresse eintragen
  (lower('DELISAS-EMAIL@example.com'), 'lisa')    -- <- Delisas Adresse eintragen
on conflict (email) do update set who = excluded.who;

-- Liefert 'linus' / 'lisa' für das angemeldete Konto, sonst null.
-- Zählt nur, wenn die E-Mail-Adresse bestätigt ist.
create or replace function public.whoami() returns text
language sql stable security definer set search_path = public as $$
  select a.who
  from public.allowed_users a
  join auth.users u on u.id = auth.uid()
  where a.email = lower(u.email) and u.email_confirmed_at is not null
$$;
revoke all on function public.whoami() from public, anon;
grant execute on function public.whoami() to authenticated;

-- 2) Ideen und Archiv
create table if not exists public.activities (
  id         uuid primary key default gen_random_uuid(),
  title      text not null check (char_length(title) between 1 and 120),
  owner      text not null check (owner in ('linus', 'lisa')),
  created_at timestamptz not null default now(),
  done       boolean not null default false,
  done_at    timestamptz,
  turn_of    text check (turn_of in ('linus', 'lisa'))
);

-- 3) Wer ist dran (genau eine Zeile)
create table if not exists public.state (
  id         int primary key default 1 check (id = 1),
  next       text check (next in ('linus', 'lisa')),
  changed_at timestamptz not null default now()
);

-- 4) Zugriff: nur Linus & Delisa, sonst niemand
alter table public.activities enable row level security;
alter table public.state      enable row level security;

drop policy if exists "nur wir zwei" on public.activities;
create policy "nur wir zwei" on public.activities
  for all to authenticated using (public.whoami() is not null) with check (public.whoami() is not null);

drop policy if exists "nur wir zwei" on public.state;
create policy "nur wir zwei" on public.state
  for all to authenticated using (public.whoami() is not null) with check (public.whoami() is not null);

revoke all on public.activities, public.state from anon;

-- 5) Live-Updates: Änderungen erscheinen sofort auf dem anderen Handy
do $$ begin
  begin alter publication supabase_realtime add table public.activities; exception when duplicate_object then null; end;
  begin alter publication supabase_realtime add table public.state;      exception when duplicate_object then null; end;
end $$;
