-- Watari — add Sleep, ADHD, and Weight tables
-- Run in Supabase SQL editor for project ibgkayhwbjkeiuphkewg

create table if not exists wat_sleep (
  user_id text not null,
  id      text not null,
  date    text not null,
  bed     text default '',
  wake    text default '',
  quality int  default 3,
  note    text default '',
  primary key (user_id, id)
);

create table if not exists wat_meds (
  user_id text    not null,
  id      text    not null,
  date    text    not null,
  time    text    default '',
  med     text    default '',
  taken   boolean default false,
  primary key (user_id, id)
);

create table if not exists wat_wins (
  user_id text not null,
  id      text not null,
  date    text not null,
  text    text default '',
  primary key (user_id, id)
);

create table if not exists wat_weight (
  user_id text    not null,
  id      text    not null,
  date    text    not null,
  kg      numeric default 0,
  note    text    default '',
  primary key (user_id, id)
);

alter table wat_sleep   disable row level security;
alter table wat_meds    disable row level security;
alter table wat_wins    disable row level security;
alter table wat_weight  disable row level security;

grant select, insert, update, delete on wat_sleep   to anon, authenticated;
grant select, insert, update, delete on wat_meds    to anon, authenticated;
grant select, insert, update, delete on wat_wins    to anon, authenticated;
grant select, insert, update, delete on wat_weight  to anon, authenticated;
