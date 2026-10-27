-- AulaEval: esquema mínimo para sincronización de datos por docente
-- Ejecuta este script en Supabase > SQL Editor.
-- La tabla almacena el espacio de trabajo de cada usuario autenticado.
create table if not exists public.teacher_workspaces (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{"evaluations":[],"rubrics":[]}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.teacher_workspaces enable row level security;

drop policy if exists "Teachers can read own workspace" on public.teacher_workspaces;
create policy "Teachers can read own workspace"
on public.teacher_workspaces for select
to authenticated
using (auth.uid() = user_id);

drop policy if exists "Teachers can insert own workspace" on public.teacher_workspaces;
create policy "Teachers can insert own workspace"
on public.teacher_workspaces for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Teachers can update own workspace" on public.teacher_workspaces;
create policy "Teachers can update own workspace"
on public.teacher_workspaces for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

-- Recomendado: en Authentication > Providers, habilitar Email.
-- Crear el usuario docente desde Supabase Authentication antes de iniciar sesión.
-- Nunca incluir la clave service_role en el navegador.
