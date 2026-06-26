-- Watari personal assistant — Supabase schema
-- Run once in the Supabase SQL editor for project nbjgwqytwkkuarxlkmnj
-- Composite natural PKs: (user_id, id) — no uuid id column (Colosseum rule)

create table if not exists wat_tasks (
  user_id text not null,
  id      text not null,
  title   text not null default '',
  detail  text default '',
  proj    text default '',
  status  text default 'active',
  priority text default 'med',
  primary key (user_id, id)
);

create table if not exists wat_foods (
  user_id   text not null,
  id        text not null,
  name      text not null default '',
  qty       int  default 1,
  unit      text default 'pcs',
  who       text default 'both',
  threshold int  default 1,
  primary key (user_id, id)
);

create table if not exists wat_clothes (
  user_id text not null,
  id      text not null,
  name    text not null default '',
  cat     text default 'misc',
  clean   int  default 1,
  worn    int  default 0,
  laundry int  default 0,
  primary key (user_id, id)
);

create table if not exists wat_laundry (
  user_id text    not null,
  id      text    not null,
  date    text    not null,
  note    text    default '',
  done    boolean default false,
  primary key (user_id, id)
);

create table if not exists wat_blocks (
  user_id text not null,
  id      text not null,
  day     int  default 0,
  time    text default '',
  text    text default '',
  primary key (user_id, id)
);

create table if not exists wat_events (
  user_id text not null,
  id      text not null,
  date    text not null,
  text    text default '',
  primary key (user_id, id)
);

create table if not exists wat_income (
  user_id text    not null,
  id      text    not null,
  name    text    default '',
  amt     numeric default 0,
  note    text    default '',
  primary key (user_id, id)
);

create table if not exists wat_expenses (
  user_id text    not null,
  id      text    not null,
  name    text    default '',
  amt     numeric default 0,
  primary key (user_id, id)
);

create table if not exists wat_fingoals (
  user_id text    not null,
  id      text    not null,
  name    text    default '',
  target  numeric default 0,
  saved   numeric default 0,
  primary key (user_id, id)
);

-- Disable RLS and grant explicit permissions (Colosseum-confirmed pattern)
alter table wat_tasks    disable row level security;
alter table wat_foods    disable row level security;
alter table wat_clothes  disable row level security;
alter table wat_laundry  disable row level security;
alter table wat_blocks   disable row level security;
alter table wat_events   disable row level security;
alter table wat_income   disable row level security;
alter table wat_expenses disable row level security;
alter table wat_fingoals disable row level security;

grant select, insert, update, delete on wat_tasks    to anon, authenticated;
grant select, insert, update, delete on wat_foods    to anon, authenticated;
grant select, insert, update, delete on wat_clothes  to anon, authenticated;
grant select, insert, update, delete on wat_laundry  to anon, authenticated;
grant select, insert, update, delete on wat_blocks   to anon, authenticated;
grant select, insert, update, delete on wat_events   to anon, authenticated;
grant select, insert, update, delete on wat_income   to anon, authenticated;
grant select, insert, update, delete on wat_expenses to anon, authenticated;
grant select, insert, update, delete on wat_fingoals to anon, authenticated;
