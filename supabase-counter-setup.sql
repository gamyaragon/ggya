create table if not exists public.calculator_metrics (
  id boolean primary key default true check (id = true),
  visitor_count bigint not null default 0,
  calculation_count bigint not null default 0
);

insert into public.calculator_metrics (id) values (true) on conflict (id) do nothing;

create table if not exists public.calculator_visitors (
  visitor_id text primary key,
  first_seen_at timestamptz not null default now()
);

alter table public.calculator_metrics enable row level security;
alter table public.calculator_visitors enable row level security;
revoke all on public.calculator_metrics from anon, authenticated;
revoke all on public.calculator_visitors from anon, authenticated;

create or replace function public.record_calculator_visit(p_visitor_id text)
returns void language plpgsql security definer set search_path = public as $$
declare inserted_rows integer;
begin
  if p_visitor_id is null or length(p_visitor_id) < 8 or length(p_visitor_id) > 100 then raise exception 'Invalid visitor identifier'; end if;
  insert into public.calculator_visitors (visitor_id) values (p_visitor_id) on conflict (visitor_id) do nothing;
  get diagnostics inserted_rows = row_count;
  if inserted_rows = 1 then update public.calculator_metrics set visitor_count = visitor_count + 1 where id = true; end if;
end; $$;

create or replace function public.record_calculator_calculation()
returns void language sql security definer set search_path = public as $$
  update public.calculator_metrics set calculation_count = calculation_count + 1 where id = true;
$$;

create or replace function public.get_calculator_metrics()
returns table (visitor_count bigint, calculation_count bigint)
language sql stable security definer set search_path = public as $$
  select m.visitor_count, m.calculation_count from public.calculator_metrics m where m.id = true;
$$;

revoke all on function public.record_calculator_visit(text) from public;
revoke all on function public.record_calculator_calculation() from public;
revoke all on function public.get_calculator_metrics() from public;
grant execute on function public.record_calculator_visit(text) to anon, authenticated;
grant execute on function public.record_calculator_calculation() to anon, authenticated;
grant execute on function public.get_calculator_metrics() to anon, authenticated;
